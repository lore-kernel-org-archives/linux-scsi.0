From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 070/103] target: remove the unused SCF_EMULATE_SYNC_UNMAP flag
Date: Thu, 21 Jul 2011 00:11:53 -0700
Message-ID: <1311232346-6674-71-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm20.bullet.mail.bf1.yahoo.com ([98.139.212.179]:42824 "HELO
	nm20.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752284Ab1GUHHP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:15 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Christoph Hellwig <hch@infradead.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   12 ------------
 include/target/target_core_base.h      |    1 -
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6ca367d..43fd277 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3396,18 +3396,6 @@ static int transport_generic_cmd_sequencer(
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
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 820ff2e..72ef4b8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -126,7 +126,6 @@ enum se_cmd_flags_table {
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00400000,
 	SCF_EMULATE_SYNC_CACHE		= 0x00800000,
 	SCF_EMULATE_CDB_ASYNC		= 0x01000000,
-	SCF_EMULATE_SYNC_UNMAP		= 0x02000000
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
-- 
1.7.6

