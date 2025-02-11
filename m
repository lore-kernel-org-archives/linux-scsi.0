Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F93320F;
	Tue, 11 Feb 2025 12:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739278044; cv=none; b=d+Ng/gxlHG468P5oeymftS/OS9RMqgLK/XC4BL+2/h/T1h4NNnvfiSywi/aYJE9Xp9EqQYs4pTFYUe+dMpk5yuFzSbrCMNIvb6ENXQ7vDaGVqywRkK/lsaLVRzfb7aaRSrUkhspWhYjXKcF1faKBp4wlI5gBcrUfSM/k70Fv+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739278044; c=relaxed/simple;
	bh=F8LGObnvBTpqNcSDHt3VrgCp2xoVpc+m9MB9e8wkevc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tYvn35Ms8j7k8d6UuPsoCCSV3ji4UP4eTwV0NPOpRhXh/NMsMJvDGOMmG8fcvNSA0cLQKTFlfhH9lEGJKYXCznPN+s7e7VqQc2tzF+6HKl8noET++5LqEOE4iiWMlrYlplII6fEYgIf5vkZAkAOg3/czmVuN9w4ZPY3iFvRVDdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [124.16.141.245])
	by APP-01 (Coremail) with SMTP id qwCowAAXHdGSRatnYL5tDA--.53184S2;
	Tue, 11 Feb 2025 20:41:55 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: don.brace@microchip.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH] scsi: hpsa: Fix missing error check for hpsa_scsi_do_simple_cmd_with_retry()
Date: Tue, 11 Feb 2025 20:33:09 +0800
Message-ID: <20250211123309.723-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAXHdGSRatnYL5tDA--.53184S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtFWfAFW7XryUCw13uw4DJwb_yoW8JF13pF
	Z5W3s7CasrCw1xKFs7Xw4kury5Aa4UWryUWay8G3y7Z3Z3ZryFvFyakry5Way8CrW8Arnx
	tryqvFyrC3WUC3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjJ73PUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwsKA2erODorlwAAs3

In the current implementation, the return value of
hpsa_scsi_do_simple_cmd_with_retry() is not checked. This can lead to
silent failures if the function fails, as the code would continue
execution and potentially use invalid error information.

This patch adds a check for the return value of
hpsa_scsi_do_simple_cmd_with_retry(). If the function fails, the error
is propagated to the caller, ensuring proper error handling.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/hpsa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0c49414c1f35..79171813bc32 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3424,8 +3424,11 @@ static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
 	c->Request.CDB[2] = bmic_device_index & 0xff;
 	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
 
-	hpsa_scsi_do_simple_cmd_with_retry(h, c, DMA_FROM_DEVICE,
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c, DMA_FROM_DEVICE,
 						NO_TIMEOUT);
+	if (rc)
+		goto out;
+
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
-- 
2.42.0.windows.2

