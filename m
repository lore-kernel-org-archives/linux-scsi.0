From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/26] megaraid: Don't use create_proc_read_entry() [RFC]
Date: Thu, 11 Apr 2013 14:30:01 +0100
Message-ID: <20130411133001.32763.78829.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, viro@ZenIV.linux.org.uk, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Neela Syam Kolli <megaraidlinux@lsi.com>
cc: James E.J. Bottomley <JBottomley@parallels.com>
cc: linux-scsi@vger.kernel.org
---

 drivers/scsi/megaraid.c | 1041 +++++++++++++++++------------------------------
 drivers/scsi/megaraid.h |   17 -
 2 files changed, 383 insertions(+), 675 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9504ec0..8230ce3 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -39,6 +39,7 @@
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/reboot.h>
 #include <linux/module.h>
 #include <linux/list.h>
@@ -2069,385 +2070,201 @@ mega_free_inquiry(void *inquiry, dma_addr_t dma_handle, struct pci_dev *pdev)
 #ifdef CONFIG_PROC_FS
 /* Following code handles /proc fs  */
 
-#define CREATE_READ_PROC(string, func)	create_proc_read_entry(string,	\
-					S_IRUSR | S_IFREG,		\
-					controller_proc_dir_entry,	\
-					func, adapter)
-
-/**
- * mega_create_proc_entry()
- * @index - index in soft state array
- * @parent - parent node for this /proc entry
- *
- * Creates /proc entries for our controllers.
- */
-static void
-mega_create_proc_entry(int index, struct proc_dir_entry *parent)
-{
-	struct proc_dir_entry	*controller_proc_dir_entry = NULL;
-	u8		string[64] = { 0 };
-	adapter_t	*adapter = hba_soft_state[index];
-
-	sprintf(string, "hba%d", adapter->host->host_no);
-
-	controller_proc_dir_entry =
-		adapter->controller_proc_dir_entry = proc_mkdir(string, parent);
-
-	if(!controller_proc_dir_entry) {
-		printk(KERN_WARNING "\nmegaraid: proc_mkdir failed\n");
-		return;
-	}
-	adapter->proc_read = CREATE_READ_PROC("config", proc_read_config);
-	adapter->proc_stat = CREATE_READ_PROC("stat", proc_read_stat);
-	adapter->proc_mbox = CREATE_READ_PROC("mailbox", proc_read_mbox);
-#if MEGA_HAVE_ENH_PROC
-	adapter->proc_rr = CREATE_READ_PROC("rebuild-rate", proc_rebuild_rate);
-	adapter->proc_battery = CREATE_READ_PROC("battery-status",
-			proc_battery);
-
-	/*
-	 * Display each physical drive on its channel
-	 */
-	adapter->proc_pdrvstat[0] = CREATE_READ_PROC("diskdrives-ch0",
-					proc_pdrv_ch0);
-	adapter->proc_pdrvstat[1] = CREATE_READ_PROC("diskdrives-ch1",
-					proc_pdrv_ch1);
-	adapter->proc_pdrvstat[2] = CREATE_READ_PROC("diskdrives-ch2",
-					proc_pdrv_ch2);
-	adapter->proc_pdrvstat[3] = CREATE_READ_PROC("diskdrives-ch3",
-					proc_pdrv_ch3);
-
-	/*
-	 * Display a set of up to 10 logical drive through each of following
-	 * /proc entries
-	 */
-	adapter->proc_rdrvstat[0] = CREATE_READ_PROC("raiddrives-0-9",
-					proc_rdrv_10);
-	adapter->proc_rdrvstat[1] = CREATE_READ_PROC("raiddrives-10-19",
-					proc_rdrv_20);
-	adapter->proc_rdrvstat[2] = CREATE_READ_PROC("raiddrives-20-29",
-					proc_rdrv_30);
-	adapter->proc_rdrvstat[3] = CREATE_READ_PROC("raiddrives-30-39",
-					proc_rdrv_40);
-#endif
-}
-
-
 /**
- * proc_read_config()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_config()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
  * Display configuration information about the controller.
  */
 static int
