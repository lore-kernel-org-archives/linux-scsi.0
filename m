From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 10:20:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205201420.g4KEK3x01892@localhost.localdomain>
References: <rabeeh@galileo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA09735
	for <linux-scsi@vger.kernel.org>; Mon, 20 May 2002 07:20:08 -0700
In-Reply-To: Message from Rabeeh Khoury <rabeeh@galileo.co.il>
   of "Mon, 20 May 2002 15:24:52 +0300." <3CE8EB14.8060803@galileo.co.il>
List-Id: linux-scsi@vger.kernel.org
To: Rabeeh Khoury <rabeeh@galileo.co.il>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>

rabeeh@galileo.co.il said:
> 1.. What is meant by "SCSI was not designed for this ..." ? 

That really refers to a very old daisy chained parallel SCSI model.  Since the 
whole bus is a transmission line, breaking it to add another device can cause 
enormous disruption (sometimes this was bad enough to physically destroy other 
devices on the bus).  However, these days, you can even get hotplug enclosures 
for parallel SCSI that don't need to break the bus to add new devices.  And, 
of course, things like Fibre Channel we're designed to be alterable on the fly 
anyway.

> 2.. SCSI architecture model (SAM-2 at least) does not mention
> hot-plugging storage device into a running system ; but doing so is a
> very common task. So, are all the SCSI hot-plug systems in the world
> are based on proprietry methods of hot-plug ?

This is the province of something called the Scsi Enclosure Services (SES) 
standard:

ftp://ftp.t10.org/t10/drafts/ses/ses-r08b.pdf

However, like most standards it began life as a bunch of companies each 
inventing their own more or less proprietary way of doing things and then 
realising that standardisation might be a good thing, so there are quite a few 
not quite compatible implementations of this.

Like all good standards it's also due to be superceded (by SES-2) any day now.

There is an enclosure monitor, which I haven't looked at but which I presume 
could be used as part of a hotplug system for SCSI devices:

http://gort.metaparadigm.com/saftemon/

> 3.. What about the naming of /dev/sdxx naming of newly hot-plugged
> SCSI disk ? which name does it get ? (supposly I'm not using the dev
> filesystem) 

The first available one.

James Bottomley


