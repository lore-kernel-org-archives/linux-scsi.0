From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] scsi_debug [was: scsi_debug issues]
Date: Fri, 22 Oct 2004 12:02:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022100212.GX1820@suse.de>
References: <20041015190154.GA3073@us.ibm.com> <4170C505.3000805@torque.net> <1097932370.1962.4.camel@mulgrave> <4173C8DB.8030009@torque.net> <20041018183747.GA3530@us.ibm.com> <41743E41.8020707@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:37295 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S270934AbUJVKCt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 06:02:49 -0400
Content-Disposition: inline
In-Reply-To: <41743E41.8020707@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

On Tue, Oct 19 2004, Douglas Gilbert wrote:
> Nishanth Aravamudan wrote:
> >On Mon, Oct 18, 2004 at 11:44:59PM +1000, Douglas Gilbert wrote:
> >
> >>James Bottomley wrote:
> >>
> >>>On Sat, 2004-10-16 at 01:51, Douglas Gilbert wrote:
> >>>
> >>>
> >>>>So this problem seems related to highmem.
> >
> >
> ><snip>
> >
> >>The above required a fair few changes to scsi_debug.
> >>Attached is a patch that rolls "kmap" changes with
> >>patches I have sent recently for scsi_debug.
> >>Attachment is gzipped (due to size) and applies against
> >>lk 2.6.8.1 -> lk 2.6.9-rc4 .
> >>
> >>Nishanth, could you test this with highmem?
> >
> >
> >Doug,
> >
> >I ran 2.6.9-rc4 with your patch applied and had several dump_stack()s
> >occur (complaining about sleeping in an invalid context) and a final
> >panic during mkfs :) I think something is still wrong... ;) Output is
> >below and attached.
> 
> Ok, it looks like kmap_atomic() is needed.
> Could you try this additional patch.
> 
> Doug Gilbert

> --- linux/drivers/scsi/scsi_debug.c	2004-10-19 07:59:14.966673272 +1000
> +++ linux/drivers/scsi/scsi_debug.c174b	2004-10-19 07:58:46.044070176 +1000
> @@ -56,7 +56,7 @@
>  #include "scsi_debug.h"
>  
>  #define SCSI_DEBUG_VERSION "1.74"
> -static const char * scsi_debug_version_date = "20041018";
> +static const char * scsi_debug_version_date = "20041019";
>  
>  /* Additional Sense Code (ASC) used */
>  #define NO_ADDED_SENSE 0x0
> @@ -505,7 +505,8 @@
>  	active = 1;
>  	for (k = 0, req_len = 0, act_len = 0; k < scp->use_sg; ++k, ++sgpnt) {
>  		if (active) {
> -			kaddr = (unsigned char *)kmap(sgpnt->page);
> +			kaddr = (unsigned char *)
> +				kmap_atomic(sgpnt->page, KM_USER0);
>  			if (NULL == kaddr)
>  				return (DID_ERROR << 16);
>  			kaddr = (unsigned char *)kaddr + sgpnt->offset;
> @@ -515,7 +516,7 @@
>  				len = arr_len - req_len;
>  			}
>  			memcpy(kaddr, arr + req_len, len);
> -			kunmap(sgpnt->page);
> +			kunmap_atomic(sgpnt->page, KM_USER0);

BUG, kunmap_atomic(kaddr) (without the offset).

Also do make sure that you stay on the same cpu from calling kmap_atomic
to kunmap_atomic(). If you are under the queue_lock you are fine, I
didn't check if this is the case for all your calls.

-- 
Jens Axboe

