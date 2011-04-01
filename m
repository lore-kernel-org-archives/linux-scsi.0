From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Fri, 1 Apr 2011 16:20:51 -0400
Message-ID: <20110401202051.GL4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1DAUUx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 16:20:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


In preparation for moving some drivers out from under the host_lock,
make cmd_serial_number an atomic.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2aeb2e9..13a3bf0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -631,14 +631,15 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
  * @host: the scsi host
  * @cmd: command to assign serial number to
  *
- * Description: a serial number identifies a request for error recovery
- * and debugging purposes.  Protected by the Host_Lock of host.
+ * A serial number identifies a request for error recovery and debugging
+ * purposes.
  */
 void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
-	cmd->serial_number = host->cmd_serial_number++;
+ again:
+	cmd->serial_number = atomic_inc_return(&host->cmd_serial_number);
 	if (cmd->serial_number == 0) 
-		cmd->serial_number = host->cmd_serial_number++;
+		goto again;
 }
 EXPORT_SYMBOL(scsi_cmd_get_serial);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e7e3858..69dfabb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -621,11 +621,9 @@ struct Scsi_Host {
 	short unsigned int sg_prot_tablesize;
 	short unsigned int max_sectors;
 	unsigned long dma_boundary;
-	/* 
-	 * Used to assign serial numbers to the cmds.
-	 * Protected by the host lock.
-	 */
-	unsigned long cmd_serial_number;
+
+	/* Used to assign serial numbers to the cmds.  */
+	atomic_t cmd_serial_number;
 	
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
