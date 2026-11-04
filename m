Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759287;
	b=n34FXLVT4XwguVGPLYSTBRn2lIqO/y3bbJOXEXR6tX9U5YbhWWmmYqn3YXdasxOPsaAl
	 cHlTtyT6HZ0W+Qm+8TJf+BlLWaMZCdAmMbuFkjLLP0ufdWTYiDMAer/nD+VWiYhNEMkLi
	 lwMBZF3hFx4mPFqoDCSiAdSEsk9AMjLEZ9iLnb8+UsfLGPBR76pHhC6X4ctzE2wfQAsh4
	 i1TuzuwdnWwDleCpZEIlPmFhOrwKU+p/0px5VcG3T5p1Llxb9PEpr2yZ1hHmTz0GXElSi
	 q5L3GFP319ccyLKjHsYLmnG8xR18Ert0O77W86XVL0Sd87UDU4Lu7e1Wmsa5Vnr6AgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759287;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=uYZxoAtzUyUJccl93uV1S+BTZFTI/6A3Feb99I+0lRI=;
	b=rnIkUB0MYGWS9CgIFcoaeKxs5n1UMsyK8M1ycTA2ioR2I8oboM8anlhqkp7ZTFhZcDMK
	 LBcdDWWSPZEu2bi02/3XVW1tfFPvKIro+orc7OZgQ4etUcM61SsHmeNZIhYI9ToY7NAdB
	 TSwItCfyLT4829pA1khGcrJDF2Gm4cwUY5DPBlr4P28cGPVHmCt713Dg0TqgMa9YCeq5G
	 d3UEkO8xioxt0Rohsh+Kk8HSVFxXrn0J/3Xx14qF8OqCV1eXOw9s/NUEUrOZD4A/fPts7
	 LKbyWw7zQAKN4fUooYo4l0m68b8Ddd9bh7fNNw6RR2BRd6n0pMP261EshiFyaeKRQtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44F9606A335
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C44F9606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAD3H_osmOpqeZs+AA--.29135S2;
	Wed, 04 Nov 2026 10:27:57 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: core: drop the runtime PM reference when probe fails
Date: Wed,  4 Nov 2026 02:28:05 +0000
Message-Id: <20261104022805.1484063-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAD3H_osmOpqeZs+AA--.29135S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyftr43trW8GF1xZw4fXwb_yoW5Jr1UpF
	4vg3yYvF1fWF4Utw12qw109FWFqa1fK343Gr4vya4xGw15KF9xX34kKF1FvF4kGrWfZayU
	XFy7t3WDXFykArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26Fy26r45twAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW7JVWDJwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUknaBUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRQBA2rqY-nHQQABsC

ufshcd_init() takes a runtime PM reference on the controller device
before it brings up the link, and ufshcd_async_scan() drops that
reference once the asynchronous scan has finished.  If link setup or
device initialization fails afterwards, the function returns through
out_release without dropping the reference, leaving the controller
permanently marked as busy and unable to runtime suspend.

Send the failures that occur after the reference is taken through a new
label that drops the reference before the existing cleanup.  Failures
before the reference is taken keep their current path.

Fixes: 62694735ca95 ("[SCSI] ufs: Add runtime PM support for UFS host controller driver")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/ufs/core/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee643830a57a..c098f51020d6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11424,7 +11424,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	err = ufshcd_link_startup(hba);
 	if (err)
-		goto out_release;
+		goto out_rpm_put;
 
 	if (hba->mcq_enabled)
 		ufshcd_config_mcq(hba);
@@ -11441,23 +11441,23 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Verify device initialization by sending NOP OUT UPIU */
 	err = ufshcd_verify_dev_init(hba);
 	if (err)
-		goto out_release;
+		goto out_rpm_put;
 
 	/* Initiate UFS initialization, and waiting until completion */
 	err = ufshcd_complete_dev_init(hba);
 	if (err)
-		goto out_release;
+		goto out_rpm_put;
 
 	err = ufshcd_device_params_init(hba);
 	if (err)
-		goto out_release;
+		goto out_rpm_put;
 
 	err = ufshcd_post_device_init(hba);
 
 initialized:
 	ufshcd_process_probe_result(hba, probe_start, err);
 	if (err)
-		goto out_release;
+		goto out_rpm_put;
 
 	ufs_sysfs_add_nodes(hba->dev);
 	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
@@ -11468,6 +11468,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufshcd_pm_qos_init(hba);
 	return 0;
 
+out_rpm_put:
+	pm_runtime_put_sync(dev);
 out_release:
 	ufshcd_release(hba);
 out_disable:
-- 
2.34.1

