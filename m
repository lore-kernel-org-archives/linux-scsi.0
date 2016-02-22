From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH 0/2][RESEND] scsi_transport_fc: LUN masking
Date: Mon, 22 Feb 2016 11:39:28 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB44535951@G4W3219.americas.hpqcorp.net>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:53106 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbcBVLjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 06:39:42 -0500
In-Reply-To: <1456127462-2817-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Hannes,

How do you know that a request for an async scan is complete (I'm assuming that you get add or change udev events)? Assuming that someone has manually started a scan on something (e.g. some newly presented devices after boot) and all scans are going to be async how do you when it is complete rather than waiting in a work queue? An example may be a sysfs file that contains unscanned, pending, scanning, scanned so you know when it's complete at the appropriate level in sysfs (the hba and the rports) so you know when can continue if you're polling the status (e.g. checking as part of system admin work with newly presented rports so you can then do something with them).

Thanks
Shane

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Monday, February 22, 2016 6:51 PM
> To: Martin K . Petersen
> Cc: Christoph Hellwig; James Bottomley; Johannes Thumshirn; linux-
> scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 0/2][RESEND] scsi_transport_fc: LUN masking
> 
> Hi all,
> 
> having been subjected to the pain of trying to bootstrap a really large
> machine with systemd I decided to implement LUN masking in
> scsi_transport_fc.
> The principle is simple: disallow the automated LUN scanning when
> discovering a rport, and create udev rules which selectively enable individual
> LUNs by echoing the relevant values in the 'scan'
> attribute of the SCSI host.
> With that I'm able to boot an arbitrary large machine without running into any
> udev or systemd imposed timeout.
> To _disable_ LUN masking and restoring the original behaviour I've noticed
> that the 'scan' sysfs attribute is actually synchronous, ie the calling process
> will be blocked until the entire LUN scan is completed.
> So I've added another module parameter 'async_user_scan' to move the
> scanning onto the existing scan workqueue, and unblock the calling process.
> 
> As usual, comments and reviews are welcome.
> 
> Hannes Reinecke (2):
>   scsi_transport_fc: implement 'disable_target_scan' module parameter
>   scsi_transport_fc: Implement 'async_user_scan' module parameter
> 
>  drivers/scsi/scsi_transport_fc.c | 47
> +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 3 deletions(-)
> 
> --
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
