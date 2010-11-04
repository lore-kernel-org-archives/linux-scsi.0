From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: fix mailbox register definition and add a delay
 before reading
Date: Thu, 04 Nov 2010 09:36:16 -0700
Message-ID: <4CD2E100.1060406@linux.vnet.ibm.com>
References: <20101104162643.264567565@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:40960 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0KDQgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2010 12:36:20 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id oA4GNJm9027927
	for <linux-scsi@vger.kernel.org>; Thu, 4 Nov 2010 10:23:19 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oA4GaHka015678
	for <linux-scsi@vger.kernel.org>; Thu, 4 Nov 2010 10:36:18 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oA4GeGis021406
	for <linux-scsi@vger.kernel.org>; Thu, 4 Nov 2010 10:40:17 -0600
In-Reply-To: <20101104162643.264567565@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

The definition for the mailbox register for new adapters was incorrect.  The
value has been updated to the correct offset.

After an adapter reset, the mailbox register on the new adapters takes a
number of seconds to stabilize.  A delay has been added before reading the
register.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ipr.h |    2 ++
 2 files changed, 43 insertions(+), 6 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-11-04 09:16:05.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-11-04 09:16:48.000000000 -0700
@@ -146,7 +146,7 @@ static const struct ipr_chip_cfg_t ipr_c
 		}
 	},
 	{ /* CRoC */
-		.mailbox = 0x00040,
+		.mailbox = 0x00044,
 		.cache_line_size = 0x20,
 		{
 			.set_interrupt_mask_reg = 0x00010,
@@ -2900,6 +2900,12 @@ static void ipr_get_ioa_dump(struct ipr_
 		return;
 	}

+	if (ioa_cfg->sis64) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		ssleep(IPR_DUMP_DELAY_SECONDS);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	}
+
 	start_addr = readl(ioa_cfg->ioa_mailbox);

 	if (!ioa_cfg->sis64 && !ipr_sdt_is_fmt2(start_addr)) {
@@ -7470,6 +7476,29 @@ static void ipr_get_unit_check_buffer(st
 }

 /**
+ * ipr_reset_get_unit_check_job - Call to get the unit check buffer.
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: This function will call to get the unit check buffer.
+ *
+ * Return value:
+ *	IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_get_unit_check_job(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
+	ENTER;
+	ioa_cfg->ioa_unit_checked = 0;
+	ipr_get_unit_check_buffer(ioa_cfg);
+	ipr_cmd->job_step = ipr_reset_alert;
+	ipr_reset_start_timer(ipr_cmd, 0);
+
+	LEAVE;
+	return IPR_RC_JOB_RETURN;
+}
+
+/**
  * ipr_reset_restore_cfg_space - Restore PCI config space.
  * @ipr_cmd:	ipr command struct
  *
@@ -7509,11 +7538,17 @@ static int ipr_reset_restore_cfg_space(s
 	}

 	if (ioa_cfg->ioa_unit_checked) {
-		ioa_cfg->ioa_unit_checked = 0;
-		ipr_get_unit_check_buffer(ioa_cfg);
-		ipr_cmd->job_step = ipr_reset_alert;
-		ipr_reset_start_timer(ipr_cmd, 0);
-		return IPR_RC_JOB_RETURN;
+		if (ioa_cfg->sis64) {
+			ipr_cmd->job_step = ipr_reset_get_unit_check_job;
+			ipr_reset_start_timer(ipr_cmd, IPR_DUMP_DELAY_TIMEOUT);
+			return IPR_RC_JOB_RETURN;
+		} else {
+			ioa_cfg->ioa_unit_checked = 0;
+			ipr_get_unit_check_buffer(ioa_cfg);
+			ipr_cmd->job_step = ipr_reset_alert;
+			ipr_reset_start_timer(ipr_cmd, 0);
+			return IPR_RC_JOB_RETURN;
+		}
 	}

 	if (ioa_cfg->in_ioa_bringdown) {
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-11-04 09:16:05.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-11-04 09:16:48.000000000 -0700
@@ -218,6 +218,8 @@
 #define IPR_WAIT_FOR_BIST_TIMEOUT		(2 * HZ)
 #define IPR_PCI_RESET_TIMEOUT			(HZ / 2)
 #define IPR_DUMP_TIMEOUT			(15 * HZ)
+#define IPR_DUMP_DELAY_SECONDS			4
+#define IPR_DUMP_DELAY_TIMEOUT			(IPR_DUMP_DELAY_SECONDS * HZ)

 /*
  * SCSI Literals

