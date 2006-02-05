From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi core: fix uninitialized variable error
Date: Sun, 5 Feb 2006 08:01:33 -0700
Message-ID: <20060205150133.GC16090@parisc-linux.org>
References: <Pine.LNX.4.44L0.0602021637430.4715-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:24456 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750887AbWBEPBe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Feb 2006 10:01:34 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0602021637430.4715-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Feb 02, 2006 at 04:44:20PM -0500, Alan Stern wrote:
> This patch (as649) fixes an uninitialized variable error (sdev) in 
> __scsi_add_device.  I don't understand why the compiler didn't flag the 
> error.

> @@ -1265,7 +1261,6 @@ struct scsi_device *__scsi_add_device(st
>  {
>  	struct scsi_device *sdev;
>  	struct device *parent = &shost->shost_gendev;
> -	int res;
>  	struct scsi_target *starget;
>  
>  	starget = scsi_alloc_target(parent, channel, id);
> @@ -1274,12 +1269,10 @@ struct scsi_device *__scsi_add_device(st
>  
>  	get_device(&starget->dev);
>  	mutex_lock(&shost->scan_mutex);
> -	if (scsi_host_scan_allowed(shost)) {
> -		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
> -					     hostdata);
> -		if (res != SCSI_SCAN_LUN_PRESENT)
> -			sdev = ERR_PTR(-ENODEV);
> -	}
> +	if (!scsi_host_scan_allowed(shost) ||
> +			scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
> +				hostdata) != SCSI_SCAN_LUN_PRESENT)
> +		sdev = ERR_PTR(-ENODEV);
>  	mutex_unlock(&shost->scan_mutex);
>  	scsi_target_reap(starget);
>  	put_device(&starget->dev);

Seems to me it'd be much easier just  to initialise sdev to
ERR_PTR(-ENODEV) at the top of the function.  That way, __scsi_add_device
doesn't need to know what the return codes from scsi_probe_and_add_lun
mean.  Something like this (untested):

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 752fb5d..4c7bd89 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1267,9 +1267,8 @@ static int scsi_report_lun_scan(struct s
 struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 				      uint id, uint lun, void *hostdata)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = ERR_PTR(-ENODEV);
 	struct device *parent = &shost->shost_gendev;
-	int res;
 	struct scsi_target *starget;
 
 	starget = scsi_alloc_target(parent, channel, id);
@@ -1278,12 +1277,8 @@ struct scsi_device *__scsi_add_device(st
 
 	get_device(&starget->dev);
 	mutex_lock(&shost->scan_mutex);
-	if (scsi_host_scan_allowed(shost)) {
-		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
-					     hostdata);
-		if (res != SCSI_SCAN_LUN_PRESENT)
-			sdev = ERR_PTR(-ENODEV);
-	}
+	if (scsi_host_scan_allowed(shost))
+		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
