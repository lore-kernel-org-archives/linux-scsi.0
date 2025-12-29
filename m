Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA482E7BAD;
	Mon, 29 Dec 2025 07:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766992532; cv=none; b=pGisLloRTCsxyW2esT5pJJ/b2KqGbFxCmXOrnEk84gr+vCOjynWFiKdm333TJecW3yz5nqW2VkohJThdAVr6msfXhcynJ99vq+KiCKOLjrIyWzalezMXLsPF5/GUWhNXK3rQT10LH802GcTrWyx2KY4BqFsZNJzw0qiiMhESJPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766992532; c=relaxed/simple;
	bh=Cnrw/Hxzd3mpKr4f3Y0o6JzIOchme2EAgMetMJGz87A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=io5llZ0+eUXwwDeRAJEDFQC3+z9Pe0AW24cGv5AJWPNvkIRhhYOCpaEI6BuvVkPxaXIow2qdJt0g/ecWDbiJYLYP1IMvSezGjg06+pXCYzOpEfcGY4Mu3WUSOsayHGLUg22T5Q9bT9VNE32ULDHvk17WMwH/+6qqdcs5PIh/BMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=IgBni0y0; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="IgBni0y0"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2edd68846;
	Mon, 29 Dec 2025 15:15:20 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
Date: Mon, 29 Dec 2025 07:15:12 +0000
Message-Id: <20251229071515.155412-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b68f6245f03a1kunmcfb8735111118d
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaQ0pPVkwaQ0MfThkZS0pNGFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=IgBni0y0bvgmIK7sBMuwUglFtrHACF82a4mX/QnjlahmaXu/tywSstWGvIB7p6fFMWb84I6cMtM3XXok9ciVgXmy7yxHxSigcUGFDf3dR5Vqcq/neZINeL6qbzZ+6Y1alggfVCnsTA2B+WVVgA9G457F+RmNU3IUarJDay8kSwo=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=gdH1Ttj8FutuwQ86NRe6aVMjVgjHdXE7yfZOdznV3FY=;
	h=date:mime-version:subject:message-id:from;

This series fixes three independent memory leaks in the lpfc driver.
All of them occur in error handling paths where allocated memory
was not properly freed before returning.

These issues were identified during static analysis.

Zilin Guan (3):
  scsi: lpfc: Fix memory leak in lpfc_config_port_post()
  scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
  scsi: lpfc: Fix memory leak in lpfc_cmpl_plogi_plogi_issue()

 drivers/scsi/lpfc/lpfc_init.c      | 3 +++
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.34.1

