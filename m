Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7FF27FD6E;
	Wed,  7 Jan 2026 08:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767776197; cv=none; b=hoiJYns4+f+T8lhHdgxUDerS+jFczoqGEreiOiacJi15AcOZMTnjLN0G/tntG2SQVYZ54F8dVVb0S2FdNXuJeIqMdmwSg/YvAJxmcO3eV1nCRx6O8pgLcUDjU1WiYyvbIyhiBiMm5mO1xAbtU+oCG1dixhlAtEvRlp2gani0u+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767776197; c=relaxed/simple;
	bh=JLqRU1DM9H+puKoxb8n2kIdFSelfKpssm+ZS8jbKKc0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AfEkaGNso9K+/tuSIROfZ2oOVU1wIBbEC/ClbrCYVbBmc0cMZVREu76L0BqKjox5kQtsSUFXcbWgWBgB59jl8uJo+n0pjaYfAFeoYSZbo2TC3a8mNvdWQScgyxxV2HYz8wvr6Fc+IVKEAazE5/vGet1qmYC1Opjk+l+laXRTdcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.223])
	by APP-03 (Coremail) with SMTP id rQCowABXWsGzH15pO+vyAw--.10449S2;
	Wed, 07 Jan 2026 16:56:19 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com,
	don.brace@microchip.com,
	martin.petersen@oracle.com,
	jbottomley@parallels.com,
	scameron@beardog.cce.hp.com
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] hpsa: fix a memory leak in hpsa_find_cfgtables()
Date: Wed,  7 Jan 2026 16:56:17 +0800
Message-Id: <20260107085617.3391860-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABXWsGzH15pO+vyAw--.10449S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw17ZFy8GFWxCF4fGF1rJFb_yoWfKrc_ua
	yjvr9Fq3yDKFsrKw13J3s5ZFyY9FyUXF109rnIqa4avw1rXr1YyFWDZFn5Zr48WF48Xw1D
	Wwnrt3yS9a1UZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Jr0_Gr
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
	ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiBwsAE2ld-ed4twAAs+

If write_driver_ver_to_cfgtable() fails, add iounmap() to
release the memory allocated by remap_pci_mem().

Fixes: 580ada3c1e2f ("[SCSI] hpsa: do a better job of detecting controller reset failure")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
 drivers/scsi/hpsa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3654b12c5d5a..4cc129d2d6f2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7646,8 +7646,11 @@ static int hpsa_find_cfgtables(struct ctlr_info *h)
 		return -ENOMEM;
 	}
 	rc = write_driver_ver_to_cfgtable(h->cfgtable);
-	if (rc)
+	if (rc) {
+		iounmap(h->cfgtable);
+		h->cfgtable = NULL;
 		return rc;
+	}
 	/* Find performant mode table. */
 	trans_offset = readl(&h->cfgtable->TransMethodOffset);
 	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
-- 
2.25.1

