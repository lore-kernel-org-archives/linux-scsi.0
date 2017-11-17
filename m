From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH 3/3] scsi: aacraid: Prevent crash in case of free interrupt during scsi EH path
Date: Fri, 17 Nov 2017 19:14:55 -0200
Message-ID: <20171117211455.29031-4-gpiccoli@linux.vnet.ibm.com>
References: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753434AbdKQVPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 16:15:16 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAHLFAZZ135359
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 16:15:16 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ea4rx746w-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 16:15:16 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Fri, 17 Nov 2017 14:15:15 -0700
In-Reply-To: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@microsemi.com, linux-scsi@vger.kernel.org
Cc: gpiccoli@linux.vnet.ibm.com, david.carroll@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, gpiccoli@protonmail.ch

As part of the scsi EH path, aacraid performs a reinitialization of
the adapter, which encompass freeing resources and IRQs, NULLifying
lots of pointers, and then initialize it all over again.
We've identified a problem during the free IRQ portion of this path
if CONFIG_DEBUG_SHIRQ is enabled on kernel config file.

Happens that, in case this flag was set, right after free_irq()
effectively clears the interrupt, it checks if it was requested
as IRQF_SHARED. In positive case, it performs another call to the
IRQ handler on driver. Problem is: since aacraid currently free
some resources *before* freeing the IRQ, once free_irq() path
calls the handler again (due to CONFIG_DEBUG_SHIRQ), aacraid
crashes due to NULL pointer dereference with the following trace:

  aac_src_intr_message+0xf8/0x740 [aacraid]
  __free_irq+0x33c/0x4a0
  free_irq+0x78/0xb0
  aac_free_irq+0x13c/0x150 [aacraid]
  aac_reset_adapter+0x2e8/0x970 [aacraid]
  aac_eh_reset+0x3a8/0x5d0 [aacraid]
  scsi_try_host_reset+0x74/0x180
  scsi_eh_ready_devs+0xc70/0x1510
  scsi_error_handler+0x624/0xa20

This patch prevents the crash by changing the order of the
deinitialization in this path of aacraid: first we clear the IRQ,
then we free other resources. No functional change intended.

Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
---
 drivers/scsi/aacraid/commsup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 2abe8fd83494..bec9f3193f60 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1554,6 +1554,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * will ensure that i/o is queisced and the card is flushed in that
 	 * case.
 	 */
+	aac_free_irq(aac);
 	aac_fib_map_free(aac);
 	dma_free_coherent(&aac->pdev->dev, aac->comm_size, aac->comm_addr,
 			  aac->comm_phys);
@@ -1561,7 +1562,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	aac->comm_phys = 0;
 	kfree(aac->queues);
 	aac->queues = NULL;
-	aac_free_irq(aac);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 
-- 
2.15.0
