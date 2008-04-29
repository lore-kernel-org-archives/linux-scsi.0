From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Issue with qla2xxx_probe_one
Date: Tue, 29 Apr 2008 10:44:47 -0700
Message-ID: <20080429174447.GL67096@plap4.qlogic.org>
References: <48175C3F.3000002@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21749 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYD2Ros (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 13:44:48 -0400
Content-Disposition: inline
In-Reply-To: <48175C3F.3000002@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

On Tue, 29 Apr 2008, Alan D. Brunelle wrote:

> I /think/ that there is an issue with this routine /if/ the firmware
> images are not loaded properly - on a 16-way ia64 box I am starting to
> see this with an up-stream kernel (Jens Axboe's origin/io-cpu-affinity
> branch). In any event, it looks to me that :
> 
>         if (qla2x00_initialize_adapter(ha)) {
>                 qla_printk(KERN_WARNING, ha,
>                     "Failed to initialize adapter\n");
> 
>                 DEBUG2(printk("scsi(%ld): Failed to initialize adapter - "
>                     "Adapter flags %x.\n",
>                     ha->host_no, ha->device_flags));
> 
>                 ret = -ENODEV;
>                 goto probe_failed;
>         }
> 
> skips around:
> 
>         ret = scsi_add_host(host, &pdev->dev);
> 
> which is needed to properly initialize the freelist (via:
> scsi_setup_command_freelist).

Wasn't something like this posted recently to linux-scsi:

http://lkml.org/lkml/2008/4/27/333

this is sitting in scsi-misc-2.6.git:

[SCSI] bug fix for free list handling
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=a79cbe1aa5dd695f0ee012ecde1ff88b1192e326

which I gather will be pushed soon...

> When qla2xxx_probe_one ends up calling scsi_host_put in this error path
> it eventually gets to scsi_destroy_command_freelist and we get the error
> below.
