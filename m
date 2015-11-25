From: Hannes Reinecke <hare@suse.de>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Wed, 25 Nov 2015 10:04:34 +0100
Message-ID: <565579A2.4000005@suse.de>
References: <1447838334.1564.2.camel@ellerman.id.au>	 <1447855399.3974.24.camel@redhat.com>	 <1447894964.15206.0.camel@ellerman.id.au>	 <20151119082325.GA11419@infradead.org>  <564DEC41.5010600@suse.de>	 <1448030316.4067.18.camel@localhost.localdomain> <564F3453.9040603@suse.de> <1448033323.4067.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448033323.4067.24.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: emilne@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On 11/20/2015 04:28 PM, Ewan Milne wrote:
> On Fri, 2015-11-20 at 15:55 +0100, Hannes Reinecke wrote:
>> Can't we have a joint effort here?
>> I've been spending a _LOT_ of time trying to debug things here, but
>> none of the ideas I've come up with have been able to fix anything.
>=20
> Yes.  I'm not the one primarily looking at it, and we don't have a
> reproducer in-house.  We just have the one dump right now.
>=20
>>
>> I'm almost tempted to increase the count from scsi_alloc_sgtable()
>> by one and be done with ...
>>
>=20
> That might not fix it if it is a problem with the merge code, though.
>=20
And indeed, it doesn't.
Seems I finally found the culprit.

What happens is this:
We have two paths, with these seg_boundary_masks:

path-1:    seg_boundary_mask =3D 65535,
path-2:    seg_boundary_mask =3D 4294967295,

consequently the DM request queue has this:

md-1:    seg_boundary_mask =3D 65535,

What happens now is that a request is being formatted, and sent
to path 2. During submission req->nr_phys_segments is formatted
with the limits of path 2, arriving at a count of 3.
Now the request gets retried on path 1, but as the NOMERGE request
flag is set req->nr_phys_segments is never updated.
But blk_rq_map_sg() ignores all counters, and just uses the
bi_vec directly, resulting in a count of 4 -> boom.

So the culprit here is the NOMERGE flag, which is evaluated
via
->dm_dispatch_request()
  ->blk_insert_cloned_request()
    ->blk_rq_check_limits()

If the above assessment is correct, the following patch should
fix it:

diff --git a/block/blk-core.c b/block/blk-core.c
index 801ced7..12cccd6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1928,7 +1928,7 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
-       if (!rq_mergeable(rq))
+       if (rq->cmd_type !=3D REQ_TYPE_FS)
                return 0;

        if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q,
rq->cmd_flags)) {


Mike? Jens?
Can you comment on it?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
