Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF716EB6E;
	Tue, 21 May 2024 11:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716292445; cv=none; b=jJS0DyHqUPdMDQdmDZGcfWYlEAJ3XHxgrt5sS7rzv7Dpay94pLiixxlemYmEy6ps9vdeMVf/DuL0ax6GxlNhwIeW6SzGK0ybhZulDuSRGxHhmvU5pZeGgzIQPYeEOzmX52w8Ea2JW8LySE1q2QArAjQx4IFVraF75+YRPqeQEOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716292445; c=relaxed/simple;
	bh=rqZqvlTQN3mxEP1q6VKOrA/FUSikdRptqwbsPUjohhQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XAU17ToztdFL6veUFsBo3PJoMC1fjHE36vNX6bZPZHGZAYrc4dW8U/Ef/s4pgrcHmLBFWEvbPPZFkEau09lQfdowiiYRLkuZjiMF++uVnriCFao+RjN79Z1Fxt9GpR2rDEgH4c4xPst+bb8WRSBrXB8OY+jZkbCFq02lRQNJBNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from unicom145.biz-email.net
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id SIX00151;
        Tue, 21 May 2024 19:53:51 +0800
Received: from localhost.localdomain (10.94.10.66) by
 jtjnmail201605.home.langchao.com (10.100.2.5) with Microsoft SMTP Server id
 15.1.2507.35; Tue, 21 May 2024 19:53:50 +0800
From: Deming Wang <wangdeming@inspur.com>
To: <jejb@linux.ibm.com>, <martin.petersen@orcal.com>
CC: <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] scsi: mpt3sas: Use a unified annotation style
Date: Tue, 21 May 2024 07:53:45 -0400
Message-ID: <20240521115345.1552-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 202452119535130275a12e75145b5469335c3b1f35b93
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Use a unified annotation style.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12d08d8ba538..9c47cc064970 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2680,10 +2680,11 @@ scsih_device_configure(struct scsi_device *sdev, struct queue_limits *lim)
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 		mpt3sas_scsih_change_queue_depth(sdev, qdepth);
-		/* Enable QUEUE_FLAG_NOMERGES flag, so that IOs won't be
-		 ** merged and can eliminate holes created during merging
-		 ** operation.
-		 **/
+		/*
+		 * Enable QUEUE_FLAG_NOMERGES flag, so that IOs won't be
+		 * merged and can eliminate holes created during merging
+		 * operation.
+		 */
 		blk_queue_flag_set(QUEUE_FLAG_NOMERGES,
 				sdev->request_queue);
 		lim->virt_boundary_mask = ioc->page_size - 1;
-- 
2.31.1

