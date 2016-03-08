From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: fix SRB_STATUS_ABORTED handling
Date: Tue, 8 Mar 2016 01:16:03 +0000
Message-ID: <BY2PR0301MB16542B711D3EDF1F6755C7FCA0B20@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1457348384-11869-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0119.outbound.protection.outlook.com ([157.56.111.119]:59616
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309AbcCHBQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 20:16:07 -0500
In-Reply-To: <1457348384-11869-1-git-send-email-vkuznets@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Haiyang Zhang <haiyangz@microsoft.com>, Cathy Avery <cavery@redhat.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen\"" <martin.petersen@oracle.com>



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Monday, March 7, 2016 3:00 AM
> To: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; KY
> Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Cathy Avery <cavery@redhat.com>; James E.J.
> Bottomley <JBottomley@odin.com>; Martin K. Petersen"
> <martin.petersen@oracle.com>
> Subject: [PATCH] scsi: storvsc: fix SRB_STATUS_ABORTED handling
> 
> Commit 3209f9d780d1 ("scsi: storvsc: Fix a bug in the handling of SRB
> status flags") filtered SRB_STATUS_AUTOSENSE_VALID out effectively
> making
> the (SRB_STATUS_ABORTED | SRB_STATUS_AUTOSENSE_VALID) case a dead
> code. The
> logic from this branch (e.g. storvsc_device_scan() call) is still required,
> fix the check.
> 
> Fixes: 3209f9d780d1 ("scsi: storvsc: Fix a bug in the handling of SRB status
> flags")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks Vitaly.

Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 292c04e..3ddcabb 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -914,8 +914,9 @@ static void storvsc_handle_error(struct
> vmscsi_request *vm_srb,
>  		do_work = true;
>  		process_err_fn = storvsc_remove_lun;
>  		break;
> -	case (SRB_STATUS_ABORTED | SRB_STATUS_AUTOSENSE_VALID):
> -		if ((asc == 0x2a) && (ascq == 0x9)) {
> +	case SRB_STATUS_ABORTED:
> +		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID
> &&
> +		    (asc == 0x2a) && (ascq == 0x9)) {
>  			do_work = true;
>  			process_err_fn = storvsc_device_scan;
>  			/*
> --
> 2.5.0

