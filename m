Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8D280A52;
	Thu, 20 Nov 2025 03:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763608891; cv=none; b=hT3aC5AOMczkXqprrJC0UHEW8++Fk84FOFjAfvBtvYmVxq/TNV+7GzRuHqBKYV9e5MNs+o93F++JCX7A/0OriQ59IxtTmax4VgfUJ5DzMx1IBSxenI26HbE+hbqBzMmOuSrc0iNl6SnLQIBEtAZ//TcNGzfv5ognVVALMWIS6Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763608891; c=relaxed/simple;
	bh=LJz0CVel82o4FxscXE0X1/ET8ofYjJDoD10kei/Z3gk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l2qu6nVeDhrV7BzZYvMfuROIsTa6A+vgjgMlfsxV3fi5qevkDFeCXoFNUjng18DjcV8wm5/XigUVvEvA8dubHTtmc/LNBzJPDdmoLjz5MSYke2+PwkHhrYoaXol+6SwS+cTPd4vRpmSAQE35YZ9hfEil393rr3a3yC1cwUjU99E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-01 (Coremail) with SMTP id qwCowADXcNAviR5pBNhQAQ--.19681S2;
	Thu, 20 Nov 2025 11:21:21 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: martin.petersen@oracle.com
Cc: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH v2] scsi: megaraid_sas: Fix debugfs error checking
Date: Thu, 20 Nov 2025 11:20:47 +0800
Message-ID: <20251120032048.572-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADXcNAviR5pBNhQAQ--.19681S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW3Gr47Xr4fXF47ur45Wrg_yoW8uryrpa
	ykGw15tr18Aw1rZr90ka1UJFyfA3ykX3sIgry093yYyw1v9r1avF4UKrW5CFyxWrZ5X3WU
	Xr45Xw18AF45KaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7Cj
	xVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67AK6r48MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb7DG7UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwwMA2keYBSgUwABs1

The debugfs_create_dir() and debugfs_create_file() functions return
ERR_PTR() on error, not NULL. The current null-checks fail to detect
errors because ERR_PTR() encodes error codes as non-null pointer values.

Replace the null-checks with IS_ERR() for debugfs_create_dir() and
debugfs_create_file() calls to properly handle errors.

Fixes: ba53572bf02d ("scsi: megaraid_sas: Export RAID map through debugfs")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
Changes in v2:
  -Also fix the check in megasas_init_debugfs().
---
 drivers/scsi/megaraid/megaraid_sas_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_debugfs.c b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
index c69760775efa..e2ed771df549 100644
--- a/drivers/scsi/megaraid/megaraid_sas_debugfs.c
+++ b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
@@ -102,7 +102,7 @@ static const struct file_operations megasas_debugfs_raidmap_fops = {
 void megasas_init_debugfs(void)
 {
 	megasas_debugfs_root = debugfs_create_dir("megaraid_sas", NULL);
-	if (!megasas_debugfs_root)
+	if (IS_ERR(megasas_debugfs_root))
 		pr_info("Cannot create debugfs root\n");
 }
 
@@ -132,7 +132,7 @@ megasas_setup_debugfs(struct megasas_instance *instance)
 		if (!instance->debugfs_root) {
 			instance->debugfs_root =
 				debugfs_create_dir(name, megasas_debugfs_root);
-			if (!instance->debugfs_root) {
+			if (IS_ERR(instance->debugfs_root)) {
 				dev_err(&instance->pdev->dev,
 					"Cannot create per adapter debugfs directory\n");
 				return;
@@ -144,7 +144,7 @@ megasas_setup_debugfs(struct megasas_instance *instance)
 			debugfs_create_file(name, S_IRUGO,
 					    instance->debugfs_root, instance,
 					    &megasas_debugfs_raidmap_fops);
-		if (!instance->raidmap_dump) {
+		if (IS_ERR(instance->raidmap_dump)) {
 			dev_err(&instance->pdev->dev,
 				"Cannot create raidmap debugfs file\n");
 			debugfs_remove(instance->debugfs_root);
-- 
2.50.1.windows.1

