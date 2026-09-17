Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6BF3A1A56;
	Thu, 17 Sep 2026 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660899; cv=none; b=uKCh9rHkpQkblNxE6kL4EWZSSNXEP/JTZjLGtLYmgXQzGvgyEQI8n8t+km747R5JeZ8hNWcJworMW55e3+Ah6lZWJ+6UtOyhhkdvOlN0ib6lyk5JwMG+Svv7em9EPwzQxTwnh9/+AbJbD7pFb0JyVmW1jH0xctQooFYnDIgX6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660899; c=relaxed/simple;
	bh=2WL+TixSTzFVZfjCLOYF3RUzf13SgJtLGAxZFY7ta4U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TlI/CeORlesTri8abY3PFor0OVfntwVi9zzpPAPFVHIWimlJUMwP7KAxIfomQkt0+lWsyRtbn+DO6qRSjjuiO3JH0dGx5oE1m09yRLjJy9yzojdLhntlqadFVPY+lPUVD0v2VnPjHqH6/MEuMoQ/vgzt/7zGndfJRUWB8DEJtLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAD3YDvWDqxqiw6ECA--.17S2;
	Fri, 18 Sep 2026 00:01:26 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: JBottomley@Parallels.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	santoshsy@gmail.com,
	sthumma@codeaurora.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: ufs: core: Fix runtime PM reference leak in ufshcd_init()
Date: Thu, 17 Sep 2026 16:01:26 +0000
Message-Id: <20260917160126.2161457-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3YDvWDqxqiw6ECA--.17S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1Utw43CF13GrW8tFWUurg_yoW8tr15pr
	ZFq3yYvr1rWF4ayw1xtr48WFWFga1fG34UGr4v9a47Ww1YkFnrXas5Kr1FqF45GrW3Za9x
	JFn2yw15XFy0yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Gr43Wr1UJr
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUblAp5UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgMNA2qr889AwQAAs3

ufshcd_init() calls pm_runtime_get_sync() to hold auto suspend until the
asynchronous scan completes, and that reference is only dropped in
ufshcd_async_scan(). If initialization fails before the scan is
scheduled, no one ever drops it and the device stays runtime resumed.

Route all error paths taken after pm_runtime_get_sync() through a new
out_put_rpm label that drops the reference.

Fixes: 62694735ca95 ("[SCSI] ufs: Add runtime PM support for UFS host controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..6aee54788d29 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11236,7 +11236,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	err = ufshcd_link_startup(hba);
 	if (err)
-		goto out_disable;
+		goto out_put_rpm;
 
 	if (hba->mcq_enabled)
 		ufshcd_config_mcq(hba);
@@ -11253,23 +11253,23 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Verify device initialization by sending NOP OUT UPIU */
 	err = ufshcd_verify_dev_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_put_rpm;
 
 	/* Initiate UFS initialization, and waiting until completion */
 	err = ufshcd_complete_dev_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_put_rpm;
 
 	err = ufshcd_device_params_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_put_rpm;
 
 	err = ufshcd_post_device_init(hba);
 
 initialized:
 	ufshcd_process_probe_result(hba, probe_start, err);
 	if (err)
-		goto out_disable;
+		goto out_put_rpm;
 
 	ufs_sysfs_add_nodes(hba->dev);
 	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
@@ -11280,6 +11280,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufshcd_pm_qos_init(hba);
 	return 0;
 
+out_put_rpm:
+	pm_runtime_put_sync(dev);
+
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
-- 
2.34.1

