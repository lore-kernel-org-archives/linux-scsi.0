Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352552773CA;
	Wed, 27 May 2026 08:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779869015; cv=none; b=TWEHS8HaCeWskWbPJa83ZCHnYADUJS2Z06+PngxJrVdwt0qKavyMZ3TrVfeGgu8xYH+xfG43ZHYPT0CFAQDWkZeR/CBLn6l3CE4EEAymUVmFGDoxfxrRlnjn1Fhe7SxXGg68bU0mqIpLxmAcRrm05RVpVA0sqBCk4GaMBEHqjbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779869015; c=relaxed/simple;
	bh=S6mq/S+uDo8ws+FVAdz/OEhCkMIl/1/PwP8X6TOkemU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k65Q7wWca3idObezuINkjuz/K4aiUaeX7gyCwUMPz/LSwSh3cDxt/tMaMtMk82GbQY/DG+W6Ci/h31MhFg3Vn28/TLx724fJ0eTB7Pvu3434p+k+daBM2HCGRmOoQxqGO24bmZRnpg+kkXCjAMVJBwP04hOsL/wQuqsu7bhl6E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.223])
	by APP-03 (Coremail) with SMTP id rQCowABHaN9JpRZqHlmIEg--.8338S2;
	Wed, 27 May 2026 16:03:22 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: skashyap@marvell.com,
	jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: bnx2fc: unmap DMA mappings when BD count exceeds firmware limit
Date: Wed, 27 May 2026 16:03:21 +0800
Message-Id: <20260527080321.2355821-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABHaN9JpRZqHlmIEg--.8338S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWDuF4DuryrZw13CFW7Jwb_yoWDtrXEkw
	s8tr9Fgryxtr9rKr1v9FZYv34avay7Wryv93WYk34Syw1rXFyDZFWYyrZ8Aw1UWw4xGFn8
	Jas7ZasFkrn8ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q
	6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUU
	U==
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiDAUAE2oWidl8IgAAso

bnx2fc_build_bd_list_from_sg() maps the SCSI SG list before checking
whether the generated BD count exceeds the firmware limit. If the limit
check fails, the function returns an error without unmapping the DMA
mapping.

Unmap the SG list before returning the error.

Fixes: 3c97b569505f ("scsi: bnx2fc: Limit the IO size according to the FW capability")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 33057908f147..5429f127c5b8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1718,6 +1718,7 @@ static int bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req)
 	if (bd_count > BNX2FC_FW_MAX_BDS_PER_CMD) {
 		pr_err("bd_count = %d exceeded FW supported max BD(255), task_id = 0x%x\n",
 		       bd_count, io_req->xid);
+		bnx2fc_unmap_sg_list(io_req);
 		return -ENOMEM;
 	}
 
-- 
2.25.1

