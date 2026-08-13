Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996FF1B4257;
	Thu, 13 Aug 2026 14:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786632585; cv=none; b=DtWweh6by6AXzTaTau0Bn9A4jGJRUIff60vHNpNhWZlNuMbDUVBGaYaYjiVsSim+F2rQ7O3cdgAmJWFKQkbMrRL7kGiP+V+BMq8aSZryKV8EzD5C8QmrEYLjGndjB2Ff7j45NG8EuXiFldkH6/Y0xq89asUPXJSc4bcH7+/AOJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786632585; c=relaxed/simple;
	bh=C7JPgZNL+0+W6W7J++xewlWJfycZ/5QeG/LLRbwGFFI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tJjQtr8BNZ9srqoWIBaghIpBm/HCT1a6glkD8zBYb9uCeKf5Rdey1PfOqBMkZSN/iVkzQq70Ikll6uf1tD1pcfH6zEu7y2vEAZlkzfdEo2ItPeubP7JAnrykiieR/T5c3nMTMwiWw8CJA2+DIZeR9PaxYGaG1DW0QK2J+XzrSkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S.localdomain (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAXHz182X1qsT4vBQ--.25114S2;
	Thu, 13 Aug 2026 22:49:33 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: brking@us.ibm.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: ipr: fix out-of-bounds read in __ipr_format_res_path()
Date: Thu, 13 Aug 2026 22:46:14 +0800
Message-ID: <20260813144614.5081-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAXHz182X1qsT4vBQ--.25114S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKw1fJrWDAF43CrykGw1UGFg_yoWkXFb_Gr
	WDJrZrA3WUCry7Ga1F9FWSvrWq9a4DK3W8CrnIqryfAF4I9r93Zwn3Wr9xXrsrWrWYqa9r
	ZwsrZFW0yr17ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdKsbUUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRUSA2p9uBcqdAABsq

The loop in __ipr_format_res_path() reads res_path[i] before checking
i against IPR_RES_PATH_BYTES, so an adapter-supplied resource path
without a 0xff terminator in its 8 bytes causes a read one byte past
the array.

Move the index check before the element access so the loop stops at
the array boundary.

Fixes: 3e7ebdfa58dd ("[SCSI] ipr: update the configuration table code for the next generation chip")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/scsi/ipr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index dbd58a7e7bc1..3cb8fb02d706 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1217,7 +1217,7 @@ static char *__ipr_format_res_path(u8 *res_path, char *buffer, int len)
 
 	*p = '\0';
 	p += scnprintf(p, buffer + len - p, "%02X", res_path[0]);
-	for (i = 1; res_path[i] != 0xff && i < IPR_RES_PATH_BYTES; i++)
+	for (i = 1; i < IPR_RES_PATH_BYTES && res_path[i] != 0xff; i++)
 		p += scnprintf(p, buffer + len - p, "-%02X", res_path[i]);
 
 	return buffer;
-- 
2.43.0

