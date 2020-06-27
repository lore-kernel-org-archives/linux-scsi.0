Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278ACC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A0A20857
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aBJI6w58"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgF0Efc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:35:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42094 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgF0Ef0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:35:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4WxLJ045438;
        Sat, 27 Jun 2020 04:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=SktdWlZAxVirP2saH2LaktTAxFtxq4YWloWq9Ic/Vl8=;
 b=aBJI6w58y35Tq+aveT+H7XhC3IfHfUWzw3pXyWHvG8wt0ZBf0fiSTBV1bD7cnr/Ol7Xr
 RSE7EThibUxkcU4cr7Q9RRJgbbeT14SyM5kQHi83hRd0KRessyrrXMypzFov+R7bCEjo
 pQkx6QMdZwE08NE47vMcZbrLg/C+Sy+s9reUPYAxTZx3hFvLBA/yrJuIpQm66OypN0A7
 QJXytTACvqoXe2eiHpfGI0acijTpg/R38hx+hGu717GliZBXUC4d5TDjIJSEN5KvdqH4
 xLSheVLJZ7UbOgyDx+XrbB9v87C9kDIcjNoVLEZTTCivDjlq0uTbK4ZuOW91ujrLYzuY +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31wx2m82g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:35:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4YJtC122171;
        Sat, 27 Jun 2020 04:35:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31wv58v8ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R4ZGAK030605;
        Sat, 27 Jun 2020 04:35:16 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 08/10] ibm,loop,vhost,xenscsi: add close_session callouts
Date:   Fri, 26 Jun 2020 23:35:07 -0500
Message-Id: <1593232509-13720-9-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 impostorscore=0 cotscore=-2147483648 priorityscore=1501 malwarescore=0
 phishscore=0 suspectscore=2 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006270030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call the fabric modules drop nexus functions from the close_session
callout.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 14 +++++++++++---
 drivers/target/loopback/tcm_loop.c       | 17 ++++++++++++-----
 drivers/usb/gadget/function/f_tcm.c      | 17 ++++++++++++-----
 drivers/vhost/scsi.c                     | 16 ++++++++++++----
 drivers/xen/xen-scsiback.c               | 16 ++++++++++++----
 5 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index a817524..81f9649 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2239,10 +2239,12 @@ static int ibmvscsis_make_nexus(struct ibmvscsis_tport *tport)
 	return rc;
 }
 
-static int ibmvscsis_drop_nexus(struct ibmvscsis_tport *tport)
+static int ibmvscsis_drop_nexus(struct se_portal_group *se_tpg)
 {
-	struct se_session *se_sess;
+	struct ibmvscsis_tport *tport =
+		container_of(se_tpg, struct ibmvscsis_tport, se_tpg);
 	struct ibmvscsis_nexus *nexus;
+	struct se_session *se_sess;
 
 	nexus = tport->ibmv_nexus;
 	if (!nexus)
@@ -2262,6 +2264,11 @@ static int ibmvscsis_drop_nexus(struct ibmvscsis_tport *tport)
 	return 0;
 }
 
+static int ibmvscsis_close_session(struct se_session *se_sess)
+{
+	return ibmvscsis_drop_nexus(se_sess->se_tpg);
+}
+
 /**
  * ibmvscsis_srp_login() - Process an SRP Login Request
  * @vscsi:	Pointer to our adapter structure
@@ -3934,7 +3941,7 @@ static void ibmvscsis_drop_tpg(struct se_portal_group *se_tpg)
 	/*
 	 * Release the virtual I_T Nexus for this ibmvscsis TPG
 	 */
-	ibmvscsis_drop_nexus(tport);
+	ibmvscsis_drop_nexus(se_tpg);
 	/*
 	 * Deregister the se_tpg from TCM..
 	 */
@@ -4036,6 +4043,7 @@ static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
 	.queue_status			= ibmvscsis_queue_status,
 	.queue_tm_rsp			= ibmvscsis_queue_tm_rsp,
 	.aborted_task			= ibmvscsis_aborted_task,
+	.close_session			= ibmvscsis_close_session,
 	/*
 	 * Setup function pointers for logic in target_core_fabric_configfs.c
 	 */
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 570dff2..d5e616e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -749,11 +749,12 @@ static int tcm_loop_make_nexus(
 	return 0;
 }
 
