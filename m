From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 5/8] scsi: megaraid_sas - using unsigned long for
 sense_buff ptr
Date: Fri, 28 Sep 2007 13:45:39 -0700
Message-ID: <20070928134539.56640570.randy.dunlap@oracle.com>
References: <1190821267.5955.20.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:38832 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXI1Uqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 16:46:45 -0400
In-Reply-To: <1190821267.5955.20.camel@dhcp-75-534.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

On Wed, 26 Sep 2007 11:41:07 -0400 bo yang wrote:

> MegaRAID utilities expect sense_buff to be of type unsigned long.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff -uprN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-09-27 04:41:39.000000000 -0700
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-09-27 04:50:14.000000000 -0700
> @@ -2969,6 +2969,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
>  	void *sense = NULL;
>  	dma_addr_t sense_handle;
>  	u32 *sense_ptr;
> +	unsigned long *sense_buff;
>  
>  	memset(kbuff_arr, 0, sizeof(kbuff_arr));
>  
> @@ -3073,14 +3074,16 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
>  	 */
>  	if (ioc->sense_len) {
>  		/*
> -		 * sense_ptr points to the location that has the user
> +		 * sense_buff points to the location that has the user
>  		 * sense buffer address
>  		 */
> -		sense_ptr = (u32 *) ((unsigned long)ioc->frame.raw +
> -				     ioc->sense_off);
> +		sense_buff = (unsigned long *) ((unsigned long)ioc->frame.raw +
> +								ioc->sense_off);
>  
> -		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
> -				 sense, ioc->sense_len)) {
> +		if (copy_to_user((void __user *)(unsigned long)(*sense_buff),
> +				sense, ioc->sense_len)) {
> +			printk(KERN_ERR "megasas: Failed to copy out to user"
> +					"sense data\n");

					" sense data\n");

>  			error = -EFAULT;
>  			goto out;
>  		}


---
~Randy
Phaedrus says that Quality is about caring.
