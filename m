From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: dpt_i2o driver
Date: Tue, 2 Sep 2003 13:26:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0998F43EAD645A47B3F6507196DD70EA256916@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:49062 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S263795AbTIBR1K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 13:27:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

dpt_i2o holds on to the device structures in the `hostdata' areas of the
device in order to speed up TID (I2O Target Identifier) lookup. This code
may be in jeopardy as a result:

 (struct adpt_device*)(cmd->device->hostdata) = pDev;
. . .
 pDev->pScsi_dev = cmd->device;

The pScsi_dev references can disappear, a hotplug reaction to clear this
needs to be registered to free up the double linked references made like
above (this is a plea for help to understand hotplug ;-/ ). Once this double
linked reference is cleared, the busy check report ENODEV which is an
`adequate' response indicating no longer busy.

*This* may help with regards to the DPT_TARGET_BUSY ioctl?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org]
Sent: Tuesday, September 02, 2003 1:15 PM
To: Salyzyn, Mark
Cc: Mark Haverkamp; linux-scsi
Subject: Re: dpt_i2o driver


On Tue, Sep 02, 2003 at 01:10:04PM -0400, Salyzyn, Mark wrote:
> When the device is mounted, should we not have a usage count in the
kernel,
> or are the hotplug events clearing this? Sorry for showing my ignorance of
> the hotplug needs ...

Wach scsi_device has a reference count (actually two currently, but one
will go away).  this is not a traditional usage count because everytime
we do something with the device without holding the protecting lock
we should have one of this references, often temporary.  (We don't do
yet but we will before 2.6.0 is finished).  If the device is marked for
unregistration and the last reference vanishes the device is freed.
So you only have a chance to see a zero refcount if the device isn't
unregistered yet - which is completly useless for monitoring when
it's deleted.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
dpt_i2o holds on to the device structures in the `hostdata' areas of the
device in order to speed up TID (I2O Target Identifier) lookup. This code
may be in jeopardy as a result:

 (struct adpt_device*)(cmd->device->hostdata) = pDev;
. . .
 pDev->pScsi_dev = cmd->device;

The pScsi_dev references can disappear, a hotplug reaction to clear this
needs to be registered to free up the double linked references made like
above (this is a plea for help to understand hotplug ;-/ ). Once this double
linked reference is cleared, the busy check report ENODEV which is an
`adequate' response indicating no longer busy.

*This* may help with regards to the DPT_TARGET_BUSY ioctl?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org]
Sent: Tuesday, September 02, 2003 1:15 PM
To: Salyzyn, Mark
Cc: Mark Haverkamp; linux-scsi
Subject: Re: dpt_i2o driver


On Tue, Sep 02, 2003 at 01:10:04PM -0400, Salyzyn, Mark wrote:
> When the device is mounted, should we not have a usage count in the
kernel,
> or are the hotplug events clearing this? Sorry for showing my ignorance of
> the hotplug needs ...

Wach scsi_device has a reference count (actually two currently, but one
will go away).  this is not a traditional usage count because everytime
we do something with the device without holding the protecting lock
we should have one of this references, often temporary.  (We don't do
yet but we will before 2.6.0 is finished).  If the device is marked for
unregistration and the last reference vanishes the device is freed.
So you only have a chance to see a zero refcount if the device isn't
unregistered yet - which is completly useless for monitoring when
it's deleted.

