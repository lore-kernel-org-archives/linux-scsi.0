Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59C650255A
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119641; cv=none; b=OD5k5xgdAG7CYz20Lyb9xggNYYi2CtvS/KF+XwMwA1es6H3ItWeEL2mj7asn4RWSPmfMcJOE6rolL6/1k2KCu+HaOupJPfx7qDRAS8HG3ccVE8R1NIQA3gmaqINEgVdj+Qdj0heiHU7nZHmY3htK/6UUdH5n4O2B1ZVQm3fXGdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119641; c=relaxed/simple;
	bh=Um0sRZPbn/hP4USAJVKh2znq/Jttp2qTzCB9hVi3chI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/zYr3C/HwmnEStboxgTVKAfwzDtP3CKUZxDKNCe0i9ix7QOlUwTHOIgak2gLiLF9KSyub/e/jGCtmHIfzcBTHMqW1Kh0yD3KOZ3fZqVNmfylzeXIB+yJspbvpdDFEU68IozzlYQKDZM4MBCSlV+/yWE5vkvSfdaHZa7vP4Vn5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zY+IhOlg; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zY+IhOlg"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqGT86l5bzlfvpr;
	Tue, 22 Sep 2026 23:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790119608; x=1792711609; bh=1JIjJ
	Qo6ZkNBHl7CpsdpDHO0rW7OXeiIDic98NZia+8=; b=zY+IhOlgI57nxIbdIcjjt
	x91SE+1ZFMVfeTUlrWpDi5LA9y5/yqVG+rZZFFm2ssW6CZGRPhuY3GYd3fZMCn8j
	coK5vEhPgIWH6fCy2N8Oo/I8gympPmjPIsL8NwNv28AL6QvzhaoeKdyUG/+N6U1Z
	vqL7Dk6bXB1m5/Az/aX2r6FWqYyVy1ZYZP3HLxVLvIiP1fliJ4RrLjQz/KQOww7v
	0XklvzJBOtb3HVgzsrmpVmMVXyylwBGRK7ewsSRuiA7BG7TQAzBctcV0i76kAC8l
	Tv6q+IO8u8FtXdL9qdO0uOTIJS+zHsvDKTYfitWVrwBjLhiVfRZTheU3/lAEa7iK
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BHHEbYY2vNND; Tue, 22 Sep 2026 23:26:48 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqGT32hRLzlfvpH;
	Tue, 22 Sep 2026 23:26:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/7] scsi: scsi_debug: Split resp_read_dt0()
Date: Tue, 22 Sep 2026 16:26:24 -0700
Message-ID: <bcc45fcd315feaec1b033496444573723a5f081b.1790119506.git.bvanassche@acm.org>
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

Split this function to remove conditional locking. This patch prepares
for enabling context analysis.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 80 +++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index fcfb49df9ee1..ac3b9bfa7e63 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4577,6 +4577,42 @@ static int resp_read_tape(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
 	return 0;
 }
=20
+static int __resp_read_dt0(struct scsi_cmnd *scp, struct sdeb_store_info=
 *sip,
+			   u64 lba, u32 num, u32 ei_lba)
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
+				return check_condition_result;
+			} else if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+				return illegal_condition_result;
+			}
+			break;
+		case 3: /* Reference tag error */
+			if (cmd[1] >> 5 !=3D 3) { /* RDPROTECT !=3D 3 */
+				mk_sense_buffer(scp, ABORTED_COMMAND,
+				      LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+				return check_condition_result;
+			} else if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+				      LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+				return illegal_condition_result;
+			}
+			break;
+		}
+	}
+
+	return do_device_access(sip, scp, 0, lba, num, 0, false, false);
+}
+
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *=
devip)
 {
 	bool check_prot;
@@ -4586,7 +4622,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, str=
uct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip =3D devip2sip(devip, true);
 	u8 *cmd =3D scp->cmnd;
-	bool meta_data_locked =3D false;
=20
 	switch (cmd[0]) {
 	case READ_16:
@@ -4668,46 +4703,17 @@ static int resp_read_dt0(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
 	}
=20
 	if (sdebug_dev_is_zoned(devip) ||
-	    (sdebug_dix && scsi_prot_sg_count(scp)))  {
+	    (sdebug_dix && scsi_prot_sg_count(scp))) {
 		sdeb_meta_read_lock(sip);
-		meta_data_locked =3D true;
+		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba);
+		sdeb_meta_read_unlock(sip);
+	} else {
+		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba);
 	}
=20
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
-	}
+	if (ret > 0)
+		return ret;
=20
-	ret =3D do_device_access(sip, scp, 0, lba, num, 0, false, false);
-	if (meta_data_locked)
-		sdeb_meta_read_unlock(sip);
 	if (unlikely(ret =3D=3D -1))
 		return DID_ERROR << 16;
=20
