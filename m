From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: RE: [PATCH] Hard disk S3 resume time optimization
Date: Fri, 2 Aug 2013 16:41:18 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A1706804B6@FMSMSX103.amr.corp.intel.com>
References: <11E08D716F0541429B7042699DD5C1A1706803A6@FMSMSX103.amr.corp.intel.com>,<1375447356.2138.13.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1375447356.2138.13.camel@linux-fkkt.site>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Do you mean in terms of debug after a failure? I can resubmit the patch with the scsi_sense_hdr buffer still in place. I just wanted to keep the first draft simple to get the concept across. 

Todd Brandt
Linux Kernel Developer OTC, Hillsboro OR
https://opensource.intel.com/linux-wiki/ToddBrandt


________________________________________
From: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.org] on behalf of Oliver Neukum [oneukum@suse.de]
Sent: Friday, August 02, 2013 5:42 AM
To: Brandt, Todd E
Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Hard disk S3 resume time optimization

On Thu, 2013-08-01 at 23:40 +0000, Brandt, Todd E wrote:
> This patch is a potential way to reduce the S3 resume time for SATA drives. Essentially this patch removes the hard disk resume time from the total system resume time, with the disks still taking as long to come back online but in the background.
>
> The major bottleneck is in the ata port resume which sends out a wakeup command and then waits up to several seconds for the port to resume. This patch changes the ata_port_resume_common function to be non blocking. The other bottleneck is in the scsi disk resume code, which issues a a command to startup the disk with blk_execute_rq, which then waits for the command to finish (which also depends on the ata port being fully resumed). The patch switches the sd_resume function to use blk_execute_rq_nowait instead (the underlying code is identical to sd_resume, but is changed to non-blocking).

But how do we know the command has succeeded?

        Regards
                Oliver


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
