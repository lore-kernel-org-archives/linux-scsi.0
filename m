From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/15] lpfc 8.2.8 : Add kernel-doc function headers - part 3
Date: Sun, 24 Aug 2008 21:49:25 -0400
Message-ID: <1219628965.7890.25.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52436 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYHYBtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:49:23 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1nMgh019928
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:49:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add kernel-doc function headers - part 3


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_debugfs.c |  327 ++++++++++++++++++++++++++++++--
 lpfc_init.c    |  575 ++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 763 insertions(+), 139 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2008-04-10 17:07:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2008-08-24 18:49:32.000000000 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2007 Emulex.  All rights reserved.                *
+ * Copyright (C) 2007-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -47,13 +47,14 @@
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_LPFC_DEBUG_FS
-/* debugfs interface
+/**
+ * debugfs interface
  *
  * To access this interface the user should:
  * # mkdir /debug
  * # mount -t debugfs none /debug
  *
- * The lpfc debugfs directory hierachy is:
+ * The lpfc debugfs directory hierarchy is:
  * lpfc/lpfcX/vportY
  * where X is the lpfc hba unique_id
  * where Y is the vport VPI on that hba
@@ -62,14 +63,21 @@
  * discovery_trace
  * This is an ACSII readable file that contains a trace of the last
  * lpfc_debugfs_max_disc_trc events that happened on a specific vport.
- * See lpfc_debugfs.h for different categories of
- * discovery events. To enable the discovery trace, the following
- * module parameters must be set:
+ * See lpfc_debugfs.h for different categories of  discovery events.
+ * To enable the discovery trace, the following module parameters must be set:
  * lpfc_debugfs_enable=1         Turns on lpfc debugfs filesystem support
  * lpfc_debugfs_max_disc_trc=X   Where X is the event trace depth for
  *                               EACH vport. X MUST also be a power of 2.
  * lpfc_debugfs_mask_disc_trc=Y  Where Y is an event mask as defined in
  *                               lpfc_debugfs.h .
+ *
+ * slow_ring_trace
+ * This is an ACSII readable file that contains a trace of the last
+ * lpfc_debugfs_max_slow_ring_trc events that happened on a specific HBA.
+ * To enable the slow ring trace, the following module parameters must be set:
+ * lpfc_debugfs_enable=1         Turns on lpfc debugfs filesystem support
+ * lpfc_debugfs_max_slow_ring_trc=X   Where X is the event trace depth for
+ *                               the HBA. X MUST also be a power of 2.
  */
 static int lpfc_debugfs_enable = 1;
 module_param(lpfc_debugfs_enable, int, 0);