-proc_read_config(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_config(struct seq_file *m, void *v)
 {
 
-	adapter_t *adapter = (adapter_t *)data;
-	int len = 0;
-
-	len += sprintf(page+len, "%s", MEGARAID_VERSION);
+	adapter_t *adapter = m->private;
 
+	seq_puts(m, MEGARAID_VERSION);
 	if(adapter->product_info.product_name[0])
-		len += sprintf(page+len, "%s\n",
-				adapter->product_info.product_name);
-
-	len += sprintf(page+len, "Controller Type: ");
+		seq_printf(m, "%s\n", adapter->product_info.product_name);
 
-	if( adapter->flag & BOARD_MEMMAP ) {
-		len += sprintf(page+len,
-			"438/466/467/471/493/518/520/531/532\n");
-	}
-	else {
-		len += sprintf(page+len,
-			"418/428/434\n");
-	}
+	seq_puts(m, "Controller Type: ");
 
-	if(adapter->flag & BOARD_40LD) {
-		len += sprintf(page+len,
-				"Controller Supports 40 Logical Drives\n");
-	}
+	if( adapter->flag & BOARD_MEMMAP )
+		seq_puts(m, "438/466/467/471/493/518/520/531/532\n");
+	else
+		seq_puts(m, "418/428/434\n");
 
-	if(adapter->flag & BOARD_64BIT) {
-		len += sprintf(page+len,
-		"Controller capable of 64-bit memory addressing\n");
-	}
-	if( adapter->has_64bit_addr ) {
-		len += sprintf(page+len,
-			"Controller using 64-bit memory addressing\n");
-	}
-	else {
-		len += sprintf(page+len,
-			"Controller is not using 64-bit memory addressing\n");
-	}
+	if(adapter->flag & BOARD_40LD)
+		seq_puts(m, "Controller Supports 40 Logical Drives\n");
 
-	len += sprintf(page+len, "Base = %08lx, Irq = %d, ", adapter->base,
-			adapter->host->irq);
-
-	len += sprintf(page+len, "Logical Drives = %d, Channels = %d\n",
-			adapter->numldrv, adapter->product_info.nchannels);
-
-	len += sprintf(page+len, "Version =%s:%s, DRAM = %dMb\n",
-			adapter->fw_version, adapter->bios_version,
-			adapter->product_info.dram_size);
-
-	len += sprintf(page+len,
-		"Controller Queue Depth = %d, Driver Queue Depth = %d\n",
-		adapter->product_info.max_commands, adapter->max_cmds);
-
-	len += sprintf(page+len, "support_ext_cdb    = %d\n",
-			adapter->support_ext_cdb);
-	len += sprintf(page+len, "support_random_del = %d\n",
-			adapter->support_random_del);
-	len += sprintf(page+len, "boot_ldrv_enabled  = %d\n",
-			adapter->boot_ldrv_enabled);
-	len += sprintf(page+len, "boot_ldrv          = %d\n",
-			adapter->boot_ldrv);
-	len += sprintf(page+len, "boot_pdrv_enabled  = %d\n",
-			adapter->boot_pdrv_enabled);
-	len += sprintf(page+len, "boot_pdrv_ch       = %d\n",
-			adapter->boot_pdrv_ch);
-	len += sprintf(page+len, "boot_pdrv_tgt      = %d\n",
-			adapter->boot_pdrv_tgt);
-	len += sprintf(page+len, "quiescent          = %d\n",
-			atomic_read(&adapter->quiescent));
-	len += sprintf(page+len, "has_cluster        = %d\n",
-			adapter->has_cluster);
-
-	len += sprintf(page+len, "\nModule Parameters:\n");
-	len += sprintf(page+len, "max_cmd_per_lun    = %d\n",
-			max_cmd_per_lun);
-	len += sprintf(page+len, "max_sectors_per_io = %d\n",
-			max_sectors_per_io);
-
-	*eof = 1;
-
-	return len;
+	if(adapter->flag & BOARD_64BIT)
+		seq_puts(m, "Controller capable of 64-bit memory addressing\n");
+	if( adapter->has_64bit_addr )
+		seq_puts(m, "Controller using 64-bit memory addressing\n");
+	else
+		seq_puts(m, "Controller is not using 64-bit memory addressing\n");
+
+	seq_printf(m, "Base = %08lx, Irq = %d, ",
+		   adapter->base, adapter->host->irq);
+
+	seq_printf(m, "Logical Drives = %d, Channels = %d\n",
+		   adapter->numldrv, adapter->product_info.nchannels);
+
+	seq_printf(m, "Version =%s:%s, DRAM = %dMb\n",
+		   adapter->fw_version, adapter->bios_version,
+		   adapter->product_info.dram_size);
+
+	seq_printf(m, "Controller Queue Depth = %d, Driver Queue Depth = %d\n",
+		   adapter->product_info.max_commands, adapter->max_cmds);
+
+	seq_printf(m, "support_ext_cdb    = %d\n", adapter->support_ext_cdb);
+	seq_printf(m, "support_random_del = %d\n", adapter->support_random_del);
+	seq_printf(m, "boot_ldrv_enabled  = %d\n", adapter->boot_ldrv_enabled);
+	seq_printf(m, "boot_ldrv          = %d\n", adapter->boot_ldrv);
+	seq_printf(m, "boot_pdrv_enabled  = %d\n", adapter->boot_pdrv_enabled);
+	seq_printf(m, "boot_pdrv_ch       = %d\n", adapter->boot_pdrv_ch);
+	seq_printf(m, "boot_pdrv_tgt      = %d\n", adapter->boot_pdrv_tgt);
+	seq_printf(m, "quiescent          = %d\n",
+		   atomic_read(&adapter->quiescent));
+	seq_printf(m, "has_cluster        = %d\n", adapter->has_cluster);
+
+	seq_puts(m, "\nModule Parameters:\n");
+	seq_printf(m, "max_cmd_per_lun    = %d\n", max_cmd_per_lun);
+	seq_printf(m, "max_sectors_per_io = %d\n", max_sectors_per_io);
+	return 0;
 }
 
-
-
 /**
- * proc_read_stat()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_stat()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
- * Diaplay statistical information about the I/O activity.
+ * Display statistical information about the I/O activity.
  */
 static int
-proc_read_stat(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_stat(struct seq_file *m, void *v)
 {
-	adapter_t	*adapter;
-	int	len;
+	adapter_t *adapter = m->private;
+#if MEGA_HAVE_STATS
 	int	i;
+#endif
 
-	i = 0;	/* avoid compilation warnings */
-	len = 0;
-	adapter = (adapter_t *)data;
-
-	len = sprintf(page, "Statistical Information for this controller\n");
-	len += sprintf(page+len, "pend_cmds = %d\n",
-			atomic_read(&adapter->pend_cmds));
+	seq_puts(m, "Statistical Information for this controller\n");
+	seq_printf(m, "pend_cmds = %d\n", atomic_read(&adapter->pend_cmds));
 #if MEGA_HAVE_STATS
 	for(i = 0; i < adapter->numldrv; i++) {
-		len += sprintf(page+len, "Logical Drive %d:\n", i);
-
-		len += sprintf(page+len,
-			"\tReads Issued = %lu, Writes Issued = %lu\n",
-			adapter->nreads[i], adapter->nwrites[i]);
-
-		len += sprintf(page+len,
-			"\tSectors Read = %lu, Sectors Written = %lu\n",
-			adapter->nreadblocks[i], adapter->nwriteblocks[i]);
-
-		len += sprintf(page+len,
-			"\tRead errors = %lu, Write errors = %lu\n\n",
-			adapter->rd_errors[i], adapter->wr_errors[i]);
+		seq_printf(m, "Logical Drive %d:\n", i);
+		seq_printf(m, "\tReads Issued = %lu, Writes Issued = %lu\n",
+			   adapter->nreads[i], adapter->nwrites[i]);
+		seq_printf(m, "\tSectors Read = %lu, Sectors Written = %lu\n",
+			   adapter->nreadblocks[i], adapter->nwriteblocks[i]);
+		seq_printf(m, "\tRead errors = %lu, Write errors = %lu\n\n",
+			   adapter->rd_errors[i], adapter->wr_errors[i]);
 	}
 #else
-	len += sprintf(page+len,
-			"IO and error counters not compiled in driver.\n");
+	seq_puts(m, "IO and error counters not compiled in driver.\n");
 #endif
-
-	*eof = 1;
-
-	return len;
+	return 0;
 }
 
 
 /**
- * proc_read_mbox()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_mbox()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
  * Display mailbox information for the last command issued. This information
  * is good for debugging.
  */
 static int
-proc_read_mbox(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_mbox(struct seq_file *m, void *v)
 {
-
-	adapter_t	*adapter = (adapter_t *)data;
+	adapter_t	*adapter = m->private;
 	volatile mbox_t	*mbox = adapter->mbox;
-	int	len = 0;
-
-	len = sprintf(page, "Contents of Mail Box Structure\n");
-	len += sprintf(page+len, "  Fw Command   = 0x%02x\n", 
-			mbox->m_out.cmd);
-	len += sprintf(page+len, "  Cmd Sequence = 0x%02x\n", 
-			mbox->m_out.cmdid);
-	len += sprintf(page+len, "  No of Sectors= %04d\n", 
-			mbox->m_out.numsectors);
-	len += sprintf(page+len, "  LBA          = 0x%02x\n", 
-			mbox->m_out.lba);
-	len += sprintf(page+len, "  DTA          = 0x%08x\n", 
-			mbox->m_out.xferaddr);
-	len += sprintf(page+len, "  Logical Drive= 0x%02x\n", 
-			mbox->m_out.logdrv);
-	len += sprintf(page+len, "  No of SG Elmt= 0x%02x\n",
-			mbox->m_out.numsgelements);
-	len += sprintf(page+len, "  Busy         = %01x\n", 
-			mbox->m_in.busy);
-	len += sprintf(page+len, "  Status       = 0x%02x\n", 
-			mbox->m_in.status);
-
-	*eof = 1;
-
-	return len;
+
+	seq_puts(m, "Contents of Mail Box Structure\n");
+	seq_printf(m, "  Fw Command   = 0x%02x\n", mbox->m_out.cmd);
+	seq_printf(m, "  Cmd Sequence = 0x%02x\n", mbox->m_out.cmdid);
+	seq_printf(m, "  No of Sectors= %04d\n", mbox->m_out.numsectors);
+	seq_printf(m, "  LBA          = 0x%02x\n", mbox->m_out.lba);
+	seq_printf(m, "  DTA          = 0x%08x\n", mbox->m_out.xferaddr);
+	seq_printf(m, "  Logical Drive= 0x%02x\n", mbox->m_out.logdrv);
+	seq_printf(m, "  No of SG Elmt= 0x%02x\n", mbox->m_out.numsgelements);
+	seq_printf(m, "  Busy         = %01x\n", mbox->m_in.busy);
+	seq_printf(m, "  Status       = 0x%02x\n", mbox->m_in.status);
+	return 0;
 }
 
 
 /**
- * proc_rebuild_rate()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_rebuild_rate()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
  * Display current rebuild rate
  */
 static int
-proc_rebuild_rate(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_rebuild_rate(struct seq_file *m, void *v)
 {
-	adapter_t	*adapter = (adapter_t *)data;
+	adapter_t	*adapter = m->private;
 	dma_addr_t	dma_handle;
 	caddr_t		inquiry;
 	struct pci_dev	*pdev;
-	int	len = 0;
 
-	if( make_local_pdev(adapter, &pdev) != 0 ) {
-		*eof = 1;
-		return len;
-	}
+	if( make_local_pdev(adapter, &pdev) != 0 )
+		return 0;
 
-	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL ) {
-		free_local_pdev(pdev);
-		*eof = 1;
-		return len;
-	}
+	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL )
+		goto free_pdev;
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
-
-		len = sprintf(page, "Adapter inquiry failed.\n");
-
+		seq_puts(m, "Adapter inquiry failed.\n");
 		printk(KERN_WARNING "megaraid: inquiry failed.\n");
-
-		mega_free_inquiry(inquiry, dma_handle, pdev);
-
-		free_local_pdev(pdev);
-
-		*eof = 1;
-
-		return len;
+		goto free_inquiry;
 	}
 
-	if( adapter->flag & BOARD_40LD ) {
-		len = sprintf(page, "Rebuild Rate: [%d%%]\n",
-			((mega_inquiry3 *)inquiry)->rebuild_rate);
-	}
-	else {
-		len = sprintf(page, "Rebuild Rate: [%d%%]\n",
+	if( adapter->flag & BOARD_40LD )
+		seq_printf(m, "Rebuild Rate: [%d%%]\n",
+			   ((mega_inquiry3 *)inquiry)->rebuild_rate);
+	else
+		seq_printf(m, "Rebuild Rate: [%d%%]\n",
 			((mraid_ext_inquiry *)
-			inquiry)->raid_inq.adapter_info.rebuild_rate);
-	}
-
+			 inquiry)->raid_inq.adapter_info.rebuild_rate);
 
+free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
-
+free_pdev:
 	free_local_pdev(pdev);
-
-	*eof = 1;
-
-	return len;
+	return 0;
 }
 
 
 /**
- * proc_battery()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_battery()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
  * Display information about the battery module on the controller.
  */
 static int
