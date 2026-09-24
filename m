Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BD7371D1F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290511; cv=none; b=Xb10iHp2dNrTmSMYjWwHF1iI9TuNb4i34r0aHcLrxn/hzqh0PGupUdM0WEXywGsdEpnZlBDnWuNHrY2diBpvpdmoM79u8kjOQTxKv8VHHJrJJcBRW7GiuiyARLGbocTzuk8DIkmW7VRBn+17b3ZvsHoo3XjkMvJLluc6Qa0mtmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290511; c=relaxed/simple;
	bh=SNYOeSMmA/EiXhJuDDubND48y3nY1aEGAKzaiu1amcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmSmVmTutUHx4HLhsbhmfQOT+Zvj5DrVW0+U9Mx4wv2o2A4JEIRmqLYR/ur7IlAggv17cHuO4AhpW8tdO3O66E9FNELjTlM8m6fnHdFMeBfn90604fZIyBq2psjbWgzrtqkDLZ6R9XI7bD9Z+SngA2c9ZfEOpwKFnWdMTkJgSuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VRiiJ0Fs; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VRiiJ0Fs"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrTgd6NR4zlfvpK;
	Thu, 24 Sep 2026 22:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790290504; x=1792882505; bh=wSFgs
	Sk9Ra+MNQqKEq/PBMEtrmZVLNsEI1yyDBNVBKU=; b=VRiiJ0FsW5Hr3kHK0i6SA
	3aKh64GnjRT1N0+vpnOU83oB9EoAwcBuPCK2tPpO3xl2T7e/lKLLN8HscJMB4BiI
	5YpmGuxKc7IxvpwjmBzWoNbL0ZY5hSlG11pHPlho1q2HmiVgOqfiU1hFzoU+7+yi
	m+GAIRSCIFp/ZZFMBMYiwiuIBJ6LPDu+vhzbjaQCHZZN7Qi15KY/uYzjAIPA/4vK
	b6liZdIHkxy/iJF4Ugb6yipwYn/QbjGV6PPG5GfO1BfM4J2N6XQDaX64m1GthZRx
	VtzNJs5AFRMLUMz8gkx9JeypPlE0KxwEHylbWhI7FEqqTGCEKI05oN/qn4jehVuT
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id me0RpHWNT0c2; Thu, 24 Sep 2026 22:55:04 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrTgW1sc3zlfvpN;
	Thu, 24 Sep 2026 22:55:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 5/7] scsi: scsi_debug: Split resp_write_dt0()
Date: Thu, 24 Sep 2026 15:54:41 -0700
Message-ID: <ace4490b7a25e7699b9021bd4a1030d6ca64ede7.1790290090.git.bvanassche@acm.org>
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

Prepare for enabling lock context analysis by eliminating conditional
locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 122 +++++++++++++++++++++-----------------
 1 file changed, 68 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b0785237bfea..229f35262382 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5041,6 +5041,65 @@ static int corrupt_lbas(struct sdebug_dev_info *de=
vip, u64 lba, u32 num,
 	return error;
 }
=20
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
+		switch (prot_verify_write(scp, lba, num, ei_lba)) {
+		case 1: /* Guard tag error */
+			if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+				*scsi_status =3D illegal_condition_result;
+				return -1;
+			} else if (scp->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT !=3D 3 */
+				mk_sense_buffer(scp, ABORTED_COMMAND,
+					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
+				*scsi_status =3D check_condition_result;
+				return -1;
+			}
+			break;
+		case 3: /* Reference tag error */
+			if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+				*scsi_status =3D illegal_condition_result;
+				return -1;
+			} else if (scp->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT !=3D 3 */
+				mk_sense_buffer(scp, ABORTED_COMMAND,
+					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
+				*scsi_status =3D check_condition_result;
+				return -1;
+			}
+			break;
+		}
+	}
+
+	*scsi_status =3D DID_ERROR << 16;
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
@@ -5051,7 +5110,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, st=
ruct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip =3D devip2sip(devip, true);
 	u8 *cmd =3D scp->cmnd;
-	bool meta_data_locked =3D false;
+	int scsi_status =3D DID_ERROR << 16;
=20
 	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
 		     atomic_read(&sdeb_inject_pending))) {
@@ -5118,63 +5177,18 @@ static int resp_write_dt0(struct scsi_cmnd *scp, =
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
