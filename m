From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] move ULD attachment into the prep function
Date: Wed, 08 Aug 2007 08:51:04 -0700
Message-ID: <1186588264.3501.13.camel@localhost.localdomain>
References: <1186239985.3439.19.camel@localhost.localdomain>
	 <46B8893E.9030005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43619 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754985AbXHHPvQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2007 11:51:16 -0400
In-Reply-To: <46B8893E.9030005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

On Tue, 2007-08-07 at 18:01 +0300, Boaz Harrosh wrote:
> James Bottomley wrote:
> > One of the intents of the block prep function was to allow ULDs to use
> > it for preprocessing.  The original SCSI model was to have a single prep
> > function and add a pointer indirect filter to build the necessary
> > commands.  This patch reverses that, does away with the init_command
> > field of the scsi_driver structure and makes ULDs attach directly to the
> > prep function instead.  The value is really that it allows us to begin
> > to separate the ULDs from the SCSI mid layer (as long as they don't use
> > any core functions---which is hard at the moment---a ULD doesn't even
> > need SCSI to bind).
> > 
> > James
> > 
> > Index: BUILD-2.6/drivers/scsi/scsi_lib.c
> 
> It turns out this patch is dependent on previous
> sd: disentangle barriers in SCSI (02)
> 
> and that one is dependent on the previous-previous one: 
> block: add protocol discriminators to requests and queues. (01)
> 
> but the middle one (02) does not apply it looks like there is a missing
> hunk for scsi_lib.c in the first (01)
> 
> <sd: disentangle barriers in SCSI (02)>
> @@ -1596,7 +1580,6 @@ struct request_queue *scsi_alloc_queue(s
>  		return NULL;
>  
>  	blk_queue_prep_rq(q, scsi_prep_fn);
> -	blk_queue_issue_flush_fn(q, scsi_issue_flush_fn);
>  	blk_queue_softirq_done(q, scsi_softirq_done);
>  	blk_queue_protocol(q, BLK_PROTOCOL_SCSI);
>  	return q;
> </sd: disentangle barriers in SCSI (02)>
> 
> The before last sync line: 
>  	blk_queue_protocol(q, BLK_PROTOCOL_SCSI);
> is missing from (01). Any thing else I need?
> 
> So I guess my first complain is that these should have been
> a series to denote dependency. Also I think an email with 
> deeper explanation of where you are going with these, and 
> what is the motivation could be nice.

Sorry they're just random dumps from my current quilt set done under the
release early release often philosophy.

> Apart from that:
> 
> Ouch! ;) That patch hurts.
> 
> What is the time frame for these changes are they for immediate
> inclusion into scsi-misc and into 2.6.24 merge window? Before
> scsi_data_buff, sglist, bidi, Mike's execute_async_cleanup ... ?

When it's reasonably stable and mature ... like all the rest of the
various patch sets.

> I do not like this patch. I think that if your motivation was
> to make sd/sr and other ULD's more independent of scsi-ml than
> you achieved the opposite.

I don't think a SCSI ULD is ever going to be independent of the SCSI mid
layer.  However, the point is that complex subsystems like libata need
the same ULD attachment mechanics as SCSI.  The idea is to demonstrate
how this can be done independently of SCSI.  One of the ultimate goals
would be to be able to write a pure ATA disk driver as an ULD attachment
that spoke only taskfiles and had no SCSI dependency at all ... feeding
straight into the libata queuing function.

The key requirement is to make the attachment mechanism independent of
SCSI.

>  5 exported functions and intimate
> knowledge of scsi_lib internals. Lots of same cut and past code 
> in ULD's. Interdependence of scsi_lib.c with it's ULD's. Will 
> make it hard for scsi_lib to change without touching ULD's.
> (And there are lots of scheduled changes :-))

The object isn't to reduce the points of contact, although conversely,
it's not the object to increase them either.  Realistically, even if
libata gets separated from SCSI, it will still need sr and st to run the
ATAPI devices.  What we will need to do then is split out a command
handler from the rest of the SCSI mid layer, so sr and st can pull in a
single libscsi (or something) module and be directly attached to the ata
stack.

> What about below approach? 
> What I tried to do is keep scsi_lib private, export a more
> simple API for ULD's. And keep common code common.
> The code was compiled and booted but I did not do any error 
> injection and/or low memory condition testing.

All you really did was go the other way on an issue I struggled with:
how to process REQ_BLOCK_PC.  Realistically, either approach is fine ...
and probably neither will survive the final separation of libscsi from
the mid layer.

James


