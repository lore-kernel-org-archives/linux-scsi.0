From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH2.5] ips 2/4: 2.4 resync
Date: Fri, 15 Aug 2003 16:56:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F3D48F3.8090405@pobox.com>
References: <1060951401.3259.44.camel@blackmagic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:64646 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270867AbTHOU4m
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2003 16:56:42 -0400
In-Reply-To: <1060951401.3259.44.camel@blackmagic>
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <david_jeffery@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

David Jeffery wrote:
> This patch is a resync with the 6.10 driver for 2.4 and updates the 2.4
> compatability code.  It adds a new wrapper function for differences
> between the 2.4 and 2.6 scsi proc interface,  forces pci posting in 3
> places, corrects using a meaningless constant of 0x80 to 0, and syncs
> comments that had changed. 

> @@ -257,9 +259,12 @@
>  	.queuecommand = ips_queue,
>  	.eh_abort_handler = ips_eh_abort,
>  	.eh_host_reset_handler = ips_eh_reset,
> +	.proc_name = "ips",
>  #if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
> +	.proc_info = ips_proc_info,
>  	.slave_configure = ips_slave_configure,
>  #else
> +	.proc_info = ips_proc24_info,
>  	.select_queue_depths = ips_select_queue_depth,
>  #endif

I wonder if you would object to removing the proc_info hook and code 
completely?  No big deal if the answer is "no", but overall, I would 
prefer to continue the current process of trimming down procfs.

If you want to export some information that's not exported currently, 
you can use sysfs attributes for that.



> @@ -4867,6 +4887,7 @@
>  	METHOD_TRACE("ips_enable_int_copperhead", 1);
>  
>  	outb(ha->io_addr + IPS_REG_HISR, IPS_BIT_EI);
> +	inb(ha->io_addr + IPS_REG_HISR);	/*Ensure PCI Posting Completes*/
>  }
>  
>  /****************************************************************************/
> @@ -4883,6 +4904,7 @@
>  	METHOD_TRACE("ips_enable_int_copperhead_memio", 1);
>  
>  	writeb(IPS_BIT_EI, ha->mem_ptr + IPS_REG_HISR);
> +	readb(ha->mem_ptr + IPS_REG_HISR);	/*Ensure PCI Posting Completes*/
>  }
>  
>  /****************************************************************************/
> @@ -4903,6 +4925,7 @@
>  	Oimr = readl(ha->mem_ptr + IPS_REG_I960_OIMR);
>  	Oimr &= ~0x08;
>  	writel(Oimr, ha->mem_ptr + IPS_REG_I960_OIMR);
> +	readl(ha->mem_ptr + IPS_REG_I960_OIMR);	/*Ensure PCI Posting Completes*/
>  }
>  
>  /****************************************************************************/

Nice :)

	Jeff



