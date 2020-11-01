Return-Path: <SRS0=rQSi=EH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B81CC2D0A3
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 18:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF9C422254
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 18:59:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="z7I7s2tz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKAS7z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Nov 2020 13:59:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46420 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbgKAS7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2020 13:59:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1IvTDx153649;
        Sun, 1 Nov 2020 18:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=tcUxYIrNdxMOZCH1Nl4lmA18Wk5AHcW5O74hlgdV5Kc=;
 b=z7I7s2tzl3YzbcEsIdQ7P5oN7nLKnpKEh0RO//Ltt2ri/CZuXRO/yMrCBD5eJXHKcoJG
 CQxArZEmXTo/RptIA2Pj/T/znAystFIG7KDUKas8tCJFbZ6PBOj9PnILvXc2/kVEVb+p
 EDHTzg95wxWBIffyLPopJnpJXVYdCQobnr47twjl4AsLinO9NYr7CkTpCAj8jvHtf8YF
 p88Y7JLIh3y26Z7AnpGTY398R1jrpj8pDsjZGjUkmSo1FOpPKwyvJYSOCccksTTSEzQ7
 cZqfy5h1HEalFkpBZgou5IfMA6KFjXg6Q45VECseWucKgExYpyupEkQqwa5D7l0dsLNA /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34hhvc1arm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 01 Nov 2020 18:59:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1IxaEd168690;
        Sun, 1 Nov 2020 18:59:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34hvrsxygg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Nov 2020 18:59:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A1IxmRE006676;
        Sun, 1 Nov 2020 18:59:50 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Nov 2020 10:59:48 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 8/8] tcm loop: allow queues, can queue and cmd per lun to be settable
Date:   Sun,  1 Nov 2020 12:59:34 -0600
Message-Id: <1604257174-4524-9-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=2 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011010155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011010154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make can_queue, nr_hw_queues and cmd_per_lun settable by the user
instead of hard coding them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 16d5a4e..badba43 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -46,6 +46,15 @@
 
 static int tcm_loop_queue_status(struct se_cmd *se_cmd);
 
+static unsigned int tcm_loop_nr_hw_queues = 1;
+module_param_named(nr_hw_queues, tcm_loop_nr_hw_queues, uint, 0644);
+
+static unsigned int tcm_loop_can_queue = 1024;
+module_param_named(can_queue, tcm_loop_can_queue, uint, 0644);
+
+static unsigned int tcm_loop_cmd_per_lun = 1024;
+module_param_named(cmd_per_lun, tcm_loop_cmd_per_lun, uint, 0644);
+
 /*
  * Called from struct target_core_fabric_ops->check_stop_free()
  */
@@ -305,10 +314,8 @@ static int tcm_loop_target_reset(struct scsi_cmnd *sc)
 	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
 	.eh_target_reset_handler = tcm_loop_target_reset,
-	.can_queue		= 1024,
 	.this_id		= -1,
 	.sg_tablesize		= 256,
-	.cmd_per_lun		= 1024,
 	.max_sectors		= 0xFFFF,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.module			= THIS_MODULE,
@@ -342,6 +349,9 @@ static int tcm_loop_driver_probe(struct device *dev)
 	sh->max_lun = 0;
 	sh->max_channel = 0;
 	sh->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
+	sh->nr_hw_queues = tcm_loop_nr_hw_queues;
+	sh->can_queue = tcm_loop_can_queue;
+	sh->cmd_per_lun = tcm_loop_cmd_per_lun;
 
 	host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
 		    SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE1_PROTECTION |
-- 
1.8.3.1

