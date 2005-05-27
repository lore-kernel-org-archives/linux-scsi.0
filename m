From: Douglas Gilbert <dougg@torque.net>
Subject: Re: libata, SCSI and storage drivers
Date: Fri, 27 May 2005 16:45:38 +1000
Message-ID: <4296C212.4030703@torque.net>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de> <4292D37C.5020700@pobox.com> <20050524071320.GW9855@suse.de> <42968AC9.60705@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <42968AC9.60705@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Jens Axboe wrote:
> 
>> On Tue, May 24 2005, Jeff Garzik wrote:
>>
>>> Jens Axboe wrote:
>>>
>>>> On Tue, May 24 2005, Jeff Garzik wrote:
>>>>
>>>>> I can describe how this will look when libata is divorced from 
>>>>> SCSI, if you would like, too...
>>>>
>>>>
>>>> I was beginning to dispair you had given up that plan...
>>>
>>>
>>> hehe, nope.  I promised Linus, and I plan to keep my promise :)
>>
>>
>>
>> You promised me, too :)
>>
>>
>>> I know how to do it.  Internally things have been kept as separate as 
>>> possible from the SCSI layer.
>>
>>
>>
>> We should start a list of items that could potentially be moved to the
>> block layer that libata currently uses.
> 
> 
> 
> Here are the two broad categories of things that immediately come to mind.
> 
> 
> 1.  Hardware in pre-production right now can do SAS or SATA on the same 
> card.  So, real soon, a driver will need to do both SCSI and ATA 
> depending on runtime conditions.
> 
> The SCSI transport class is a very nice way to connect low-level drivers 
> and the class drivers (disk/cdrom/tape/...).  It works well with the 
> device model, and is modular in just the right location.
> 
> I would like to develop ATA transport class(es).  In order to work well 
> with SATA/SAS hardware, there will need to be at least one.
> 
> And as I hoped you have guessed.....  the ATA transport class should be 
> a child of the block layer, not the SCSI layer.

Jeff,
Yes, the SAS HBAs that I'm aware of can connect to
SATA I/II disks "directly" on their phys.

So here are two scenarios for connecting SATA disks:

a)
  SAS HBA < -------------------------> SATA disk

b)
  SAS HBA <------>SAS_expander<------> SATA disk

In a) the interconnect is SATA. Still it is hard
to believe that the SAS HBA LLD would belong to
anything other than the SCSI subsystem (since
SAS HBAs come with 4 or 8 phys, others of which could
be in scenario b) and/or connected to SAS disks).
Hence the initiator_ports/phys/target_ports on and
seen by that SAS HBA should (also) have SAS transport
classes.

When a SAS HBA phy is not connected to anything is it
a member of a SAS transport class or a ATA transport
class (or both)?

In scenario b) the left interconnect is SAS and the
right interconnect is SATA. The SAS_expander contains
the STP<->SATA bridging function (and, for sake of
argument, no SCSI-ATA Translation (SAT) layer).
Would scenario b) also have a ATA transport
class? I'll assume it does. To be discovered it also
needs a SAS transport class. Larger enclosures are
likely to be amplifications of scenario b). The presence
of the SATA disk in scenario b) will be discovered via
the SAS SMP (i.e. talking to the SAS_expander) or via
the SES protocol (i.e. a SCSI Enclosure Services target
running near the SAS_expander). Either way if there are
a lot of SATA disks then they are likely to be held
in their initialization sequence to stop them spinning
up all at once. SAS transport intervention may be
required (staggered timers are another possibility).

Now I may be wrong but I think that one of the SAS HBAs
that I have read about that looks (externally) like
scenario a) but is actually scenario b). In other words
the SAS_expander is silicon on the HBA and it is not
controlled via the PCI bus, but rather by SMP.

This suggests to me we would need an ordered sequence of
transport classes. I really wonder about trying to model
this level of complexity in sysfs, plus the nightmare of
keeping state data of (topologically) distant nodes up
to date. At some point one needs to supply a management
pass through and hand the problem over to the user
space. The question is, at what point.


There are already FCP enclosures filled with SATA disks
on the market so this problem in not unique to SAS.
However they have (I presume) a SAT layer in their
FC enclosures so the OS thinks it is taking to SCSI
disks.

Doug Gilbert