-static int tcm_loop_drop_nexus(
-	struct tcm_loop_tpg *tpg)
+static int tcm_loop_drop_nexus(struct se_portal_group *se_tpg)
 {
-	struct se_session *se_sess;
+	struct tcm_loop_tpg *tpg = container_of(se_tpg, struct tcm_loop_tpg,
+						tl_se_tpg);
 	struct tcm_loop_nexus *tl_nexus;
+	struct se_session *se_sess;
 
 	mutex_lock(&tpg->tl_nexus_mutex);
 	tl_nexus = tpg->tl_nexus;
@@ -789,6 +790,11 @@ static int tcm_loop_drop_nexus(
 	return 0;
 }
 
+static int tcm_loop_close_session(struct se_session *se_sess)
+{
+	return tcm_loop_drop_nexus(se_sess->se_tpg);
+}
+
 /* End items for tcm_loop_nexus_cit */
 
 static ssize_t tcm_loop_tpg_nexus_show(struct config_item *item, char *page)
@@ -826,7 +832,7 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	 * Shutdown the active I_T nexus if 'NULL' is passed..
 	 */
 	if (!strncmp(page, "NULL", 4)) {
-		ret = tcm_loop_drop_nexus(tl_tpg);
+		ret = tcm_loop_drop_nexus(se_tpg);
 		return (!ret) ? count : ret;
 	}
 	/*
@@ -1017,7 +1023,7 @@ static void tcm_loop_drop_naa_tpg(
 	/*
 	 * Release the I_T Nexus for the Virtual target link if present
 	 */
-	tcm_loop_drop_nexus(tl_tpg);
+	tcm_loop_drop_nexus(se_tpg);
 	/*
 	 * Deregister the tl_tpg as a emulated TCM Target Endpoint
 	 */
@@ -1155,6 +1161,7 @@ static ssize_t tcm_loop_wwn_version_show(struct config_item *item, char *page)
 	.queue_status			= tcm_loop_queue_status,
 	.queue_tm_rsp			= tcm_loop_queue_tm_rsp,
 	.aborted_task			= tcm_loop_aborted_task,
+	.close_session			= tcm_loop_close_session,
 	.fabric_make_wwn		= tcm_loop_make_scsi_hba,
 	.fabric_drop_wwn		= tcm_loop_drop_scsi_hba,
 	.fabric_make_tpg		= tcm_loop_make_naa_tpg,
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index e66884f..ed449ab 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1415,7 +1415,7 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	return ERR_PTR(ret);
 }
 
-static int tcm_usbg_drop_nexus(struct usbg_tpg *);
+static int tcm_usbg_drop_nexus(struct se_portal_group *);
 
 static void usbg_drop_tpg(struct se_portal_group *se_tpg)
 {
@@ -1424,7 +1424,7 @@ static void usbg_drop_tpg(struct se_portal_group *se_tpg)
 	unsigned i;
 	struct f_tcm_opts *opts;
 
-	tcm_usbg_drop_nexus(tpg);
+	tcm_usbg_drop_nexus(se_tpg);
 	core_tpg_deregister(se_tpg);
 	destroy_workqueue(tpg->workqueue);
 
@@ -1597,10 +1597,11 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 	return ret;
 }
 
-static int tcm_usbg_drop_nexus(struct usbg_tpg *tpg)
+static int tcm_usbg_drop_nexus(struct se_portal_group *se_tpg)
 {
-	struct se_session *se_sess;
+	struct usbg_tpg *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
 	struct tcm_usbg_nexus *tv_nexus;
+	struct se_session *se_sess;
 	int ret = -ENODEV;
 
 	mutex_lock(&tpg->tpg_mutex);
@@ -1635,6 +1636,11 @@ static int tcm_usbg_drop_nexus(struct usbg_tpg *tpg)
 	return ret;
 }
 
