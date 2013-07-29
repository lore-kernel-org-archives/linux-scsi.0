From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Mon, 29 Jul 2013 13:18:28 +0200
Message-ID: <20130729111827.GA14283@dhcp-26-207.brq.redhat.com>
References: <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
 <1374885793.7397.1537.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374885793.7397.1537.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 26, 2013 at 05:43:13PM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2013-07-26 at 14:14 -0700, Nicholas A. Bellinger wrote:
> > On Thu, 2013-07-25 at 20:09 -0600, Jens Axboe wrote:
> > > On Thu, Jul 25 2013, Nicholas A. Bellinger wrote:
> > > > On Thu, 2013-07-25 at 12:16 +0200, Alexander Gordeev wrote:
> > > > > On Mon, Jul 22, 2013 at 02:10:36PM -0700, Nicholas A. Bellinger wrote:
> > > > > > Np.  FYI, you'll want to use the latest commit e7827b351 HEAD from
> > > > > > target-pending/scsi-mq, which now has functioning scsi-generic support.
> > > > > 
> > > > > Survives a boot, a kernel build and the build's result :)
> > > > 
> > > > Great.  Thanks for the feedback Alexander!
> > > > 
> > > > So the next step on my end is to enable -mq for ahci, and verify initial
> > > > correctness using QEMU/KVM hardware emulation.
> > > > 
> > > > Btw, I've been looking at enabling the SHT->cmd_size for struct
> > > > ata_queued_cmd descriptor pre-allocation, but AFAICT these descriptors
> > > > are already all pre-allocated by libata and obtained via ata_qc_new() ->
> > > > __ata_qc_from_tag() during ata_scsi_queuecmd().
> > > 
> > > Might still not be a bad idea to do it:
> > > 
> > > - Cleans up a driver, getting rid of the need to alloc, maintain, and
> > >   free those structures.
> > > 
> > > - Should be some cache locality benefits to having it all sequential.
> > > 
> > 
> > Looking at this some more, there are a number of locations outside of
> > the main blk_mq_ops->queue_rq() -> SHT->queuecommand_mq() dispatch that
> > use *ata_qc_from_tag() to obtain *ata_queued_cmd, and a few without a
> > associated struct scsi_cmnd like libata-core.c:ata_exec_internal_sg()
> > for example..
> > 
> > So I don't think (completely) getting rid of ata_port->qcmds[] will be
> > possible, and just converting the ata_scsi_queuecmd() path to use the
> > extra SHT->cmd_size pre-allocation for *ata_queued_cmd might end up
> > being more trouble that it's worth.  Still undecided on that part..
> > 
> > Tejun, do you have any thoughts + input here..?
> > 
> 
> OK, so I decided to give this a shot anyways..  Here is a quick
> conversion for libata + AHCI to use blk-mq -> scsi-mq pre-allocation for
> ata_queued_cmd descriptors:
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 2b50dfd..61b3db8 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -92,6 +92,9 @@ static int ahci_pci_device_resume(struct pci_dev *pdev);
>  
>  static struct scsi_host_template ahci_sht = {
>         AHCI_SHT("ahci"),
> +       .scsi_mq = true,
> +       .cmd_size = sizeof(struct ata_queued_cmd),
> +       .queuecommand_mq = ata_scsi_queuecmd,
>  };
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index f218427..e21814d 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4725,29 +4725,25 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
>  /**
>   *     ata_qc_new - Request an available ATA command, for queueing
>   *     @ap: target port
> + *     @sc: incoming scsi_cmnd descriptor
>   *
>   *     LOCKING:
>   *     None.
>   */
>  
> -static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
> +static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap,
> +                                        struct scsi_cmnd *sc)
>  {
>         struct ata_queued_cmd *qc = NULL;
> -       unsigned int i;
> +       struct request *rq = sc->request;
>  
>         /* no command while frozen */
>         if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
>                 return NULL;
>  
> -       /* the last tag is reserved for internal command. */
> -       for (i = 0; i < ATA_MAX_QUEUE - 1; i++)

blk-mq does not prevent tag ATA_TAG_INTERNAL from being using. Would it make
sense to promote queue depth of length (ATA_MAX_QUEUE - 1) while always
pointing ATA_TAG_INTERNAL to qcmd (see below)?

> -               if (!test_and_set_bit(i, &ap->qc_allocated)) {

ata_port::qc_allocated becomes redundant.

> -                       qc = __ata_qc_from_tag(ap, i);
> -                       break;
> -               }
> -
> -       if (qc)
> -               qc->tag = i;
> +       qc = (struct ata_queued_cmd *)sc->SCp.ptr;
> +       qc->scsicmd = sc;
> +       qc->tag = rq->tag;
>  
>         return qc;
>  }
> @@ -4755,19 +4751,20 @@ static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
>  /**
>   *     ata_qc_new_init - Request an available ATA command, and initialize it
>   *     @dev: Device from whom we request an available command structure
> + *     @sc: incoming scsi_cmnd descriptor
>   *
>   *     LOCKING:
>   *     None.
>   */
>  
> -struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev)
> +struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev,
> +                                      struct scsi_cmnd *sc)
>  {
>         struct ata_port *ap = dev->link->ap;
>         struct ata_queued_cmd *qc;
>  
> -       qc = ata_qc_new(ap);
> +       qc = ata_qc_new(ap, sc);
>         if (qc) {
> -               qc->scsicmd = NULL;
>                 qc->ap = ap;
>                 qc->dev = dev;
>  
> @@ -4797,10 +4794,9 @@ void ata_qc_free(struct ata_queued_cmd *qc)
>  
>         qc->flags = 0;
>         tag = qc->tag;
> -       if (likely(ata_tag_valid(tag))) {
> +
> +       if (likely(ata_tag_valid(tag)))
>                 qc->tag = ATA_TAG_POISON;
> -               clear_bit(tag, &ap->qc_allocated);
> -       }
>  }
>  
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 0101af5..e5ab880 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -742,9 +742,8 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>  {
>         struct ata_queued_cmd *qc;
>  
> -       qc = ata_qc_new_init(dev);
> +       qc = ata_qc_new_init(dev, cmd);
>         if (qc) {
> -               qc->scsicmd = cmd;
>                 qc->scsidone = cmd->scsi_done;
>  
>                 qc->sg = scsi_sglist(cmd);
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index c949dd3..4cd88af 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -63,7 +63,8 @@ extern struct ata_link *ata_dev_phys_link(struct ata_device *dev);
>  extern void ata_force_cbl(struct ata_port *ap);
>  extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
>  extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
> -extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
> +extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev,
> +                                             struct scsi_cmnd *sc);
>  extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
>                            u64 block, u32 n_block, unsigned int tf_flags,
>                            unsigned int tag);
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index eae7a05..52e9e9e 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -35,9 +35,13 @@
>  #include <linux/ata.h>
>  #include <linux/workqueue.h>
>  #include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_cmnd.h>
>  #include <linux/acpi.h>
>  #include <linux/cdrom.h>
>  #include <linux/sched.h>
> +#include <linux/blk-mq.h>
> +#include <../../block/blk-mq.h>
>  
>  /*
>   * Define if arch has non-standard setup.  This is a _PCI_ standard
> @@ -1500,9 +1504,26 @@ static inline void ata_qc_set_polling(struct ata_queued_cmd *qc)
>  static inline struct ata_queued_cmd *__ata_qc_from_tag(struct ata_port *ap,
>                                                        unsigned int tag)
>  {
> -       if (likely(ata_tag_valid(tag)))
> -               return &ap->qcmd[tag];
> -       return NULL;
> +       struct scsi_device *sdev = ap->link.device[0].sdev;
> +       struct request_queue *q = sdev->request_queue;
> +
> +       if (unlikely(!ata_tag_valid(tag)))
> +               return NULL;
> +
> +       if (likely(sdev->host->hostt->scsi_mq)) {

Together with the comment above:

          if (likely(sdev->host->hostt->scsi_mq && (tag != ATA_TAG_INTERNAL))) {
          	...

> +               struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
> +               struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
> +               struct request *rq;
> +               struct ata_queued_cmd *qc;
> +
> +               BUG_ON(tag > hctx->queue_depth);
> +
> +               rq = hctx->rqs[tag];
> +               qc = blk_mq_rq_to_pdu(rq) + sizeof(struct scsi_cmnd);
> +               blk_mq_put_ctx(ctx);
> +               return qc;
> +       }
> +       return &ap->qcmd[tag];
>  }

I also tried to make a "quick" conversion and hit the same issue(s) as you.
Generally, I am concerned with these assumptions in such approach:

1. While libata concept of tags matches nicely with blk-mq (blk_mq_hw_ctx::
rqs[] vs ata_port::qcmd[]) right now, it is too exposed to changes in blk-mq
in the long run. I.e. ata_link::sactive limits tags to indices, while tags
might become hashes. Easily fixable, but still.

2. Unallocated requests in blk-mq are accessed/analized from libata-eh.c as
result of such iterations:

        for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
                qc = __ata_qc_from_tag(ap, tag);

                if (!(qc->flags & ATA_QCFLAG_FAILED))
                        continue;

		...
	}

While it is probably okay right now, it is still based on a premise that
blk-mq will not change the contents/concept of "payload", i.e. from embedded
to (re-)allocated memory.

> The thing that I'm hung up on now for existing __ata_qc_from_tag() usage
> outside of the main blk_mq_ops->queue_rq -> SHT->queuecommand_mq()
> dispatch path, is how to actually locate the underlying scsi_device ->
> request_queue -> blk_mq_ctx -> blk_mq_hw_hctx from the passed
> ata_port..?

I am actually in favor of getting rid of ata_queued_cmd::tag. Converting
ata_link::sactive to a list, making ata_link::active_tag as struct
ata_queued_cmd *ata_link::active_qc and converting ata_port::qc_allocated to a
list seems solves it all, including [2]. Have not checked it though.

Anyway, if we need a blk-mq tag (why?), we have qc->scsicmd->request->tag.

> Considering there can be more than a single ata_device hanging off each
> ata_port, the '*sdev = ap->link.device[0].sdev' in __ata_qc_from_tag()
> is definitely bogus, but I'm not sure how else to correlate
> blk-mq/scsi-mq per device descriptors to existing code expecting
> ata_port->qcmd[] descriptors to be shared across multiple devices..
> 
> Tejun..?
> 
> --nab
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
