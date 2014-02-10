From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] [SCSI] arcmsr: upper 32 of dma address lost
Date: Mon, 10 Feb 2014 18:18:19 +0300
Message-ID: <20140210151819.GA23898@elgon.mountain>
References: <20140207130028.GA6971@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140207130028.GA6971@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Nick Cheng <nick.cheng@areca.com.tw>
Cc: Jingoo Han <jg1.han@samsung.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The original code always set the upper 32 bits to zero because it was
doing a shift of the wrong variable.

Fixes: 1a4f550a09f8 ('[SCSI] arcmsr: 1.20.00.15: add SATA RAID plus other fixes')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Add a cast to u64 to avoid a future static checker warning

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4f6a30b8e5f9..9cfd399c47c0 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2500,16 +2500,15 @@ static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
 	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
-	dma_addr_t dma_coherent_handle;
+
 	/*
 	********************************************************************
 	** here we need to tell iop 331 our freeccb.HighPart
 	** if freeccb.HighPart is not zero
 	********************************************************************
 	*/
-	dma_coherent_handle = acb->dma_coherent_handle;
-	cdb_phyaddr = (uint32_t)(dma_coherent_handle);
-	cdb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
+	cdb_phyaddr = (uint32_t)(acb->dma_coherent_handle);
+	cdb_phyaddr_hi32 = (uint32_t)((u64)acb->dma_coherent_handle >> 32);
 	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
 	/*
 	***********************************************************************

