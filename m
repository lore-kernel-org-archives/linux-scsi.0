From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: mpt2sas logged messages
Date: Tue, 18 Aug 2009 11:09:28 -0500
Message-ID: <1250611768.6971.6.camel@mulgrave.site>
References: <4A8AAA26.9090706@redhat.com> <20090818132518.GA4418@kroah.com>
	 <4A8AB3DC.4060805@redhat.com> <20090818145710.GA6064@kroah.com>
	 <4A8ACE7C.5080501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46285 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbZHRQJf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 12:09:35 -0400
In-Reply-To: <4A8ACE7C.5080501@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, Tom Coughlan <coughlan@redhat.com>

On Tue, 2009-08-18 at 11:53 -0400, Ric Wheeler wrote:
> On 08/18/2009 10:57 AM, Greg KH wrote:
> > On Tue, Aug 18, 2009 at 09:59:56AM -0400, Ric Wheeler wrote:
> >    
> >> On 08/18/2009 09:25 AM, Greg KH wrote:
> >>      
> >>> On Tue, Aug 18, 2009 at 09:18:30AM -0400, Ric Wheeler wrote:
> >>>        
> >>>> We have a new toy to test very large&   slow storage with built up from 5
> >>>> SAS expansion shelves (Promise Vtrak J-Class) with 60 S-ATA drives and
> >>>> 16 SAS drives (the S-ATA drives each have a Promise Vtrak S-ATA MUX
> >>>> adapter daughter card in the disk sled).
> >>>>
> >>>> The basic idea is to build a cheap&   slow test bed for file&   storage
> >>>> system scalability. Collectively, we have about 120TB (raw) of capacity
> >>>> to play with in one server.
> >>>>
> >>>> As we work through various issues, a couple of oddities popped out.
> >>>>
> >>>> The first is that udev grumbles during boot about "file name too long"
> >>>> like the following:
> >>>>
> >>>> Aug 17 06:49:58 megadeth udevd-event[20447]: unable to create db file
> >>>> '/dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:04.0\x2f0000:17:00.0\x2f0000:18:0a.0\x2f0000:1f:00.0\x2fhost11\x2fport-11:0\x2fexpander-11:0\x2fport-11:0:0\x2fexpander-11:1\x2fport-11:1:0\x2fexpander-11:2\x2fport-11:2:17\x2fexpander-11:3\x2fport-11:3:1\x2fend_device-11:3:1\x2fbsg\x2fend_device-11:3:1':
> >>>> File name too long
> >>>>          
> >>> Odd, what is the sysfs tree for this device?  You have expanders
> >>> attached to ports attached to expanders?  How deep can you go?
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>>        
> >> There are two dual-port SAS HBA's in the server that plug into the first of the
> >> 5 SAS expansion shelves. Each shelf has two internal SAS loops and is daisy
> >> chained to the next shelf....  This test is running with just the first 4
> >> shelves active (although that fifth shelf is plugged in, just not used/active).
> >>
> >> Each of the 60 S-ATA disks sits behind a MUX card which lets it appear on both
> >> loops.
> >>
> >> We could break up the shelves into two independent sets of devices which would
> >> limit the tree depth.
> >>
> >> How can I get you the sysfs tree information in a useful way?
> >>      
> > 'tree /sys/devices/'
> > or
> > 'find /sys/devices/'
> > would be good.
> >
> > thanks,
> >
> > greg k-h
> >    
> 
> Attached is the bzipped output from - the uncompressed output is quite 
> large. Note that this same server has CCIS controllers and fibre HBA's 
> as well,

It's perfectly legal the way you have it, but I will say you have an
inefficient configuration.  The way a configuration like this is
supposed to look is that there should be a fanout expander at the top
going to the expander in each tray, for a routing depth of two for every
device.

The way you've got it:  expander daisy chained off the next expander
gives an unnecessary routing delay to the disks furthest away in the
chain.

James


