From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 1/2]scsi: scsi_run_queue() doesn't use local list to
 handle starved sdev
Date: Thu, 22 Dec 2011 19:17:25 -0600
Message-ID: <1324603045.9282.2.camel@dabdike.cust.hotspot.t-mobile.com>
References: <1324523412.22361.471.camel@sli10-conroe>
	 <1324578449.9709.15.camel@dabdike.int.hansenpartnership.com>
	 <1324600851.22361.475.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36556 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab1LWBRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2011 20:17:36 -0500
In-Reply-To: <1324600851.22361.475.camel@sli10-conroe>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ted Ts'o <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>, "Darrick J. Wong" <djwong@us.ibm.com>

On Fri, 2011-12-23 at 08:40 +0800, Shaohua Li wrote:
> On Thu, 2011-12-22 at 18:27 +0000, James Bottomley wrote:
> > On Thu, 2011-12-22 at 11:10 +0800, Shaohua Li wrote:
> > > scsi_run_queue() picks off all sdev from host starved_list to a local list,
> > > then handle them. If there are multiple threads running scsi_run_queue(),
> > > the starved_list will get messed. This is quite common, because request
> > > rq_affinity is on by default.
> > > 
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > ---
> > >  drivers/scsi/scsi_lib.c |   21 ++++++++++++++-------
> > >  1 file changed, 14 insertions(+), 7 deletions(-)
> > > 
> > > Index: linux/drivers/scsi/scsi_lib.c
> > > ===================================================================
> > > --- linux.orig/drivers/scsi/scsi_lib.c	2011-12-21 16:56:23.000000000 +0800
> > > +++ linux/drivers/scsi/scsi_lib.c	2011-12-22 09:33:09.000000000 +0800
> > > @@ -401,9 +401,8 @@ static inline int scsi_host_is_busy(stru
> > >   */
> > >  static void scsi_run_queue(struct request_queue *q)
> > >  {
> > > -	struct scsi_device *sdev = q->queuedata;
> > > +	struct scsi_device *sdev = q->queuedata, *head_sdev = NULL;
> > >  	struct Scsi_Host *shost;
> > > -	LIST_HEAD(starved_list);
> > >  	unsigned long flags;
> > >  
> > >  	/* if the device is dead, sdev will be NULL, so no queue to run */
> > > @@ -415,9 +414,8 @@ static void scsi_run_queue(struct reques
> > >  		scsi_single_lun_run(sdev);
> > >  
> > >  	spin_lock_irqsave(shost->host_lock, flags);
> > > -	list_splice_init(&shost->starved_list, &starved_list);
> > >  
> > > -	while (!list_empty(&starved_list)) {
> > > +	while (!list_empty(&shost->starved_list)) {
> > 
> > The original reason for working from a copy instead of the original list
> > was that the device can end up back on the starved list because of a
> > variety of conditions in the HBA and so this would cause the loop not to
> > exit, so this piece of the patch doesn't look right to me.
> +               /*
> +                * the head sdev is no longer starved and removed from the
> +                * starved list, select a new sdev as head.
> +                */
> +               if (head_sdev == sdev && list_empty(&sdev->starved_entry))
> +                       head_sdev = NULL;
> I had this in the loop, which is to guarantee the loop will exit if a
> device is removed from the starved list.

And the non-head sdevs? which can also get put back onto the list

What's the reason for not just traversing the list once using list
splice?

Basically, the changelog doesn't seem to explain what you're doing and
the logic looks flawed.

James


