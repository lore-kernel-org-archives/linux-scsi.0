Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F41FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 13:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbiFGNU1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 09:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244607AbiFGNUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 09:20:13 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A9B69290
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 06:20:12 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A7B264242A;
        Tue,  7 Jun 2022 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1654608004; x=
        1656422405; bh=O/NrX6VUDoXUzhetZuzlVYWyjXBNNCHj6oYEc5iUZKA=; b=M
        hW6FQuiTIsdb87H4NcceU6eTeuyElhhHBKdS3tWF2mtErL4rv8l94ZPVRcG9XZ5d
        2//Iij+KWY6pdRSbr+d5vtGqCerxcmD8iYZYIbZs4YZQf2709VJpcpg29zyHitNo
        zvcBPh8p1UQm8fErvTvRIN/K1JZLbrH8VKoNyZZV0M=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4pXbYKAkb5QZ; Tue,  7 Jun 2022 16:20:04 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 191CB41BB2;
        Tue,  7 Jun 2022 16:20:02 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 7 Jun 2022 16:20:02 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-09.corp.yadro.com (172.17.11.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Tue, 7 Jun 2022 16:20:01 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
CC:     <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Konstantin Shelekhin" <k.shelekhin@yadro.com>
Subject: [PATCH] scsi: iscsi: prefer xmit of DataOut before new cmd
Date:   Tue, 7 Jun 2022 16:19:53 +0300
Message-ID: <20220607131953.11584-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In function iscsi_data_xmit (TX worker) there is walking through the
queue of new SCSI commands that is replenished in parallell. And only
after that queue got emptied the function will start sending pending
DataOut PDUs. That lead to DataOut timer time out on target side and
to connection reinstatment.

This patch swaps walking through the new commands queue and the pending
DataOut queue. To make a preference to ongoing commands over new ones.

Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/libiscsi.c | 44 ++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 797abf4f5399..8d78559ae94a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1567,6 +1567,28 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 			goto done;
 	}
 
+check_requeue:
+	while (!list_empty(&conn->requeue)) {
+		/*
+		 * we always do fastlogout - conn stop code will clean up.
+		 */
+		if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
+			break;
+
+		task = list_entry(conn->requeue.next, struct iscsi_task,
+				  running);
+
+		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
+			break;
+
+		list_del_init(&task->running);
+		rc = iscsi_xmit_task(conn, task, true);
+		if (rc)
+			goto done;
+		if (!list_empty(&conn->mgmtqueue))
+			goto check_mgmt;
+	}
+
 	/* process pending command queue */
 	while (!list_empty(&conn->cmdqueue)) {
 		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
@@ -1594,28 +1616,10 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		 */
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
+		if (!list_empty(&conn->requeue))
+			goto check_requeue;
 	}
 
-	while (!list_empty(&conn->requeue)) {
-		/*
-		 * we always do fastlogout - conn stop code will clean up.
-		 */
-		if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
-			break;
-
-		task = list_entry(conn->requeue.next, struct iscsi_task,
-				  running);
-
-		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
-			break;
-
-		list_del_init(&task->running);
-		rc = iscsi_xmit_task(conn, task, true);
-		if (rc)
-			goto done;
-		if (!list_empty(&conn->mgmtqueue))
-			goto check_mgmt;
-	}
 	spin_unlock_bh(&conn->session->frwd_lock);
 	return -ENODATA;
 
-- 
2.25.1

