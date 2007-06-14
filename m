From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] FC_Transport: Check portstates before invoking target scan
Date: Thu, 14 Jun 2007 15:16:45 +0200
Message-ID: <20070614131645.GB20689@pentland.suse.de>
References: <4670EDCA.5070302@suse.de> <46712D11.1010506@emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:36252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbXFNNQx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2007 09:16:53 -0400
Content-Disposition: inline
In-Reply-To: <46712D11.1010506@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi James,

On Thu, Jun 14, 2007 at 07:57:05AM -0400, James Smart wrote:
> Sounds reasonable...  Only change I'd make is rather than comparing all the
> different states, simply compare  (rport->port_state != FC_PORTSTATE_ONLINE)
> 
As per normal you are oh-so correct.

Updated patch attached.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N�rnberg
GF: Markus Rex, HRB 16746 (AG N�rnberg)

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=fc_transport_check-portstates-before-scanning

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
index 4953f0d..e882570 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1943,6 +1943,9 @@ static int fc_user_scan(struct Scsi_Host
 		if (rport->scsi_target_id == -1)
 			continue;
 
+		if (rport->port_state != FC_PORTSTATE_ONLINE)
+			continue;
+
 		if ((channel == SCAN_WILD_CARD || channel == rport->channel) &&
 		    (id == SCAN_WILD_CARD || id == rport->scsi_target_id)) {
 			scsi_scan_target(&rport->dev, rport->channel,

--SLDf9lqlvOQaIe6s--
