From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] be2iscsi: fix gfp use in alloc_pdu
Date: Fri, 31 Dec 2010 02:22:19 -0600
Message-ID: <1293783742-8238-3-git-send-email-michaelc@cs.wisc.edu>
References: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab0LaIWa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2010 03:22:30 -0500
In-Reply-To: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The pdu allication callout is called from a spin lock
and in the IO path so we cannot use GFP_KERNEL. This
has the driver use GFP_ATOMIC.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 75a85aa..be07ca0 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3785,7 +3785,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	dma_addr_t paddr;
 
 	io_task->cmd_bhs = pci_pool_alloc(beiscsi_sess->bhs_pool,
-					  GFP_KERNEL, &paddr);
+					  GFP_ATOMIC, &paddr);
 	if (!io_task->cmd_bhs)
 		return -ENOMEM;
 	io_task->bhs_pa.u.a64.address = paddr;
-- 
1.7.0.1

