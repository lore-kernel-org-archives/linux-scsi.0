Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C49DE7D0B6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjIUWzC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjIUWyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A201F7
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:46 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMe21s009327;
        Thu, 21 Sep 2023 22:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PrpCTG6I7DkQICYkGfUj8lHdVC2Njk00160YnNc8nLU=;
 b=oQQoPt4TtMoh8pgKTu3rOS7c1wJLWxkyv3qiY1/7X46U5fHiHQ4/l64LWOvqJLpGs1pe
 V6IhH1tbVM1h+W9WF1KoZAYJ13l2CyMZeWeeP+iKcyUY0VcpS0NrAP1e+uyhWszz145s
 +aN9TsobxNQZCCylr487KOnr+85i2ulTD/D/UJlsZ9P5NCuCJSj8Al8EqTpWqf++cHhC
 Yg/Z4MEJA6UsOyLiX44+BjVbG0eU5pDxXKjsDZDAZ5vPCkY+QuXGRHe28FTXBKphJHNS
 HZm1mLFPMyQkfaf2NZIVI/PCdHLol11eq1kgfBL31O9dW9RKXXnPkKn79wI2YTXEAzWy jQ== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8v2gvhde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:42 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLowQe017421;
        Thu, 21 Sep 2023 22:54:41 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t8tsm478t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:41 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMseca23462306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:40 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28BD858051;
        Thu, 21 Sep 2023 22:54:40 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6ED65805E;
        Thu, 21 Sep 2023 22:54:39 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 21 Sep 2023 22:54:39 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 10/11] ibmvfc: make discovery buffer per protocol channel group
Date:   Thu, 21 Sep 2023 17:54:34 -0500
Message-Id: <20230921225435.3537728-11-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ocjWQrExhUTuEjf41iexm3pWaaoCxto6
X-Proofpoint-GUID: ocjWQrExhUTuEjf41iexm3pWaaoCxto6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309210196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The target discovery buffer that the VIOS populates with targets is
currently a host adapter field. To facilitate the discovery of NVMe
targets as well as SCSI another discovery buffer is required. Move the
discovery buffer out of the host struct and into the ibmvfc_channels
struct so that each channels instance for a given protocol has its own
discovery buffer.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 47 ++++++++++++++++++++++------------
 drivers/scsi/ibmvscsi/ibmvfc.h |  6 ++---
 2 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a1d547db7eef..122b79db79e3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4935,7 +4935,7 @@ static int ibmvfc_alloc_targets(struct ibmvfc_host *vhost)
 	int i, rc;
 
 	for (i = 0, rc = 0; !rc && i < vhost->num_targets; i++)
-		rc = ibmvfc_alloc_target(vhost, &vhost->disc_buf[i]);
+		rc = ibmvfc_alloc_target(vhost, &vhost->scsi_scrqs.disc_buf[i]);
 
 	return rc;
 }
@@ -4999,9 +4999,9 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 	mad->common.version = cpu_to_be32(1);
 	mad->common.opcode = cpu_to_be32(IBMVFC_DISC_TARGETS);
 	mad->common.length = cpu_to_be16(sizeof(*mad));
-	mad->bufflen = cpu_to_be32(vhost->disc_buf_sz);
-	mad->buffer.va = cpu_to_be64(vhost->disc_buf_dma);
-	mad->buffer.len = cpu_to_be32(vhost->disc_buf_sz);
+	mad->bufflen = cpu_to_be32(vhost->scsi_scrqs.disc_buf_sz);
+	mad->buffer.va = cpu_to_be64(vhost->scsi_scrqs.disc_buf_dma);
+	mad->buffer.len = cpu_to_be32(vhost->scsi_scrqs.disc_buf_sz);
 	mad->flags = cpu_to_be32(IBMVFC_DISC_TGT_PORT_ID_WWPN_LIST);
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
 
@@ -6119,6 +6119,12 @@ static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 	LEAVE;
 }
 
