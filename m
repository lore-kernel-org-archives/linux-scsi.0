From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1] fusion: hold off error recovery while alternate ioc is
 initializing
Date: Wed, 16 Dec 2009 15:20:49 -0600
Message-ID: <4B294F31.5030109@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:36741 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756127AbZLPVUu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 16:20:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Jeremy Higdon <jeremy@sgi.com>, Robin Holt <holt@sgi.com>, kashyap.desai@lsi.com

Fusion FC chips are two function with some shared resources.  During
initialization of one function its driver inhibits the ability of the
other function's driver to allocate message frames by clearing its
"active" flag.  Should mid-layer error recovery be initiated for a
scsi command during this initialization (which can take many seconds)
error recovery will escalate to the level of host reset.  This host
reset might fail resulting in all connected targets being taken offline.

This patch holds off mid-layer error recovery for up to 60 seconds
to permit initialization of the other function to complete.

Applies to scsi-misc.

Signed-off-by: Michael Reed <mdr@sgi.com>

==

--- a/drivers/message/fusion/mptfc.c	2009-12-16 15:09:22.817382765 -0600
+++ b/drivers/message/fusion/mptfc.c	2009-12-16 15:10:31.949380663 -0600
@@ -195,29 +195,31 @@ mptfc_block_error_handler(struct scsi_cm
 	unsigned long		flags;
 	int			ready;
 	MPT_ADAPTER 		*ioc;
+	int			sleep_interval = 1000;
+	int			loops = 60 * sleep_interval;
 
 	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
 	spin_lock_irqsave(shost->host_lock, flags);
-	while ((ready = fc_remote_port_chkready(rport) >> 16) == DID_IMM_RETRY) {
+
+	while ((loops > 0 && ioc->active == 0)
+	 || (ready = fc_remote_port_chkready(rport) >> 16) == DID_IMM_RETRY) {
+
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-			"mptfc_block_error_handler.%d: %d:%d, port status is "
-			"DID_IMM_RETRY, deferring %s recovery.\n",
-			ioc->name, ioc->sh->host_no,
-			SCpnt->device->id, SCpnt->device->lun, caller));
-		msleep(1000);
+		msleep(sleep_interval);
+		loops -= sleep_interval;
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata) {
+	if (ioc->active == 0
+	 || ready == DID_NO_CONNECT || !SCpnt->device->hostdata) {
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-			"%s.%d: %d:%d, failing recovery, "
+			"%s.%d: %d:%d, failing recovery, active %d, "
 			"port state %d, vdevice %p.\n", caller,
 			ioc->name, ioc->sh->host_no,
-			SCpnt->device->id, SCpnt->device->lun, ready,
-			SCpnt->device->hostdata));
+			SCpnt->device->id, SCpnt->device->lun,
+			ioc->active, ready, SCpnt->device->hostdata));
 		return FAILED;
 	}
 	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
