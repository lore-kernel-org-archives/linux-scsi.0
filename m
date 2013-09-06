From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND 1/2] Hard disk S3 resume time optimization
Date: Fri, 6 Sep 2013 15:45:35 -0700
Message-ID: <20130906224534.GD7205@linux.intel.com>
References: <20130906003852.GC25263@linux.intel.com>
 <2115560.nTPvnSceni@amdc1032>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38007 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3IFWpd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Sep 2013 18:45:33 -0400
Content-Disposition: inline
In-Reply-To: <2115560.nTPvnSceni@amdc1032>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Sep 06, 2013 at 06:54:48PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday, September 05, 2013 05:38:53 PM Todd E Brandt wrote:
> > This is the final draft of the non-blocking hard disk resume patch. I've
> > included some performance results to demonstrate the real benefits
> > of this patch. Please note that this patch provides a MASSIVE performance
> > improvement in hard disk resume. It's too valuable to ignore, so I really
> > need the help of the maintainers to get this implemented. Even if this
> > patch is deemed the wrong approach I hope you won't abandon the idea
> > altogether. There is so much potential in this kind of optimization and
> > I'm highly motivated to make this work.
> > 
> > To demonstrate the substantial performance improvement I've run the 
> > AnalyzeSuspend tool on three different platforms patched with the new 
> > behavior. Each is running Ubuntu Raring with a kernel built from the 
> > upstream kernel source.
> > 
> > The complete analysis and graphical outputs of the tool are available
> > online at 01.org:
> > https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach
> 
> Please include changes descriptions from the link above in the actual patch
> descriptions.
> 
> "The essential issue behind hard disks' lengthy resume time is the ata
> port driver blocking until the ATA port hardware is finished coming online.
> So the kernel isn't really doing anything during all those seconds that
> the disks are resuming, it's just blocking until the hardware says it's
> ready to accept commands. This patch changes the ATA port driver to issue
> the wakeup command and then return immediately. Any commands issued to
> the hardware will be queued up and will be executed once the port is
> physically online. Thus no information is lost, and although the wait
> time itself isn't removed, it doesn't hold up the rest of the system
> which can function on what's left in RAM and cache."
> 

 What happens when somebody requests suspend while ATA port resume is still
 running?

The suspend request is queued until the resume has completed. I've tested
that case very heavily. Basically if you do two suspends in a row (within
seconds of each other) you lose any performance benefit, but that's a use
case that should happen only very rarerly (and wouldn't be expected to
be of any power benefit since too many sequential suspends actually
takes more power than just letting the machine stay in run mode).

> 
> > Here's a synopsis of the results.
> > 
> > -------------------------------------------------------
> > [Computer One]
> > PLATFORM: Ubuntu Raring Ringtail (13.04)
> > KERNEL: 3.11.0-rc7
> > CPU: Intel(R) Core(TM) i7-3960X CPU @ 3.30GHz
> > SATA: Intel C600/X79 series chipset 6-Port SATA AHCI (r5)
> > DISK CONFIG:
> >     ATA1: 240 GB SSD
> >     ATA2: 3 TB Hard Disk
> >     ATA3: 500 GB Hard Disk
> >     ATA4: DVD-ROM (with cd inserted)
> >     ATA5: 2 TB Hard Disk
> >     ATA6: 1 TB Hard Disk
> > RESUME TIME WITHOUT PATCH: 11656 ms
> > RESUME TIME WITH PATCH: 1110 ms

 These results are with both patches applied, could you tell what is
 the improvement from the patch #1 alone?

With either patch alone there is no benefit. I've tested with each
patch applied independently to verify that they function, but you 
can't get the benefit without both. 

 Where is the 11s delay coming from? Are we doing the resume for all 
 ports sequentially instead of in parallel? In such case you should be
 fixing the power management layer instead.

The ATA ports are all resumed in parallel. The long resume time
comes from extremely large drives. The ATA port wakeup delay is
the hardware running an internal subroutine to reinitialize the
connection, which I guess takes longer for bigger disks. I'm not
completely sure what it's doing, I just know that there's nothing
software can do to speed it up.

