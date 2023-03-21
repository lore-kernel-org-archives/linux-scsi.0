Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56680C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCUCGi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCUCGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:06:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73892ED5B;
        Mon, 20 Mar 2023 19:06:34 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4PPJ017062;
        Tue, 21 Mar 2023 02:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=ICr6JzllCR1YW+fQxz7qhwf/ZHRNWHHojOVxIp7h5Q4=;
 b=kn/EgPcVAhsLSIqVULY+HZA0wyfSWr+dvbIuaomq9Wi+F3YWDfb2Y1/pfFf9KIFGVl+E
 9b8AXJKTYruNSb6dv7aJR9pqfX1pIo1G29wx/JTfxEBZgVzwce7abs/x7cmDAmj1Hqv4
 bYJZ5IY6YzYczO86vILwUV015m9hQcN+6F7fztEb+uNKn2Lr9xWxTEzlDQuuxODcuIvp
 I4M8tjQFfhkFzGn9H3/ZCjMt2DrKBMNYNofS0SsGZD2mVG/RrQ5qyIzoGv6WzGo61wuc
 Wf9lFBC+/HIU4dlvm0INonMaOocRA7PlUIFYfUhqYZmuR6+yX2IDm1N0GcFP68SBWw42 6w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5bcd14c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KNGEQa010416;
        Tue, 21 Mar 2023 02:06:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjn4c38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:31 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32L26T9U007440;
        Tue, 21 Mar 2023 02:06:31 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-165-250.vpn.oracle.com [10.154.165.250])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3peqjn4c0v-3;
        Tue, 21 Mar 2023 02:06:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 2/7] vhost-scsi: Fix crash during LUN unmapping
Date:   Mon, 20 Mar 2023 21:06:19 -0500
Message-Id: <20230321020624.13323-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321020624.13323-1-michael.christie@oracle.com>
References: <20230321020624.13323-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_18,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210017
X-Proofpoint-ORIG-GUID: nfcE546NliwODiwmeltDLuD_vdtg3kGS
X-Proofpoint-GUID: nfcE546NliwODiwmeltDLuD_vdtg3kGS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We normally clear the endpoint then unmap LUNs so the devices are fully
shutdown when the LUN is unmapped, but it's legal to unmap before
clearing. If the user does that while TMFs are running then we can end
up crashing.

vhost_scsi_port_unlink assumes that the LUN's tmf struct will always be on
the tmf_queue list. However, if a TMF is running then it will have been
removed while it's executing. If we do a LUN unmap at this time, then
we assume the entry is on the list and just start accessing it and free
it.

This fixes the bug by just allocating the vhost_scsi_tmf struct when it's
needed like is done with the se_tmr struct that's needed when we submit
the TMF. In this path perf is not an issue and we can use GFP_KERNEL
since it won't swing directly back on us, so we don't need to preallocate
the struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5875241e1654..32d0be968103 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -125,7 +125,6 @@ struct vhost_scsi_tpg {
 	struct se_portal_group se_tpg;
 	/* Pointer back to vhost_scsi, protected by tv_tpg_mutex */
 	struct vhost_scsi *vhost_scsi;
-	struct list_head tmf_queue;
 };
 
 struct vhost_scsi_tport {
@@ -206,10 +205,8 @@ struct vhost_scsi {
 
 struct vhost_scsi_tmf {
 	struct vhost_work vwork;
-	struct vhost_scsi_tpg *tpg;
 	struct vhost_scsi *vhost;
 	struct vhost_scsi_virtqueue *svq;
-	struct list_head queue_entry;
 
 	struct se_cmd se_cmd;
 	u8 scsi_resp;
@@ -352,12 +349,9 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 
 static void vhost_scsi_release_tmf_res(struct vhost_scsi_tmf *tmf)
 {
-	struct vhost_scsi_tpg *tpg = tmf->tpg;
 	struct vhost_scsi_inflight *inflight = tmf->inflight;
 
-	mutex_lock(&tpg->tv_tpg_mutex);
-	list_add_tail(&tpg->tmf_queue, &tmf->queue_entry);
-	mutex_unlock(&tpg->tv_tpg_mutex);
+	kfree(tmf);
 	vhost_scsi_put_inflight(inflight);
 }
 
@@ -1194,19 +1188,11 @@ vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 		goto send_reject;
 	}
 
-	mutex_lock(&tpg->tv_tpg_mutex);
-	if (list_empty(&tpg->tmf_queue)) {
-		pr_err("Missing reserve TMF. Could not handle LUN RESET.\n");
-		mutex_unlock(&tpg->tv_tpg_mutex);
+	tmf = kzalloc(sizeof(*tmf), GFP_KERNEL);
+	if (!tmf)
 		goto send_reject;
-	}
-
-	tmf = list_first_entry(&tpg->tmf_queue, struct vhost_scsi_tmf,
-			       queue_entry);
-	list_del_init(&tmf->queue_entry);
-	mutex_unlock(&tpg->tv_tpg_mutex);
 
-	tmf->tpg = tpg;
+	vhost_work_init(&tmf->vwork, vhost_scsi_tmf_resp_work);
 	tmf->vhost = vs;
 	tmf->svq = svq;
 	tmf->resp_iov = vq->iov[vc->out];
@@ -2035,19 +2021,11 @@ static int vhost_scsi_port_link(struct se_portal_group *se_tpg,
 {
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
-	struct vhost_scsi_tmf *tmf;
-
-	tmf = kzalloc(sizeof(*tmf), GFP_KERNEL);
-	if (!tmf)
-		return -ENOMEM;
-	INIT_LIST_HEAD(&tmf->queue_entry);
-	vhost_work_init(&tmf->vwork, vhost_scsi_tmf_resp_work);
 
 	mutex_lock(&vhost_scsi_mutex);
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count++;
-	list_add_tail(&tmf->queue_entry, &tpg->tmf_queue);
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
 	vhost_scsi_hotplug(tpg, lun);
@@ -2062,16 +2040,11 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 {
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
-	struct vhost_scsi_tmf *tmf;
 
 	mutex_lock(&vhost_scsi_mutex);
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count--;
-	tmf = list_first_entry(&tpg->tmf_queue, struct vhost_scsi_tmf,
-			       queue_entry);
-	list_del(&tmf->queue_entry);
-	kfree(tmf);
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
 	vhost_scsi_hotunplug(tpg, lun);
@@ -2332,7 +2305,6 @@ vhost_scsi_make_tpg(struct se_wwn *wwn, const char *name)
 	}
 	mutex_init(&tpg->tv_tpg_mutex);
 	INIT_LIST_HEAD(&tpg->tv_tpg_list);
-	INIT_LIST_HEAD(&tpg->tmf_queue);
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
-- 
2.25.1

