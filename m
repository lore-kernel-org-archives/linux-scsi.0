From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [PATCH 2/2] qla1280: Drop host_lock while requesting firmware
Date: Mon, 24 Aug 2009 10:07:04 +0530
Message-ID: <aa5953d60908232137se50ae5ei287f694afdd4e853@mail.gmail.com>
References: <1251041902.16001.251.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:43196 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZHXEhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2009 00:37:03 -0400
Received: by wa-out-1112.google.com with SMTP id j5so373690wah.21
        for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2009 21:37:05 -0700 (PDT)
In-Reply-To: <1251041902.16001.251.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, David.Woodhouse@intel.com

Thanks, Ben.

Seems good to me.
--
JSR

On Sun, Aug 23, 2009 at 9:08 PM, Ben Hutchings<ben@decadent.org.uk> wro=
te:
> request_firmware() may sleep and it appears to be safe to release the
> spinlock here.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> Scott Bailey <scott.bailey@hp.com> tested this change to the two
> separate functions qla1280_load_firmware_{pio,dma}() in 2.6.30. =A0I'=
m not
> adding Tested-by since he didn't test this exact code.
>
> Ben.
>
> =A0drivers/scsi/qla1280.c | =A0 =A02 ++
> =A01 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 4951344..492492d 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -1803,8 +1803,10 @@ qla1280_load_firmware(struct scsi_qla_host *ha=
)
> =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
>
> + =A0 =A0 =A0 spin_unlock_irq(ha->host->host_lock);
> =A0 =A0 =A0 =A0err =3D request_firmware(&fw, ql1280_board_tbl[ha->dev=
num].fwname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ha->pdev=
->dev);
> + =A0 =A0 =A0 spin_lock_irq(ha->host->host_lock);
> =A0 =A0 =A0 =A0if (err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "Failed to load image =
\"%s\" err %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ql1280_board_tbl[ha->devn=
um].fwname, err);
> --
> 1.6.3.3
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
