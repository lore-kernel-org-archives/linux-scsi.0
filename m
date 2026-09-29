Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0A3BB124
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724218; cv=none; b=nTBbLWlXi8aSxgWd4fzGlFdMB2aOwcTyURnsTYPSZQGd4kr8WY6G+z/zuyx1regXQXCNSFb5Ns36rY6vlrf4GatIx9lun0g2/yZWkulxCr1aciQv7G0GHmA3V9BsCvvOj04k5a0PENoQ2v5wrUhUjbbMWwuKF+9+W6gLjQFC/Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724218; c=relaxed/simple;
	bh=Ma4e+FHlUV566UHJNT2VP/M5CSJ4kbckJKh3V112XHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfOnsDiZT493NFF1hDbRkz2Kf8yZyr/ncN3jPHBEp0Vo53nFJvqANf5nAhVbljE3es3luKyAISOPKceilqw5vyxKQDdhTR3hcMGknuJvGipWL50sS/EDV/C62T8SreiT20pDNlkqxUxpj0Ex6jU4FL4zzhMze0tJ/6+TmydOj/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=quSCFLi4; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="quSCFLi4"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hvZ4917fXz1XM5kD;
	Tue, 29 Sep 2026 23:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790724211; x=1793316212; bh=9rqZx
	k1lzz3DoW0FBf2UI5w08/k8GPllSa2rkYVtYy4=; b=quSCFLi4udDa4JdO63SHe
	Ay55pDqE26wNYEFdr2qfh3Qgc/tee/x8B06FZGXtbkRbObWJ7VdNwzWRlNORonqD
	jNTRyoySHi/2mM0Fz5RsOvUnMBAEdIkCJ9nk25ouBcluULrogM3RCx/Cx5MLWxk9
	2bOabml4fmM1gUGUsa6pbLWe60lYO0eCKtBK+wTpZs5cD66XZrYIopquqa3iKaaW
	SD3qRP8NOAMff7pQP4lSM3ytNPWNNmsMM06e8BCLAATZB2A4tql9V+E0XgjCweW+
	58zOrO5/UPlTE67WIVl2YSWPDcVDkeCc2QQG4Ex/N9oeymikmDJ0QZhAY8xVB9dL
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OG-irGw5Jg7T; Tue, 29 Sep 2026 23:23:31 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hvZ4217f9z1XM4Sx;
	Tue, 29 Sep 2026 23:23:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v3 5/7] scsi: scsi_debug: Split resp_write_dt0()
Date: Tue, 29 Sep 2026 16:23:01 -0700
Message-ID: <9496fa3e76e38a9bdb4c670538e563298bf281a3.1790723966.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790723966.git.bvanassche@acm.org>
References: <cover.1790723966.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for enabling lock context analysis by eliminating conditional
locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 143 ++++++++++++++++++++++++--------------
 1 file changed, 89 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8c47e6d48b9b..44840ba0c5b5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5060,6 +5060,86 @@ static int corrupt_lbas(struct sdebug_dev_info *de=
vip, u64 lba, u32 num,
 	return error;
 }
