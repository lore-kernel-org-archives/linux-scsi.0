From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] mpt fusion: convert to seq_file
Date: Wed, 25 Nov 2009 10:09:41 +0300
Message-ID: <20091125070941.GA3459@x200.malnet.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49752 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZKYHJl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2009 02:09:41 -0500
Received: by ewy19 with SMTP id 19so90239ewy.21
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2009 23:09:45 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@suse.de
Cc: kadesai@lsi.com, linux-scsi@vger.kernel.org

Convert everything except ->proc_info() stuff, it is done withing separate
->proc_info path series.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/message/fusion/mptbase.c |  236 +++++++++++++++++++--------------------
 drivers/message/fusion/mptbase.h |   25 ----
 2 files changed, 119 insertions(+), 142 deletions(-)

--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -50,6 +50,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pci.h>
@@ -198,12 +199,9 @@ static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_valu
 static int	mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init);
 
 #ifdef CONFIG_PROC_FS
-static int	procmpt_summary_read(char *buf, char **start, off_t offset,
-				int request, int *eof, void *data);
-static int	procmpt_version_read(char *buf, char **start, off_t offset,
-				int request, int *eof, void *data);
-static int	procmpt_iocinfo_read(char *buf, char **start, off_t offset,
-				int request, int *eof, void *data);
+static const struct file_operations mpt_summary_proc_fops;
+static const struct file_operations mpt_version_proc_fops;
+static const struct file_operations mpt_iocinfo_proc_fops;
 #endif
 static void	mpt_get_fw_exp_ver(char *buf, MPT_ADAPTER *ioc);
 
@@ -1718,7 +1716,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	u8		 pcixcmd;
 	static int	 mpt_ids = 0;
 #ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *dent, *ent;
+	struct proc_dir_entry *dent;
 #endif
 
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
@@ -1971,16 +1969,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	dent = proc_mkdir(ioc->name, mpt_proc_root_dir);
 	if (dent) {
-		ent = create_proc_entry("info", S_IFREG|S_IRUGO, dent);
-		if (ent) {
-			ent->read_proc = procmpt_iocinfo_read;
-			ent->data = ioc;
-		}
-		ent = create_proc_entry("summary", S_IFREG|S_IRUGO, dent);
-		if (ent) {
-			ent->read_proc = procmpt_summary_read;
-			ent->data = ioc;
-		}
+		proc_create_data("info", S_IRUGO, dent, &mpt_iocinfo_proc_fops, ioc);
+		proc_create_data("summary", S_IRUGO, dent, &mpt_summary_proc_fops, ioc);
 	}
 #endif
 
@@ -6529,20 +6519,12 @@ mpt_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 static int
 procmpt_create(void)
 {
-	struct proc_dir_entry	*ent;
-
 	mpt_proc_root_dir = proc_mkdir(MPT_PROCFS_MPTBASEDIR, NULL);
 	if (mpt_proc_root_dir == NULL)
 		return -ENOTDIR;
 
-	ent = create_proc_entry("summary", S_IFREG|S_IRUGO, mpt_proc_root_dir);
-	if (ent)
-		ent->read_proc = procmpt_summary_read;
-
-	ent = create_proc_entry("version", S_IFREG|S_IRUGO, mpt_proc_root_dir);
-	if (ent)
-		ent->read_proc = procmpt_version_read;
-
+	proc_create("summary", S_IRUGO, mpt_proc_root_dir, &mpt_summary_proc_fops);
+	proc_create("version", S_IRUGO, mpt_proc_root_dir, &mpt_version_proc_fops);
 	return 0;
 }
 
@@ -6562,70 +6544,46 @@ procmpt_destroy(void)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	procmpt_summary_read - Handle read request of a summary file
- *	@buf: Pointer to area to write information
- *	@start: Pointer to start pointer
- *	@offset: Offset to start writing
- *	@request: Amount of read data requested
- *	@eof: Pointer to EOF integer
- *	@data: Pointer
- *
  *	Handles read request from /proc/mpt/summary or /proc/mpt/iocN/summary.
- *	Returns number of characters written to process performing the read.
  */
-static int
-procmpt_summary_read(char *buf, char **start, off_t offset, int request, int *eof, void *data)
-{
-	MPT_ADAPTER *ioc;
-	char *out = buf;
-	int len;
+static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int showlan);
 
