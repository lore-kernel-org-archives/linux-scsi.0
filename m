From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 04:25:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071225.EAA29497@adam.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de, linux-scsi@vger.kernel.org

>Okay, we're finally at the point where ->detect has become entirely
>superflous.  In sd, sr and st it does nothing but return different
>values that are ignored anyway, in sg it increments a variable
>that is never read (and thus removed in this patch aswell), only
>in osst it increments a variable that is actually checked for beeing
>non-zero.  But if it was zero we'd never reached that place anyway
>(same check in the beginning of osst_detect and osst_attach).

>This make the upper layer interface a lot nicer and avoids the
>race condition where a device is remove between detect and attach
>(which currently wouldn't matter anyway as we aren't doing anything
>in detect anymore)

	I think we can get cleaner code by *not* doing that.

	If we keep Scsi_Device_Template.detect and just change it so
that it has no side effects like incrementing a counter, then we can
shrink scsi_bus_match, previously a list of special cases, like so
(just typed this code in, haven't tried to compile it):


static int scsi_bus_match(struct device *dev, struct device_driver *drv)
{
	struct Scsi_Device_Template *scsi_dev_tmpl =
		container_of(drv, struct Scsi_Device_Template,
			     scsi_driverfs_driver);
	struct Scsi_Device_Template *scsi_dev =
		container_of(dev, struct Scsi_Device, sdev_driverfs_dev);

	return (*scsi_dev_templ->detect)(scsi_dev);
}

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."
