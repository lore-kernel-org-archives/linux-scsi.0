From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] scsi_device printk helper macro - sdev_printk -> with patch
Date: Tue, 30 Sep 2003 09:50:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030930095024.A5881@beaverton.ibm.com>
References: <200309291413.51987.dsteklof@us.ibm.com> <3F79740C.5020007@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:47068 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261615AbTI3QvY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2003 12:51:24 -0400
Content-Disposition: inline
In-Reply-To: <3F79740C.5020007@torque.net>; from dougg@torque.net on Tue, Sep 30, 2003 at 10:16:12PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Daniel Stekloff <dsteklof@us.ibm.com>, linux-scsi@vger.kernel.org, Larry Kessler <lkessler@us.ibm.com>, James Keniston <kenistoj@us.ibm.com>

On Tue, Sep 30, 2003 at 10:16:12PM +1000, Douglas Gilbert wrote:

> Dan,
> Looks great.
> We have a fair amount of scsi command and sense decode logic **
> laying idle in drivers/scsi/constants.[hc] that might enhance
> the output further.

I have a patch to log/dump commands using the print_command before sending
(via queuecommand) and after completion.

It can be easily modified to use a sdev_printk, though the two are not
connected.

> Perhaps while we are at it, we could make a more useful logging
> mechanism in the scsi subsystem (rather than, or in addition to,
> 'echo "scsi log ..." > /proc/scsi/scsi'). Putting a
> read/write "log" variable in the /sys/class/scsi_device/*/device
> directory would allow per device logging. [Obviously struct
> scsi_device would get a new "log" member, initialized to 0.]

Writing to /proc/scsi/scsi to enable logging was replaced by sysctl. It's
a bit hard to figure out what bits to set (with 3 bits per area) to get
the logging you want.

The code I have could be easily modified to log based on triggers other
than the scsi_logging_level, but I don't plan on adding any at this time.

> This does not cover the debugging or logging of a device
> scan. In this case scsi_device::log could be inherited from
> somewhere. Since the device might be the first one seen by the
> first host, that "somewhere" would need to be be the scsi mid
> level. Currently the scsi mid level doesn't have a sysfs
> presence. It is obviously a module and also has a pseudo
> device at /proc/scsi/scsi. Any suggestions where a scsi
> mid level device/driver directory could go in sysfs? Such

A permananent area under sysfs rather than a modules-only one like
gregkh's recent patch (posted to lkml) would be nice, that might take care
of any of the current scsi module_param's except for scsi_dev_flags
(devinfo).

devinfo needs to specify a "set" function to parse the scsi_dev_flags.

> ** Sense buffer decoding should be centralized, especially
> since SPC3 has a new (more sane) "descriptor sense data
> format" [SPC-3 rev 15 section 4.5.2 at www.t10.org].

Aren't they already centralized in print_sense and scsi_check_sense?

-- Patrick Mansfield
