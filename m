Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0B73B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451745; cv=none; b=Z/lsFBu98DycETRWcuPZAWsYTH8X35cUm2FkQxNHs/ny2+MaGL5FupWAzFgtMMUKyk0j9ijT8XOIZLNKIc2Gg092P3PjZ1cLdhvDujUEEaE0S5rTM8QIgjirjm1+RTRjjelwpPZJoWGTjaSnZrDvJ3v3KZxXDAo4M3WCVwf0PZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451745; c=relaxed/simple;
	bh=uy11pHqRIzxxNrMLe98nu80xOi1i/veoJzr+qADpG7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s153AQAEGUEMJLBPkqIeqEU4rNgzkyC/tewxRXtw7ubhf7DY5I4V4RE9XOwiMngMUMB3KmxK31/FbLOLrj+KCpYL9Vbzpg9ZklOxlMQ5ITTgbmeoOIxEXc/hf9qfUQZ2euqW6rbeQxV2VU80WdQpbBcSJDN9ILWyhuqStIVHWck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sCoMwa8v; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sCoMwa8v"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4BS0YxNz1XM30r;
	Thu, 30 Jul 2026 22:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451739; x=1788043740; bh=l+ofl
	uSerwWX7AEEFRL9LXB4hCrxu5v6zkarpbndqq0=; b=sCoMwa8v4DDopNI+7p+4S
	D7ZB7OmYkheFQDB8m+2jwCtKg0oryWXnxuz+B/PEryj3KFTz8THOltDkTyIQIfhb
	6+NrZ+MhClsgZ0SFaliXnC8fXLL90w7O7oROC07OdfNz8Llkr8dtp3mlxojqJxUb
	wNUhYPrmg7WRnlxmUhT64niwR8Urf2DvkKitowWbaChfoNc+unDcAJ2KblbLXZB5
	WRcgKK1+PAvhCknie+cveUVK1YbPnBAWhN8gADG6brudtETB73cJBqYP0xQ3xKRy
	cAjzb2S+CRND0fo+ac3xcPOmvGLbdHc+hRBifYInE8WzcCOaYu+QDLLHkyqRJIoB
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Q3uj-mnDvMlJ; Thu, 30 Jul 2026 22:48:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4BK5Km1z1XM30k;
	Thu, 30 Jul 2026 22:48:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 46/57] scsi: qedi: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:29 -0700
Message-ID: <43ff011280be3c01537e6f696cbe721d6ff24a53.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Annotate qedi_cleanup_all_io() with __no_context_analysis since it
performs conditional locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/Makefile  | 3 +++
 drivers/scsi/qedi/qedi_fw.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/qedi/Makefile b/drivers/scsi/qedi/Makefile
index d84eedfd031b..f081d047b6eb 100644
--- a/drivers/scsi/qedi/Makefile
+++ b/drivers/scsi/qedi/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_QEDI) :=3D qedi.o
 qedi-y :=3D qedi_main.o qedi_iscsi.o qedi_fw.o qedi_sysfs.o \
 	    qedi_dbg.o qedi_fw_api.o
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 854efa4f61d8..e162061ca49c 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1134,6 +1134,7 @@ int qedi_send_iscsi_logout(struct qedi_conn *qedi_c=
onn,
=20
 int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_co=
nn,
 			struct iscsi_task *task, bool in_recovery)
+	__context_unsafe(conditional locking)
 {
 	int rval;
 	struct iscsi_task *ctask;
