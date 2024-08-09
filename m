Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229083D6D
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 19:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723231905; cv=none; b=Y7OB07T8NJcsQ4L+JDvniYkyTy51MLKdoksmVrUfIjlC00tMAvbS1bt8L7o2Cr3NrgP6+liPFXQhhmm79tzXRfnXe4Rep5R9dO8sdrKunDBFWZffBjR2k3DkVu30LkzU6R4bPBV2IP+fk77C3+01Y4yZClMtjWggb9dsoam2eL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723231905; c=relaxed/simple;
	bh=9NEep1vc1qpa3J3Zv8iPQJwJJ2tC5ugq1WAiL/5JGKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHPvKJKuoOTK3rwfo0B6H/VrR+pQQhyddDmEn6y64PJqHQPxD3ByMDeqTYh6SN9523bm0cy+F7oacexYNoqsErue0UsSOnHs3JeL7GeafAxxej3eB/uIwh5SJ2yB3AE4Km2DRZsaMeZrE7wZogGhPgyxnoGEJJ5OrnRfo3QQths=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BddWq0K4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BddWq0K4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WgYv34Sf4z6Cnk98;
	Fri,  9 Aug 2024 19:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723231900; x=1725823901; bh=Yg58L
	53BiHu1/iSeNIpPUcwVoICYHFuI1GMCNM0MHXU=; b=BddWq0K4YY71+JfoZ8Tx3
	4thXp4xBeDPT00ASLngR4Ix4GMdMJoOw0oYrrzeQG4Z+jnFCgZfFd/XPlxKV23dh
	HFlOnIggkKQyFFfwwCJI3bRsyNVmPgszZ6pzvRrdsM8MKTHGwSOEuX+xOK5x0VYw
	ogykVp1De+9g/M06PAQlae1pqMNw90PwRZ+kDJWsGX3lMaDdYzN7/O2LYj7uTKkL
	ZsitxznW9yzFIeHxkqdiRB0j8uQlTYv0Hn/9fG6xiZ7+deJ9oayJpBH/ozADpiF4
	6JIGEVJR35W40jjlA/c+7qRwg57fL+uklrxBQ92/BXNPYP6FlGHqZQ3+asoURknj
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vrbsnk-jk8W9; Fri,  9 Aug 2024 19:31:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WgYv015q7z6ClY8x;
	Fri,  9 Aug 2024 19:31:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 1/2] scsi: core: Retry passthrough commands if SCMD_RETRY_PASSTHROUGH is set
Date: Fri,  9 Aug 2024 12:31:13 -0700
Message-ID: <20240809193115.1222737-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240809193115.1222737-1-bvanassche@acm.org>
References: <20240809193115.1222737-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The SCSI core does not retry passthrough commands even if the SCSI device
reports a retryable unit attention condition. Support retrying in this ca=
se
by introducing the SCMD_RETRY_PASSTHROUGH flag.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 5 ++++-
 include/scsi/scsi_cmnd.h  | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 612489afe8d2..9089d39c2170 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1855,7 +1855,10 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	 * assume caller has checked sense and determined
 	 * the check condition was retryable.
 	 */
-	if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
+	if (req->cmd_flags & REQ_FAILFAST_DEV)
+		return true;
+	if (blk_rq_is_passthrough(req) &&
+	    !(scmd->flags & SCMD_RETRY_PASSTHROUGH))
 		return true;
=20
 	return false;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 45c40d200154..19c57446ab23 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -58,8 +58,11 @@ struct scsi_pointer {
  */
 #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
+/* If set, retry a passthrough command in case of a unit attention. */
+#define SCMD_RETRY_PASSTHROUGH	(1 << 5)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING=
)
+#define SCMD_PRESERVED_FLAGS	\
+	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | SCMD_RETRY_PASSTHROUGH)
=20
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
