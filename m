Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51295464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451686; cv=none; b=UrFG/yeZq+tnxyMKT9Ipdzf0JEQDf/fsU7g4S3CQI2NJU/K42SUJFB5quN3GgTDR7AzW2gqKU2nBuv+GmKLzNS6l29dWpKoxFRvGzxbccKR6f38QCRgH86aY2YmHnerj3JCCd+ylh5R8vHDSci4LgLzPzARsgVK7UKQVd+ihjBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451686; c=relaxed/simple;
	bh=cbcqL4QI+no/ZvQ/XpchMGVdbNtQdDoE/vHVIlB9tvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iah2kU1qHSbXNxRQ0N8Z9oKSq0s0k+ltvdLksvToYV7vrDK9ssVaM6y7UUlgLIBgwkCji8DGZUmgqqg+YTUb35GKCrMPo/pjUw25eoLqB5/9nl4LrAqBepJsgzS1w/DTGjToW7eCQQ8Buho6egFrQYn4ICI87/0HDoZ6512F3B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RAEbQk3E; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RAEbQk3E"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49J4pcTz1XM6Jm;
	Thu, 30 Jul 2026 22:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451682; x=1788043683; bh=32TSW
	CbHjiskeo0J6OtY7X7eOhcxxx0DKaL+PCFqP+0=; b=RAEbQk3EsyegZbWgCxyPm
	EtcYDQG+9cG7zmbG9k3H4vzpI2LA5aNbpyixcLklPDkTY5E6TcOGM3DlRPb6fv05
	K8fH49Isrmp4nJZjol+oJGBgYFPryeWH9Xb0kmEQtpCOng8eAADSb22MwmLsGm1o
	2dzEtpU+mVWc7ZZXdFNYkPUxaID+367EA+nPWIwiYFGCe/WwkYcWfXAsyvnaRFdY
	m8dRxcgq2zK/bajTGIbz1NRn060L/xw4NQf0oXF+MUIexup9NZnn4ryZxTVihkyV
	8HSfu9nV2OD14YGIQNhphMLsvPOnsjGtBylL+hTrC8cDNblIg4SEnw2Uc3swZnzT
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VjdOwi_1UDZC; Thu, 30 Jul 2026 22:48:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49D2NKrz1XM30r;
	Thu, 30 Jul 2026 22:48:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 24/57] scsi: esas2r: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:07 -0700
Message-ID: <4610a929a4f11d3dcf438223d2f9fbcb6ff37faa.1785451174.git.bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/esas2r/Makefile b/drivers/scsi/esas2r/Makefile
index 279d9cb3ca69..325fa0e634fa 100644
--- a/drivers/scsi/esas2r/Makefile
+++ b/drivers/scsi/esas2r/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_ESAS2R)	+=3D esas2r.o
=20
 esas2r-objs :=3D esas2r_log.o esas2r_disc.o esas2r_flash.o esas2r_init.o=
 \
