From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] FC_Transport: Check portstates before invoking target scan
Date: Thu, 14 Jun 2007 09:27:06 +0200
Message-ID: <4670EDCA.5070302@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050301030106020401060009"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:45704 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXFNH1I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2007 03:27:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: James Smart <James.Smart@Emulex.Com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050301030106020401060009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James (& James, too :-),

scsi_transport_fc.c:fc_user_scan() should check the portstates prior to
calling scsi_scan_target(). Otherwise we might get a nice oops as the
rport might already been disconnected from the host by the time we're
calling scsi_scan_target(). Thus the traversal from the rport to the
scsi_host in scsi_scan_target() will fail, resulting in a nice Oops.
Plus it's quite pointless to scan a target if the portstates already
told us that we can't communicate with it.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------050301030106020401060009
Content-Type: text/plain;
 name="fc_transport_check-portstates-before-scanning"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fc_transport_check-portstates-before-scanning"

scsi_transport_fc: Check portstates before invoking target scan

When a target scan is initiated from sysfs, we should check the
portstate prior to invoke scsi_scan_target().
Otherwise scsi_scan_target() might oops as the rport might already
been removed from the scsi host and the traversal from the rport to
the scsi_host in scsi_scan_target() will fail.
Also the portstate already told us that communication with the target
has failed, so it's quite pointless to try.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4953f0d..bd73615 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1943,6 +1943,12 @@ static int fc_user_scan(struct Scsi_Host
 		if (rport->scsi_target_id == -1)
 			continue;
 
+		if ((rport->port_state == FC_PORTSTATE_NOTPRESENT) ||
+		    (rport->port_state == FC_PORTSTATE_UNKNOWN) ||
+		    (rport->port_state == FC_PORTSTATE_DELETED) ||
+		    (rport->port_state == FC_PORTSTATE_BLOCKED))
+			continue;
+
 		if ((channel == SCAN_WILD_CARD || channel == rport->channel) &&
 		    (id == SCAN_WILD_CARD || id == rport->scsi_target_id)) {
 			scsi_scan_target(&rport->dev, rport->channel,

--------------050301030106020401060009--
