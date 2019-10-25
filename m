Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3DACA9EBD
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4B522053B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504990AbfJYQNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502277AbfJYQNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:01 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG9251066047
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:00 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv1ycwsjh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:12:59 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:58 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCsWL31588468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4249AA4059;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E33CA4055;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cr-00074L-TX; Fri, 25 Oct 2019 18:12:53 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 03/11] zfcp: add diagnostics buffer for exchange config data
Date:   Fri, 25 Oct 2019 18:12:45 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0028-0000-0000-000003AF90D2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0029-0000-0000-00002471C7A8
Message-Id: <7d8ac0a6cad403fa8f8b888693476a84e80a277b.1572018131.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the same vein as the previous patch, add diagnostic data capture for
the Exchange Config Data command.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_diag.c | 14 ++++++++++++--
 drivers/s390/scsi/zfcp_diag.h |  7 +++++++
 drivers/s390/scsi/zfcp_fsf.c  |  9 +++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_diag.c b/drivers/s390/scsi/zfcp_diag.c
index fa1b25f3ec3c..d7d2db85b32e 100644
--- a/drivers/s390/scsi/zfcp_diag.c
+++ b/drivers/s390/scsi/zfcp_diag.c
@@ -34,6 +34,9 @@
  */
 int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter)
 {
+	/* set the timestamp so that the first test on age will always fail */
+	const unsigned long initial_timestamp =
+		jiffies - msecs_to_jiffies(ZFCP_DIAG_MAX_AGE);
 	struct zfcp_diag_adapter *diag;
 	struct zfcp_diag_header *hdr;
 
@@ -47,8 +50,15 @@ int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter)
 	spin_lock_init(&hdr->access_lock);
 	hdr->buffer = &diag->port_data.data;
 	hdr->buffer_size = sizeof(diag->port_data.data);
-	/* set the timestamp so that the first test on age will always fail */
-	hdr->timestamp = jiffies - msecs_to_jiffies(ZFCP_DIAG_MAX_AGE);
+	hdr->timestamp = initial_timestamp;
+
+	/* setup header for config_data */
+	hdr = &diag->config_data.header;
+
+	spin_lock_init(&hdr->access_lock);
+	hdr->buffer = &diag->config_data.data;
+	hdr->buffer_size = sizeof(diag->config_data.data);
+	hdr->timestamp = initial_timestamp;
 
 	adapter->diagnostics = diag;
 	return 0;
diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
index 2a933326b6e4..a3eb21cc201d 100644
--- a/drivers/s390/scsi/zfcp_diag.h
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -43,12 +43,19 @@ struct zfcp_diag_header {
  * @port_data: data retrieved using exchange port data.
  * @port_data.header: header with metadata for the cache in @port_data.data.
  * @port_data.data: cached QTCB Bottom of command exchange port data.
+ * @config_data: data retrieved using exchange config data.
+ * @config_data.header: header with metadata for the cache in @config_data.data.
+ * @config_data.data: cached QTCB Bottom of command exchange config data.
  */
 struct zfcp_diag_adapter {
 	struct {
 		struct zfcp_diag_header		header;
 		struct fsf_qtcb_bottom_port	data;
 	} port_data;
+	struct {
+		struct zfcp_diag_header		header;
+		struct fsf_qtcb_bottom_config	data;
+	} config_data;
 };
 
 int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 883bbfd67a62..0fff060de5ac 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -556,6 +556,8 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
+	struct zfcp_diag_header *const diag_hdr =
+		&adapter->diagnostics->config_data.header;
 	struct fsf_qtcb *qtcb = req->qtcb;
 	struct fsf_qtcb_bottom_config *bottom = &qtcb->bottom.config;
 	struct Scsi_Host *shost = adapter->scsi_host;
@@ -572,6 +574,12 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 
 	switch (qtcb->header.fsf_status) {
 	case FSF_GOOD:
+		/*
+		 * usually we wait with an update till the cache is too old,
+		 * but because we have the data available, update it anyway
+		 */
+		zfcp_diag_update_xdata(diag_hdr, bottom, false);
+
 		if (zfcp_fsf_exchange_config_evaluate(req))
 			return;
 
@@ -587,6 +595,7 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 				&adapter->status);
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
+		zfcp_diag_update_xdata(diag_hdr, bottom, true);
 		req->status |= ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE;
 
 		fc_host_node_name(shost) = 0;
-- 
2.21.0