-proc_battery(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_battery(struct seq_file *m, void *v)
 {
-	adapter_t	*adapter = (adapter_t *)data;
+	adapter_t	*adapter = m->private;
 	dma_addr_t	dma_handle;
 	caddr_t		inquiry;
 	struct pci_dev	*pdev;
-	u8	battery_status = 0;
-	char	str[256];
-	int	len = 0;
+	u8	battery_status;
 
-	if( make_local_pdev(adapter, &pdev) != 0 ) {
-		*eof = 1;
-		return len;
-	}
+	if( make_local_pdev(adapter, &pdev) != 0 )
+		return 0;
 
-	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL ) {
-		free_local_pdev(pdev);
-		*eof = 1;
-		return len;
-	}
+	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL )
+		goto free_pdev;
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
-
-		len = sprintf(page, "Adapter inquiry failed.\n");
-
+		seq_printf(m, "Adapter inquiry failed.\n");
 		printk(KERN_WARNING "megaraid: inquiry failed.\n");
-
-		mega_free_inquiry(inquiry, dma_handle, pdev);
-
-		free_local_pdev(pdev);
-
-		*eof = 1;
-
-		return len;
+		goto free_inquiry;
 	}
 
 	if( adapter->flag & BOARD_40LD ) {
@@ -2461,146 +2278,80 @@ proc_battery(char *page, char **start, off_t offset, int count, int *eof,
 	/*
 	 * Decode the battery status
 	 */
-	sprintf(str, "Battery Status:[%d]", battery_status);
+	seq_printf(m, "Battery Status:[%d]", battery_status);
 
 	if(battery_status == MEGA_BATT_CHARGE_DONE)
-		strcat(str, " Charge Done");
+		seq_puts(m, " Charge Done");
 
 	if(battery_status & MEGA_BATT_MODULE_MISSING)
-		strcat(str, " Module Missing");
+		seq_puts(m, " Module Missing");
 	
 	if(battery_status & MEGA_BATT_LOW_VOLTAGE)
-		strcat(str, " Low Voltage");
+		seq_puts(m, " Low Voltage");
 	
 	if(battery_status & MEGA_BATT_TEMP_HIGH)
-		strcat(str, " Temperature High");
+		seq_puts(m, " Temperature High");
 	
 	if(battery_status & MEGA_BATT_PACK_MISSING)
-		strcat(str, " Pack Missing");
+		seq_puts(m, " Pack Missing");
 	
 	if(battery_status & MEGA_BATT_CHARGE_INPROG)
-		strcat(str, " Charge In-progress");
+		seq_puts(m, " Charge In-progress");
 	
 	if(battery_status & MEGA_BATT_CHARGE_FAIL)
-		strcat(str, " Charge Fail");
+		seq_puts(m, " Charge Fail");
 	
 	if(battery_status & MEGA_BATT_CYCLES_EXCEEDED)
-		strcat(str, " Cycles Exceeded");
-
-	len = sprintf(page, "%s\n", str);
+		seq_puts(m, " Cycles Exceeded");
 
+	seq_putc(m, '\n');
 
+free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
-
+free_pdev:
 	free_local_pdev(pdev);
-
-	*eof = 1;
-
-	return len;
-}
-
-
-/**
- * proc_pdrv_ch0()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
- *
- * Display information about the physical drives on physical channel 0.
- */
-static int
-proc_pdrv_ch0(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
-{
-	adapter_t *adapter = (adapter_t *)data;
-
-	*eof = 1;
-
-	return (proc_pdrv(adapter, page, 0));
-}
-
-
-/**
- * proc_pdrv_ch1()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
- *
- * Display information about the physical drives on physical channel 1.
- */
-static int
-proc_pdrv_ch1(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
-{
-	adapter_t *adapter = (adapter_t *)data;
-
-	*eof = 1;
-
-	return (proc_pdrv(adapter, page, 1));
+	return 0;
 }
 
 
-/**
- * proc_pdrv_ch2()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
- *
- * Display information about the physical drives on physical channel 2.
+/*
+ * Display scsi inquiry
  */
-static int
-proc_pdrv_ch2(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+static void
+mega_print_inquiry(struct seq_file *m, char *scsi_inq)
 {
-	adapter_t *adapter = (adapter_t *)data;
-
-	*eof = 1;
-
-	return (proc_pdrv(adapter, page, 2));
-}
+	int	i;
 
+	seq_puts(m, "  Vendor: ");
+	seq_write(m, scsi_inq + 8, 8);
+	seq_puts(m, "  Model: ");
+	seq_write(m, scsi_inq + 16, 16);
+	seq_puts(m, "  Rev: ");
+	seq_write(m, scsi_inq + 32, 4);
+	seq_putc(m, '\n');
 
-/**
- * proc_pdrv_ch3()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
- *
- * Display information about the physical drives on physical channel 3.
- */
-static int
-proc_pdrv_ch3(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
-{
-	adapter_t *adapter = (adapter_t *)data;
+	i = scsi_inq[0] & 0x1f;
+	seq_printf(m, "  Type:   %s ", scsi_device_type(i));
 
-	*eof = 1;
+	seq_printf(m, "                 ANSI SCSI revision: %02x",
+		   scsi_inq[2] & 0x07);
 
-	return (proc_pdrv(adapter, page, 3));
+	if( (scsi_inq[2] & 0x07) == 1 && (scsi_inq[3] & 0x0f) == 1 )
+		seq_puts(m, " CCS\n");
+	else
+		seq_putc(m, '\n');
 }
 
-
 /**
- * proc_pdrv()
+ * proc_show_pdrv()
+ * @m - Synthetic file construction data
  * @page - buffer to write the data in
  * @adapter - pointer to our soft state
  *
  * Display information about the physical drives.
  */
 static int
-proc_pdrv(adapter_t *adapter, char *page, int channel)
+proc_show_pdrv(struct seq_file *m, adapter_t *adapter, int channel)
 {
 	dma_addr_t	dma_handle;
 	char		*scsi_inq;
@@ -2611,32 +2362,24 @@ proc_pdrv(adapter_t *adapter, char *page, int channel)
 	u8	state;
 	int	tgt;
 	int	max_channels;
-	int	len = 0;
-	char	str[80];
 	int	i;
 
-	if( make_local_pdev(adapter, &pdev) != 0 ) {
-		return len;
-	}
+	if( make_local_pdev(adapter, &pdev) != 0 )
+		return 0;
 
-	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL ) {
+	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL )
 		goto free_pdev;
-	}
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
-		len = sprintf(page, "Adapter inquiry failed.\n");
-
+		seq_puts(m, "Adapter inquiry failed.\n");
 		printk(KERN_WARNING "megaraid: inquiry failed.\n");
-
 		goto free_inquiry;
 	}
 
 
 	scsi_inq = pci_alloc_consistent(pdev, 256, &scsi_inq_dma_handle);
-
 	if( scsi_inq == NULL ) {
-		len = sprintf(page, "memory not available for scsi inq.\n");
-
+		seq_puts(m, "memory not available for scsi inq.\n");
 		goto free_inquiry;
 	}
 
@@ -2659,39 +2402,31 @@ proc_pdrv(adapter_t *adapter, char *page, int channel)
 		i = channel*16 + tgt;
 
 		state = *(pdrv_state + i);
-
 		switch( state & 0x0F ) {
-
 		case PDRV_ONLINE:
-			sprintf(str,
-			"Channel:%2d Id:%2d State: Online",
-				channel, tgt);
+			seq_printf(m, "Channel:%2d Id:%2d State: Online",
+				   channel, tgt);
 			break;
 
 		case PDRV_FAILED:
-			sprintf(str,
-			"Channel:%2d Id:%2d State: Failed",
-				channel, tgt);
+			seq_printf(m, "Channel:%2d Id:%2d State: Failed",
+				   channel, tgt);
 			break;
 
 		case PDRV_RBLD:
-			sprintf(str,
-			"Channel:%2d Id:%2d State: Rebuild",
-				channel, tgt);
+			seq_printf(m, "Channel:%2d Id:%2d State: Rebuild",
+				   channel, tgt);
 			break;
 
 		case PDRV_HOTSPARE:
-			sprintf(str,
-			"Channel:%2d Id:%2d State: Hot spare",
-				channel, tgt);
+			seq_printf(m, "Channel:%2d Id:%2d State: Hot spare",
+				   channel, tgt);
 			break;
 
 		default:
-			sprintf(str,
-			"Channel:%2d Id:%2d State: Un-configured",
-				channel, tgt);
+			seq_printf(m, "Channel:%2d Id:%2d State: Un-configured",
+				   channel, tgt);
 			break;
-
 		}
 
 		/*
@@ -2710,11 +2445,8 @@ proc_pdrv(adapter_t *adapter, char *page, int channel)
 		 * Check for overflow. We print less than 240
 		 * characters for inquiry
 		 */
-		if( (len + 240) >= PAGE_SIZE ) break;
-
-		len += sprintf(page+len, "%s.\n", str);
-
-		len += mega_print_inquiry(page+len, scsi_inq);
+		seq_puts(m, ".\n");
+		mega_print_inquiry(m, scsi_inq);
 	}
 
 free_pci:
@@ -2723,150 +2455,68 @@ free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
 free_pdev:
 	free_local_pdev(pdev);
-
-	return len;
-}
-
-
-/*
- * Display scsi inquiry
- */
-static int
-mega_print_inquiry(char *page, char *scsi_inq)
-{
-	int	len = 0;
-	int	i;
-
-	len = sprintf(page, "  Vendor: ");
-	for( i = 8; i < 16; i++ ) {
-		len += sprintf(page+len, "%c", scsi_inq[i]);
-	}
-
-	len += sprintf(page+len, "  Model: ");
-
-	for( i = 16; i < 32; i++ ) {
-		len += sprintf(page+len, "%c", scsi_inq[i]);
-	}
-
-	len += sprintf(page+len, "  Rev: ");
-
-	for( i = 32; i < 36; i++ ) {
-		len += sprintf(page+len, "%c", scsi_inq[i]);
-	}
-
-	len += sprintf(page+len, "\n");
-
-	i = scsi_inq[0] & 0x1f;
-
-	len += sprintf(page+len, "  Type:   %s ", scsi_device_type(i));
-
-	len += sprintf(page+len,
-	"                 ANSI SCSI revision: %02x", scsi_inq[2] & 0x07);
-
-	if( (scsi_inq[2] & 0x07) == 1 && (scsi_inq[3] & 0x0f) == 1 )
-		len += sprintf(page+len, " CCS\n");
-	else
-		len += sprintf(page+len, "\n");
-
-	return len;
+	return 0;
 }
 
-
 /**
- * proc_rdrv_10()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_pdrv_ch0()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
- * Display real time information about the logical drives 0 through 9.
+ * Display information about the physical drives on physical channel 0.
  */
 static int
-proc_rdrv_10(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_pdrv_ch0(struct seq_file *m, void *v)
 {
-	adapter_t *adapter = (adapter_t *)data;
-
-	*eof = 1;
-
-	return (proc_rdrv(adapter, page, 0, 9));
+	return proc_show_pdrv(m, m->private, 0);
 }
 
 
 /**
- * proc_rdrv_20()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_pdrv_ch1()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
- * Display real time information about the logical drives 0 through 9.
+ * Display information about the physical drives on physical channel 1.
  */
 static int
-proc_rdrv_20(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_pdrv_ch1(struct seq_file *m, void *v)
 {
-	adapter_t *adapter = (adapter_t *)data;
-
-	*eof = 1;
-
-	return (proc_rdrv(adapter, page, 10, 19));
+	return proc_show_pdrv(m, m->private, 1);
 }
 
 
 /**
- * proc_rdrv_30()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_pdrv_ch2()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
- * Display real time information about the logical drives 0 through 9.
+ * Display information about the physical drives on physical channel 2.
  */
 static int
-proc_rdrv_30(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_pdrv_ch2(struct seq_file *m, void *v)
 {
-	adapter_t *adapter = (adapter_t *)data;
-
-	*eof = 1;
-
-	return (proc_rdrv(adapter, page, 20, 29));
+	return proc_show_pdrv(m, m->private, 2);
 }
 
 
 /**
- * proc_rdrv_40()
- * @page - buffer to write the data in
- * @start - where the actual data has been written in page
- * @offset - same meaning as the read system call
- * @count - same meaning as the read system call
- * @eof - set if no more data needs to be returned
- * @data - pointer to our soft state
+ * proc_show_pdrv_ch3()
+ * @m - Synthetic file construction data
+ * @v - File iterator
  *
- * Display real time information about the logical drives 0 through 9.
+ * Display information about the physical drives on physical channel 3.
  */
 static int
-proc_rdrv_40(char *page, char **start, off_t offset, int count, int *eof,
-		void *data)
+proc_show_pdrv_ch3(struct seq_file *m, void *v)
 {
-	adapter_t *adapter = (adapter_t *)data;
-
-	*eof = 1;
-
-	return (proc_rdrv(adapter, page, 30, 39));
+	return proc_show_pdrv(m, m->private, 3);
 }
 
 
 /**
- * proc_rdrv()
- * @page - buffer to write the data in
+ * proc_show_rdrv()
+ * @m - Synthetic file construction data
  * @adapter - pointer to our soft state
  * @start - starting logical drive to display
  * @end - ending logical drive to display
@@ -2875,7 +2525,7 @@ proc_rdrv_40(char *page, char **start, off_t offset, int count, int *eof,
  * /proc/scsi/scsi interface
  */
 static int
-proc_rdrv(adapter_t *adapter, char *page, int start, int end )
+proc_show_rdrv(struct seq_file *m, adapter_t *adapter, int start, int end )
 {
 	dma_addr_t	dma_handle;
 	logdrv_param	*lparam;
@@ -2887,29 +2537,18 @@ proc_rdrv(adapter_t *adapter, char *page, int start, int end )
 	u8	*rdrv_state;
 	int	num_ldrv;
 	u32	array_sz;
-	int	len = 0;
 	int	i;
 
-	if( make_local_pdev(adapter, &pdev) != 0 ) {
-		return len;
-	}
+	if( make_local_pdev(adapter, &pdev) != 0 )
+		return 0;
 
-	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL ) {
-		free_local_pdev(pdev);
-		return len;
-	}
+	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL )
+		goto free_pdev;
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
-
-		len = sprintf(page, "Adapter inquiry failed.\n");
-
+		seq_puts(m, "Adapter inquiry failed.\n");
 		printk(KERN_WARNING "megaraid: inquiry failed.\n");
-
-		mega_free_inquiry(inquiry, dma_handle, pdev);
-
-		free_local_pdev(pdev);
-
-		return len;
+		goto free_inquiry;
 	}
 
 	memset(&mc, 0, sizeof(megacmd_t));
@@ -2935,13 +2574,8 @@ proc_rdrv(adapter_t *adapter, char *page, int start, int end )
 			&disk_array_dma_handle);
 
 	if( disk_array == NULL ) {
-		len = sprintf(page, "memory not available.\n");
-
-		mega_free_inquiry(inquiry, dma_handle, pdev);
-
-		free_local_pdev(pdev);
-
-		return len;
+		seq_puts(m, "memory not available.\n");
+		goto free_inquiry;
 	}
 
 	mc.xferaddr = (u32)disk_array_dma_handle;
@@ -2951,17 +2585,8 @@ proc_rdrv(adapter_t *adapter, char *page, int start, int end )
 		mc.opcode = OP_DCMD_READ_CONFIG;
 
 		if( mega_internal_command(adapter, &mc, NULL) ) {
-
-			len = sprintf(page, "40LD read config failed.\n");
-
-			mega_free_inquiry(inquiry, dma_handle, pdev);
-
-			pci_free_consistent(pdev, array_sz, disk_array,
-					disk_array_dma_handle);
-
-			free_local_pdev(pdev);
-
-			return len;
+			seq_puts(m, "40LD read config failed.\n");
+			goto free_pci;
 		}
 
 	}
