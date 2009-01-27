From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] [Target_Core_Mod]: Convert TYPE_ROM support to use
	include/linux/cdrom.h GPCMD_* defines
Date: Tue, 27 Jan 2009 14:08:47 -0800
Message-ID: <1233094127.6442.107.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:23019 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751857AbZA0WJ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 17:09:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

>From a4bcd2cf3833c64d9f37b29b91bc08496b26a48c Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 27 Jan 2009 13:57:20 -0800
Subject: [PATCH 4/4] [Target_Core_Mod]: Convert TYPE_ROM support to use include/linux/cdrom.h GPCMD_* defines

This patch updates transport_generic_cmd_sequencer() to use GPCMD_* MMC opcode defines
from include/linux/cdrom.h, instead of our locally defined ones w/o the GPCMD_* prefix
in drivers/lio-core/target_core_base.h.  This patch removes all those locally defined
opcodes in target_core_base.h (some which date back to usage on v2.2), and adds
GPCMD_MECHANISM_STATUS and GPCMD_READ_FORMAT_CAPACITIES CDB support in the generic
cdb sequencer.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |   59 ------------------------------
 drivers/lio-core/target_core_transport.c |   29 ++++++++-------
 2 files changed, 16 insertions(+), 72 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index c5b6f3e..3523023 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -61,65 +61,6 @@
 #define INQUIRY_EVPD_SERIAL_LEN			254
 #define INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN	254
 
-/* used by PSCSI and iBlock Transport drivers */
-#ifndef GET_CONFIGURATION
-#define		GET_CONFIGURATION		0x46
-#endif
-#ifndef LOAD_UNLOAD_MEDIUM
-#define		LOAD_UNLOAD_MEDIUM		0xa6
-#endif
-#ifndef REPORT_LUNS
-#define         REPORT_LUNS     		0xa0
-#endif
-#ifndef READ_16
-#define         READ_16         		0x88
-#endif
-#ifndef WRITE_16
-#define         WRITE_16        		0x8a
-#endif
-#ifndef READ_CD
-#define		READ_CD				0xbe
-#endif
-#ifndef READ_DISK_INFORMATION
-#define		READ_DISK_INFORMATION		0x51
-#endif
-#ifndef READ_DVD_STRUCTURE
-#define		READ_DVD_STRUCTURE		0xad
-#endif
-#ifndef REPORT_KEY
-#define		REPORT_KEY			0xa4
-#endif
-#ifndef SEND_KEY
-#define		SEND_KEY			0xa3
-#endif
-#ifndef READ_TRACK_RZONE_INFO
-#define		READ_TRACK_RZONE_INFO		0x52
-#endif
-#ifndef SET_SPEED
-#define		SET_SPEED			0xbb
-#endif
-#ifndef CLOSE_TRACK
-#define		CLOSE_TRACK			0x5b
-#endif
-#ifndef READ_BUFFER_CAPACITY
-#define		READ_BUFFER_CAPACITY		0x5c
-#endif
-#ifndef SEND_OPC_INFORMATION
-#define		SEND_OPC_INFORMATION		0x54
-#endif
-#ifndef SERVICE_ACTION_IN
-#define		SERVICE_ACTION_IN		0x9e
-#endif
-#ifndef SAI_READ_CAPACITY_16
-#define		SAI_READ_CAPACITY_16		0x10
-#endif
-#ifndef INITIALIZE_ELEMENT_STATUS
-#define		INITIALIZE_ELEMENT_STATUS	0x07
-#endif
-#ifndef VERIFY_16
-#define		VERIFY_16			0x8f
-#endif
-
 /* se_cmd_t->data_direction */
 #define SE_DIRECTION_NONE			0
 #define SE_DIRECTION_READ			1
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index a0a7710..22325ec 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -39,6 +39,7 @@
 #include <linux/spinlock.h>
 #include <linux/smp_lock.h>
 #include <linux/in.h>
+#include <linux/cdrom.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 //#include <asm/div64.h>
@@ -4476,7 +4477,7 @@ static int transport_generic_cmd_sequencer (
 			// MAINTENANCE_IN from SCC-2
 			size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
 		} else {
-			// SEND_KEY from multi media commands
+			// GPCMD_SEND_KEY from multi media commands
 			size = (cdb[8] << 8) + cdb[9];
 		}
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
@@ -4505,8 +4506,8 @@ static int transport_generic_cmd_sequencer (
 		ret = 2;
 		break;
 	case MODE_SENSE_10:
-	case READ_BUFFER_CAPACITY:
-	case SEND_OPC_INFORMATION:
+	case GPCMD_READ_BUFFER_CAPACITY:
+	case GPCMD_SEND_OPC:
 	case LOG_SELECT:
 	case LOG_SENSE:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
@@ -4522,9 +4523,10 @@ static int transport_generic_cmd_sequencer (
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
-	case GET_CONFIGURATION:
-	case READ_DISK_INFORMATION:
-	case READ_TRACK_RZONE_INFO:
+	case GPCMD_GET_CONFIGURATION:
+	case GPCMD_READ_FORMAT_CAPACITIES:
+	case GPCMD_READ_DISC_INFO:
+	case GPCMD_READ_TRACK_RZONE_INFO:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[7] << 8) + cdb[8];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
@@ -4542,7 +4544,8 @@ static int transport_generic_cmd_sequencer (
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
-	case READ_DVD_STRUCTURE:
+	case GPCMD_MECHANISM_STATUS:
+	case GPCMD_READ_DVD_STRUCTURE:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[8] << 8) + cdb[9];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
@@ -4562,7 +4565,7 @@ static int transport_generic_cmd_sequencer (
 			// MAINTENANCE_OUT from SCC-2
 			size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
 		} else  {
-			// REPORT_KEY from multi media commands
+			// GPCMD_REPORT_KEY from multi media commands
 			size = (cdb[8] << 8) + cdb[9];
 		}
 		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
@@ -4627,9 +4630,9 @@ static int transport_generic_cmd_sequencer (
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
-//#warning FIXME: Figure out correct READ_CD blocksize.
+//#warning FIXME: Figure out correct GPCMD_READ_CD blocksize.
 #if 0
-	case READ_CD:
+	case GPCMD_READ_CD:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
 		size = (2336 * sectors);
@@ -4708,13 +4711,13 @@ static int transport_generic_cmd_sequencer (
 		ret = 3;
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
-	case CLOSE_TRACK:
+	case GPCMD_CLOSE_TRACK:
 	case ERASE:
 	case INITIALIZE_ELEMENT_STATUS:
-	case LOAD_UNLOAD_MEDIUM:
+	case GPCMD_LOAD_UNLOAD:
 	case REZERO_UNIT:
 	case SEEK_10:
-	case SET_SPEED:
+	case GPCMD_SET_SPEED:
 	case SPACE:
 	case START_STOP:
 	case SYNCHRONIZE_CACHE:
-- 
1.5.4.1



