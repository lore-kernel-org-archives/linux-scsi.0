From: michaelc@cs.wisc.edu
Subject: [PATCH 13/17] be2iscsi: Return async handle of unknown opcode to free list.
Date: Tue, 20 Mar 2012 20:48:04 -0500
Message-ID: <1332294488-13684-14-git-send-email-michaelc@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030413Ab2CUBso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:44 -0400
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The async handle corresponding to unknown Opcode was not freed
 earlier. This code does the fix for that.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 97a08f3..a4ec458 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1659,8 +1659,7 @@ hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
 					    phdr, hdr_len, pfirst_buffer,
 					    offset);
 
-	if (status == 0)
-		hwi_free_async_msg(phba, cri);
+	hwi_free_async_msg(phba, cri);
 	return 0;
 }
 
-- 
1.7.7.6

