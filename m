Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8543C2D8379;
	Tue, 30 Dec 2025 03:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767064524; cv=none; b=BxUDd+8cc6gJp/k9ehtLAqW+jIGR8ZfhO3Ql4zJX+MuJkIam8ySPgLgQBPA+KqLG9blQP6DXEJaxFr/BNiHGA6UXl0SvtoLF6Jv0SSUAX750hPzN8q00voPqjna522+ee8CqJBUp8r2IRTpwY9W3WOMCgToU4lOIPNsLRWhXFVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767064524; c=relaxed/simple;
	bh=DXr8T2sKpB/jB9nFlua7fLhlLNBZayT+wAlQcNB4Km0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nG3IjtMTq3oSCa18JYm2j7g/131iHeCD+9ZcSxw7yKP9r+bxonB5qNcRJpWBCU3lSORAu800Z7bgzcLD+hmR/c8JVRwPkJigYWJiqY/glQjCAJMPSZrlxmTQBDIsbaPcVqk4/k9HxMHogFP2ytAcH1zUnm05hEEMsydv8n0TojQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S.localdomain (unknown [124.16.141.245])
	by APP-05 (Coremail) with SMTP id zQCowAD3ig63Q1NpI8h1Ag--.37826S2;
	Tue, 30 Dec 2025 11:15:06 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] scsi: mpt3sas: Fix invalid NUMA node index
Date: Tue, 30 Dec 2025 11:14:16 +0800
Message-ID: <20251230031416.55328-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3ig63Q1NpI8h1Ag--.37826S2
X-Coremail-Antispam: 1UD129KBjvdXoW7GF47GF4kAr48Jw1fGw4rZrb_yoWkXwc_Xr
	WIgFZ7t34UCF4Sv3W09345ur90vFW8Xw1q9FsavasxZFZ5ursrXrsxZw15Gr4Uuay7K34U
	CryUC3yfCr17ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQ8MA2lTL5tN6AAAsi

When dev_to_node() returns NUMA_NO_NODE (-1), passing it directly to
cpumask_of_node() causes an array index out-of-bounds access.

Check for NUMA_NO_NODE and fall back to node 0 if detected.

Fixes: fdb8ed13a772 ("scsi: mpt3sas: Use irq_set_affinity_and_hint()")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0d652db8fe24..3fe071e8490d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3238,7 +3238,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 		 * corresponding to high iops queues.
 		 */
 		if (ioc->high_iops_queues) {
-			mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
+			int nid = dev_to_node(&ioc->pdev->dev);
+
+			if (nid == NUMA_NO_NODE)
+				nid = 0;
+			mask = cpumask_of_node(nid);
 			for (index = 0; index < ioc->high_iops_queues;
 			    index++) {
 				irq = pci_irq_vector(ioc->pdev, index);
-- 
2.43.0

