From: Hannes Reinecke <hare@suse.de>
Subject: Re: Question: request tag usage
Date: Fri, 26 Sep 2014 14:41:17 +0200
Message-ID: <54255EED.90005@suse.de>
References: <542507C9.2060901@suse.de>	 <20140926080308.GA21137@infradead.org> <542521DB.1020605@suse.de> <1411726343.2183.9.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaIZMlV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 08:41:21 -0400
In-Reply-To: <1411726343.2183.9.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On 09/26/2014 12:12 PM, James Bottomley wrote:
> On Fri, 2014-09-26 at 10:20 +0200, Hannes Reinecke wrote:
>> On 09/26/2014 10:03 AM, Christoph Hellwig wrote:
>>> On Fri, Sep 26, 2014 at 08:29:29AM +0200, Hannes Reinecke wrote:
>>>> Hi Christoph,
>>>>
>>>> as discussed it would make sense to use the request->tag in eg
>>>> scmd_printk() to identify the command.
>>>> Which I duly did, only to figure out that the tag is always '-1', =
ie
>>>> tagging is not in use.
>>>> (Which is okay from the SCSI side, seeing the TCQ is basically a
>>>> SCSI parallel thing).
>>>
>>> tag are still a live part of SAM for every transport, they've only
>>> been renamed to "command identifier" in SAM-4 to confuse everyone.
>>>
>>>> Looking closer I found plenty of code for handling tags in the blo=
ck
>>>> layer (and the blk-mq stuff, of course), but virtually none of the
>>>> non-SPI driver seems to be using them.
>>>
>>> A quick grep for scsi_activate_tcq disagrees with you.
>>>
>> Yeah, I've noticed after I've written the mail.
>> However, main point still stands: using 'tag' to identify commands
>> is pointless if not all of the LLDDs use tagging ...
>=20
> Every non parallel LLD uses tagging; they all use the network request
> response model, so they can no longer hold the bus until they get an
> answer (which was how untagged commands work in SPI), so for most of =
the
> transports, untagged commands aren't legal.  Of course, some drivers
> roll their own tags instead of using the block ones.
>=20
Hmm, I probably will get shot for this, but we _could_ do something
like this:

diff --git a/block/blk-core.c b/block/blk-core.c
index bf930f4..91570d2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2347,7 +2347,8 @@ void blk_start_request(struct request *req)
        req->resid_len =3D blk_rq_bytes(req);
        if (unlikely(blk_bidi_rq(req)))
                req->next_rq->resid_len =3D blk_rq_bytes(req->next_rq);
-
+       if (!blk_queue_tagged(req->q))
+               req->tag =3D (++req->q->last_tag) % req->q->nr_requests=
;
        BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
        blk_add_timer(req);
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 518b465..e8ce575 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -418,6 +418,7 @@ struct request_queue {

        struct blk_queue_tag    *queue_tags;
        struct list_head        tag_busy_list;
+       unsigned int            last_tag;

        unsigned int            nr_sorted;
        unsigned int            in_flight[2];

I know, I know. But it would give us a rather nice command identifier.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
