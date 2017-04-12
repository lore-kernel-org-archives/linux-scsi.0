From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 01/17] cxlflash: Separate RRQ processing from the RRQ interrupt handler
Date: Wed, 12 Apr 2017 14:11:44 -0500
Message-ID: <1492024304-55659-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45551 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754633AbdDLTNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:13:01 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ98AQ132461
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:12:58 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29sne7y9h9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:12:58 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:12:57 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

In order to support processing the HRRQ by other means (e.g. polling),
the processing portion of the current RRQ interrupt handler needs to be
broken out into a separate routine. This will allow RRQ processing from
places other than the RRQ hardware interrupt handler.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 3061d80..30c09593c 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1155,19 +1155,18 @@ static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
 }
 
 /**
- * cxlflash_rrq_irq() - interrupt handler for read-response queue (normal path)
- * @irq:	Interrupt number.
- * @data:	Private data provided at interrupt registration, the AFU.
+ * process_hrrq() - process the read-response queue
+ * @afu:	AFU associated with the host.
  *
- * Return: Always return IRQ_HANDLED.
+ * Return: The number of entries processed.
  */
-static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
+static int process_hrrq(struct afu *afu)
 {
-	struct afu *afu = (struct afu *)data;
 	struct afu_cmd *cmd;
 	struct sisl_ioasa *ioasa;
 	struct sisl_ioarcb *ioarcb;
 	bool toggle = afu->toggle;
+	int num_hrrq = 0;
 	u64 entry,
 	    *hrrq_start = afu->hrrq_start,
 	    *hrrq_end = afu->hrrq_end,
@@ -1201,11 +1200,27 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 		}
 
 		atomic_inc(&afu->hsq_credits);
+		num_hrrq++;
 	}
 
 	afu->hrrq_curr = hrrq_curr;
 	afu->toggle = toggle;
 
+	return num_hrrq;
+}
+
+/**
+ * cxlflash_rrq_irq() - interrupt handler for read-response queue (normal path)
+ * @irq:	Interrupt number.
+ * @data:	Private data provided at interrupt registration, the AFU.
+ *
+ * Return: Always return IRQ_HANDLED.
+ */
+static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
+{
+	struct afu *afu = (struct afu *)data;
+
+	process_hrrq(afu);
 	return IRQ_HANDLED;
 }
 
-- 
2.1.0
