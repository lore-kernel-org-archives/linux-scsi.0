From: michaelc@cs.wisc.edu
Subject: [PATCH 06/17] be2iscsi:Set num_cpu = 1 if pci_enable_msix fails
Date: Tue, 20 Mar 2012 20:47:57 -0500
Message-ID: <1332294488-13684-7-git-send-email-michaelc@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030355Ab2CUBsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:35 -0400
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

	This patch sets the num_cpu to 1 if  msix not supported
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f0909db..ce7ce79 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4279,8 +4279,11 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	phba->num_cpus = num_cpus;
 	SE_DEBUG(DBG_LVL_8, "num_cpus = %d\n", phba->num_cpus);
 
-	if (enable_msix)
+	if (enable_msix) {
 		beiscsi_msix_enable(phba);
+		if (!phba->msix_enabled)
+			phba->num_cpus = 1;
+	}
 	ret = be_ctrl_init(phba, pcidev);
 	if (ret) {
 		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
-- 
1.7.7.6

