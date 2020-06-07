Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3474C433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FD9620760
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wtb0Ficg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgFGUg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51732 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbgFGUgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KXdmj129180;
        Sun, 7 Jun 2020 20:36:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=wwg0352vLBMbYyfEiFHFIAeNOtcQR44rqjWspcIejKg=;
 b=wtb0FicgPPH9HK3YHUX03pBCkSSNGenjJ+zNHbFIxePyd8AQBUuxKNl5tp807A4BndNU
 4Xc5wm1fuHL2w/VOWqwNfZAuS03kiI0lMQ8L0vs5OdpSftTE94tvEPLPK+DnHyT5m6F8
 3P5zssMIL10ikJfC+r06O4mS7Fhxud1upJMlo30Fu/tikG77ehupIodVCTQVehFUwSxV
 psHyJsmb8n7Yl48jI3pGZ/LihxmvfB6SAjaETHG3ugM/xg+YMgJhmWGRAUAjWopDD+Nf
 6W4Dx+FWRoZPswb7CPg358xph13XDObQfYGaYuJPL2Dnqm+kbu/IoWacH4mnXJbe44B9 Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31g3smkxfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KRj3U075755;
        Sun, 7 Jun 2020 20:36:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31gmqk8a63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057KaCkH003588;
        Sun, 7 Jun 2020 20:36:12 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:12 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 05/17] vhost scsi: use target_parse_emulated_name
Date:   Sun,  7 Jun 2020 15:35:52 -0500
Message-Id: <1591562164-9766-6-git-send-email-michael.christie@oracle.com>
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

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/vhost/scsi.c | 69 +++++++++-------------------------------------------
 1 file changed, 11 insertions(+), 58 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 15aabc2..37f66f8 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1938,7 +1938,8 @@ static int vhost_scsi_nexus_cb(struct se_portal_group *se_tpg,
 }
 
 static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
-				const char *name)
+				const char *tpt_id_name,
+				const char *acl_name)
 {
 	struct vhost_scsi_nexus *tv_nexus;
 
@@ -1964,8 +1965,8 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 					VHOST_SCSI_DEFAULT_TAGS,
 					sizeof(struct vhost_scsi_cmd),
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					(unsigned char *)name,
-					(unsigned char *)name, tv_nexus,
+					(unsigned char *)tpt_id_name,
+					(unsigned char *)acl_name, tv_nexus,
 					vhost_scsi_nexus_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
@@ -2056,7 +2057,7 @@ static ssize_t vhost_scsi_tpg_nexus_store(struct config_item *item,
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
 	struct vhost_scsi_tport *tport_wwn = tpg->tport;
-	unsigned char i_port[VHOST_SCSI_NAMELEN], *ptr, *port_ptr;
+	unsigned char i_port[VHOST_SCSI_NAMELEN], *tpt_id_name;
 	int ret;
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed..
@@ -2065,62 +2066,14 @@ static ssize_t vhost_scsi_tpg_nexus_store(struct config_item *item,
 		ret = vhost_scsi_drop_nexus(tpg);
 		return (!ret) ? count : ret;
 	}
-	/*
-	 * Otherwise make sure the passed virtual Initiator port WWN matches
-	 * the fabric protocol_id set in vhost_scsi_make_tport(), and call
-	 * vhost_scsi_make_nexus().
-	 */
-	if (strlen(page) >= VHOST_SCSI_NAMELEN) {
-		pr_err("Emulated NAA Sas Address: %s, exceeds"
-				" max: %d\n", page, VHOST_SCSI_NAMELEN);
-		return -EINVAL;
-	}
-	snprintf(&i_port[0], VHOST_SCSI_NAMELEN, "%s", page);
 
-	ptr = strstr(i_port, "naa.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_SAS) {
-			pr_err("Passed SAS Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				vhost_scsi_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "fc.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_FCP) {
-			pr_err("Passed FCP Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				vhost_scsi_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[3]; /* Skip over "fc." */
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "iqn.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_ISCSI) {
-			pr_err("Passed iSCSI Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				vhost_scsi_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	pr_err("Unable to locate prefix for emulated Initiator Port:"
-			" %s\n", i_port);
-	return -EINVAL;
-	/*
-	 * Clear any trailing newline for the NAA WWN
-	 */
-check_newline:
-	if (i_port[strlen(i_port)-1] == '\n')
-		i_port[strlen(i_port)-1] = '\0';
+	ret = target_parse_emulated_name(tport_wwn->tport_proto_id, page,
+					 i_port, VHOST_SCSI_NAMELEN,
+					 &tpt_id_name);
+	if (ret)
+		return ret;
 
-	ret = vhost_scsi_make_nexus(tpg, port_ptr);
+	ret = vhost_scsi_make_nexus(tpg, tpt_id_name, i_port);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

