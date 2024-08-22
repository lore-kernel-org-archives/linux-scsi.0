Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78491166F29
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356820; cv=none; b=FafUQyHs4CRpSmLQuuEGc8KR2v7arMjqdBX3dXNusFKQ22uU+IBaV5G+sOAIq22mPMxcPAyOW1R+1daR+frW1t+XCt83mTKfxdkOIizHPKWRCNQZNu4Y6c8ULXWqlDSmc7MIWDFoGujUW71gPjDowVDe7TOzLtHT9yq8wKOM/co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356820; c=relaxed/simple;
	bh=Tea0nRLl/F6rTeBQtk9RSleCCvVwpm/DCk44+A+OIYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkfS07sLHCR58LWcqalGoZYJrOsrSlxZFL8vv6GrjJzW0vOl26klk99r3yJHDA39nHdzdIcbT4hdoq5fIKP4Sjw1oCqmjXkFuF1cUULJ5C+Ldzd/heuguBMi69TTvDiEmp9IT7Z+tkvJowv0TuLZD76tiFj1qcj9+CbVwDs9y6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nwykaJZe; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nwykaJZe"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw14yFNz6ClY9P;
	Thu, 22 Aug 2024 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356815; x=1726948816; bh=dIV0M
	zTqKSLs75pRHwjZv9wzy9UkaqXuwG2DQwhD2hE=; b=nwykaJZeHbWEduf/2u6ep
	1IVF453FvdjBrIyTbNW/uB207VqN8JAfRoQVTMBjMnoNAyAk/2RnvOtJhtz2CREh
	d/yNucGq8kCAxaam9svTZYVYpIQJbYgQVPrYu+X89ooxQEW4QBa98yw5NIuKkK18
	2c6q+K+8qUy036cVFqh3RmCmATA0RkMEGc4gIoexv06oYZsE/LvmVrXK0A6/dJSQ
	U5wlfjVs9qGYhoSNehHjn1H0/9jCoIoiXfgIZOsMv7w0t8FUwAL+D6SMrWHdV9KQ
	GbiKsP8z2V4XB3cdB3HrUIF0CA6VxrLpBkuD0s8kmwKGLP0DHFpQLZIv19aLjoU2
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fwW7ZZoQR86C; Thu, 22 Aug 2024 20:00:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYvx0bQyz6ClY9K;
	Thu, 22 Aug 2024 20:00:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 04/18] scsi: bfa: Simplify an alloc_ordered_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:08 -0700
Message-ID: <20240822195944.654691-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_ordered_workqueue() format the workqueue name instead of
calling snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_im.c | 6 ++----
 drivers/scsi/bfa/bfad_im.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a1d015356063..66fb701401de 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -766,10 +766,8 @@ bfad_thread_workq(struct bfad_s *bfad)
 	struct bfad_im_s      *im =3D bfad->im;
=20
 	bfa_trc(bfad, 0);
-	snprintf(im->drv_workq_name, KOBJ_NAME_LEN, "bfad_wq_%d",
-		 bfad->inst_no);
-	im->drv_workq =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
-						im->drv_workq_name);
+	im->drv_workq =3D alloc_ordered_workqueue("bfad_wq_%d", WQ_MEM_RECLAIM,
+						bfad->inst_no);
 	if (!im->drv_workq)
 		return BFA_STATUS_FAILED;
=20
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 4353feedf76a..0884af04bd1f 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -134,7 +134,6 @@ struct bfad_fcp_binding {
 struct bfad_im_s {
 	struct bfad_s         *bfad;
 	struct workqueue_struct *drv_workq;
-	char            drv_workq_name[KOBJ_NAME_LEN];
 	struct work_struct	aen_im_notify_work;
 };
=20
