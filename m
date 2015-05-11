From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 3/5] Replace MAX_COMMAND_SIZE with BLK_MAX_CDB
Date: Mon, 11 May 2015 09:55:07 +0200
Message-ID: <5550605B.904@sandisk.com>
References: <554C6E79.7020501@sandisk.com> <554C6EFF.5000400@sandisk.com>
 <20150511063250.GD30323@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0093.outbound.protection.outlook.com ([207.46.100.93]:50400
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752224AbbEKHzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 03:55:16 -0400
In-Reply-To: <20150511063250.GD30323@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@odin.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>

On 05/11/15 08:32, Christoph Hellwig wrote:
> I know I suggested this, but as I have some other work to actually kill
> BLK_MAX_CDB now we might want to go for the light-weight variant where
> we just #define MAX_COMMAND_SIZE to BLK_MAX_CDB for now.
> 
> Sorry for causing this additional work.

Actually this makes my job easier because it allows me to drop a whole
bunch of changes. Is the patch below what you had in mind ?

Thanks,

Bart.

From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v5] Make MAX_COMMAND_SIZE identical to BLK_MAX_CDB

Since the two constants MAX_COMMAND_SIZE and BLK_MAX_CDB have
the same meaning, define MAX_COMMAND_SIZE as BLK_MAX_CDB.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/usb/gadget/function/storage_common.h |  3 ---
 include/scsi/scsi_cmnd.h                     | 17 +++--------------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/function/storage_common.h b/drivers/usb/gadget/function/storage_common.h
index 70c8914..45d3b87 100644
--- a/drivers/usb/gadget/function/storage_common.h
+++ b/drivers/usb/gadget/function/storage_common.h
@@ -65,9 +65,6 @@ do {									\
 
 #endif /* DUMP_MSGS */
 
-/* Length of a SCSI Command Data Block */
-#define MAX_COMMAND_SIZE	16
-
 /* SCSI Sense Key/Additional Sense Code/ASC Qualifier values */
 #define SS_NO_SENSE				0
 #define SS_COMMUNICATION_FAILURE		0x040800
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9fc1aec..6379d07 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -15,21 +15,10 @@ struct scsi_driver;
 #include <scsi/scsi_device.h>
 
 /*
- * MAX_COMMAND_SIZE is:
- * The longest fixed-length SCSI CDB as per the SCSI standard.
- * fixed-length means: commands that their size can be determined
- * by their opcode and the CDB does not carry a length specifier, (unlike
- * the VARIABLE_LENGTH_CMD(0x7f) command). This is actually not exactly
- * true and the SCSI standard also defines extended commands and
- * vendor specific commands that can be bigger than 16 bytes. The kernel
- * will support these using the same infrastructure used for VARLEN CDB's.
- * So in effect MAX_COMMAND_SIZE means the maximum size command scsi-ml
- * supports without specifying a cmd_len by ULD's
+ * MAX_COMMAND_SIZE is the maximum length of a CDB that fits in struct request
+ * without allocating additional memory.
  */
-#define MAX_COMMAND_SIZE 16
-#if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
-# error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
-#endif
+#define MAX_COMMAND_SIZE BLK_MAX_CDB
 
 struct scsi_data_buffer {
 	struct sg_table table;
-- 
2.1.4



