Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E605C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D81D22267
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050488;
	bh=VBzvYmETKXOwfA2KkRNYm/mmCR6EPH7oXjsYbI2Q7cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MUw+/AFnkF2M4olWA6eK7CDsDEGuF+j8XDpC/DyU10E3fksnmleX/VySh2rGT2diY
	 oIL5kxhYIJF7jn6GXZFoxKRuoKZR/pAlMXyh6DB8v3rL7jUdEOnVD2QhsXyKwYo38m
	 hKURgHjcphwWBm7NciMUfOe3On8C+uXduWFf0RyM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgJRTWF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbgJRTWC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A31222E7;
        Sun, 18 Oct 2020 19:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048921;
        bh=VBzvYmETKXOwfA2KkRNYm/mmCR6EPH7oXjsYbI2Q7cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fen9DLf0EIxZnGsaG3max296ovDUDtl5lJerXodUyuFRtvrVUA1Soofo63sPxh1fg
         z5h0AAhlnrpqN+kQ4SlSk+Di7635In6BAPM0A66WQXWomPgiua28VYCHQb4KiDhHaZ
         jaagLIQmSpabTSlFP6vEc3BjyQhmLwMIKPn+UnlM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 079/101] scsi: qedi: Mark all connections for recovery on link down event
Date:   Sun, 18 Oct 2020 15:20:04 -0400
Message-Id: <20201018192026.4053674-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 4118879be3755b38171063dfd4a57611d4b20a83 ]

For short time cable pulls, the in-flight I/O to the firmware is never
cleaned up, resulting in the behaviour of stale I/O completion causing
list_del corruption and soft lockup of the system.

On link down event, mark all the connections for recovery, causing cleanup
of all the in-flight I/O immediately.

Link: https://lore.kernel.org/r/20200908095657.26821-7-mrangankar@marvell.com
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 81a307695cc91..569fa4b28e4e2 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1127,6 +1127,15 @@ static void qedi_schedule_recovery_handler(void *dev)
 	schedule_delayed_work(&qedi->recovery_work, 0);
 }
 
+static void qedi_set_conn_recovery(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct iscsi_conn *conn = session->leadconn;
+	struct qedi_conn *qedi_conn = conn->dd_data;
+
+	qedi_start_conn_recovery(qedi_conn->qedi, qedi_conn);
+}
+
 static void qedi_link_update(void *dev, struct qed_link_output *link)
 {
 	struct qedi_ctx *qedi = (struct qedi_ctx *)dev;
@@ -1138,6 +1147,7 @@ static void qedi_link_update(void *dev, struct qed_link_output *link)
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 			  "Link Down event.\n");
 		atomic_set(&qedi->link_state, QEDI_LINK_DOWN);
+		iscsi_host_for_each_session(qedi->shost, qedi_set_conn_recovery);
 	}
 }
 
-- 
2.25.1

