Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1908183CD5;
	Thu,  8 Aug 2024 05:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723096507; cv=none; b=M7GNloHXCmQLd/Dflc+ScnBmcVhfjSBGXrpLH28kkn5wy/CletrZp+in9mlwEc5LwTb7Fov9tsXcnNoXD9dSJ34ZvbSho4KS8+eidJNdycMVAuXZuTmLBySaNpX46Znv7Yv2jJEIoiv9beePaOumUMX4EcIaUpTxVT3LELO3WqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723096507; c=relaxed/simple;
	bh=d/YDeM3gBlId/zLD9YGyTJEGALHdfOuvwu8J/aYD0+U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HrS049+LqMkXkBs49WDzYUELRkAEGMS+1+JmAwus2LiaSt2JTafA6/G4F+hjt7ylClvA17PADTusfMsNMdZAn/GC5Cl1005PHGIJOzSnkaluph/g41rtw3eeqobyinvoeG5ok0IvHpdXbHleIIvqgPgDhUe3Latv/pbsg0QWX48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from icess-ProLiant-DL380-Gen10.. (unknown [183.174.60.14])
	by APP-05 (Coremail) with SMTP id zQCowACnjjl6XbRmqPFZBA--.19447S2;
	Thu, 08 Aug 2024 13:54:17 +0800 (CST)
From: Ma Ke <make24@iscas.ac.cn>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	ahalaney@redhat.com,
	beanhuo@micron.com,
	subhashj@codeaurora.org,
	quic_asutoshd@quicinc.com,
	vviswana@codeaurora.org,
	quic_cang@quicinc.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ma Ke <make24@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: ufs: Add missing check for alloc_ordered_workqueue
Date: Thu,  8 Aug 2024 13:54:00 +0800
Message-Id: <20240808055400.2784028-1-make24@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACnjjl6XbRmqPFZBA--.19447S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr1DKryrtFW3uFyUKFWfKrg_yoWfXFb_Cr
	ZxXr9Fy3yDKr4Dur1xJry3XrWrKay8Zr18Xa9avFZxJrykZF1Sq3yDZ395ur43ua98Xrnr
	Cr40yr98uwsrWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbSkFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28Icx
	kI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2Iq
	xVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42
	IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
	CY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRiSfO3UUUUU==
X-CM-SenderInfo: ppdnvj2u6l2u1dvotugofq/

As it may return NULL pointer and cause NULL pointer dereference. Add check
for the return value of alloc_ordered_workqueue.

Cc: stable@vger.kernel.org
Fixes: 10e5e37581fc ("scsi: ufs: Add clock ungating to a separate workqueue")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5e3c67e96956..41842f2cd454 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2139,6 +2139,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 		 hba->host->host_no);
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
 					WQ_MEM_RECLAIM | WQ_HIGHPRI);
+	if (!hba->clk_gating.clk_gating_workq)
+		return;
 
 	ufshcd_init_clk_gating_sysfs(hba);
 
-- 
2.25.1

