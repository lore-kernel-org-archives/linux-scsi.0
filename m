From: Hannes Reinecke <hare@suse.de>
Subject: Re: Overlapped command error handling
Date: Fri, 03 Feb 2006 10:34:50 +0100
Message-ID: <43E323BA.8010604@suse.de>
References: <43E20272.5000506@suse.de> <1138893147.3363.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060909050704090205040706"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:64444 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932155AbWBCJex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2006 04:34:53 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id CB0381BB26
	for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2006 10:34:50 +0100 (CET)
In-Reply-To: <1138893147.3363.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060909050704090205040706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

James Bottomley wrote:
> On Thu, 2006-02-02 at 14:00 +0100, Hannes Reinecke wrote:
>> It looks to me as if the device has aborted _both_ commands when
>> returning the 'overlapped commands attempted' sense.
>> Is that conformant behaviour?
>>
>> SCSI-2 states in section 7.5.2:
>> A target that detects an incorrect initiator connection shall abort al=
l
>> I/O processes for the initiator on the logical unit or target routine
>> and shall return CHECK CONDITION status. The sense key shall be set to=

>> ABORTED COMMAND and the additional sense code shall be set to OVERLAPP=
ED
>> COMMANDS ATTEMPTED.
>=20
> Actually, I think it's probably complaining about tag reuse in the sens=
e
> of SAM-3 section 5.9.3.  You return this sense if an initiator attempts=

> to use a duplicate tag.  Since the aic79xx manges its own tags, then
> it's probably a driver error.  You could verify this by having the
> aic79xx print out the tag as it sends the command out on the wire.  (Th=
e
> device does support TCQ, doesn't it?)
>=20
Argl. Been bitten by the classical 'I know better than thou' attitude.

drivers/scsi/aic7xx/aic79xx_osm.c:ahd_platform_set_tags()
	default:
		/*
		 * We allow the OS to queue 2 untagged transactions to
		 * us at any time even though we can only execute them
		 * serially on the controller/device.  This should
		 * remove some latency.
		 */

but as we also removed the aic7xxx internal timeout handling this means
that the queue_depth is always '2', hence the midlayer might attempt to
send two command simultaneously to the device.
Which is what it did in my case. And, surprisingly enough, setting the
queue depth for the non-TCQ case to '1' fixed the issue.

Can someone explain to my how having a queue depth of '2' in the non-TCQ
case can be correct?
If not, please apply the following patch. Oh, and aic7xxx suffers from
the same problem, naturally.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------060909050704090205040706
Content-Type: text/plain;
 name="aic79xx-disable-tcq-fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-disable-tcq-fix"

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 78c8338..b9e3776 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1346,25 +1346,15 @@ ahd_platform_set_tags(struct ahd_softc *
 
 	switch ((dev->flags & (AHD_DEV_Q_BASIC|AHD_DEV_Q_TAGGED))) {
 	case AHD_DEV_Q_BASIC:
-		scsi_adjust_queue_depth(sdev,
-					MSG_SIMPLE_TASK,
-					dev->openings + dev->active);
+		scsi_set_tag_type(sdev, MSG_SIMPLE_TASK);
+		scsi_activate_tcq(sdev, dev->openings + dev->active);
 		break;
 	case AHD_DEV_Q_TAGGED:
-		scsi_adjust_queue_depth(sdev,
-					MSG_ORDERED_TASK,
-					dev->openings + dev->active);
+		scsi_set_tag_type(sdev, MSG_ORDERED_TASK);
+		scsi_activate_tcq(sdev, dev->openings + dev->active);
 		break;
 	default:
-		/*
-		 * We allow the OS to queue 2 untagged transactions to
-		 * us at any time even though we can only execute them
-		 * serially on the controller/device.  This should
-		 * remove some latency.
-		 */
-		scsi_adjust_queue_depth(sdev,
-					/*NON-TAGGED*/0,
-					/*queue depth*/2);
+		scsi_deactivate_tcq(sdev, 1);
 		break;
 	}
 }

--------------060909050704090205040706--
