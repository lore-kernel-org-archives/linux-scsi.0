Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51A7C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F020206B1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCLR4a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:56:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgCLR4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 13:56:30 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHtcGj086132
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:56:28 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yqskk8try-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:56:27 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:43 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:40 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHjc7q40435926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:45:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94B6C52051;
        Thu, 12 Mar 2020 17:45:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4C3465204E;
        Thu, 12 Mar 2020 17:45:38 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>
Subject: [PATCH 10/10] zfcp: log FC Endpoint Security errors
Date:   Thu, 12 Mar 2020 18:45:05 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312174505.51294-1-maier@linux.ibm.com>
References: <20200312174505.51294-1-maier@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031217-4275-0000-0000-000003AB4657
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-4276-0000-0000-000038C065AE
Message-Id: <20200312174505.51294-11-maier@linux.ibm.com>
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

Log any FC Endpoint Security errors to the kernel ring buffer with rate-
limiting.

Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 62 ++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.h |  8 +++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index e8d0bf0ec10f..662ddbc74263 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1647,6 +1647,62 @@ static void zfcp_fsf_log_port_fc_security(struct zfcp_port *port,
 	port->connection_info_old = port->connection_info;
 }
 
+static void zfcp_fsf_log_security_error(const struct device *dev, u32 fsf_sqw0,
+					u64 wwpn)
+{
+	switch (fsf_sqw0) {
+
+	/*
+	 * Open Port command error codes
+	 */
+
+	case FSF_SQ_SECURITY_REQUIRED:
+		dev_warn_ratelimited(dev,
+				     "FC Endpoint Security error: FC security is required but not supported or configured on remote port 0x%016llx\n",
+				     wwpn);
+		break;
+	case FSF_SQ_SECURITY_TIMEOUT:
+		dev_warn_ratelimited(dev,
+				     "FC Endpoint Security error: a timeout prevented opening remote port 0x%016llx\n",
+				     wwpn);
+		break;
+	case FSF_SQ_SECURITY_KM_UNAVAILABLE:
+		dev_warn_ratelimited(dev,
+				     "FC Endpoint Security error: opening remote port 0x%016llx failed because local and external key manager cannot communicate\n",
+				     wwpn);
+		break;
+	case FSF_SQ_SECURITY_RKM_UNAVAILABLE:
+		dev_warn_ratelimited(dev,
+				     "FC Endpoint Security error: opening remote port 0x%016llx failed because it cannot communicate with the external key manager\n",
+				     wwpn);
+		break;
+	case FSF_SQ_SECURITY_AUTH_FAILURE:
+		dev_warn_ratelimited(dev,
+				     "FC Endpoint Security error: the device could not verify the identity of remote port 0x%016llx\n",
+				     wwpn);
+		break;
+
+	/*
+	 * Send FCP command error codes
+	 */
+
+	case FSF_SQ_SECURITY_ENC_FAILURE:
+		dev_warn_ratelimited(dev,
+				     "FC Endpoint Security error: FC connection to remote port 0x%016llx closed because encryption broke down\n",
+				     wwpn);
+		break;
+
+	/*
+	 * Unknown error codes
+	 */
+
+	default:
+		dev_warn_ratelimited(dev,
+				     "FC Endpoint Security error: the device issued an unknown error code 0x%08x related to the FC connection to remote port 0x%016llx\n",
+				     fsf_sqw0, wwpn);
+	}
+}
+
 static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
@@ -1671,6 +1727,9 @@ static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SECURITY_ERROR:
+		zfcp_fsf_log_security_error(&req->adapter->ccw_device->dev,
+					    header->fsf_status_qual.word[0],
+					    port->wwpn);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -2404,6 +2463,9 @@ static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req,
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SECURITY_ERROR:
+		zfcp_fsf_log_security_error(&req->adapter->ccw_device->dev,
+					    header->fsf_status_qual.word[0],
+					    zfcp_sdev->port->wwpn);
 		zfcp_erp_port_forced_reopen(zfcp_sdev->port, 0, "fssfch7");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index c6a56f96c363..ba1fd144b890 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -111,6 +111,14 @@
 #define FSF_PSQ_LINK_MODE_TABLE_CURRUPTED	0x00004000
 #define FSF_PSQ_LINK_NO_WWPN_ASSIGNMENT		0x00008000
 
+/* FSF status qualifier, security error */
+#define FSF_SQ_SECURITY_REQUIRED		0x00000001
+#define FSF_SQ_SECURITY_TIMEOUT			0x00000002
+#define FSF_SQ_SECURITY_KM_UNAVAILABLE		0x00000003
+#define FSF_SQ_SECURITY_RKM_UNAVAILABLE		0x00000004
+#define FSF_SQ_SECURITY_AUTH_FAILURE		0x00000005
+#define FSF_SQ_SECURITY_ENC_FAILURE		0x00000010
+
 /* payload size in status read buffer */
 #define FSF_STATUS_READ_PAYLOAD_SIZE		4032
 
-- 
2.17.1

