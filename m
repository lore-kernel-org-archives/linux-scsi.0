From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] SG_SET_RESERVED_SIZE negative oops
Date: Tue, 21 Oct 2003 08:42:32 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F9464D8.9080704@torque.net>
References: <1066688955.2814.3.camel@patehci2>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:7648 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S262859AbTJTWnK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 18:43:10 -0400
In-Reply-To: <1066688955.2814.3.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> Doug G:
> 
> I propose the 2.6.0-test8 two-line patch below to teach
> SG_SET_RESERVED_SIZE to reject a negative size, rather than oops-ing.
> 
> Whaddyathink?
> 
> I dreamed up this trivial patch after losing my console whenever I typed
> something like:
> 
> sg_dd of=/dev/sg0 bs=2k bpt=
> 
> Courtesy some Red Hat automagic that does a `sudo chown `id -u`
> /dev/sg0` to me, I find I can oops that way without involving full root
> privilege.
> 
> My short nightmare appears detailed as the linux-scsi thread re "sg_dd
> bpt= count=":
> http://marc.theaimsgroup.com/?t=106617534400002
> 
> That thread tells us `sg_dd of=/dev/sg0 bs=2k bpt=-1` is a less
> indeterminate way to cause such trouble.  Also a two-paragraph demo .c
> app appears there to demo trouble even when you have an sg_dd patched to
> stop passing thru negative lengths.
> 
> In place of the oops, this 2.6.0-test8 patch gives me:
> 
> $
> $ sg_dd of=/dev/sg0 bs=2k bpt=
> unrecognized multiplier
> sg_dd: SG_SET_RESERVED_SIZE error: Invalid argument
> Not enough user memory
> $
> 
> Pat LaVarre
> 
> diff -Nur linux-2.6.0-test8/drivers/scsi/sg.c linux/drivers/scsi/sg.c
> --- linux-2.6.0-test8/drivers/scsi/sg.c	2003-10-17 15:43:10.000000000 -0600
> +++ linux/drivers/scsi/sg.c	2003-10-20 16:15:17.699475136 -0600
> @@ -877,6 +877,8 @@
>  		result = get_user(val, (int *) arg);
>  		if (result)
>  			return result;
> +		if (val < 0)
> +			return -EINVAL;
>  		if (val != sfp->reserve.bufflen) {
>  			if (sg_res_in_use(sfp) || sfp->mmap_called)
>  				return -EBUSY;
> 

Pat,
Looks fine to me. I'll send a patch for lk 2.4 later.

Doug Gilbert


