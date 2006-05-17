From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 12:05:25 -0400
Message-ID: <446B49C5.9080107@torque.net>
References: <4468B596.9090508@garzik.org> <1147789098.3505.19.camel@mulgrave.il.steeleye.com> <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com> <4469F9FB.7020807@garzik.org> <1147797507.3505.52.camel@mulgrave.il.steeleye.com> <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de> <446B3BE0.8040806@garzik.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13270 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750736AbWEQQGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 12:06:00 -0400
In-Reply-To: <446B3BE0.8040806@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Jeff Garzik wrote:
> Jens Axboe wrote:
> 
>> On Tue, May 16 2006, Jeff Garzik wrote:
>>
>>> James Bottomley wrote:
>>>
>>>> On Tue, 2006-05-16 at 12:12 -0400, Jeff Garzik wrote:
>>>>
>>>>> Its an API-which-only-libata-uses that we're discussing.  And
>>>>> because its moving to the block layer, its also a
>>>>> temporary-API-which-only-libata-uses.
>>>>
>>>> OK ... this may be the root of the problem.  I really would like libata
>>>> to migrate to being block only ... especially as PATA looks to be
>>>> trying
>>>> to follow you into the SCSI subsystem.  However, this has been the
>>>> statement for the past two years (at least), and really, few
>>>> enhancements have been made to block that you need to make good on
>>>> this.
>>>> I think one of the things we'll try to find time to do at the storage
>>>> summit is to take a hard look at block to see exactly what has to be
>>>> added to make libata solely dependent upon it.
>>>
>>> 100% agreed...
>>
>>
>> Ditto! I'd be more than willing to implement some of these features (and
>> already started to, the per command timeout for instance), but I was
>> starting to write off libata moving to block as a silly pipe dream in
>> all honesty... But if momentum is picking up behind this move, then I'll
>> all for it.
> 
> 
> Just gotta be patient.  Rome wasn't built in a day, and all that :)
> 
> Like I mentioned in another message, the ideal world is that libata uses
> an ATA disk driver and a SCSI MMC driver -- just like a modern SAS
> controller (which likely supports SATA too) will use both an ATA disk
> driver and a SCSI disk driver.
> 
> Given this "ideal world", its IMO best that the "storage driver"
> infrastructure lives in the block layer not SCSI layer.

LSI have chosen to put a SAT layer in the HBA firmware
of their MPT fusion SAS cards. This makes both directly
connected SATA disks (not strictly speaking SAS) and
expander connected SATA disks (using the STP protocol)
look like SCSI devices to the OS. Interestingly LSI have
chosen not to implement the ATA PASSTHROUGH scsi commands
at this time. That makes the job of smartmontools
difficult.

More generally if you start putting SATA disks in a
multi-initiator fabric (FC or SAS) then there are
issues that need to be addressed. One issue is
when two initiators try to access a SATA disk at
around the same time. SAS has optional "affiliations"
for protecting individual SATA commands but I'm
unaware of anything like SCSI's persistent reservations.
In the case of SAS affiliations, as far as I can
see, some additional help is needed via SAS's
management protocol (SMP). Command queueing (at
the disk) is another issue.

A SAT layer in the OS (e.g. like libata) may not
be able address these issues, but a SATL in (or
aware of) the transport might.

So the point I'm making is the appropriate command
set(s) for a hard disk not only depends on what the
device itself talks, but also the way in which
it is connected.

libata demonstrates that it is viable to use both
the SCSI commands (for data) and SATA commands
(for maintenance) on the same SATA device.

Doug Gilbert
