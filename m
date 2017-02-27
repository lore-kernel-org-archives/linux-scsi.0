From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: lpfc: NVME Target: Receive buffer updates
Date: Mon, 27 Feb 2017 19:44:25 +0300
Message-ID: <20170227164349.GA22044@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:51876 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdB0X2c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 18:28:32 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1RGk53c016195
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 16:46:05 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch 2d7dbc4c2775: "scsi: lpfc: NVME Target: Receive buffer 
updates" from Feb 12, 2017, leads to the following Smatch complaint:

drivers/scsi/lpfc/lpfc_sli.c:15194 lpfc_mrq_create()
	 warn: variable dereferenced before check 'hrq' (see line 15188)

drivers/scsi/lpfc/lpfc_sli.c
 15181          cnt = 0;
 15182  
 15183          for (idx = 0; idx < numrq; idx++) {
 15184                  hrq = hrqp[idx];
 15185                  drq = drqp[idx];
 15186                  cq  = cqp[idx];
 15187	
 15188			if (hrq->entry_count != drq->entry_count) {
                            ^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^
Dereferences.

 15189				status = -EINVAL;
 15190				goto out;
 15191			}
 15192	
 15193			/* sanity check on queue memory */
 15194			if (!hrq || !drq || !cq) {
                             ^^^^^^^^^^^
Too late.

 15195				status = -ENODEV;
 15196				goto out;

regards,
dan carpenter
