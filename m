Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3DF371D1F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 22:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290509; cv=none; b=duxd2oCYud2vXhquD3R7meECV9uliXOyVRthFURLRLmAVsDqFv2COyznuKlFTMh6HVTiI9TSlQtV5iEVPn0+0KHRTm2kfMxPWWICF4QgRJBYbz17v0T+cwWHG57T2+kxb+dkAne5t+hRQC1bWo2R9E5U9yuGEKP4J0hQoajZeeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290509; c=relaxed/simple;
	bh=j0V8oCjQNK99vPyBXL3t+gjauZ2esxhyzCgcE4lkOS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjYygSWXMIhG1SQRqLKThl2fltZp9JSPubYqaSmcbDLKid56dWmQuFoQf6CSbA0s5nX45q0Yrs5Q+4aKSz0r7GdPJIS2WolQwde8T2ts4KeJcDf7uHtPOwdCZASgOZaSXktR0f9APMaRFzrTSqN4HhGNQlZShG0/fyKvonLhLoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DV0w7wIV; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DV0w7wIV"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrTgb40ZBzlfvpW;
	Thu, 24 Sep 2026 22:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790290502; x=1792882503; bh=KVZpk
	MwvxbCDV95Li2LGF6QAUBC/JAvP4HQ49Ds2XpE=; b=DV0w7wIVanZNCjNJBl8Z/
	eAvGIqsN/Drbux53sr9qCG9lUvvmdgLlCDUflnLlG0n9OuSVqkVOji0ukHrqznrJ
	sz7RAAGvog3zvE7l29KpeepJuOnS3oZEiko0jgIkimQys4WSsyvs/+h7WgiGCj9T
	fcYVQ6hPrY5e5lSNxHL1yIzb7cTOtppmxoQKNvnw82EJXxTCTU2WhU+7n/8+D0te
	r0vNrEX93Xf/2lDumuFFsnklZvj/Cb38PRWhMOjCJBwVn3SMIFULXsCUnbEffDAD
	iFe5TkcEiolPA+nL1BQtIXXsE8d5zFBIssa2EF7Tbmya9DZbdJS/Svk99qW3KI89
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N5vOhocw87Kr; Thu, 24 Sep 2026 22:55:02 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrTgT1kw3zlfvpK;
	Thu, 24 Sep 2026 22:55:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 4/7] scsi: scsi_debug: Split resp_read_dt0()
Date: Thu, 24 Sep 2026 15:54:40 -0700
Message-ID: <4b4b537c1a2c95b81d0c8b8f9c4c31e2b9f47369.1790290090.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790290089.git.bvanassche@acm.org>
References: <cover.1790290089.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Split this function to remove conditional locking. This patch prepares
for enabling context analysis.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 93 +++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0f4637d1265a..b0785237bfea 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4577,6 +4577,51 @@ static int resp_read_tape(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
 	return 0;
 }
=20
+/*
+ * Returns the number of bytes transferred, or -1 with *scsi_status set =
to a
+ * SCSI status code on failure.
+ */
+static int __resp_read_dt0(struct scsi_cmnd *scp, struct sdeb_store_info=
 *sip,
+			   u64 lba, u32 num, u32 ei_lba, int *scsi_status)
+{
+	u8 *cmd =3D scp->cmnd;
+
+	/* DIX + T10 DIF */
+	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
+		switch (prot_verify_read(scp, lba, num, ei_lba)) {
+		case 1: /* Guard tag error */
+			if (cmd[1] >> 5 !=3D 3) { /* RDPROTECT !=3D 3 */
+				mk_sense_buffer(scp, ABORTED_COMMAND,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+				*scsi_status =3D check_condition_result;
+				return -1;
+			} else if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+				*scsi_status =3D illegal_condition_result;
+				return -1;
+			}
+			break;
+		case 3: /* Reference tag error */
+			if (cmd[1] >> 5 !=3D 3) { /* RDPROTECT !=3D 3 */
+				mk_sense_buffer(scp, ABORTED_COMMAND,
+					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+				*scsi_status =3D check_condition_result;
+				return -1;
+			} else if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+				*scsi_status =3D illegal_condition_result;
+				return -1;
+			}
+			break;
+		}
+	}
+
+	*scsi_status =3D DID_ERROR << 16;
+	return do_device_access(sip, scp, 0, lba, num, 0, false, false);
+}
+
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *=
devip)
 {
 	bool check_prot;
@@ -4586,7 +4631,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, str=
uct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip =3D devip2sip(devip, true);
 	u8 *cmd =3D scp->cmnd;
-	bool meta_data_locked =3D false;
+	int scsi_status =3D DID_ERROR << 16;
=20
 	switch (cmd[0]) {
 	case READ_16:
@@ -4668,48 +4713,18 @@ static int resp_read_dt0(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
 	}
=20
 	if (sdebug_dev_is_zoned(devip) ||
-	    (sdebug_dix && scsi_prot_sg_count(scp)))  {
+	    (sdebug_dix && scsi_prot_sg_count(scp))) {
 		sdeb_meta_read_lock(sip);
-		meta_data_locked =3D true;
-	}
-
-	/* DIX + T10 DIF */
-	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
-		switch (prot_verify_read(scp, lba, num, ei_lba)) {
-		case 1: /* Guard tag error */
-			if (cmd[1] >> 5 !=3D 3) { /* RDPROTECT !=3D 3 */
-				sdeb_meta_read_unlock(sip);
-				mk_sense_buffer(scp, ABORTED_COMMAND,
-					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
-				return check_condition_result;
-			} else if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
-				sdeb_meta_read_unlock(sip);
-				mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
-				return illegal_condition_result;
-			}
-			break;
-		case 3: /* Reference tag error */
-			if (cmd[1] >> 5 !=3D 3) { /* RDPROTECT !=3D 3 */
-				sdeb_meta_read_unlock(sip);
-				mk_sense_buffer(scp, ABORTED_COMMAND,
-				      LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
-				return check_condition_result;
-			} else if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
-				sdeb_meta_read_unlock(sip);
-				mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				      LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
-				return illegal_condition_result;
-			}
-			break;
-		}
+		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba,
+				      &scsi_status);
+		sdeb_meta_read_unlock(sip);
+	} else {
+		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba,
+				      &scsi_status);
 	}
=20
-	ret =3D do_device_access(sip, scp, 0, lba, num, 0, false, false);
-	if (meta_data_locked)
-		sdeb_meta_read_unlock(sip);
 	if (unlikely(ret =3D=3D -1))
-		return DID_ERROR << 16;
+		return scsi_status;
=20
 	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
=20
