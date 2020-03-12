Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F965C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E539206B1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgCLRzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:55:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgCLRzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 13:55:46 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHtbdC084835
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:55:44 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yqskk8set-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:55:44 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:26 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:25 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHjNi561407308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:45:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F74652057;
        Thu, 12 Mar 2020 17:45:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DACB45204E;
        Thu, 12 Mar 2020 17:45:22 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>
Subject: [PATCH 05/10] zfcp: auto variables for dereferenced structs in open port handler
Date:   Thu, 12 Mar 2020 18:45:00 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312174505.51294-1-maier@linux.ibm.com>
References: <20200312174505.51294-1-maier@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031217-0020-0000-0000-000003B35DCF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-0021-0000-0000-0000220BB2DB
Message-Id: <20200312174505.51294-6-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120092
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jens Remus <jremus@linux.ibm.com>

Introduce automatic variables for adapter and QTCB bottom in
zfcp_fsf_open_port_handler(). This facilitates subsequent changes
to meet the 80 character per line limit.

Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Fedor Loshakov <loshakov@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 1fa94277d287..c3aa0546364a 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -4,7 +4,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corp. 2002, 2018
+ * Copyright IBM Corp. 2002, 2020
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -1499,8 +1499,10 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 
 static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 {
+	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_port *port = req->data;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
+	struct fsf_qtcb_bottom_support *bottom = &req->qtcb->bottom.support;
 	struct fc_els_flogi *plogi;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
@@ -1510,7 +1512,7 @@ static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 	case FSF_PORT_ALREADY_OPEN:
 		break;
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
-		dev_warn(&req->adapter->ccw_device->dev,
+		dev_warn(&adapter->ccw_device->dev,
 			 "Not enough FCP adapter resources to open "
 			 "remote port 0x%016Lx\n",
 			 (unsigned long long)port->wwpn);
@@ -1550,10 +1552,9 @@ static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 		 * another GID_PN straight after a port has been opened.
 		 * Alternately, an ADISC/PDISC ELS should suffice, as well.
 		 */
-		plogi = (struct fc_els_flogi *) req->qtcb->bottom.support.els;
-		if (req->qtcb->bottom.support.els1_length >=
-		    FSF_PLOGI_MIN_LEN)
-				zfcp_fc_plogi_evaluate(port, plogi);
+		plogi = (struct fc_els_flogi *) bottom->els;
+		if (bottom->els1_length >= FSF_PLOGI_MIN_LEN)
+			zfcp_fc_plogi_evaluate(port, plogi);
 		break;
 	case FSF_UNKNOWN_OP_SUBTYPE:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-- 
2.17.1

