From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing
 allocation of a reply-buffer
Date: Fri, 11 Aug 2017 00:10:38 +0200
Message-ID: <20170810221038.GA918@bblock-ThinkPad-W530>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
 <9e67ce3fc2f3cd42e9e05b2753b00d6676f46ee1.1502120928.git.bblock@linux.vnet.ibm.com>
 <20170810093217.GL24539@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170810093217.GL24539@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2017 at 11:32:17AM +0200, Christoph Hellwig wrote:
> We can't use an on-stack buffer for the sense data, as drivers will
> dma to it.  So we should reuse the SCSI init_rq_fn() for the BSG
> queues and/or implement the same scheme.
> 

BSG is odd in this regard. Here is the data model as far as I understood
it from reading the source.

The user of the interface provides his input via a sg_io_v4 object.

 struct sg_io_v4
 +--------------+
 |              |  
 | request-------->+----------------------------+
 |   + _len     |  |                            |
 |   (A)        |  | BSG Request                |
 |              |  | e.g. struct fc_bsg_request | Depends on BSG implementation
 |              |  |                            | FC vs. iSCSI vs. ...
 |              |  +----------------------------+
 |              |
 | response------->+----------------------------+ Used as _Output_
 |   + max_len  |  |                            | User doesn't initialize
 |   (B)        |  | BSG Reply                  | User provides (optional)
 |              |  | e.g. struct fc_bsg_reply   |   memory; May be NULL.
 |              |  |                            |
 |              |  +----------------------------+
 |              |
 | dout_xferp----->+-----------------------+ Stuff send on the wire by
 |   + _len     |  |                       |   the LLD
 |   (C)        |  | Transport Protocol IU | Aligned on PAGE_SIZE
 |              |  | e.g. FC-GS-7 CT_IU    |
 |              |  |                       |
 |              |  +-----------------------+
 |              |
 | din_xferp------>+-----------------------+ Buffer for response data by
 |   + _len     |  |                       |   the LLD
 |   (D)        |  | Transport Protocol IU | Aligned on PAGE_SIZE
 |              |  | e.g. FC-GS-7 CT_IU    |
 |              |  |                       |
 |              |  +-----------------------+
 +--------------+

This is just a part of it, but the most important for this issue. The
BSG driver then encapsulates this into two linked block-requests he
passes down to the LLDs. The first block-request (E) is for the Request
Data, and the second request (F) for the Response Data. (F) is optional,
depending on the whether the user passes both dout_xferp and din_xferp.

 struct request (E)
 +--------------+
 |              |  struct scsi_request
 | scsi_request--->+-----------------+
 |              |  |                 |
 |              |  | cmd---------------------> Copy of (A)
 |              |  |  + _len         |         Space in struct or kzalloc
 |              |  |  (G)            |
 |              |  |                 |
 |              |  | sense-------------------> Space for BSG Reply
 |              |  |  + _len         |         Same Data-Structure as (B)
 |              |  |  (H)            |         NOT actually pointer (B)
 |              |  |                 |         'reply_buffer' in my patch 
 |              |  +-----------------+
 |              |
 | bio------------> Mapped via blk_rq_map_user() to (C) dout_xferp
 |              |
 | next_rq---------+
 |              |  |
 +--------------+  |
                   |
 struct request (F)|(if used)
 +--------------+<-+
 |              |
 | scsi_request---> Unused here
 |              |
 | bio------------> Mapped via blk_rq_map_user() to (D) din_xferp
 |              |
 +--------------+

This is enqueued in the (legacy) blk-queue. In bsg-lib.c this is
processed and encapsulated into an other data-structure struct bsg_job

 struct bsg_job
 +-----------------+
 |                 |
 | request-----------> (G) scsi_request->cmd -> Copy of (A)
 |   + _len        |       e.g. struct fc_bsg_request
 |                 |
 | reply-------------> (H) scsi_request->sense -> 'reply_buffer'
 |   + _len        |       e.g. struct fc_bsg_reply
 |                 |
 | request_payload---> struct scatterlist ... map (E)->bio
 |   + _len        |
 |   (I)           |
 |                 |
 | reply_payload-----> struct scatterlist ... map (F)->bio
 |   + _len        |
 |   (J)           |
 |                 |
 +-----------------+

This then is finally what the LLD gets to work with, with the callback
from the request-queue. Depending on contents of (G) the LLD gets to
decide whatever the user-space wants him to do. This depends highly on
the transport.

In case of zFCP we map (I) and (J) directly into the ring that passes
the data to our hardware and the one that the hardware uses to pass back
the responses.

(This is actually pretty cool if you think about it. Apart from the copy
we make of (A) into (G), this whole send was completely 'zero-copy'.
Depending on the hardware it can directly DMA onto the wire... I guess
most modern cards can do such a thing.)

When the answer is coming back, the payload data is expected to be put
into (J). If your HW can DMA into this, no more effort.

Again, depending on (H), the LLD fills in some information for
accounting and such. In case of FC, there is also some
protocol-information, but this is by no means a standard IU.

This is then passed up the stack pretty quick and if the user passed
something with (B), data from (H) is copied into (B). But this is
optional. The main payload is transferred to the user via (J) which is a
remap of (D).

So this is my understanding here. (I don't wanna say that this is
necessarily completely correct ;-), pleas correct me, if I am wrong. The
lack of proper documentation is also not helping at all.)

This worked till it broke. Right now every driver that tries to access
(H) will panic the system, or cause very undefined behavior. I suspect
no driver right now tries to do any DMA into (H); before the regression,
this has been also an on-stack variable (I suspect since BSG was
introduced, haven't checked though).

The asymmetries between the first struct request (E) and the following
(F) also makes it hard to use the same scheme as in other drivers, where
init_rq_fn() gets to initialize each request in the same'ish way. Or?
Just looking at it right now, this would require some bigger rework that
is not appropriate for a stable bug-fix.

I think it would be best if we fix the possible panics every user of
this is gonna experience and after that we can still think about
improving it further beyond what the rest of the patch set already does,
if that is necessary.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
                  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
