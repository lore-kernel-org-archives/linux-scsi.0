From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [Ubuntu PATCH] lpfc: Add missing proc_name entry to scsi_host_table
Date: Thu, 15 Jun 2006 13:00:37 -0700
Message-ID: <4491BC65.8010202@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:33471 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1031129AbWFOTAR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 15:00:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@SteelEye.com>, james.smart@emulex.com, akpm <akpm@osdl.org>

[UBUNTU:drivers/scsi/lpfc] Add missing proc_name entry to scsi_host_table.

http://www.kernel.org/git/?p=linux/kernel/git/bcollins/ubuntu-dapper.git;a=commitdiff;h=8e3174d462c06d45138ff7a9a25667a7347ff5ab

According to a few people, the scsi proc interface should die, but sysfs
still uses some proc_* entries from scsi_host_table.

The Emulex driver needs to export at least proc_name.

Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    1 +
 1 files changed, 1 insertion(+)

--- linux-2617-rc6g7.orig/drivers/scsi/lpfc/lpfc_scsi.c
+++ linux-2617-rc6g7/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1269,6 +1269,7 @@ struct scsi_host_template lpfc_template 
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
+	.proc_name		= "lpfc",
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,

