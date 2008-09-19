From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 2/2] scsi: exports busy status via
	bdi_lld_congested
Date: Fri, 19 Sep 2008 13:28:45 -0400 (EDT)
Message-ID: <20080919.132845.59649006.k-ueda@ct.jp.nec.com>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
	<20080919.104922.97297160.k-ueda@ct.jp.nec.com>
	<48D3CDEC.9060407@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48D3CDEC.9060407@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: michaelc@cs.wisc.edu
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

On Fri, 19 Sep 2008 11:06:04 -0500, Mike Christie wrote:
> Kiyoshi Ueda wrote:
> > This patch change scsi mid layer to export its busy status.
> > Not set the busy flag, when scsi can't dispatch I/Os anymore and
> > needs to kill I/Os.  Otherwise, request stacking drivers may hold
> > requests forever.
> > 
> > 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  drivers/scsi/scsi.c     |    4 ++--
> >  drivers/scsi/scsi_lib.c |   23 ++++++++++++++++++++++-
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
> > ===================================================================
> > --- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c
> > +++ scsi-misc-2.6/drivers/scsi/scsi_lib.c
> > @@ -459,17 +459,30 @@ static void scsi_init_cmd_errh(struct sc
> >  
> >  void scsi_device_unbusy(struct scsi_device *sdev)
> >  {
> > +	int host_congested;
> >  	struct Scsi_Host *shost = sdev->host;
> >  	unsigned long flags;
> >  
> >  	spin_lock_irqsave(shost->host_lock, flags);
> >  	shost->host_busy--;
> > +	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> > +	    shost->host_blocked || shost->host_self_blocked ||
> > +	    scsi_host_in_recovery(shost))
> > +		host_congested = 1;
> > +	else
> > +		host_congested = 0;
> > +
> 
> You might want to check if the starget busy too (scsi-misc has this but 
> Jens's tree and linus do not)? The code below that I snipped from 
> scsi_request_fn will set the congested bits if scsi_target_queue_ready 
> returns 0, so above here you would want to clear it if it not congested 
> anymore.

Yes, thank you for noticing that.
Since I was looking at scsi-misc and your target patch is in
scsi-post-merge, I overlooked it.
I'll rebase my patches and repost again.

Thanks,
Kiyoshi Ueda
