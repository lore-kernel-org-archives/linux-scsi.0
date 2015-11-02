From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 2/8] pm80xx: add support for PMC Sierra 8070 and PMC
 Sierra 8072 SAS controllers
Date: Mon, 2 Nov 2015 09:01:43 +0100
Message-ID: <CAD+HZHW2YuwKjz0AuNREN5Nm0Yh0G3bNYd7eS=oSvpWOWV+fvg@mail.gmail.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
	<1446216811-2248-3-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36316 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbKBIBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 03:01:47 -0500
Received: by lbjm5 with SMTP id m5so82452725lbj.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 00:01:46 -0800 (PST)
In-Reply-To: <1446216811-2248-3-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <brood@attotech.com>

2015-10-30 15:53 GMT+01:00 Benjamin Rood <benjaminjrood@gmail.com>:
> These SAS controllers support speeds up to 12Gb.
>
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_defs.h | 2 ++
>  drivers/scsi/pm8001/pm8001_init.c | 4 +++-
>  drivers/scsi/pm8001/pm8001_sas.h  | 4 +++-
>  3 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
> index f14ec6e..199527d 100644
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -51,6 +51,8 @@ enum chip_flavors {
>         chip_8076,
>         chip_8077,
>         chip_8006,
> +       chip_8070,
> +       chip_8072
>  };
>
>  enum phy_speed {
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 8c094fd..2106ac3 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -58,6 +58,8 @@ static const struct pm8001_chip_info pm8001_chips[] = {
>         [chip_8076] = {0,  16, &pm8001_80xx_dispatch,},
>         [chip_8077] = {0,  16, &pm8001_80xx_dispatch,},
>         [chip_8006] = {0,  16, &pm8001_80xx_dispatch,},
> +       [chip_8070] = {0,  8, &pm8001_80xx_dispatch,},
> +       [chip_8072] = {0,  16, &pm8001_80xx_dispatch,},
>  };
>  static int pm8001_id;
>
> @@ -1234,7 +1236,7 @@ MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
>  MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
>  MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>");
>  MODULE_DESCRIPTION(
> -               "PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/8077 "
> +               "PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/8077/8070/8072 "
>                 "SAS/SATA controller driver");
>  MODULE_VERSION(DRV_VERSION);
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index e2e97db..9fa9705 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -106,7 +106,9 @@ do {                                                \
>  #define DEV_IS_EXPANDER(type)  ((type == SAS_EDGE_EXPANDER_DEVICE) || (type == SAS_FANOUT_EXPANDER_DEVICE))
>  #define IS_SPCV_12G(dev)       ((dev->device == 0X8074)                \
>                                 || (dev->device == 0X8076)              \
> -                               || (dev->device == 0X8077))
> +                               || (dev->device == 0X8077)              \
> +                               || (dev->device == 0X8070)              \
> +                               || (dev->device == 0X8072))
>
>  #define PM8001_NAME_LENGTH             32/* generic length of strings */
>  extern struct list_head hba_list;
> --
> 2.4.3
>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks
Jack
