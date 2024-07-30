Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A26238B
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 21:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722373295; cv=none; b=UIsMBm2hfyzuhc1QClu3RqYsgK5J1fPmHwIEA9PaDC0Cl30Vpq57cQRaBYIvZ3aebjfCMIH4R9yK19Db15IFG8iQF7osLqoBk15CcRsW7Tm4QoFiW2T6p15vaERtMr+mVF0u/frZF2V78uoA1L961dKzdmoyinlXhgau9HUsu60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722373295; c=relaxed/simple;
	bh=DHTfTxuBDTKrML70ZzDW8kEyRl/ZhNYbPQpcEpT1GnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPOBhbL1k11msMCTrENKIJTzHWOAVz4z/rCy3iXRS43ma42CgLYqEvU0qUNTR98PZd3kEZZjMw8nuaC5liaWATVvZVG8q+uw2SZ7rAXi/Nvk5mTYzsnXOQ+DikwSnow2ZDiE1Qy2BIsUaVxYgl2WBI0i2cxSMDrToa1LW1qWHTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LHB4aSBV; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LHB4aSBV"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WYSML0w7nz6CmM6L;
	Tue, 30 Jul 2024 21:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722373286; x=1724965287; bh=986xW
	wd3dVG9NJPb+VcWZcQ9B0JA4Q5YqwyiSpQHvi4=; b=LHB4aSBVj1CAPN56FyY+K
	DMzakG2ydXL6NKLMq0Q2kPHMBcKt3LPtnGaa3zgQcBnzjrGRAmsjHU9ELJXt1yWI
	Gbig5ndoMG3Bu3dutUnNMjdbvBCVgrfd30SOt5FhAnJQae6Fky/IiyzOGtt3Mjj2
	q2Nm4VxdXkeV4CTCdx4nWzJ7pjW1ksqgeOIoWc4b95ABB3LcFuAIZMq0yLhZM7QA
	4VLRJ5fxNSqaOfbABfaET7VAfLcKjM4bochnSM9bSXygj3LVVcxkBPVXa6Td8Dx1
	16V+WB5ToOi6i4RvrL0+Z7xhp22Qf9uH0N76ZyGCpZk110dxv5zctsUBgf/aLij5
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0fs65KoK2-rk; Tue, 30 Jul 2024 21:01:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WYSM653j6z6CmM6d;
	Tue, 30 Jul 2024 21:01:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 6/6] scsi: sd: Do not split error messages
Date: Tue, 30 Jul 2024 14:00:41 -0700
Message-ID: <20240730210042.266504-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
In-Reply-To: <20240730210042.266504-1-bvanassche@acm.org>
References: <20240730210042.266504-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make it easier to find these error messages with grep. This patch has bee=
n
created as follows:
* Delete all occurrences of the following regular expression:
  "[[:blank:]]*\\*\n[[:blank:]]*"
* Split long lines manually where necessary.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 54 ++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f4df58f2bbc..304da82fea4f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1651,8 +1651,9 @@ static int sd_ioctl(struct block_device *bdev, blk_=
mode_t mode,
 	void __user *p =3D (void __user *)arg;
 	int error;
    =20
-	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=3D%s, "
-				    "cmd=3D0x%x\n", disk->disk_name, cmd));
+	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp,
+				    "sd_ioctl: disk=3D%s, cmd=3D0x%x\n",
+				    disk->disk_name, cmd));
=20
 	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
 		return -ENOIOCTLCMD;
