Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84ACC3A5A4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99BDC20673
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="sLQA399F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389899AbfHWJxW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389897AbfHWJxV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nhVw002712
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=sUUEcezI0ULhD6WLKWDyRBqYQrXA+XPVuQ82qsnuU4U=;
 b=sLQA399FdpdZ1rGFuj/XY6bMZ+ilM5AickRLLs7X6tESAbRBKtmplHhCkOJVUioCJBDn
 1Pp0dtut6P7qFoRxpPBWugny9FIBf+LhoQcmkJTiv8IQVsDCl5shVJMxLcEfNDCg8fhn
 MYMmJ9Nq5U3nCWOFIv84Cxh9yMpi+aXbBYyPzMsZ+/yCJ7dXE2UggZxW25aKtFn1Lji0
 zG+DLEqeaYOfkYFQvjBCDR9XkCguE5g83iUsnXkWP3ur2e+mI8F6VS7+XjSqk16E1Jcv
 Ez48or5uN5OHkyPFS70CdzmbV9sGOqEDA12d32ggP7SCJqRX3itMF0aQ4t/B3SHx81P5 Yg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad4075c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:20 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:53:19 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:53:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BCE2E3F703F;
        Fri, 23 Aug 2019 02:53:19 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9rJPZ007921;
        Fri, 23 Aug 2019 02:53:19 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9rJSe007920;
        Fri, 23 Aug 2019 02:53:19 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 12/14] qedf: Use discovery list to traverse rports
Date:   Fri, 23 Aug 2019 02:52:42 -0700
Message-ID: <20190823095244.7830-13-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

The list of rports might become stale, so we should rather traverse
the discovery list when trying relogin.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 39 +++++++--------------------------------
 1 file changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 8845873..0856d13 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -343,11 +343,6 @@ int qedf_send_flogi(struct qedf_ctx *qedf)
 	return 0;
 }
 
-struct qedf_tmp_rdata_item {
-	struct fc_rport_priv *rdata;
-	struct list_head list;
-};
-
 /*
  * This function is called if link_down_tmo is in use.  If we get a link up and
  * link_down_tmo has not expired then use just FLOGI/ADISC to recover our
@@ -357,9 +352,8 @@ static void qedf_link_recovery(struct work_struct *work)
 {
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, link_recovery.work);
-	struct qedf_rport *fcport;
+	struct fc_lport *lport = qedf->lport;
 	struct fc_rport_priv *rdata;
-	struct qedf_tmp_rdata_item *rdata_item, *tmp_rdata_item;
 	bool rc;
 	int retries = 30;
 	int rval, i;
@@ -426,33 +420,14 @@ static void qedf_link_recovery(struct work_struct *work)
 	 * Call lport->tt.rport_login which will cause libfc to send an
 	 * ADISC since the rport is in state ready.
 	 */
-	rcu_read_lock();
-	list_for_each_entry_rcu(fcport, &qedf->fcports, peers) {
-		rdata = fcport->rdata;
-		if (rdata == NULL)
-			continue;
-		rdata_item = kzalloc(sizeof(struct qedf_tmp_rdata_item),
-		    GFP_ATOMIC);
-		if (!rdata_item)
-			continue;
+	mutex_lock(&lport->disc.disc_mutex);
+	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
 		if (kref_get_unless_zero(&rdata->kref)) {
-			rdata_item->rdata = rdata;
-			list_add(&rdata_item->list, &rdata_login_list);
-		} else
-			kfree(rdata_item);
-	}
-	rcu_read_unlock();
-	/*
-	 * Do the fc_rport_login outside of the rcu lock so we don't take a
-	 * mutex in an atomic context.
-	 */
-	list_for_each_entry_safe(rdata_item, tmp_rdata_item, &rdata_login_list,
-	    list) {
-		list_del(&rdata_item->list);
-		fc_rport_login(rdata_item->rdata);
-		kref_put(&rdata_item->rdata->kref, fc_rport_destroy);
-		kfree(rdata_item);
+			fc_rport_login(rdata);
+			kref_put(&rdata->kref, fc_rport_destroy);
+		}
 	}
+	mutex_unlock(&lport->disc.disc_mutex);
 }
 
 static void qedf_update_link_speed(struct qedf_ctx *qedf,
-- 
1.8.3.1

