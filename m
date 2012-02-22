From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 08/34] scsi proc_ops: convert drivers/scsi/ibmmca.c
Date: Wed, 22 Feb 2012 22:45:59 +0300
Message-ID: <1329939985-26793-8-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2BVTqr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:47 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:46 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/ibmmca.c |  105 ++++++++++++++++++++++++++----------------------
 1 files changed, 57 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 67fc8ff..1d6ca0f 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -27,6 +27,7 @@
 #include <linux/delay.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/stat.h>
 #include <linux/mca.h>
 #include <linux/spinlock.h>
@@ -43,7 +44,7 @@ static int ibmmca_queuecommand (struct Scsi_Host *, struct scsi_cmnd *);
 static int ibmmca_abort (Scsi_Cmnd *);
 static int ibmmca_host_reset (Scsi_Cmnd *);
 static int ibmmca_biosparam (struct scsi_device *, struct block_device *, sector_t, int *);
-static int ibmmca_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout);
+static const struct file_operations ibmmca_proc_ops;
 
 
 
@@ -1490,7 +1491,7 @@ static int ibmmca_getinfo(char *buf, int slot, void *dev_id)
 
 static struct scsi_host_template ibmmca_driver_template = {
           .proc_name      = "ibmmca",
-	  .proc_info	  = ibmmca_proc_info,
+	  .proc_ops	  = &ibmmca_proc_ops,
           .name           = "IBM SCSI-Subsystem",
           .queuecommand   = ibmmca_queuecommand,
 	  .eh_abort_handler = ibmmca_abort,
@@ -2262,9 +2263,9 @@ static int ldn_access_total_modeselect(struct Scsi_Host *shpnt)
 }
 
 /* routine to display info in the proc-fs-structure (a deluxe feature) */
-static int ibmmca_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout)
+static int ibmmca_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
+	struct Scsi_Host *shpnt = m->private;
 	int i, id, lun;
 	unsigned long flags;
 	int max_pun;
@@ -2274,64 +2275,72 @@ static int ibmmca_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start,
 
 	max_pun = subsystem_maxid(shpnt);
 
-	len += sprintf(buffer + len, "\n             IBM-SCSI-Subsystem-Linux-Driver, Version %s\n\n\n", IBMMCA_SCSI_DRIVER_VERSION);
-	len += sprintf(buffer + len, " SCSI Access-Statistics:\n");
-	len += sprintf(buffer + len, "               Device Scanning Order....: %s\n", (ibm_ansi_order) ? "IBM/ANSI" : "New Industry Standard");
+	seq_printf(m, "\n             IBM-SCSI-Subsystem-Linux-Driver, Version %s\n\n\n", IBMMCA_SCSI_DRIVER_VERSION);
+	seq_printf(m, " SCSI Access-Statistics:\n");
+	seq_printf(m, "               Device Scanning Order....: %s\n", (ibm_ansi_order) ? "IBM/ANSI" : "New Industry Standard");
 #ifdef CONFIG_SCSI_MULTI_LUN
-	len += sprintf(buffer + len, "               Multiple LUN probing.....: Yes\n");
+	seq_printf(m, "               Multiple LUN probing.....: Yes\n");
 #else
-	len += sprintf(buffer + len, "               Multiple LUN probing.....: No\n");
+	seq_printf(m, "               Multiple LUN probing.....: No\n");
 #endif
