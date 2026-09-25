Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA2A3FFAA4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361009; cv=none; b=iGG90nmPbswxKnLeHGxLDOMJUo7sOe4I00xMJS/7sUJ/ney8pn7iK3hzmQtUJWAi2IuibZoRDedYBM5v5dCT3vfkto4s17gbCF2ykjc084qvHuZ3L5mryRUeUCMg9ryt0RRXCmVUVWN5s1W80O3MzfxmCjNmm2GvLIKCt3D/ixs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361009; c=relaxed/simple;
	bh=g7D4WKNsrhm7oBLt11mJ93GHgZaJa3SCP6Rixk2cY8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7v6VgZpg+tMJFP7aNrOBMhMH80QPjXS5ZN1aH73Bhm/l+W9Og2CBFRarA/NBe8HzI0dM57Gk1PwVMnJqoSdd7hwerjzhZXpO1gN/x2a0grkXN1tDjcXVPXRuAlgvM/KHjatJZBM4BL1jEjpXWutWyDd94n/kL3eGUWuKTaNkQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aR/QFCng; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aR/QFCng"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzlL5DJhz1XM30g;
	Fri, 25 Sep 2026 18:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361002; x=1792953003; bh=PD1I8
	0im2bCRJQToxkZKyGEtjsBQGYggg+dFcELM4Pw=; b=aR/QFCng65GpoDHA+V3fk
	4Ov8ZN68Z7iJje36gtfyshYWZa3CJOPmf7HnN2KPeErHc3A1TH2t0QhGLdRi6EoK
	R/hrnmazB67zUyLBgJALPkXuBm7kHkw2rOiYH7EEP7TBVkN64lCN5enti+kznw4B
	8yZsiioHyVyY9cgVYFnOc1FfqfVOK3Y6XZwjZ8o5XW/U8lRxMOJi8uo1FNu/fv2N
	Y9RLuBcSxyj4C7j9jAe+nOQ2mqLhZYzBpsUqyOLM5HMxbhgy/xVzmFKdPqwxCav9
	3iBy6jfZcTf0pZ56H4ljd9kOnAjVZfb2yFaQCF4MG2VBLU4WeJIou2LzUMwAn9iU
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wAn1cNSOHlwc; Fri, 25 Sep 2026 18:30:02 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzlD0QdTz1XM5kW;
	Fri, 25 Sep 2026 18:29:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v4 15/54] scsi: cxgbi: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:53 -0700
Message-ID: <e663e2d47afc8727991838bbfa29bb5ab21b38b8.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable compile-time lock context analysis in the Makefile. Document where
locking is missing by adding an __assume_ctx_lock() annotation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/cxgbi/Makefile   | 3 +++
 drivers/scsi/cxgbi/libcxgbi.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Makefile
index abfd38a26fec..c614afa18a33 100644
--- a/drivers/scsi/cxgbi/Makefile
+++ b/drivers/scsi/cxgbi/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-y +=3D -I $(srctree)/drivers/net/ethernet/chelsio/libcxgb
=20
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+=3D libcxgbi.o cxgb3i/
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.=
c
index d73a6578b461..b0bffbc38183 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1540,6 +1540,11 @@ skb_read_pdu_bhs(struct cxgbi_sock *csk, struct is=
csi_conn *conn,
 		struct iscsi_task *task;
 		u32 data_sn;
=20
+		/*
+		 * TODO: hold session->back_lock around the iscsi_itt_to_task()
+		 * call below.
+		 */
+		__assume_ctx_lock(&conn->session->back_lock);
 		task =3D iscsi_itt_to_ctask(conn->session, conn, itt);
 		data_sn =3D be32_to_cpu(((struct iscsi_data *)skb->data)->datasn);
 		if (task && task->sc) {
