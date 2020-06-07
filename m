Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427E7C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BEE020760
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kQJg1gI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgFGUgX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgFGUgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KWnSP125842;
        Sun, 7 Jun 2020 20:36:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=bVmm3tdbw0XvH6VgY+Z+jhMHDgOo2ycU8ZOdkn4UUx8=;
 b=kQJg1gI8ELxO43rYjvJfD/VeH1tHt5YE41Xa4VTFpFe3XCJKULkHVSX7lVHhevgjsWA9
 3rka+qMLBpfWyg8RQOINfhwJqm75mLM2vgVUVA92c7NE0BVRahXp0o9Gz9kDcti7otFZ
 g0LTXw5nHzpLZtZzlnRpp56I70z+YFrMvpq2SoO6taxEDypi50uFUhpTw22M4NMhrhR0
 UPEzI6IKmfYmg2iYI1MFsehgkn+UyVBUUrA1UEDJ5+nIEHI3hnV7VB9L51KtgzLlFosf
 Ftg3/wDGLlZ8g2AMzJMTKADxdsfvBKh29ZS2V4sIda5LGn0arG58iEGWxiT7/mSjUGiL fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31g3smkxfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KRjhJ075816;
        Sun, 7 Jun 2020 20:36:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31gmqk8a64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 057KaCXI022725;
        Sun, 7 Jun 2020 20:36:12 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:12 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>
Subject: [PATCH 06/17] xen scsiback: use target_parse_emulated_name
Date:   Sun,  7 Jun 2020 15:35:53 -0500
Message-Id: <1591562164-9766-7-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
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

Use target_parse_emulated_name so the acl and SCSI names are
properly formatted.

Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/xen/xen-scsiback.c | 66 ++++++++--------------------------------------
 1 file changed, 11 insertions(+), 55 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 93cb386..f70b6da 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1509,7 +1509,8 @@ static int scsiback_alloc_sess_cb(struct se_portal_group *se_tpg,
 }
 
 static int scsiback_make_nexus(struct scsiback_tpg *tpg,
-				const char *name)
+				const char *tpt_id_name,
+				const char *acl_name)
 {
 	struct scsiback_nexus *tv_nexus;
 	int ret = 0;
@@ -1530,8 +1531,9 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
 						     VSCSI_DEFAULT_SESSION_TAGS,
 						     sizeof(struct vscsibk_pend),
-						     TARGET_PROT_NORMAL, name,
-						     name, tv_nexus,
+						     TARGET_PROT_NORMAL,
+						     tpt_id_name, acl_name,
+						     tv_nexus,
 						     scsiback_alloc_sess_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		kfree(tv_nexus);
@@ -1619,7 +1621,7 @@ static ssize_t scsiback_tpg_nexus_store(struct config_item *item,
 	struct scsiback_tpg *tpg = container_of(se_tpg,
 				struct scsiback_tpg, se_tpg);
 	struct scsiback_tport *tport_wwn = tpg->tport;
-	unsigned char i_port[VSCSI_NAMELEN], *ptr, *port_ptr;
+	unsigned char i_port[VSCSI_NAMELEN], *tpt_id_name;
 	int ret;
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed.
@@ -1628,59 +1630,13 @@ static ssize_t scsiback_tpg_nexus_store(struct config_item *item,
 		ret = scsiback_drop_nexus(tpg);
 		return (!ret) ? count : ret;
 	}
-	/*
-	 * Otherwise make sure the passed virtual Initiator port WWN matches
-	 * the fabric protocol_id set in scsiback_make_tport(), and call
-	 * scsiback_make_nexus().
-	 */
-	if (strlen(page) >= VSCSI_NAMELEN) {
-		pr_err("Emulated NAA Sas Address: %s, exceeds max: %d\n",
-			page, VSCSI_NAMELEN);
-		return -EINVAL;
-	}
-	snprintf(&i_port[0], VSCSI_NAMELEN, "%s", page);
 
-	ptr = strstr(i_port, "naa.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_SAS) {
-			pr_err("Passed SAS Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "fc.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_FCP) {
-			pr_err("Passed FCP Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[3]; /* Skip over "fc." */
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "iqn.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_ISCSI) {
-			pr_err("Passed iSCSI Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	pr_err("Unable to locate prefix for emulated Initiator Port: %s\n",
-		i_port);
-	return -EINVAL;
-	/*
-	 * Clear any trailing newline for the NAA WWN
-	 */
-check_newline:
-	if (i_port[strlen(i_port) - 1] == '\n')
-		i_port[strlen(i_port) - 1] = '\0';
+	ret = target_parse_emulated_name(tport_wwn->tport_proto_id, page,
+					 i_port, VSCSI_NAMELEN, &tpt_id_name);
+	if (ret)
+		return ret;
 
-	ret = scsiback_make_nexus(tpg, port_ptr);
+	ret = scsiback_make_nexus(tpg, tpt_id_name, i_port);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

