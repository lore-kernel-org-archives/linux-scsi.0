From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/6] cxlflash: Reset command ioasc
Date: Wed,  3 Jan 2018 16:54:02 -0600
Message-ID: <1515020042-43590-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751206AbeACWyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 17:54:22 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id w03MsMjb021260
        for <linux-scsi@vger.kernel.org>; Wed, 3 Jan 2018 17:54:22 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2f982y0j9d-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jan 2018 17:54:22 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 3 Jan 2018 15:54:21 -0700
In-Reply-To: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

In the event of a command failure, cxlflash returns the failure to the
upper layers to process. After processing the error, when the command is
queued again, the private command structure will not be zeroed and the
ioasc could be stale. Per the SISLite specification, the AFU only sets the
ioasc in the presence of a failure. Thus, even though the original command
succeeds the second time, the command is considered a failure due to stale
ioasc. This cycle repeats indefinitely and can cause a hang or IO failure.

To fix the issue, clear the ioasc before queuing any command.

Fixes: 479ad8e9d48c ("scsi: cxlflash: Remove zeroing of private command
data")
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 38b3a9c..48d3663 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -620,6 +620,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	cmd->parent = afu;
 	cmd->hwq_index = hwq_index;
 
+	cmd->sa.ioasc = 0;
 	cmd->rcb.ctx_id = hwq->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
 	cmd->rcb.port_sel = CHAN2PORTMASK(scp->device->channel);
-- 
2.1.0
