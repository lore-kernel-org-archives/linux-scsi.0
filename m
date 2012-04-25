From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 1/2] BNX2I: Added the setting of target can_queue via
 target_alloc
Date: Wed, 25 Apr 2012 15:03:45 -0700
Message-ID: <1335391425-30410-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1288 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab2DYWCo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 18:02:44 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

This will set the target can_queue limit to the number of preallocated
session tasks set during creation.

"Could not send nopout" messages were observed without this when the
iSCSI connection experiences dropped frames under heavy I/O stress.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1a44b45..e4029327 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2244,6 +2244,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.change_queue_depth	= iscsi_change_queue_depth,
+	.target_alloc		= iscsi_target_alloc,
 	.can_queue		= 2048,
 	.max_sectors		= 127,
 	.cmd_per_lun		= 128,
-- 
1.7.7.4


