Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58C431ED91;
	Tue, 30 Dec 2025 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767106753; cv=none; b=o/nImmay/IXOX65N55v9Sdjk6y36z0ZSxKANv/L6XqHPKR6QINt8i+7WLoa5+rsKqW0Hu07rkga/dZJLYFL+IBcSduFCMa2ygOQQJdUTMhebyNd3tkPKMIGnrW8DtDB+ihL1FhEPl67RfwHiLAuNuxzl6qE4w58JgXl3HvRpTrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767106753; c=relaxed/simple;
	bh=0lFQsJkLfxOHhYVdnX23I2eT+FRtpwVW+IfMg/vHFlE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lvtxx1Frzpju6DLmKaRhcJnZSCCbRDeut3kVUaMMuOrj48E/Zd2rICb4J5J8L/t5ruOqLSG16puEDm3sQNwieDQSACn+RjhlxxT9++9YE2BVSFUEXS2td/a6+BEuXZXS5ST+zpZn9SufK2PsGaZkJ/MJ6qYtjRazxlzlO9G0VAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=C6oxFTT0; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="C6oxFTT0"
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f0b66555;
	Tue, 30 Dec 2025 22:59:04 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Markus.Elfring@web.de,
	jianhao.xu@seu.edu.cn,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH v2 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
Date: Tue, 30 Dec 2025 14:58:55 +0000
Message-Id: <20251230145858.1356864-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6fc50e5703a1kunmc44e99e11660b3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaGE9PVk5DGkNPS0MaS0keGlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=C6oxFTT0+io33F/5lPP72flOkXNgAjMu09z4Y178Mw/A9qwf/Ur9iB2PXDIOBFOJqAkDXF7Ex9DzIi3dpr7GeoVSRbRKv1Mh4NGa4ESwjCeWkU/9pl8+wcrHa2djXE+XoTXrVGDG6d+bj2JyPVynMWuQe9woPajPtBjVIQ+5YFc=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=T+OenruCRRhpoH9MHDzP3HHEUWSzFLhdTDxRzjTW8uY=;
	h=date:mime-version:subject:message-id:from;

This series fixes three independent memory leaks in the lpfc driver.
All of them occur in error handling paths where allocated memory
was not properly freed before returning.

These issues were identified during static analysis.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>

Changes in v2:
- Patch 1: Refactor error handling to use a goto label for cleanup.
- Patch 2: No changes.
- Patch 3: No changes.

Zilin Guan (3):
  scsi: lpfc: Fix memory leak in lpfc_config_port_post()
  scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
  scsi: lpfc: Fix memory leak in lpfc_cmpl_plogi_plogi_issue()

 drivers/scsi/lpfc/lpfc_init.c      | 21 +++++++++++----------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  4 +++-
 2 files changed, 14 insertions(+), 11 deletions(-)

-- 
2.34.1

