From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 12:52:40 -0400
Message-ID: <49EF4B58.8000204@garzik.org>
References: <20090422090929.GA14928@havoc.gtf.org> <49EF16F5.5080909@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49EF16F5.5080909@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>> Currently, libata creates a Scsi_Host per port.  This was originally
>> done to leverage SCSI's infrastructure to arbitrate among master/slave
>> devices, but is not needed for most modern SATA controllers.   And I
>> _think_ it is not needed for master/slave if done properly, either.
>>
>> The patch below converts libata such that there is now a 1:1
>> correspondence between struct Scsi_Host and struct ata_host.  ATA ports
>> are represented as SCSI layer 'channels', which is more natural.
>>
>> This patch is an experiment, and not meant for upstream anytime soon.
> ..
> 
> Could you perhaps explain how error handling would behave in this scheme?
> 
> Currently, one SATA port can have failures without any impact whatsoever
> on concurrent operation of other ports, in part because each port is 
> treated
> as a completely independent SCSI host.
> 
> I wonder if that changes with the new (better) scheme proposed here?

It changes, yes, most definitely.  We just have to pay close attention, 
and make sure to indicate which EH actions are host-wide, channel-wide 
(== per port, in ATA parlance) or per-device.

SCSI handles all these cases, because e.g. you might not want to disrupt 
all 1,000 SAN devices actively talking to a single SCSI host in Linux.

So...  error handling should behave how it needs to behave ;-)

There might be an issue with concurrent error handling, because of 
potential sharing of EH threads (== one port's EH must wait for 
another's, I think)....but not with concurrent and independent 
operation.  You should be able to reset an AHCI port without affecting 
data xfer on the other ports.

	Jeff



