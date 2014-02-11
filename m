From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v3] [SCSI] arcmsr: upper 32 of dma address lost
Date: Tue, 11 Feb 2014 19:06:33 +0300
Message-ID: <20140211160633.GC9406@elgon.mountain>
References: <20140207130028.GA6971@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31022 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaBKQG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2014 11:06:56 -0500
Content-Disposition: inline
In-Reply-To: <20140207130028.GA6971@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Nick Cheng <nick.cheng@areca.com.tw>
Cc: Jingoo Han <jg1.han@samsung.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The original code always set the upper 32 bits to zero because it was
doing a shift of the wrong variable.

Fixes: 1a4f550a09f8 ('[SCSI] arcmsr: 1.20.00.15: add SATA RAID plus other fixes')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v3: In v2 I introduced an expensive cast to solve a static checker
    warning but James noticed and pointed me to the upper_32_bits()
    macro.

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
+	cdb_phyaddr = lower_32_bits(acb->dma_coherent_handle);
+	cdb_phyaddr_hi32 = upper_32_bits(acb->dma_coherent_handle);
 	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
 	/*
 	***********************************************************************

