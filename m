From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 18/21] target: Print subpage too for unhandled MODE SENSE pages
Date: Wed, 17 Aug 2011 23:17:22 +0000
Message-ID: <1313623045-15916-19-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58351 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1HQXmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:46 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

Make a log message more useful by printing both the page and subpage
that an initiator is requesting.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 40ad142..89ae923 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -920,8 +920,8 @@ target_emulate_modesense(struct se_cmd *cmd, int ten)
 		length += target_modesense_control(dev, &buf[offset+length]);
 		break;
 	default:
-		pr_err("Got Unknown Mode Page: 0x%02x\n",
-				cdb[2] & 0x3f);
+		pr_err("MODE SENSE: unimplemented page/subpage: 0x%02x/0x%02x\n",
+		       cdb[2] & 0x3f, cdb[3]);
 		return PYX_TRANSPORT_UNKNOWN_MODE_PAGE;
 	}
 	offset += length;
-- 
1.7.6

