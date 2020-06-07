Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AF0C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E5C52074B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nTaypmcY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgFGUg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgFGUgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KWk5m125838;
        Sun, 7 Jun 2020 20:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ECKXryUn6iwZIhWoaackKfQjn9LXva6soFkhEvc+ChM=;
 b=nTaypmcYGinPO2rtbZKDLuTcrqKvTk8F7wRZfWiP0gcnh9kDT4cqvV9e07eQWSJ7XhYF
 U9UUdUYIlEGu9b898Q6YhdOLK95yFXfP2juQyL8SCIGbRQZI18jLAsCZqoKCXuzoOtKw
 zhLO6yMdMvyfKgNGVCqC8Ddcx9iOLWZq/85g1D2GxWULMHqjN2ZGgqMlXhl8T7rTDxZ9
 u/+VccJ4u/qCmM/2o3m5wd7jSlbqZwwbje8mc4LHw6FHepekXwUPyYoyNjZYjUboYG7O
 2VKOcHJamGa6kAE4TJnSO/Z2x6ZTYfMAOSN/y8PEBuuFa4i6mtBjZ/ohL8NuJHBgIqqs lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31g3smkxfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KRp6H015821;
        Sun, 7 Jun 2020 20:36:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31gn2u8669-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:18 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057KaH61024052;
        Sun, 7 Jun 2020 20:36:17 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:17 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 16/17] iscsi target: export session state and alias in sysfs
Date:   Sun,  7 Jun 2020 15:36:03 -0500
Message-Id: <1591562164-9766-17-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=2
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export the session state and alias in sysfs.

Note:
It does not export the per connection state. In the future we can
have the iscsi target add/rm an attribute group directly for each
connection when we login and logout/drop a connection. Since those
are dynamic and can change while the session exists, we don't need
them at device addition so it can be done directly from the module.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 97 ++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 21 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index ba608fa..64de2ec 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -28,6 +28,28 @@
 #include "iscsi_target.h"
 #include <target/iscsi/iscsi_target_stat.h>
 
+static const struct {
+	enum target_sess_state_table	value;
+	char				*name;
+} session_states[] = {
+	{ TARG_SESS_STATE_FREE,		"TARG_SESS_FREE" },
+	{ TARG_SESS_STATE_ACTIVE,	"TARG_SESS_STATE_ACTIVE" },
+	{ TARG_SESS_STATE_LOGGED_IN,	"TARG_SESS_STATE_LOGGED_IN" },
+	{ TARG_SESS_STATE_FAILED,	"TARG_SESS_STATE_FAILED" },
+	{ TARG_SESS_STATE_IN_CONTINUE,	"TARG_SESS_STATE_IN_CONTINUE" },
+};
+
+static const char *session_state_name(enum target_sess_state_table state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(session_states); i++) {
+		if (session_states[i].value == state)
+			return session_states[i].name;
+	}
+
+	return NULL;
+}
 
 /* Start items for lio_target_portal_cit */
 
@@ -502,6 +524,7 @@ static ssize_t lio_target_nacl_info_show(struct config_item *item, char *page)
 	struct iscsi_session *sess;
 	struct iscsi_conn *conn;
 	struct se_session *se_sess;
+	const char *state_name;
 	ssize_t rb = 0;
 	u32 max_cmd_sn;
 
@@ -525,27 +548,12 @@ static ssize_t lio_target_nacl_info_show(struct config_item *item, char *page)
 				(sess->sess_ops->SessionType) ?
 				"Discovery" : "Normal");
 		rb += sprintf(page+rb, "Session State: ");
-		switch (sess->session_state) {
-		case TARG_SESS_STATE_FREE:
-			rb += sprintf(page+rb, "TARG_SESS_FREE\n");
-			break;
-		case TARG_SESS_STATE_ACTIVE:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_ACTIVE\n");
-			break;
-		case TARG_SESS_STATE_LOGGED_IN:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_LOGGED_IN\n");
-			break;
-		case TARG_SESS_STATE_FAILED:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_FAILED\n");
-			break;
-		case TARG_SESS_STATE_IN_CONTINUE:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_IN_CONTINUE\n");
-			break;
-		default:
-			rb += sprintf(page+rb, "ERROR: Unknown Session"
-					" State!\n");
-			break;
-		}
+
+		state_name = session_state_name(sess->session_state);
+		if (state_name)
+			rb += sprintf(page+rb, "%s\n", state_name);
+		else
+			rb += sprintf(page+rb, "ERROR: Unknown Session State!\n");
 
 		rb += sprintf(page+rb, "---------------------[iSCSI Session"
 				" Values]-----------------------\n");
@@ -1333,6 +1341,51 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 /* End lio_target_discovery_auth_cit */
 
+/* session sysfs */
+static ssize_t
+lio_show_sess_state(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct se_session *se_sess = container_of(dev, struct se_session, dev);
+	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+	const char *state_name;
+
+	state_name = session_state_name(sess->session_state);
+	if (!state_name)
+		return -EINVAL;
+
+	return snprintf(buf, PAGE_SIZE, "%s", state_name);
+}
+
+static ssize_t
+lio_show_initiator_alias(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct se_session *se_sess = container_of(dev, struct se_session, dev);
+	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+
+	return snprintf(buf, PAGE_SIZE, "%s", sess->sess_ops->InitiatorAlias);
+}
+
+static DEVICE_ATTR(state, S_IRUGO, lio_show_sess_state, NULL);
+static DEVICE_ATTR(initiator_alias, S_IRUGO, lio_show_initiator_alias, NULL);
+
+static struct attribute *lio_sess_attrs[] = {
+	&dev_attr_state.attr,
+	&dev_attr_initiator_alias.attr,
+	NULL,
+};
+
+static struct attribute_group lio_sess_attr_group = {
+	.name = "iscsi_session",
+	.attrs = lio_sess_attrs,
+};
+
+static const struct attribute_group *lio_sess_attr_groups[] = {
+	&lio_sess_attr_group,
+	NULL,
+};
+
 /* Start functions for target_core_fabric_ops */
 
 static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
@@ -1556,6 +1609,8 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.fabric_drop_np			= lio_target_call_delnpfromtpg,
 	.fabric_init_nodeacl		= lio_target_init_nodeacl,
 
+	.session_attr_groups		= lio_sess_attr_groups,
+
 	.tfc_discovery_attrs		= lio_target_discovery_auth_attrs,
 	.tfc_wwn_attrs			= lio_target_wwn_attrs,
 	.tfc_tpg_base_attrs		= lio_target_tpg_attrs,
-- 
1.8.3.1

