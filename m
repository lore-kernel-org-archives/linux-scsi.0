From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/9] blk-mq: use the introduced
 blk_mq_unquiesce_queue()
Date: Fri, 2 Jun 2017 22:19:53 +0000
Message-ID: <1496441991.1214.25.camel@sandisk.com>
References: <20170531123706.20885-1-ming.lei@redhat.com>
         <20170531123706.20885-4-ming.lei@redhat.com>
         <1496244100.2608.3.camel@sandisk.com> <20170601005423.GA23563@ming.t460p>
         <1496358538.3075.12.camel@sandisk.com> <20170602020041.GE30505@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170602020041.GE30505@ming.t460p>
Content-Language: en-US
Content-ID: <2AB090B513CB324FB70C30EAED9E2C58@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-06-02 at 10:00 +0800, Ming Lei wrote:
> On Thu, Jun 01, 2017 at 11:09:00PM +0000, Bart Van Assche wrote:
> > My opinion is that scsi_internal_device_block() and scsi_internal_devic=
e_unblock()
> > should be changed as follows for the scsi-mq code path:
> > * scsi_internal_device_block() should call blk_mq_quiesce_queue(q) if t=
he "wait"
> >   argument is true and should set the QUEUE_FLAG_QUIESCED flag if the "=
wait"
> >   argument is false.
> > * scsi_internal_device_unblock() should call blk_mq_unquiesce_queue().
> >=20
> > I am aware it sounds weird to set the QUEUE_FLAG_QUIESCED flag without =
waiting
> > until ongoing .queue_rq() calls have finished. The only driver that tri=
ggers
>=20
> This way may break the contract of blk_mq_quiesce_queue() and is really w=
eird.
> And the above change shouldn't be related with this patchset, so better
> to do whatever you want once this patch is merged.

No, what I proposed doesn't break the contract of blk_mq_quiesce_queue().
The contract of that function is that if it is called that all pending
.queue_rq() calls have finished and no new .queue_rq() calls will occur
until blk_mq_unquiesce_queue() is called. Since the wait =3D=3D false path =
does
not call blk_mq_quiesce_queue() that contract does not apply.

> This patchset won't break current SCSI uses of blk_mq_quiesce_queue() and
> won't cause regression, and I setup one iSCSI target yesterday and it wor=
ks
> just fine, how about just keeping this patch as it is?

As I explained in a previous e-mail, the iSCSI initiator driver does not
trigger the wait =3D=3D false path so your test did not trigger that code p=
ath.

Something else I explained in a previous e-mail is that your patch makes it
impossible to use the STOPPED flag in the SCSI core what it was originally
intended for, namely preventing that the block layer keeps trying to queue
requests while the block driver knows that it will have to return "BUSY".
This is why I asked you to modify the SCSI integration of your patch.

Bart.=
