From: Rob Landley <rob@landley.net>
Subject: [PATCH 11/15] Update kerneldoc comments in drivers/scsi/scsi_transport_fc.c
Date: Fri, 26 Oct 2007 23:15:21 -0500
Message-ID: <200710262315.21990.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35989
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751144AbXJ0DPh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:15:37 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id BA21973938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:18:21 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_transport_fc.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_transport_fc.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_fc.c	Fri Oct 26 22:44:43 2007 -0500
@@ -481,9 +481,9 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " exceeded, the scsi target is removed. Value should be"
 		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
 
-/**
+/*
  * Netlink Infrastructure
- **/
+ */
 
 static atomic_t fc_event_seq;
 
@@ -491,7 +491,7 @@ static atomic_t fc_event_seq;
  * fc_get_event_number - Obtain the next sequential FC event number
  *
  * Notes:
- *   We could have inline'd this, but it would have required fc_event_seq to
+ *   We could have inlined this, but it would have required fc_event_seq to
  *   be exposed. For now, live with the subroutine call.
  *   Atomic used to avoid lock/unlock...
  **/
@@ -586,6 +586,7 @@ EXPORT_SYMBOL(fc_host_post_event);
  * @event_number:	fc event number obtained from get_fc_event_number()
  * @data_len:		amount, in bytes, of vendor unique data
  * @data_buf:		pointer to vendor unique data
+ * @vendor_id:          Vendor id
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
@@ -2214,13 +2215,13 @@ fc_flush_devloss(struct Scsi_Host *shost
 /**
  * fc_remove_host - called to terminate any fc_transport-related elements
  *                  for a scsi host.
- * @rport:	remote port to be unblocked.
+ * @shost:	Which &Scsi_Host
  *
  * This routine is expected to be called immediately preceeding the
  * a driver's call to scsi_remove_host().
  *
  * WARNING: A driver utilizing the fc_transport, which fails to call
- *   this routine prior to scsi_remote_host(), will leave dangling
+ *   this routine prior to scsi_remove_host(), will leave dangling
  *   objects in /sys/class/fc_remote_ports. Access to any of these
  *   objects can result in a system crash !!!
  *
@@ -2691,11 +2692,11 @@ EXPORT_SYMBOL(fc_remote_port_add);
  * port is no longer part of the topology. Note: Although a port
  * may no longer be part of the topology, it may persist in the remote
  * ports displayed by the fc_host. We do this under 2 conditions:
- * - If the port was a scsi target, we delay its deletion by "blocking" it.
+ * 1) If the port was a scsi target, we delay its deletion by "blocking" it.
  *   This allows the port to temporarily disappear, then reappear without
  *   disrupting the SCSI device tree attached to it. During the "blocked"
  *   period the port will still exist.
- * - If the port was a scsi target and disappears for longer than we
+ * 2) If the port was a scsi target and disappears for longer than we
  *   expect, we'll delete the port and the tear down the SCSI device tree
  *   attached to it. However, we want to semi-persist the target id assigned
  *   to that port if it eventually does exist. The port structure will
@@ -2709,7 +2710,8 @@ EXPORT_SYMBOL(fc_remote_port_add);
  * temporary blocked state. From the LLDD's perspective, the rport no
  * longer exists. From the SCSI midlayer's perspective, the SCSI target
  * exists, but all sdevs on it are blocked from further I/O. The following
- * is then expected:
+ * is then expected.
+ *
  *   If the remote port does not return (signaled by a LLDD call to
  *   fc_remote_port_add()) within the dev_loss_tmo timeout, then the
  *   scsi target is removed - killing all outstanding i/o and removing the
@@ -2795,9 +2797,10 @@ EXPORT_SYMBOL(fc_remote_port_delete);
  * fc_remote_port_rolechg - notifies the fc transport that the roles
  *		on a remote may have changed.
  * @rport:	The remote port that changed.
- *
- * The LLDD calls this routine to notify the transport that the roles
- * on a remote port may have changed. The largest effect of this is
+ * @roles:      New roles for this port.
+ *
+ * Description: The LLDD calls this routine to notify the transport that the
+ * roles on a remote port may have changed. The largest effect of this is
  * if a port now becomes a FCP Target, it must be allocated a
  * scsi target id.  If the port is no longer a FCP target, any
  * scsi target id value assigned to it will persist in case the

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
