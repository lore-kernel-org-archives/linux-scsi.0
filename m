Return-Path: <SRS0=2Tp4=EA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37707C4363A
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2E9A223BD
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jcN12bGA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420346AbgJYXDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 19:03:39 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40704 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1419588AbgJYXDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Oct 2020 19:03:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PN04Uk150044;
        Sun, 25 Oct 2020 23:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=NTEIIGjYqbpiA+dDdXIPUXjMPN4NBK5Jl5VILAwlyKk=;
 b=jcN12bGAi8J0Y/blXHN5pDTl681mNWTwIK8uVomNKGEygofhXbfWLSV2/d7eXiEBtNw0
 Vhn05IdXcXq1MIDWCv3RkXhGxLHV8igewaJXLg+c6u5oW0oq5G28v4T9OPn62NQMa6LV
 86LE6sRzL6VcN/3m1Rr3Df+6/Pt+kIsfViTfWsLg6GcXOHs/HGzAZbogZm+e8Qw0+flZ
 VrRsGE7bxyZ025M1YXrC10EJBkfS/XbGiGDHTtYhWu4ynJ2HCv80JY9iIrwG+nR36nFw
 6P+VH4bbZ0OpUZCcF85B5qD8SPSs6p8yoA3dFCCmbAzyYthzRjHmafWa/O1y0uSWnDGO Gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9sajmms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Oct 2020 23:03:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PN0JtI033116;
        Sun, 25 Oct 2020 23:03:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwujrt70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Oct 2020 23:03:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09PN3RjZ018696;
        Sun, 25 Oct 2020 23:03:27 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Oct 2020 16:03:26 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 7/7] tcm loop: allow queues, can queue and cmd per lun to be settable
Date:   Sun, 25 Oct 2020 18:03:18 -0500
Message-Id: <1603666998-8086-8-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010250174
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make can_queue, nr_hw_queues and cmd_per_lun settable by the user
instead of hard coding them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 16d5a4e..31315b5 100644
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

