Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED243A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361176; cv=none; b=jGH+qvrrH4cuurHneSKN/PCyyLUzikyxz+wTnewGxOItLAlw14KXeYTDLXbX9xVIJZMv/wpLDPo9vhEU7aqbpU70c5wgDHvf7luUi4duXvBhIicVIbyNxUlQ6DR3io0hhB2fWVbULQka1dz93OjBARLIbQ4I7jVl7mbybPXlNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361176; c=relaxed/simple;
	bh=WTx9eCGUmQvaKxXQZj8bTFwr4SI98qCjzM4HsO8VzH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZIrWDeiiF64P0aoD9dIYUCUtYlqGPCBBTIzNWxNrJbc32kme6R6MGW7/J+OMZnSpcqZBI+LIP4V92A6Xp7DSo0RVA3rBCbMbcik3whV6Mh76+GMDOoJPo+e/CbKE873U0jhq/VgY54JN9aZuJ1eF1nkL1QfvKYGgZw8+2ULDyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oZVLpr2G; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oZVLpr2G"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpX5sYtz1XM5kt;
	Fri, 25 Sep 2026 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361168; x=1792953169; bh=1f7ta
	z49njPtN88UUaGyP4m87QpB1l1rh5xly1ckXY0=; b=oZVLpr2GaYUOGNNnzLhbB
	jy9aGDEXLBW/07vYsT6JvwbS+eBtwsSiSLodvUbvFDYINIWlTbJ01GpYIql8OjRZ
	Wd3jM0u8BR6jhAYjY40zxPrOctWp68cpBNc93U5DCXDr7XTNlL2q6gfXIPwcLYLK
	x4d/vvRRDk9PQoPAw10ZY4CG2xukaBGe8KSRgGG5vXxdQyL1lGVVDlN+53qY1tFg
	hZrmD96kpLrZrPNn5bDocgrxB9fL7Fs+Mlvk0nIbt4vQ8Wo5K39x5A99p8CdLokQ
	C02xhF3zqQjoZeTRYmdcn4Gq9yzZlweggXBYMvfOZ99J5f5jB3VaiuLFCMYWQPRm
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CVJxlF27a6Hf; Fri, 25 Sep 2026 18:32:48 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpP5nsyz1XM4Sx;
	Fri, 25 Sep 2026 18:32:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 45/54] scsi: qedi: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:23 -0700
Message-ID: <670af9856e17f9c86ef2119aa7b3b266645e86da.1790360262.git.bvanassche@acm.org>
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

Annotate qedi_cleanup_all_io() with __context_unsafe() since it performs
conditional locking.

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
index 37945f16811b..c8af10c32653 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1137,6 +1137,7 @@ int qedi_send_iscsi_logout(struct qedi_conn *qedi_c=
onn,
=20
 int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_co=
nn,
 			struct iscsi_task *task, bool in_recovery)
+	__context_unsafe(/*conditional locking*/)
 {
 	int rval;
 	struct iscsi_task *ctask;
