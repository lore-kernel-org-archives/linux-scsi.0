From: michaelc@cs.wisc.edu
Subject: [PATCH 6/7] Increase iscsi tcp max_sectors
Date: Wed, 28 Feb 2007 17:32:20 -0600
Message-ID: <11727055453295-git-send-email-michaelc@cs.wisc.edu>
References: <1172705541949-git-send-email-michaelc@cs.wisc.edu> <11727055423762-git-send-email-michaelc@cs.wisc.edu> <11727055433394-git-send-email-michaelc@cs.wisc.edu> <1172705543740-git-send-email-michaelc@cs.wisc.edu> <1172705544330-git-send-email-michaelc@cs.wisc.edu> <11727055441132-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbXB1Xck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 18:32:40 -0500
In-Reply-To: <11727055441132-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

For a while now, the block layer has seperated max sectors
and max hw sectors. Software iscsi has no limit so this patch
increases max hw sectors, so we can support large pass through
commands.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 6fd0845..861cb9b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2138,6 +2138,7 @@ static struct scsi_host_template iscsi_s
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,
 	.sg_tablesize		= ISCSI_SG_TABLESIZE,
+	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
-- 
1.4.1.1

