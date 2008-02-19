From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Tue, 19 Feb 2008 17:02:23 +0900
Message-ID: <20080219170100D.tomof@acm.org>
References: <20080218073134A.tomof@acm.org>
	<20080217233701.GA30994@tpepper-t42p.dolavim.us>
	<20080218223246I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:45606 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYBSICs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 03:02:48 -0500
In-Reply-To: <20080218223246I.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: lnxninja@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

ips did scsi_add_host(sh, NULL) so scsi_dma_map uses
shost_gendev.parent that isn't initialized properly, then the kernel
crashes. 2.6.23 and 2.6.24 have this bug.

We can fix this by calling scsi_add_host with pdev->dev, in the
standard way (like the following way) but this bug was fixed in the
current Linus tree by:

commit 2551a13e61d3c3df6c2da6de5a3ece78e6d67111
Author: Jeff Garzik <jeff@garzik.org>
Date:   Thu Dec 13 16:14:10 2007 -0800

[SCSI] ips: handle scsi_add_host() failure, and other err cleanups


James, the legitimate way to fix stable trees is sending this commit
(not sending a patch that was not committed upstream)?


On Mon, 18 Feb 2008 22:32:46 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> On Sun, 17 Feb 2008 15:37:02 -0800
> Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:
> 
> > On Mon 19 Feb at 07:31:56 +0900 tomof@acm.org said:
> > > 
> > > Can you apply the 0001 and 0002 against 2.6.24 and see how it works?
> > > If it works well, then please apply the 0001, 0002 and 0003.
> > 
> > Fujita-san,
> > 
> > I've started through the patches in order, cumulatively and after applying
> > 0005 things break.  I wont be able to test anything else until tomorrow
> > when I can phycisally reset the machine...
> 
> Great, thanks a lot!
> 
> Can you apply this patch after the 0005 patch and see how it works? If
> it works, then please continue to test 0006, 0007 ...
> 
> 
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 05bb6ea..39cdd68 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -6906,7 +6906,7 @@ ips_register_scsi(int index)
>  	sh->max_channel = ha->nbus - 1;
>  	sh->can_queue = ha->max_cmds - 1;
>  
> -	scsi_add_host(sh, NULL);
> +	scsi_add_host(sh, &ha->pcidev->dev);
>  	scsi_scan_host(sh);
>  
>  	return 0;
> -- 
> 1.5.3.7
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
