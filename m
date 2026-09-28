Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603A136B91C
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580093; cv=none; b=AcZWvNzjq9OMnR+8PXjRjHSGPmM1aBwAcGWwAQJb9/7WMN4NIN+9Ln0eA8/5L2y4Lx2GJhe+l2bZRM0x5m5kHTXBUW8tnsMzLXq2HJPchcFtPCnCEE9Knk13e9hWojS1zqLgxr18HoOsb38ihQuxNadqE+EmKHJgtzhhAufFrqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580093; c=relaxed/simple;
	bh=2uva+ZRWCF9vYEkAj78UofEc72YBkamfAGSg+ba28zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWgv+jXt/NHY3aQDAIcNVtRv2qgyoWxgzYdQQIskEo/8byYe/W1DLTMOIizj931JQ3ItZvpsvz286jWN/ytjexothgiOD2CVQ5IpCLR8XwOHx4l+PEs6CB79SxGbdrXDxUhwt5AjlWVMG2w53JE/+0Wo3gSxpkyYI9Z8phsBu/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h8+AYdGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8+AYdGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8F81F000FF;
	Mon, 28 Sep 2026 07:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580092;
	bh=zs4zu3KfIR5+a1lfn5szah4cMfv6C50XI6MP4id/P4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8+AYdGquBMS1Rv+xZY9A4GFPnuLYX+UPauNk/4H0iP/lgg7RGJrH/qEEOg9euhmQ
	 d0hWPxZOlJF0cXTcMUhVfkOUeDHO+0l49aDVVYylufBBuGvibCRrm9lAIFamPjIHlA
	 yFST5smt6eLmm6Fi8PGyREC30DVBbCIrTI45aVJyqjADRGHKJhHgPWbXieWdSPtCVY
	 F6jsVemy/9nIgnhYO3Om7NJsc1xpe8MyqcKxwJoLtagGphhWGee7Ka+8JIV/G48PIb
	 bQ5MoM542qU+nn5wfIcSkiqhHj/5WIKJyRBuIhzXriZD0KX8iGiw+3uavTe2dkkP77
	 lkPyJk8uEnM0A==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 08/12] scsi: scsi_debug: Do not write a partial physical block to a zoned device
Date: Mon, 28 Sep 2026 09:21:11 +0200
Message-ID: <20260928072102.725566-22-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2895; i=cassel@kernel.org; h=from:subject; bh=2uva+ZRWCF9vYEkAj78UofEc72YBkamfAGSg+ba28zc=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iabnCUTvK/28h8cx/Gzf/+6myf7rW8y+RZg55ezlX TNho8LrjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExE3Y/hD+/P/zWtRXoSJtMe V3WlVpv3tS6dUcXxc4nej1+l2+qidjP8T97h7XXCf/Y6+/MPz6k8iT3oV3uCdVnh5bVzunnEJzx 6xA8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

do_device_access() copies one logical block at a time and stops at the
first short copy, so a data-out buffer smaller than the transfer length
of the command can leave part of a physical block written. An initiator
can arrange that with SG_IO.

That is acceptable everywhere but a sequential write required zone,
where ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, requires a write to end
on a physical block boundary.

For such a zone, stop at the last whole physical block that the buffer
holds. The bytes left over are not written, and are reported to the
initiator as part of the residual.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

issuing a sixteen logical block WRITE(16) through SG_IO with a buffer of
twelve blocks. To a sequential write required zone it now transfers
eight blocks, one whole physical block, and reports the remaining 2048
bytes as the residual; before this patch it transferred twelve. To a
conventional zone it still transfers all twelve and reports no residual.

With physblk_exp=0 an eight block write with a buffer of one block still
transfers one block, wherever it is addressed.
---
 drivers/scsi/scsi_debug.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b4583fe10ec5..dd7132e92c27 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4273,6 +4273,8 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 	u64 block;
 	enum dma_data_direction dir;
 	struct scsi_data_buffer *sdb = &scp->sdb;
+	struct scsi_device *sdp = scp->device;
+	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
 	u8 *fsp;
 	int i, total = 0;
 
@@ -4300,6 +4302,25 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 
 	fsp = sip->storep;
 
+	/*
+	 * A write to a sequential write required zone has to end on a physical
+	 * block boundary, so if the data-out buffer does not hold all of the
+	 * data that the command asks for, write up to the last whole physical
+	 * block that it does hold. What is left over is reported as part of
+	 * the residual.
+	 */
+	if (do_write && sdebug_dev_is_zoned(devip)) {
+		struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
+
+		if (zsp->z_type == ZBC_ZTYPE_SWR) {
+			u32 avail = (sdb->length - sg_skip)
+				>> ilog2(sdebug_sector_size);
+
+			if (avail < num)
+				num = round_down(avail, 1U << sdebug_physblk_exp);
+		}
+	}
+
 	block = do_div(lba, sdebug_store_sectors);
 
 	/* Only allow 1x atomic write or multiple non-atomic writes at any given time */
-- 
2.55.0

