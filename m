From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: RE: [PATCH] Hard disk S3 resume time optimization
Date: Fri, 2 Aug 2013 17:12:58 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A170680503@FMSMSX103.amr.corp.intel.com>
References: <11E08D716F0541429B7042699DD5C1A1706803A6@FMSMSX103.amr.corp.intel.com>
	,<1375447356.2138.13.camel@linux-fkkt.site>
	 <11E08D716F0541429B7042699DD5C1A1706804B6@FMSMSX103.amr.corp.intel.com>,<1375463105.13494.0.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1375463105.13494.0.camel@linux-fkkt.site>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Errors are reported through printk. In the upstream kernel this is the spot where an error would be detected and reported for a bad sd_resume:

drivers/scsi/sd.c:3061

        if (res) {
                sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
                sd_print_result(sdkp, res);
                if (driver_byte(res) & DRIVER_SENSE)
                        sd_print_sense_hdr(sdkp, &sshdr);
        }

So it would print out the device id with a message that the start_stop failed, and then optionally print out the sense buffer if it was supplied.


Todd Brandt
Linux Kernel Developer OTC, Hillsboro OR
https://opensource.intel.com/linux-wiki/ToddBrandt


________________________________________
From: Oliver Neukum [oneukum@suse.de]
Sent: Friday, August 02, 2013 10:05 AM
To: Brandt, Todd E
Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Hard disk S3 resume time optimization

On Fri, 2013-08-02 at 16:41 +0000, Brandt, Todd E wrote:
> Do you mean in terms of debug after a failure? I can resubmit the patch with the scsi_sense_hdr buffer still in place. I just wanted to keep the first draft simple to get the concept across.
How are errors reported?

        Regards
                Oliver