=20
+/*
+ * Returns the number of bytes transferred, or -1 with *scsi_status set =
to a
+ * SCSI status code on failure.
+ */
+static int __resp_write_dt0_dix(struct scsi_cmnd *scp,
+				struct sdebug_dev_info *devip,
+				struct sdeb_store_info *sip, u64 lba, u32 num,
+				u32 ei_lba, u8 group, int *scsi_status)
+{
+	switch (prot_verify_write(scp, lba, num, ei_lba)) {
+	case 1: /* Guard tag error */
+		if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+			*scsi_status =3D illegal_condition_result;
+			return -1;
+		}
+		if (scp->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT !=3D 3 */
+			mk_sense_buffer(scp, ABORTED_COMMAND,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+			*scsi_status =3D check_condition_result;
+			return -1;
+		}
+		break;
+	case 3: /* Reference tag error */
+		if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+				LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+			*scsi_status =3D illegal_condition_result;
+			return -1;
+		}
+		if (scp->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT !=3D 3 */
+			mk_sense_buffer(scp, ABORTED_COMMAND,
+				LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+			*scsi_status =3D check_condition_result;
+			return -1;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Returns the number of bytes transferred, or -1 with *scsi_status set =
to a
+ * SCSI status code on failure.
+ */
+static int __resp_write_dt0(struct scsi_cmnd *scp,
+			    struct sdebug_dev_info *devip,
+			    struct sdeb_store_info *sip, u64 lba, u32 num,
+			    u32 ei_lba, u8 group, int *scsi_status)
+{
+	int ret;
+
+	*scsi_status =3D check_device_access_params(scp, lba, num, true);
+	if (*scsi_status)
+		return -1;
+
+	/* DIX + T10 DIF */
+	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
+		ret =3D __resp_write_dt0_dix(scp, devip, sip, lba, num, ei_lba,
+					   group, scsi_status);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret =3D do_device_access(sip, scp, 0, lba, num, group, true, false);
+	if (ret < 0)
+		*scsi_status =3D DID_ERROR << 16;
+
+	if (unlikely(scsi_debug_lbp()))
+		map_region(sip, lba, num);
+
+	/* If ZBC zone then bump its write pointer */
+	if (sdebug_dev_is_zoned(devip))
+		zbc_inc_wp(devip, lba, num);
+
+	return ret;
+}
+
 static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info =
*devip)
 {
 	bool check_prot;
@@ -5070,7 +5150,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, st=
ruct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip =3D devip2sip(devip, true);
 	u8 *cmd =3D scp->cmnd;
-	bool meta_data_locked =3D false;
+	int scsi_status =3D DID_ERROR << 16;
=20
 	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
 		     atomic_read(&sdeb_inject_pending))) {
@@ -5137,63 +5217,18 @@ static int resp_write_dt0(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)
 	}
=20
 	if (sdebug_dev_is_zoned(devip) ||
-	    (sdebug_dix && scsi_prot_sg_count(scp)) ||
-	    scsi_debug_lbp())  {
+	    (sdebug_dix && scsi_prot_sg_count(scp)) || scsi_debug_lbp()) {
 		sdeb_meta_write_lock(sip);
-		meta_data_locked =3D true;
-	}
-
-	ret =3D check_device_access_params(scp, lba, num, true);
-	if (ret) {
-		if (meta_data_locked)
-			sdeb_meta_write_unlock(sip);
-		return ret;
-	}
-
-	/* DIX + T10 DIF */
-	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
-		switch (prot_verify_write(scp, lba, num, ei_lba)) {
-		case 1: /* Guard tag error */
-			if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
-				sdeb_meta_write_unlock(sip);
-				mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
-				return illegal_condition_result;
-			} else if (scp->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT !=3D 3 */
-				sdeb_meta_write_unlock(sip);
-				mk_sense_buffer(scp, ABORTED_COMMAND,
-					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
-				return check_condition_result;
-			}
-			break;
-		case 3: /* Reference tag error */
-			if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
-				sdeb_meta_write_unlock(sip);
-				mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
-				return illegal_condition_result;
-			} else if (scp->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT !=3D 3 */
-				sdeb_meta_write_unlock(sip);
-				mk_sense_buffer(scp, ABORTED_COMMAND,
-					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
-				return check_condition_result;
-			}
-			break;
-		}
-	}
-
-	ret =3D do_device_access(sip, scp, 0, lba, num, group, true, false);
-	if (unlikely(scsi_debug_lbp()))
-		map_region(sip, lba, num);
-
-	/* If ZBC zone then bump its write pointer */
-	if (sdebug_dev_is_zoned(devip))
-		zbc_inc_wp(devip, lba, num);
-	if (meta_data_locked)
+		ret =3D __resp_write_dt0(scp, devip, sip, lba, num, ei_lba, group,
+				       &scsi_status);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		ret =3D __resp_write_dt0(scp, devip, sip, lba, num, ei_lba, group,
+				       &scsi_status);
+	}
=20
 	if (unlikely(-1 =3D=3D ret))
-		return DID_ERROR << 16;
+		return scsi_status;
 	else if (unlikely(sdebug_verbose &&
 			  (ret < (num * sdebug_sector_size))))
 		sdev_printk(KERN_INFO, scp->device,
