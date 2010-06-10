From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: move setting of the allow_restart flag for vsets
 and disks
Date: Thu, 10 Jun 2010 14:46:34 -0700
Message-ID: <4C115D3A.1020604@linux.vnet.ibm.com>
References: <20100610214133.343780338@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:51046 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab0FJVqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2010 17:46:49 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5ALe9SR030530
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2010 15:40:09 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5ALkdS3082308
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2010 15:46:39 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5ALkcXl023892
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2010 15:46:38 -0600
In-Reply-To: <20100610214133.343780338@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

A problem was found where the call to scsi_add_device() fails intermittently
for an adapter.  This is caused when __scsi_add_device() returns -ENODEV as
a result of not calling scsi_probe_and_add_lun() since the call to
scsi_host_scan_allowed() fails.  scsi_host_scan_allowed() fails because the
adapter state is set to SHOST_RECOVERY instead of SHOST_RUNNING. The state of
the adapter is being set to SHOST_RECOVERY by scsi_eh_scmd_add() during
error handling.

This problem is avoided by moving the setting of the allow_restart flag to
later in the device initialization sequence.  This prevents further error
handling if we get a NOT_READY response from a TUR command by causing
scsi_check_sense() to return SUCCESS.  Therefore, scsi_eh_scmd_add() will
not run and the adapter state will remain as SHOST_RUNNING.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-06-03 15:48:52.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-06-08 17:22:14.000000000 -0700
@@ -4350,8 +4350,6 @@ static int ipr_slave_configure(struct sc
 					     IPR_VSET_RW_TIMEOUT);
 			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
 		}
-		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
-			sdev->allow_restart = 1;
 		if (ipr_is_gata(res) && res->sata_port)
 			ap = res->sata_port->ap;
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
@@ -6768,7 +6766,8 @@ static int ipr_init_res_table(struct ipr
 			list_move_tail(&res->queue, &ioa_cfg->used_res_q);
 			ipr_init_res_entry(res, &cfgtew);
 			res->add_to_ml = 1;
-		}
+		} else if (res->sdev && (ipr_is_vset_device(res) || ipr_is_scsi_disk(res)))
+			res->sdev->allow_restart = 1;

 		if (found)
 			ipr_update_res_entry(res, &cfgtew);

