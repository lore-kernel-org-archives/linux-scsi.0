Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B263C47257
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7072E218AC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgEHRXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:23:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727824AbgEHRXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:23:47 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048H2TNN145814;
        Fri, 8 May 2020 13:23:44 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vtsrb329-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:23:44 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048H61f9010090;
        Fri, 8 May 2020 17:23:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 30s0g65kcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 17:23:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048HMSLh59703792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 17:22:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06564AE055;
        Fri,  8 May 2020 17:23:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7B16AE051;
        Fri,  8 May 2020 17:23:38 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.54.185])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 May 2020 17:23:38 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jX6io-002wrQ-3C; Fri, 08 May 2020 19:23:38 +0200
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
Subject: [PATCH 1/8] zfcp: move shost modification after QDIO (re-)open into fenced function
Date:   Fri,  8 May 2020 19:23:28 +0200
Message-Id: <a214ebf508f71e3690113e3e90edab1cea0e24e3.1588956679.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588956679.git.bblock@linux.ibm.com>
References: <cover.1588956679.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=980
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 clxscore=1011
 adultscore=0 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080142
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When establishing and activating the QDIO queue pair for a FCP device
for the first time, or after an adapter recovery, we publish some of its
characteristics to the scsi host object representing that FCP device.

When moving the scsi host object allocation and registration to after
the first exchange config and exchange port data, this is not possible
for the former case - QDIO open for the first time - because that
happens before exchange config and exchange port data.

Move the scsi host object update into a fenced function that checks
whether the object already exists or not. This way we can repeat that
step later, once we are past the allocation.

Once the first recovery succeeds we don't release the scsi host object
anymore, so further recoveries do work as before.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h  |  2 ++
 drivers/s390/scsi/zfcp_qdio.c | 19 ++++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 88294ca0e2ea..d67f31b9b859 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -153,6 +153,8 @@ extern int zfcp_qdio_sbal_get(struct zfcp_qdio *);
 extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_qdio_req *);
 extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *, struct zfcp_qdio_req *,
 				   struct scatterlist *);
+extern void zfcp_qdio_shost_update(struct zfcp_adapter *const adapter,
+				   const struct zfcp_qdio *const qdio);
 extern int zfcp_qdio_open(struct zfcp_qdio *);
 extern void zfcp_qdio_close(struct zfcp_qdio *);
 extern void zfcp_qdio_siosl(struct zfcp_adapter *);
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 26702b56a7ab..3a7f3374d10a 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -4,7 +4,7 @@
  *
  * Setup and helper functions to access QDIO.
  *
- * Copyright IBM Corp. 2002, 2017
+ * Copyright IBM Corp. 2002, 2020
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -342,6 +342,18 @@ void zfcp_qdio_close(struct zfcp_qdio *qdio)
 	atomic_set(&qdio->req_q_free, 0);
 }
 
+void zfcp_qdio_shost_update(struct zfcp_adapter *const adapter,
+			    const struct zfcp_qdio *const qdio)
+{
+	struct Scsi_Host *const shost = adapter->scsi_host;
+
+	if (shost == NULL)
+		return;
+
+	shost->sg_tablesize = qdio->max_sbale_per_req;
+	shost->max_sectors = qdio->max_sbale_per_req * 8;
+}
+
 /**
  * zfcp_qdio_open - prepare and initialize response queue
  * @qdio: pointer to struct zfcp_qdio
@@ -420,10 +432,7 @@ int zfcp_qdio_open(struct zfcp_qdio *qdio)
 	atomic_set(&qdio->req_q_free, QDIO_MAX_BUFFERS_PER_Q);
 	atomic_or(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
 
-	if (adapter->scsi_host) {
-		adapter->scsi_host->sg_tablesize = qdio->max_sbale_per_req;
-		adapter->scsi_host->max_sectors = qdio->max_sbale_per_req * 8;
-	}
+	zfcp_qdio_shost_update(adapter, qdio);
 
 	return 0;
 
-- 
2.17.1

