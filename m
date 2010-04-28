From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/11] qla4xxx: fix ql4_mbx tcp_source_port_num
Date: Wed, 28 Apr 2010 11:43:15 +0530
Message-ID: <20100428061315.GA11185@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:16768
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750918Ab0D1GRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:17:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Randy Dunlap <randy.dunlap@oracle.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning, which indicates a precedence problem and the
data value always being 0:

drivers/scsi/qla4xxx/ql4_mbx.c:470:66: warning: right shift by bigger than source value

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index e1315cd..75496fb 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -565,7 +565,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 	if (conn_err_detail)
 		*conn_err_detail = mbox_sts[5];
 	if (tcp_source_port_num)
-		*tcp_source_port_num = (uint16_t) mbox_sts[6] >> 16;
+		*tcp_source_port_num = (uint16_t) (mbox_sts[6] >> 16);
 	if (connection_id)
 		*connection_id = (uint16_t) mbox_sts[6] & 0x00FF;
 	status = QLA_SUCCESS;
-- 
1.7.0.5

