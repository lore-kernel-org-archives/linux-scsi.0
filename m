From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 1/2  scsi-rc-fixes-2.6] Midlayer rework to allow remote port between shost and starget
Date: Wed, 9 Feb 2005 01:33:05 -0800
Message-ID: <20050209093305.GC5599@plap.qlogic.org>
References: <0B1E13B586976742A7599D71A6AC733C12EB46@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:13682 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261803AbVBIJcn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 04:32:43 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EB46@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

>   This patch modifies the midlayer for the addition of transport
>   objects to be layered between the scsi_host and the scsi_target.
>   FC will be the first consumer - placing the remote port between
>   the host and the target.
> 

These seems to be some reference-counting problems during starget
creating while scanning:

> diff -puN a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> --- a/drivers/scsi/scsi_sysfs.c	2005-02-08 21:05:49.000000000 -0500
> +++ b/drivers/scsi/scsi_sysfs.c	2005-02-08 21:05:49.000000000 -0500
> @@ -170,12 +170,8 @@ void scsi_device_dev_release(struct devi
>  
>  	if (delete) {
>  		struct scsi_target *starget = to_scsi_target(parent);
> -		if (!starget->create) {
> -			transport_remove_device(&starget->dev);
> -			device_del(parent);
> -		}
> -		transport_destroy_device(&starget->dev);
> -
> +		if (starget->scan_created)
> +			__scsi_remove_target(starget);
>  		put_device(parent);
>  	}
>  	if (sdev->request_queue)

resulting in some slab corruption:

	Slab corruption: start=d39c1ab4, len=256
	Redzone: 0x5a2cf071/0x5a2cf071.
	Last user: [<c02971de>](scsi_target_dev_release+0xe/0x20)
	040: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
	Prev obj: start=d39c19a8, lfen=256
	Redzoner: [<00000000>](0x0)
	000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
	010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
	Next obj: start=d39c1bc0, len=256
	Redzone: 0x170fc2a5/0x170fc2a5.
	Last user: [<c025f385>](cfq_init_queue+0x85/0x1b0)
	000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

small patch below should fix the problem.

--
AV


--- scsi-rport/drivers/scsi/scsi_sysfs.c.orig	2005-02-09 00:29:20.000000000 -0800
+++ scsi-rport/drivers/scsi/scsi_sysfs.c	2005-02-09 00:36:55.000000000 -0800
@@ -172,7 +172,6 @@
 		struct scsi_target *starget = to_scsi_target(parent);
 		if (starget->scan_created)
 			__scsi_remove_target(starget);
-		put_device(parent);
 	}
 	if (sdev->request_queue)
 		scsi_free_queue(sdev->request_queue);

