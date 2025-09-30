Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23E0E288DB;
	Tue, 30 Sep 2025 04:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759208075; cv=none; b=nA26UK3oinpWcuFTQ/za0xbnZFfGQubraRE9ZYl8RCS0/MdK5fikR9izmGywU1wdUSJp/VQBOrUNk4aAqTE/EfJILNqMrU+8ZnTuc2FJzGJuFtPQN4XHlPazIrAAmtf5L3PuQ0Kc6K/NCLUr3NJOkMQOcEEgwv1YnqRMQHHHYaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759208075; c=relaxed/simple;
	bh=Gw5ZjzJnceznZ0FnaMXKyoToW5xxSQMuBie2EAuTFMU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jtux+TTPfUZ2v/TVWdb6LZj9iYW/CyHOGsistntMcIsrB178os4KSAX9GbSUy7eot94VhrpJIEpbY68j8j1Eh8AdpreGdEDQOaS3lp0m12sOn2eGbkPQ1XwkPTlIX36G2gr7RZPY9j5Oo7qktxV+pKuRYXXhkTKJToPabT0q4E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: EVtpDxrPSqqcFC7xE6im6Q==
X-CSE-MsgGUID: SnU+0+RdRwuxkDHoijzSaQ==
X-IronPort-AV: E=Sophos;i="6.18,303,1751212800"; 
   d="scan'208";a="154003711"
From: guhuinan <guhuinan@xiaomi.com>
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<usb-storage@lists.one-eyed-alien.net>, <linux-kernel@vger.kernel.org>, "Yu
 Chen" <chenyu45@xiaomi.com>, Owen Gu <guhuinan@xiaomi.com>
Subject: [PATCH] fix urb unmapping issue when the uas device is remove during ongoing data transfer
Date: Tue, 30 Sep 2025 12:53:08 +0800
Message-ID: <20250930045309.21588-1-guhuinan@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bj-mbx11.mioffice.cn (10.237.8.131) To BJ-MBX05.mioffice.cn
 (10.237.8.125)

From: Owen Gu <guhuinan@xiaomi.com>

When a UAS device is unplugged during data transfer, there is
a probability of a system panic occurring. The root cause is
an access to an invalid memory address during URB callback handling.
Specifically, this happens when the dma_direct_unmap_sg() function
is called within the usb_hcd_unmap_urb_for_dma() interface, but the
sg->dma_address field is 0 and the sg data structure has already been
freed.

The SCSI driver sends transfer commands by invoking uas_queuecommand_lck()
in uas.c, using the uas_submit_urbs() function to submit requests to USB.
Within the uas_submit_urbs() implementation, three URBs (sense_urb,
data_urb, and cmd_urb) are sequentially submitted. Device removal may
occur at any point during uas_submit_urbs execution, which may result
in URB submission failure. However, some URBs might have been successfully
submitted before the failure, and uas_submit_urbs will return the -ENODEV
error code in this case. The current error handling directly calls
scsi_done(). In the SCSI driver, this eventually triggers scsi_complete()
to invoke scsi_end_request() for releasing the sgtable. The successfully
submitted URBs, when being completed (giveback), call
usb_hcd_unmap_urb_for_dma() in hcd.c, leading to exceptions during sg
unmapping operations since the sg data structure has already been freed.

This patch modifies the error condition check in the uas_submit_urbs()
function. When a UAS device is removed but one or more URBs have already
been successfully submitted to USB, it avoids immediately invoking
scsi_done(). Instead, it waits for the successfully submitted URBs to
complete , and then triggers the scsi_done() function call within
uas_try_complete() after all pending URB operations are finalized.

Signed-off-by: Yu Chen <chenyu45@xiaomi.com>
Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
---
 drivers/usb/storage/uas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 4ed0dc19afe0..6bfc7281f7ad 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -699,7 +699,9 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
 	 */
 	if (err == -ENODEV) {
 		set_host_byte(cmnd, DID_NO_CONNECT);
-		scsi_done(cmnd);
+		if (!(cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
+				DATA_OUT_URB_INFLIGHT)))
+			scsi_done(cmnd);
 		goto zombie;
 	}
 	if (err) {
-- 
2.43.0

