From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Wed, 22 Jun 2005 09:44:51 -0400
Message-ID: <42B96B53.3070208@adaptec.com>
References: <20050621201056.GA29658@infradead.org> <Pine.LNX.4.44L0.0506211619460.634-100000@iolanthe.rowland.org> <20050621205858.GB30526@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:52699 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261287AbVFVNpL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 09:45:11 -0400
In-Reply-To: <20050621205858.GB30526@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 06/21/05 16:58, Mike Anderson wrote:
> Alan Stern [stern@rowland.harvard.edu] wrote:
>>I would describe it differently: Since you don't know whether a hot-unplug 
>>occurred, you might as well assume it did not.  There's no harm in this, 
>>because if the HBA really was unplugged then it doesn't matter what you 
>>do; everything will fail.
>>
> 
> 
> I have asked this multiple times, but I will again. If the hba knows to
> fail everything by some internal state in the LLDD why does it not also
> know to flush all commands back to the scsi mid layer in this unplugged
> state so we do not have to deal with canceling them from the mid-layer. 

This is a good question.  The way I see it: follow the path of the event
and at each logical point act on it:
	device-->SDS-->HA-->LLDD-->SCSI midlayer-->etc.
That is, at each point of the unplug event's path, act on that
unplug event, meaning HA first, then LLDD, then SCSI midlayer.

The HA and LLDD would work together, but if they _know_ about "device gone"
they should stop accepting commands to that device and return them to
the midlayer, along with saying hey, this device is gone, along with
returning all previously queued but infinished commands and rejecting new.

The other way around, a notified unplug, the event travels the same path
but in opposite direction.  So the same actions should follow but
in opposite direction: SCSI midlayer first, LLDD, HA, finally device,
just as the event from userspace travels (remove device).

(We have to go to the device eventualy in case there any reservations on
the LU.)
 
> I think it has been stated many times if commands always go in through
> queuecommand and always return through scsi_done it makes the chances of
> errors a lot less.

Completely agree!

>>But those sd flush-cache commands are a problem.  Presumably you want to 
>>send them _after_ all the outstanding commands have finished or been 
>>cancelled.  What's the right way to allow those commands while rejecting 
>>all others?
> 
> 
> We have some notion of this already if you look in scsi_prep_fn (i.e.,
> specials_only), but this is based on sdev state not shost. Checking for a
> specials_only flag in scsi_dispatch may not be to clean. This may be why
> we should look at a shost state model update and align sdev and shost to
> clearly state what will happen to command.s

Check host state first, then target then lu...

	Luben

