Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92914C4F62
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724216; cv=none; b=VBG13Ujbl2M/GvK0xjJJfoBi+BMhIUgfrP7FSJ/jsJF4avciaeUreQvYoXHJfozcnRXKIeV9eeUWfCDWRTEAiQhuAcpjNS2iiy0Nge/y+hl5+rCE9575fageHqwy8KYILRrA4kUJ7zl9gU+1SfO1I9lToBxsTz0PTHITE1/dN/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724216; c=relaxed/simple;
	bh=2R1ali4Cz6IzzrzlkfSJP9E6bnGXI+OaIY7dP68/p5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obL0kJsl2Cu1GCfPNkNoIR8TAZIxNSyHIlG22KXHZ3sQzK2e3zkvNltJ0/l7S+dHyGgZlUTZ8Xt1Ry8OprJng2eub619o3x4ZtERzGlBo7Q7mFsM1JKIOkuPScoCWE0erGy/x+x2WnbwSZukJcEv09rhyYrbPq5CvC9teeFpOd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=q0DYnvKq; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="q0DYnvKq"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hvZ460rzDz1XM5kW;
	Tue, 29 Sep 2026 23:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790724209; x=1793316210; bh=somTk
	6Cn2FqwFJnr7Q0YsvedLE3blxdK1uh6YMrvxNQ=; b=q0DYnvKqi2pa+X1Enbdbu
	jpXnXch8/yhNh59419q1Efnz6HxbGAWbdvDsyNbPmxgK5SlqsCvG19wYL1wfD0vh
	RyIJcB4QdkecbxoaD9Vit7oGuN1Vo4snBGMGaQjTshdHsPoZ4tiIfHeoRJzmMtcr
	qKsE8yERWvCRyj9IHitpE3/aA2+SKAzfEpgV45a41wG5BP7Zhng4a66e424ByQ7o
	tFWZws1ArGXA61J5P/tji14x8+WCmsYw/KzGmUB9DltYTvRg1FG0nWrncHEXGuUn
	oCyE/AgjzFpe0x9oD9Gqag+mD7B0Zhekl6vzK7J+9J0vIcAAUQHWAzu+UprX1l0c
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TD06kD5872L2; Tue, 29 Sep 2026 23:23:29 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hvZ3z6Xdgz1XM5kY;
	Tue, 29 Sep 2026 23:23:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v3 4/7] scsi: scsi_debug: Split resp_read_dt0()
Date: Tue, 29 Sep 2026 16:23:00 -0700
Message-ID: <ad760096328a5959c154a15916368a4fecad8e9f.1790723966.git.bvanassche@acm.org>
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

Split this function to remove conditional locking. This patch prepares
for enabling context analysis.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 112 +++++++++++++++++++++++++-------------
 1 file changed, 73 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0f4637d1265a..8c47e6d48b9b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4577,6 +4577,72 @@ static int resp_read_tape(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
 	return 0;
 }
=20
+/*
+ * Returns the number of bytes transferred, or -1 with *scsi_status set =
to a
+ * SCSI status code on failure.
+ */
+static int __resp_read_dt0_dix(struct scsi_cmnd *scp,
+			       struct sdeb_store_info *sip, u64 lba, u32 num,
+			       u32 ei_lba, int *scsi_status)
+{
+	const u8 *const cmd =3D scp->cmnd;
+
+	switch (prot_verify_read(scp, lba, num, ei_lba)) {
+	case 1: /* Guard tag error */
+		if (cmd[1] >> 5 !=3D 3) { /* RDPROTECT !=3D 3 */
+			mk_sense_buffer(scp, ABORTED_COMMAND,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+			*scsi_status =3D check_condition_result;
+			return -1;
+		}
+		if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+			*scsi_status =3D illegal_condition_result;
+			return -1;
+		}
+		break;
+	case 3: /* Reference tag error */
+		if (cmd[1] >> 5 !=3D 3) { /* RDPROTECT !=3D 3 */
+			mk_sense_buffer(scp, ABORTED_COMMAND,
+				LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+			*scsi_status =3D check_condition_result;
+			return -1;
+		}
+		if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+				LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+			*scsi_status =3D illegal_condition_result;
+			return -1;
+		}
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Returns the number of bytes transferred, or -1 with *scsi_status set =
to a
+ * SCSI status code on failure.
+ */
+static int __resp_read_dt0(struct scsi_cmnd *scp, struct sdeb_store_info=
 *sip,
+			   u64 lba, u32 num, u32 ei_lba, int *scsi_status)
+{
+	int ret;
+
+	/* DIX + T10 DIF */
+	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
+		ret =3D __resp_read_dt0_dix(scp, sip, lba, num, ei_lba,
+					  scsi_status);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret =3D do_device_access(sip, scp, 0, lba, num, 0, false, false);
+	if (ret < 0)
+		*scsi_status =3D DID_ERROR << 16;
+	return ret;
+}
+
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *=
devip)
 {
 	bool check_prot;
@@ -4586,7 +4652,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, str=
uct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip =3D devip2sip(devip, true);
 	u8 *cmd =3D scp->cmnd;
-	bool meta_data_locked =3D false;
+	int scsi_status;
=20
 	switch (cmd[0]) {
 	case READ_16:
@@ -4668,48 +4734,16 @@ static int resp_read_dt0(struct scsi_cmnd *scp, s=
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
+		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba, &scsi_status);
+		sdeb_meta_read_unlock(sip);
+	} else {
+		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba, &scsi_status);
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
