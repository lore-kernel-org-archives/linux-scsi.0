From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] sgbind
Date: Wed, 14 May 2003 17:05:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514170510.A16882@beaverton.ibm.com>
References: <3EC2379C.4010709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:21644 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263182AbTENX4s
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 19:56:48 -0400
Content-Disposition: inline
In-Reply-To: <3EC2379C.4010709@torque.net>; from dougg@torque.net on Wed, May 14, 2003 at 10:33:32PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Wed, May 14, 2003 at 10:33:32PM +1000, Douglas Gilbert wrote:

> Here is the additional code in the sg header:
> 
> /* sgbind support, for device scanning via /dev/sgbind */
> #define SGBIND_ATTACH 0x22a0
> #define SGBIND_DETACH 0x22a1
> #define SGBIND_ADD_LU 0x22a2
> #define SGBIND_REMOVE_LU 0x22a3

> The SGBIND_ADD_LU and SGBIND_REMOVE_LU ioctls are simply
> programmatic interfaces to the code behind "scsi add-single-device"
> and "scsi remove-single-device". [Code was moved from scsi_proc.c
> to scsi_scan.c so that these ioctls don't require procfs to be
> configured.]

Calling the current scsi_probe_and_add_lun defeats the user level scanning
- at least what I had in mind, that is, using sgbind to send the INQUIRY
and all other SCSI commands currently sent via calling
scsi_probe_and_add_lun.

I was thinking more along the lines of using scsi_add_lun or similiar
code, and/or allowing modification of appropriate scsi_device values from
user land - like borken, single_lun etc.

So in user land we could SGBIND_ATTACH (to a non-existent device), send an
INQUIRY, if the INQUIRY worked (like current scan code when we call
scsi_add_lun) then use an sgbind interface to add (SGBIND_ADD_LU or such)
this scsi_device.

The SGBIND_ADD_LU would at a minimum call scsi_device_register, so we
would then have sysfs interfaces available. If we passed in the inquiry
result, we might be able to just call scsi_add_lun, but exposing and
setting scsi_device sysfs attributes (like single_lun, borken, etc.; a
scsi_device.bflags might make this easier) would be more flexible.

Maybe this is too much to ask for in 2.5, though exposing interfaces that
are only used via sgbind would not be dangerous.

> To test this further I believe there should be a new
> field in the Scsi_Host and Scsi_Host_Template structures
> called something like 'no_scan'. Default is 0 for
> existing mid level scanning. A value of 1 instructs
> the scsi_scan.c to ignore this host.

You can always test by removing an existing device, or using scsi_debug.

If we want to allow both in kernel and user level scanning, we would need
a global scsi value, not just per host, a boot time or user settable value
would work nicely. I don't think we have anyplace for global scsi sysfs
attributes.

-- Patrick Mansfield
