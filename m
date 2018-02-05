From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce force_blk_mq
Date: Mon, 5 Feb 2018 12:35:13 +0530
Message-ID: <528c93de0aac9010e274847ab1ae0328@mail.gmail.com>
References: <20180203042112.15239-1-ming.lei@redhat.com> <07c1f41e-de7c-5e3d-1a2d-0cd7af7b46df@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <07c1f41e-de7c-5e3d-1a2d-0cd7af7b46df@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, February 5, 2018 12:28 PM
> To: Ming Lei; Jens Axboe; linux-block@vger.kernel.org; Christoph Hellwig;
> Mike Snitzer
> Cc: linux-scsi@vger.kernel.org; Arun Easi; Omar Sandoval; Martin K .
> Petersen;
> James Bottomley; Christoph Hellwig; Don Brace; Kashyap Desai; Peter
> Rivera;
> Paolo Bonzini; Laurence Oberman
> Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
> force_blk_mq
>
> On 02/03/2018 05:21 AM, Ming Lei wrote:
> > Hi All,
> >
> > This patchset supports global tags which was started by Hannes
> > originally:
> >
> > 	https://marc.info/?l=3Dlinux-block&m=3D149132580511346&w=3D2
> >
> > Also inroduce 'force_blk_mq' to 'struct scsi_host_template', so that
> > driver can avoid to support two IO paths(legacy and blk-mq),
> > especially recent discusion mentioned that SCSI_MQ will be enabled at
> default soon.
> >
> > 	https://marc.info/?l=3Dlinux-scsi&m=3D151727684915589&w=3D2
> >
> > With the above two changes, it should be easier to convert SCSI drivers=
'
> > reply queue into blk-mq's hctx, then the automatic irq affinity issue
> > can be solved easily, please see detailed descrption in commit log.
> >
> > Also drivers may require to complete request on the submission CPU for
> > avoiding hard/soft deadlock, which can be done easily with blk_mq too.
> >
> > 	https://marc.info/?t=3D151601851400001&r=3D1&w=3D2
> >
> > The final patch uses the introduced 'force_blk_mq' to fix virtio_scsi
> > so that IO hang issue can be avoided inside legacy IO path, this issue
> > is a bit generic, at least HPSA/virtio-scsi are found broken with
> > v4.15+.
> >
> > Thanks
> > Ming
> >
> > Ming Lei (5):
> >   blk-mq: tags: define several fields of tags as pointer
> >   blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
> >   block: null_blk: introduce module parameter of 'g_global_tags'
> >   scsi: introduce force_blk_mq
> >   scsi: virtio_scsi: fix IO hang by irq vector automatic affinity
> >
> >  block/bfq-iosched.c        |  4 +--
> >  block/blk-mq-debugfs.c     | 11 ++++----
> >  block/blk-mq-sched.c       |  2 +-
> >  block/blk-mq-tag.c         | 67
> > +++++++++++++++++++++++++++++-----------------
> >  block/blk-mq-tag.h         | 15 ++++++++---
> >  block/blk-mq.c             | 31 ++++++++++++++++-----
> >  block/blk-mq.h             |  3 ++-
> >  block/kyber-iosched.c      |  2 +-
> >  drivers/block/null_blk.c   |  6 +++++
> >  drivers/scsi/hosts.c       |  1 +
> >  drivers/scsi/virtio_scsi.c | 59
> > +++-------------------------------------
> >  include/linux/blk-mq.h     |  2 ++
> >  include/scsi/scsi_host.h   |  3 +++
> >  13 files changed, 105 insertions(+), 101 deletions(-)
> >
> Thanks Ming for picking this up.
>
> I'll give it a shot and see how it behaves on other hardware.

Ming -

There is no way we can enable global tags from SCSI stack in this patch
series.   I still think we have no solution for issue described below in
this patch series.
https://marc.info/?t=3D151601851400001&r=3D1&w=3D2

What we will be doing is just use global tag HBA wide instead of h/w queue
based. We still have more than one reply queue ending up completion one CPU=
.
Try to reduce MSI-x vector of megaraid_sas or mpt3sas driver via module
parameter to simulate the issue. We need more number of Online CPU than
reply-queue.
We may see completion redirected to original CPU because of
"QUEUE_FLAG_SAME_FORCE", but ISR of low level driver can keep one CPU busy
in local ISR routine.


Kashyap

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB=
 21284
> (AG N=C3=BCrnberg)
