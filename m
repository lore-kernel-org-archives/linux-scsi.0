From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 7/9] target: Enable EXTENDED_COPY setup in spc_parse_cdb
Date: Fri, 23 Aug 2013 02:26:59 +0000
Message-ID: <1377224821-23422-8-git-send-email-nab@daterainc.com>
References: <1377224821-23422-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:49799 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3HWCnZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2013 22:43:25 -0400
Received: by mail-oa0-f49.google.com with SMTP id n10so150157oag.36
        for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2013 19:43:24 -0700 (PDT)
In-Reply-To: <1377224821-23422-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>

From: Nicholas Bellinger <nab@daterainc.com>

Setup up the se_cmd->execute_cmd() pointers for EXTENDED_COPY and
RECEIVE_COPY_RESULTS handling within spc_parse_cdb()

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Zach Brown <zab@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_spc.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index bd16a93..894e83b 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -35,7 +35,7 @@
 #include "target_core_alua.h"
 #include "target_core_pr.h"
 #include "target_core_ua.h"
-
+#include "target_core_xcopy.h"
 
 static void spc_fill_alua_data(struct se_port *port, unsigned char *buf)
 {
@@ -1252,8 +1252,14 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		*size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
 		break;
 	case EXTENDED_COPY:
-	case READ_ATTRIBUTE:
+		*size = get_unaligned_be32(&cdb[10]);
+		cmd->execute_cmd = target_do_xcopy;
+		break;
 	case RECEIVE_COPY_RESULTS:
+		*size = get_unaligned_be32(&cdb[10]);
+		cmd->execute_cmd = target_do_receive_copy_results;
+		break;
+	case READ_ATTRIBUTE:
 	case WRITE_ATTRIBUTE:
 		*size = (cdb[10] << 24) | (cdb[11] << 16) |
 		       (cdb[12] << 8) | cdb[13];
-- 
1.7.2.5

