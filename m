From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Fix I/O hang when port is not mapped
Date: Mon, 19 Sep 2016 08:59:19 -0500
Message-ID: <20160919135919.689C528041@b01ledav001.gho.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43191 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938762AbcISN7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Sep 2016 09:59:30 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8JDwkTB140894
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2016 09:59:25 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25hr4j9chv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2016 09:59:25 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Mon, 19 Sep 2016 09:59:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


If a VFC port gets unmapped in the VIOS, it may not respond with a CRQ init
complete following H_REG_CRQ. If this occurs, we can end up having called
scsi_block_requests and not a resulting unblock until the init complete
happens, which may never occur, and we end up hanging I/O requests.
This patch ensures the host action stay set to IBMVFC_HOST_ACTION_TGT_DEL so
we move all rports into devloss state and unblock unless we receive an
init complete. 

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_unmap_hang_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6.git/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_unmap_hang_fix	2016-09-09 15:46:36.452011778 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2016-09-09 15:47:07.026632886 -0500
@@ -717,7 +717,6 @@ static int ibmvfc_reset_crq(struct ibmvf
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	vhost->state = IBMVFC_NO_CRQ;
 	vhost->logged_in = 0;
-	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
 
 	/* Clean out the queue */
 	memset(crq->msgs, 0, PAGE_SIZE);
_

