Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CD42BD0B;
	Sun, 25 Jan 2026 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769353375; cv=none; b=WjWb5WeBy1fjseu8pQzRqJNp6wg8FqNIN/d+sWBBx06vvkzExvPBptcEHRm4R8Q7mpBsoAM/DbBgTz2xDIfSDD9qMtAvAAex7/8X6cvOidZjCoRg9MjsHr5jO5R/xUiM3MF5D2gOJCcY/xFJaatbrdeJIw1Yz40Q9zU0WujkEqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769353375; c=relaxed/simple;
	bh=IdTNu+xJ3THNwGdlT/wchKakuV0n8mN7P9/+NvuiGLA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gg9/9FohuDivo7SOSZjWkPT/HMTnYtgO+YYDCklwqvelDH71sh/1jGapieH7UhFyJEMhrFmiP0dWaXS60zkuWIqjhiGzyLTs95I/sUIzYIHkqc9jl7JbScqWv7Uvz5f60WhlUdQtW+LULeeWql1YY62iBAt0G1k5PBgPRveP/aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.223])
	by APP-03 (Coremail) with SMTP id rQCowACnx96VMHZpOFmuBg--.51200S2;
	Sun, 25 Jan 2026 23:02:46 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: don.brace@microchip.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Subject: [PATCH] scsi: hpsa: add return value check for remap_pci_mem()
Date: Sun, 25 Jan 2026 23:02:44 +0800
Message-Id: <20260125150244.2115157-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnx96VMHZpOFmuBg--.51200S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JryxKry3Gr4fuFWrtw15twb_yoW3WFg_W3
	yIvwnayrZFyFn2kFsxAw13ZryYvw45Xr409r4v9a4Sk3yrXF15CrWxZrs5Zrn7Gr4rXFyD
	Jw1qqrWfC3WUCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjJ73PUUUU
	U==
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiBg0SE2l1qXukVQAAs1

In hpsa_enter_performant_mode(), add return value check
for remap_pci_mem() to prevent potential null pointer
dereference.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
 drivers/scsi/hpsa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3654b12c5d5a..f3118695f320 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9323,6 +9323,8 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 					cfg_offset + bft2_offset,
 					ARRAY_SIZE(bft2) *
 					sizeof(*h->ioaccel2_bft2_regs));
+		if (!h->ioaccel2_bft2_regs)
+			return -ENODEV;
 		for (i = 0; i < ARRAY_SIZE(bft2); i++)
 			writel(bft2[i], &h->ioaccel2_bft2_regs[i]);
 	}
-- 
2.25.1

