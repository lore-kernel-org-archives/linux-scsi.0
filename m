From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 3rd_time] scsi: fix operator precedence warning
Date: Thu, 22 Apr 2010 11:02:14 -0700
Message-ID: <20100422110214.e7c62688.randy.dunlap@oracle.com>
References: <1271945825.2889.138.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1271945825.2889.138.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Ravi Anand <ravi.anand@qlogic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, David C Somayajulu <david.somayajulu@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix operator precedence warning (from sparse), which results in the
data value always being 0:

drivers/scsi/qla4xxx/ql4_mbx.c:470:66: warning: right shift by bigger than source value

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Ravi Anand <ravi.anand@qlogic.com>
Cc: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: Karen Higgins <karen.higgins@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---

 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.34-rc3-git5.orig/drivers/scsi/qla4xxx/ql4_mbx.c
+++ linux-2.6.34-rc3-git5/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -467,7 +467,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 	if (conn_err_detail)
 		*conn_err_detail = mbox_sts[5];
 	if (tcp_source_port_num)
-		*tcp_source_port_num = (uint16_t) mbox_sts[6] >> 16;
+		*tcp_source_port_num = (uint16_t) (mbox_sts[6] >> 16);
 	if (connection_id)
 		*connection_id = (uint16_t) mbox_sts[6] & 0x00FF;
 	status = QLA_SUCCESS;
