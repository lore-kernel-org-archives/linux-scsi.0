From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/3] [SCSI] sd: fix runtime status check in sd_shutdown
Date: Thu, 15 Dec 2011 02:34:24 +0800
Message-ID: <1323887664.7655.5.camel@hp6530s>
References: <Pine.LNX.4.44L0.1112141146230.1707-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1112141146230.1707-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-15 at 00:49 +0800, Alan Stern wrote:
> On Wed, 14 Dec 2011, Lin Ming wrote:
> 
> > Commit af8db15 disabled device's runtime PM during shutdown.
> > So sd's runtime status can't be checked with pm_runtime_suspended(dev)
> > any more.
> > 
> > Fix it by checking runtime status with pm_runtime_status_suspended(dev).
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  drivers/scsi/sd.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 7b3f807..284b087 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2742,7 +2742,12 @@ static void sd_shutdown(struct device *dev)
> >  	if (!sdkp)
> >  		return;         /* this can happen */
> >  
> > -	if (pm_runtime_suspended(dev))
> > +	/*
> > +	 * Check runtime status with pm_runtime_status_suspended(dev)
> > +	 * instead of pm_runtime_suspended(dev),
> > +	 * because device_shutdown() has disabled the device's runtime PM.
> > +	 */
> > +	if (pm_runtime_status_suspended(dev))
> >  		goto exit;
> >  
> >  	if (sdkp->WCE) {
> 
> This is no longer needed.  See commit
> fe6b91f47080eb17d21cbf2a39311877d57f6938 (PM / Driver core: leave
> runtime PM enabled during system shutdown).

I'll remove this patch.

Thanks.

> 
> Alan Stern
> 
