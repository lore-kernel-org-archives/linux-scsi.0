From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] missing statics in fusion
Date: Tue, 17 Aug 2004 18:29:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817162910.GA16734@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:19179 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265795AbUHQQ3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:29:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org


--- 1.29/drivers/message/fusion/mptbase.c	2004-08-17 00:49:58 +02:00
+++ edited/drivers/message/fusion/mptbase.c	2004-08-17 20:23:02 +02:00
@@ -3395,7 +3395,7 @@
  *	@hd: Pointer to MPT_SCSI_HOST structure
  *	@init: If set, initialize the spin lock.
  */
-int
+static int
 initChainBuffers(MPT_ADAPTER *ioc)
 {
 	u8		*mem;
--- 1.28/drivers/message/fusion/mptctl.c	2004-07-02 17:14:30 +02:00
+++ edited/drivers/message/fusion/mptctl.c	2004-08-17 20:19:57 +02:00
@@ -2865,7 +2865,7 @@
 };
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-int __init mptctl_init(void)
+static int __init mptctl_init(void)
 {
 	int err;
 	int where = 1;
@@ -2963,7 +2963,7 @@
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-void mptctl_exit(void)
+static void __exit mptctl_exit(void)
 {
 	misc_deregister(&mptctl_miscdev);
 	printk(KERN_INFO MYNAM ": Deregistered /dev/%s @ (major,minor=%d,%d)\n",
--- 1.45/drivers/message/fusion/mptscsih.c	2004-08-03 01:01:01 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-08-17 20:22:42 +02:00
@@ -178,7 +178,7 @@
 static int	mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
 static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 lun, char *data, int dlen);
-void		mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56);
+static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56);
 static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq);
 static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 offset, int *requestedPtr, int *configurationPtr, u8 flags);
 static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id);
@@ -1760,7 +1759,7 @@
  *
  *	Returns pointer to buffer where information was written.
  */
-const char *
+static const char *
 mptscsih_info(struct Scsi_Host *SChost)
 {
 	MPT_SCSI_HOST *h;
@@ -1975,8 +1974,9 @@
  * 	hostno: scsi host number
  *	func:   if write = 1; if read = 0
  */
-int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-			int length, int func)
+static int
+mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start,
+		off_t offset, int length, int func)
 {
 	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
 	MPT_ADAPTER	*ioc = hd->ioc;
@@ -2010,7 +2010,7 @@
  *
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)
  */
-int
+static int
 mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	MPT_SCSI_HOST		*hd;
@@ -2551,7 +2551,7 @@
  *
  *	Returns SUCCESS or FAILED.
  */
-int
+static int
 mptscsih_abort(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
@@ -2653,7 +2653,7 @@
  *
  *	Returns SUCCESS or FAILED.
  */
-int
+static int
 mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
@@ -2708,7 +2708,7 @@
  *
  *	Returns SUCCESS or FAILED.
  */
-int
+static int
 mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
@@ -2760,7 +2760,7 @@
  *
  *	Returns SUCCESS or FAILED.
  */
-int
+static int
 mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST *  hd;
@@ -2937,7 +2937,7 @@
 /*
  *	This is anyones guess quite frankly.
  */
-int
+static int
 mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev,
 		sector_t capacity, int geom[])
 {
@@ -2984,7 +2984,7 @@
  *	Return non-zero if allocation fails.
  *	Init memory once per id (not LUN).
  */
-int
+static int
 mptscsih_slave_alloc(struct scsi_device *device)
 {
 	struct Scsi_Host	*host = device->host;
@@ -3033,7 +3033,7 @@
  *	OS entry point to allow for host driver to free allocated memory
  *	Called if no device present or device being unloaded
  */
-void
+static void
 mptscsih_slave_destroy(struct scsi_device *device)
 {
 	struct Scsi_Host	*host = device->host;
@@ -3098,7 +3098,7 @@
  *	member to 1 if a device does not support Q tags.
  *	Return non-zero if fails.
  */
-int
+static int
 mptscsih_slave_configure(struct scsi_device *device)
 {
 	struct Scsi_Host	*sh = device->host;
@@ -3743,7 +3743,8 @@
  *  the Inquiry data, adapter capabilities, and NVRAM settings.
  *
  */
-void mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56)
+static void
+mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56)
 {
 	ScsiCfgData *pspi_data = &hd->ioc->spi_data;
 	int  id = (int) target->target_id;
