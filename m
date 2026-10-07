Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2BA36B909
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 05:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349683; cv=none; b=aYqazJ7jf1Zh6Ch00BFR3TGAZhNFi631R+5E944cI9SSCamhIl481hwVNBwNBX0b7iJkjXDyObKyUM4pTqszsS7Y36ASvcgUrGWO5m8uTr6z0bsjSgevkYpTfgCR6zsUP31qgDxcz9k+7ye2ZsfJQ9omDBEDEt1XaI0B6RNjHEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349683; c=relaxed/simple;
	bh=O+up+/sJkdy7JIasjvYDR5eYH9aCrIJtfFfcv9NuqFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsYip+HZ6POHvt0AtMgmLZHZm1wHu5zMSA3Gl4ByJBP28S6KPESBOM90Tiu7B2TAAGV1C5M1BAI8b8Ij/TLr9BndmuR+EIBpJleMqZEcG4K7BdhkZ0PJtg6eDKiwdLUC2nKDuFtxxNb+n5JsSey473HFttHwSXBXw+OtSeWikJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1k6xtdYx; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1k6xtdYx"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j01NK4B1VzlfvpN;
	Wed,  7 Oct 2026 05:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791349677; x=1793941678; bh=cys1e
	S2QJefr6tTh4oxNeMwpIDRKrRFa+89iOIR6RLA=; b=1k6xtdYxr0ytnuzhFG0u4
	jkIhkPzBHLus/0k2faaL3fP9BDY1kt5TAiBb9qKGemWTfviDWkfwsBK4FKVJ/k1H
	l2bERmDzdd/3cQau7svnwjhQ6me2NHBturOfUynvRCI82v/fQBAlZ2MSYm9Tk0+X
	RX6GAOB/gvLnoPR8RDz/mUPaVSo1JjFl77aTMw7G/oXSZGmGoadTXta9pBpwfq9I
	NrHt9aNtQ8Coz2UIoGOE/Rll+2cZJg07eWiK7fsYWEJoSN+F9HPmbsI6pWgn2PBQ
	As1ngIaM0Rw/lTT/XofnIrd1J2vfbPjyUTiqmS1XQo9krL/szljdXw3GZJeOCOYH
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EoJ6O0yAzbQz; Wed,  7 Oct 2026 05:07:57 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j01NC3ygczlfdfD;
	Wed,  7 Oct 2026 05:07:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 5/8] scsi: scsi_debug: Split resp_write_dt0()
Date: Tue,  6 Oct 2026 22:07:27 -0700
Message-ID: <cd2d03eef52045b8a94c7c11644c3676f91b105f.1791349129.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1791349129.git.bvanassche@acm.org>
References: <cover.1791349129.git.bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 139 ++++++++++++++++++++++++--------------
 1 file changed, 87 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c66f8556896d..685949aedf9a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5094,6 +5094,85 @@ static int corrupt_lbas(struct sdebug_dev_info *de=
vip, u64 lba, u32 num,
 	return error;
 }
=20
+/*
+ * Returns 0 upon success or -1 with *scsi_status set to a SCSI status c=
ode upon
+ * failure.
+ */
+static int __resp_write_dt0_dix(struct scsi_cmnd *scp,
+				u64 lba, u32 num,
+				u32 ei_lba, int *scsi_status)
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
+			    u32 ei_lba, u8 group, bool lbp, int *scsi_status)
+{
+	int ret;
+
+	*scsi_status =3D check_device_access_params(scp, lba, num, true);
+	if (*scsi_status)
+		return -1;
+
+	/* DIX + T10 DIF */
+	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
+		ret =3D __resp_write_dt0_dix(scp, lba, num, ei_lba,
+					   scsi_status);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret =3D do_device_access(sip, scp, 0, lba, num, group, true, false);
+	if (ret < 0)
+		*scsi_status =3D DID_ERROR << 16;
+
+	if (unlikely(lbp))
+		map_region(sip, lba, num);
+
+	/* If ZBC zone then bump its write pointer */
+	if (sdebug_dev_is_zoned(devip) && ret > 0)
+		zbc_inc_wp(devip, lba, ret >> ilog2(sdebug_sector_size));
+
+	return ret;
+}
+
 static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info =
*devip)
 {
 	bool check_prot;
@@ -5104,7 +5183,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, st=
ruct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip =3D devip2sip(devip, true);
 	u8 *cmd =3D scp->cmnd;
-	bool meta_data_locked =3D false;
+	int scsi_status =3D DID_ERROR << 16;
 	bool lbp =3D scsi_debug_lbp();
=20
 	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
@@ -5174,60 +5253,16 @@ static int resp_write_dt0(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)
 	if (sdebug_dev_is_zoned(devip) ||
 	    (sdebug_dix && scsi_prot_sg_count(scp)) || lbp) {
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
-	if (unlikely(lbp))
-		map_region(sip, lba, num);
-
-	/* If ZBC zone then bump its write pointer over the data written */
-	if (sdebug_dev_is_zoned(devip) && ret > 0)
-		zbc_inc_wp(devip, lba, ret >> ilog2(sdebug_sector_size));
-	if (meta_data_locked)
+		ret =3D __resp_write_dt0(scp, devip, sip, lba, num, ei_lba, group,
+				       lbp, &scsi_status);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		ret =3D __resp_write_dt0(scp, devip, sip, lba, num, ei_lba, group,
+				       lbp, &scsi_status);
+	}
=20
 	if (unlikely(-1 =3D=3D ret))
-		return DID_ERROR << 16;
+		return scsi_status;
 	else if (unlikely(sdebug_verbose &&
 			  (ret < (num * sdebug_sector_size))))
 		sdev_printk(KERN_INFO, scp->device,
