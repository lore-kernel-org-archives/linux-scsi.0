From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Mon, 10 Mar 2014 11:49:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403101148340.22665-100000@netrider.rowland.org>
References: <1394247126.10864.3.camel@dwillia2-mobl2.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1394247126.10864.3.camel@dwillia2-mobl2.amr.corp.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tj@kernel.org, JBottomley@Parallels.com, Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, Phillip Susi <psusi@ubuntu.com>, linux-ide@vger.kernel.org, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 7 Mar 2014, Dan Williams wrote:

> On Fri, 2014-03-07 at 10:42 -0500, Alan Stern wrote:
> > >  #ifdef CONFIG_PM_SLEEP
> > >  
> > > +#define do_pm_op(dev, op) \
> > > +	dev->driver ? dev->driver->pm ? \
> > > +	dev->driver->pm->op(dev) : 0 : 0
> > 
> > This will crash if dev->driver->pm->op is NULL.  How about making it 
> > easier to read, too?
> > 
> > #define RETURN_PM_OP(dev, op)						\
> > 	if (dev->driver && dev->driver->pm && dev->driver->pm->op) 	\
> > 		return dev->driver->pm->op(dev);			\
> > 	else								\
> > 		return 0
> > 
> > static int do_scsi_suspend(struct device *dev)
> > {
> > 	RETURM_PM_OP(dev, suspend);
> > }
> > 
> > etc.
> > 
> > Alternatively, you could put the "dev->driver && dev->driver->pm" part
> > of the test directly into scsi_dev_type_suspend and
> > scsi_dev_type_resume, to save a little code space.  Then the original 
> > macro formulation would become sufficiently simple: one test and one 
> > function call.
> [..]
> > Given that this function is used in only one place; I would put it 
> > inline.
> > 
> 
> Ended up putting the dev->driver->pm lookup into scsi_dev_type_{suspend|
> resume} directly, and open coding the pm->op is NULL check.
> 
> Moved the lookup of the async function inline.
> 
> 8<----------------
> Subject: scsi: async sd resume
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> async_schedule() sd resume work to allow disks and other devices to
> resume in parallel.
> 
> This moves the entirety of scsi_device resume to an async context to
> ensure that scsi_device_resume() remains ordered with respect to the
> completion of the start/stop command.  For the duration of the resume,
> new command submissions (that do not originate from the scsi-core) will
> be deferred (BLKPREP_DEFER).
> 
> It adds a new ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain) as a container
> of these operations.  Like scsi_sd_probe_domain it is flushed at
> sd_remove() time to ensure async ops do not continue past the
> end-of-life of the sdev.  The implementation explicitly refrains from
> reusing scsi_sd_probe_domain directly for this purpose as it is flushed
> at the end of dpm_resume(), potentially defeating some of the benefit.
> Given sdevs are quiesced it is permissible for these resume operations
> to bleed past the async_synchronize_full() calls made by the driver
> core.
> 
> We defer the resolution of which pm callback to call until
> scsi_dev_type_{suspend|resume} time and guarantee that the callback
> parameter is never NULL.  With this in place the type of resume
> operation is encoded in the async function identifier.
> 
> Inspired by Todd's analysis and initial proposal [2]:
> https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach
> 
> Cc: Len Brown <len.brown@intel.com>
> Cc: Phillip Susi <psusi@ubuntu.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> [alan: bug fix and clean up suggestion]
> Suggested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
> [djbw: kick all resume work to the async queue]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

