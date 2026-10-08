Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E75453A59
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499367; cv=none; b=Cpgc7pI08KyxYnprS6BhHcRsgP+KUQmjf5yfUeHRrmuGf21k1djv9YcwLvO50wDwIhs9Vgu8SmjM8ZrAwrCbotHtJ50r3pue/mxJt4TNoCh4ZX0BOf//H4z8WiZ1skNImYnOD0wNxJeeHsrnSug9Rf34FPmBSRacOd1G/u57pD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499367; c=relaxed/simple;
	bh=0oOTdpTyuzdkzn5IbgFzTZN5i+9ErzKpLpsOldLdYic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4ELff0Rs2i38Sf/rcFuc/BxMsZ3fXqQWtQ83HestAytZMH/ybUoVOUUnYYnfI3rIYYS49efGW5t5pRIayryez98qvkmdPYDgdGHpFYl6PBmW/DFi/tgSDfLmhfnGDbTrrNyOdnavLR6s+s/CIQg7Rlz/NjS4Wuum2Ua9HezzXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HiKOVhcY; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HiKOVhcY"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j14kr3L2Wz1XM30k;
	Thu,  8 Oct 2026 22:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791499359; x=1794091360; bh=ikYF2
	x65eRGgsbSmY45WvR3OIFrJ8VetcqvkLdaNSDY=; b=HiKOVhcY3vbOHZ2kVM8NE
	ambay3qGuDxbTiMxqvu9Vw4Vbi6mS9DbOqt7eIQdR+kRNgxXvnCli0LE/LzBJLwj
	Os39YZBbvslmdRX8G8LjKP/3P008RBVM6M8Zz88lNO1WMVjpVDLFgUaUaY7bpRnI
	JYRQCo3R2AhwyEzmgt7BUSTMIg4jP+OPecPp2UTmfEj7yzl2yKAguXI8QPwVjTFV
	H12Qw6WfgRuv7h0f3MRnBJrV7sgZmLqyo0MiFY+dYRHZR3jPc2um9YKlYnAkC5SC
	SFQAXHx7KfO9TOcQGgEuKloLk9c1HxqWPvpWqPinfhGKEs12mJIUuy8sDaC2vU0p
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ly5BZuxowjnp; Thu,  8 Oct 2026 22:42:39 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j14kj5cBQz1XM30g;
	Thu,  8 Oct 2026 22:42:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 4/8] scsi: scsi_debug: Split resp_read_dt0()
Date: Thu,  8 Oct 2026 15:42:15 -0700
Message-ID: <5336162520371fc22ebde7bd4080a9465908dd2a.1791499174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.170.g584c36229d-goog
In-Reply-To: <cover.1791499174.git.bvanassche@acm.org>
References: <cover.1791499174.git.bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 110 ++++++++++++++++++++++++--------------
 1 file changed, 71 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index eafcadc6ef07..c66f8556896d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4608,6 +4608,70 @@ static int resp_read_tape(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
 	return 0;
 }
=20
+/*
+ * Returns 0 upon success or -1 with *scsi_status set to a SCSI status c=
ode upon
+ * failure.
+ */
+static int __resp_read_dt0_dix(struct scsi_cmnd *scp, u64 lba, u32 num,
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
+		ret =3D __resp_read_dt0_dix(scp, lba, num, ei_lba, scsi_status);
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
@@ -4617,7 +4681,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, str=
uct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip =3D devip2sip(devip, true);
 	u8 *cmd =3D scp->cmnd;
-	bool meta_data_locked =3D false;
+	int scsi_status;
=20
 	switch (cmd[0]) {
 	case READ_16:
@@ -4699,48 +4763,16 @@ static int resp_read_dt0(struct scsi_cmnd *scp, s=
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