-	if (data) {
-		int more = 0;
-
-		ioc = data;
-		mpt_print_ioc_summary(ioc, out, &more, 0, 1);
+static int mpt_summary_proc_show(struct seq_file *m, void *v)
+{
+	MPT_ADAPTER *ioc = m->private;
 
-		out += more;
+	if (ioc) {
+		seq_mpt_print_ioc_summary(ioc, m, 1);
 	} else {
 		list_for_each_entry(ioc, &ioc_list, list) {
-			int	more = 0;
-
-			mpt_print_ioc_summary(ioc, out, &more, 0, 1);
-
-			out += more;
-			if ((out-buf) >= request)
-				break;
+			seq_mpt_print_ioc_summary(ioc, m, 1);
 		}
 	}
 
-	len = out - buf;
+	return 0;
+}
 
-	MPT_PROC_READ_RETURN(buf,start,offset,request,eof,len);
+static int mpt_summary_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mpt_summary_proc_show, PDE(inode)->data);
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	procmpt_version_read - Handle read request from /proc/mpt/version.
- *	@buf: Pointer to area to write information
- *	@start: Pointer to start pointer
- *	@offset: Offset to start writing
- *	@request: Amount of read data requested
- *	@eof: Pointer to EOF integer
- *	@data: Pointer
- *
- *	Returns number of characters written to process performing the read.
- */
-static int
-procmpt_version_read(char *buf, char **start, off_t offset, int request, int *eof, void *data)
+static const struct file_operations mpt_summary_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mpt_summary_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int mpt_version_proc_show(struct seq_file *m, void *v)
 {
 	u8	 cb_idx;
 	int	 scsi, fc, sas, lan, ctl, targ, dmp;
 	char	*drvname;
-	int	 len;
 
-	len = sprintf(buf, "%s-%s\n", "mptlinux", MPT_LINUX_VERSION_COMMON);
-	len += sprintf(buf+len, "  Fusion MPT base driver\n");
+	seq_printf(m, "%s-%s\n", "mptlinux", MPT_LINUX_VERSION_COMMON);
+	seq_printf(m, "  Fusion MPT base driver\n");
 
 	scsi = fc = sas = lan = ctl = targ = dmp = 0;
 	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
@@ -6653,98 +6611,97 @@ procmpt_version_read(char *buf, char **start, off_t offset, int request, int *eo
 			}
 
 			if (drvname)
-				len += sprintf(buf+len, "  Fusion MPT %s driver\n", drvname);
+				seq_printf(m, "  Fusion MPT %s driver\n", drvname);
 		}
 	}
 
