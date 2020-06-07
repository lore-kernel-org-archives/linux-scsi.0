Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40847C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1794F2075A
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iSxF5IXx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgFGUgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51678 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgFGUgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KWjDm125835;
        Sun, 7 Jun 2020 20:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=PRA6+CzMf50HPXBaBCUA/RSf5gWWu72cmsN6V8Cp/cI=;
 b=iSxF5IXxdSu0zEMxCh7vCsdpq3gXyblbxLiOYdGe59SoHRPYU59pwueSk/9dzDKxDvaI
 zwAiihY3OPxTevd/Le2hpZ63eeBvJoeVsq2A2PyhKncJ4nAFjMcRRy09Hio2c2N/LENb
 qUH0jbptiZpkHCqkapCCQNIz0A1gCCAtZ29qna4PsobKujVVrHFHdWpZ7uiPLMUw1D5l
 NFKvJPAqAWsob98mrMLsqxIiVfkGo90HisBpiDWgn509tNEtXSaNTBvU6/Lc0A5QzKZA
 OL6YfIyva2oP0HSO1LFm7e92v8Iul8b1mcjZGeBH4KPUW8z3bJrj/icUcdX23+cb0+K2 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31g3smkxft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KSbjg020489;
        Sun, 7 Jun 2020 20:36:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31gn205nbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 057KaDkw022733;
        Sun, 7 Jun 2020 20:36:13 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:13 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 08/17] target: use tpt_id in target_stat_iport_port_ident_show
Date:   Sun,  7 Jun 2020 15:35:55 -0500
Message-Id: <1591562164-9766-9-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the tpt_id session id instead of sess_get_initiator_sid.

Note that for userspace compat this patch continues the behavior:

1. Still add the "+i+" even if there is no session_id.
2. Use the acl initiatorname instead of the transportID port/addr/name.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_stat.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 237309d..3eb1b9b 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1308,9 +1308,7 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
 	struct se_lun_acl *lacl = iport_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
 	struct se_session *se_sess;
-	struct se_portal_group *tpg;
 	ssize_t ret;
-	unsigned char buf[64];
 
 	spin_lock_irq(&nacl->nacl_sess_lock);
 	se_sess = nacl->nacl_sess;
@@ -1319,13 +1317,9 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
 		return -ENODEV;
 	}
 
-	tpg = nacl->se_tpg;
-	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
-	memset(buf, 0, 64);
-	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL)
-		tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, buf, 64);
-
-	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf);
+	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname,
+		       se_sess->tpt_id->session_id ? se_sess->tpt_id->session_id :
+		       "");
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
-- 
1.8.3.1

