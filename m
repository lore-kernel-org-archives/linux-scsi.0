Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8576618643;
	Sat, 27 Jul 2024 20:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722112660; cv=none; b=P0bjI3DuLMT5XSoHU+b/bCA1Lpc8zG0YI/xcJ6Vp9i33siQzWqUgfZH1h76vSRzoHGRk42k1m3OPmHwhFMZJE4p0uXuM2+0QrJVJFwFUgYq+11FRt9quXFZTjtyojxy8DRgDsR3qaTyNwJVNWvcgYR3KIXVoqYvehVa/F4H6tFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722112660; c=relaxed/simple;
	bh=0wv8LplG2WHF4iagJpseBcJkythLO5m0vQLh2flInxs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FIv41it9GmdjdR18cWsHrLxI8zro9J8CfmO3mzCAOcwOA4YZNHvkcvLR4/ayWloDwxggpTN5cALsIJtDfj4avWZKKfnbiRcZDLvaEtFbwZBUulZpbmaDbYDmCyrzEOUBdC4TAjjbOiYi68yGIZAMJ4efl1aaej5kDJRHEO2D0q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=U6ej5lWi; arc=none smtp.client-ip=80.12.242.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="U6ej5lWi"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id XoAXsrPVIkc2vXoAXsClW4; Sat, 27 Jul 2024 22:37:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1722112655;
	bh=vIvNRlhJ8J1UYs1bJ4mqG+wbUkdAzoI8r7PqTBxe4YQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=U6ej5lWiSSomDCFhDS+xWGLTsUPjvg/qAq1Eep/eoo04w1fx995girCnmq28SM+P7
	 dMzuPiR3EqUDihnl0ATX+ggOrYxFMT2/EOsOMEwAJwGFoymrYmgFd2b5ugs6vuYPyO
	 YcbH5XJVCpBVl0BeAUVCUtlONz7Dk0dRtYfRCAoXCZcxlvsV0nMFmBNtDqa1ANCT67
	 +YfWj2P87GiTF+5OZApYqSPqgeFv1vhbtwz+CvH2dcpiTjBatRRX2ylQaAmuKmRCWR
	 6DHiBYYg9CVRy95zoabkxm5To9W6wznVEKwXIUYaR0Zi19IawuQ+TWFvlO4GjDfCVm
	 aPo7NQcNSEdUA==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 27 Jul 2024 22:37:35 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Use bitmap_size()
Date: Sat, 27 Jul 2024 22:37:27 +0200
Message-ID: <704d0aade3c8ed4ff64f6ddf81edfb409514be92.1722112623.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use bitmap_size() instead of hand-writing it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/lpfc/lpfc_mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 2697da3248b3..8dfceb0938b0 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -21,6 +21,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#include <linux/bitmap.h>
 #include <linux/mempool.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
@@ -78,8 +79,7 @@ lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
 
 	if (max_xri <= 0)
 		return -ENOMEM;
-	bytes = ((BITS_PER_LONG - 1 + max_xri) / BITS_PER_LONG) *
-		  sizeof(unsigned long);
+	bytes = bitmap_size(max_xri);
 	phba->cfg_rrq_xri_bitmap_sz = bytes;
 	phba->active_rrq_pool = mempool_create_kmalloc_pool(LPFC_MEM_POOL_SIZE,
 							    bytes);
-- 
2.45.2

