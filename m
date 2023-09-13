Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD21EE0212
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 00:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjINAyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 20:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbjIMXbM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 19:31:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A05EE41
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 16:31:06 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DN87ZY030585;
        Wed, 13 Sep 2023 23:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=niacoBGWpBB1nkAeF1ys1ymNNwpY9/FTBISrR+D+PjM=;
 b=WsfVTRzANCxAfsCUyPNRf+gJkgCYysOYiCGrf2EgYbZ3T8vCKmGW63VVmpU3G2mxrBIO
 CVq9B5aFJV6iJBoRv1bOpmbXQQMx15ipuOZ3WOQC2oZ7/EcIywpSx1HhyJaL0d0l6M0Q
 15p5ZhJDRY11aDqseMv6TezaQF9+zDLgj/NXkIzVzi5PKzCZntbu1EWAkbYIrddnbFTh
 A0wofRiaGAU4a8R8F8MiXYwaGH7w8gVh1cWFZAeZAYh4v4EIvOBImB+B/IKsBMiDi3qE
 IuyD26t80MOEFpCiQuZ1J6rzDeUiTxb31ZRUWd6rPMWMQJL9G5TiBNO+vVjbNJfYCS7z IA== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3kpfn4u2-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:31:02 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DLbA8e002410;
        Wed, 13 Sep 2023 23:05:04 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t158ke7dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:04 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN53Sw61800722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:05:03 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 797F058061;
        Wed, 13 Sep 2023 23:05:03 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C17F58059;
        Wed, 13 Sep 2023 23:05:03 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:05:02 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 06/11] ibmvfc: rename ibmvfc_scsi_channels to ibmvfc_channels
Date:   Wed, 13 Sep 2023 18:04:52 -0500
Message-Id: <20230913230457.2575849-7-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230913230457.2575849-1-tyreld@linux.ibm.com>
References: <20230913230457.2575849-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N37pkN84sGZ8k7aGyWlBgwC6MzaFoolW
X-Proofpoint-ORIG-GUID: N37pkN84sGZ8k7aGyWlBgwC6MzaFoolW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_17,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 mlxlogscore=740 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309130191
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
index a2f6a9ba5955..b03b68b3b1b6 100644
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

