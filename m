From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 3/8] mpt fusion: adding/removing white space
Date: Fri, 14 Sep 2007 18:47:40 -0600
Message-ID: <20070915004740.GA16827@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48360 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193AbXIOAz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 20:55:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

cleaning up some white space that was introduce in a recent "cb_idx int to u8" patch.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-09-14 17:23:24.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2007-09-14 17:26:18.000000000 -0600
@@ -305,7 +305,7 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa
 
 	/*  Check for (valid) IO callback!  */
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
-			MptCallbacks[cb_idx] == NULL) {
+		MptCallbacks[cb_idx] == NULL) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
 				__FUNCTION__, ioc->name, cb_idx);
 		goto out;
@@ -369,7 +369,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 
 	/*  Check for (valid) IO callback!  */
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
-			MptCallbacks[cb_idx] == NULL) {
+		MptCallbacks[cb_idx] == NULL) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
 				__FUNCTION__, ioc->name, cb_idx);
 		freeme = 0;
@@ -621,7 +621,7 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DR
 void
 mpt_deregister(u8 cb_idx)
 {
-	if (cb_idx  && (cb_idx < MPT_MAX_PROTOCOL_DRIVERS)) {
+	if (cb_idx && (cb_idx < MPT_MAX_PROTOCOL_DRIVERS)) {
 		MptCallbacks[cb_idx] = NULL;
 		MptDriverClass[cb_idx] = MPTUNKNOWN_DRIVER;
 		MptEvHandlers[cb_idx] = NULL;
@@ -645,7 +645,7 @@ mpt_deregister(u8 cb_idx)
 int
 mpt_event_register(u8 cb_idx, MPT_EVHANDLER ev_cbfunc)
 {
-	if (!cb_idx  || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return -1;
 
 	MptEvHandlers[cb_idx] = ev_cbfunc;
@@ -665,7 +665,7 @@ mpt_event_register(u8 cb_idx, MPT_EVHAND
 void
 mpt_event_deregister(u8 cb_idx)
 {
-	if (!cb_idx  || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return;
 
 	MptEvHandlers[cb_idx] = NULL;
@@ -722,7 +722,7 @@ mpt_device_driver_register(struct mpt_pc
 	MPT_ADAPTER	*ioc;
 	const struct pci_device_id *id;
 
-	if (!cb_idx  || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return -EINVAL;
 
 	MptDeviceDriverHandlers[cb_idx] = dd_cbfunc;
@@ -749,7 +749,7 @@ mpt_device_driver_deregister(u8 cb_idx)
 	struct mpt_pci_driver *dd_cbfunc;
 	MPT_ADAPTER	*ioc;
 
-	if (!cb_idx  || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return;
 
 	dd_cbfunc = MptDeviceDriverHandlers[cb_idx];
@@ -1681,7 +1681,7 @@ mpt_attach(struct pci_dev *pdev, const s
 	}
 
 	/* call per device driver probe entry point */
-	for(cb_idx=0; cb_idx<MPT_MAX_PROTOCOL_DRIVERS; cb_idx++) {
+	for(cb_idx = 0; cb_idx < MPT_MAX_PROTOCOL_DRIVERS; cb_idx++) {
 		if(MptDeviceDriverHandlers[cb_idx] &&
 		  MptDeviceDriverHandlers[cb_idx]->probe) {
 			MptDeviceDriverHandlers[cb_idx]->probe(pdev,id);
@@ -1731,7 +1731,7 @@ mpt_detach(struct pci_dev *pdev)
 	remove_proc_entry(pname, NULL);
 
 	/* call per device driver remove entry point */
-	for(cb_idx=0; cb_idx<MPT_MAX_PROTOCOL_DRIVERS; cb_idx++) {
+	for(cb_idx = 0; cb_idx < MPT_MAX_PROTOCOL_DRIVERS; cb_idx++) {
 		if(MptDeviceDriverHandlers[cb_idx] &&
 		  MptDeviceDriverHandlers[cb_idx]->remove) {
 			MptDeviceDriverHandlers[cb_idx]->remove(pdev);
@@ -5933,7 +5933,7 @@ procmpt_version_read(char *buf, char **s
 	len += sprintf(buf+len, "  Fusion MPT base driver\n");
 
 	scsi = fc = sas = lan = ctl = targ = dmp = 0;
-	for (cb_idx=MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
 		drvname = NULL;
 		if (MptCallbacks[cb_idx]) {
 			switch (MptDriverClass[cb_idx]) {
@@ -6676,7 +6676,7 @@ ProcessEventNotification(MPT_ADAPTER *io
 	/*
 	 *  Call each currently registered protocol event handler.
 	 */
-	for (cb_idx=MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
 		if (MptEvHandlers[cb_idx]) {
 			devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Routing Event to event handler #%d\n",
 					ioc->name, cb_idx));
