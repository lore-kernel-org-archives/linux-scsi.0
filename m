From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: dpt_i2o driver
Date: Tue, 2 Sep 2003 18:34:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902183408.A14487@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA256916@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:52237 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263829AbTIBReP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 13:34:15 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA256916@OTCEXC01>; from mark_salyzyn@adaptec.com on Tue, Sep 02, 2003 at 01:26:53PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Sep 02, 2003 at 01:26:53PM -0400, Salyzyn, Mark wrote:
> dpt_i2o holds on to the device structures in the `hostdata' areas of the
> device in order to speed up TID (I2O Target Identifier) lookup. This code
> may be in jeopardy as a result:
> 
>  (struct adpt_device*)(cmd->device->hostdata) = pDev;
> . . .
>  pDev->pScsi_dev = cmd->device;

That is bad indeed and I still need to audit all drivers for issues
like that.  Either we kill this cache (I need to take a look at the
actual code). OR you need to grab a reference using scsi_device_get
when you store it and release it in your ->slave_destroy method that's
called when the device is marked deleted.

> The pScsi_dev references can disappear, a hotplug reaction to clear this
> needs to be registered to free up the double linked references made like
> above (this is a plea for help to understand hotplug ;-/ ). Once this double
> linked reference is cleared, the busy check report ENODEV which is an
> `adequate' response indicating no longer busy.

Why do you need an ioctl then?  Just wait for the sysfs file to
disappear..

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
On Tue, Sep 02, 2003 at 01:26:53PM -0400, Salyzyn, Mark wrote:
> dpt_i2o holds on to the device structures in the `hostdata' areas of the
> device in order to speed up TID (I2O Target Identifier) lookup. This code
> may be in jeopardy as a result:
> 
>  (struct adpt_device*)(cmd->device->hostdata) = pDev;
> . . .
>  pDev->pScsi_dev = cmd->device;

That is bad indeed and I still need to audit all drivers for issues
like that.  Either we kill this cache (I need to take a look at the
actual code). OR you need to grab a reference using scsi_device_get
when you store it and release it in your ->slave_destroy method that's
called when the device is marked deleted.

> The pScsi_dev references can disappear, a hotplug reaction to clear this
> needs to be registered to free up the double linked references made like
> above (this is a plea for help to understand hotplug ;-/ ). Once this double
> linked reference is cleared, the busy check report ENODEV which is an
> `adequate' response indicating no longer busy.

Why do you need an ioctl then?  Just wait for the sysfs file to
disappear..

