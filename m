From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 6/8] pm80xx: do not examine registers for iButton feature
 if ATTO adapter
Date: Mon, 2 Nov 2015 09:08:38 +0100
Message-ID: <CAD+HZHXYXw15hDgSKAvub-xOaGDY4-auyZcxpNijfaNXBRoLDA@mail.gmail.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
	<1446216811-2248-7-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34097 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbKBIIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 03:08:40 -0500
Received: by lfgh9 with SMTP id h9so11395360lfg.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 00:08:38 -0800 (PST)
In-Reply-To: <1446216811-2248-7-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <brood@attotech.com>

2015-10-30 15:53 GMT+01:00 Benjamin Rood <benjaminjrood@gmail.com>:
> ATTO adapters do not support this feature.  If the firmware fails to be
> ready, it should not check the examined registers in order to examine
> the state of the feature in order to prevent undefined behavior.
>
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 29c548b..eb4fee6 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1267,6 +1267,8 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
>                 /* check iButton feature support for motherboard controller */
>                 if (pm8001_ha->pdev->subsystem_vendor !=
>                         PCI_VENDOR_ID_ADAPTEC2 &&
> +                       pm8001_ha->pdev->subsystem_vendor !=
> +                       PCI_VENDOR_ID_ATTO &&
>                         pm8001_ha->pdev->subsystem_vendor != 0) {
>                         ibutton0 = pm8001_cr32(pm8001_ha, 0,
>                                         MSGU_HOST_SCRATCH_PAD_6);
> --
> 2.4.3
>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks
Jack
