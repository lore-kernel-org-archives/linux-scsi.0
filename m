Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D23C2236F3;
	Wed, 31 Dec 2025 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767193881; cv=none; b=HHkM4kdUmLfuIU8tVEWrHjNp+recMZMgYtCs1OxSWMVKoS6N/UeAfKfNkZTgZi6OvmqLMVgs2QaTKlMFo3dIkUKWQYLYJ/fh71es1QU2jYueGdpLrAb+EAnVROk1pPpSvhHS/4rsbzYpx3cFnnYZEAKc5o3nxvuX9EesgIThlwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767193881; c=relaxed/simple;
	bh=+95oyJLHAh19mM8FTI0QzkR2mrAKWvzrtsCiluUg9TY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X6WqdYStnyORcAJj8zfm0CDaM16uKjDOu3UzsZWZqZ3XQKm0g6Iy3mDdbnlPUeBMBqcImSPJcR7R313eidSYhH6CayeC/liLwi1dRTpo1yf/yB/rckwHN4+ax6kTVEvUOemev85wMpagbSnaG2gvBQUQxopnxibWWurLtsgoTBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=VIYCprDn; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="VIYCprDn"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f2b2ecba;
	Wed, 31 Dec 2025 23:11:13 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus.Elfring@web.de,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH v3 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
Date: Wed, 31 Dec 2025 15:11:06 +0000
Message-Id: <20251231151109.362373-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b74f68c6d03a1kunmad4383ff1aba39
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZGElPVktOTUNNSxgaGUoZGlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=VIYCprDnRbHuS7sA4GF986Ig7kzooinbbtG1dyC7CqRKlFb3p6i082p0NkB0dR5d48OiYZlfXf0j+8ln5d+A0jzEAJZw1KILkD9lPlSPy2Hi4tx21hmd2sdqeiAVH0wXhZ29+ei3PY1ygeXV2o4eTMXSU5kAhQOSa362GWyMNb0=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=IoyGeNlpa6TqDCg3NAi3Ytx3a7sCGStg/sB/RQWe+Wc=;
	h=date:mime-version:subject:message-id:from;

This series fixes three independent memory leaks in the lpfc driver.
All of them occur in error handling paths where allocated memory
was not properly freed before returning.

These issues were identified during static analysis.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>

Changes in v3:
- Patch 1: Remove unnecessary braces for single-line if statement.
- Patch 2: No changes.
- Patch 3: No changes.

Changes in v2:
- Patch 1: Refactor error handling to use a goto label for cleanup.
- Patch 2: No changes.
- Patch 3: No changes.

Zilin Guan (3):
  scsi: lpfc: Fix memory leak in lpfc_config_port_post()
  scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
  scsi: lpfc: Fix memory leak in lpfc_cmpl_plogi_plogi_issue()

 drivers/scsi/lpfc/lpfc_init.c      | 25 +++++++++++++------------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  4 +++-
 2 files changed, 16 insertions(+), 13 deletions(-)

-- 
2.34.1

