From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
 force_blk_mq
Date: Mon, 5 Feb 2018 18:23:43 +0800
Message-ID: <20180205102342.GB32558@ming.t460p>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <07c1f41e-de7c-5e3d-1a2d-0cd7af7b46df@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752719AbeBEKYD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 05:24:03 -0500
Content-Disposition: inline
In-Reply-To: <07c1f41e-de7c-5e3d-1a2d-0cd7af7b46df@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On Mon, Feb 05, 2018 at 07:58:29AM +0100, Hannes Reinecke wrote:
> On 02/03/2018 05:21 AM, Ming Lei wrote:
> > Hi All,
> > 
> > This patchset supports global tags which was started by Hannes originally:
> > 
> > 	https://marc.info/?l=linux-block&m=149132580511346&w=2
> > 
> > Also inroduce 'force_blk_mq' to 'struct scsi_host_template', so that
> > driver can avoid to support two IO paths(legacy and blk-mq), especially
> > recent discusion mentioned that SCSI_MQ will be enabled at default soon.
> > 
> > 	https://marc.info/?l=linux-scsi&m=151727684915589&w=2
> > 
> > With the above two changes, it should be easier to convert SCSI drivers'
> > reply queue into blk-mq's hctx, then the automatic irq affinity issue can
> > be solved easily, please see detailed descrption in commit log.
> > 
> > Also drivers may require to complete request on the submission CPU
> > for avoiding hard/soft deadlock, which can be done easily with blk_mq
> > too.
> > 
> > 	https://marc.info/?t=151601851400001&r=1&w=2
> > 
> > The final patch uses the introduced 'force_blk_mq' to fix virtio_scsi
> > so that IO hang issue can be avoided inside legacy IO path, this issue is
> > a bit generic, at least HPSA/virtio-scsi are found broken with v4.15+.
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
> >  block/blk-mq-tag.c         | 67 +++++++++++++++++++++++++++++-----------------
> >  block/blk-mq-tag.h         | 15 ++++++++---
> >  block/blk-mq.c             | 31 ++++++++++++++++-----
> >  block/blk-mq.h             |  3 ++-
> >  block/kyber-iosched.c      |  2 +-
> >  drivers/block/null_blk.c   |  6 +++++
> >  drivers/scsi/hosts.c       |  1 +
> >  drivers/scsi/virtio_scsi.c | 59 +++-------------------------------------
> >  include/linux/blk-mq.h     |  2 ++
> >  include/scsi/scsi_host.h   |  3 +++
> >  13 files changed, 105 insertions(+), 101 deletions(-)
> > 
> Thanks Ming for picking this up.
> 
> I'll give it a shot and see how it behaves on other hardware.

Hi Hannes,

Thanks for looking at it.

I am working on V2, which has fixed some issues, and added your patch
of 'scsi: Add template flag 'host_tagset', but causes a HPSA kernel
oops. Once it is fixed, I will posted V2 out, then there will be one
real example about how to use global tags for converting reply queue
to blk-mq hctx.

https://github.com/ming1/linux/commits/v4.15-for-next-global-tags-V2

Thanks,
Ming
