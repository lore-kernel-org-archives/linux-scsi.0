Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF1428373;
	Mon, 19 Aug 2024 09:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724059468; cv=none; b=mngg0y1khIFDG4WlOOPtKNqvQIJtg15qUU1ETgN/AW78PJshNP8L9bmLPBfFvU8XQ8zXNdlDV7ArsKGm0kkY2dDGHQUfqhMIpwU/8VMxHNe3XDOCeYi9lqqoL1SkdSkgK3RUE+fbWpT28NTQX43HQhMUMxBMLjxdjnzHnkSf0Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724059468; c=relaxed/simple;
	bh=vIACFU5pV7FY3YiEM/69pven583eTZCyLjaDVNt5Vk4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YgxYO1bYJ/69nrjQ7vr5QQDZdfCW0UL04ujUysGVQTtqIN6jAzlgTGkzVKncAHBHqmlMkJCvV3vcEfGbid2DRGYyKQXovLPtSXGe32XI+qnObDNEXE22dMwfP7rklM+8fMy31XcUkBv9IXAeIpvJJ0evH6C5s9MJdXD79CAj6eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from icess-ProLiant-DL380-Gen10.. (unknown [183.174.60.14])
	by APP-03 (Coremail) with SMTP id rQCowACHrwI2D8NmtVkUCA--.44254S2;
	Mon, 19 Aug 2024 17:24:14 +0800 (CST)
From: Ma Ke <make24@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	m.muzzammilashraf@gmail.com,
	make24@iscas.ac.cn,
	James.Bottomley@suse.de,
	kxie@chelsio.com,
	michaelc@cs.wisc.edu,
	akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: iscsi: fix reference count leak in cxgbi_check_route()
Date: Mon, 19 Aug 2024 17:24:05 +0800
Message-Id: <20240819092405.1017971-1-make24@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACHrwI2D8NmtVkUCA--.44254S2
X-Coremail-Antispam: 1UD129KBjvdXoWrur47tw48tFy7uFWDCw1xZrb_yoWfurg_Gw
	48ZFW7Ar4qgrsrKw4I93Z3ZF9xZF9rZFy8uF4xtr9akw45Xr97Kr18AF1rJ345Xw4qgr15
	Aw17Wr13CFnFgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbS8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUl-eOUUUUU=
X-CM-SenderInfo: ppdnvj2u6l2u1dvotugofq/

cxgbi_check_route() dont release the reference acquired by ip_dev_find()
which introducing a reference count leak. We could remedy this by
insuring the reference is released.ip_dev_find().

Cc: stable@vger.kernel.org
Fixes: 9ba682f01e2f ("[SCSI] libcxgbi: common library for cxgb3i and cxgb4i")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
---
 drivers/scsi/cxgbi/libcxgbi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bf75940f2be1..6b0f1e8dac40 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -670,6 +670,7 @@ cxgbi_check_route(struct sockaddr *dst_addr, int ifindex)
 		"route to %pI4 :%u, ndev p#%d,%s, cdev 0x%p.\n",
 		&daddr->sin_addr.s_addr, ntohs(daddr->sin_port),
 			   port, ndev->name, cdev);
+	dev_put(ndev);
 
 	csk = cxgbi_sock_create(cdev);
 	if (!csk) {
-- 
2.25.1