@@ -2969,24 +2594,10 @@ proc_rdrv(adapter_t *adapter, char *page, int start, int end )
 		mc.cmd = NEW_READ_CONFIG_8LD;
 
 		if( mega_internal_command(adapter, &mc, NULL) ) {
-
 			mc.cmd = READ_CONFIG_8LD;
-
-			if( mega_internal_command(adapter, &mc,
-						NULL) ){
-
-				len = sprintf(page,
-					"8LD read config failed.\n");
-
-				mega_free_inquiry(inquiry, dma_handle, pdev);
-
-				pci_free_consistent(pdev, array_sz,
-						disk_array,
-						disk_array_dma_handle);
-
-				free_local_pdev(pdev);
-
-				return len;
+			if( mega_internal_command(adapter, &mc, NULL) ) {
+				seq_puts(m, "8LD read config failed.\n");
+				goto free_pci;
 			}
 		}
 	}
@@ -3006,29 +2617,23 @@ proc_rdrv(adapter_t *adapter, char *page, int start, int end )
 		 * Check for overflow. We print less than 240 characters for
 		 * information about each logical drive.
 		 */
-		if( (len + 240) >= PAGE_SIZE ) break;
-
-		len += sprintf(page+len, "Logical drive:%2d:, ", i);
+		seq_printf(m, "Logical drive:%2d:, ", i);
 
 		switch( rdrv_state[i] & 0x0F ) {
 		case RDRV_OFFLINE:
-			len += sprintf(page+len, "state: offline");
+			seq_puts(m, "state: offline");
 			break;
-
 		case RDRV_DEGRADED:
-			len += sprintf(page+len, "state: degraded");
+			seq_puts(m, "state: degraded");
 			break;
-
 		case RDRV_OPTIMAL:
-			len += sprintf(page+len, "state: optimal");
+			seq_puts(m, "state: optimal");
 			break;
-
 		case RDRV_DELETED:
-			len += sprintf(page+len, "state: deleted");
+			seq_puts(m, "state: deleted");
 			break;
-
 		default:
-			len += sprintf(page+len, "state: unknown");
+			seq_puts(m, "state: unknown");
 			break;
 		}
 