> > IMPROVEMENT: 10.5X speedup
> > 
> > -------------------------------------------------------
> > [Computer Two]
> > PLATFORM: Ubuntu Raring Ringtail (13.04)
> > KERNEL: 3.11.0-rc7
> > CPU: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
> > SATA: Intel 7 Series/C210 Series Chipset Family 6-port SATA [AHCI mode] (r4)
> > DISK CONFIG:
> >     ATA1: 320 GB Hard Disk
> >     ATA2 - ATA6: Empty slots
> > RESUME TIME WITHOUT PATCH: 5416 ms
> > RESUME TIME WITH PATCH: 448 ms
> > 
> > IMPROVEMENT: 12X speedup
> > 
> > -------------------------------------------------------
> > [Computer Three]
> > PLATFORM: Ubuntu Raring Ringtail (13.04)
> > KERNEL: 3.11.0-rc7
> > CPU: Intel(R) Core(TM) i7-4770S CPU @ 3.10GHz
> > SATA: Intel Lynx Point 6-port SATA Controller 1 [AHCI mode] (r2)
> > DISK CONFIG:
> >     ATA1,3,4,6: Empty Slots
> >     ATA2: DVD-ROM (empty)
> >     ATA5: 500 GB Hard Disk
> > RESUME TIME WITHOUT PATCH: 5385 ms
> > RESUME TIME WITH PATCH: 688 ms
> > 
> > IMPROVEMENT: 7.8X speedup
> > 
> > -------------------------------------------------------
> > 
> > Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > 
> >  drivers/ata/libata-core.c | 36 +++++++++++++++++++++++++++++++++++-
> >  1 file changed, 35 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > index c24354d..6cf0c15 100644
> > --- a/drivers/ata/libata-core.c
> > +++ b/drivers/ata/libata-core.c
> > @@ -5415,6 +5415,40 @@ static int ata_port_resume(struct device *dev)
> >  	return rc;
> >  }
> >  
> > +static int ata_port_resume_async(struct device *dev)
> > +{
> > +	struct ata_port *ap = to_ata_port(dev);
> > +	struct ata_link *link;
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
> > +		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
> > +		ret = -EAGAIN;
> > +		goto out;
> > +	}
> > +
> > +	spin_lock_irqsave(ap->lock, flags);
> > +
> > +	ap->pm_mesg = PMSG_RESUME;
> > +	ap->pm_result = NULL;
> > +	ap->pflags |= ATA_PFLAG_PM_PENDING;
> > +	ata_for_each_link(link, ap, HOST_FIRST) {
> > +		link->eh_info.action |= ATA_EH_RESET;
> > +		link->eh_info.flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
> > +	}
> > +
> > +	ata_port_schedule_eh(ap);
> > +
> > +	spin_unlock_irqrestore(ap->lock, flags);
> 

 Why have you open-coded ata_port_request_pm() instead of just re-using it
 but with "async" parameter set?

Because the async mode call requires a place to capture the value, and in
this case I want to ignore it. The PM subsystem doesn't supply any method
of checking on the status of a resume callback that's running asynchronously
because it has no way of knowing. So without altering the pm code there's
no point in collecting it.

> 
> > + out:
> > +	pm_runtime_disable(dev);
> > +	pm_runtime_set_active(dev);
> > +	pm_runtime_enable(dev);
> > +	return ret;
> > 
> > +}
> > 
> >  /*
> >   * For ODDs, the upper layer will poll for media change every few seconds,
> >   * which will make it enter and leave suspend state every few seconds. And
> > @@ -5451,7 +5485,7 @@ static int ata_port_runtime_resume(struct device *dev)
> >  
> >  static const struct dev_pm_ops ata_port_pm_ops = {
> >  	.suspend = ata_port_suspend,
> > -	.resume = ata_port_resume,
> > +	.resume = ata_port_resume_async,
> 

 ->resume will now return success even though it can later fail during
 the async operation (error value will be lost), this is no-go, sorry.

Yes, that's the nature of the asynchronous paradigm. The return value in this 
case is the status of whether the resume was initiated, rather than if it was 
completed. I'm letting the scsi and ata drivers assume control over their
own error reporting in this case (which they already do). If you look at 
the ata_port resume code you'll see that the ata_port_resume callback returns
the status of the ahci_port_resume callback, which is always 0. So for SATA 
disks the returned value for the resume callback is always 0. Error 
handling and reporting is taken care of in the scsi error handler thread, 
which runs separately from the pm core. I agree that in general it's a 
"no-go" to ignore a return value, but in this specific case for this 
specific driver, the return value is erronuous anyway, so there's no 
harm in ignoring it.

> 
> Also it seems that ata_port_resume() becomes unused after this change.
> 
> >  	.freeze = ata_port_do_freeze,
> >  	.thaw = ata_port_resume,
> >  	.poweroff = ata_port_poweroff,
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
