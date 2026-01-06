Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16A33DEE5
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 19:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726496; cv=none; b=P0fs8yshNuRYWWU0Ba2WQtM5Dg9acAsXNIeFFAC6/NV7v3syL0chsrJzBw977KAmm1lDxXWpFuPsGGE2fa4xYdQV6UwBqBPdmGQnosFMdmAkBJr/thAC/CfODoRX9sSfMB7WdaU3gvc4OHFdtmVC6ofy1HOJ9jwdB6r/24vKyaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726496; c=relaxed/simple;
	bh=96Yk640I8yltJmi0ZcO/WisABwwFWAlQwkmNnYyyWhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXHo8uER2kt13U/+iqlitUo1qEYeocQ9Rs9Ptvohs3YM4d4k0k8aM+U7FfSXqm/YZVTWh6zUji7YsYomg969soOOuhdsy/WL0oB1aKLKs5IAen/jcnKhk7ULH8M77RaXi6UDjYF/6ZQF65s1Hxeamj60G6b5Uymy46LPirrXeEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u2crFICf; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u2crFICf"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dm10G21JWz1XScCW;
	Tue,  6 Jan 2026 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767726492; x=1770318493; bh=FHhZx
	prjugh7LoHVI0lhpVLObZE99W0J2Thgpd+kc4o=; b=u2crFICfqhb3hwUQPTOoX
	ovIeqL5tf7q4o9iLXlYGwJFtmNS1gTonhWrKiJNKE8SuP/7uruJz/7l5n0xMAk96
	81xoBTFthNDWWGiJsthZXQRASXQjEiHrFegDhDT4EzR0qf65qR+SjoA9oh57g4hX
	Xr5i0wVn9ozo+VxHrgfVYyiQi0VVB5fpiCQI0AFXreXPU+AkzDLxKA6Kkbgto2fW
	H7KNhBMmnYmz14YYcBHIeVDsxER7+op1ymG3AF0mn1KDGgwzJvUBOLDopnMgtSDN
	LZzeEbpKs50ZWbJzY4gIu108TuRYEQ82RfDbkQJf8dyfnv709x4GQO1O1TJl3s6M
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zjcs8KJtYZSm; Tue,  6 Jan 2026 19:08:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dm10B43gvz1XScCh;
	Tue,  6 Jan 2026 19:08:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 5/5] scsi: sd: Do not split error messages
Date: Tue,  6 Jan 2026 12:07:48 -0700
Message-ID: <20260106190749.2549070-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20260106190749.2549070-1-bvanassche@acm.org>
References: <20260106190749.2549070-1-bvanassche@acm.org>
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
 drivers/scsi/sd.c | 54 ++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95e1e6d5d5e2..3fa2d7a6c32f 100644
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
@@ -2898,17 +2899,16 @@ sd_read_capacity(struct scsi_disk *sdkp, struct q=
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
+		sd_printk(KERN_NOTICE, sdkp, "Sector size 0 reported, assuming 512.\n"=
);
 	}
=20
 	if (sector_size !=3D 512 &&
@@ -3113,8 +3113,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3137,8 +3138,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3153,8 +3153,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3617,8 +3616,7 @@ static bool sd_validate_min_xfer_size(struct scsi_d=
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
@@ -3648,41 +3646,35 @@ static bool sd_validate_opt_xfer_size(struct scsi=
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
