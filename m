From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 2/2] cciss: add reboot notifier support to driver
Date: Wed, 21 Feb 2007 19:17:59 -0800
Message-ID: <20070221191759.190e1a18.akpm@linux-foundation.org>
References: <20070221211251.GB2672@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35467 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbXBVDVT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Feb 2007 22:21:19 -0500
In-Reply-To: <20070221211251.GB2672@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Wed, 21 Feb 2007 15:12:51 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> @@ -3293,6 +3327,12 @@ #endif
>  	       ((hba[i]->nr_cmds + BITS_PER_LONG -
>  		 1) / BITS_PER_LONG) * sizeof(unsigned long));
>  
> +	if (notify_count == 0) {
> +		register_reboot_notifier(&cciss_notifier);
> +		notify_count=1;
> +	}
> +
> +
>  #ifdef CCISS_DEBUG
>  	printk(KERN_DEBUG "Scanning for drives on controller cciss%d\n", i);
>  #endif				/* CCISS_DEBUG */
> @@ -3500,6 +3540,7 @@ static void __exit cciss_cleanup(void)
>  	int i;
>  
>  	pci_unregister_driver(&cciss_pci_driver);
> +	unregister_reboot_notifier(&cciss_notifier);

Should we check that it was registered before going and unregistering
it?  ie: do `modprobe cciss' on a machine which has no cciss hardware,
then do rmmod...
