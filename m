Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8349314A6C
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413080; cv=none; b=iIgg5h0+Ab0PaNM5vTVaIPNSf4Dv7EDem/QsQoB77QRmBuPg/KXloAhsISVaWg0+5yTqitj/4SnASOJFK+hH0MPbt8sZ7sO4PkPOuWD3+WaKY2S2iWw2gjzMmHzhVS9McwO6iaT/sWphuzPsjQ986OAyTlCop3AiJzzQMHHKVUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413080; c=relaxed/simple;
	bh=5Op8jUxrM68SnRTHywlf+uxBAJ0C7zdWT0Lz7etUQp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElYXO1iOh0xnGTgZrc5joJGkv5LF3zV/GRsZGd63QwOACmRd9V4t3Jq3gVTWEfww3T2XYhwBlrho8Hw/s7x3UOEQ52zfSKl5H5NalKPURynYrV5KAFKb/EXQ/P1mtDmkN80iz9mLzZFaMUYdm9uvMxThNvq4bY1a3xZANs7KzrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rqz7LlmG; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rqz7LlmG"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4drtvp20tFzllCWw;
	Wed, 14 Jan 2026 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768413076; x=1771005077; bh=W98VH
	FAOUZAydof3G1anutp88EF989WMu5PiZ+9u5T4=; b=rqz7LlmGffJWjhgx9afT7
	OIL5SLwwGi2qrFlx1TlywhKw/xQQXOo/ppq9HulC9iKmWGD5LLEH66fvQTnNG60S
	tGnTFWltTEqa/yOV9r2MnC8ICpyBMbxQuLs+MbOlAdaGbA73/WKAIVUvS/OxEF5m
	wiy9cVw586XhEdRrkpI9nMsf/ky7H9bCZf6HAYGMSK7XulEsuiQsGXhpyVYcp8wZ
	1TJnY1B4LefgAiy/Z7oW5uvkAn6EDfikE2tpr//PVVGawgfFCt7vcrrZHsWfpTdC
	oFJ5yHlNLVNSmBJfWEdTvWePit7LQHcZiTCT9JnyPHcI3BPmdoMxPYeUV62OXfBd
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9MXoApwNpWLO; Wed, 14 Jan 2026 17:51:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4drtvl07VbzllCWt;
	Wed, 14 Jan 2026 17:51:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 5/5] scsi: sd: Do not split error messages
Date: Wed, 14 Jan 2026 09:50:53 -0800
Message-ID: <20260114175054.4118163-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260114175054.4118163-1-bvanassche@acm.org>
References: <20260114175054.4118163-1-bvanassche@acm.org>
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

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 55 +++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1dae8a02c446..d76996d6cbc9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1682,9 +1682,10 @@ static int sd_ioctl(struct block_device *bdev, blk=
_mode_t mode,
 	struct scsi_device *sdp =3D sdkp->device;
 	void __user *p =3D (void __user *)arg;
 	int error;
-   =20
-	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=3D%s, "
-				    "cmd=3D0x%x\n", disk->disk_name, cmd));
+
+	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp,
+				    "sd_ioctl: disk=3D%s, cmd=3D0x%x\n",
+				    disk->disk_name, cmd));
=20
 	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
 		return -ENOIOCTLCMD;
@@ -2593,8 +2594,8 @@ static int sd_read_protection_type(struct scsi_disk=
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
@@ -2871,8 +2872,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct que=
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
@@ -2898,17 +2899,17 @@ sd_read_capacity(struct scsi_disk *sdkp, struct q=
ueue_limits *lim,
 	 */
 	if (sdp->fix_capacity ||
 	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
-		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
-				"from its reported value: %llu\n",
-				(unsigned long long) sdkp->capacity);
+		sd_printk(KERN_INFO, sdkp,
+			  "Adjusting the sector count from its reported value: %llu\n",
+			  (unsigned long long) sdkp->capacity);
 		--sdkp->capacity;
 	}
=20
 got_data:
 	if (sector_size =3D=3D 0) {
 		sector_size =3D 512;
-		sd_printk(KERN_NOTICE, sdkp, "Sector size 0 reported, "
-			  "assuming 512.\n");
+		sd_printk(KERN_NOTICE, sdkp,
+			  "Sector size 0 reported, assuming 512.\n");
 	}
=20
 	if (sector_size !=3D 512 &&
@@ -3113,8 +3114,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3137,8 +3139,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3153,8 +3154,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3617,8 +3617,7 @@ static bool sd_validate_min_xfer_size(struct scsi_d=
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
@@ -3648,41 +3647,35 @@ static bool sd_validate_opt_xfer_size(struct scsi=
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
