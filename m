From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
 force_blk_mq
Date: Mon, 5 Feb 2018 18:17:40 +0800
Message-ID: <20180205101734.GA32558@ming.t460p>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <07c1f41e-de7c-5e3d-1a2d-0cd7af7b46df@suse.de>
 <528c93de0aac9010e274847ab1ae0328@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752324AbeBEKSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 05:18:02 -0500
Content-Disposition: inline
In-Reply-To: <528c93de0aac9010e274847ab1ae0328@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

Hi Kashyap,

On Mon, Feb 05, 2018 at 12:35:13PM +0530, Kashyap Desai wrote:
> > -----Original Message-----
> > From: Hannes Reinecke [mailto:hare@suse.de]
> > Sent: Monday, February 5, 2018 12:28 PM
> > To: Ming Lei; Jens Axboe; linux-block@vger.kernel.org; Christoph Hellwig;
> > Mike Snitzer
> > Cc: linux-scsi@vger.kernel.org; Arun Easi; Omar Sandoval; Martin K .
> > Petersen;
> > James Bottomley; Christoph Hellwig; Don Brace; Kashyap Desai; Peter
> > Rivera;
> > Paolo Bonzini; Laurence Oberman
> > Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
> > force_blk_mq
> >
> > On 02/03/2018 05:21 AM, Ming Lei wrote:
> > > Hi All,
> > >
> > > This patchset supports global tags which was started by Hannes
> > > originally:
> > >
> > > 	https://marc.info/?l=linux-block&m=149132580511346&w=2
> > >
> > > Also inroduce 'force_blk_mq' to 'struct scsi_host_template', so that
> > > driver can avoid to support two IO paths(legacy and blk-mq),
> > > especially recent discusion mentioned that SCSI_MQ will be enabled at
> > default soon.
> > >
> > > 	https://marc.info/?l=linux-scsi&m=151727684915589&w=2
> > >
> > > With the above two changes, it should be easier to convert SCSI drivers'
> > > reply queue into blk-mq's hctx, then the automatic irq affinity issue
> > > can be solved easily, please see detailed descrption in commit log.
> > >
> > > Also drivers may require to complete request on the submission CPU for
> > > avoiding hard/soft deadlock, which can be done easily with blk_mq too.
> > >
> > > 	https://marc.info/?t=151601851400001&r=1&w=2
> > >
> > > The final patch uses the introduced 'force_blk_mq' to fix virtio_scsi
> > > so that IO hang issue can be avoided inside legacy IO path, this issue
> > > is a bit generic, at least HPSA/virtio-scsi are found broken with
> > > v4.15+.
> > >
> > > Thanks
> > > Ming
> > >
> > > Ming Lei (5):
> > >   blk-mq: tags: define several fields of tags as pointer
> > >   blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
> > >   block: null_blk: introduce module parameter of 'g_global_tags'
> > >   scsi: introduce force_blk_mq
> > >   scsi: virtio_scsi: fix IO hang by irq vector automatic affinity
> > >
> > >  block/bfq-iosched.c        |  4 +--
> > >  block/blk-mq-debugfs.c     | 11 ++++----
> > >  block/blk-mq-sched.c       |  2 +-
> > >  block/blk-mq-tag.c         | 67
> > > +++++++++++++++++++++++++++++-----------------
> > >  block/blk-mq-tag.h         | 15 ++++++++---
> > >  block/blk-mq.c             | 31 ++++++++++++++++-----
> > >  block/blk-mq.h             |  3 ++-
> > >  block/kyber-iosched.c      |  2 +-
> > >  drivers/block/null_blk.c   |  6 +++++
> > >  drivers/scsi/hosts.c       |  1 +
> > >  drivers/scsi/virtio_scsi.c | 59
> > > +++-------------------------------------
> > >  include/linux/blk-mq.h     |  2 ++
> > >  include/scsi/scsi_host.h   |  3 +++
> > >  13 files changed, 105 insertions(+), 101 deletions(-)
> > >
> > Thanks Ming for picking this up.
> >
> > I'll give it a shot and see how it behaves on other hardware.
> 
> Ming -
> 
> There is no way we can enable global tags from SCSI stack in this patch

It has been done in V2 of this patchset, which will be posted out after
HPSA's issue is fixed:

	https://github.com/ming1/linux/commits/v4.15-for-next-global-tags-V2

Global tags will be enabled easily via .host_tagset of scsi_host_template.

> series.   I still think we have no solution for issue described below in
> this patch series.
> https://marc.info/?t=151601851400001&r=1&w=2
> 
> What we will be doing is just use global tag HBA wide instead of h/w queue
> based.

Right, that is just what the 1st three patches are doing.

> We still have more than one reply queue ending up completion one CPU.

pci_alloc_irq_vectors(PCI_IRQ_AFFINITY) has to be used, that means
smp_affinity_enable has to be set as 1, but seems it is the default
setting.

Please see kernel/irq/affinity.c, especially irq_calc_affinity_vectors()
which figures out an optimal number of vectors, and the computation is
based on cpumask_weight(cpu_possible_mask) now. If all offline CPUs are
mapped to some of reply queues, these queues won't be active(no request
submitted to these queues). The mechanism of PCI_IRQ_AFFINITY basically
makes sure that more than one irq vector won't be handled by one same CPU,
and the irq vector spread is done in irq_create_affinity_masks().

> Try to reduce MSI-x vector of megaraid_sas or mpt3sas driver via module
> parameter to simulate the issue. We need more number of Online CPU than
> reply-queue.

IMO, you don't need to simulate the issue, pci_alloc_irq_vectors(
PCI_IRQ_AFFINITY) will handle that for you. You can dump the returned
irq vector number, num_possible_cpus()/num_online_cpus() and each
irq vector's affinity assignment.

> We may see completion redirected to original CPU because of
> "QUEUE_FLAG_SAME_FORCE", but ISR of low level driver can keep one CPU busy
> in local ISR routine.

Could you dump each irq vector's affinity assignment of your megaraid
in your test?

And the following script can do it easily, and the pci path
(the 1st column of lspci output) need to be passed, such as: 00:1c.4, 

#!/bin/sh
if [ $# -ge 1 ]; then
    PCID=$1
else
    PCID=`lspci | grep "Non-Volatile memory" | cut -c1-7`
fi
PCIP=`find /sys/devices -name *$PCID | grep pci`
IRQS=`ls $PCIP/msi_irqs`

echo "kernel version: "
uname -a

echo "PCI name is $PCID, dump its irq affinity:"
for IRQ in $IRQS; do
    CPUS=`cat /proc/irq/$IRQ/smp_affinity_list`
    echo "\tirq $IRQ, cpu list $CPUS"
done


Thanks,
Ming
