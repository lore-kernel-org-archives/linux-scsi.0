Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8E3C54E4A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A39206D3
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgEHRXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:23:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727893AbgEHRXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:23:47 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048H1fg3116373;
        Fri, 8 May 2020 13:23:45 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vts7stn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:23:45 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048H57Jx000345;
        Fri, 8 May 2020 17:23:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g5dnek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 17:23:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048HMTV459769136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 17:22:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2544A4057;
        Fri,  8 May 2020 17:23:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE6ADA404D;
        Fri,  8 May 2020 17:23:39 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.54.185])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 May 2020 17:23:39 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jX6io-002wre-W3; Fri, 08 May 2020 19:23:39 +0200
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
Subject: [PATCH 4/8] zfcp: fence fc_host updates during link-down handling
Date:   Fri,  8 May 2020 19:23:31 +0200
Message-Id: <f841f2cda61dcd7b8549910c44e1831927459edf.1588956679.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588956679.git.bblock@linux.ibm.com>
References: <cover.1588956679.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080142
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When receiving a notification that a FCP device lost its local link we
usually update the fibre channel host object which represents that FCP
device to reflect that.

This notification/information can also surface when the FCP device is
running through adapter recovery (exchange config and exchange port data
return incomplete).

When moving the scsi host object allocation and registration  - and thus
also the fibre channel host object allocation - to after the first
exchange config and exchange port data, and this happens during the very
first adapter recovery, these updates can not be done until after the
scsi host object is allocated.

Reorder the fc_host updates in zfcp_fsf_fc_host_link_down() so that they
only happen after a check of whether the scsi host object is already
allocated or not.

During the first adapter recovery this will cause the skip of these
updates if a link-down condition is detected, but we can repeat them
after we allocated the scsi host object, if necessary.

For any further link-down handling the only changes in the work flow are
the slightly reordered assignments in zfcp_fsf_fc_host_link_down().

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index bfb567a1d7bf..8c4b690e329e 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -124,17 +124,21 @@ static void zfcp_fsf_fc_host_link_down(struct zfcp_adapter *adapter)
 {
 	struct Scsi_Host *shost = adapter->scsi_host;
 
+	adapter->hydra_version = 0;
+	adapter->peer_wwpn = 0;
+	adapter->peer_wwnn = 0;
+	adapter->peer_d_id = 0;
+
+	/* if there is no shost yet, we have nothing to zero-out */
+	if (shost == NULL)
+		return;
+
 	fc_host_port_id(shost) = 0;
 	fc_host_fabric_name(shost) = 0;
 	fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 	fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
-	adapter->hydra_version = 0;
 	snprintf(fc_host_model(shost), FC_SYMBOLIC_NAME_SIZE, "0x%04x", 0);
 	memset(fc_host_active_fc4s(shost), 0, FC_FC4_LIST_SIZE);
-
-	adapter->peer_wwpn = 0;
-	adapter->peer_wwnn = 0;
-	adapter->peer_d_id = 0;
 }
 
 static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req,
-- 
2.17.1

