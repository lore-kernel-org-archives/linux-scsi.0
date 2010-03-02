From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] qla4x: fix ql4_mbx tcp_source_port_num
Date: Tue, 2 Mar 2010 14:41:13 -0800
Message-ID: <20100302144113.28c15ee5.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:38487 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0CBWm6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 17:42:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, james.bottomley@suse.de
Cc: David C Somayajulu <david.somayajulu@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning, which indicates a precedence problem and the
data value always being 0:

drivers/scsi/qla4xxx/ql4_mbx.c:470:66: warning: right shift by bigger than source value

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: Karen Higgins <karen.higgins@qlogic.com>
Cc: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---

Sorry if you already received this patch; I thought that I had
already sent it, but I can't find it anywhere.

And how about a MAINTAINERS entry for qla4xxx, please?

 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.33-git7.orig/drivers/scsi/qla4xxx/ql4_mbx.c
+++ linux-2.6.33-git7/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -467,7 +467,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 	if (conn_err_detail)
 		*conn_err_detail = mbox_sts[5];
 	if (tcp_source_port_num)
-		*tcp_source_port_num = (uint16_t) mbox_sts[6] >> 16;
+		*tcp_source_port_num = (uint16_t) (mbox_sts[6] >> 16);
 	if (connection_id)
 		*connection_id = (uint16_t) mbox_sts[6] & 0x00FF;
 	status = QLA_SUCCESS;
