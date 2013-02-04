From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] SG_SCSI_RESET ioctl should only perform requested operation
Date: Mon, 04 Feb 2013 17:28:48 -0500
Message-ID: <51103620.1050204@interlog.com>
References: <5110174A.4080808@tributary.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54144 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab3BDW2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Feb 2013 17:28:53 -0500
In-Reply-To: <5110174A.4080808@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Linux Scsi <linux-scsi@vger.kernel.org>

On 13-02-04 03:17 PM, Jeremy Linton wrote:
>>From all the documentation I've found, it is not clear that users of the
> SG_SCSI_RESET ioctl may have their requests progress up the hierarchy of reset
> operations.
>
> Basically, requests for a SCSI_TRY_RESET_DEVICE may eventually result in a
> TARGET, BUS, or HOST reset. The sg_reset utility hints at the error handling,
> but actually leads the user to believe that they should reissue the sg_reset
> command themselves to enact more aggressive reset functions. It also says:
> "Note that a host reset and a bus reset may cause collateral damage."
>
> In the interest of error isolation, I have attached a patch which changes the
> behavior. The existing behavior is obviously intentional, but I don't believe
> its the best choice.
>
> There are other alternatives to this patch. For one, to avoid the possibility of
> breaking an existing application, maybe SG_SCSI_RESET needs some new values like
> "SG_SCSI_RESET_DEVICE_ONLY". While leaving the existing operations alone.
>
>
>
> Just in case...
> Signed-off-by: Jeremy Linton <jlinton@tributary.com>
> ---
> 	
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c1b05a8..6f05bc2 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1999,19 +1999,13 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
>          switch (flag) {
>          case SCSI_TRY_RESET_DEVICE:
>                  rtn = scsi_try_bus_device_reset(scmd);
> -               if (rtn == SUCCESS)
> -                       break;
> -               /* FALLTHROUGH */
> +               break;
>          case SCSI_TRY_RESET_TARGET:
>                  rtn = scsi_try_target_reset(scmd);
> -               if (rtn == SUCCESS)
> -                       break;
> -               /* FALLTHROUGH */
> +               break;
>          case SCSI_TRY_RESET_BUS:
>                  rtn = scsi_try_bus_reset(scmd);
> -               if (rtn == SUCCESS)
> -                       break;
> -               /* FALLTHROUGH */
> +               break;
>          case SCSI_TRY_RESET_HOST:
>                  rtn = scsi_try_host_reset(scmd);
>                  break;
> --

Jeremy,
That is way too sensible to be approved as it will most likely
break existing code that assumes the escalation property.

Perhaps some new constants could be introduced (e.g.
SCSI_TRY_RESET_TARGET_ONLY) that could be passed to
the SG_SCSI_RESET ioctl. And perhaps that new set of
constants could more accurately reflect how such things
are done in modern SCSI.

Doug Gilbert


