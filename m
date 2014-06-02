From: Alain Kalker <a.c.kalker@gmail.com>
Subject: Re: [PATCH V2] sd: Reduce log level to KERN_NOTICE for missing caching
 mode page
Date: Mon, 02 Jun 2014 21:08:17 +0200
Message-ID: <538CCBA1.7060808@gmail.com>
References: <1401734883-9540-1-git-send-email-a.c.kalker@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55312 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaFBTIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 15:08:21 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so5503318wgh.26
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 12:08:20 -0700 (PDT)
In-Reply-To: <1401734883-9540-1-git-send-email-a.c.kalker@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 06/02/2014 08:48 PM, Alain Kalker wrote:
> Reduce the lernel log level to KERN_NOTICE for messages related
> to a missing caching mode page.

There is an open bug report at kernel.org (dating all the way back to=20
Linux 2.6.34.1) about this:
Bug 16490 =96 "Assuming drive cache: write through" messages probably h=
ave=20
wrong loglevel : https://bugzilla.kernel.org/show_bug.cgi?id=3D16490

Also, many people are asking questions about this on internet fora,=20
submitting bug reports to bugtrackers for their distributions,=20
apparently the error log level makes them think their system is=20
malfunctioning in some way.

> Reasons why I think this change is justified:
> - The condition is not an error; the existing workaround of assuming
>    a write through cache doesn't limit functionality in any way.
> - It doesn't warrant a warning either: as it is most likely
>    a hardware limitation, there is little that an ordinary user can d=
o
>    about it besides replacing the affected hardware.
>    Making it a warning would still break quiet boot (kernel commandli=
ne
>    parameter 'quiet'), and may still trip log monitoring software
>    unneccessarily, either on every boot or whenever an affected
>    external device is plugged in.
> - It should be a notice, for it is a normal but significant condition=
,
>    as it may impact write performance. This would bring it on par wit=
h
>    the log messages in the same function.
>
> Signed-off-by: Alain Kalker <a.c.kalker@gmail.com>
> ---
>   drivers/scsi/sd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index efcbcd1..5f0f6c6 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2442,7 +2442,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsi=
gned char *buffer)
>   			}
>   		}
>
> -		sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
> +		sd_first_printk(KERN_NOTICE, sdkp, "No Caching mode page found\n")=
;
>   		goto defaults;
>
>   	Page_found:
> @@ -2489,7 +2489,7 @@ defaults:
>   				"Assuming drive cache: write back\n");
>   		sdkp->WCE =3D 1;
>   	} else {
> -		sd_first_printk(KERN_ERR, sdkp,
> +		sd_first_printk(KERN_NOTICE, sdkp,
>   				"Assuming drive cache: write through\n");
>   		sdkp->WCE =3D 0;
>   	}
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
