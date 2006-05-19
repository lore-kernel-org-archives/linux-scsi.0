From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] printks in print_inquiry
Date: Fri, 19 May 2006 13:08:48 -0600
Message-ID: <20060519190848.GA2826@parisc-linux.org>
References: <20060511150015.GJ12272@parisc-linux.org> <20060512170854.GA11215@us.ibm.com> <20060513050059.GR12272@parisc-linux.org> <20060518183652.GM1604@parisc-linux.org> <20060518200957.GA29200@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44239 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932471AbWESTIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 15:08:49 -0400
Content-Disposition: inline
In-Reply-To: <20060518200957.GA29200@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, May 18, 2006 at 01:09:57PM -0700, Patrick Mansfield wrote:
> > scsi: 2:0:1:0: Vendor: HP 18.2G Model: ATLAS10K3_18_SCA Rev: HP05 ANSI rev: 02  
> That is very nice ... as is replacing print_inquiry with one line of code.

Thanks.  However, I'm now wondering about the length of the line.
Aren't people agitating to replace the channel with a string?  which
could be longer than the, oh, three bytes left after the end of the
current string?  Losing the scsi: isn't really a good idea.  So how
about:

scsi: 2:0:1:0 Device: HP 18.2G ATLAS10K3_18_SCA HP05 ANSI 02
scsi: 4:0:2:0 Device: HP       DVD-ROM 305      1.01 ANSI 02

If we really wanted to be smart, we could even do:

scsi: 2:0:1:0 Direct-Access      HP 18.2G ATLAS10K3_18_SCA HP05 ANSI 02
scsi: 4:0:2:0 CD-ROM             HP       DVD-ROM 305      1.01 ANSI 02

I'm still in two minds about even reporting the ANSI version.  Is there
ever a time when having that information would be useful to debug a
problem *and* we don't have access to that (eg through sysfs)?

> > sda: 35566480 512-byte hdwr sectors (18210 MB)
> > sda: Write Protect is off
> > sda: drive cache: write through w/ FUA
> >  sda: sda1 sda2 sda3
> > sd 2:0:1:0: Attached scsi disk sda
> > sd 2:0:1:0: Attached scsi generic sg0 type 0
> 
> Yes, better. I guess those should all be sdev_printk in sd.c.

Not sure I agree, actually.  A lot of these things pertain much more to
the sda-ness of the device than they do to the 2:0:1:0'ness of the device.

> Funky how loading sd after sg changes the output ... and using the driver
> name as a prefix sometimes messes this up for scsi.
> 
> i.e. scan without sd_mod or sg loaded (and distro I'm using loads sg
> before sd_mod via udev rules):
> 
>  0:0:0:0: Attached scsi generic sg0 type 0
>  0:0:0:1: Attached scsi generic sg1 type 0
> 
> Then remove/add those devices, and sg lines become:
> 
> sd 1:0:0:0: Attached scsi generic sg0 type 0
> sd 1:0:0:1: Attached scsi generic sg1 type 0

I'm going to reply to this in a separate email, as I think we need
buy-in from Greg on this one.

> It is the only place that we modify the inquiry result, and I thought it
> was gross and (a bit) confusing.

I agree, nice patch, makes much more sense.
