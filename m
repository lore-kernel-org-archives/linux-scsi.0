From: Markus Reichelt <ml@mareichelt.com>
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion
 (resid=78, sector_sz=512)
Date: Sat, 3 Aug 2019 13:36:06 +0200
Message-ID: <20190803113606.GB3746@pc21.mareichelt.com>
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I can reproduce this with kernel 5.2.2 and a WD drive (WD40EZRZ-22GXCB0)
in a USB 3.0 enclosure featuring a JMicron SATA Bridge (ID 152d:2329)

I'm also interested in getting rid of the warnings.

* Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile
> back and ran some file copy tests and was getting these warnings--
> is there any way to avoid these warnings?  I did confirm with
> parted that the partition was aligned but this appears to be
> something related to the firmware on the device according to [1]
> and [2]?
> 
> [1] https://patchwork.kernel.org/patch/9573203/
> [2] https://patchwork.kernel.org/patch/9597797/
> 
> Part of the patch in [2] - if the firmware is buggy is there a
> patch or workaround for these drives (when used in the USB
> enclosures) to avoid this issue?
> 
> +	default:
> +		/*
> +		 * In case of bogus fw or device, we could end up having
> +		 * an unaligned partial completion. Check this here and
> force
> +		 * alignment.
> +		 */
> +		resid = scsi_get_resid(SCpnt);
> +		if (resid & (sector_size - 1)) {
> +			sd_printk(KERN_INFO, sdkp,
> +				"Unaligned partial completion (resid=%u,
> sector_sz=%u)\n",
> +				resid, sector_size);
> +			resid = min(scsi_bufflen(SCpnt),
> +				    round_up(resid, sector_size));
> +			scsi_set_resid(SCpnt, resid);
> +		}
> 
> Errors:
> 
> Jul 18 16:25:02 name kernel: [87305.605993] sd 8:0:0:0: [sdg] Unaligned
> partial completion (resid=78, sector_sz=512)
> Jul 18 16:25:02 name kernel: [87305.605993] sd 8:0:0:0: [sdg] Unaligned
> partial completion (resid=78, sector_sz=512)
> 
> Jul 18 16:25:15 name kernel: [87318.292262] sd 7:0:0:0: [sdf] Unaligned
> partial completion (resid=78, sector_sz=512)
> Jul 18 16:25:15 name kernel: [87318.292262] sd 7:0:0:0: [sdf] Unaligned
> partial completion (resid=78, sector_sz=512)

-- 
left blank, right bald
