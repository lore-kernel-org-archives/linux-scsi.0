Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636AB1C68AC
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845408; cv=none; b=sZ35etGhSveAc2PdV8BYg2DILB7BIMY9SGeZj0b5HBoOFnQ6UygeAt9phmvhycAIFUkzJzPC5KXBckvcL32KcyE+m14xJH9dtGMlbhkEZJqvV/el7jG5iJjQC2ySm07kK4yQs7CmrLkgmmv09N2zkjdhG9n4j/jhftRbmNPsSuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845408; c=relaxed/simple;
	bh=Tea0nRLl/F6rTeBQtk9RSleCCvVwpm/DCk44+A+OIYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frnGmHXtmifwp/8xtmuEEWqzZQYD9osaIdPVYIBgLOPNx0xBaiZ0XBVs6/KxY7HucbsnfK/Slk+GkrcpNgi/2hMiKoh1G7LH+4XDdnio+Cxzb3kKIiFKuK6TEBoEejShuCVu0MjMafhuIYjwvRw7hI2COaRLbwCdiVR2cELkstM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rBGy0E4c; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rBGy0E4c"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnB58Mlz6ClY9B;
	Fri, 16 Aug 2024 21:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845404; x=1726437405; bh=dIV0M
	zTqKSLs75pRHwjZv9wzy9UkaqXuwG2DQwhD2hE=; b=rBGy0E4cKNWyQYo+Y3Ux7
	vz90xl62D6/D8z1yEpsYJmokNyJpcnGwT/hrL4gsxW+QpQRJWGpZHahep4cPDFmF
	CgC/dl8belD2N/VQ3hriPLS0JBYX4CfzKCXWDiYL7j/EpWp6L7awZKskSd6zjeSI
	Gg7MnOMBk21Qc1YuLe6bcUlfmtkshe/daZwi/Yu10t3oSH+4zqXtzTj/vNYz7rtv
	WF0Htjy2n1wH9AgmmqhtoFChLtaJfgIzH8+/MhB6peSeErX4rm4g9JlyuaTMaPbk
	4GzozFRCI9NZ1k1+J/YprB5rLQW63IZgLKZH12wTht+KKxD4WvE1BGogrYxirwk7
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id F0KrkmKzXDkc; Fri, 16 Aug 2024 21:56:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wlwn64q1Rz6ClY9C;
	Fri, 16 Aug 2024 21:56:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 04/18] scsi: bfa: Simplify an alloc_ordered_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:27 -0700
Message-ID: <20240816215605.36240-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
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