-	len += sprintf(buffer + len, "               This Hostnumber..........: %d\n", shpnt->host_no);
-	len += sprintf(buffer + len, "               Base I/O-Port............: 0x%x\n", (unsigned int) (IM_CMD_REG(shpnt)));
-	len += sprintf(buffer + len, "               (Shared) IRQ.............: %d\n", IM_IRQ);
-	len += sprintf(buffer + len, "               Total Interrupts.........: %d\n", IBM_DS(shpnt).total_interrupts);
-	len += sprintf(buffer + len, "               Total SCSI Accesses......: %d\n", IBM_DS(shpnt).total_accesses);
-	len += sprintf(buffer + len, "               Total short SCBs.........: %d\n", IBM_DS(shpnt).scbs);
-	len += sprintf(buffer + len, "               Total long SCBs..........: %d\n", IBM_DS(shpnt).long_scbs);
-	len += sprintf(buffer + len, "                 Total SCSI READ/WRITE..: %d\n", ldn_access_total_read_write(shpnt));
-	len += sprintf(buffer + len, "                 Total SCSI Inquiries...: %d\n", ldn_access_total_inquiry(shpnt));
-	len += sprintf(buffer + len, "                 Total SCSI Modeselects.: %d\n", ldn_access_total_modeselect(shpnt));
-	len += sprintf(buffer + len, "                 Total SCSI other cmds..: %d\n", IBM_DS(shpnt).total_accesses - ldn_access_total_read_write(shpnt)
+	seq_printf(m, "               This Hostnumber..........: %d\n", shpnt->host_no);
+	seq_printf(m, "               Base I/O-Port............: 0x%x\n", (unsigned int) (IM_CMD_REG(shpnt)));
+	seq_printf(m, "               (Shared) IRQ.............: %d\n", IM_IRQ);
+	seq_printf(m, "               Total Interrupts.........: %d\n", IBM_DS(shpnt).total_interrupts);
+	seq_printf(m, "               Total SCSI Accesses......: %d\n", IBM_DS(shpnt).total_accesses);
+	seq_printf(m, "               Total short SCBs.........: %d\n", IBM_DS(shpnt).scbs);
+	seq_printf(m, "               Total long SCBs..........: %d\n", IBM_DS(shpnt).long_scbs);
+	seq_printf(m, "                 Total SCSI READ/WRITE..: %d\n", ldn_access_total_read_write(shpnt));
+	seq_printf(m, "                 Total SCSI Inquiries...: %d\n", ldn_access_total_inquiry(shpnt));
+	seq_printf(m, "                 Total SCSI Modeselects.: %d\n", ldn_access_total_modeselect(shpnt));
+	seq_printf(m, "                 Total SCSI other cmds..: %d\n", IBM_DS(shpnt).total_accesses - ldn_access_total_read_write(shpnt)
 		       - ldn_access_total_modeselect(shpnt)
 		       - ldn_access_total_inquiry(shpnt));
-	len += sprintf(buffer + len, "               Total SCSI command fails.: %d\n\n", IBM_DS(shpnt).total_errors);
-	len += sprintf(buffer + len, " Logical-Device-Number (LDN) Access-Statistics:\n");
-	len += sprintf(buffer + len, "         LDN | Accesses [%%] |   READ    |   WRITE   | ASSIGNMENTS\n");
-	len += sprintf(buffer + len, "        -----|--------------|-----------|-----------|--------------\n");
+	seq_printf(m, "               Total SCSI command fails.: %d\n\n", IBM_DS(shpnt).total_errors);
+	seq_printf(m, " Logical-Device-Number (LDN) Access-Statistics:\n");
+	seq_printf(m, "         LDN | Accesses [%%] |   READ    |   WRITE   | ASSIGNMENTS\n");
+	seq_printf(m, "        -----|--------------|-----------|-----------|--------------\n");
 	for (i = 0; i <= MAX_LOG_DEV; i++)
-		len += sprintf(buffer + len, "         %2X  |    %3d       |  %8d |  %8d | %8d\n", i, ldn_access_load(shpnt, i), IBM_DS(shpnt).ldn_read_access[i], IBM_DS(shpnt).ldn_write_access[i], IBM_DS(shpnt).ldn_assignments[i]);
-	len += sprintf(buffer + len, "        -----------------------------------------------------------\n\n");
-	len += sprintf(buffer + len, " Dynamical-LDN-Assignment-Statistics:\n");
-	len += sprintf(buffer + len, "               Number of physical SCSI-devices..: %d (+ Adapter)\n", IBM_DS(shpnt).total_scsi_devices);
-	len += sprintf(buffer + len, "               Dynamical Assignment necessary...: %s\n", IBM_DS(shpnt).dyn_flag ? "Yes" : "No ");
-	len += sprintf(buffer + len, "               Next LDN to be assigned..........: 0x%x\n", next_ldn(shpnt));
-	len += sprintf(buffer + len, "               Dynamical assignments done yet...: %d\n", IBM_DS(shpnt).dynamical_assignments);
-	len += sprintf(buffer + len, "\n Current SCSI-Device-Mapping:\n");
-	len += sprintf(buffer + len, "        Physical SCSI-Device Map               Logical SCSI-Device Map\n");
-	len += sprintf(buffer + len, "    ID\\LUN  0  1  2  3  4  5  6  7       ID\\LUN  0  1  2  3  4  5  6  7\n");
+		seq_printf(m, "         %2X  |    %3d       |  %8d |  %8d | %8d\n", i, ldn_access_load(shpnt, i), IBM_DS(shpnt).ldn_read_access[i], IBM_DS(shpnt).ldn_write_access[i], IBM_DS(shpnt).ldn_assignments[i]);
+	seq_printf(m, "        -----------------------------------------------------------\n\n");
+	seq_printf(m, " Dynamical-LDN-Assignment-Statistics:\n");
+	seq_printf(m, "               Number of physical SCSI-devices..: %d (+ Adapter)\n", IBM_DS(shpnt).total_scsi_devices);
+	seq_printf(m, "               Dynamical Assignment necessary...: %s\n", IBM_DS(shpnt).dyn_flag ? "Yes" : "No ");
+	seq_printf(m, "               Next LDN to be assigned..........: 0x%x\n", next_ldn(shpnt));
+	seq_printf(m, "               Dynamical assignments done yet...: %d\n", IBM_DS(shpnt).dynamical_assignments);
+	seq_printf(m, "\n Current SCSI-Device-Mapping:\n");
+	seq_printf(m, "        Physical SCSI-Device Map               Logical SCSI-Device Map\n");
+	seq_printf(m, "    ID\\LUN  0  1  2  3  4  5  6  7       ID\\LUN  0  1  2  3  4  5  6  7\n");
 	for (id = 0; id < max_pun; id++) {
-		len += sprintf(buffer + len, "    %2d     ", id);
+		seq_printf(m, "    %2d     ", id);
 		for (lun = 0; lun < 8; lun++)
-			len += sprintf(buffer + len, "%2s ", ti_p(get_scsi(shpnt)[id][lun]));
-		len += sprintf(buffer + len, "      %2d     ", id);
+			seq_printf(m, "%2s ", ti_p(get_scsi(shpnt)[id][lun]));
+		seq_printf(m, "      %2d     ", id);
 		for (lun = 0; lun < 8; lun++)
-			len += sprintf(buffer + len, "%2s ", ti_l(get_ldn(shpnt)[id][lun]));
-		len += sprintf(buffer + len, "\n");
+			seq_printf(m, "%2s ", ti_l(get_ldn(shpnt)[id][lun]));
+		seq_printf(m, "\n");
 	}
+	spin_unlock_irqrestore(shpnt->host_lock, flags);
 
-	len += sprintf(buffer + len, "(A = IBM-Subsystem, D = Harddisk, T = Tapedrive, P = Processor, W = WORM,\n");
-	len += sprintf(buffer + len, " R = CD-ROM, S = Scanner, M = MO-Drive, C = Medium-Changer, + = unprovided LUN,\n");
-	len += sprintf(buffer + len, " - = nothing found, nothing assigned or unprobed LUN)\n\n");
+	seq_printf(m, "(A = IBM-Subsystem, D = Harddisk, T = Tapedrive, P = Processor, W = WORM,\n");
+	seq_printf(m, " R = CD-ROM, S = Scanner, M = MO-Drive, C = Medium-Changer, + = unprovided LUN,\n");
+	seq_printf(m, " - = nothing found, nothing assigned or unprobed LUN)\n\n");
 
-	*start = buffer + offset;
-	len -= offset;
-	if (len > length)
-		len = length;
-	spin_unlock_irqrestore(shpnt->host_lock, flags);
-	return len;
+	return 0;
 }
 
+static int ibmmca_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ibmmca_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations ibmmca_proc_ops = {
+	.open		= ibmmca_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int option_setup(char *str)
 {
 	int ints[IM_MAX_HOSTS];
-- 
1.7.3.4

