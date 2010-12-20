From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less w/
	interrupts disabled internally
Date: Sun, 19 Dec 2010 17:15:03 -0800
Message-ID: <1292807703.20840.29.camel@haakon2.linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>
	 <20101219233835.GJ1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101219233835.GJ1263@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2010-12-19 at 16:38 -0700, Matthew Wilcox wrote:
> On Sun, Dec 19, 2010 at 01:21:56PM -0800, Nicholas A. Bellinger wrote:
> > This patch changes iscsi_queuecommand_lck() to a host_lock less
> > iscsi_queuecommand() that will internally disable interrupts using
> > session->lock and drop the now legacy host_lock unlock.
> 
> I think this patch is buggy.  Before, iscsi_queuecommand_lck is called with
> interrupts disabled.  Now, it's called with interrupts disabled.  Elsewhere,
> session->lock is acquired with bh's disabled:
> 
> void iscsi_put_task(struct iscsi_task *task)
> {
>         struct iscsi_session *session = task->conn->session;
> 
>         spin_lock_bh(&session->lock);
> 
> So I think you need to convert the
>         spin_lock(&session->lock);
> in iscsi_queuecommand_lck to at least a spin_lock_bh, and possibly
> a spin_lock_irq -- it's not clear to me whether it needs to exclude
> against interrupt context, or only BH context.  In some places, it's
> taken with spin_lock_irqsave().
> 
> I'd play it safe and use _irq, but someone more confident with this code
> might choose to only use _bh.
> 

Hmmm, indeed..  I must have dropped this recently as the last patch for
libiscsi posted below still has been converted to spin_lock_irq() for
session->lock here:

http://marc.info/?l=linux-scsi&m=128952081412461&w=2

Converting back to spin_lock_irq() usage for the moment..  Thanks alot
of noticing this..

MikeC and Hannes, do you think this is safe to use spin_lock_bh() as
well..?

--nab


> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/libiscsi.c |   10 ++--------
> >  1 files changed, 2 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> > index c15fde8..5535782 100644
> > --- a/drivers/scsi/libiscsi.c
> > +++ b/drivers/scsi/libiscsi.c
> > @@ -1599,7 +1599,7 @@ enum {
> >  	FAILURE_SESSION_NOT_READY,
> >  };
> >  
> > -static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
> > +int iscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> >  {
> >  	struct iscsi_cls_session *cls_session;
> >  	struct Scsi_Host *host;
> > @@ -1609,13 +1609,11 @@ static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi
> >  	struct iscsi_conn *conn;
> >  	struct iscsi_task *task = NULL;
> >  
> > -	sc->scsi_done = done;
> >  	sc->result = 0;
> >  	sc->SCp.ptr = NULL;
> >  
> >  	host = sc->device->host;
> >  	ihost = shost_priv(host);
> > -	spin_unlock(host->host_lock);
> >  
> >  	cls_session = starget_to_session(scsi_target(sc->device));
> >  	session = cls_session->dd_data;
> > @@ -1706,7 +1704,6 @@ static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi
> >  
> >  	session->queued_cmdsn++;
> >  	spin_unlock(&session->lock);
> > -	spin_lock(host->host_lock);
> >  	return 0;
> >  
> >  prepd_reject:
> > @@ -1716,7 +1713,6 @@ reject:
> >  	spin_unlock(&session->lock);
> >  	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
> >  			  sc->cmnd[0], reason);
> > -	spin_lock(host->host_lock);
> >  	return SCSI_MLQUEUE_TARGET_BUSY;
> >  
> >  prepd_fault:
> > @@ -1732,12 +1728,10 @@ fault:
> >  		scsi_out(sc)->resid = scsi_out(sc)->length;
> >  		scsi_in(sc)->resid = scsi_in(sc)->length;
> >  	}
> > -	done(sc);
> > -	spin_lock(host->host_lock);
> > +	sc->scsi_done(sc);
> >  	return 0;
> >  }
> >  
> > -DEF_SCSI_QCMD(iscsi_queuecommand)
> >  EXPORT_SYMBOL_GPL(iscsi_queuecommand);
> >  
> >  int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
> > -- 
> > 1.7.3.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
