From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: add host SMP processing
Date: Sat, 29 Dec 2007 10:59:53 -0600
Message-ID: <1198947594.3264.31.camel@localhost.localdomain>
References: <1198884998.3174.5.camel@localhost.localdomain>
	 <200712290524.lBT5Ot2u004870@mbox.iij4u.or.jp>
	 <1198943072.3264.23.camel@localhost.localdomain>
	 <20071230010931H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60678 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056AbXL2RAA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Dec 2007 12:00:00 -0500
In-Reply-To: <20071230010931H.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp


On Sun, 2007-12-30 at 01:06 +0900, FUJITA Tomonori wrote:
> On Sat, 29 Dec 2007 09:44:32 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Sat, 2007-12-29 at 14:24 +0900, FUJITA Tomonori wrote:
> > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > --- a/drivers/scsi/libsas/sas_expander.c
> > > > +++ b/drivers/scsi/libsas/sas_expander.c
> > > > @@ -1896,11 +1896,9 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> > > >  	}
> > > >  
> > > >  	/* no rphy means no smp target support (ie aic94xx host) */
> > > > -	if (!rphy) {
> > > > -		printk("%s: can we send a smp request to a host?\n",
> > > > -		       __FUNCTION__);
> > > > -		return -EINVAL;
> > > > -	}
> > > > +	if (!rphy)
> > > > +		return sas_smp_host_handler(shost, req, rsp);
> > > > +
> > > 
> > > I have one related question.
> > > 
> > > Currently, bsg doesn't return an error to user space since I had no
> > > idea how to convert errors such as EINVAL and ENOMEM into
> > > driver_status, transport_status, and device_status in struct sg_io_v4.
> > > I think that it's confusing that bsg don't return an error even if SMP
> > > requests aren't sent (e.g. devices are offline).
> > > 
> > > Do we need to map errors to the current error code in scsi/scsi.h
> > > (like DID_*) or define a new one for SMP?
> > 
> > Neither, I think ... the DID codes are only for things that actually
> > pass through the SCSI stack.  The way you implemented the smp functions
> > in bsg, they're direct queue handlers themselves (Incidentally, that's
> > another point about this: I think almost every use of bsg like this is
> > going to be for SG_IO only, so it makes sense to move the actual queue
> > handler into bsg, since they'll all share it).
> > 
> > The attached is the simplest patch that implements this.  However, it
> > unfortunately can't be applied yet ... the current SMP tools send
> > receive buffers too large and libsas actually returns a data underrun
> > error (which is now propagated).
> 
> bsg read/write interface doens't return errors in this way (compatible
> with sg3 read/write interface). If we support only SG_IO for non SCSI
> request/response protocols, then that's fine.

OK, guilty of disliking the read/write interface (and therefore not
thinking about it).  However, it's easy to fix.  How about this?  Note,
I think returning errors when they occur is more important than
preserving compatibility and swallowing the error somewhere, especially
as the bsg v3 interface *only* dealt with SCSI, so this is more like an
extension to non-scsi error returning.  But if I'd had my way, bsg
wouldn't have had a read/write interface, so I'm happy to do whatever
people who actually use it want.

James
diff --git a/block/bsg.c b/block/bsg.c
index 8e181ab..69b0a9d 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -445,6 +445,15 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	else
 		hdr->dout_resid = rq->data_len;
 
+	/*
+	 * If the request generated a negative error number, return it
+	 * (providing we aren't already returning an error); if it's
+	 * just a protocol response (i.e. non negative), that gets
+	 * processed above.
+	 */
+	if (!ret && rq->errors < 0)
+		ret = rq->errors;
+
 	blk_rq_unmap_user(bio);
 	blk_put_request(rq);
 
@@ -837,6 +846,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct bsg_device *bd = file->private_data;
 	int __user *uarg = (int __user *) arg;
+	int ret;
 
 	switch (cmd) {
 		/*
@@ -889,12 +899,12 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (rq->next_rq)
 			bidi_bio = rq->next_rq->bio;
 		blk_execute_rq(bd->queue, NULL, rq, 0);
-		blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
+		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
 			return -EFAULT;
 
-		return 0;
+		return ret;
 	}
 	/*
 	 * block device ioctls
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 87e786d..f2149d0 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -173,6 +173,7 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 
 		handler = to_sas_internal(shost->transportt)->f->smp_handler;
 		ret = handler(shost, rphy, req);
+		req->errors = ret;
 
 		spin_lock_irq(q->queue_lock);
 


