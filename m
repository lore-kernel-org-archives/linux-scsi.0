From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 05/14] blk-mq-sched: don't dequeue request until all in
 ->dispatch are flushed
Date: Tue, 1 Aug 2017 16:14:07 +0000
Message-ID: <1501604045.2475.8.camel@wdc.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
         <20170731165111.11536-7-ming.lei@redhat.com>
         <1501544540.2466.31.camel@wdc.com> <20170801104433.GC31452@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170801104433.GC31452@ming.t460p>
Content-Language: en-US
Content-ID: <90CBA748A708574FB73B8D231239BF04@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-08-01 at 18:44 +0800, Ming Lei wrote:
> On Mon, Jul 31, 2017 at 11:42:21PM +0000, Bart Van Assche wrote:
> > Since setting, clearing and testing of BLK_MQ_S_BUSY can happen concurr=
ently
> > and since clearing and testing happens without any locks held I'm afrai=
d this
> > patch introduces the following race conditions:
> > [ ... ]
> > * Checking BLK_MQ_S_BUSY after requests have been removed from the disp=
atch list
> >   but before that bit is cleared, resulting in test_bit(BLK_MQ_S_BUSY, =
&hctx->state)
> >   reporting that the BLK_MQ_S_BUSY
> > has been set although there are no requests
> >   on the dispatch list.
>=20
> That won't be a problem, because dispatch will be started in the
> context in which dispatch list is flushed, since the BUSY bit
> is cleared after blk_mq_dispatch_rq_list() returns. So no I/O
> hang.

Hello Ming,

Please consider changing the name of the BLK_MQ_S_BUSY constant. That bit
is used to serialize dispatching requests from the hctx dispatch list but
that's not clear from the name of that constant.

Thanks,

Bart.=
