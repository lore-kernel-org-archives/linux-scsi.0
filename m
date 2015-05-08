From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 4/5] target: Correct a comment
Date: Fri, 8 May 2015 10:08:55 +0200
Message-ID: <554C6F17.30501@sandisk.com>
References: <554C6E79.7020501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:52683
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751493AbbEHIJC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2015 04:09:02 -0400
In-Reply-To: <554C6E79.7020501@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Correct the comment above the definition of TCM_MAX_COMMAND_SIZE.
A quote from Christoph:

    There aren't any legacy issues, we just decided to handle >
    16 byte CDBs in the slow path.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 include/target/target_core_base.h | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 480e9f8..0203774 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -17,16 +17,8 @@
 /* Don't raise above 511 or REPORT_LUNS needs to handle >1 page */
 #define TRANSPORT_MAX_LUNS_PER_TPG		256
 /*
- * By default we use 32-byte CDBs in TCM Core and subsystem plugin code.
- *
- * Note that both include/scsi/scsi_cmnd.h:MAX_COMMAND_SIZE and
- * include/linux/blkdev.h:BLOCK_MAX_CDB as of v2.6.36-rc4 still use
- * 16-byte CDBs by default and require an extra allocation for
- * 32-byte CDBs to because of legacy issues.
- *
- * Within TCM Core there are no such legacy limitiations, so we go ahead
- * use 32-byte CDBs by default and use include/scsi/scsi.h:scsi_command_size()
- * within all TCM Core and subsystem plugin code.
+ * Maximum size of a CDB that can be stored in se_cmd without allocating
+ * memory dynamically for the CDB.
  */
 #define TCM_MAX_COMMAND_SIZE			32
 /*
-- 
2.1.4

