From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] iscsi_tcp, ib_iser Enable module refcounting for iscsi host template
Date: Thu, 26 Jul 2007 12:46:46 -0500
Message-ID: <11854720113567-git-send-email-michaelc@cs.wisc.edu>
References: <11854720083011-git-send-email-michaelc@cs.wisc.edu>
 <1185472010604-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934791AbXGZRrV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:47:21 -0400
In-Reply-To: <1185472010604-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Olaf Kirch <olaf.kirch@oracle.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This prevents the iscsi modules from being unloaded while
there are active mounts from an iscsi target.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 drivers/scsi/iscsi_tcp.c                 |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5db3143..bad8dac 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -548,6 +548,7 @@ iscsi_iser_ep_disconnect(__u64 ep_handle)
 }
 
 static struct scsi_host_template iscsi_iser_sht = {
+	.module                 = THIS_MODULE,
 	.name                   = "iSCSI Initiator over iSER, v." DRV_VER,
 	.queuecommand           = iscsi_queuecommand,
 	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7829ab1..93034b4 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2221,6 +2221,7 @@ static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
 }
 
 static struct scsi_host_template iscsi_sht = {
+	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
-- 
1.5.1.2

