Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1528C1DED7B;
	Thu, 20 Nov 2025 03:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763608586; cv=none; b=GeHGiwH/JrLjX1QZlt5QON84dbc6NTSxtK4RfTj4AF/HfniYVPBzbbkhKsUxveG4Qhov383rBtd70obARJ/Z9CS4KeZRF49EMe9XV8FtIL3bTq2HlcRGbKg2JObkEeIlY3y2Ib56C06Qmx69ga+hozQN2VJSzlagU2mGqHDGUd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763608586; c=relaxed/simple;
	bh=lema7F2x+2n03fK7/nMl0OylzuAhW043cUA9mt55MlE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KNTqzzmiHMchq8mYYrCEOH6eJJ8IDD7CaJiMYYqS6VGuKC9mx59L72PgmArN3j9Q2FTxmUebDYP2+qy9+v1F6u/24+hnEMN1xJmWyjS90OZdwgKoA9PoVOrhUrZsWT6fGaX6Iric+3LS3cn3QXP6Fq1UBHKlUXTwrFtr2CA/4xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-01 (Coremail) with SMTP id qwCowABH28r+hx5pOr9QAQ--.35029S2;
	Thu, 20 Nov 2025 11:16:15 +0800 (CST)
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
Subject: [PATCH] scsi: megaraid_sas: Fix debugfs error checking
Date: Thu, 20 Nov 2025 11:16:08 +0800
Message-ID: <20251120031608.531-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABH28r+hx5pOr9QAQ--.35029S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW3Gr47Xr4fWw13Ar4kXrb_yoW8Ww4Dpa
	ykGr15tr18Aw1rZr909a1UJFyfA3ykX3sIgrW093yYyw4v9r1ayr47KFW5GFyxWrZ5X3WU
	Xr45X348AF4jkaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYb10UUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAYMA2keX-qgPgAAsJ

The debugfs_create_dir() and debugfs_create_file() functions return
ERR_PTR() on error, not NULL. The current null-checks fail to detect
errors because ERR_PTR() encodes error codes as non-null pointer values.

Replace the null-checks with IS_ERR() for debugfs_create_dir() and
debugfs_create_file() calls to properly handle errors.

Fixes: ba53572bf02d ("scsi: megaraid_sas: Export RAID map through debugfs")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/scsi/megaraid/megaraid_sas_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_debugfs.c b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
index c69760775efa..6f0f64dae5d4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_debugfs.c
+++ b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
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