@@ -3036,84 +2641,204 @@ proc_rdrv(adapter_t *adapter, char *page, int start, int end )
 		 * Check if check consistency or initialization is going on
 		 * for this logical drive.
 		 */
-		if( (rdrv_state[i] & 0xF0) == 0x20 ) {
-			len += sprintf(page+len,
-					", check-consistency in progress");
-		}
-		else if( (rdrv_state[i] & 0xF0) == 0x10 ) {
-			len += sprintf(page+len,
-					", initialization in progress");
-		}
+		if( (rdrv_state[i] & 0xF0) == 0x20 )
+			seq_puts(m, ", check-consistency in progress");
+		else if( (rdrv_state[i] & 0xF0) == 0x10 )
+			seq_puts(m, ", initialization in progress");
 		
-		len += sprintf(page+len, "\n");
-
-		len += sprintf(page+len, "Span depth:%3d, ",
-				lparam->span_depth);
-
-		len += sprintf(page+len, "RAID level:%3d, ",
-				lparam->level);
-
-		len += sprintf(page+len, "Stripe size:%3d, ",
-				lparam->stripe_sz ? lparam->stripe_sz/2: 128);
-
-		len += sprintf(page+len, "Row size:%3d\n",
-				lparam->row_size);
+		seq_putc(m, '\n');
 
