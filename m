Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DBF30E82E;
	Thu, 20 Nov 2025 03:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763609851; cv=none; b=SZJC5j6Si5iaKJUwIvSUyZTrp2Odegz0LsN4tpDDjRJPFeRHXV+HZwsBasmeumhGEJCgILZO8bkLdFx8AiTHD1lHYFimdy2G8jylcoSfqy0asBnK0wyAYq9yosjuLnigOG3osCtUXjLCHJ8RCdbkz9G2qrx5C+R3fC10I3P+I74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763609851; c=relaxed/simple;
	bh=Y4WqIXtrH6PXtWg9Be/n4/CHydCBwn2CV5p7b7043Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IWNY5HJQzzVxPeO7+hwsgoTB3GUATA4pcasKErn9rIXf56orIFiTe19M0+fkzWd8Ig+lpVwp4W48lAp1/HF1JxN8Y9YQ4tGlpR+0Scf+THwzpAb5qzWUPM6Wg8/RMwTtYKqKRe9hNoxxNTBJJQmDN2B/IDRs3my6DTNfXiqqvZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-01 (Coremail) with SMTP id qwCowACXL8_wjB5prSNRAQ--.4598S2;
	Thu, 20 Nov 2025 11:37:20 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] scsi: mpt3sas: Fix debugfs error checking
Date: Thu, 20 Nov 2025 11:35:10 +0800
Message-ID: <20251120033510.2050-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACXL8_wjB5prSNRAQ--.4598S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW3Gr47XrWDGFW7WFW7Arb_yoW8Zr43pa
	yDC345Jrn5Cw43J3s3Cw45JryfG3ykWrnFgrW09ayrAwn7AryFvFy8CrWDG340gF95Xw4D
	XF45J34Yga17KF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUtVW8ZwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUYb10UUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAcMA2keX-qlJgABsU

The debugfs_create_dir() and debugfs_create_file() functions return
ERR_PTR() on error, not NULL. The current null-checks fail to detect
errors because ERR_PTR() encodes error codes as non-null pointer values.

Replace the null-checks with IS_ERR() for debugfs_create_dir() and
debugfs_create_file() calls to properly handle errors.

Fixes: 2b01b293f359 ("scsi: mpt3sas: Capture IOC data for debugging purposes")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
index a6ab1db81167..88fc10ad03fc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
@@ -99,7 +99,7 @@ static const struct file_operations mpt3sas_debugfs_iocdump_fops = {
 void mpt3sas_init_debugfs(void)
 {
 	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
-	if (!mpt3sas_debugfs_root)
+	if (IS_ERR(mpt3sas_debugfs_root))
 		pr_info("mpt3sas: Cannot create debugfs root\n");
 }
 
@@ -124,7 +124,7 @@ mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc)
 	if (!ioc->debugfs_root) {
 		ioc->debugfs_root =
 		    debugfs_create_dir(name, mpt3sas_debugfs_root);
-		if (!ioc->debugfs_root) {
+		if (IS_ERR(ioc->debugfs_root)) {
 			dev_err(&ioc->pdev->dev,
 			    "Cannot create per adapter debugfs directory\n");
 			return;
@@ -134,7 +134,7 @@ mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc)
 	snprintf(name, sizeof(name), "ioc_dump");
 	ioc->ioc_dump =	debugfs_create_file(name, 0444,
 	    ioc->debugfs_root, ioc, &mpt3sas_debugfs_iocdump_fops);
-	if (!ioc->ioc_dump) {
+	if (IS_ERR(ioc->ioc_dump)) {
 		dev_err(&ioc->pdev->dev,
 		    "Cannot create ioc_dump debugfs file\n");
 		debugfs_remove(ioc->debugfs_root);
-- 
2.50.1.windows.1

