From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Mon, 18 Feb 2008 15:30:58 -0800
Message-ID: <20080218233057.GC12905@tpepper-t42p.dolavim.us>
References: <20080217233701.GA30994@tpepper-t42p.dolavim.us> <20080218223246I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41410 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbYBRXbD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 18:31:03 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1INV02b000383
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:31:00 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1INV0n8226672
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:31:00 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1INUxZk006590
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:31:00 -0500
Content-Disposition: inline
In-Reply-To: <20080218223246I.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: lnxninja@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Mon 18 Feb at 22:32:46 +0900 tomof@acm.org said:
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

Fujita-san,

This applies and runs well on top of your 0005 patch!  The rest of the
patches also then apply in order and run successfully.

Just to confirm, I applied the above alone to a clean 2.6.24 and things
again build and run successfully.  For completeness I also reproduced
the problem against 2.6.23.16 and verified the above patch fixes on that
kernel version as well.

Assuming this patch is accepted for 2.6.25, please also queue it for
the 2.6.23/24 stable trees.

Thank you very much for your help in tracking this issue down!

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
