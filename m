From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] fix for missing proc dir in megaraid driver.
Date: Tue, 17 Feb 2004 23:15:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217231541.GG11824@parcelfarce.linux.theplanet.co.uk>
References: <1077058085.1897.4.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:51148 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266831AbUBQXPm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 18:15:42 -0500
Content-Disposition: inline
In-Reply-To: <1077058085.1897.4.camel@morsel.kungfoocoder.org>
List-Id: linux-scsi@vger.kernel.org
To: Paul Wagland <paul@wagland.net>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Tue, Feb 17, 2004 at 11:48:06PM +0100, Paul Wagland wrote:
> This applies against 2.6.2. and resolves the problem of the missing
> /proc/megaraid/* entries. The problem was that the megaraid directory
> was getting created after it was used. Sometime in the next few days I
> will also send through the work I have done to convert to sysfs.
> 
> Hope this helps,
> Paul
> patch follows:
> 
> 
> diff --recursive --unified linux-2.6.2/drivers/scsi/megaraid.c linux-2.6.2.megaraid/drivers/scsi/megaraid.c
> --- linux-2.6.2/drivers/scsi/megaraid.c	2004-02-09 22:56:09.000000000 +0100
> +++ linux-2.6.2.megaraid/drivers/scsi/megaraid.c	2004-02-17 23:38:41.000000000 +0100
> @@ -5118,17 +5118,20 @@
>  	if (max_mbox_busy_wait > MBOX_BUSY_WAIT)
>  		max_mbox_busy_wait = MBOX_BUSY_WAIT;
>  
> -	error = pci_module_init(&megaraid_pci_driver);
> -	if (error) 
> -		return error;
> -	
>  #ifdef CONFIG_PROC_FS
>  	mega_proc_dir_entry = proc_mkdir("megaraid", &proc_root);
>  	if (!mega_proc_dir_entry) {
>  		printk(KERN_WARNING
>  				"megaraid: failed to create megaraid root\n");
>  	}
>  #endif
> +	error = pci_module_init(&megaraid_pci_driver);
> +	if (error) {
> +#ifdef CONFIG_PROC_FS
> +		remove_proc_entry("megaraid", &proc_root);
> +#endif
> +		return error;
> +	}
>  
>  	/*
>  	 * Register the driver as a character device, for applications
> 

Actually, all the CONFIG_PROC_FS ifdefs can go away.  They're properly
stubbed in include/linux/proc_fs.h.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
