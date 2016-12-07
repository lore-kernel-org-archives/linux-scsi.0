From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ibmvscsi: log bad SRP response opcode in hex format
Date: Wed,  7 Dec 2016 16:04:36 -0600
Message-ID: <1481148276-5083-2-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1481148276-5083-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46041 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932595AbcLGWFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 17:05:35 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB7M06C6118214
        for <linux-scsi@vger.kernel.org>; Wed, 7 Dec 2016 17:05:34 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 276n7r92m7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Dec 2016 17:05:34 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Wed, 7 Dec 2016 15:05:33 -0700
In-Reply-To: <1481148276-5083-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

An unrecogonized or unsupported SRP response has its opcode currently
logged in decimal format. Log it in hex format instead so it can easily
be validated against the SRP specs values which are in hex.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index a0ee16f..7752656 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -993,7 +993,7 @@ static void handle_cmd_rsp(struct srp_event_struct *evt_struct)
 	if (unlikely(rsp->opcode != SRP_RSP)) {
 		if (printk_ratelimit())
 			dev_warn(evt_struct->hostdata->dev,
-				 "bad SRP RSP type %d\n", rsp->opcode);
+				 "bad SRP RSP type %#02x\n", rsp->opcode);
 	}
 	
 	if (cmnd) {
-- 
1.8.3.1