@@ -118,6 +126,25 @@ struct lpfc_debug {
 static atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 static unsigned long lpfc_debugfs_start_time = 0L;
 
+/**
+ * lpfc_debugfs_disc_trc_data - Dump discovery logging to a buffer.
+ * @vport: The vport to gather the log info from.
+ * @buf: The buffer to dump log into.
+ * @size: The maximum amount of data to process.
+ *
+ * Description:
+ * This routine gathers the lpfc discovery debugfs data from the @vport and
+ * dumps it to @buf up to @size number of bytes. It will start at the next entry
+ * in the log and process the log until the end of the buffer. Then it will
+ * gather from the beginning of the log and process until the current entry.
+ *
+ * Notes:
+ * Discovery logging will be disabled while while this routine dumps the log.
+ *
+ * Return Value:
+ * This routine returns the amount of bytes that were dumped into @buf and will
+ * not exceed @size.
+ **/
 static int
 lpfc_debugfs_disc_trc_data(struct lpfc_vport *vport, char *buf, int size)
 {
@@ -126,7 +153,6 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 	struct lpfc_debugfs_trc *dtp;
 	char buffer[LPFC_DEBUG_TRC_ENTRY_SIZE];
 
-
 	enable = lpfc_debugfs_enable;
 	lpfc_debugfs_enable = 0;
 
@@ -160,6 +186,25 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 	return len;
 }
 
+/**
+ * lpfc_debugfs_slow_ring_trc_data - Dump slow ring logging to a buffer.
+ * @phba: The HBA to gather the log info from.
+ * @buf: The buffer to dump log into.
+ * @size: The maximum amount of data to process.
+ *
+ * Description:
+ * This routine gathers the lpfc slow ring debugfs data from the @phba and
+ * dumps it to @buf up to @size number of bytes. It will start at the next entry
+ * in the log and process the log until the end of the buffer. Then it will
+ * gather from the beginning of the log and process until the current entry.
+ *
+ * Notes:
+ * Slow ring logging will be disabled while while this routine dumps the log.
+ *
+ * Return Value:
+ * This routine returns the amount of bytes that were dumped into @buf and will
+ * not exceed @size.
+ **/
 static int
 lpfc_debugfs_slow_ring_trc_data(struct lpfc_hba *phba, char *buf, int size)
 {
@@ -204,6 +249,25 @@ lpfc_debugfs_slow_ring_trc_data(struct l
 
 static int lpfc_debugfs_last_hbq = -1;
 
+/**
+ * lpfc_debugfs_hbqinfo_data - Dump host buffer queue info to a buffer.
+ * @phba: The HBA to gather host buffer info from.
+ * @buf: The buffer to dump log into.
+ * @size: The maximum amount of data to process.
+ *
+ * Description:
+ * This routine dumps the host buffer queue info from the @phba to @buf up to
+ * @size number of bytes. A header that describes the current hbq state will be
+ * dumped to @buf first and then info on each hbq entry will be dumped to @buf
+ * until @size bytes have been dumped or all the hbq info has been dumped.
+ *
+ * Notes:
+ * This routine will rotate through each configured HBQ each time called.
+ *
+ * Return Value:
+ * This routine returns the amount of bytes that were dumped into @buf and will
+ * not exceed @size.
+ **/
 static int
 lpfc_debugfs_hbqinfo_data(struct lpfc_hba *phba, char *buf, int size)
 {
@@ -304,6 +368,24 @@ skipit:
 
 static int lpfc_debugfs_last_hba_slim_off;
 
+/**
+ * lpfc_debugfs_dumpHBASlim_data - Dump HBA SLIM info to a buffer.
+ * @phba: The HBA to gather SLIM info from.
+ * @buf: The buffer to dump log into.
+ * @size: The maximum amount of data to process.
+ *
+ * Description:
+ * This routine dumps the current contents of HBA SLIM for the HBA associated
+ * with @phba to @buf up to @size bytes of data. This is the raw HBA SLIM data.
+ *
+ * Notes:
+ * This routine will only dump up to 1024 bytes of data each time called and
+ * should be called multiple times to dump the entire HBA SLIM.
+ *
+ * Return Value:
+ * This routine returns the amount of bytes that were dumped into @buf and will
+ * not exceed @size.
+ **/
 static int
 lpfc_debugfs_dumpHBASlim_data(struct lpfc_hba *phba, char *buf, int size)
 {
@@ -343,6 +425,21 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 	return len;
 }
 
+/**
+ * lpfc_debugfs_dumpHostSlim_data - Dump host SLIM info to a buffer.
+ * @phba: The HBA to gather Host SLIM info from.
+ * @buf: The buffer to dump log into.
+ * @size: The maximum amount of data to process.
+ *
+ * Description:
+ * This routine dumps the current contents of host SLIM for the host associated
+ * with @phba to @buf up to @size bytes of data. The dump will contain the
+ * Mailbox, PCB, Rings, and Registers that are located in host memory.
+ *
+ * Return Value:
+ * This routine returns the amount of bytes that were dumped into @buf and will
+ * not exceed @size.
+ **/
 static int
 lpfc_debugfs_dumpHostSlim_data(struct lpfc_hba *phba, char *buf, int size)
 {
@@ -431,6 +528,21 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 	return len;
 }
 
+/**
+ * lpfc_debugfs_nodelist_data - Dump target node list to a buffer.
+ * @vport: The vport to gather target node info from.
+ * @buf: The buffer to dump log into.
+ * @size: The maximum amount of data to process.
+ *
+ * Description:
+ * This routine dumps the current target node list associated with @vport to
+ * @buf up to @size bytes of data. Each node entry in the dump will contain a
+ * node state, DID, WWPN, WWNN, RPI, flags, type, and other useful fields.
+ *
+ * Return Value:
+ * This routine returns the amount of bytes that were dumped into @buf and will
+ * not exceed @size.
+ **/
 static int
 lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 {
@@ -514,7 +626,22 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 }
 #endif
 
-
+/**
+ * lpfc_debugfs_disc_trc - Store discovery trace log.
+ * @vport: The vport to associate this trace string with for retrieval.
+ * @mask: Log entry classification.
+ * @fmt: Format string to be displayed when dumping the log.
+ * @data1: 1st data parameter to be applied to @fmt.
+ * @data2: 2nd data parameter to be applied to @fmt.
+ * @data3: 3rd data parameter to be applied to @fmt.
+ *
+ * Description:
+ * This routine is used by the driver code to add a debugfs log entry to the
+ * discovery trace buffer associated with @vport. Only entries with a @mask that
+ * match the current debugfs discovery mask will be saved. Entries that do not
+ * match will be thrown away. @fmt, @data1, @data2, and @data3 are used like
+ * printf when displaying the log.
+ **/
 inline void
 lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 	uint32_t data1, uint32_t data2, uint32_t data3)
@@ -543,6 +670,19 @@ lpfc_debugfs_disc_trc(struct lpfc_vport 
 	return;
 }
 
+/**
+ * lpfc_debugfs_slow_ring_trc - Store slow ring trace log.
+ * @phba: The phba to associate this trace string with for retrieval.
+ * @fmt: Format string to be displayed when dumping the log.
+ * @data1: 1st data parameter to be applied to @fmt.
+ * @data2: 2nd data parameter to be applied to @fmt.
+ * @data3: 3rd data parameter to be applied to @fmt.
+ *
+ * Description:
+ * This routine is used by the driver code to add a debugfs log entry to the
+ * discovery trace buffer associated with @vport. @fmt, @data1, @data2, and
+ * @data3 are used like printf when displaying the log.
+ **/
 inline void
 lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 	uint32_t data1, uint32_t data2, uint32_t data3)
@@ -569,6 +709,21 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_h
 }
 
 #ifdef CONFIG_LPFC_DEBUG_FS
+/**
+ * lpfc_debugfs_disc_trc_open - Open the discovery trace log.
+ * @inode: The inode pointer that contains a vport pointer.
+ * @file: The file pointer to attach the log output.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs open file operation. It gets
+ * the vport from the i_private field in @inode, allocates the necessary buffer
+ * for the log, fills the buffer from the in-memory log for this vport, and then
+ * returns a pointer to that log in the private_data field in @file.
+ *
+ * Returns:
+ * This function returns zero if successful. On error it will return an negative
+ * error value.
+ **/
 static int
 lpfc_debugfs_disc_trc_open(struct inode *inode, struct file *file)
 {
@@ -586,7 +741,7 @@ lpfc_debugfs_disc_trc_open(struct inode 
 	if (!debug)
 		goto out;
 
-	/* Round to page boundry */
+	/* Round to page boundary */
 	size =  (lpfc_debugfs_max_disc_trc * LPFC_DEBUG_TRC_ENTRY_SIZE);
 	size = PAGE_ALIGN(size);
 
@@ -604,6 +759,21 @@ out:
 	return rc;
 }
 
+/**
+ * lpfc_debugfs_slow_ring_trc_open - Open the Slow Ring trace log.
+ * @inode: The inode pointer that contains a vport pointer.
+ * @file: The file pointer to attach the log output.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs open file operation. It gets
+ * the vport from the i_private field in @inode, allocates the necessary buffer
+ * for the log, fills the buffer from the in-memory log for this vport, and then
+ * returns a pointer to that log in the private_data field in @file.
+ *
+ * Returns:
+ * This function returns zero if successful. On error it will return an negative
+ * error value.
+ **/
 static int
 lpfc_debugfs_slow_ring_trc_open(struct inode *inode, struct file *file)
 {
@@ -621,7 +791,7 @@ lpfc_debugfs_slow_ring_trc_open(struct i
 	if (!debug)
 		goto out;
 
-	/* Round to page boundry */
+	/* Round to page boundary */
 	size =  (lpfc_debugfs_max_slow_ring_trc * LPFC_DEBUG_TRC_ENTRY_SIZE);
 	size = PAGE_ALIGN(size);
 
@@ -639,6 +809,21 @@ out:
 	return rc;
 }
 
+/**
+ * lpfc_debugfs_hbqinfo_open - Open the hbqinfo debugfs buffer.
+ * @inode: The inode pointer that contains a vport pointer.
+ * @file: The file pointer to attach the log output.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs open file operation. It gets
+ * the vport from the i_private field in @inode, allocates the necessary buffer
+ * for the log, fills the buffer from the in-memory log for this vport, and then
+ * returns a pointer to that log in the private_data field in @file.
+ *
+ * Returns:
+ * This function returns zero if successful. On error it will return an negative
+ * error value.
+ **/
 static int
 lpfc_debugfs_hbqinfo_open(struct inode *inode, struct file *file)
 {
@@ -650,7 +835,7 @@ lpfc_debugfs_hbqinfo_open(struct inode *
 	if (!debug)
 		goto out;
 
-	/* Round to page boundry */
+	/* Round to page boundary */
 	debug->buffer = kmalloc(LPFC_HBQINFO_SIZE, GFP_KERNEL);
 	if (!debug->buffer) {
 		kfree(debug);
@@ -666,6 +851,21 @@ out:
 	return rc;
 }
 
+/**
+ * lpfc_debugfs_dumpHBASlim_open - Open the Dump HBA SLIM debugfs buffer.
+ * @inode: The inode pointer that contains a vport pointer.
+ * @file: The file pointer to attach the log output.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs open file operation. It gets
+ * the vport from the i_private field in @inode, allocates the necessary buffer
+ * for the log, fills the buffer from the in-memory log for this vport, and then
+ * returns a pointer to that log in the private_data field in @file.
+ *
+ * Returns:
+ * This function returns zero if successful. On error it will return an negative
+ * error value.
+ **/
 static int
 lpfc_debugfs_dumpHBASlim_open(struct inode *inode, struct file *file)
 {
@@ -677,7 +877,7 @@ lpfc_debugfs_dumpHBASlim_open(struct ino
 	if (!debug)
 		goto out;
 
-	/* Round to page boundry */
+	/* Round to page boundary */
 	debug->buffer = kmalloc(LPFC_DUMPHBASLIM_SIZE, GFP_KERNEL);
 	if (!debug->buffer) {
 		kfree(debug);
@@ -693,6 +893,21 @@ out:
 	return rc;
 }
 
+/**
+ * lpfc_debugfs_dumpHostSlim_open - Open the Dump Host SLIM debugfs buffer.
+ * @inode: The inode pointer that contains a vport pointer.
+ * @file: The file pointer to attach the log output.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs open file operation. It gets
+ * the vport from the i_private field in @inode, allocates the necessary buffer
+ * for the log, fills the buffer from the in-memory log for this vport, and then
+ * returns a pointer to that log in the private_data field in @file.
+ *
+ * Returns:
+ * This function returns zero if successful. On error it will return an negative
+ * error value.
+ **/
 static int
 lpfc_debugfs_dumpHostSlim_open(struct inode *inode, struct file *file)
 {
@@ -704,7 +919,7 @@ lpfc_debugfs_dumpHostSlim_open(struct in
 	if (!debug)
 		goto out;
 
-	/* Round to page boundry */
+	/* Round to page boundary */
 	debug->buffer = kmalloc(LPFC_DUMPHOSTSLIM_SIZE, GFP_KERNEL);
 	if (!debug->buffer) {
 		kfree(debug);
@@ -720,6 +935,21 @@ out:
 	return rc;
 }
 
+/**
+ * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file.
+ * @inode: The inode pointer that contains a vport pointer.
+ * @file: The file pointer to attach the log output.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs open file operation. It gets
+ * the vport from the i_private field in @inode, allocates the necessary buffer
+ * for the log, fills the buffer from the in-memory log for this vport, and then
+ * returns a pointer to that log in the private_data field in @file.
+ *
+ * Returns:
+ * This function returns zero if successful. On error it will return an negative
+ * error value.
+ **/
 static int
 lpfc_debugfs_nodelist_open(struct inode *inode, struct file *file)
 {
@@ -731,7 +961,7 @@ lpfc_debugfs_nodelist_open(struct inode 
 	if (!debug)
 		goto out;
 
-	/* Round to page boundry */
+	/* Round to page boundary */
 	debug->buffer = kmalloc(LPFC_NODELIST_SIZE, GFP_KERNEL);
 	if (!debug->buffer) {
 		kfree(debug);
@@ -747,6 +977,23 @@ out:
 	return rc;
 }
 
+/**
+ * lpfc_debugfs_lseek - Seek through a debugfs file.
+ * @file: The file pointer to seek through.
+ * @off: The offset to seek to or the amount to seek by.
+ * @whence: Indicates how to seek.
+ *
+ * Description:
+ * This routine is the entry point for the debugfs lseek file operation. The
+ * @whence parameter indicates whether @off is the offset to directly seek to,
+ * or if it is a value to seek forward or reverse by. This function figures out
+ * what the new offset of the debugfs file will be and assigns that value to the
+ * f_pos field of @file.
+ *
+ * Returns:
+ * This function returns the new offset if successful and returns a negative
+ * error if unable to process the seek.
+ **/
 static loff_t
 lpfc_debugfs_lseek(struct file *file, loff_t off, int whence)
 {
@@ -768,6 +1015,22 @@ lpfc_debugfs_lseek(struct file *file, lo
 	return (pos < 0 || pos > debug->len) ? -EINVAL : (file->f_pos = pos);
 }
 
+/**
+ * lpfc_debugfs_read - Read a debugfs file.
+ * @file: The file pointer to read from.
+ * @buf: The buffer to copy the data to.
+ * @nbytes: The number of bytes to read.
+ * @ppos: The position in the file to start reading from.
+ *
+ * Description:
+ * This routine reads data from from the buffer indicated in the private_data
+ * field of @file. It will start reading at @ppos and copy up to @nbytes of
+ * data to @buf.
+ *
+ * Returns:
+ * This function returns the amount of data that was read (this could be less
+ * than @nbytes if the end of the file was reached) or a negative error value.
+ **/
 static ssize_t
 lpfc_debugfs_read(struct file *file, char __user *buf,
 		  size_t nbytes, loff_t *ppos)
@@ -777,6 +1040,18 @@ lpfc_debugfs_read(struct file *file, cha
 				       debug->len);
 }
 
+/**
+ * lpfc_debugfs_release - Release the buffer used to store debugfs file data.
+ * @inode: The inode pointer that contains a vport pointer. (unused)
+ * @file: The file pointer that contains the buffer to release.
+ *
+ * Description:
+ * This routine frees the buffer that was allocated when the debugfs file was
+ * opened.
+ *
+ * Returns:
+ * This function returns zero.
+ **/
 static int
 lpfc_debugfs_release(struct inode *inode, struct file *file)
 {
@@ -846,6 +1121,16 @@ static struct dentry *lpfc_debugfs_root 
 static atomic_t lpfc_debugfs_hba_count;
 #endif
 
+/**
+ * lpfc_debugfs_initialize - Initialize debugfs for a vport.
+ * @vport: The vport pointer to initialize.
+ *
+ * Description:
+ * When Debugfs is configured this routine sets up the lpfc debugfs file system.
+ * If not already created, this routine will create the lpfc directory, and
+ * lpfcX directory (for this HBA), and vportX directory for this vport. It will
+ * also create each file used to access lpfc specific debugfs information.
+ **/
 inline void
 lpfc_debugfs_initialize(struct lpfc_vport *vport)
 {
@@ -1034,7 +1319,17 @@ debug_failed:
 #endif
 }
 
-
+/**
+ * lpfc_debugfs_terminate -  Tear down debugfs infrastructure for this vport.
+ * @vport: The vport pointer to remove from debugfs.
+ *
+ * Description:
+ * When Debugfs is configured this routine removes debugfs file system elements
+ * that are specific to this vport. It also checks to see if there are any
+ * users left for the debugfs directories associated with the HBA and driver. If
+ * this is the last user of the HBA directory or driver directory then it will
+ * remove those from the debugfs infrastructure as well.
+ **/
 inline void
 lpfc_debugfs_terminate(struct lpfc_vport *vport)
 {
@@ -1097,5 +1392,3 @@ lpfc_debugfs_terminate(struct lpfc_vport
 #endif
 	return;
 }
-
-
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-07-30 13:05:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 18:49:32.000000000 -0400
@@ -52,17 +52,20 @@ static struct scsi_transport_template *l
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
 static DEFINE_IDR(lpfc_hba_index);
 
-/************************************************************************/
-/*                                                                      */
-/*    lpfc_config_port_prep                                             */
-/*    This routine will do LPFC initialization prior to the             */
-/*    CONFIG_PORT mailbox command. This will be initialized             */
-/*    as a SLI layer callback routine.                                  */
-/*    This routine returns 0 on success or -ERESTART if it wants        */
-/*    the SLI layer to reset the HBA and try again. Any                 */
-/*    other return value indicates an error.                            */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_config_port_prep: Perform lpfc initialization prior to config port.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine will do LPFC initialization prior to issuing the CONFIG_PORT
+ * mailbox command. It retrieves the revision information from the HBA and
+ * collects the Vital Product Data (VPD) about the HBA for preparing the
+ * configuration of the HBA.
+ *
+ * Return codes:
+ *   0 - success.
+ *   -ERESTART - requests the SLI layer to reset the HBA and try again.
+ *   Any other value - indicates an error.
+ **/
 int
 lpfc_config_port_prep(struct lpfc_hba *phba)
 {
@@ -214,7 +217,16 @@ out_free_mbox:
 	return 0;
 }
 
-/* Completion handler for config async event mailbox command. */
+/**
+ * lpfc_config_async_cmpl: Completion handler for config async event mbox cmd.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmboxq: pointer to the driver internal queue element for mailbox command.
+ *
+ * This is the completion handler for driver's configuring asynchronous event
+ * mailbox command to the device. If the mailbox command returns successfully,
+ * it will set internal async event support flag to 1; otherwise, it will
+ * set internal async event support flag to 0.
+ **/
 static void
 lpfc_config_async_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 {
@@ -226,16 +238,19 @@ lpfc_config_async_cmpl(struct lpfc_hba *
 	return;
 }
 
-/************************************************************************/
-/*                                                                      */
-/*    lpfc_config_port_post                                             */
-/*    This routine will do LPFC initialization after the                */
-/*    CONFIG_PORT mailbox command. This will be initialized             */
-/*    as a SLI layer callback routine.                                  */
-/*    This routine returns 0 on success. Any other return value         */
-/*    indicates an error.                                               */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_config_port_post: Perform lpfc initialization after config port.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine will do LPFC initialization after the CONFIG_PORT mailbox
+ * command call. It performs all internal resource and state setups on the
+ * port: post IOCB buffers, enable appropriate host interrupt attentions,
+ * ELS ring timers, etc.
+ *
+ * Return codes
+ *   0 - success.
+ *   Any other value - error.
+ **/
 int
 lpfc_config_port_post(struct lpfc_hba *phba)
 {
@@ -450,16 +465,17 @@ lpfc_config_port_post(struct lpfc_hba *p
 	return (0);
 }
 
-/************************************************************************/
-/*                                                                      */
-/*    lpfc_hba_down_prep                                                */
-/*    This routine will do LPFC uninitialization before the             */
-/*    HBA is reset when bringing down the SLI Layer. This will be       */
-/*    initialized as a SLI layer callback routine.                      */
-/*    This routine returns 0 on success. Any other return value         */
-/*    indicates an error.                                               */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_hba_down_prep: Perform lpfc uninitialization prior to HBA reset.
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine will do LPFC uninitialization before the HBA is reset when
+ * bringing down the SLI Layer.
+ *
+ * Return codes
+ *   0 - success.
+ *   Any other value - error.
+ **/
 int
 lpfc_hba_down_prep(struct lpfc_hba *phba)
 {
@@ -481,15 +497,17 @@ lpfc_hba_down_prep(struct lpfc_hba *phba
 	return 0;
 }
 
-/************************************************************************/
-/*                                                                      */
-/*    lpfc_hba_down_post                                                */
-/*    This routine will do uninitialization after the HBA is reset      */
-/*    when bringing down the SLI Layer.                                 */
-/*    This routine returns 0 on success. Any other return value         */
-/*    indicates an error.                                               */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_hba_down_post: Perform lpfc uninitialization after HBA reset.
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine will do uninitialization after the HBA is reset when bring
+ * down the SLI Layer.
+ *
+ * Return codes
+ *   0 - sucess.
+ *   Any other value - error.
+ **/
 int
 lpfc_hba_down_post(struct lpfc_hba *phba)
 {
@@ -548,7 +566,18 @@ lpfc_hba_down_post(struct lpfc_hba *phba
 	return 0;
 }
 
-/* HBA heart beat timeout handler */
+/**
+ * lpfc_hb_timeout: The HBA-timer timeout handler.
+ * @ptr: unsigned long holds the pointer to lpfc hba data structure.
+ *
+ * This is the HBA-timer timeout handler registered to the lpfc driver. When
+ * this timer fires, a HBA timeout event shall be posted to the lpfc driver
+ * work-port-events bitmap and the worker thread is notified. This timeout
+ * event will be used by the worker thread to invoke the actual timeout
+ * handler routine, lpfc_hb_timeout_handler. Any periodical operations will
+ * be performed in the timeout handler and the HBA timeout event bit shall
+ * be cleared by the worker thread after it has taken the event bitmap out.
+ **/
 static void
 lpfc_hb_timeout(unsigned long ptr)
 {
@@ -568,6 +597,22 @@ lpfc_hb_timeout(unsigned long ptr)
 	return;
 }
 
+/**
+ * lpfc_hb_mbox_cmpl: The lpfc heart-beat mailbox command callback function.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmboxq: pointer to the driver internal queue element for mailbox command.
+ *
+ * This is the callback function to the lpfc heart-beat mailbox command.
+ * If configured, the lpfc driver issues the heart-beat mailbox command to
+ * the HBA every LPFC_HB_MBOX_INTERVAL (current 5) seconds. At the time the
+ * heart-beat mailbox command is issued, the driver shall set up heart-beat
+ * timeout timer to LPFC_HB_MBOX_TIMEOUT (current 30) seconds and marks
+ * heart-beat outstanding state. Once the mailbox command comes back and
+ * no error conditions detected, the heart-beat mailbox command timer is
+ * reset to LPFC_HB_MBOX_INTERVAL seconds and the heart-beat outstanding
+ * state is cleared for the next heart-beat. If the timer expired with the
+ * heart-beat outstanding state set, the driver will put the HBA offline.
+ **/
 static void
 lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 {
@@ -586,6 +631,22 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba
 	return;
 }
 
+/**
+ * lpfc_hb_timeout_handler: The HBA-timer timeout handler.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This is the actual HBA-timer timeout handler to be invoked by the worker
+ * thread whenever the HBA timer fired and HBA-timeout event posted. This
+ * handler performs any periodic operations needed for the device. If such
+ * periodic event has already been attended to either in the interrupt handler
+ * or by processing slow-ring or fast-ring events within the HBA-timer
+ * timeout window (LPFC_HB_MBOX_INTERVAL), this handler just simply resets
+ * the timer for the next timeout period. If lpfc heart-beat mailbox command
+ * is configured and there is no heart-beat mailbox command outstanding, a
+ * heart-beat mailbox is issued and timer set properly. Otherwise, if there
+ * has been a heart-beat mailbox command outstanding, the HBA shall be put
+ * to offline.
+ **/
 void
 lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 {
@@ -684,6 +745,13 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 	}
 }
 
+/**
+ * lpfc_offline_eratt: Bring lpfc offline on hardware error attention.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to bring the HBA offline when HBA hardware error
+ * other than Port Error 6 has been detected.
+ **/
 static void
 lpfc_offline_eratt(struct lpfc_hba *phba)
 {
@@ -704,14 +772,16 @@ lpfc_offline_eratt(struct lpfc_hba *phba
 	return;
 }
 
-/************************************************************************/
-/*                                                                      */
-/*    lpfc_handle_eratt                                                 */
-/*    This routine will handle processing a Host Attention              */
-/*    Error Status event. This will be initialized                      */
-/*    as a SLI layer callback routine.                                  */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_handle_eratt: The HBA hardware error handler.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to handle the following HBA hardware error
+ * conditions:
+ * 1 - HBA error attention interrupt
+ * 2 - DMA ring index out of range
+ * 3 - Mailbox command came back as unknown
+ **/
 void
 lpfc_handle_eratt(struct lpfc_hba *phba)
 {
@@ -810,14 +880,13 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	}
 }
 
-/************************************************************************/
-/*                                                                      */
-/*    lpfc_handle_latt                                                  */
-/*    This routine will handle processing a Host Attention              */
-/*    Link Status event. This will be initialized                       */
-/*    as a SLI layer callback routine.                                  */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_handle_latt: The HBA link event handler.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked from the worker thread to handle a HBA host
+ * attention link event.
+ **/
 void
 lpfc_handle_latt(struct lpfc_hba *phba)
 {
@@ -898,12 +967,20 @@ lpfc_handle_latt_err_exit:
 	return;
 }
 
-/************************************************************************/
-/*                                                                      */
-/*   lpfc_parse_vpd                                                     */
-/*   This routine will parse the VPD data                               */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_parse_vpd: Parse VPD (Vital Product Data).
+ * @phba: pointer to lpfc hba data structure.
+ * @vpd: pointer to the vital product data.
+ * @len: length of the vital product data in bytes.
+ *
+ * This routine parses the Vital Product Data (VPD). The VPD is treated as
+ * an array of characters. In this routine, the ModelName, ProgramType, and
+ * ModelDesc, etc. fields of the phba data structure will be populated.
+ *
+ * Return codes
+ *   0 - pointer to the VPD passed in is NULL
+ *   1 - success
+ **/
 static int
 lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 {
@@ -1040,6 +1117,18 @@ lpfc_parse_vpd(struct lpfc_hba *phba, ui
 	return(1);
 }
 
+/**
+ * lpfc_get_hba_model_desc: Retrieve HBA device model name and description.
+ * @phba: pointer to lpfc hba data structure.
+ * @mdp: pointer to the data structure to hold the derived model name.
+ * @descp: pointer to the data structure to hold the derived description.
+ *
+ * This routine retrieves HBA's description based on its registered PCI device
+ * ID. The @descp passed into this function points to an array of 256 chars. It
+ * shall be returned with the model name, maximum speed, and the host bus type.
+ * The @mdp passed into this function points to an array of 80 chars. When the
+ * function returns, the @mdp will be filled with the model name.
+ **/
 static void
 lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 {
@@ -1190,14 +1279,18 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 			 m.name, m.max_speed, m.bus);
 }
 
-/**************************************************/
-/*   lpfc_post_buffer                             */
-/*                                                */
-/*   This routine will post count buffers to the  */
-/*   ring with the QUE_RING_BUF_CN command. This  */
-/*   allows 3 buffers / command to be posted.     */
-/*   Returns the number of buffers NOT posted.    */
-/**************************************************/
+/**
+ * lpfc_post_buffer: Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring.
+ * @phba: pointer to lpfc hba data structure.
+ * @pring: pointer to a IOCB ring.
+ * @cnt: the number of IOCBs to be posted to the IOCB ring.
+ *
+ * This routine posts a given number of IOCBs with the associated DMA buffer
+ * descriptors specified by the cnt argument to the given IOCB ring.
+ *
+ * Return codes
+ *   The number of IOCBs NOT able to be posted to the IOCB ring.
+ **/
 int
 lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
 {
@@ -1287,12 +1380,17 @@ lpfc_post_buffer(struct lpfc_hba *phba, 
 	return 0;
 }
 
-/************************************************************************/
-/*                                                                      */
-/*   lpfc_post_rcv_buf                                                  */
-/*   This routine post initial rcv buffers to the configured rings      */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_post_rcv_buf: Post the initial receive IOCB buffers to ELS ring.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine posts initial receive IOCB buffers to the ELS ring. The
+ * current number of initial IOCB buffers specified by LPFC_BUF_RING0 is
+ * set to 64 IOCBs.
+ *
+ * Return codes
+ *   0 - success (currently always success)
+ **/
 static int
 lpfc_post_rcv_buf(struct lpfc_hba *phba)
 {
@@ -1307,11 +1405,13 @@ lpfc_post_rcv_buf(struct lpfc_hba *phba)
 
 #define S(N,V) (((V)<<(N))|((V)>>(32-(N))))
 
-/************************************************************************/
-/*                                                                      */
-/*   lpfc_sha_init                                                      */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_sha_init: Set up initial array of hash table entries.
+ * @HashResultPointer: pointer to an array as hash table.
+ *
+ * This routine sets up the initial values to the array of hash table entries
+ * for the LC HBAs.
+ **/
 static void
 lpfc_sha_init(uint32_t * HashResultPointer)
 {
@@ -1322,11 +1422,16 @@ lpfc_sha_init(uint32_t * HashResultPoint
 	HashResultPointer[4] = 0xC3D2E1F0;
 }
 
-/************************************************************************/
-/*                                                                      */
-/*   lpfc_sha_iterate                                                   */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_sha_iterate: Iterate initial hash table with the working hash table.
+ * @HashResultPointer: pointer to an initial/result hash table.
+ * @HashWorkingPointer: pointer to an working hash table.
+ *
+ * This routine iterates an initial hash table pointed by @HashResultPointer
+ * with the values from the working hash table pointeed by @HashWorkingPointer.
+ * The results are putting back to the initial hash table, returned through
+ * the @HashResultPointer as the result hash table.
+ **/
 static void
 lpfc_sha_iterate(uint32_t * HashResultPointer, uint32_t * HashWorkingPointer)
 {
@@ -1374,22 +1479,29 @@ lpfc_sha_iterate(uint32_t * HashResultPo
 
 }
 
-/************************************************************************/
-/*                                                                      */
-/*   lpfc_challenge_key                                                 */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_challenge_key: Create challenge key based on WWPN of the HBA.
+ * @RandomChallenge: pointer to the entry of host challenge random number array.
+ * @HashWorking: pointer to the entry of the working hash array.
+ *
+ * This routine calculates the working hash array referred by @HashWorking
+ * from the challenge random numbers associated with the host, referred by
+ * @RandomChallenge. The result is put into the entry of the working hash
+ * array and returned by reference through @HashWorking.
+ **/
 static void
 lpfc_challenge_key(uint32_t * RandomChallenge, uint32_t * HashWorking)
 {
 	*HashWorking = (*RandomChallenge ^ *HashWorking);
 }
 
-/************************************************************************/
-/*                                                                      */
-/*   lpfc_hba_init                                                      */
-/*                                                                      */
-/************************************************************************/
+/**
+ * lpfc_hba_init: Perform special handling for LC HBA initialization.
+ * @phba: pointer to lpfc hba data structure.
+ * @hbainit: pointer to an array of unsigned 32-bit integers.
+ *
+ * This routine performs the special handling for LC HBA initialization.
+ **/
 void
 lpfc_hba_init(struct lpfc_hba *phba, uint32_t *hbainit)
 {
@@ -1412,6 +1524,15 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 	kfree(HashWorking);
 }
 
+/**
+ * lpfc_cleanup: Performs vport cleanups before deleting a vport.
+ * @vport: pointer to a virtual N_Port data structure.
+ *
+ * This routine performs the necessary cleanups before deleting the @vport.
+ * It invokes the discovery state machine to perform necessary state
+ * transitions and to release the ndlps associated with the @vport. Note,
+ * the physical port is treated as @vport 0.
+ **/
 void
 lpfc_cleanup(struct lpfc_vport *vport)
 {
@@ -1498,6 +1619,14 @@ lpfc_cleanup(struct lpfc_vport *vport)
 	return;
 }
 
+/**
+ * lpfc_stop_vport_timers: Stop all the timers associated with a vport.
+ * @vport: pointer to a virtual N_Port data structure.
+ *
+ * This routine stops all the timers associated with a @vport. This function
+ * is invoked before disabling or deleting a @vport. Note that the physical
+ * port is treated as @vport 0.
+ **/
 void
 lpfc_stop_vport_timers(struct lpfc_vport *vport)
 {
@@ -1507,6 +1636,13 @@ lpfc_stop_vport_timers(struct lpfc_vport
 	return;
 }
 
+/**
+ * lpfc_stop_phba_timers: Stop all the timers associated with an HBA.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine stops all the timers associated with a HBA. This function is
+ * invoked before either putting a HBA offline or unloading the driver.
+ **/
 static void
 lpfc_stop_phba_timers(struct lpfc_hba *phba)
 {
@@ -1519,6 +1655,16 @@ lpfc_stop_phba_timers(struct lpfc_hba *p
 	return;
 }
 
+/**
+ * lpfc_block_mgmt_io: Mark a HBA's management interface as blocked.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine marks a HBA's management interface as blocked. Once the HBA's
+ * management interface is marked as blocked, all the user space access to
+ * the HBA, whether they are from sysfs interface or libdfc interface will
+ * all be blocked. The HBA is set to block the management interface when the
+ * driver prepares the HBA interface for online or offline.
+ **/
 static void
 lpfc_block_mgmt_io(struct lpfc_hba * phba)
 {
@@ -1529,6 +1675,18 @@ lpfc_block_mgmt_io(struct lpfc_hba * phb
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 }
 
+/**
+ * lpfc_online: Initialize and bring a HBA online.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine initializes the HBA and brings a HBA online. During this
+ * process, the management interface is blocked to prevent user space access
+ * to the HBA interfering with the driver initialization.
+ *
+ * Return codes
+ *   0 - successful
+ *   1 - failed
+ **/
 int
 lpfc_online(struct lpfc_hba *phba)
 {
@@ -1574,6 +1732,17 @@ lpfc_online(struct lpfc_hba *phba)
 	return 0;
 }
 
+/**
+ * lpfc_unblock_mgmt_io: Mark a HBA's management interface to be not blocked.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine marks a HBA's management interface as not blocked. Once the
+ * HBA's management interface is marked as not blocked, all the user space
+ * access to the HBA, whether they are from sysfs interface or libdfc
+ * interface will be allowed. The HBA is set to block the management interface
+ * when the driver prepares the HBA interface for online or offline and then
+ * set to unblock the management interface afterwards.
+ **/
 void
 lpfc_unblock_mgmt_io(struct lpfc_hba * phba)
 {
@@ -1584,6 +1753,14 @@ lpfc_unblock_mgmt_io(struct lpfc_hba * p
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 }
 
+/**
+ * lpfc_offline_prep: Prepare a HBA to be brought offline.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to prepare a HBA to be brought offline. It performs
+ * unregistration login to all the nodes on all vports and flushes the mailbox
+ * queue to make it ready to be brought offline.
+ **/
 void
 lpfc_offline_prep(struct lpfc_hba * phba)
 {
@@ -1633,6 +1810,14 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	lpfc_sli_flush_mbox_queue(phba);
 }
 
+/**
+ * lpfc_offline: Bring a HBA offline.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine actually brings a HBA offline. It stops all the timers
+ * associated with the HBA, brings down the SLI layer, and eventually
+ * marks the HBA as in offline state for the upper layer protocol.
+ **/
 void
 lpfc_offline(struct lpfc_hba *phba)
 {
@@ -1670,12 +1855,17 @@ lpfc_offline(struct lpfc_hba *phba)
 	lpfc_destroy_vport_work_array(phba, vports);
 }
 
-/******************************************************************************
-* Function name: lpfc_scsi_free
-*
-* Description: Called from lpfc_pci_remove_one free internal driver resources
-*
-******************************************************************************/
+/**
+ * lpfc_scsi_free: Free all the SCSI buffers and IOCBs from driver lists.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is to free all the SCSI buffers and IOCBs from the driver
+ * list back to kernel. It is called from lpfc_pci_remove_one to free
+ * the internal resources before the device is removed from the system.
+ *
+ * Return codes
+ *   0 - successful (for now, it always returns 0)
+ **/
 static int
 lpfc_scsi_free(struct lpfc_hba *phba)
 {
@@ -1704,6 +1894,22 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	return 0;
 }
 
+/**
+ * lpfc_create_port: Create an FC port.
+ * @phba: pointer to lpfc hba data structure.
+ * @instance: a unique integer ID to this FC port.
+ * @dev: pointer to the device data structure.
+ *
+ * This routine creates a FC port for the upper layer protocol. The FC port
+ * can be created on top of either a physical port or a virtual port provided
+ * by the HBA. This routine also allocates a SCSI host data structure (shost)
+ * and associates the FC port created before adding the shost into the SCSI
+ * layer.
+ *
+ * Return codes
+ *   @vport - pointer to the virtual N_Port data structure.
+ *   NULL - port create failed.
+ **/
 struct lpfc_vport *
 lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 {
@@ -1777,6 +1983,13 @@ out:
 	return NULL;
 }
 
+/**
+ * destroy_port: Destroy an FC port.
+ * @vport: pointer to an lpfc virtual N_Port data structure.
+ *
+ * This routine destroys a FC port from the upper layer protocol. All the
+ * resources associated with the port are released.
+ **/
 void
 destroy_port(struct lpfc_vport *vport)
 {
@@ -1797,6 +2010,16 @@ destroy_port(struct lpfc_vport *vport)
 	return;
 }
 
+/**
+ * lpfc_get_instance: Get a unique integer ID.
+ *
+ * This routine allocates a unique integer ID from lpfc_hba_index pool. It
+ * uses the kernel idr facility to perform the task.
+ *
+ * Return codes:
+ *   instance - a unique integer ID allocated as the new instance.
+ *   -1 - lpfc get instance failed.
+ **/
 int
 lpfc_get_instance(void)
 {
@@ -1810,11 +2033,21 @@ lpfc_get_instance(void)
 	return instance;
 }
 
-/*
- * Note: there is no scan_start function as adapter initialization
- * will have asynchronously kicked off the link initialization.
- */
-
+/**
+ * lpfc_scan_finished: method for SCSI layer to detect whether scan is done.
+ * @shost: pointer to SCSI host data structure.
+ * @time: elapsed time of the scan in jiffies.
+ *
+ * This routine is called by the SCSI layer with a SCSI host to determine
+ * whether the scan host is finished.
+ *
+ * Note: there is no scan_start function as adapter initialization will have
+ * asynchronously kicked off the link initialization.
+ *
+ * Return codes
+ *   0 - SCSI host scan is not over yet.
+ *   1 - SCSI host scan is over.
+ **/
 int lpfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
@@ -1858,6 +2091,13 @@ finished:
 	return stat;
 }
 
+/**
+ * lpfc_host_attrib_init: Initialize SCSI host attributes on a FC port.
+ * @shost: pointer to SCSI host data structure.
+ *
+ * This routine initializes a given SCSI host attributes on a FC port. The
+ * SCSI host can be either on top of a physical port or a virtual port.
+ **/
 void lpfc_host_attrib_init(struct Scsi_Host *shost)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
@@ -1906,6 +2146,25 @@ void lpfc_host_attrib_init(struct Scsi_H
 	spin_unlock_irq(shost->host_lock);
 }
 
+/**
+ * lpfc_enable_msix: Enable MSI-X interrupt mode.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable the MSI-X interrupt vectors. The kernel
+ * function pci_enable_msix() is called to enable the MSI-X vectors. Note that
+ * pci_enable_msix(), once invoked, enables either all or nothing, depending
+ * on the current availability of PCI vector resources. The device driver is
+ * responsible for calling the individual request_irq() to register each MSI-X
+ * vector with a interrupt handler, which is done in this function. Note that
+ * later when device is unloading, the driver should always call free_irq()
+ * on all MSI-X vectors it has done request_irq() on before calling
+ * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
+ * will be left with MSI-X enabled and leaks its vectors.
+ *
+ * Return codes
+ *   0 - sucessful
+ *   other values - error
+ **/
 static int
 lpfc_enable_msix(struct lpfc_hba *phba)
 {
@@ -1935,6 +2194,13 @@ lpfc_enable_msix(struct lpfc_hba *phba)
 	return error;
 }
 
+/**
+ * lpfc_disable_msix: Disable MSI-X interrupt mode.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release the MSI-X vectors and then disable the
+ * MSI-X interrupt mode.
+ **/
 static void
 lpfc_disable_msix(struct lpfc_hba *phba)
 {
@@ -1942,6 +2208,23 @@ lpfc_disable_msix(struct lpfc_hba *phba)
 	pci_disable_msix(phba->pcidev);
 }
 
+/**
+ * lpfc_pci_probe_one: lpfc PCI probe func to register device to PCI subsystem.
+ * @pdev: pointer to PCI device
+ * @pid: pointer to PCI device identifier
+ *
+ * This routine is to be registered to the kernel's PCI subsystem. When an
+ * Emulex HBA is presented in PCI bus, the kernel PCI subsystem looks at
+ * PCI device-specific information of the device and driver to see if the
+ * driver state that it can support this kind of device. If the match is
+ * successful, the driver core invokes this routine. If this routine
+ * determines it can claim the HBA, it does all the initialization that it
+ * needs to do to handle the HBA properly.
+ *
+ * Return code
+ *   0 - driver can claim the device
+ *   negative value - driver can not claim the device
+ **/
 static int __devinit
 lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 {
@@ -2262,6 +2545,14 @@ out:
 	return error;
 }
 
+/**
+ * lpfc_pci_remove_one: lpfc PCI func to unregister device from PCI subsystem.
+ * @pdev: pointer to PCI device
+ *
+ * This routine is to be registered to the kernel's PCI subsystem. When an
+ * Emulex HBA is removed from PCI bus. It perform all the necessary cleanup
+ * for the HBA device to be removed from the PCI subsystem properly.
+ **/
 static void __devexit
 lpfc_pci_remove_one(struct pci_dev *pdev)
 {
@@ -2336,13 +2627,21 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 }
 
 /**
- * lpfc_io_error_detected - called when PCI error is detected
- * @pdev: Pointer to PCI device
- * @state: The current pci conneection state
+ * lpfc_io_error_detected: Driver method for handling PCI I/O error detected.
+ * @pdev: pointer to PCI device.
+ * @state: the current PCI connection state.
  *
- * This function is called after a PCI bus error affecting
- * this device has been detected.
- */
+ * This routine is registered to the PCI subsystem for error handling. This
+ * function is called by the PCI subsystem after a PCI bus error affecting
+ * this device has been detected. When this function is invoked, it will
+ * need to stop all the I/Os and interrupt(s) to the device. Once that is
+ * done, it will return PCI_ERS_RESULT_NEED_RESET for the PCI subsystem to
+ * perform proper recovery as desired.
+ *
+ * Return codes
+ *   PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
+ *   PCI_ERS_RESULT_DISCONNECT - device could not be recovered
+ **/
 static pci_ers_result_t lpfc_io_error_detected(struct pci_dev *pdev,
 				pci_channel_state_t state)
 {
@@ -2376,10 +2675,21 @@ static pci_ers_result_t lpfc_io_error_de
 }
 
 /**
- * lpfc_io_slot_reset - called after the pci bus has been reset.
- * @pdev: Pointer to PCI device
+ * lpfc_io_slot_reset: Restart a PCI device from scratch.
+ * @pdev: pointer to PCI device.
+ *
+ * This routine is registered to the PCI subsystem for error handling. This is
+ * called after PCI bus has been reset to restart the PCI card from scratch,
+ * as if from a cold-boot. During the PCI subsystem error recovery, after the
+ * driver returns PCI_ERS_RESULT_NEED_RESET, the PCI subsystem will perform
+ * proper error recovery and then call this routine before calling the .resume
+ * method to recover the device. This function will initialize the HBA device,
+ * enable the interrupt, but it will just put the HBA to offline state without
+ * passing any I/O traffic.
  *
- * Restart the card from scratch, as if from a cold-boot.
+ * Return codes
+ *   PCI_ERS_RESULT_RECOVERED - the device has been recovered
+ *   PCI_ERS_RESULT_DISCONNECT - device could not be recovered
  */
 static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
 {
@@ -2440,11 +2750,13 @@ static pci_ers_result_t lpfc_io_slot_res
 }
 
 /**
- * lpfc_io_resume - called when traffic can start flowing again.
- * @pdev: Pointer to PCI device
+ * lpfc_io_resume: Resume PCI I/O operation.
+ * @pdev: pointer to PCI device
  *
- * This callback is called when the error recovery driver tells us that
- * its OK to resume normal operation.
+ * This routine is registered to the PCI subsystem for error handling. It is
+ * called when kernel error recovery tells the lpfc driver that it is ok to
+ * resume normal PCI operation after PCI bus error recovery. After this call,
+ * traffic can start to flow from this device again.
  */
 static void lpfc_io_resume(struct pci_dev *pdev)
 {
@@ -2540,6 +2852,18 @@ static struct pci_driver lpfc_driver = {
 	.err_handler    = &lpfc_err_handler,
 };
 
+/**
+ * lpfc_init: lpfc module initialization routine.
+ *
+ * This routine is to be invoked when the lpfc module is loaded into the
+ * kernel. The special kernel macro module_init() is used to indicate the
+ * role of this routine to the kernel as lpfc module entry point.
+ *
+ * Return codes
+ *   0 - successful
+ *   -ENOMEM - FC attach transport failed
+ *   all others - failed
+ */
 static int __init
 lpfc_init(void)
 {
@@ -2573,6 +2897,13 @@ lpfc_init(void)
 	return error;
 }
 
+/**
+ * lpfc_exit: lpfc module removal routine.
+ *
+ * This routine is invoked when the lpfc module is removed from the kernel.
+ * The special kernel macro module_exit() is used to indicate the role of
+ * this routine to the kernel as lpfc module exit point.
+ */
 static void __exit
 lpfc_exit(void)
 {


