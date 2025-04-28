Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A813428D83E
	for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2025 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745860977; cv=none; b=PSrPz8TAwrNM+pKnXUYE0aHh3IpenAdspypZGy8H0o3fDxPVD3wDOzQPRm5UohMl6ehEzCGnCl5b8oQsETLdqGa5PcDwfTBNxymiC46WrkH95to/swsGBxxgT2KMP//9ywSoUTmIbWVdNBD1uhZj0VCEEDZSSpMSWwoNrYtd8nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745860977; c=relaxed/simple;
	bh=38lrtvP3Fegb2/yFDBCyBNOYLbgJmqfz9glOU33c8cA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ExoNLWU9uwUMCuV4h3LOztUhQ684bVzC+EQk4P+mJqlOQtGeQQG4ZHpmMnP6KjihdInQNr8gEYJ6rSJKemV7foGjM1vatwH3krsn1djG+/yEcFWQv7K/Y5vHxV7TaZVasdD4YWPd8t/rRrWPOlf6eGN0+RubPlPk5GsiI59YxX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pJSdKjas; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pJSdKjas"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745860973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PFkNkl64NBVDb+0cR8KGO6d71bTbYgYFpudiWpVGc+M=;
	b=pJSdKjasmS03w+a2oAjY6Wjy/xlRqUHF7EoG2H3lGSaOaG+oW/W7/LCxH3f04hO/wDWvhG
	AVtvrIst6eAs/HDNQyhr4kcdZD5IoVWhslVY+Lqg5kGr6Se6h3rUFPBLwmMfiJEGNUZ/u5
	aDb7IAsKvb4YmgUmoMSFJCa6HTZtj+c=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Use secs_to_jiffies() instead of msecs_to_jiffies()
Date: Mon, 28 Apr 2025 19:22:05 +0200
Message-ID: <20250428172205.2749-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use secs_to_jiffies() instead of msecs_to_jiffies() and avoid scaling
'ratov_j' to milliseconds.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
 drivers/scsi/qla2xxx/qla_os.c  | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 10431a67d202..ccfc2d26dd37 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3106,8 +3106,8 @@ static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
 	switch (rval) {
 	case QLA_SUCCESS:
 		/* Wait for the command completion. */
-		ratov_j = ha->r_a_tov / 10 * 4 * 1000;
-		ratov_j = msecs_to_jiffies(ratov_j);
+		ratov_j = ha->r_a_tov / 10 * 4;
+		ratov_j = secs_to_jiffies(ratov_j);
 
 		if (!wait_for_completion_timeout(&comp, ratov_j)) {
 			ql_log(ql_log_info, vha, 0x7089,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6b9b8218b512..276441e26ae2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1303,8 +1303,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	       "Abort command mbx cmd=%p, rval=%x.\n", cmd, rval);
 
 	/* Wait for the command completion. */
-	ratov_j = ha->r_a_tov/10 * 4 * 1000;
-	ratov_j = msecs_to_jiffies(ratov_j);
+	ratov_j = ha->r_a_tov / 10 * 4;
+	ratov_j = secs_to_jiffies(ratov_j);
 	switch (rval) {
 	case QLA_SUCCESS:
 		if (!wait_for_completion_timeout(&comp, ratov_j)) {
@@ -1818,8 +1818,8 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		rval = ha->isp_ops->abort_command(sp);
 		/* Wait for command completion. */
 		ret_cmd = false;
-		ratov_j = ha->r_a_tov/10 * 4 * 1000;
-		ratov_j = msecs_to_jiffies(ratov_j);
+		ratov_j = ha->r_a_tov / 10 * 4;
+		ratov_j = secs_to_jiffies(ratov_j);
 		switch (rval) {
 		case QLA_SUCCESS:
 			if (wait_for_completion_timeout(&comp, ratov_j)) {
-- 
2.49.0

