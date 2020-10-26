Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C044C5517A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 01:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A3AD2225C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 01:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NDjCNYIb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421181AbgJZBhF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 21:37:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14166 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2410972AbgJZBhE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Oct 2020 21:37:04 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09Q1W1qH086265;
        Sun, 25 Oct 2020 21:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HzN4WTS1A6+3V80bxbst9bTvW0O4208Qy5TytbIiHeg=;
 b=NDjCNYIbIcjgt7DCxwjuddgEwzeSyNlaWbuVvpQ4Jj2tpgOFAYDMK1Pa4aBkXSoCwU+V
 GqThN4wUko3ufK3aCOLJcN7fkldzziKMhnkJQBzRCkhWc+OdtlkysAeXaeFwrQ78CSNw
 ybqIKWmV1fW4Oo31jTv5dzW87ciz5dpFeLBmk6rdgwvGtaMU8JUG53mJwm8Cq91Ew3g/
 bB+Sdy33rbHs6dfPqsem3RSEpDiRipFnLUvLny4JmzWcAV7qWIzaMzCSZkcNnmAJxdRZ
 k7nFNXZCR9FoTa2Omt9rNmqQ1EKNR8UMVqZll78LQ8aqx3wb6znPnPwpJsnPD/BAQqoi OQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34d97f3sx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 25 Oct 2020 21:36:53 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09Q1XaTL024083;
        Mon, 26 Oct 2020 01:36:52 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 34cbw8vcqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 01:36:52 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09Q1aqHN54591970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 01:36:52 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BC312805A;
        Mon, 26 Oct 2020 01:36:52 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A79C428059;
        Mon, 26 Oct 2020 01:36:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.40.195.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 01:36:51 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH] ibmvfc: add new fields for version 2 of several MADs
Date:   Sun, 25 Oct 2020 20:36:49 -0500
Message-Id: <20201026013649.10147-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-25_16:2020-10-23,2020-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=1 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010260004
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce a targetWWPN field to several MADs. Its possible that a scsi
ID of a target can change due to some fabric changes. The WWPN of the
scsi target provides a better way to identify the target. Also, add
flags for receiving MAD versioning information and advertising client
support for targetWWPN with the VIOS. This latter capability flag will
be required for future clients capable of requesting multiple hardware
queues from the host adapter.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 34debccfb142..c9c7f55baf55 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -54,6 +54,7 @@
 
 #define IBMVFC_MAD_SUCCESS		0x00
 #define IBMVFC_MAD_NOT_SUPPORTED	0xF1
+#define IBMVFC_MAD_VERSION_NOT_SUPP	0xF2
 #define IBMVFC_MAD_FAILED		0xF7
 #define IBMVFC_MAD_DRIVER_FAILED	0xEE
 #define IBMVFC_MAD_CRQ_ERROR		0xEF
@@ -168,6 +169,8 @@ struct ibmvfc_npiv_login {
 #define IBMVFC_CAN_MIGRATE		0x01
 #define IBMVFC_CAN_USE_CHANNELS		0x02
 #define IBMVFC_CAN_HANDLE_FPIN		0x04
+#define IBMVFC_CAN_USE_MAD_VERSION	0x08
+#define IBMVFC_CAN_SEND_VF_WWPN		0x10
 	__be64 node_name;
 	struct srp_direct_buf async;
 	u8 partition_name[IBMVFC_MAX_NAME];
@@ -211,7 +214,9 @@ struct ibmvfc_npiv_login_resp {
 	__be64 capabilities;
 #define IBMVFC_CAN_FLUSH_ON_HALT	0x08
 #define IBMVFC_CAN_SUPPRESS_ABTS	0x10
-#define IBMVFC_CAN_SUPPORT_CHANNELS	0x20
+#define IBMVFC_MAD_VERSION_CAP		0x20
+#define IBMVFC_HANDLE_VF_WWPN		0x40
+#define IBMVFC_CAN_SUPPORT_CHANNELS	0x80
 	__be32 max_cmds;
 	__be32 scsi_id_sz;
 	__be64 max_dma_len;
@@ -293,7 +298,8 @@ struct ibmvfc_port_login {
 	__be32 reserved2;
 	struct ibmvfc_service_parms service_parms;
 	struct ibmvfc_service_parms service_parms_change;
-	__be64 reserved3[2];
+	__be64 targetWWPN;
+	__be64 reserved3;
 } __packed __aligned(8);
 
 struct ibmvfc_move_login {
@@ -344,7 +350,8 @@ struct ibmvfc_process_login {
 	__be16 status;
 	__be16 error;			/* also fc_reason */
 	__be32 reserved2;
-	__be64 reserved3[2];
+	__be64 targetWWPN;
+	__be64 reserved3;
 } __packed __aligned(8);
 
 struct ibmvfc_query_tgt {
@@ -378,7 +385,8 @@ struct ibmvfc_tmf {
 	__be32 cancel_key;
 	__be32 my_cancel_key;
 	__be32 pad;
-	__be64 reserved[2];
+	__be64 targetWWPN;
+	__be64 taskTag;
 } __packed __aligned(8);
 
 enum ibmvfc_fcp_rsp_info_codes {
@@ -474,7 +482,8 @@ struct ibmvfc_cmd {
 	__be64 correlation;
 	__be64 tgt_scsi_id;
 	__be64 tag;
-	__be64 reserved3[2];
+	__be64 targetWWPN;
+	__be64 reserved3;
 	struct ibmvfc_fcp_cmd_iu iu;
 	struct ibmvfc_fcp_rsp rsp;
 } __packed __aligned(8);
@@ -503,7 +512,8 @@ struct ibmvfc_passthru_iu {
 	__be64 correlation;
 	__be64 scsi_id;
 	__be64 tag;
-	__be64 reserved2[2];
+	__be64 targetWWPN;
+	__be64 reserved2;
 } __packed __aligned(8);
 
 struct ibmvfc_passthru_mad {
-- 
2.27.0

