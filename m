From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 5/8] be2iscsi: Fix memory corruption in MBX path
Date: Mon,  5 May 2014 21:41:28 -0400
Message-ID: <1399340492-2136-5-git-send-email-jkallickal@emulex.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47466 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629AbaEFBlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 21:41:53 -0400
Received: by mail-pa0-f46.google.com with SMTP id kx10so7700148pab.19
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2014 18:41:52 -0700 (PDT)
In-Reply-To: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
 Sent: Friday, March 28, 2014 1:42 AM
 Subject: re: [SCSI] be2iscsi: Fix handling timed out MBX completion from FW

 Hello Jayamohan Kallickal,

 The patch 1957aa7f6246: "[SCSI] be2iscsi: Fix handling timed out MBX completion from FW" from Jan 29, 2014, leads to the following static checker warning:

 drivers/scsi/be2iscsi/be_main.c:5581 beiscsi_dev_probe()
 error: memset() '&phba->ctrl.ptag_state[i]->tag_mem_state' too small (24 vs 32)

 drivers/scsi/be2iscsi/be_main.c
 5576          for (i = 0; i < MAX_MCC_CMD; i++) {
 5577                  init_waitqueue_head(&phba->ctrl.mcc_wait[i + 1]);
 5578                  phba->ctrl.mcc_tag[i] = i + 1;
 5579                  phba->ctrl.mcc_numtag[i + 1] = 0;
 5580                  phba->ctrl.mcc_tag_available++;
 5581                  memset(&phba->ctrl.ptag_state[i].tag_mem_state, 0,
 5582                         sizeof(struct beiscsi_mcc_tag_state));
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 Probably this this be change to sizeof(struct be_dma_mem struct)?  It looks like we are corrupting memory a bit here.

 5583          }

 regards,
 dan carpenter

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9ff8667..e8bba90 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5625,7 +5625,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		phba->ctrl.mcc_numtag[i + 1] = 0;
 		phba->ctrl.mcc_tag_available++;
 		memset(&phba->ctrl.ptag_state[i].tag_mem_state, 0,
-		       sizeof(struct beiscsi_mcc_tag_state));
+		       sizeof(struct be_dma_mem));
 	}
 
 	phba->ctrl.mcc_alloc_index = phba->ctrl.mcc_free_index = 0;
-- 
1.8.5.3

