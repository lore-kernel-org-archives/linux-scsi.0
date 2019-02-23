From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 51/72] scsi: 53c700: pass correct "dev" to dma_alloc_attrs()
Date: Sat, 23 Feb 2019 16:04:01 -0500
Message-ID: <20190223210422.199966-51-sashal@kernel.org>
References: <20190223210422.199966-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190223210422.199966-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8437fcf14deed67e5ad90b5e8abf62fb20f30881 ]

The "hostdata->dev" pointer is NULL here.  We set "hostdata->dev = dev;"
later in the function and we also use "hostdata->dev" when we call
dma_free_attrs() in NCR_700_release().

This bug predates git version control.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/53c700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 6be77b3aa8a5f..ac79f2088b316 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -295,7 +295,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	if(tpnt->sdev_attrs == NULL)
 		tpnt->sdev_attrs = NCR_700_dev_attrs;
 
-	memory = dma_alloc_attrs(hostdata->dev, TOTAL_MEM_SIZE, &pScript,
+	memory = dma_alloc_attrs(dev, TOTAL_MEM_SIZE, &pScript,
 				 GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
 	if(memory == NULL) {
 		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detaching\n");
-- 
2.19.1
