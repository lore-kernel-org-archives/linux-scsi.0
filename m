From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 11:06:08 -0400
Message-ID: <446B3BE0.8040806@garzik.org>
References: <4468B596.9090508@garzik.org> <1147789098.3505.19.camel@mulgrave.il.steeleye.com> <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com> <4469F9FB.7020807@garzik.org> <1147797507.3505.52.camel@mulgrave.il.steeleye.com> <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:27061 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750905AbWEQPGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 11:06:13 -0400
In-Reply-To: <20060517073701.GE4197@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Jens Axboe wrote:
> On Tue, May 16 2006, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> On Tue, 2006-05-16 at 12:12 -0400, Jeff Garzik wrote:
>>>> Its an API-which-only-libata-uses that we're discussing.  And because 
>>>> its moving to the block layer, its also a 
>>>> temporary-API-which-only-libata-uses.
>>> OK ... this may be the root of the problem.  I really would like libata
>>> to migrate to being block only ... especially as PATA looks to be trying
>>> to follow you into the SCSI subsystem.  However, this has been the
>>> statement for the past two years (at least), and really, few
>>> enhancements have been made to block that you need to make good on this.
>>> I think one of the things we'll try to find time to do at the storage
>>> summit is to take a hard look at block to see exactly what has to be
>>> added to make libata solely dependent upon it.
>> 100% agreed...
> 
> Ditto! I'd be more than willing to implement some of these features (and
> already started to, the per command timeout for instance), but I was
> starting to write off libata moving to block as a silly pipe dream in
> all honesty... But if momentum is picking up behind this move, then I'll
> all for it.

Just gotta be patient.  Rome wasn't built in a day, and all that :)

Like I mentioned in another message, the ideal world is that libata uses 
an ATA disk driver and a SCSI MMC driver -- just like a modern SAS 
controller (which likely supports SATA too) will use both an ATA disk 
driver and a SCSI disk driver.

Given this "ideal world", its IMO best that the "storage driver" 
infrastructure lives in the block layer not SCSI layer.


>> The general list, off the top of my head:
>>
>> * objects: storage message, storage device, storage host, and the 
>> requisite interconnections
> 
> Storage message -> request. The rq-cmd-type branch of the block repo has
> most/some of that done. For an explicit storage device + host, I have no
> plans to expland on what we have.

Agreed that storage message == request.

storage device and storage host are key objects included in the 
infrastructure libata uses SCSI for.  They fall naturally out of the 
infrastructure that provides "device busy", "host busy", EH and EH 
synchronization across multiple devices, etc.  Though these, SCSI also 
provides infrastructure through which an LLDD may export a bus topology 
to the user.


>> * queuecommand-style API
> 
> That's a style issue, rather than a required item. You can roll that on
> top of the current api by just doing a:
> 
> int queuecommand_helper(request_queue_t *q, struct request *rq)
> {
>         /* issue request */
>         ...
>         return OK/DEFER/REJECT/WHATEVER
> }
> 
> blk_queuecommand_helper(request_queue_t *q, queue_command_fn *fn)
> {
>         struct request *rq;
>         int ret;
> 
>         do {
>                 rq = elv_next_request(q);
>                 if (!rq)
>                         break;
> 
>                 ret = fn(q, rq);
>                 if (ret == OK)
>                         continue;
> 
>                 /* handle replugging/killing/whatever */
>         } while (1);
> }
> 
> if you really wanted.

That's not an optional piece.  Given the needed timeout / device / host 
infrastructure, you inevitably wind up with the following code pattern:

	infrastructure code
	send fully prepared request to hardware
	infrastructure code

At this point I should note that all of what I've been describing is an 
_optional addition_ to the block layer.  Its all helpers and a few new, 
optional structs.  This SHOULD NOT involve changing the core block layer 
at all.  Well, maybe struct request would like the addition of a timer. 
  But that's it, and such a mod is easy to do.

	Jeff