@@ -2549,8 +2550,8 @@ static int sd_read_protection_type(struct scsi_disk=
 *sdkp, unsigned char *buffer
 	type =3D ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 =3D Type 1 */
=20
 	if (type > T10_PI_TYPE3_PROTECTION) {
-		sd_printk(KERN_ERR, sdkp, "formatted with unsupported"	\
-			  " protection type %u. Disabling disk!\n",
+		sd_printk(KERN_ERR, sdkp,
+			  "formatted with unsupported protection type %u. Disabling disk!\n",
 			  type);
 		sdkp->protection_type =3D 0;
 		return -ENODEV;
@@ -2829,8 +2830,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct que=
ue_limits *lim,
 		if ((sizeof(sdkp->capacity) > 4) &&
 		    (sdkp->capacity > 0xffffffffULL)) {
 			int old_sector_size =3D sector_size;
-			sd_printk(KERN_NOTICE, sdkp, "Very big device. "
-					"Trying to use READ CAPACITY(16).\n");
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Very big device. Trying to use READ CAPACITY(16).\n");
 			sector_size =3D read_capacity_16(sdkp, sdp, lim, buffer);
 			if (sector_size < 0) {
 				sd_printk(KERN_NOTICE, sdkp,
@@ -2856,8 +2857,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct que=
ue_limits *lim,
 	 */
 	if (sdp->fix_capacity ||
 	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
-		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
-				"from its reported value: %llu\n",
+		sd_printk(KERN_INFO, sdkp,
+				"Adjusting the sector count from its reported value: %llu\n",
 				(unsigned long long) sdkp->capacity);
 		--sdkp->capacity;
 	}
@@ -2865,8 +2866,7 @@ sd_read_capacity(struct scsi_disk *sdkp, struct que=
ue_limits *lim,
 got_data:
 	if (sector_size =3D=3D 0) {
 		sector_size =3D 512;
-		sd_printk(KERN_NOTICE, sdkp, "Sector size 0 reported, "
-			  "assuming 512.\n");
+		sd_printk(KERN_NOTICE, sdkp, "Sector size 0 reported, assuming 512.\n"=
);
 	}
=20
 	if (sector_size !=3D 512 &&
@@ -3071,8 +3071,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
 char *buffer)
 	if (len < 3)
 		goto bad_sense;
 	else if (len > SD_BUF_SIZE) {
-		sd_first_printk(KERN_NOTICE, sdkp, "Truncating mode parameter "
-			  "data from %d to %d bytes\n", len, SD_BUF_SIZE);
+		sd_first_printk(KERN_NOTICE, sdkp,
+				"Truncating mode parameter data from %d to %d bytes\n",
+				len, SD_BUF_SIZE);
 		len =3D SD_BUF_SIZE;
 	}
 	if (modepage =3D=3D 0x3F && sdp->use_192_bytes_for_3f)
@@ -3095,8 +3096,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
 char *buffer)
 				 */
 				if (len - offset <=3D 2) {
 					sd_first_printk(KERN_ERR, sdkp,
-						"Incomplete mode parameter "
-							"data\n");
+						"Incomplete mode parameter data\n");
 					goto defaults;
 				} else {
 					modepage =3D page_code;
@@ -3111,8 +3111,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
 char *buffer)
 					offset +=3D 2 + buffer[offset+1];
 				else {
 					sd_first_printk(KERN_ERR, sdkp,
-							"Incomplete mode "
-							"parameter data\n");
+							"Incomplete mode parameter data\n");
 					goto defaults;
 				}
 			}
@@ -3579,8 +3578,7 @@ static bool sd_validate_min_xfer_size(struct scsi_d=
isk *sdkp)
=20
 	if (min_xfer_bytes & (sdkp->physical_block_size - 1)) {
 		sd_first_printk(KERN_WARNING, sdkp,
-				"Preferred minimum I/O size %u bytes not a " \
-				"multiple of physical block size (%u bytes)\n",
+				"Preferred minimum I/O size %u bytes not a multiple of physical bloc=
k size (%u bytes)\n",
 				min_xfer_bytes, sdkp->physical_block_size);
 		sdkp->min_xfer_blocks =3D 0;
 		return false;
@@ -3610,41 +3608,35 @@ static bool sd_validate_opt_xfer_size(struct scsi=
_disk *sdkp,
=20
 	if (sdkp->opt_xfer_blocks > dev_max) {
 		sd_first_printk(KERN_WARNING, sdkp,
-				"Optimal transfer size %u logical blocks " \
-				"> dev_max (%u logical blocks)\n",
+				"Optimal transfer size %u logical blocks > dev_max (%u logical block=
s)\n",
 				sdkp->opt_xfer_blocks, dev_max);
 		return false;
 	}
=20
 	if (sdkp->opt_xfer_blocks > SD_DEF_XFER_BLOCKS) {
 		sd_first_printk(KERN_WARNING, sdkp,
-				"Optimal transfer size %u logical blocks " \
-				"> sd driver limit (%u logical blocks)\n",
+				"Optimal transfer size %u logical blocks > sd driver limit (%u logic=
al blocks)\n",
 				sdkp->opt_xfer_blocks, SD_DEF_XFER_BLOCKS);
 		return false;
 	}
=20
 	if (opt_xfer_bytes < PAGE_SIZE) {
 		sd_first_printk(KERN_WARNING, sdkp,
-				"Optimal transfer size %u bytes < " \
-				"PAGE_SIZE (%u bytes)\n",
+				"Optimal transfer size %u bytes < PAGE_SIZE (%u bytes)\n",
 				opt_xfer_bytes, (unsigned int)PAGE_SIZE);
 		return false;
 	}
=20
 	if (min_xfer_bytes && opt_xfer_bytes % min_xfer_bytes) {
 		sd_first_printk(KERN_WARNING, sdkp,
-				"Optimal transfer size %u bytes not a " \
-				"multiple of preferred minimum block " \
-				"size (%u bytes)\n",
+				"Optimal transfer size %u bytes not a multiple of preferred minimum =
block size (%u bytes)\n",
 				opt_xfer_bytes, min_xfer_bytes);
 		return false;
 	}
=20
 	if (opt_xfer_bytes & (sdkp->physical_block_size - 1)) {
 		sd_first_printk(KERN_WARNING, sdkp,
-				"Optimal transfer size %u bytes not a " \
-				"multiple of physical block size (%u bytes)\n",
+				"Optimal transfer size %u bytes not a multiple of physical block siz=
e (%u bytes)\n",
 				opt_xfer_bytes, sdkp->physical_block_size);
 		return false;
 	}
@@ -3706,8 +3698,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
=20
 	buffer =3D kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer) {
-		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
-			  "allocation failure.\n");
+		sd_printk(KERN_WARNING, sdkp,
+			  "sd_revalidate_disk: Memory allocation failure.\n");
 		goto out;
 	}
=20
