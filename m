From: Nikanth Karthikesan <nikanth@gmail.com>
Subject: Re: [PATCH] [SCSI] scsi_dh_alua: Attach to UNAVAILABLE/OFFLINE AAS devices
Date: Wed, 27 Apr 2011 12:12:51 +0530
Message-ID: <201104271212.51890.nikanth@kernel.org>
References: <201104261827.06024.marting@netapp.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36735 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1D0Gm4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2011 02:42:56 -0400
Received: by pzk9 with SMTP id 9so859420pzk.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2011 23:42:56 -0700 (PDT)
In-Reply-To: <201104261827.06024.marting@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin George <marting@netapp.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On Tuesday, April 26, 2011 06:27:05 PM Martin George wrote:
> The SCSI ALUA handler currently fails to attach to devices
> reporting an UNAVAILABLE/OFFLINE AAS. But given that an
> UNAVAILABLE/OFFLINE AAS can transition to other states
> like ACTIVE/OPTIMIZED, ACTIVE/NON-OPTIMIZED, etc. as per
> SPC4, this ALUA handler behavior should be rectified so
> as to attach to devices which also report an
> UNAVAILABLE/OFFLINE AAS.
> 
> The below patch enables the same.
> 
> Signed-off-by: Martin George <marting@netapp.com>

Reviewed-by: Nikanth Karthikesan <nikanth@kernel.org>

Thanks
Nikanth

> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c index 42fe529..6fec9fe 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -782,7 +782,7 @@ static int alua_bus_attach(struct scsi_device *sdev)
>  	h->sdev = sdev;
> 
>  	err = alua_initialize(sdev, h);
> -	if (err != SCSI_DH_OK)
> +	if ((err != SCSI_DH_OK) && (err != SCSI_DH_DEV_OFFLINED))
>  		goto failed;
> 
>  	if (!try_module_get(THIS_MODULE))
