From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: RE: [PATCH v2] Hard disk S3 resume time optimization
Date: Fri, 9 Aug 2013 20:44:16 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A1706810F4@FMSMSX103.amr.corp.intel.com>
References: <11E08D716F0541429B7042699DD5C1A170680F5C@FMSMSX103.amr.corp.intel.com>,<Pine.LNX.4.44L0.1308091350300.1405-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1308091350300.1405-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Oliver Neukum <oneukum@suse.de>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

I apologize for the text wrapping issue, our mail server is very outlook centric and I didn't know the weird formatting issues would happen until the mail showed up on the mailing list. It won't happen again.

I'll also change the formatting back to the way it was originally. I tend to be wary of goto's which is why I took them out, but your right, my changes do deviate from the proper kernel coding style. Thanks for the feedback!

Todd Brandt
Linux Kernel Developer OTC, Hillsboro OR
https://opensource.intel.com/linux-wiki/ToddBrandt


________________________________________
From: Alan Stern [stern@rowland.harvard.edu]
Sent: Friday, August 09, 2013 11:06 AM
To: Brandt, Todd E
Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org; Oliver Neukum; Tejun Heo; Greg Kroah-Hartman
Subject: Re: [PATCH v2] Hard disk S3 resume time optimization

Your email messages would be easier to work with if they were wrapped
after column 72 or so.

On Fri, 9 Aug 2013, Brandt, Todd E wrote:

> This patch essentially removes the disk spinup wait time from the system S3 resume delay. It can be a very significant improvement on systems with large SATA disks which can take several seconds to spin up. On the systems I've tested this patch reduces the resume time to around half a second (assuming no USB devices are consuming that time). Without the patch my systems require anywhere from 5 to 12 seconds to wakeup from S3 resume depending on the size of the disks attached.
>
> This is a rewrite of my first attempt to optimize S3 disk resume time: http://marc.info/?l=linux-ide&m=136874337908364&w=2 . It's vastly simpler in that it doesn't make any alterations at all to the pm subsystem to allow non-blocking resume, it simply enables the ata_port and scsi_disk drivers to do their work in a non-blocking way.
>
> Made some alterations to the first draft of the patch, this is v2.
>
> 1) Added scsi cmd error reporting in response to Oliver's comments. The sd_resume_async_end function now prints out the same error information that was printed in the sd_start_stop_device call; including the sense buffer contents. I didn't add any additional error messages for the ata port wakeup since, if the port wakeup fails, the error data is printed out by the error handler process itself, so it doesn't require the ata_port_resume call to check up on it after the failure. The only potential issue is that the ata_port_resume_async call sets the ata port device to RPM_ACTIVE even if the ata_eh_handle_port_resume call fails, but there doesn't appear to be any code which actually calls pm_runtime_set_suspended for ata_ports at the moment, so the ata_port appears to always be set to RPM_
 ACTIVE anyway (please correct me if I'm wrong).
> 2) I created a new ata_port_resume_async function just for the "resume" callback so that it wouldn't affect the thaw, restore, or runtime resume callback behaviour (just to be on the safe side).
> 3) I also moved the scsi_disk_put call up into the sd_resume_async_end callback since the reference counter shouldn't be decremented until the disk is actually finished starting.
>
> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>

I will comment only on the sd.c portion.

> +static int sd_resume_async(struct device *dev)
> +{
> +     unsigned char cmd[6] = { START_STOP };
> +     struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +     struct request *req;
> +     char *sense = NULL;
> +
> +     if (!sdkp->device->manage_start_stop) {
> +             scsi_disk_put(sdkp);
> +             return 0;
> +     }
> +
> +     sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> +
> +     cmd[4] |= 1;
> +
> +     if (sdkp->device->start_stop_pwr_cond)
> +             cmd[4] |= 1 << 4;       /* Active or Standby */
> +
> +     if (!scsi_device_online(sdkp->device)) {
> +             scsi_disk_put(sdkp);
> +             return -ENODEV;
> +     }
> +
> +     req = blk_get_request(sdkp->device->request_queue, 0, __GFP_WAIT);
> +     if (!req) {
> +             scsi_disk_put(sdkp);
> +             return DRIVER_ERROR << 24;
> +     }
> +
> +     sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
> +     if (!sense) {
> +             __blk_put_request(req->q, req);
> +             scsi_disk_put(sdkp);
> +             return DRIVER_ERROR << 24;
> +     }

The usual idiom for situations like this is:

        if (!scsi_device_online(...)) {
                rc = -ENODEV;
                goto err_online;
        }

        if (!req) {
                retval = DRIVER_ERROR << 24;
                goto err_get_request;
        }

        if (!sense) {
                retval = DRIVER_ERROR << 24;
                goto err_sense;
        }
...

Also, the return values here don't really make sense.  This routine
isn't invoked by part of the SCSI stack; it is called (indirectly) by
the PM layer.  Hence the only sensible error codes are generic things
like -ENOMEM or -EIO.

Apart from these minor issues, this part seems okay.

Alan Stern

