From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: RE: [PATCH v2] Hard disk S3 resume time optimization
Date: Fri, 9 Aug 2013 20:38:40 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A1706810E3@FMSMSX103.amr.corp.intel.com>
References: <11E08D716F0541429B7042699DD5C1A170680F5C@FMSMSX103.amr.corp.intel.com>,<1376033147.1902.6.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1376033147.1902.6.camel@linux-fkkt.site>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

I'll redo the ata portion as a separate patch, thanks for the feedback. For the sd.c changes the basic structure hasn't changed from the synchronous version, if any commands come in while the start command is still executing, they're queued up and held until the start has completed. But I'll do additional testing to really flex those scenarios to be sure there are no issues.

Todd Brandt
Linux Kernel Developer OTC, Hillsboro OR
https://opensource.intel.com/linux-wiki/ToddBrandt


________________________________________
From: Oliver Neukum [oneukum@suse.de]
Sent: Friday, August 09, 2013 12:25 AM
To: Brandt, Todd E
Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org; Tejun Heo; Greg Kroah-Hartman; Alan Stern
Subject: Re: [PATCH v2] Hard disk S3 resume time optimization

On Fri, 2013-08-09 at 01:09 +0000, Brandt, Todd E wrote:

>  static struct ata_force_ent *ata_force_tbl;
>  static int ata_force_tbl_size;
> +int ata_resume_status;

A single global variable for multiple ports?

>  static char ata_force_param_buf[PAGE_SIZE] __initdata;
>  /* param_buf is thrown away after initialization, disallow read */
> @@ -5415,6 +5416,22 @@ static int ata_port_resume(struct device *dev)
>       return rc;
>  }
>
> +static int ata_port_resume_async(struct device *dev)
> +{
> +     struct ata_port *ap = to_ata_port(dev);
> +
> +     ata_resume_status = 0;
> +     ata_port_request_pm(ap, PMSG_RESUME, ATA_EH_RESET,
> +             ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, &ata_resume_status);

If this ever runs in paralell it is extremely racy.

> +     if (!ata_resume_status) {
> +             pm_runtime_disable(dev);
> +             pm_runtime_set_active(dev);
> +             pm_runtime_enable(dev);
> +     }
> +
> +     return ata_resume_status;
> +}
> +


> +     req = blk_get_request(sdkp->device->request_queue, 0, __GFP_WAIT);

What happens if commands go to the device before this has finished?
Especially should it fail.

        Regards
                Oliver


