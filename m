From: James Smart <james.smart@emulex.com>
Subject: [PATCH 20/21] lpfc 8.3.33: Fixed incomplete list of SLI4 commands
 with extended timeout value
Date: Fri, 3 Aug 2012 12:37:08 -0400
Message-ID: <1344011828.6110.45.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:44858 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2HCQhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:37:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed incomplete list of SLI4 commands with extended second timeout value


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h   |    1 +
 lpfc_hw4.h  |    6 ++++++
 lpfc_mbox.c |   11 ++++++++++-
 lpfc_sli.c  |    1 +
 4 files changed, 18 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-07-22 14:30:08.557267563 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-07-22 14:35:29.464256416 -0400
@@ -886,13 +886,19 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_EQ_DESTROY			0x37
 #define LPFC_MBOX_OPCODE_QUERY_FW_CFG			0x3A
 #define LPFC_MBOX_OPCODE_FUNCTION_RESET			0x3D
+#define LPFC_MBOX_OPCODE_SET_PHYSICAL_LINK_CONFIG	0x3E
+#define LPFC_MBOX_OPCODE_SET_BOOT_CONFIG		0x43
 #define LPFC_MBOX_OPCODE_GET_PORT_NAME			0x4D
 #define LPFC_MBOX_OPCODE_MQ_CREATE_EXT			0x5A
+#define LPFC_MBOX_OPCODE_GET_VPD_DATA			0x5B
+#define LPFC_MBOX_OPCODE_SEND_ACTIVATION		0x73
+#define LPFC_MBOX_OPCODE_RESET_LICENSES			0x74
 #define LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO		0x9A
 #define LPFC_MBOX_OPCODE_GET_ALLOC_RSRC_EXTENT		0x9B
 #define LPFC_MBOX_OPCODE_ALLOC_RSRC_EXTENT		0x9C
 #define LPFC_MBOX_OPCODE_DEALLOC_RSRC_EXTENT		0x9D
 #define LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG		0xA0
+#define LPFC_MBOX_OPCODE_GET_PROFILE_CAPACITIES		0xA1
 #define LPFC_MBOX_OPCODE_GET_PROFILE_CONFIG		0xA4
 #define LPFC_MBOX_OPCODE_SET_PROFILE_CONFIG		0xA5
 #define LPFC_MBOX_OPCODE_GET_PROFILE_LIST		0xA6
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2012-07-22 14:29:51.079268170 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2012-07-22 14:35:29.470256416 -0400
@@ -1460,6 +1460,7 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_UNREG_FCFI	    0xA2
 #define MBX_INIT_VFI        0xA3
 #define MBX_INIT_VPI        0xA4
+#define MBX_ACCESS_VDATA    0xA5
 
 #define MBX_AUTH_PORT       0xF8
 #define MBX_SECURITY_MGMT   0xF9
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2012-07-22 14:29:50.958268174 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2012-07-22 14:35:29.471256416 -0400
@@ -1612,12 +1612,15 @@ lpfc_mbox_tmo_val(struct lpfc_hba *phba,
 
 	switch (mbox->mbxCommand) {
 	case MBX_WRITE_NV:	/* 0x03 */
+	case MBX_DUMP_MEMORY:	/* 0x17 */
 	case MBX_UPDATE_CFG:	/* 0x1B */
 	case MBX_DOWN_LOAD:	/* 0x1C */
 	case MBX_DEL_LD_ENTRY:	/* 0x1D */
+	case MBX_WRITE_VPARMS:	/* 0x32 */
 	case MBX_LOAD_AREA:	/* 0x81 */
 	case MBX_WRITE_WWN:     /* 0x98 */
 	case MBX_LOAD_EXP_ROM:	/* 0x9C */
+	case MBX_ACCESS_VDATA:	/* 0xA5 */
 		return LPFC_MBOX_TMO_FLASH_CMD;
 	case MBX_SLI4_CONFIG:	/* 0x9b */
 		subsys = lpfc_sli_config_mbox_subsys_get(phba, mboxq);
@@ -1628,11 +1631,17 @@ lpfc_mbox_tmo_val(struct lpfc_hba *phba,
 			case LPFC_MBOX_OPCODE_WRITE_OBJECT:
 			case LPFC_MBOX_OPCODE_READ_OBJECT_LIST:
 			case LPFC_MBOX_OPCODE_DELETE_OBJECT:
-			case LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG:
 			case LPFC_MBOX_OPCODE_GET_PROFILE_LIST:
 			case LPFC_MBOX_OPCODE_SET_ACT_PROFILE:
+			case LPFC_MBOX_OPCODE_GET_PROFILE_CONFIG:
 			case LPFC_MBOX_OPCODE_SET_PROFILE_CONFIG:
 			case LPFC_MBOX_OPCODE_GET_FACTORY_PROFILE_CONFIG:
+			case LPFC_MBOX_OPCODE_GET_PROFILE_CAPACITIES:
+			case LPFC_MBOX_OPCODE_SEND_ACTIVATION:
+			case LPFC_MBOX_OPCODE_RESET_LICENSES:
+			case LPFC_MBOX_OPCODE_SET_BOOT_CONFIG:
+			case LPFC_MBOX_OPCODE_GET_VPD_DATA:
+			case LPFC_MBOX_OPCODE_SET_PHYSICAL_LINK_CONFIG:
 				return LPFC_MBOX_SLI4_CONFIG_EXTENDED_TMO;
 			}
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 14:32:56.396261733 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 14:35:29.493256415 -0400
@@ -2087,6 +2087,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_READ_EVENT_LOG:
 	case MBX_SECURITY_MGMT:
 	case MBX_AUTH_PORT:
+	case MBX_ACCESS_VDATA:
 		ret = mbxCommand;
 		break;
 	default:



