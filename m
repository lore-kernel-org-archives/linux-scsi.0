From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Mon, 10 Mar 2014 16:43:14 -0400
Message-ID: <20140310204314.GH25290@htj.dyndns.org>
References: <Pine.LNX.4.44L0.1403071028440.1246-100000@iolanthe.rowland.org>
 <1394247126.10864.3.camel@dwillia2-mobl2.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1394247126.10864.3.camel@dwillia2-mobl2.amr.corp.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, JBottomley@Parallels.com, Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, Phillip Susi <psusi@ubuntu.com>, linux-ide@vger.kernel.org, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 07, 2014 at 06:52:06PM -0800, Dan Williams wrote:
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

The only thing which is a bit concerning is that this doesn't have any
throttling mechanism for simultaneous wakeups.  Would this be able to
blow up the PSU if used on a machine with a lot of spindles?

Thanks.

-- 
tejun
