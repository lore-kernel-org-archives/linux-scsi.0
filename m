Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3E5205E0E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957201; cv=none; b=Y6lymnPvhMIfLHnbUcIDmXjcEBYh8l3MACiYkRcKbskXZgb+lBvVE4ucnwVW9Cq/TZW6P9CwrNClaIJcMLD9EthH6FoYpz029f/LIJrByFX290ZQ0+tCVp4ZdArqenZWdiRmJo4KO2Bfj1eZO6WG51sqsYz1fQek8IIGknLcvdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957201; c=relaxed/simple;
	bh=Tea0nRLl/F6rTeBQtk9RSleCCvVwpm/DCk44+A+OIYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMsBaS7v6v1bEcXxJxDESON3LTbM4pnczuQK2v/SIEVgaI6KBOK/tdAOhUlT5vvqQEoAINsrlj+Qr7vq7pJ5a15e1u3gkijAawks2+/ik4JwAbeG280YXWHiO7+xnwCQpov8POdYNH9RjZXw2jaRRLCtuEgnuqy90DH9l+oc/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HeOssgqa; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HeOssgqa"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGqz3rj3zlnQkm;
	Tue,  2 Jul 2024 21:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957197; x=1722549198; bh=dIV0M
	zTqKSLs75pRHwjZv9wzy9UkaqXuwG2DQwhD2hE=; b=HeOssgqaFAZ1bHCnbJ9co
	JxYgxx4LnutCx/y+waTIHGjfJkYlJ1iUMDLTRwyVe+OCPyBiS+GWs66DGIoN2dAw
	PjYRPTofDnC7r8etymNcyF5/VPfQnaDR8veOgd8NSt/Q44HiaeV171DeXzNwK7Pl
	lAXOORZubncwPnliJg//B+7aPnUG+Mo68ctjsIbEKgolpoKK3bNUodrH0VTy+KQs
	g7zOP+mqe2SPtHXlTmnI5jGskNawEsrEgyIv017hC3U5icPlSnkXnIcZ5aYIO+uL
	iAHev+eNrEpClUZe/MZtsl7RihhuMP8R+mmDdMWDagO1TtHr5xw3KOwMrYyrTki/
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ytY5eq8gmfa7; Tue,  2 Jul 2024 21:53:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGqv65RDzlnQkq;
	Tue,  2 Jul 2024 21:53:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 04/18] scsi: bfa: Simplify an alloc_ordered_workqueue() invocation
Date: Tue,  2 Jul 2024 14:51:51 -0700
Message-ID: <20240702215228.2743420-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702215228.2743420-1-bvanassche@acm.org>
References: <20240702215228.2743420-1-bvanassche@acm.org>
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
