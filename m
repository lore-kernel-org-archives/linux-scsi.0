From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH (trivial) 2/2] SCSI: simplify scsi_remove_target()
Date: Wed, 22 Dec 2010 12:21:51 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1012221220560.16569@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1011151603300.1370-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48626 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab0LVLVx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Dec 2010 06:21:53 -0500
In-Reply-To: <Pine.LNX.4.44L0.1011151603300.1370-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <jbottomley@novell.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 15 Nov 2010, Alan Stern wrote:

> This trivial patch (as1340) eliminates an unnecessary local variable
> from scsi_remove_target().
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/drivers/scsi/scsi_sysfs.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
> +++ usb-2.6/drivers/scsi/scsi_sysfs.c
> @@ -1020,16 +1020,14 @@ static int __remove_child (struct device
>   */
>  void scsi_remove_target(struct device *dev)
>  {
> -	struct device *rdev;
> -
>  	if (scsi_is_target_device(dev)) {
>  		__scsi_remove_target(to_scsi_target(dev));
>  		return;
>  	}
>  
> -	rdev = get_device(dev);
> +	get_device(dev);
>  	device_for_each_child(dev, NULL, __remove_child);
> -	put_device(rdev);
> +	put_device(dev);
>  }
>  EXPORT_SYMBOL(scsi_remove_target);

The code seems to be reshuffled a little bit in -next, so this'd better go 
through SCSI tree to avoid unnecessary conflicts between trees in next.

James, are you going to pick it up?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
