From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Time to conclude the Sony USB mass storage thread
Date: Fri, 14 Nov 2003 12:00:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114120048.A4527@beaverton.ibm.com>
References: <1068825146.2134.6.camel@mulgrave> <20031114092644.A2794@beaverton.ibm.com> <20031114093503.B19467@one-eyed-alien.net> <20031114095823.A3597@beaverton.ibm.com> <20031114105212.C19467@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:12461 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262197AbTKNUBD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 15:01:03 -0500
Content-Disposition: inline
In-Reply-To: <20031114105212.C19467@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Fri, Nov 14, 2003 at 10:52:12AM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 14, 2003 at 10:52:12AM -0800, Matthew Dharm wrote:

> It's not immediately clear how we can override it if it's
> scsi_devinfo/dev_flags.  Can you elaborate?

The same way you can set it is the same way it can be cleared.

If we want to allow all standard scsi core usage, as if there were not
special flag settings at all, and including using MODE SENSE 6, use
("model" is synonymous with SCSI product):

	echo "vendor:model:0" > /proc/scsi/device_info

If we want MODE SENSE 10, default cache write through (if the device can't
do MODE SENSE page 8), use BLIST_USE_10_BYTE_MS | BLIST_MS_SKIP_PAGE_08
(0x8000 | 0x2000):

	echo "vendor:model:0xa000" > /proc/scsi/device_info

The above can also be done at boot time or scsi_mod load time, on boot
use:

	scsi_mod.dev_flags=vendor:model:0xa000

For scsi_mod as a module just drop the "scsi_mod." prefix.

The above does not allow us to send a variant of the MODE SENSE, like the
Sony really wants - MODE SENSE with a 10 byte (or larger) buffer - but
that would require a patch like the other one I sent, or command filtering
code, plus other code to enable/disable its use.

We still need a sysfs attribute to eventually replace the proc one - this
should be done by using module_param_call instead of module_param_string
(we need a special callout to parse the string, I did not understand
module_param_call when I added module_param usage), plus code to always
(not just for modules) add sysfs parameters for all module_param entries.

The device specific flags override any other settings - the shost->flags
or the scsi_default_dev_flags. We don't have any deletion method other
than reboot, but the last setting added overrides earlier settings, and so
you can even overide static entries in scsi_devinfo.c.

-- Patrick Mansfield
