From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Thu, 2 Mar 2017 10:23:24 -0800
Message-ID: <20170302102324.47dbe3ad@xeon-e3>
References: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170228224845.1da358ee@xeon-e3>
        <20170301155057.GA13167@lst.de>
        <20170301075412.2e5f1e98@xeon-e3>
        <20170302000135.GA22886@lst.de>
        <20170302005615.GA23687@lst.de>
        <20170301174058.383da142@xeon-e3>
        <c8ff2b64-2421-ca45-1f89-afec0490c8b3@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:32832 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753954AbdCBSXg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 13:23:36 -0500
Received: by mail-pg0-f52.google.com with SMTP id 25so34821450pgy.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Mar 2017 10:23:32 -0800 (PST)
In-Reply-To: <c8ff2b64-2421-ca45-1f89-afec0490c8b3@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Thu, 2 Mar 2017 14:25:14 +0100
Hannes Reinecke <hare@suse.de> wrote:

> On 03/02/2017 02:40 AM, Stephen Hemminger wrote:
> > On Thu, 2 Mar 2017 01:56:15 +0100
> > Christoph Hellwig <hch@lst.de> wrote:
> >  
> >> On Thu, Mar 02, 2017 at 01:01:35AM +0100, Christoph Hellwig wrote:  
> >>> On Wed, Mar 01, 2017 at 07:54:12AM -0800, Stephen Hemminger wrote:  
> >>>>> 	http://git.infradead.org/users/hch/block.git/commitdiff/148cff67b401e2229c076c0ea418712654be77e4  
> >>>>
> >>>> It appears that is already in the code I am testing in linux-next...  
> >>>
> >>> It's in -next now, but it wasn't at the time you reported the bug.
> >>>
> >>> And it would sortof explain the bug if the INQUIRY data is correct
> >>> in the scatterlist, but we ignore it, given that scsi_probe_lun
> >>> ignores the result based on sense data.
> >>>
> >>> Can you check what happens with the horrible hack below:  
> >>
> >> Strike that - we're checking result later, so this can't be the case.
> >>
> >> Now the other interesting thing is the memset in __scsi_exectute,
> >> which looks very suspicious.  Try the following please:
> >>
> >> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >> index 3e32dc954c3c..22f4fb550561 100644
> >> --- a/drivers/scsi/scsi_lib.c
> >> +++ b/drivers/scsi/scsi_lib.c
> >> @@ -253,7 +253,8 @@ static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> >>  	 * and prevent security leaks by zeroing out the excess data.
> >>  	 */
> >>  	if (unlikely(rq->resid_len > 0 && rq->resid_len <= bufflen))
> >> -		memset(buffer + (bufflen - rq->resid_len), 0, rq->resid_len);
> >> +//		memset(buffer + (bufflen - rq->resid_len), 0, rq->resid_len);
> >> +		printk_ratelimited("%s: got resid %d\n", __func__, rq->resid_len);
> >>
> >>  	if (resid)
> >>  		*resid = rq->resid_len;  
> >
> >
> > Still fails but does print resid on some of the later INQUIRY commands (not the initial one).
> >  
> Can you test what happens if you blank out the storvsc_drv workaround:
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 585e54f..c36f42d 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1060,13 +1060,13 @@ static void storvsc_on_io_completion(struct 
> storvsc_device *stor_device,
>           * We do this so we can distinguish truly fatal failues
>           * (srb status == 0x4) and off-line the device in that case.
>           */
> -
> +#if 0
>          if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
>             (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
>                  vstor_packet->vm_srb.scsi_status = 0;
>                  vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
>          }
> -
> +#endif
> 
>          /* Copy over the status...etc */
>          stor_pkt->vm_srb.scsi_status = vstor_packet->vm_srb.scsi_status;
> 
> It might thappen that we're fail to interpret the 'Device not present' 
> status correctly (which will happen for non-connected DVDs) causing the 
> SCSI stack to make incorrect decisions later on.
> 
> Cheers,
> 
> Hannes

There are several oddities about the host SCSI interface that I see:
  1. The host bus seems to report up to 6 devices even though only 2 are
     present (Disk and CDROM).
  2. The CDROM emulation doesn't report the same status as a real device.
  3. The host emulation of SCSI doesn't support all the page codes which
     is why there is the hack.

But as James said, these don't appear to be related to the failure because
the code worked before and only in post 4.11 merege is there a problem.