+		seq_printf(m, "Span depth:%3d, ", lparam->span_depth);
+		seq_printf(m, "RAID level:%3d, ", lparam->level);
+		seq_printf(m, "Stripe size:%3d, ",
+			   lparam->stripe_sz ? lparam->stripe_sz/2: 128);
+		seq_printf(m, "Row size:%3d\n", lparam->row_size);
 
-		len += sprintf(page+len, "Read Policy: ");
-
+		seq_puts(m, "Read Policy: ");
 		switch(lparam->read_ahead) {
-
 		case NO_READ_AHEAD:
-			len += sprintf(page+len, "No read ahead, ");
+			seq_puts(m, "No read ahead, ");
 			break;
-
 		case READ_AHEAD:
-			len += sprintf(page+len, "Read ahead, ");
+			seq_puts(m, "Read ahead, ");
 			break;
-
 		case ADAP_READ_AHEAD:
-			len += sprintf(page+len, "Adaptive, ");
+			seq_puts(m, "Adaptive, ");
 			break;
 
 		}
 
-		len += sprintf(page+len, "Write Policy: ");
-
+		seq_puts(m, "Write Policy: ");
 		switch(lparam->write_mode) {
-
 		case WRMODE_WRITE_THRU:
-			len += sprintf(page+len, "Write thru, ");
+			seq_puts(m, "Write thru, ");
 			break;
-
 		case WRMODE_WRITE_BACK:
-			len += sprintf(page+len, "Write back, ");
+			seq_puts(m, "Write back, ");
 			break;
 		}
 
