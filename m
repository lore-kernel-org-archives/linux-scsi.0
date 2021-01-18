Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80514C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E7F522D71
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388427AbhARUgP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:36:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388980AbhARUfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:35:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKYl6f084990;
        Mon, 18 Jan 2021 20:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=nfFwApzLr/YH2epVDj9g4gF/FFyeWmuW3Dm2F09oTBE=;
 b=lxq0m8skR4bDgOEPJS/H+0s8utjwYm2KWSyNPOLmoBGL/ir7LPhmpsbIJc92oaQikqm6
 zKjHcNrhG3Hqxt+TwiVxVzS39bClNKea0pVtV2VwgTmyBAjb5v52Sby6GP3cfQwVm7ge
 ajnFXA3PGk24+B3hp2gTYkuFGHPcLsVRiOnptvi4xdhvl3B/NBc9VoFbIqqSE0ZL1PRi
 K9fsrKP8WZ0A282sblsojplRTWZWHlJKubs+XxZ7GSdh8QAwso73HbkJLCkGMT9DKgq8
 jAMvkeYeZV9IIkoBkQvhV89juE8PLqK867N7EnCsMedq2787j5mKRhBXT87R0r6794Ze lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 363r3kphkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:34:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKPPaj026106;
        Mon, 18 Jan 2021 20:34:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 364a2vhh0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:34:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10IKYj9K004859;
        Mon, 18 Jan 2021 20:34:45 GMT
Received: from localhost.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Jan 2021 12:34:44 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 6/7] iscsi_tcp: fix shost can_queue initialization
Date:   Mon, 18 Jan 2021 14:34:29 -0600
Message-Id: <20210118203430.4921-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118203430.4921-1-michael.christie@oracle.com>
References: <20210118203430.4921-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are setting the shost's can_queue after we add the host which is
too late, because scsi-ml will have allocated the tag set based on
the can_queue value at that time. This patch has us use the
iscsi_host_get_max_scsi_cmds helper to figure out the number of
scsi cmds.

It also fixes up the template can_queue so it reflects the max scsi
cmds we can support like how other drivers work.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a9ce6298b935..f0070e3c7ffa 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -847,6 +847,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	struct iscsi_session *session;
 	struct iscsi_sw_tcp_host *tcp_sw_host;
 	struct Scsi_Host *shost;
+	int rc;
 
 	if (ep) {
 		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
@@ -864,6 +865,11 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	shost->max_channel = 0;
 	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
+	rc = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
+	if (rc < 0)
+		goto free_host;
+	shost->can_queue = rc;
+
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
 
@@ -878,7 +884,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	tcp_sw_host = iscsi_host_priv(shost);
 	tcp_sw_host->session = session;
 
-	shost->can_queue = session->scsi_cmds_max;
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
 	return cls_session;
@@ -981,7 +986,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
+	.can_queue		= ISCSI_TOTAL_CMDS_MAX - ISCSI_MGMT_CMDS_MAX,
 	.sg_tablesize		= 4096,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
-- 
2.25.1

