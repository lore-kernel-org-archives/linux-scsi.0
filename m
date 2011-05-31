From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] target: remove the unused SCF_CMD_PASSTHROUGH_NOALLOC flag
Date: Tue, 31 May 2011 17:06:44 -0400
Message-ID: <20110531210703.057209445@bombadil.infradead.org>
References: <20110531210641.032149131@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42336
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932529Ab1EaVHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 17:07:03 -0400
Content-Disposition: inline; filename=lio-kill-SCF_CMD_PASSTHROUGH_NOALLOC
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2011-06-01 05:19:59.147628735 +0900
+++ lio-core/drivers/target/target_core_transport.c	2011-06-01 05:29:19.758629178 +0900
@@ -3764,12 +3761,6 @@ static inline void transport_free_pages(
 		return;
 	}
 
-	/*
-	 * Caller will handle releasing of struct se_mem.
-	 */
-	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH_NOALLOC)
-		return;
-
 	list_for_each_entry_safe(se_mem, se_mem_tmp,
 			&cmd->t_mem_list, se_list) {
 		/*
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2011-06-01 05:19:59.151686671 +0900
+++ lio-core/include/target/target_core_base.h	2011-06-01 05:19:59.000000000 +0900
@@ -112,7 +112,6 @@ enum se_cmd_flags_table {
 	SCF_SCSI_NON_DATA_CDB		= 0x00000040,
 	SCF_SCSI_CDB_EXCEPTION		= 0x00000080,
 	SCF_SCSI_RESERVATION_CONFLICT	= 0x00000100,
-	SCF_CMD_PASSTHROUGH_NOALLOC	= 0x00000200,
 	SCF_SE_CMD_FAILED		= 0x00000400,
 	SCF_SE_LUN_CMD			= 0x00000800,
 	SCF_SE_ALLOW_EOO		= 0x00001000,

