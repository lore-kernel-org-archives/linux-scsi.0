Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B47145FE5;
	Thu, 16 May 2024 12:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715861185; cv=none; b=J+sn90QgBKDARM+SPq07nzTQFsm+l4/J+/tUEa0XDdszTs9+wCelPnLxq94qr+UYO1qfpmmEBQaj/0P8kz/aUJ6qva0kuBz9bDUNpH2WgTiDF+iuYUQXsNNybuj218iXNhamcd6TxQDwfGqIKeZPhSAs+40PANlBdygj9lPP/4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715861185; c=relaxed/simple;
	bh=ZrkME+u5Uv/8b40EDiD4n2PP4kiAQP1GT7BPu4lgrGw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PB4I36Q//lU0ciYDSqyeX2FKrY/PREVxNhTEM/gKhvFc9p3MP9eci8+Uo2UDVFYPcv/RBPr9T+pUF1HvRgRjPyylIezAArXm6FQ7lVmSCfFIjYwmKyVtQBpKgeGpKNKzAWk2SqoezSz/GAcomNQmILUXgjn88UBKAx/xfMvnxPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from unicom145.biz-email.net
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id NJX00017;
        Thu, 16 May 2024 20:06:17 +0800
Received: from localhost.localdomain (10.94.5.253) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.35; Thu, 16 May 2024 20:06:16 +0800
From: Deming Wang <wangdeming@inspur.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] scsi: mpt3sas: use pcie_device replace ret
Date: Thu, 16 May 2024 08:05:04 -0400
Message-ID: <20240516120504.1694-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 2024516200617f8eec022e4bc83d813917b89af661a5d
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Use pcie_device replace the 'ret' may be better in the function
of mpt3sas_get_pdev_from_target.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12d08d8ba538..edb7dfffa8e8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -700,14 +700,14 @@ static struct _pcie_device *
 mpt3sas_get_pdev_from_target(struct MPT3SAS_ADAPTER *ioc,
 	struct MPT3SAS_TARGET *tgt_priv)
 {
-	struct _pcie_device *ret;
+	struct _pcie_device *pcie_device;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
-	ret = __mpt3sas_get_pdev_from_target(ioc, tgt_priv);
+	pcie_device = __mpt3sas_get_pdev_from_target(ioc, tgt_priv);
 	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 
-	return ret;
+	return pcie_device;
 }
 
 
-- 
2.31.1

