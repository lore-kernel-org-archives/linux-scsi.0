From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/5] target: remove the unused SCF_EMULATE_SYNC_UNMAP flag
Date: Tue, 31 May 2011 17:06:45 -0400
Message-ID: <20110531210703.233666525@bombadil.infradead.org>
References: <20110531210641.032149131@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42337
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932530Ab1EaVHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 17:07:04 -0400
Content-Disposition: inline; filename=lio-kill-SCF_EMULATE_SYNC_UNMAP
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2011-06-01 05:58:26.855628963 +0900
+++ lio-core/drivers/target/target_core_transport.c	2011-06-01 05:58:48.982131649 +0900
@@ -3402,18 +3402,6 @@ static int transport_generic_cmd_sequenc
 		break;
 	case UNMAP:
 		size = get_unaligned_be16(&cdb[7]);
-		passthrough = (dev->transport->transport_type ==
-				TRANSPORT_PLUGIN_PHBA_PDEV);
-		/*
-		 * Determine if the received UNMAP used to for direct passthrough
-		 * into Linux/SCSI with struct request via TCM/pSCSI or we are
-		 * signaling the use of internal transport_generic_unmap() emulation
-		 * for UNMAP -> Linux/BLOCK disbard with TCM/IBLOCK and TCM/FILEIO
-		 * subsystem plugin backstores.
-		 */
-		if (!(passthrough))
-			cmd->se_cmd_flags |= SCF_EMULATE_SYNC_UNMAP;
-
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
 	case WRITE_SAME_16:
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2011-06-01 05:58:52.623629088 +0900
+++ lio-core/include/target/target_core_base.h	2011-06-01 05:58:57.426628785 +0900
@@ -126,7 +126,6 @@ enum se_cmd_flags_table {
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00400000,
 	SCF_EMULATE_SYNC_CACHE		= 0x00800000,
 	SCF_EMULATE_CDB_ASYNC		= 0x01000000,
-	SCF_EMULATE_SYNC_UNMAP		= 0x02000000
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */

