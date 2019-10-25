Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBDCCA9EBF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA8792053B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505255AbfJYQNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503806AbfJYQNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:01 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG8woB083588
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:00 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv3avajde-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:00 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:58 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCsEC43909152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ED7FA405F;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A7CFA405B;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cr-00074Q-UF; Fri, 25 Oct 2019 18:12:53 +0200
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
Subject: [PATCH v2 04/11] zfcp: support retrieval of SFP Data via Exchange Port Data
Date:   Fri, 25 Oct 2019 18:12:46 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-4275-0000-0000-00000377A273
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-4276-0000-0000-0000388AD0E3
Message-Id: <ee1eba4de71eb06b4d82207ad4f428429346156f.1572018132.git.bblock@linux.ibm.com>
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

A new FCP channel feature allows us to read the diagnostics from our
local SFP transceivers. To make use of that add a flag
(FSF_FEATURE_REQUEST_SFP_DATA) to the feature-set we request from the
FCP channel. Whether the channel actually implements this can be
determined via an other new flag (FSF_FEATURE_REPORT_SFP_DATA), that is
set in the adapter_features field of the adapter structure after
Exchange Config Data finished.

Also add the corresponding definitions in the QTCB Bottom for Exchange
Port Data. These new definitions are only valid, if
FSF_FEATURE_REPORT_SFP_DATA is set.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |  6 ++++--
 drivers/s390/scsi/zfcp_fsf.h | 21 ++++++++++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 0fff060de5ac..223a805f0b0b 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1286,7 +1286,8 @@ int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 
 	req->qtcb->bottom.config.feature_selection =
 			FSF_FEATURE_NOTIFICATION_LOST |
-			FSF_FEATURE_UPDATE_ALERT;
+			FSF_FEATURE_UPDATE_ALERT |
+			FSF_FEATURE_REQUEST_SFP_DATA;
 	req->erp_action = erp_action;
 	req->handler = zfcp_fsf_exchange_config_data_handler;
 	erp_action->fsf_req_id = req->req_id;
@@ -1339,7 +1340,8 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *qdio,
 
 	req->qtcb->bottom.config.feature_selection =
 			FSF_FEATURE_NOTIFICATION_LOST |
-			FSF_FEATURE_UPDATE_ALERT;
+			FSF_FEATURE_UPDATE_ALERT |
+			FSF_FEATURE_REQUEST_SFP_DATA;
 
 	if (data)
 		req->data = data;
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 2c658b66318c..2b1e4da1944f 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -163,6 +163,8 @@
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS	0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
 #define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
+#define FSF_FEATURE_REQUEST_SFP_DATA		0x00000200
+#define FSF_FEATURE_REPORT_SFP_DATA		0x00000800
 #define FSF_FEATURE_DIF_PROT_TYPE1		0x00010000
 #define FSF_FEATURE_DIX_PROT_TCPIP		0x00020000
 
@@ -407,7 +409,24 @@ struct fsf_qtcb_bottom_port {
 	u8 cp_util;
 	u8 cb_util;
 	u8 a_util;
-	u8 res2[253];
+	u8 res2;
+	u16 temperature;
+	u16 vcc;
+	u16 tx_bias;
+	u16 tx_power;
+	u16 rx_power;
+	union {
+		u16 raw;
+		struct {
+			u16 fec_active		:1;
+			u16:7;
+			u16 connector_type	:2;
+			u16 sfp_invalid		:1;
+			u16 optical_port	:1;
+			u16 port_tx_type	:4;
+		};
+	} sfp_flags;
+	u8 res3[240];
 } __attribute__ ((packed));
 
 union fsf_qtcb_bottom {
-- 
2.21.0

