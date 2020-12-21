Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38DFC433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C1B22EBE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgLUCie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 21:38:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39520 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgLUCie (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 21:38:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2UcIX087211;
        Mon, 21 Dec 2020 02:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=smBJhWpgSaycTPReHIyPVkMbzrWv1nXl9Pj3Ks2iQq0=;
 b=Bk50hzHbO4DwHP8b3lIB4GkaRjGCE7Rpo1tikJehGmQ4HVf2VL7Z3gbgBwmY07MvHUC1
 A/5KR12RXFGEKxXfxi+vxZB2ONDbc4XJ6yi5BvvA/aGUMW/M/tLy3KQDdFFHyXxPfCJn
 YQMi8WBt0/7n5RexXb65nLmGbjSqRcL6LxEOd44PCM+MsFLBlSuRNdVD4uZOHipUGsYR
 aRXR9QJF23U1QBSbveyGfmIOS+pn2EfoWwsWsRKxj5HDHF+XRN5MVpqC+R9w1v8iZxVf
 TsBslxab4A6ITnRTkUTa9E2O3tJDCzx3kGOSC6RCngCpJdQhMHfb4yGalDDK1AFQHNBs tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35h8xquauj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 02:37:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2ZTwP081534;
        Mon, 21 Dec 2020 02:37:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35hu3kugcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 02:37:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BL2bQ8H013175;
        Mon, 21 Dec 2020 02:37:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 20 Dec 2020 18:37:26 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 5/6 V3] iscsi_tcp: fix shost can_queue initialization
Date:   Sun, 20 Dec 2020 20:37:05 -0600
Message-Id: <1608518226-30376-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are setting the shost's can_queue after we add the host which is
too late, because scsi-ml will have allocated the tag set based on
the can_queue value at that time. This patch has us use the
iscsi_host_get_max_scsi_cmds helper to figure out the number of
scsi cmds, so we can set it properly. We should now not be limited
to 128 cmds per session.

It also fixes up the template can_queue so it reflects the max scsi
cmds we can support like how other drivers work.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index df47557..7a5aec7 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -847,6 +847,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 	struct iscsi_session *session;
 	struct iscsi_sw_tcp_host *tcp_sw_host;
 	struct Scsi_Host *shost;
+	int rc;
 
 	if (ep) {
 		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
@@ -864,6 +865,11 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 	shost->max_channel = 0;
 	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
+	rc = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
+	if (rc < 0)
+		goto free_host;
+	shost->can_queue = rc;
+
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
 
@@ -878,7 +884,6 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 	tcp_sw_host = iscsi_host_priv(shost);
 	tcp_sw_host->session = session;
 
-	shost->can_queue = session->scsi_cmds_max;
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
 	return cls_session;
@@ -981,7 +986,7 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
+	.can_queue		= ISCSI_TOTAL_CMDS_MAX - ISCSI_MGMT_CMDS_MAX,
 	.sg_tablesize		= 4096,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
-- 
1.8.3.1

