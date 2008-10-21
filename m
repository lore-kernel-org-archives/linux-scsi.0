From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-sbp2: extend failure check after SCSI probe
Date: Tue, 21 Oct 2008 23:46:13 +0200
Message-ID: <48FE4DA5.3050706@s5r6.in-berlin.de>
References: <tkrat.35d7de3b2ee2ecfc@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57360 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYJUVqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2008 17:46:10 -0400
In-Reply-To: <tkrat.35d7de3b2ee2ecfc@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

I wrote on 2008-10-15:
> https://bugzilla.redhat.com/show_bug.cgi?id=466679 indicates that the
> SCSI stack's probe may fail (with the sdev offlined) even if no 1394 bus
> generation update happened.  It's cheap to check for offline status,
> hence add this check to initiate a logout/ login/ SCSI probe retry.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/fw-sbp2.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/firewire/fw-sbp2.c
> ===================================================================
> --- linux.orig/drivers/firewire/fw-sbp2.c
> +++ linux/drivers/firewire/fw-sbp2.c
> @@ -930,7 +930,8 @@ static void sbp2_login(struct work_struc
>  
>  	/* Unreported error during __scsi_add_device() */
>  	smp_rmb(); /* get current card generation */
> -	if (generation != device->card->generation) {
> +	if (generation != device->card->generation ||
> +	    !scsi_device_online(sdev)) {
>  		scsi_remove_device(sdev);
>  		scsi_device_put(sdev);
>  		goto out_logout_login;

Wrong.  I was mislead by missing info in the bug report.  The generation 
check /is/ most certainly sufficient after all.

And adding the scsi_device_online check does not fix 
https://bugzilla.redhat.com/show_bug.cgi?id=466679 at all.  To fix that 
bug, we have to tweak fw-sbp2 so that the SCSI probe succeeds in the 
very first attempt in the specific scenario which is relevant to the 
reporter.  (The scenario is basically:  The firewire-sbp2 module was 
initialized before the firewire-ohci module.)
-- 
Stefan Richter
-=====-==--- =-=- =-=-=
http://arcgraph.de/sr/