+static int tcm_usbg_close_session(struct se_session *se_sess)
+{
+	return tcm_usbg_drop_nexus(se_sess->se_tpg);
+}
+
 static ssize_t tcm_usbg_tpg_nexus_store(struct config_item *item,
 		const char *page, size_t count)
 {
@@ -1644,7 +1650,7 @@ static ssize_t tcm_usbg_tpg_nexus_store(struct config_item *item,
 	int ret;
 
 	if (!strncmp(page, "NULL", 4)) {
-		ret = tcm_usbg_drop_nexus(tpg);
+		ret = tcm_usbg_drop_nexus(se_tpg);
 		return (!ret) ? count : ret;
 	}
 	if (strlen(page) >= USBG_NAMELEN) {
@@ -1723,6 +1729,7 @@ static int usbg_check_stop_free(struct se_cmd *se_cmd)
 	.queue_tm_rsp			= usbg_queue_tm_rsp,
 	.aborted_task			= usbg_aborted_task,
 	.check_stop_free		= usbg_check_stop_free,
+	.close_session			= tcm_usbg_close_session,
 
 	.fabric_make_wwn		= usbg_make_tport,
 	.fabric_drop_wwn		= usbg_drop_tport,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7896e69..d30b8da 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1972,10 +1972,12 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 	return 0;
 }
 
-static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
+static int vhost_scsi_drop_nexus(struct se_portal_group *se_tpg)
 {
-	struct se_session *se_sess;
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg, struct vhost_scsi_tpg,
+						  se_tpg);
 	struct vhost_scsi_nexus *tv_nexus;
+	struct se_session *se_sess;
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tv_nexus = tpg->tpg_nexus;
@@ -2022,6 +2024,11 @@ static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
 	return 0;
 }
 
+static int vhost_scsi_close_session(struct se_session *se_sess)
+{
+	return vhost_scsi_drop_nexus(se_sess->se_tpg);
+}
+
 static ssize_t vhost_scsi_tpg_nexus_show(struct config_item *item, char *page)
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
@@ -2056,7 +2063,7 @@ static ssize_t vhost_scsi_tpg_nexus_store(struct config_item *item,
 	 * Shutdown the active I_T nexus if 'NULL' is passed..
 	 */
 	if (!strncmp(page, "NULL", 4)) {
-		ret = vhost_scsi_drop_nexus(tpg);
+		ret = vhost_scsi_drop_nexus(se_tpg);
 		return (!ret) ? count : ret;
 	}
 	/*
@@ -2176,7 +2183,7 @@ static void vhost_scsi_drop_tpg(struct se_portal_group *se_tpg)
 	/*
 	 * Release the virtual I_T Nexus for this vhost TPG
 	 */
-	vhost_scsi_drop_nexus(tpg);
+	vhost_scsi_drop_nexus(se_tpg);
 	/*
 	 * Deregister the se_tpg from TCM..
 	 */
@@ -2294,6 +2301,7 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 	.queue_status			= vhost_scsi_queue_status,
 	.queue_tm_rsp			= vhost_scsi_queue_tm_rsp,
 	.aborted_task			= vhost_scsi_aborted_task,
+	.close_session			= vhost_scsi_close_session,
 	/*
 	 * Setup callers for generic logic in target_core_fabric_configfs.c
 	 */
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index f0a8fc7..ffd1a7a 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1538,10 +1538,12 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 	return ret;
 }
 
-static int scsiback_drop_nexus(struct scsiback_tpg *tpg)
+static int scsiback_drop_nexus(struct se_portal_group *se_tpg)
 {
-	struct se_session *se_sess;
+	struct scsiback_tpg *tpg = container_of(se_tpg, struct scsiback_tpg,
+						se_tpg);
 	struct scsiback_nexus *tv_nexus;
+	struct se_session *se_sess;
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tv_nexus = tpg->tpg_nexus;
@@ -1585,6 +1587,11 @@ static int scsiback_drop_nexus(struct scsiback_tpg *tpg)
 	return 0;
 }
 
+static int scsiback_close_session(struct se_session *se_sess)
+{
+	return scsiback_drop_nexus(se_sess->se_tpg);
+}
+
 static ssize_t scsiback_tpg_nexus_show(struct config_item *item, char *page)
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
@@ -1619,7 +1626,7 @@ static ssize_t scsiback_tpg_nexus_store(struct config_item *item,
 	 * Shutdown the active I_T nexus if 'NULL' is passed.
 	 */
 	if (!strncmp(page, "NULL", 4)) {
-		ret = scsiback_drop_nexus(tpg);
+		ret = scsiback_drop_nexus(se_tpg);
 		return (!ret) ? count : ret;
 	}
 	/*
@@ -1776,7 +1783,7 @@ static void scsiback_drop_tpg(struct se_portal_group *se_tpg)
 	/*
 	 * Release the virtual I_T Nexus for this xen-pvscsi TPG
 	 */
-	scsiback_drop_nexus(tpg);
+	scsiback_drop_nexus(se_tpg);
 	/*
 	 * Deregister the se_tpg from TCM.
 	 */
@@ -1814,6 +1821,7 @@ static int scsiback_check_false(struct se_portal_group *se_tpg)
 	.queue_status			= scsiback_queue_status,
 	.queue_tm_rsp			= scsiback_queue_tm_rsp,
 	.aborted_task			= scsiback_aborted_task,
+	.close_session			= scsiback_close_session,
 	/*
 	 * Setup callers for generic logic in target_core_fabric_configfs.c
 	 */
-- 
1.8.3.1

