Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDC1448C0
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2024 20:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723062763; cv=none; b=FyVW23FyoI+hrQwKaCtiTNYuENjf7zBVp2uqzo5FtwtS50lB+xTIplRtTxSddWam8sh8Anr3glZ1L2weKX3pgyGw+KKGTCuFoX0q/M7cA2bRy5mIuYLhfbNPEV1+fRdmAtLAwnb3OQqPtq5jHkCJzY48ulBZ98yOgEvOkjxAV+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723062763; c=relaxed/simple;
	bh=KPnOK7Wkg1wrfSaQ3lzewGmG1B1ZwpZs39g505Qj894=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJC5+M/gpNiZWb+uUggmsBpvc6V+zy8HT0fZNtK1nrknLFGJFLCEoe8Kyf1zGOImkDKb50Gv7SZsUcgrR4apBaYNBChcGNC97SJd4N2EEgIQEJqWcsxfHJeM7p8eNwWZU+bRcAY2+Es/YbW/yI90qZymV/15P+CLsiigUQqWln4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jeil9aYj; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jeil9aYj"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WfMLK0pGnzlgVnf;
	Wed,  7 Aug 2024 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723062758; x=1725654759; bh=WPX9e
	WUOvEZNMph5/B7KtctY73Okvl+bREwwX1TMcGk=; b=jeil9aYjZlhVmMx8xwJVU
	ZgdpVmP65njFakL24mCOwTYzsz1N0yXMoPGCHG3H8rzfcZ+rv+GrbH0wKf4cYRFT
	nasyOWBmbFhbj3s+oeb3bANL2VkpGR790Y4tNvjKHEcMEpWu38h/eZ3FlzEsDzlN
	ioPFv6ruJjaUByQBx15buSQAZAlOpzYvDbV0Lzb1raEltLzzJwia525uZkhlR6Ks
	IZfhusKJ31tKx4mQpHklQY3MDLvP1xptqnYEMQH9zPPoIMeDhFS8v5VuZDlQbHLl
	GY4DUYhhvoElot6f4WI/vp8GYsWNZBifSF0s8c9Boj2yx+2ShYFiVOnCcIZrD/Qe
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 812hzXBKZ330; Wed,  7 Aug 2024 20:32:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WfMLG1WxqzlgVnF;
	Wed,  7 Aug 2024 20:32:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/2] scsi: core: Retry passthrough commands if SCMD_RETRY_PASST_ON_UA is set
Date: Wed,  7 Aug 2024 13:32:13 -0700
Message-ID: <20240807203215.2439244-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
In-Reply-To: <20240807203215.2439244-1-bvanassche@acm.org>
References: <20240807203215.2439244-1-bvanassche@acm.org>
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
by introducing the SCMD_RETRY_PASST_ON_UA flag.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 5 ++++-
 include/scsi/scsi_cmnd.h  | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 612489afe8d2..38e3ea85e381 100644
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
+	    !(scmd->flags & SCMD_RETRY_PASST_ON_UA))
 		return true;
=20
 	return false;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 45c40d200154..43c584fbeaca 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -58,8 +58,11 @@ struct scsi_pointer {
  */
 #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
+/* If set, retry a passthrough command in case of a unit attention. */
+#define SCMD_RETRY_PASST_ON_UA	(1 << 5)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING=
)
+#define SCMD_PRESERVED_FLAGS	\
+	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | SCMD_RETRY_PASST_ON_UA)
=20
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
