Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443FF1A23A0;
	Thu,  8 Jan 2026 07:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857585; cv=none; b=eLkx+QKdDW9hqDDjboOM8RSANa7hlEbAbj10vvKeVhLIow9qERU4Zw7Bk02NlEaC6fuQt02FDGP45ZlSxORYdw4p/HUnjGQW/+41dqtjlVrIXRJAa5YblwoPZVL19/jfNvPDChMMhsX1L1FtzGT0RK10XLVVuGsZVWxsevS6olA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857585; c=relaxed/simple;
	bh=4PRYlzB6lFF66PN5L2LiJHO/AHqcK6tDfxBZ1YF0ZbY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LcYk7OfJkuENx9yIwmKE/Cd/OpoicJnuOgdd9DJwXaxoSMFBYefiAjktv4rkmBwentjf0jb6RE38c2VbFUUh3tBCC4icbOd5KCKMpx/G744itLeU7ntxgHVz/+YSa+DZL5BZFtqFZfU9xf9NLFTYW5cICYLwhcvAxNEuUIjnryI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.223])
	by APP-05 (Coremail) with SMTP id zQCowAA3yg2kXV9pnwv4Aw--.12628S2;
	Thu, 08 Jan 2026 15:32:52 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: don.brace@microchip.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	jbottomley@parallels.com,
	scameron@beardog.cce.hp.com
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] hpsa: fix a memory leak in hpsa_find_cfgtables()
Date: Thu,  8 Jan 2026 15:32:51 +0800
Message-Id: <20260108073251.315271-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3yg2kXV9pnwv4Aw--.12628S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw17ZF4xZry5ur47Jw1DKFg_yoWDurc_ua
	yj9rnFq3yDKFsFkw13AF93ZFya9F4UXr109rnIqa4ayw1rXrnFvryDZr95Zr48WF48Jr1D
	Ww1DJ3yak3WUAjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUb_Ma5UUUUU==
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiDAUBE2lfT9MtJgAAs6

If write_driver_ver_to_cfgtable() fails, add iounmap() to
release the memory allocated by remap_pci_mem().

Found by manual static code review.

Fixes: 580ada3c1e2f ("[SCSI] hpsa: do a better job of detecting controller reset failure")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
Changes in v2:
- replace iounmap with unified release method. Thanks, Greg!
---
 drivers/scsi/hpsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3654b12c5d5a..e38d4a7488f8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7646,8 +7646,10 @@ static int hpsa_find_cfgtables(struct ctlr_info *h)
 		return -ENOMEM;
 	}
 	rc = write_driver_ver_to_cfgtable(h->cfgtable);
-	if (rc)
+	if (rc) {
+		hpsa_free_cfgtables(h);
 		return rc;
+	}
 	/* Find performant mode table. */
 	trans_offset = readl(&h->cfgtable->TransMethodOffset);
 	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
-- 
2.25.1

