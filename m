From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] iscsit: use GFP_ATOMIC under spin lock
Date: Fri, 23 Nov 2012 12:07:39 +0800
Message-ID: <CAPgLHd9ZPyLugr5mS0NHpm8kiv6a6e9maTY4cuVbO=+CtCf1NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55828 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958Ab2KWEHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Nov 2012 23:07:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The function iscsit_build_conn_drop_async_message() is called
from iscsit_close_connection() with spin lock 'sess->conn_lock'
held, so we should use GFP_ATOMIC instead of GFP_KERNEL.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 035c2c7..3983ad3 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2360,7 +2360,7 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 	if (!conn_p)
 		return;
 
-	cmd = iscsit_allocate_cmd(conn_p, GFP_KERNEL);
+	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
 	if (!cmd) {
 		iscsit_dec_conn_usage_count(conn_p);
 		return;


