From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi_transport_sas and device hotplug
Date: Fri, 19 May 2006 10:49:37 -0500
Message-ID: <1148053777.3410.41.camel@mulgrave.il.steeleye.com>
References: <446DC84B.1070203@sanblaze.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18844 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932419AbWESPtk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 11:49:40 -0400
In-Reply-To: <446DC84B.1070203@sanblaze.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Scott O'Connor <soconnor@sanblaze.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-05-19 at 09:29 -0400, Scott O'Connor wrote:
> With a LSI1068 (SAS) card, I'm trying to do device hotplug.
> Back in the day I used the /proc calls below to hotplug a device.
> 
> scsi remove-single-device <args>
> scsi add_single-device <args>
> 
> With 2.6.16-1 kernel, the "remove" call below works, the /dev/sd*
> structure is removed.
> 
> echo scsi remove-single-device 0 07 00 00 > /proc/scsi/scsi
> 
> However, this does not add the device back (the /dev/sd* node
> is not created):
> 
> echo scsi add-single-device 0 07 00 00 > /proc/scsi/scsi
> 
> I see the scsi_proc.c to scsi_transport_sas.c user_scan transport
> layer code and it seems hooked up properly.  Before I debug, has
> anyone else seen a problem here?

Actually, when I try this with 2.6.17-rc4, I get a BUG triggered in the
transport class at line 579 ... it's finding the wrong device in the
user_scan callback.

Does this attached patch fix it for you?

James

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -955,7 +955,8 @@ static int sas_user_scan(struct Scsi_Hos
 	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
 		struct sas_phy *parent = dev_to_phy(rphy->dev.parent);
 
-		if (rphy->scsi_target_id == -1)
+		if (rphy->identify.device_type != SAS_END_DEVICE ||
+		    rphy->scsi_target_id == -1)
 			continue;
 
 		if ((channel == SCAN_WILD_CARD || channel == parent->port_identifier) &&


