From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] lpfc: fix printk format warning
Date: Mon, 23 Oct 2006 21:47:13 -0700
Message-ID: <20061023214713.cfff635b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:63718 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1752024AbWJXEsK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Oct 2006 00:48:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: james.smart@emulex.com, jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:
drivers/scsi/lpfc/lpfc_attr.c:597: warning: long long unsigned int format, uint64_t arg (arg 4)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 drivers/scsi/lpfc/lpfc_attr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2619-rc3-pv.orig/drivers/scsi/lpfc/lpfc_attr.c
+++ linux-2619-rc3-pv/drivers/scsi/lpfc/lpfc_attr.c
@@ -594,7 +594,8 @@ lpfc_soft_wwpn_show(struct class_device 
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", phba->cfg_soft_wwpn);
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+			(unsigned long long)phba->cfg_soft_wwpn);
 }
 
 


---
