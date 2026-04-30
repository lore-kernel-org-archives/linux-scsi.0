Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC37F3537FF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573498; cv=none; b=UgCwIdjyBF7S1IVD/AutTR9zYYNS+XpNwAJi8ldg9HrpZ/lu5QyPDHLHtKsHdI1zaB3P1PESbNDrtpWhwN5WxYCoLAfUcgCQsITlASCGjx5DEoV5/gXf6fHWFevPRK7UnLEvFbhm4sxdPg65GC524jhWGTnV0WS/1FjxaEiFYF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573498; c=relaxed/simple;
	bh=uy11pHqRIzxxNrMLe98nu80xOi1i/veoJzr+qADpG7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3IhXAoDlfeOCunEnMBXlr0HQn3GBEBeghLqsTRD7mCnf9C+JFIQWYioJLe6UwmHEls7qSrWHzlqfk0u3uH+U7kIdVUstygX+qXLqF/WvT04GxXqcBD88EuQSyCg29wH1KgcN8dPj0RoDHXRCAhT5CKraziSsa9OK9Twm/Pr6dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VLQR0ENF; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VLQR0ENF"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62dh0gDlzm1QFR;
	Thu, 30 Apr 2026 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573492; x=1780165493; bh=l+ofl
	uSerwWX7AEEFRL9LXB4hCrxu5v6zkarpbndqq0=; b=VLQR0ENFNpySSKnKvJsbN
	+7+yGpU5QxPO8viNoD+xrLSX5Eg04d2fEjVdycvFQG/2St9lwSBqKHkN2SqaQk70
	Xzz9WS2RQTqBpYk28xbk9+KaXh408HeSLwD6ZsUnXRSsXWVi0gvk4mLoy7c9ErBX
	VRkOh5t3V6+ou7KnEYzOzuBr2I/TT6B+vENsXd+39TzpRVm1aeLf7/JNDge9VqE7
	rbwy1dZtf/WlvvO2UdRbgUA0yMZZZDlFaNobFERTuais3M4iOSZ+5K8/aoafNSx7
	kwCWBjSptN5tC9kjMtJecSEMPzatqyQCuxmCuJo/cpE0QD59lT8zvfC0TkUDkUIK
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mN09vWFa9ljn; Thu, 30 Apr 2026 18:24:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62dX6X40zlhpdN;
	Thu, 30 Apr 2026 18:24:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 46/56] scsi: qedi: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:16 -0700
Message-ID: <20260430182130.1978347-47-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
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