-		len += sprintf(page+len, "Cache Policy: ");
-
+		seq_puts(m, "Cache Policy: ");
 		switch(lparam->direct_io) {
-
 		case CACHED_IO:
-			len += sprintf(page+len, "Cached IO\n\n");
+			seq_puts(m, "Cached IO\n\n");
 			break;
-
 		case DIRECT_IO:
-			len += sprintf(page+len, "Direct IO\n\n");
+			seq_puts(m, "Direct IO\n\n");
 			break;
 		}
 	}
 
-	mega_free_inquiry(inquiry, dma_handle, pdev);
-
+free_pci:
 	pci_free_consistent(pdev, array_sz, disk_array,
 			disk_array_dma_handle);
-
+free_inquiry:
+	mega_free_inquiry(inquiry, dma_handle, pdev);
+free_pdev:
 	free_local_pdev(pdev);
+	return 0;
+}
+
+/**
+ * proc_show_rdrv_10()
+ * @m - Synthetic file construction data
+ * @v - File iterator
+ *
+ * Display real time information about the logical drives 0 through 9.
+ */
+static int
+proc_show_rdrv_10(struct seq_file *m, void *v)
+{
+	return proc_show_rdrv(m, m->private, 0, 9);
+}
 
-	return len;
+
+/**
+ * proc_show_rdrv_20()
+ * @m - Synthetic file construction data
+ * @v - File iterator
+ *
+ * Display real time information about the logical drives 0 through 9.
+ */
+static int
+proc_show_rdrv_20(struct seq_file *m, void *v)
+{
+	return proc_show_rdrv(m, m->private, 10, 19);
+}
+
+
+/**
+ * proc_show_rdrv_30()
+ * @m - Synthetic file construction data
+ * @v - File iterator
+ *
+ * Display real time information about the logical drives 0 through 9.
+ */
+static int
+proc_show_rdrv_30(struct seq_file *m, void *v)
+{
+	return proc_show_rdrv(m, m->private, 20, 29);
 }
