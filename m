From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Thu, 23 Apr 2009 07:00:54 -0400
Message-ID: <49F04A66.4080303@garzik.org>
References: <20090422090929.GA14928@havoc.gtf.org> <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34808 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZDWLA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 07:00:58 -0400
In-Reply-To: <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Grant Grundler wrote:
> On Wed, Apr 22, 2009 at 2:09 AM, Jeff Garzik <jeff@garzik.org> wrote:
>> Currently, libata creates a Scsi_Host per port.  This was originally
>> done to leverage SCSI's infrastructure to arbitrate among master/slave
>> devices, but is not needed for most modern SATA controllers.   And I
>> _think_ it is not needed for master/slave if done properly, either.
>>
>> The patch below converts libata such that there is now a 1:1
>> correspondence between struct Scsi_Host and struct ata_host.  ATA ports
>> are represented as SCSI layer 'channels', which is more natural.
> 
> Jeff,
> So far in reading this, the only reasons I gather for changing this
> mapping are "not needed" and "is more natural". Data Center
> environments (not just Google's) like to track disks in many different
> ways, including the SCSI identifiers since this one "key" for physical
> location. Breaking the current mappings is going to cause some people
> a world of pain since they will need to manually build (and integrate)
> old->new maps of the SCSI identifiers. Can you propose some real,
> tangible benefit to making this change? (e.g. enables some other
> feature)

Sure there are compat issues, just like there are compat issues with the 
existing consensus goal of moving libata to the block layer -- part of 
which implies that ATA disks would be served via a "native" block device 
rather than drivers/scsi/sd.c.

So at least to me, it is axiomatic that these issues will be examined.

As to benefits, the phrase "more natural" means the code naturally 
aligns with existing object topologies (ata_host becomes analagous to 
Scsi_Host), which always has a long list of technical benefits.

- we get to remove all the ugly hacks currently in place that assume 
ata_port is _the_ first class object.
- we get to remove all the workarounds where SCSI assumes it manipulates 
all devices on a controller (not true in current libata)
- SCSI (soon block) host-wide busy, block etc functionality now works as 
expected
- it makes the libata conversion from SCSI to block layer easier
- it makes integration with SAS+SATA devices such as mvsas or ipr easier
- the list goes on; that is just off the top of my head, before my 
morning Mountain Dew

"more natural" also solves a longstanding user confusion/complaint about 
libata:  users expected that libata would export each ATA "channel" 
(bus) as a SCSI channel.


> Mark already pointed out this might cause issues with Error Handling
> (forcing a review of all that code). So before triggering other
> developers (e.g. HW vendors) do that kind of work I'd like to hear
> what the reward is going to be at the end.

Are you aware that EH is already receiving a stream of updates, moving 
it from SCSI to the block layer?  This area has been in constant motion 
since, well, Tejun arrived and started improving things!  :)

	Jeff




