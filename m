Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF402E1730
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 21:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765919268; cv=none; b=T77zfiC9MaoWZMlnlfFn1ERMKrdJii8w+63BUMImxtI3Wn5ppz+BMdLxzQw4I5ccFRHs/qPe1sTdOjHSsaOfk1x3Huz3CymQpDn81MH/SjcxlTg7rbzI33co4J+qim7B1QW9LDXSIS5P01LAnUT8d7RxUPgzfQED2nL1df04TTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765919268; c=relaxed/simple;
	bh=ZJmbUn4IffQhDs/jnVD245VCpfNstnA0In0/9JfH5V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgLEaCFYW43FS8I4rzC2KfAxYF1P3yfFldeYPvnkhO3UfWTlssp1RhlXZDOByyyKph1u6jOukSkLFosvyMJn3xMgmbYE3CeDPs2ISZX52mlirvr4HRBSpG9Q6juvX8A4A7LUY7D34lldSN5eCcX6g8WRsh6sFr4F6Y7fXG6LC88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pcWuh37h; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pcWuh37h"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dW8ds7352zmP6ZC;
	Tue, 16 Dec 2025 21:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765919264; x=1768511265; bh=1aTnF
	9i74R0urw0TRGz6cYnAv4Pl6TRyGCYX8J6Rd0I=; b=pcWuh37hdoYqvkpGiNXPa
	S16dwv6XBF44ht+MJEX2Z+J/LwFFzbqF1U97FZ6mXf+/Jqn/LoZynaz8NZhSng7A
	LYsi58HPjNNIo8dTmQS/QOcJkr8at/Jct4cxbVve1VdFmBjyla8bOTgrh2/iCkLx
	sWbfJ7bsw51ZjF+gI4MFInVjzpD9PiD3R9NVgH7USj/jAJMX47uNA1+ib76dEm4n
	uQQa+O90WdR9i1Vp2T6hLzL5tA0tPX+L/IS0HJtfr5pV9l6t/j9Yjb7UoES2zYqR
	gbLYrYTjkPkZ12JPibFaly4+qU8PZRN1zYE6aFK7R6xZiy4vy+Q4+kUcGMWNPKcQ
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O6mMuerehKtR; Tue, 16 Dec 2025 21:07:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dW8dq1jbczmP6Ym;
	Tue, 16 Dec 2025 21:07:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 5/5] scsi: sd: Do not split error messages
Date: Tue, 16 Dec 2025 13:07:17 -0800
Message-ID: <20251216210719.57256-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.305.g3fc767764a-goog
In-Reply-To: <20251216210719.57256-1-bvanassche@acm.org>
References: <20251216210719.57256-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 54 ++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f52b435bf398..7bb9e9cf8c00 100644
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
@@ -2583,8 +2584,8 @@ static int sd_read_protection_type(struct scsi_disk=
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
@@ -2861,8 +2862,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct que=
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
@@ -2888,17 +2889,16 @@ sd_read_capacity(struct scsi_disk *sdkp, struct q=
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
@@ -3103,8 +3103,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3127,8 +3128,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3143,8 +3143,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned=
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
@@ -3607,8 +3606,7 @@ static bool sd_validate_min_xfer_size(struct scsi_d=
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
@@ -3638,41 +3636,35 @@ static bool sd_validate_opt_xfer_size(struct scsi=
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
