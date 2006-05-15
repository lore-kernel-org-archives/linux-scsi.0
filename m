From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Hotplug does not work with Fusion MPT
Date: Mon, 15 May 2006 10:04:01 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D700F9EEA@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:47851 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750788AbWEOQED convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 12:04:03 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Maik Hampel <Maik.Hampel@xiranet.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Monday, May 15, 2006 9:52 AM,  Matthew Wilcox wrote:
> 
> On Mon, May 15, 2006 at 09:04:52AM -0600, Moore, Eric wrote:
> > On Monday, May 15, 2006 7:44 AM, Matthew Wilcox wrote:
> > > Did you tell Linux you removed it?  Try:
> > > 
> > > echo scsi remove-single-device 0 0 4 0 > /proc/scsi/scsi
> > > 
> > > Parallel SCSI doesn't have a way to notify the OS that a 
> > > device is gone,
> > > so the user has to say.
> > 
> > We have Hotplug device support in fustion drivers for SAS 
> and Fibre, not
> > for SPI.
> 
> Erm.  Are you saying it doesn't work?  Or you just don't test it?
> If the user runs the above command, the host's 
> ->slave_destroy is called.
> The mptspi slave_destroy method looks like it works.  What's 
> the problem?
>

Yes, what you suggested does work.  I wasn't disagreeing with that.

What I was saying as with SAS and FC, our firmware sends events to the
driver which tells when devices are pulled or pushed. When that event
occurs,
we call functions in the transport layers that handle hotpluging the
device
automatically, that doesn't require an enduser to echo something into
the /proc or /sysfs.

As for SPI, there are not events that notifiy the driver when a device
is pulled or pushed.  Therefore you will need to do what you suggested.

Eric 
