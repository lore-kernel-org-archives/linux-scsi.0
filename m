Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283CD846A
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022726; cv=none; b=kddGDf8QnrWxFYsUHSACA2Pt/MVhMsDQf3T5/Wk9l78yfF/UATjHYGrXh8Li2wDOUbBjI+yP4UT6QYJ8YLkaQDQYDG+WOanE6nDLEL1VfriyH9B6Z5G4ECp2o9exYdle8C0EY6Rz+syPTV/yWal7VvtnUBSMyz/HgyFq7U84BgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022726; c=relaxed/simple;
	bh=BiA1tyTLdISpGieZjQsAzyplsYAKvwK3pkgy5zdIpOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fq1VFhLXthLsNZ/aA53RfZtMmoDfnx2Bwej9ErFQos0FkvQKDEyBrtZWmHiS1jjpRmcpwFwRfGimixrjGRQMlfyY9+aiPq3c1Vs7R2VrcZ1mXjHWz7dKQUIeUd4Du03sa6BVP+0/2ptl5zx52/D5TkxwrAJFIcp7FtXvvcJeDYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DrJRygs7; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DrJRygs7"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j4pHS3MvKz1XM4Tl;
	Thu, 15 Oct 2026 00:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1792022721; x=1794614722; bh=Ao0A72fbS+/uSeSBMbRHyrIlAjB9grTz9Qs
	HXM3q0qI=; b=DrJRygs7ELZT3RwC+6iW2RKgIJTp8sXr2VgSbR2WnnWQwkyzxAu
	7CRAGpiDno7dF8DdjKewj2RGyG/l0lAY9kDEfvj70KaeV0M9W+pwjnLgVTfkvCOP
	iQg9Snd2VOzs8FkxOPUoSXw9ek3FJC/IAoNjMeFMlEMKwvYftlvhwN7d5d8dzpii
	PTLRdvLkwZiYFKP7WmpkHl9GRodYNiTgUNNFILQquAcVzlMLkqt2uQeVJUuOYewK
	QnBaBLMTFS9Ln4x1ZirvX78Hb7LH9FP6tWOEPl0ldZ/+mLCaAKNDSJCQL2wlV0cq
	g91xRGY9CtRy+YE9wLu7JmmSwDKxoionh7A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QjgkgPUSBLih; Thu, 15 Oct 2026 00:05:21 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j4pHP0Th9z1XM5kD;
	Thu, 15 Oct 2026 00:05:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: core: Document the role of scsi_done()
Date: Wed, 14 Oct 2026 17:05:10 -0700
Message-ID: <6edb00749da7a5ce9b7752d389ad2ed5a38776e4.1792022610.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document the role of scsi_done() and also how it deals with commands owne=
d
by the SCSI error handler.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f695a6605815..ab39514cc0c6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1789,6 +1789,20 @@ static void scsi_done_internal(struct scsi_cmnd *c=
md, bool complete_directly)
 		blk_mq_complete_request(req);
 }
=20
+/**
+ * scsi_done - Notify the SCSI mid-layer that a command has completed
+ * @cmd: Completed SCSI command
+ *
+ * Called by a SCSI low-level driver to notify the SCSI mid-layer that t=
he
+ * command has completed. There are two cases:
+ *
+ * - The SCSI error handler does not own @cmd. In this case scsi_complet=
e()
+ *   decides how to complete the command based on the value of @cmd->res=
ult.
+ * - The SCSI error handler owns @cmd because scsi_timeout() has set
+ *   SCMD_STATE_COMPLETE. In this case this function has no effect, @cmd=
->result
+ *   is ignored and the SCSI error handler decides whether to retry or f=
ail
+ *   @cmd. See also scmd_eh_abort_handler() and scsi_eh_flush_done_q().
+ */
 void scsi_done(struct scsi_cmnd *cmd)
 {
 	scsi_done_internal(cmd, false);