+
+
+/**
+ * proc_show_rdrv_40()
+ * @m - Synthetic file construction data
+ * @v - File iterator
+ *
+ * Display real time information about the logical drives 0 through 9.
+ */
+static int
+proc_show_rdrv_40(struct seq_file *m, void *v)
+{
+	return proc_show_rdrv(m, m->private, 30, 39);
+}
+
+
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int mega_proc_open(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *e = PDE(inode);
+	adapter_t *adapter = e->parent->data;
+	int (*show)(struct seq_file *, void *) = e->data;
+
+	return single_open(file, show, adapter);
+}
+
+static const struct file_operations mega_proc_fops = {
+	.open		= mega_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+/*
+ * Table of proc files we need to create.
+ */
+struct mega_proc_file {
+	const char *name;
+	unsigned short ptr_offset;
+	int (*show) (struct seq_file *m, void *v);
+};
+
+static const struct mega_proc_file mega_proc_files[] = {
+	{ "config",	      offsetof(adapter_t, proc_read), proc_show_config },
+	{ "stat",	      offsetof(adapter_t, proc_stat), proc_show_stat },
+	{ "mailbox",	      offsetof(adapter_t, proc_mbox), proc_show_mbox },
+#if MEGA_HAVE_ENH_PROC
+	{ "rebuild-rate",     offsetof(adapter_t, proc_rr), proc_show_rebuild_rate },
+	{ "battery-status",   offsetof(adapter_t, proc_battery), proc_show_battery },
+	{ "diskdrives-ch0",   offsetof(adapter_t, proc_pdrvstat[0]), proc_show_pdrv_ch0 },
+	{ "diskdrives-ch1",   offsetof(adapter_t, proc_pdrvstat[1]), proc_show_pdrv_ch1 },
+	{ "diskdrives-ch2",   offsetof(adapter_t, proc_pdrvstat[2]), proc_show_pdrv_ch2 },
+	{ "diskdrives-ch3",   offsetof(adapter_t, proc_pdrvstat[3]), proc_show_pdrv_ch3 },
+	{ "raiddrives-0-9",   offsetof(adapter_t, proc_rdrvstat[0]), proc_show_rdrv_10 },
+	{ "raiddrives-10-19", offsetof(adapter_t, proc_rdrvstat[1]), proc_show_rdrv_20 },
+	{ "raiddrives-20-29", offsetof(adapter_t, proc_rdrvstat[2]), proc_show_rdrv_30 },
+	{ "raiddrives-30-39", offsetof(adapter_t, proc_rdrvstat[3]), proc_show_rdrv_40 },
+#endif
+	{ NULL }
+};
+
+/**
+ * mega_create_proc_entry()
+ * @index - index in soft state array
+ * @parent - parent node for this /proc entry
+ *
+ * Creates /proc entries for our controllers.
+ */
+static void
+mega_create_proc_entry(int index, struct proc_dir_entry *parent)
+{
+	const struct mega_proc_file *f;
+	adapter_t	*adapter = hba_soft_state[index];
+	struct proc_dir_entry	*dir, *de, **ppde;
+	u8		string[16];
+
+	sprintf(string, "hba%d", adapter->host->host_no);
+
+	dir = adapter->controller_proc_dir_entry = proc_mkdir(string, parent);
+	if(!dir) {
+		printk(KERN_WARNING "\nmegaraid: proc_mkdir failed\n");
+		return;
+	}
+	dir->data = adapter;
+
+	for (f = mega_proc_files; f->name; f++) {
+		de = proc_create_data(f->name, S_IRUSR, dir, &mega_proc_fops,
+				      f->show);
+		if (!de) {
+			printk(KERN_WARNING "\nmegaraid: proc_create failed\n");
+			return;
+		}
+
+		ppde = (void *)adapter + f->ptr_offset;
+		*ppde = de;
+	}
+}
+
 #else
 static inline void mega_create_proc_entry(int index, struct proc_dir_entry *parent)
 {
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 4fb2adf..4d0ce4e 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -987,24 +987,7 @@ static int mega_init_scb (adapter_t *);
 static int mega_is_bios_enabled (adapter_t *);
 
 #ifdef CONFIG_PROC_FS
-static int mega_print_inquiry(char *, char *);
 static void mega_create_proc_entry(int, struct proc_dir_entry *);
-static int proc_read_config(char *, char **, off_t, int, int *, void *);
-static int proc_read_stat(char *, char **, off_t, int, int *, void *);
-static int proc_read_mbox(char *, char **, off_t, int, int *, void *);
-static int proc_rebuild_rate(char *, char **, off_t, int, int *, void *);
-static int proc_battery(char *, char **, off_t, int, int *, void *);
-static int proc_pdrv_ch0(char *, char **, off_t, int, int *, void *);
-static int proc_pdrv_ch1(char *, char **, off_t, int, int *, void *);
-static int proc_pdrv_ch2(char *, char **, off_t, int, int *, void *);
-static int proc_pdrv_ch3(char *, char **, off_t, int, int *, void *);
-static int proc_pdrv(adapter_t *, char *, int);
-static int proc_rdrv_10(char *, char **, off_t, int, int *, void *);
-static int proc_rdrv_20(char *, char **, off_t, int, int *, void *);
-static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
-static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
-static int proc_rdrv(adapter_t *, char *, int, int);
-
 static int mega_adapinq(adapter_t *, dma_addr_t);
 static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
 #endif
