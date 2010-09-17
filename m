From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around
	SHT->queuecommand()
Date: Thu, 16 Sep 2010 20:02:32 -0700
Message-ID: <1284692552.13344.143.camel@haakon2.linux-iscsi.org>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
	 <1284691571.26423.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:48947 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753339Ab0IQDGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 23:06:41 -0400
In-Reply-To: <1284691571.26423.50.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>

On Thu, 2010-09-16 at 22:46 -0400, James Bottomley wrote:
> On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch converts scsi_dispatch_cmd() to only hold struct Scsi_Host->host_lock
> > for scsi_cmd_get_serial(), and drops the lock because the call into
> > the LLD with host->hostt->queuecommand().
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/scsi.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index ad0ed21..06e5b3a 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -745,6 +745,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> >  	 * TODO: kill serial or move to blk layer
> >  	 */
> >  	scsi_cmd_get_serial(host, cmd); 
> > +	spin_unlock_irqrestore(host->host_lock, flags);
> 
> So at least from where I stand, my object is to reduce the number of
> times we take and release the lock, which this doesn't do.  As I said
> before: we need to figure out the rest, which likely includes an atomic
> for the serial number (which is almost unused).  I think the check
> against SHOST_DEL is fine unlocked.
> 

Ok, this makes sense if the shost_state == SHOST_DEL check really is OK
to be done w/o host_lock held (I really don't know on this one..)

So if that is the case, then Tim and Vasu can you guys have a look at
dropping the host_lock around serial number usage and post this for
review..?  I will plan to include the host_lock'less serial number patch
into lio-core-2.6.git/drop-host_lock with the rest of the LLD driver
conversion patches from this afternoon and respin a new branch for James
and Co. to review.

Thanks!

--nab


