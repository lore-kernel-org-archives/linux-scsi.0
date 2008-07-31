From: James.Smart@Emulex.Com
Subject: RE: SCSI device rescan, detection of disconnected device,or	switched devices.
Date: Thu, 31 Jul 2008 13:51:21 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F54A@xbl3.ma.emulex.com>
References: <1217248348.4133.51.camel@galr-linux> <488DC55C.2050603@s5r6.in-berlin.de> <1217487434.25491.34.camel@galr-linux> <4891792C.6020304@s5r6.in-berlin.de> <1217504895.25491.69.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46045 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYGaRvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 13:51:36 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: galr@storwize.com, stefanr@s5r6.in-berlin.de
Cc: linux-scsi@vger.kernel.org

 

> -----Original Message-----
> This is true; when the remote port is no longer exists, after timeout
> all the sg devices will disappear, but what if I am changing the
> configuration in the disk array, and remove only one logical device.
> There will not be any event for that. The hotplug 
> implementation in the
> SCSI today creates events of add/remove when adding/removing HBA, or
> when the FC link go down and up again, but not for additional and
> removal of devices. In the linux documentation in scsi_mid_low_api.txt
> it is written that "The hotplug concept may be extended to SCSI
> devices". I guess that nobody implemented it because what you said
> previously in this thread that someone could hold reference to the
> device.
> I think that I understand the concept. When the FC port is 
> going down/up
> you get interrupt, so you can remove all devices or initiate scsi scan
> and add devices. 

True - Target-level add or remove usually generates transport events, 
which allow the transports to detect it.

SCSI-Lun-level add/remove doesn't. Well.. it could, as there is a check
condition code that can be generated to report configuration change, and
in some transports, there's Async Event Notification (AEN) -- BUT --
no one really does AEN, and not all arrays generate the Chk Condition,
and even if it did, our midlayer doesn't act on it.  And even if the 
midlayer did act on it, we would have to add device identifier
recognition
into the equation, which we don't do today, and leave it up to udev.
It's not a simple thing to add...

> But when device is added you can't get any event,
> because this device is not known to the client yet (no body is working
> with it), all you can do is to initiate scan every once a while. For
> removing a device there is a possibility to do it 
> automatically. The LLD
> can identify that the device is not ready, and then call to the mid
> layer to remove this device. It will succeed only if nobody 
> is holding a
> reference to that device.
> 
> Gal.

Yep - with the addition of the device identifier part.

-- james s
