From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] qla4: fix shift precedence (sparse warning)
Date: Wed, 24 Feb 2010 14:26:38 -0800
Message-ID: <20100224142638.b88d5307.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:53685 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab0BXW1a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2010 17:27:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: james.bottomley@suse.de, Karen Higgins <karen.higgins@qlogic.com>, David C Somayajulu <david.somayajulu@qlogic.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix qla4xxx sparse warning:

drivers/scsi/qla4xxx/ql4_mbx.c:470:66: warning: right shift by bigger than source value

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Karen Higgins <karen.higgins@qlogic.com>
Cc: David C Somayajulu <david.somayajulu@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.33-rc8.orig/drivers/scsi/qla4xxx/ql4_mbx.c
+++ linux-2.6.33-rc8/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -467,7 +467,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 	if (conn_err_detail)
 		*conn_err_detail = mbox_sts[5];
 	if (tcp_source_port_num)
-		*tcp_source_port_num = (uint16_t) mbox_sts[6] >> 16;
+		*tcp_source_port_num = (uint16_t) (mbox_sts[6] >> 16);
 	if (connection_id)
 		*connection_id = (uint16_t) mbox_sts[6] & 0x00FF;
 	status = QLA_SUCCESS;
