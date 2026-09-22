Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CD54F55D2
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119647; cv=none; b=nYlwIXNV1223wWcmsHtSLjWk7mT1PH9qa0SKVjVYRS/iEnL1TAUGnyPT/RBJ8qodQDUSQC5pRLDvY+tljUjnEvh47a7Nqkl23aALfwUTxdVaGImErn+avGxi1ayRKA+N/AoaqfnqVyAUDJ7QyJ09iFEIwux2DfRASvYnT3CuTQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119647; c=relaxed/simple;
	bh=iTzFEatv/9pxsQxKx9VKGQujRnQiKwQP1A28xeWjDrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0wPFTNU/+xXyiNjkWTdp5LJ8z1eWisIcotxHX1risNdzrVe0DOInCekjG9zyvze+ktGeXb3TMLY1v8UVaG+ULmKedSXUbwIXtsoteCw84eyOJAdwJk7lebGP+7+fX031+KEd8Fx+lAgWpzu4ott7GufmCktPGAQk4TV4vkBbzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OobkQ/dd; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OobkQ/dd"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqGTC5Fw0zlfvps;
	Tue, 22 Sep 2026 23:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790119610; x=1792711611; bh=YheGs
	NCgjxELUg633Yq+lwwnYbpenEOAk6IOlb3Ak+M=; b=OobkQ/dd2rNTOa0ZNcgV0
	SSrqs3iuY/cuYYxE/w3RDmGYrh/RdXOdhR9pmn6bQBxb5HJkJbm5qX0Cp7b0PlG3
	iYmgVZry/fxeL/4VCKeQSDRZZemoNH48UGCeds8JFkabEt82S/s0K8o+E0ZY5I44
	PcYNHin5yeIk5hUX7dKF+lRursesqPwOOoFbjrwMr3Xmke56PpweS2jswFCUOGbH
	uUiG+Oaqeb6moxRB+/c+nzPwR8bb+D8odxi/5hHYDdgBONslnGTyulFJG4Lhiyt4
	2FWoW+KziRRi1CvzkB/ASW/lQkCFlmb3wswHUrpR7ugtN2tdpqZLiiK9nTZqPRXr
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Mis-cA-2Sobp; Tue, 22 Sep 2026 23:26:50 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqGT52vPRzlfvpN;
	Tue, 22 Sep 2026 23:26:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5/7] scsi: scsi_debug: Split resp_write_dt0()
Date: Tue, 22 Sep 2026 16:26:25 -0700
Message-ID: <206aacd14ccbe8c5923d844cdc9f26ecbc229b04.1790119506.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <cover.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 107 ++++++++++++++++++++------------------
 1 file changed, 57 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ac3b9bfa7e63..ed30b3950c4e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5032,6 +5032,55 @@ static int corrupt_lbas(struct sdebug_dev_info *de=
vip, u64 lba, u32 num,
 	return error;
 }
=20
+static int __resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_inf=
o *devip,
+			    struct sdeb_store_info *sip, u64 lba, u32 num,
+			    u32 ei_lba, u8 group)
+{
+	int ret;
+
+	ret =3D check_device_access_params(scp, lba, num, true);
+	if (ret)
+		return ret;
+
+	/* DIX + T10 DIF */
+	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
+		switch (prot_verify_write(scp, lba, num, ei_lba)) {
+		case 1: /* Guard tag error */
+			if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+				return illegal_condition_result;
+			} else if (scp->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT !=3D 3 */
+				mk_sense_buffer(scp, ABORTED_COMMAND,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+				return check_condition_result;
+			}
+			break;
+		case 3: /* Reference tag error */
+			if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+				return illegal_condition_result;
+			} else if (scp->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT !=3D 3 */
+				mk_sense_buffer(scp, ABORTED_COMMAND,
+					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+				return check_condition_result;
+			}
+			break;
+		}
+	}
+
+	ret =3D do_device_access(sip, scp, 0, lba, num, group, true, false);
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
@@ -5042,7 +5091,6 @@ static int resp_write_dt0(struct scsi_cmnd *scp, st=
ruct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip =3D devip2sip(devip, true);
 	u8 *cmd =3D scp->cmnd;
-	bool meta_data_locked =3D false;
=20
 	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
 		     atomic_read(&sdeb_inject_pending))) {
@@ -5110,59 +5158,18 @@ static int resp_write_dt0(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)
=20
 	if (sdebug_dev_is_zoned(devip) ||
 	    (sdebug_dix && scsi_prot_sg_count(scp)) ||
-	    scsi_debug_lbp())  {
+	    scsi_debug_lbp()) {
 		sdeb_meta_write_lock(sip);
-		meta_data_locked =3D true;
+		ret =3D __resp_write_dt0(scp, devip, sip, lba, num, ei_lba,
+				       group);
+		sdeb_meta_write_unlock(sip);
+	} else {
+		ret =3D __resp_write_dt0(scp, devip, sip, lba, num, ei_lba,
+				       group);
 	}
=20
-	ret =3D check_device_access_params(scp, lba, num, true);
-	if (ret) {
-		if (meta_data_locked)
-			sdeb_meta_write_unlock(sip);
+	if (ret > 0)
 		return ret;
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
-		sdeb_meta_write_unlock(sip);
=20
 	if (unlikely(-1 =3D=3D ret))
 		return DID_ERROR << 16;