-	MPT_PROC_READ_RETURN(buf,start,offset,request,eof,len);
+	return 0;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	procmpt_iocinfo_read - Handle read request from /proc/mpt/iocN/info.
- *	@buf: Pointer to area to write information
- *	@start: Pointer to start pointer
- *	@offset: Offset to start writing
- *	@request: Amount of read data requested
- *	@eof: Pointer to EOF integer
- *	@data: Pointer
- *
- *	Returns number of characters written to process performing the read.
- */
-static int
-procmpt_iocinfo_read(char *buf, char **start, off_t offset, int request, int *eof, void *data)
+static int mpt_version_proc_open(struct inode *inode, struct file *file)
 {
-	MPT_ADAPTER	*ioc = data;
-	int		 len;
+	return single_open(file, mpt_version_proc_show, NULL);
+}
+
+static const struct file_operations mpt_version_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mpt_version_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int mpt_iocinfo_proc_show(struct seq_file *m, void *v)
+{
+	MPT_ADAPTER	*ioc = m->private;
 	char		 expVer[32];
 	int		 sz;
 	int		 p;
 
 	mpt_get_fw_exp_ver(expVer, ioc);
 
-	len = sprintf(buf, "%s:", ioc->name);
+	seq_printf(m, "%s:", ioc->name);
 	if (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_FW_DOWNLOAD_BOOT)
-		len += sprintf(buf+len, "  (f/w download boot flag set)");
+		seq_printf(m, "  (f/w download boot flag set)");
 //	if (ioc->facts.IOCExceptions & MPI_IOCFACTS_EXCEPT_CONFIG_CHECKSUM_FAIL)
-//		len += sprintf(buf+len, "  CONFIG_CHECKSUM_FAIL!");
+//		seq_printf(m, "  CONFIG_CHECKSUM_FAIL!");
 
-	len += sprintf(buf+len, "\n  ProductID = 0x%04x (%s)\n",
+	seq_printf(m, "\n  ProductID = 0x%04x (%s)\n",
 			ioc->facts.ProductID,
 			ioc->prod_name);
-	len += sprintf(buf+len, "  FWVersion = 0x%08x%s", ioc->facts.FWVersion.Word, expVer);
+	seq_printf(m, "  FWVersion = 0x%08x%s", ioc->facts.FWVersion.Word, expVer);
 	if (ioc->facts.FWImageSize)
-		len += sprintf(buf+len, " (fw_size=%d)", ioc->facts.FWImageSize);
-	len += sprintf(buf+len, "\n  MsgVersion = 0x%04x\n", ioc->facts.MsgVersion);
-	len += sprintf(buf+len, "  FirstWhoInit = 0x%02x\n", ioc->FirstWhoInit);
-	len += sprintf(buf+len, "  EventState = 0x%02x\n", ioc->facts.EventState);
+		seq_printf(m, " (fw_size=%d)", ioc->facts.FWImageSize);
+	seq_printf(m, "\n  MsgVersion = 0x%04x\n", ioc->facts.MsgVersion);
+	seq_printf(m, "  FirstWhoInit = 0x%02x\n", ioc->FirstWhoInit);
+	seq_printf(m, "  EventState = 0x%02x\n", ioc->facts.EventState);
 
-	len += sprintf(buf+len, "  CurrentHostMfaHighAddr = 0x%08x\n",
+	seq_printf(m, "  CurrentHostMfaHighAddr = 0x%08x\n",
 			ioc->facts.CurrentHostMfaHighAddr);
-	len += sprintf(buf+len, "  CurrentSenseBufferHighAddr = 0x%08x\n",
+	seq_printf(m, "  CurrentSenseBufferHighAddr = 0x%08x\n",
 			ioc->facts.CurrentSenseBufferHighAddr);
 
-	len += sprintf(buf+len, "  MaxChainDepth = 0x%02x frames\n", ioc->facts.MaxChainDepth);
-	len += sprintf(buf+len, "  MinBlockSize = 0x%02x bytes\n", 4*ioc->facts.BlockSize);
+	seq_printf(m, "  MaxChainDepth = 0x%02x frames\n", ioc->facts.MaxChainDepth);
+	seq_printf(m, "  MinBlockSize = 0x%02x bytes\n", 4*ioc->facts.BlockSize);
 
-	len += sprintf(buf+len, "  RequestFrames @ 0x%p (Dma @ 0x%p)\n",
+	seq_printf(m, "  RequestFrames @ 0x%p (Dma @ 0x%p)\n",
 					(void *)ioc->req_frames, (void *)(ulong)ioc->req_frames_dma);
 	/*
 	 *  Rounding UP to nearest 4-kB boundary here...
 	 */
 	sz = (ioc->req_sz * ioc->req_depth) + 128;
 	sz = ((sz + 0x1000UL - 1UL) / 0x1000) * 0x1000;
-	len += sprintf(buf+len, "    {CurReqSz=%d} x {CurReqDepth=%d} = %d bytes ^= 0x%x\n",
+	seq_printf(m, "    {CurReqSz=%d} x {CurReqDepth=%d} = %d bytes ^= 0x%x\n",
 					ioc->req_sz, ioc->req_depth, ioc->req_sz*ioc->req_depth, sz);
-	len += sprintf(buf+len, "    {MaxReqSz=%d}   {MaxReqDepth=%d}\n",
+	seq_printf(m, "    {MaxReqSz=%d}   {MaxReqDepth=%d}\n",
 					4*ioc->facts.RequestFrameSize,
 					ioc->facts.GlobalCredits);
 
-	len += sprintf(buf+len, "  Frames   @ 0x%p (Dma @ 0x%p)\n",
+	seq_printf(m, "  Frames   @ 0x%p (Dma @ 0x%p)\n",
 					(void *)ioc->alloc, (void *)(ulong)ioc->alloc_dma);
 	sz = (ioc->reply_sz * ioc->reply_depth) + 128;
-	len += sprintf(buf+len, "    {CurRepSz=%d} x {CurRepDepth=%d} = %d bytes ^= 0x%x\n",
+	seq_printf(m, "    {CurRepSz=%d} x {CurRepDepth=%d} = %d bytes ^= 0x%x\n",
 					ioc->reply_sz, ioc->reply_depth, ioc->reply_sz*ioc->reply_depth, sz);
-	len += sprintf(buf+len, "    {MaxRepSz=%d}   {MaxRepDepth=%d}\n",
+	seq_printf(m, "    {MaxRepSz=%d}   {MaxRepDepth=%d}\n",
 					ioc->facts.CurReplyFrameSize,
 					ioc->facts.ReplyQueueDepth);
 
-	len += sprintf(buf+len, "  MaxDevices = %d\n",
+	seq_printf(m, "  MaxDevices = %d\n",
 			(ioc->facts.MaxDevices==0) ? 255 : ioc->facts.MaxDevices);
-	len += sprintf(buf+len, "  MaxBuses = %d\n", ioc->facts.MaxBuses);
+	seq_printf(m, "  MaxBuses = %d\n", ioc->facts.MaxBuses);
 
 	/* per-port info */
 	for (p=0; p < ioc->facts.NumberOfPorts; p++) {
-		len += sprintf(buf+len, "  PortNumber = %d (of %d)\n",
+		seq_printf(m, "  PortNumber = %d (of %d)\n",
 				p+1,
 				ioc->facts.NumberOfPorts);
 		if (ioc->bus_type == FC) {
 			if (ioc->pfacts[p].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) {
 				u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-				len += sprintf(buf+len, "    LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
+				seq_printf(m, "    LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
 						a[5], a[4], a[3], a[2], a[1], a[0]);
 			}
-			len += sprintf(buf+len, "    WWN = %08X%08X:%08X%08X\n",
+			seq_printf(m, "    WWN = %08X%08X:%08X%08X\n",
 					ioc->fc_port_page0[p].WWNN.High,
 					ioc->fc_port_page0[p].WWNN.Low,
 					ioc->fc_port_page0[p].WWPN.High,
@@ -6752,9 +6709,21 @@ procmpt_iocinfo_read(char *buf, char **start, off_t offset, int request, int *eo
 		}
 	}
 
-	MPT_PROC_READ_RETURN(buf,start,offset,request,eof,len);
+	return 0;
+}
+
+static int mpt_iocinfo_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mpt_iocinfo_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations mpt_iocinfo_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mpt_iocinfo_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif		/* CONFIG_PROC_FS } */
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -6820,6 +6789,39 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
 
 	*size = y;
 }
+
+static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int showlan)
+{
+	char expVer[32];
+
+	mpt_get_fw_exp_ver(expVer, ioc);
+
+	/*
+	 *  Shorter summary of attached ioc's...
+	 */
+	seq_printf(m, "%s: %s, %s%08xh%s, Ports=%d, MaxQ=%d",
+			ioc->name,
+			ioc->prod_name,
+			MPT_FW_REV_MAGIC_ID_STRING,	/* "FwRev=" or somesuch */
+			ioc->facts.FWVersion.Word,
+			expVer,
+			ioc->facts.NumberOfPorts,
+			ioc->req_depth);
+
+	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
+		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
+		seq_printf(m, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
+			a[5], a[4], a[3], a[2], a[1], a[0]);
+	}
+
+	seq_printf(m, ", IRQ=%d", ioc->pci_irq);
+
+	if (!ioc->active)
+		seq_printf(m, " (disabled)");
+
+	seq_putc(m, '\n');
+}
+
 /**
  *	mpt_set_taskmgmt_in_progress_flag - set flags associated with task management
  *	@ioc: Pointer to MPT_ADAPTER structure
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -418,31 +418,6 @@ typedef struct _VirtDevice {
 #define MPT_TARGET_FLAGS_LED_ON		0x80
 
 /*
- *	/proc/mpt interface
- */
-typedef struct {
-	const char	*name;
-	mode_t		 mode;
-	int		 pad;
-	read_proc_t	*read_proc;
-	write_proc_t	*write_proc;
-} mpt_proc_entry_t;
-
-#define MPT_PROC_READ_RETURN(buf,start,offset,request,eof,len) \
-do { \
-	len -= offset;			\
-	if (len < request) {		\
-		*eof = 1;		\
-		if (len <= 0)		\
-			return 0;	\
-	} else				\
-		len = request;		\
-	*start = buf + offset;		\
-	return len;			\
-} while (0)
-
-
-/*
  *	IOCTL structure and associated defines
  */
 
