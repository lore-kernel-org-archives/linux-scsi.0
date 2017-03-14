From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi] scsi: ufshcd-platform: remove the useless cast in ERR_PTR/IS_ERR
Date: Tue, 14 Mar 2017 14:19:36 +0200
Message-ID: <20170314121936.1360-1-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

IS_ERR and ERR_PTR already forcefully cast their argument,
hence there is no need for additional (complex) casting.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index a72a4ba78125..8e5e6c04c035 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -309,8 +309,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mmio_base = devm_ioremap_resource(dev, mem_res);
-	if (IS_ERR(*(void **)&mmio_base)) {
-		err = PTR_ERR(*(void **)&mmio_base);
+	if (IS_ERR(mmio_base)) {
+		err = PTR_ERR(mmio_base);
 		goto out;
 	}
 
-- 
2.9.3
