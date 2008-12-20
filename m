From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/8] [LIO-Target]: Add transport_free_session() in
	iscsi_target_login_thread() exception path
Date: Sat, 20 Dec 2008 15:02:13 -0800
Message-ID: <1229814133.4560.202.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:45676 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754089AbYLTXCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2008 18:02:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 5717324513c2db0000d15af92083614aa28cee8b Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 02:55:22 -0800
Subject: [PATCH 5/8] [LIO-Target]: Add transport_free_session() in iscsi_target_login_thread() exception path

This patch adds transport_free_session() usage to iscsi_target_login_thread():new_sess_out
label to properly release the iscsi_session_t->se_sess allocated in iscsi_login_zero_tsih_s1()
with transport_init_session().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_login.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_login.c b/drivers/lio-core/iscsi_target_login.c
index 40d9b65..53c4ae5 100644
--- a/drivers/lio-core/iscsi_target_login.c
+++ b/drivers/lio-core/iscsi_target_login.c
@@ -1240,7 +1240,8 @@ new_sess_out:
 
 	if (!zero_tsih || !SESS(conn))
 		goto old_sess_out;
-
+	if (SESS(conn)->se_sess)
+		transport_free_session(SESS(conn)->se_sess);
 	if (SESS(conn)->sess_ops)
 		kfree(SESS(conn)->sess_ops);
 	if (SESS(conn))
-- 
1.5.4.1



