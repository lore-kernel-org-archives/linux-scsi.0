Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CA6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 20:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJCU1z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJCU1v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 16:27:51 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB993E771;
        Mon,  3 Oct 2022 13:27:49 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A6673411F8;
        Mon,  3 Oct 2022 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1664828867; x=1666643268; bh=BlqpQ5lIMULqb1JjlXGVS3eHU
        p/CLKPTsZvHH0M03Rs=; b=E4+r8JK/MwOfEy35B0/d+CHgbeiT6Ik2A7cnOTdTw
        SBu6RTr/reOsQ0EMqooqNb7oq3SHShp4XjIKinc5AV7cHt9KX1iXGJ9VQveY2nd9
        sVpyZNzb+IPynN0Bcf4KwYjAj3p6S2wqofKozJykUwZAWyEmvgjkUp22qf9TiU55
        rI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jEze6DcVS8Mg; Mon,  3 Oct 2022 23:27:47 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 743E34120E;
        Mon,  3 Oct 2022 23:27:43 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 3 Oct 2022 23:27:36 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 3 Oct 2022 23:27:36 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 3/3] target: iscsi: close session without connections
Date:   Mon, 3 Oct 2022 23:27:23 +0300
Message-ID: <20221003202723.22714-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003202723.22714-1-d.bogdanov@yadro.com>
References: <20221003202723.22714-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During Time2Retain timer there are no connections in the session.
A session stop due to ACL/TPG removal is done by stopping its
connections. For session in recovery it stops Time2Retain timer and
that's it. The session hanges forever.

Call directly a session closure when no connections in the session.
Do it in other context to make it possible to wait for session usage
counter, that is decreased always after invocation of session stop.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 3e91523e540b..967c969cfc10 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4738,6 +4738,12 @@ void iscsit_stop_session(
 	struct iscsit_conn *conn, *conn_tmp = NULL;
 	int is_last;
 
+	if (!conn_count) {
+		/* during Time2Retain timer there is no connections */
+		schedule_work(&sess->session_close_worker);
+		return;
+	}
+
 	spin_lock_bh(&sess->conn_lock);
 
 	if (connection_sleep) {
-- 
2.25.1