+static void ibmvfc_free_disc_buf(struct device *dev, struct ibmvfc_channels *channels)
+{
+	dma_free_coherent(dev, channels->disc_buf_sz, channels->disc_buf,
+			  channels->disc_buf_dma);
+}
+
 /**
  * ibmvfc_free_mem - Free memory for vhost
  * @vhost:	ibmvfc host struct
@@ -6133,8 +6139,7 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 	ENTER;
 	mempool_destroy(vhost->tgt_pool);
 	kfree(vhost->trace);
-	dma_free_coherent(vhost->dev, vhost->disc_buf_sz, vhost->disc_buf,
-			  vhost->disc_buf_dma);
+	ibmvfc_free_disc_buf(vhost->dev, &vhost->scsi_scrqs);
 	dma_free_coherent(vhost->dev, sizeof(*vhost->login_buf),
 			  vhost->login_buf, vhost->login_buf_dma);
 	dma_free_coherent(vhost->dev, sizeof(*vhost->channel_setup_buf),
@@ -6144,6 +6149,21 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 	LEAVE;
 }
 
+static int ibmvfc_alloc_disc_buf(struct device *dev, struct ibmvfc_channels *channels)
+{
+	channels->disc_buf_sz = sizeof(*channels->disc_buf) * max_targets;
+	channels->disc_buf = dma_alloc_coherent(dev, channels->disc_buf_sz,
+					     &channels->disc_buf_dma, GFP_KERNEL);
+
+	if (!channels->disc_buf) {
+		dev_err(dev, "Couldn't allocate %s Discover Targets buffer\n",
+			(channels->protocol == IBMVFC_PROTO_SCSI) ? "SCSI" : "NVMe");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 /**
  * ibmvfc_alloc_mem - Allocate memory for vhost
  * @vhost:	ibmvfc host struct
@@ -6179,21 +6199,15 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 		goto free_sg_pool;
 	}
 
-	vhost->disc_buf_sz = sizeof(*vhost->disc_buf) * max_targets;
-	vhost->disc_buf = dma_alloc_coherent(dev, vhost->disc_buf_sz,
-					     &vhost->disc_buf_dma, GFP_KERNEL);
-
-	if (!vhost->disc_buf) {
-		dev_err(dev, "Couldn't allocate Discover Targets buffer\n");
+	if (ibmvfc_alloc_disc_buf(dev, &vhost->scsi_scrqs))
 		goto free_login_buffer;
-	}
 
 	vhost->trace = kcalloc(IBMVFC_NUM_TRACE_ENTRIES,
 			       sizeof(struct ibmvfc_trace_entry), GFP_KERNEL);
 	atomic_set(&vhost->trace_index, -1);
 
 	if (!vhost->trace)
-		goto free_disc_buffer;
+		goto free_scsi_disc_buffer;
 
 	vhost->tgt_pool = mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
 						      sizeof(struct ibmvfc_target));
@@ -6219,9 +6233,8 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 	mempool_destroy(vhost->tgt_pool);
 free_trace:
 	kfree(vhost->trace);
-free_disc_buffer:
-	dma_free_coherent(dev, vhost->disc_buf_sz, vhost->disc_buf,
-			  vhost->disc_buf_dma);
+free_scsi_disc_buffer:
+	ibmvfc_free_disc_buf(dev, &vhost->scsi_scrqs);
 free_login_buffer:
 	dma_free_coherent(dev, sizeof(*vhost->login_buf),
 			  vhost->login_buf, vhost->login_buf_dma);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 085dfc38446a..ab3a7070171b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -827,6 +827,9 @@ struct ibmvfc_channels {
 	unsigned int active_queues;
 	unsigned int desired_queues;
 	unsigned int max_queues;
+	int disc_buf_sz;
+	struct ibmvfc_discover_targets_entry *disc_buf;
+	dma_addr_t disc_buf_dma;
 };
 
 enum ibmvfc_host_action {
@@ -881,9 +884,7 @@ struct ibmvfc_host {
 	dma_addr_t login_buf_dma;
 	struct ibmvfc_channel_setup *channel_setup_buf;
 	dma_addr_t channel_setup_dma;
-	int disc_buf_sz;
 	int log_level;
-	struct ibmvfc_discover_targets_entry *disc_buf;
 	struct mutex passthru_mutex;
 	unsigned int max_vios_scsi_channels;
 	int task_set;
@@ -904,7 +905,6 @@ struct ibmvfc_host {
 #define IBMVFC_AE_LINKUP	0x0001
 #define IBMVFC_AE_LINKDOWN	0x0002
 #define IBMVFC_AE_RSCN		0x0004
-	dma_addr_t disc_buf_dma;
 	unsigned int partition_number;
 	char partition_name[97];
 	void (*job_step) (struct ibmvfc_host *);
-- 
2.31.1

