From: Hannes Reinecke <hare@suse.de>
Subject: Re: aic79xx noise on hot insert in 2.6.19.x and 2.6.20
Date: Wed, 07 Feb 2007 11:10:53 +0100
Message-ID: <45C9A5AD.3010102@suse.de>
References: <C33207EA-8376-4A2F-828C-23B00327C42D@gmail.com> <45C995D0.70108@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060701070402050600020601"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030618AbXBGKK5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 05:10:57 -0500
In-Reply-To: <45C995D0.70108@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@gmail.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060701070402050600020601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Darrick J. Wong wrote:
> Mark Rustad wrote:
>> I have systems with Supermicro X6-class (Nocona/Lindenhurst)
>> motherboards with Adaptec SCSI and SAFTE backplanes running software
>> RAID-1 (md) on a pair of drives. When I hot-insert a drive, I get a lot
>> of noise from the kernel apparently due to lack of handling something in
>> the interrupt routine. So far, life seems to go on after the event, but
>> not knowing anything about the internals of the driver, I am concerned
>> enough to want to ask about it.
> 
> I see the noise too, though I don't know enough about aic79xx (and am
> too busy with aic94xx) to do anything about it.  As far as I can tell,
> the driver's just being a little trigger happy with the "DUMP CARD
> STATE" routine.  But that's my totally unqualified opinion. :)
> 
Yeah, that's default behaviour with aic79xx. First complain and then
check if it actually was an error.

But anyway, looks like it was actually my fault. Might be an idea to
clear the bus reset flag again.

Care to try the attached patch?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------060701070402050600020601
Content-Type: text/plain;
 name="aic79xx-clear-bus-reset-flag"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-clear-bus-reset-flag"

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 07a86a3..bf073d2 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1645,6 +1645,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 	 */
 	if (((status & SCSIRSTI) != 0) && (ahd->flags & AHD_BUS_RESET_ACTIVE)) {
 		ahd_outb(ahd, CLRSINT1, CLRSCSIRSTI);
+		ahd->flags &= ~AHD_BUS_RESET_ACTIVE;
 		return;
 	}
 

--------------060701070402050600020601--
