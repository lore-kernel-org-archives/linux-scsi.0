From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Mon, 27 Oct 2003 09:16:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031027091655.B4263@vienna.EGENERA.COM>
References: <20031021165857.A8240@beaverton.ibm.com> <1067031185.4772.48.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:31148 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S263137AbTJ0OTH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 09:19:07 -0500
Content-Disposition: inline
In-Reply-To: <1067031185.4772.48.camel@persist.az.mvista.com>; from sdake@mvista.com on Fri, Oct 24, 2003 at 02:33:05PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-hotplug-devel@lists.sourceforge, linux-scsi@vger.kernel.org

Hi,

Rumor has it that on Fri, Oct 24, 2003 at 02:33:05PM -0700 Steven Dake said:
> 
> On Tue, 2003-10-21 at 16:58, Patrick Mansfield wrote:
> > Attached is version 0.1 of scsi_id, a program to generate a SCSI unique
> > identifier for a given SCSI device.
> > 
> > It is primarily for use with udev callout config entries. It could also be
> > used for automatic multi-path configuration.
> > 
> Patrick,
> Here is a quick hack I wrote to do automatic multipath configuration
> some time ago.  It works with devfs only but could be modified by
> someone interested to work with other device names.
> 
> It also uses the extended inquiry page 83 to retrieve a IEEE id.
> 

In my experience code page 0x83 by itself is not always enough. There 
are high-end devices that don't return the results correctly. This leads 
to false negatives (which are safer than false positives, of course, but 
make multipath useless). I think in all of these auto-mp detection schemes 
there needs to be some mechanism for dealing with the quirks of different 
machine types. In userspace it should not be hard to have a table of some 
kind to tell such programs how to compare the results. This can also depend 
on how the system is configured as well so that adds another level of 
complexity.

Code page 0x80 does work for this array, modulo the FA port number which 
can be exposed as part of the serial number, making them look "too" unique.

I haven't gotten to try either of these programs. (Our systems have neither
devfs nor kernel 2.6). However, I've had to develop a home-grown automatic 
multipath driver and have had to deal with all of these issues. I'd very 
much like to be able to use the native Linux multipathing in the future.
So, to that end I thought I'd jump in here and offer my 2 cents.

Cheers,

Phil


> Cheers
> -steve
> 
> > It generates and uses a temporary dev entry based on the values found in
> > sysfs dev attributes. This means it does not support SCSI drivers that do
> > are not currently creating dev entries (st or sg). In addition, for this
> > to function with st (assuming you have a tape drive that supports page 0x80
> > or page 0x83) st would have to support SG_IO.
> > 
> > It uses the SG_IO ioctl to send SCSI INQUIRY page 0x80 or page 0x83
> > commands to the SCSI device.
> > 
> > Requires:
> > 
> > - Linux kernel 2.6
> > 
> > - libsysfs 
> > 
> > No man page yet.
> > 
> > libsysfs 0_2_0 was not installing libsysfs.h or dlist.h, manually copy
> > those files to /usr/include/sys before compiling.
> > 
> > Build via make and make install.
> > 
> > To use with udev, in short:
> > 
> > Run scsi_id to dump a value, for example, for sda, run:
> > 
> > 	scsi_id  -s /block/sda
> > 
> > Take the resulting value (including white space) and use it as the ID in a
> > udev CALLOUT entry, an exmample /etc/udev/namedev.config entry for one of
> > my disk drives:
> > 
> > CALLOUT, PROGRAM="/sbin/scsi_id" BUS="scsi", ID="SIBM OEM DCHS09X 68078621" NAME="disk-1"
> > 
> > I have not tried using scsi_id (or udev) via initramfs or initrd.
> > 
> > Please send me any questions, comments or patches.
> > 
> > Thanks!
> > 
> > -- Patrick Mansfield



-- 
Philip R. Auld, Ph.D.                  Technical Staff 
Egenera Corp.                        pauld@egenera.com
165 Forest St., Marlboro, MA 01752       (508)858-2600
