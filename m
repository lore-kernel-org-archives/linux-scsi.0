From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 18:12:45 -0400
Message-ID: <446B9FDD.7030800@garzik.org>
References: <1147789098.3505.19.camel@mulgrave.il.steeleye.com> <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com> <4469F9FB.7020807@garzik.org> <1147797507.3505.52.camel@mulgrave.il.steeleye.com> <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de> <446B3BE0.8040806@garzik.org> <1147881002.3463.23.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0605171036140.10823@g5.osdl.org> <20060517175541.GT4197@suse.de> <Pine.LNX.4.64.0605171455050.10823@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0605171455050.10823@g5.osdl.org>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 17 May 2006, Jens Axboe wrote:
>> Some devices need serialization between them, and the only way to
>> achieve that currently is by sharing a queue.
> 
> Hmm? No. We share the queue for some things, but the most _common_ example 
> of a device that needs serialization between queues is IDE, and we don't 
> share queues there. We have independent queues, they just end up sharing 
> certain infrastructure (tags and locking).

Strongly agreed.

Note that libata uses independent queues, but serializes access to them. 
  This is the sort of "group of queues" infrastructure I find helpful.


> But they _are_ independent, and you can have different elevators, 
> different merging rules, and even different request functions for the 
> different queues - even if they also have some things they share.

Yep.


> And yes, you can see an ATA host as a host in the SCSI sense, but I wanted 

Actually libata presents one Scsi_Host per SATA port on each controller, 
FWIW :)  So the Scsi_Host notion WRT queues _is_ limiting, which is the 
reason why I refer to "group of queues".

	Jeff


