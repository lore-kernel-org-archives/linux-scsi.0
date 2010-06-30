From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: aacraid problems on 2.6.35-rc3
Date: Wed, 30 Jun 2010 09:54:22 -0500
Message-ID: <1277909662.2839.17.camel@mulgrave.site>
References: <AANLkTimvQtYPh_6ZeKiGz2-eZf_pVy6N7TwEeXCoq0Iv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab0F3Oy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 10:54:26 -0400
In-Reply-To: <AANLkTimvQtYPh_6ZeKiGz2-eZf_pVy6N7TwEeXCoq0Iv@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-06-30 at 10:28 -0400, Alex wrote:
> Hi,
> 
> I'm trying to compile a kernel with aacraid support on a dual Opteron
> 246 box with two 36GB disks on a Tyan S2891, using an initrd and lilo.
> 
> There is an older kernel on there that works just fine, so I suspect
> it's something I'm missing in the kernel config. No matter what I try,
> the kernel fails to find the disks on the controller. I've even tried
> building it without an initrd and compiling everything into the
> kernel, but it still panics.
> 
> I've included the aacraid support, SCSI disk, SCSI generic, and even
> RAID1/5 support. The controller and motherboard also have the latest
> BIOS updates.
> 
> What else is necessary to support aacraid?
> 
> It only prints the following when booting:
> 
> Adaptec aacraid driver 1.1-5[2456]-ms

That driver comes from a rather old kernel (2.6.29 or before).  Could
you try with a modern version (which should print 1.1-5[26400]-ms just
in case the problem got fixed in the interim.

> Is I2O or ACPI support necessary?

ACPI may be necessary for the driver to attach its interrupt correctly,
but this is a motherboard issue.

> Are there any boot-time options to increase debugging output to
> troubleshoot this?
> 
> The dmesg output from a working system is here:
> 
> http://pastebin.com/0AnVBV7s

This trace shows your system won't configure interrupts correctly
without ACPI ... if ACPI isn't working, more than just the aacraid will
be non functional.  A dmesg of the failing system would be definitive in
diagnosing this.

James


