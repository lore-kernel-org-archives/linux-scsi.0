Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83443C47255
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A6C21974
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgEHRXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:23:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727834AbgEHRXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:23:47 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048H2GtX129068;
        Fri, 8 May 2020 13:23:45 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vtsgu8ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:23:45 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048H4ri1002505;
        Fri, 8 May 2020 17:23:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 30s0g5dna3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 17:23:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048HNeAF56033378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 17:23:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 368C7A405B;
        Fri,  8 May 2020 17:23:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 240E3A4054;
        Fri,  8 May 2020 17:23:40 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.54.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 May 2020 17:23:40 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jX6ip-002wrj-A0; Fri, 08 May 2020 19:23:39 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 5/8] zfcp: move p-t-p port allocation to after xport data
Date:   Fri,  8 May 2020 19:23:32 +0200
Message-Id: <73e5d4ac21e2b37bf0c3ca8e530bc5a5c6e74f8f.1588956679.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588956679.git.bblock@linux.ibm.com>
References: <cover.1588956679.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080142
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When doing the very first adapter recovery - initialization - for a FCP
device in a point-to-point topology we also allocate the port object
corresponding to the attached remote port, and trigger a port recovery
for it that will run after the adapter recovery finished.

Right now this happens right after we finished with the exchange config
data command, and uses the fibre channel host object corresponding to
the FCP device to determine whether a point-to-point topology is used.

When moving the scsi host object allocation and registration - and thus
also the fibre channel host object allocation - to after the first
exchange config and exchange port data, this use of the fc_host object
is not possible anymore at that point in the work flow.

But the allocation and recovery trigger doesn't have notable
side-effects on the following exchange port data processing, so we can
move those to after xport data, and thus also to after the scsi host
object allocation, once we move it. Then the fc_host object can be used
again, like it is now.

For any further adapter recoveries this doesn't change anything, because
at that point the port object already exists and recovery is triggered
elsewhere for existing port objects.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 3d0bc000f500..356f51d2bbee 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -4,7 +4,7 @@
  *
  * Error Recovery Procedures (ERP).
  *
- * Copyright IBM Corp. 2002, 2017
+ * Copyright IBM Corp. 2002, 2020
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -768,10 +768,14 @@ static enum zfcp_erp_act_result zfcp_erp_adapter_strat_fsf_xconf(
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_XCONFIG_OK))
 		return ZFCP_ERP_FAILED;
 
+	return ZFCP_ERP_SUCCEEDED;
+}
+
+static void
+zfcp_erp_adapter_strategy_open_ptp_port(struct zfcp_adapter *const adapter)
+{
 	if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
 		zfcp_erp_enqueue_ptp_port(adapter);
-
-	return ZFCP_ERP_SUCCEEDED;
 }
 
 static enum zfcp_erp_act_result zfcp_erp_adapter_strategy_open_fsf_xport(
@@ -809,6 +813,8 @@ static enum zfcp_erp_act_result zfcp_erp_adapter_strategy_open_fsf(
 	if (zfcp_erp_adapter_strategy_open_fsf_xport(act) == ZFCP_ERP_FAILED)
 		return ZFCP_ERP_FAILED;
 
+	zfcp_erp_adapter_strategy_open_ptp_port(act->adapter);
+
 	if (mempool_resize(act->adapter->pool.sr_data,
 			   act->adapter->stat_read_buf_num))
 		return ZFCP_ERP_FAILED;
-- 
2.17.1

