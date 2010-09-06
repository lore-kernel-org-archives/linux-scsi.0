From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] scsi_debug: Convert to use root_device_register() and
 root_device_unregister()
Date: Mon, 6 Sep 2010 16:41:19 -0700
Message-ID: <20100906234119.GA20589@core.coreip.homeip.net>
References: <1283812340-21132-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:61507 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0IFXlZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 19:41:25 -0400
Content-Disposition: inline
In-Reply-To: <1283812340-21132-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>

On Mon, Sep 06, 2010 at 03:32:20PM -0700, Nicholas A. Bellinger wrote:
>  static int __init scsi_debug_init(void)
>  {
>  	unsigned long sz;
>  	int host_to_add;
>  	int k;
> -	int ret;
> +	int ret = 0;
>  

Please do not initialize error condition with success; when adding
additional initialization it makes easy to miss assigning proper return
value (as you seem to have) and return success in case of failure.

>  	switch (scsi_debug_sector_size) {
>  	case  512:
> @@ -3352,10 +3343,9 @@ static int __init scsi_debug_init(void)
>  			map_region(0, 2);
>  	}
>  
> -	ret = device_register(&pseudo_primary);
> -	if (ret < 0) {
> -		printk(KERN_WARNING "scsi_debug: device_register error: %d\n",
> -			ret);
> +	pseudo_primary = root_device_register("pseudo_0");
> +	if (!(pseudo_primary)) {

root_device_register() returns ERR_PTR-encoded error codes, you should
do:

	if (IS_ERR(pseudo_primary)) {
		printk(KERN_WARNING "scsi_debug: root_device_register() error\n");
		ret = PTR_ERR(pseudo_primary);
		goto free_vm;
	}

Same goes for your other patch.

Thanks.

-- 
Dmitry
