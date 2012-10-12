From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v2 1/5] sd: put to stopped power state when runtime
 suspend
Date: Fri, 12 Oct 2012 14:45:20 +0800
Message-ID: <20121012064518.GA2165@mint-spring.sh.intel.com>
References: <1349932091-6856-2-git-send-email-aaron.lu@intel.com>
 <Pine.LNX.4.44L0.1210111039510.1170-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2JLGp1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 02:45:27 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1210111039510.1170-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Thu, Oct 11, 2012 at 10:50:37AM -0400, Alan Stern wrote:
> On Thu, 11 Oct 2012, Aaron Lu wrote:
> 
> > When device is runtime suspended, put it to stopped power state to save
> > some power.
> > 
> > This will also make the behaviour consistent with what the scsi_pm.c
> > thinks about sd as the comment says:
> > sd treats runtime suspend, system suspend and system hibernate identical.
> > With this patch, it is now identical.
> > And sd_shutdown will also do nothing when it finds the device has been
> > runtime suspended, if we do not spin down the disk in runtime suspend
> > by putting it into stopped power state, the disk will be shut down
> > incorrectly.
> > And the the same problem can be solved for runtime power off after
> > runtime suspended case by this change.
> > 
> > With the current runtime scheme for disk, it will only be runtime
> > suspended when no process opens the disk, so this shouldn't happen a
> > lot, which makes it acceptable to spin down the disk when runtime
> > suspended. If some day a more aggressive runtime scheme is used, like
> > the 'request based runtime pm for disk' that Alan Stern and Lin Ming
> > has been working, we can introduce some policy to control this. But for
> > now, make it simple and correct by spinning down the disk.
> > 
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > ---
> >  drivers/scsi/sd.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 12f6fdf..8b6e004 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2911,7 +2911,8 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
> >  			goto done;
> >  	}
> >  
> > -	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
> > +	if (((mesg.event & PM_EVENT_SLEEP) || PMSG_IS_AUTO(mesg)) &&
> > +			sdkp->device->manage_start_stop) {
> 
> This is more complicated than it needs to be.  Any suspend is either a
> system sleep or an autosuspend, so the test doesn't have to be there at

There is also the freeze case, in which no need to stop the drive.

> all.  But since you remove the test anyway in patch 5/5, this doesn't
> matter very much.  If you end up resubmitting these patches, you might
> as well get rid of the test in this one.
> 
> Overall this series is much better than before; thanks for rewriting 
> it.

Thanks for your suggestion which made the patch a lot better :-)

-Aaron

