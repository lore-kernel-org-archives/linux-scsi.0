Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF7370D75
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775153055; cv=none; b=josAXeSZ6MI3P6sScZ1rbQ5MggU0N7jL6X5V6d5UT5dp8RMZEPgRn9QKX47QC5OBNRnK9Wds4l8w23HmcbOJWAGelzJM+Px2g5rNK7EfASYXTekHxp6kQHzQQ+/t3b+pYGyloWE/Vd6O8sDmOh6AmTOkhDc0i9M6nrprpY7Kzns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775153055; c=relaxed/simple;
	bh=F4DsrgIwCXh1HXEg5g9pfI4vm/MPlqNk9kwFD7OT3bE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DQLbQ4uaWYY0MQg1DguELDrakOroPsEsnvdKx7/ZrNsqZW38JBJMKkUJeiZVftVuh/gGQjQy2D1h0rtppktAM1Pr4ZaqC8ZRY6C5XvO7o801jn/NZdO1b1yKEEWQ9PBKD2Hur5BcC6cTKZg05KHYoiO8v/2PK8p2VBa3lz31nAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=il1dJTWi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="il1dJTWi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775153052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h7yOigxXZpZsVMssh+mLEedTpd1BlUZc6Kc/zzGuCvY=;
	b=il1dJTWirRg13EJnJEXqu9/VT8qdEL/Vvz1fPAvj68gNCZX0DPw8OvPEoTRoz8FdiaSjuF
	uV15AhCBSueOSMhPkycVgdJJcuBDM81kkUbPcYairqXMg2+SvDaNTww9nLAg/HoerUepsU
	MGeMslceN77OJvaWLaPSfHU4hi29KF4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-bafMvKWtM46D7vCCfgvvrA-1; Thu,
 02 Apr 2026 14:04:08 -0400
X-MC-Unique: bafMvKWtM46D7vCCfgvvrA-1
X-Mimecast-MFC-AGG-ID: bafMvKWtM46D7vCCfgvvrA_1775153047
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37F28195609F;
	Thu,  2 Apr 2026 18:04:07 +0000 (UTC)
Received: from localhost (unknown [10.44.32.37])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 20B1C30030D1;
	Thu,  2 Apr 2026 18:04:05 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: target-devel@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH] scsi: target: don't validate ignored fields in PROUT PREEMPT
Date: Thu,  2 Apr 2026 14:03:42 -0400
Message-ID: <20260402180342.126583-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The PERSISTENT RESERVE OUT command's PREEMPT service action provides two
different functions: 1. preempting persistent reservations and 2.
removing registrations. In the latter case the spec says:

  b) ignore the contents of the SCOPE field and the TYPE field;

The code currently validates the SCOPE and TYPE fields even when PREEMPT
is called to remove registrations.

This patch achieves spec compliance by validating the SCOPE and TYPE
fields only when they will actually be used.

To confirm my interpretation of the specification I tested against HPE
3PAR storage and found the TYPE field is indeed ignored in this case.

Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 drivers/target/target_core_pr.c | 59 ++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index f88e63aefcd84..11790f2c5d80f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2809,7 +2809,7 @@ static void core_scsi3_release_preempt_and_abort(
 }
 
 static sense_reason_t
-core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
+core_scsi3_emulate_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		u64 sa_res_key, enum preempt_type preempt_type)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -2838,11 +2838,6 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return TCM_RESERVATION_CONFLICT;
 	}
-	if (scope != PR_SCOPE_LU_SCOPE) {
-		pr_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
-		core_scsi3_put_pr_reg(pr_reg_n);
-		return TCM_INVALID_PARAMETER_LIST;
-	}
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
@@ -2856,6 +2851,37 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
+
+	/* Validate TYPE and SCOPE fields if they will be used */
+	if (pr_res_holder &&
+	    (pr_res_holder->pr_res_key == sa_res_key ||
+	     (all_reg && !sa_res_key))) {
+		switch (type) {
+		case PR_TYPE_WRITE_EXCLUSIVE:
+		case PR_TYPE_EXCLUSIVE_ACCESS:
+		case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
+		case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
+		case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
+		case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
+			break;
+		default:
+			pr_err("SPC-3 PR: Unknown Service Action PREEMPT%s"
+				" Type: 0x%02x\n",
+				(preempt_type == PREEMPT_AND_ABORT) ?
+				"_AND_ABORT" : "", type);
+			spin_unlock(&dev->dev_reservation_lock);
+			core_scsi3_put_pr_reg(pr_reg_n);
+			return TCM_INVALID_CDB_FIELD;
+		}
+
+		if (scope != PR_SCOPE_LU_SCOPE) {
+			pr_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+			spin_unlock(&dev->dev_reservation_lock);
+			core_scsi3_put_pr_reg(pr_reg_n);
+			return TCM_INVALID_PARAMETER_LIST;
+		}
+	}
+
 	/*
 	 * From spc4r17, section 5.7.11.4.4 Removing Registrations:
 	 *
@@ -3118,27 +3144,6 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 	return 0;
 }
 
-static sense_reason_t
-core_scsi3_emulate_pro_preempt(struct se_cmd *cmd, int type, int scope,
-		u64 res_key, u64 sa_res_key, enum preempt_type preempt_type)
-{
-	switch (type) {
-	case PR_TYPE_WRITE_EXCLUSIVE:
-	case PR_TYPE_EXCLUSIVE_ACCESS:
-	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
-	case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
-	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
-	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
-		return core_scsi3_pro_preempt(cmd, type, scope, res_key,
-					      sa_res_key, preempt_type);
-	default:
-		pr_err("SPC-3 PR: Unknown Service Action PREEMPT%s"
-			" Type: 0x%02x\n", (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "", type);
-		return TCM_INVALID_CDB_FIELD;
-	}
-}
-
-
 static sense_reason_t
 core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		u64 sa_res_key, int aptpl, int unreg)
-- 
2.53.0

