Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="meQcnt+x"
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3C7EBE;
	Wed, 29 Nov 2023 07:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=feMp/yQdhv1cPkfaZT
	swMPfvGgf29QwDsfVs7q/7umg=; b=meQcnt+xpXwd4m9WQE94rE3uXOU9rxyby3
	nCUuPH1Jmj8w+ncT1y6F9uYoaN806rnOYheXjvJnj1241XXTv79QDufXln9BrUDG
	/3jJ+Q0te7YPGdQVn7IH1DOGXjpffx6uMc5mxKGsH1c8T1qC8pgIm29BMNWFNN1V
	6zShKMRU0=
Received: from localhost.localdomain (unknown [39.144.190.126])
	by zwqz-smtp-mta-g4-4 (Coremail) with SMTP id _____wC3njG5VGdlx_XzEA--.39554S2;
	Wed, 29 Nov 2023 23:11:55 +0800 (CST)
From: Haoran Liu <liuhaoran14@163.com>
To: jejb@linux.ibm.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoran Liu <liuhaoran14@163.com>
Subject: [PATCH] [scsi] sni_53c710: Add error handling in snirm710_probe
Date: Wed, 29 Nov 2023 07:11:52 -0800
Message-Id: <20231129151152.34829-1-liuhaoran14@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:_____wC3njG5VGdlx_XzEA--.39554S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kry7ur4fKF18JryDCrW3Wrg_yoW8Wr45p3
	9xGw45Ca97GF1xA343Xa18u3Z0yaySkrZrK3W7W3sI9a1rJFyYqr4SyFyagFW8GrWktF4U
	Xr1UtFWI93WDCa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRa9akUUUUU=
X-CM-SenderInfo: xolxxtxrud0iqu6rljoofrz/1tbiZRo3gl8ZaQ-qYQAFsk
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The patch adds checks for the return values of dma_set_mask and ioremap.
Previously, the function did not handle potential failures of these calls,
which could lead to improper device initialization and unpredictable
behavior.

Although the error addressed by this patch may not occur in the current
environment, I still suggest implementing these error handling routines
if the function is not highly time-sensitive. As the environment evolves
or the code gets reused in different contexts, there's a possibility that
these errors might occur. Addressing them now can prevent potential
debugging efforts in the future, which could be quite resource-intensive.

Signed-off-by: Haoran Liu <liuhaoran14@163.com>
---
 drivers/scsi/sni_53c710.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 678651b9b4dd..41414d0c64f8 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -69,8 +69,19 @@ static int snirm710_probe(struct platform_device *dev)
 		return -ENOMEM;
 
 	hostdata->dev = &dev->dev;
-	dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
+	rc = dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
+	if (rc) {
+		printk(KERN_ERR "snirm710: dma_set_mask failed!\n");
+		goto out_kfree;
+	}
+
 	hostdata->base = ioremap(base, 0x100);
+	if (!hostdata->base) {
+		printk(KERN_ERR "snirm710: ioremap failed!\n");
+		rc = -ENOMEM;
+		goto out_kfree;
+	}
+
 	hostdata->differential = 0;
 
 	hostdata->clock = SNIRM710_CLOCK;
-- 
2.17.1

