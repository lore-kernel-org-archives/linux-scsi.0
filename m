From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 03 Mar 2006 10:26:28 -0600
Message-ID: <1141403188.3928.16.camel@mulgrave.il.steeleye.com>
References: <20060303101420.78398.qmail@web31806.mail.mud.yahoo.com>
	 <1141399404.3928.5.camel@mulgrave.il.steeleye.com>
	 <440867B7.70703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:49107 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932118AbWCCQ0g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 11:26:36 -0500
In-Reply-To: <440867B7.70703@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: ltuikov@yahoo.com, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-03-03 at 16:58 +0100, Stefan Richter wrote:
> James Bottomley wrote:
> > Assuming the cages are all powered up, which is beyond
> > the driver control, then serialising the scan will allow one to
> > specify /dev/sda1 deterministically for root.
> 
> Does SAS provide a persistent globally unique property of a device, or
> has SAS to rely on bus topology to uniqely identify devices?

Yes ... naturally; all modern SCSI devices provide a variety of ways of
identifying them. In the fullness of time, I expect udev and initramfs
to support all of these, allowing the user free range of specifications.
I also expect the boot system to provide a timeout (or wait forever)
parameter for delaying before these become visible.  However, none of
these problems are kernel issues.

The problem, currently, isn't really waiting for the root device (which
is well known and solved)  it's that with random ordering you're forcing
the udev method ... which may not be a bad thing, but not one I'm
necessarily willing to push at the moment.  So the intent is to add
enough determinism for most simple SAS boot systems to function on the
current /dev/sd method.  It can be altered later.

James


