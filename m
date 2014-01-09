From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Thu, 09 Jan 2014 13:29:53 -0500
Message-ID: <52CEEAA1.2010904@interlog.com>
References: <Pine.LNX.4.44L0.1401071015120.1296-100000@iolanthe.rowland.org> <52CC1FF2.1020301@ubuntu.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:60051 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977AbaAISaV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jan 2014 13:30:21 -0500
In-Reply-To: <52CC1FF2.1020301@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 14-01-07 10:40 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 1/7/2014 10:20 AM, Alan Stern wrote:
>> This raises two questions:
>>
>> Should the host's resume be allowed to complete while the host is
>> still in error recovery?  Wouldn't it be better to wait until the
>> recovery is finished?
>
> Ahh, right, my other patch changed the ata_port stuff to schedule the
> eh, and return  from resume, so that IT doesn't block the system
> resume path for a long period of time while IT tries to spin up the
> disk.  Both the libata and sd layers were spinning up the disk.
>
> Still, the sd request should just wait in the queue until after the
> recovery completes shouldn't it?
>
>> How does the queue end up in a stopped state?  (The stopped queue
>> explains why blk_peek_request returns NULL.)
>
> I was guessing that was the cause from reading the code, after
> stepping through it with gdb and qemu, it turned out it was in
> SHOST_RECOVERY rather that stopped.  I suppose it may be stopped as
> well, so I guess I'll have to go do another debug session and make
> sure, but I think that was a red herring.
>
> The flow seems to simply be:
>
> host is in recovery
> sd_resume queues REQUEST SENSE

You need to be careful with the SCSI REQUEST SENSE command
when used for getting power management information from
SCSI devices (mainly disks and tape drives).

Many moons ago REQUEST SENSE was used to explicitly fetch
sense data when the previous SCSI command failed and only
yielded a single byte status: CHECK CONDITION.

All modern SCSI transports have "autosense" so the original
semantics of REQUEST SENSE became pointless. So some crafty
folks at T10 decided to re-purpose REQUEST SENSE into what
it is today. That transition has been going on for around
10 years (and may not have finished).

When REQUEST SENSE had its original semantics, TEST UNIT
READY was the only game in town for monitoring power
management. From my reading of spc4r36n.pdf section  5.1.2
"Important commands for all SCSI device servers" TEST UNIT
READY should be called before REQUEST SENSE during device
initialization (including resume). If the responses to TEST
UNIT READY and REQUEST SENSE contradict then the former is
correct.

There are SCSI devices out caught in that transition. For
example with sg_format I monitor progress with either TEST
UNIT READY or REQUEST SENSE, defaulting to the former.
[Progress indication is another new role for REQUEST SENSE.]

Note that the billion or so USB keys out there that say that
they comply with SCSI-2 should respond to a REQUEST SENSE
with its original semantics.

The ATA REQUEST SENSE DATA EXT command refers to the SPC-4
"standard" (not yet it ain't) which is naturally the new
SCSI semantics of REQUEST SENSE. I believe the ATA REQUEST
SENSE DATA EXT command is a relatively new ATA command so
it does not carry the historical baggage of its SCSI
counterpart.


Just a little more hand waving for Phillip's amusement.

Doug Gilbert

