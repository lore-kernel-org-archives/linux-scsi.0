Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DB8E7D0B7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjIUWyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjIUWyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633B7F7
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:44 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMeU8k010815;
        Thu, 21 Sep 2023 22:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Dvp+IolEFnDje8hias3DYC4XspWUQ2OIAULYQihaSp4=;
 b=TKAHAy3busADdqOlDo8t0KLW1Rg0v0n1Jhx4hlFsER7EunpUu1JP1DpHe50xTBF0Lpzd
 2nh+p4Y0T/fNjib+5+DoE/1c8241n75SrNBC6c+pXAhZM5DrayMfiiAIfc3/PMLghZOE
 EDVAVXD1j42JG52Gr0KrtQQ1wNoblG1j/GyN8kVqTIGQBxU+Ew3GSDZh2nMqQHKr0Hzd
 zXRrQAfCDFd/Eaf4u/ZWsHWuJt3kvb60kZMXQnHt9m2HWTfd+K0Nmv3bBSnuLjVyghMA
 2gyp2tOcPnHoknFiIbfW8B3iDK1mB4lyxKFjRe6xJAA0+SpWUgzbiEpu2YmHhgINUc7k AA== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8v2gvhd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:41 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLrnQk017442;
        Thu, 21 Sep 2023 22:54:40 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t8tsm478p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:40 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMsdhv8061652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:39 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 039FF58051;
        Thu, 21 Sep 2023 22:54:39 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C38155805C;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 06/11] ibmvfc: rename ibmvfc_scsi_channels to ibmvfc_channels
Date:   Thu, 21 Sep 2023 17:54:30 -0500
Message-Id: <20230921225435.3537728-7-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JjwiXkE3PWKYhItLaw_QzjNVMptJ86ZF
X-Proofpoint-GUID: JjwiXkE3PWKYhItLaw_QzjNVMptJ86ZF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=743 spamscore=0
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309210196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is nothing scsi specific about the ibmvfc_scsi_channels struct. It
is meant to encapsulate a set of channels regardless of protocol.

Remove _scsi from the struct name to reflect this genric nature.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 4 ++--
 drivers/scsi/ibmvscsi/ibmvfc.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 30baa046ae5b..9a5b3ccb0809 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5013,7 +5013,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
-	struct ibmvfc_scsi_channels *scrqs = &vhost->scsi_scrqs;
+	struct ibmvfc_channels *scrqs = &vhost->scsi_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 	int flags, active_queues, i;
@@ -5064,7 +5064,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_channel_setup_mad *mad;
 	struct ibmvfc_channel_setup *setup_buf = vhost->channel_setup_buf;
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
-	struct ibmvfc_scsi_channels *scrqs = &vhost->scsi_scrqs;
+	struct ibmvfc_channels *scrqs = &vhost->scsi_scrqs;
 	unsigned int num_channels =
 		min(vhost->client_scsi_channels, vhost->max_vios_scsi_channels);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 8ae52c239009..d88a528b8cc1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -815,7 +815,7 @@ struct ibmvfc_queue {
 	char name[32];
 };
 
-struct ibmvfc_scsi_channels {
+struct ibmvfc_channels {
 	struct ibmvfc_queue *scrqs;
 	unsigned int active_queues;
 };
@@ -866,7 +866,7 @@ struct ibmvfc_host {
 	mempool_t *tgt_pool;
 	struct ibmvfc_queue crq;
 	struct ibmvfc_queue async_crq;
-	struct ibmvfc_scsi_channels scsi_scrqs;
+	struct ibmvfc_channels scsi_scrqs;
 	struct ibmvfc_npiv_login login_info;
 	union ibmvfc_npiv_login_data *login_buf;
 	dma_addr_t login_buf_dma;
-- 
2.31.1

