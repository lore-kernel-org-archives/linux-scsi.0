From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Sat, 11 Jan 2014 14:13:15 -0500
Message-ID: <20140111191315.GC3257@mtj.dyndns.org>
References: <20140108005607.GB29556@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140108005607.GB29556@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Todd E Brandt <todd.e.brandt@linux.intel.com>
Cc: James.Bottomley@HansenPartnership.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Jan 07, 2014 at 04:56:07PM -0800, Todd E Brandt wrote:
> On resume, the ATA port driver currently waits until the AHCI controller
> finishes executing the port wakeup command. This patch changes the

Is there anything ahci specific about this?  There shouldn't be.

> This patch only changes the behavior of the resume callback, not restore,
> thaw, or runtime-resume. This is because thaw and restore are used after a
> suspend-to-disk, which means that an image needs to be read from swap and
> reloaded into RAM. The swap disk will always need to be fully restored/thawed
> in order for resume to continue.

If the system has multiple devices, wouldn't that still reduce the
latency?  Do we really need to deviate behavior among different
resume/unfreeze paths?

> The return value from ata_resume_async is now an indicator of whether 
> the resume was initiated, rather than if it was completed. I'm letting the ata
> driver assume control over its own error reporting in this case (which it does
> already). If you look at the ata_port resume code you'll see that the
> ata_port_resume callback returns the status of the ahci_port_resume callback,
> which is always 0. So I don't see any harm in ignoring it.

I've been always kinda doubtful about the usefulness of resume return
code.  It's not like there's anything resume path can do differently
upon being notified that resume of a device failed.  Just reporting
success and deal with error conditions as usual should work fine,
right?

Well, in fact, I don't think even the return code of suspend is
useful.  Failing suspend is most likely wrong.  The only action PM
core can take is aborting suspend and AFAICS none of the libata
drivers has suspend failure conditions whose recoverability is made
worse by just proceeding with suspend.  The hardware is recycled after
all anyway.  The device is inoperational anyway, so aborting suspend
doens't buy us anything other than failing suspend, which is almost
always wrong.  So, I'd actually prefer just removing all returns from
suspend/resume operations, but yeah this might be out of scope for
this series.

> +static int ata_port_resume_async(struct device *dev)
> +{
> +       int rc;
> +
> +       rc = ata_port_resume_common(dev, PMSG_RESUME, true);
> +       if (!rc) {
> +               pm_runtime_disable(dev);
> +               pm_runtime_set_active(dev);
> +               pm_runtime_enable(dev);
> +       }
> +
> +       return rc;
>  }

So, can't just everything become async?  Are there cases where we
*need* synchronous PM behaviors?

Thanks.

-- 
tejun
