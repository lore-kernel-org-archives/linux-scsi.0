From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] clean up some more tmscsim scan logic
Date: Thu, 19 Aug 2004 18:07:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412524BE.1030002@adaptec.com>
References: <20040817163323.GA16799@lst.de> <Pine.LNX.4.60.0408172136340.5224@poirot.grange> <20040819113327.GA21326@lst.de> <Pine.LNX.4.60.0408192300530.5248@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:2993 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267461AbUHSWIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 18:08:04 -0400
In-Reply-To: <Pine.LNX.4.60.0408192300530.5248@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

The device server should send sense information when the task
finishes with CHECK CONDITION status _with_ the same transaction.
(SAM-3r13, 5.9.6, SPC-3r18, 4.5.1).  This used to be called
"autosense" a couple of years back, but no more as it is now
protocol.

This has been off-loaded to LLDD when the device doesn't support
it, so that SCSI Core is basically SAM.

BTW, the state and task queue would most likely change between
the time SCSI Core gets CHECK CONDITION (with no sense) until
the time it issues REQUEST SENSE, to get the sense for _that_
command which failed.  Thus we want LLDDs to emulate it for
devices which do not support it, since it has better (closer)
control of the device.


Guennadi Liakhovetski wrote:
> Hi
> 
> On Thu, 19 Aug 2004, Christoph Hellwig wrote:
> 
>  > On Tue, Aug 17, 2004 at 10:17:14PM +0200, Guennadi Liakhovetski wrote:
>  >> Currently SCSI drivers (tmscsim included) implement multiplecommand
>  >> queues. Which, in part, makes sense, but the generic code changed, 
> and not
>  >> all drivers nave been converted to fully use it promptly. So, as a
>  >> maximum, I saw (maybe you could add a couple:-)):
>  >>
>  >> 1) Queue in the block-layer
>  >> 2) Incoming queue in a scsi LLD (recently removed in tmscsim)
>  >> 3) Issue queue in LLD (Waiting in tmscsim)
>  >> 4) Submitted tagged command queue or untagged 1 current command in LLD
>  >> with a timer (Going in tmscsim)
>  >> 5) tcq in SCSI mid-layer / block.
>  >>
>  >> So, I can't figure out, nor find a sample implementation or a document
>  >> about which queues should really be implemented in LLDs and how they
>  >> should inter-operate with the mid- / block-layer. Say, a document,
>  >> describing the (SCSI-)command flow would be very useful, like
>  >
>  > None should be in the LLDD.  I have an experimental patch that doesn't
>  > remove the per-device queue yet but only does the easier part of
>  > returning MLQUEUE_DEVICE_BUSY in ->queuecommand but doesn't do the
>  > requeueing from the isr yet.  I'll send it out ASAP.
> 
> Looks good, thanks! Compiles too. I'll test it on the hardware tomorrow,
> should work, still, I'd do a short test. And, yes, please, feel free to
> offload any part of that further cleanup on me - I would just need a
> couple of hints. I'll do it slower and you'll have to fix it afterwards
> and consult me before, but I want to have my piece of fun too!:-)
> 
>  >> n)   scsi.c: LLD->queuecommand()
>  >> n+1) LLD:    send out on the bus, insert on tcq / return
>  >>      SCSI_MLQUEUE_DEVICE_BUSY
>  >> n+2) LLD:    on command-completion, if successful, report 
> (scsi_done()),
>  >>      if not - auto request sense, put the request-sense command on
>  >>      internal "going" queue
>  >> ...
>  >>
>  >> Where n+2 is, actually, the second question - I've seen a comment
>  >> somewhere, that LLDs should (not?) auto request-sense, rather than 
> failing
>  >> and letting the mid-layer issue one...
>  >
>  > No, mid-layer auto request sense is deprecated and isn't that reliable.
>  > See the comment ontop of scsi_eh_get_sense() in scsi_error.c
> 
> That's actually what I was reading and that's where I didn't understand:
> 
>   * Notes:
>   *    This has the unfortunate side effect that if a shost adapter does
>   *    not automatically request sense information, that we end up shutting
>   *    it down before we request it.  All shosts should be doing this
>                                                                 ^^^^
>   *    anyways, so for now all I have to say is tough noogies if you end up
>   *    in here.  On second thought, this is probably a good idea.  We
>   *    *really* want to give authors an incentive to automatically request
>   *    this.
> 
> So, I failed to understand if "this" above means "All shosts should be
> automatically requesting sense" or the opposite. Then the "second
> thought"... So, you mean LLDs should really auto-request sense on
> failures. Well, if we detect an error condition when we are CONNECTED to a
> host, it should be possible to directly send a REQUEST SENSE - the bus
> should be ours at this time, right?
> 
>  >> Is there a "perfect" LLD, I could look at for an example? I looked at
>  >> 53c700.c, as it was until recently the only one using tcq, but it 
> also has
>  >> a few of those internal queues...
>  >
>  > that driver queues commands in HBA memory, not in the driver.  It's one
>  > of the NCR scripts family HBAs where the firmware is written specificly
>  > to match the driver and they cooperate closely.  (better ask James on
>  > the details..)
> 
> Ok, I see (roughly), thanks.
> 
> Many thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



