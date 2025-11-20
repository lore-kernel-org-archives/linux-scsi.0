Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19DB26463A;
	Thu, 20 Nov 2025 12:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642077; cv=none; b=CncbBPapRFqOcV9de+28pICVBEYl2PYcAOUbksmQBwnUpFbTiDiUwWIKZoLLfXoBbPkhR6Kj/10anx88ZqE/4B+9b40Amw4vLHHob46/iYNE3Q7Gi+WOTbT8igQvNPyY8Z179Xpbwne5FyCiD2NVmodR5L8QIbj6BRzmwmOeb9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642077; c=relaxed/simple;
	bh=uASkiBThjg0+2aydI15+rppeNYNlJb+ZepyqZt3ACiI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RSZ99YFkYNevR0AKjbwhGx9jGpZQFsfIgZW66EXS2UwhDR1jbkW+ppxQUyLMYuUR1B5n2DGx4E6Pw9xYlctASdftWLMfnTliZ31bkc6WPn6/TbSU2FpjTVQSz+C2/SnaI3Ev9jkZYXAPItNLsZzIkkgbVViQNEMh1GgOSi2sQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: I9S4tjiGQ7WW3GG6Ca6ONQ==
X-CSE-MsgGUID: JD2+mL9rQqCt5e1vO6uGnA==
X-IronPort-AV: E=Sophos;i="6.20,213,1758556800"; 
   d="scan'208";a="158953641"
From: guhuinan <guhuinan@xiaomi.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum
	<oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<usb-storage@lists.one-eyed-alien.net>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Yu Chen <chenyu45@xiaomi.com>, Owen Gu
	<guhuinan@xiaomi.com>, Michal Pecio <michal.pecio@gmail.com>
Subject: [PATCH v4] usb: uas: fix urb unmapping issue when the uas device is remove during ongoing data transfer
Date: Thu, 20 Nov 2025 20:33:36 +0800
Message-ID: <20251120123336.3328-1-guhuinan@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ-MBX19.mioffice.cn (10.237.8.139) To BJ-MBX05.mioffice.cn
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
submitted URBs, when being unlinked to giveback, call
usb_hcd_unmap_urb_for_dma() in hcd.c, leading to exceptions during sg
unmapping operations since the sg data structure has already been freed.

This patch modifies the error condition check in the uas_submit_urbs()
function. When a UAS device is removed but one or more URBs have already
been successfully submitted to USB, it avoids immediately invoking
scsi_done() and save the cmnd to devinfo->cmnd array. If the successfully
submitted URBs is completed before devinfo->resetting being set, then
the scsi_done() function will be called within uas_try_complete() after
all pending URB operations are finalized. Otherwise, the scsi_done()
function will be called within uas_zap_pending(), which is executed after
usb_kill_anchored_urbs().

The error handling only takes effect when uas_queuecommand_lck() calls
uas_submit_urbs() and returns the error value -ENODEV . In this case,
the device is disconnected, and the flow proceeds to uas_disconnect(),
where uas_zap_pending() is invoked to call uas_try_complete().

Fixes: eb2a86ae8c54 ("USB: UAS: fix disconnect by unplugging a hub")
Cc: stable@vger.kernel.org
Signed-off-by: Yu Chen <chenyu45@xiaomi.com>
Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
---
v4: Add the fix tag, cc stable and acked-by tag
v3: Add some commit message.
v2: Upon uas_submit_urbs() returning -ENODEV despite successful URB
submission, the cmnd is added to the devinfo->cmnd array before
exiting uas_queuecommand_lck().
https://lore.kernel.org/linux-usb/20251015153157.11870-1-guhuinan@xiaomi.com/
v1: https://lore.kernel.org/linux-usb/20250930045309.21588-1-guhuinan@xiaomi.com/
---
---
 drivers/usb/storage/uas.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 03043d567fa1..02fe411567fa 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -698,6 +698,10 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
 	 * of queueing, no matter how fatal the error
 	 */
 	if (err == -ENODEV) {
+		if (cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
+				DATA_OUT_URB_INFLIGHT))
+			goto out;
+
 		set_host_byte(cmnd, DID_NO_CONNECT);
 		scsi_done(cmnd);
 		goto zombie;
@@ -711,6 +715,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
 		uas_add_work(cmnd);
 	}
 
+out:
 	devinfo->cmnd[idx] = cmnd;
 zombie:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
-- 
2.43.0

