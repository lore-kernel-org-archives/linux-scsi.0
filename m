From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Mon, 24 Oct 2005 09:59:35 +0200
Message-ID: <20051024075934.GK2811@suse.de>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023070011.GA26569@havoc.gtf.org> <435B6A62.8070306@torque.net> <435BBD9A.80603@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:65105 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1750780AbVJXH6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 03:58:48 -0400
Content-Disposition: inline
In-Reply-To: <435BBD9A.80603@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Sun, Oct 23 2005, Jeff Garzik wrote:
> Douglas Gilbert wrote:
> >Which in turn makes me think of applying the same idea
> >to max_sectors
> >
> >        shost->max_sectors = MAX_512B_SECTORS_UNLIMITED;
> 
> 
> Won't work.  max_sectors is communicated to the block layer, where we 
> limit the overall size of the request for practical reasons.
> 
> Read the comment in libata-scsi's slave_configure:
> 
>                 /* TODO: 1024 is an arbitrary number, not the
>                  * hardware maximum.  This should be increased to
>                  * 65534 when Jens Axboe's patch for dynamically
>                  * determining max_sectors is merged.
>                  */
> 
> Right now, setting the true hardware / command set maximum would use way 
> too much memory, with no way to get feedback from the VM.
> 
> This is why SCSI_DEFAULT_MAX_SECTORS is defined to 1024.

The block layer has had split values for quite some time, ->max_sectors
and max_hw_sectors. scsi_ioctl.c needs a patch to look at max_hw_sectors
instead and SCSI drivers could then easily be updated to advertise a
real hardware value as well. That is what shost->max_sectors should be,
SCSI mid layer would then set q->max_sectors to SCSI_DEFAULT_MAX_SECTORS
and q->max_hw_sectors to shost->max_sectors.

Then the limiting factor becomes BIO_MAX_PAGES for mapping in the user
data, which caps us at 1MiB currently.

-- 
Jens Axboe

