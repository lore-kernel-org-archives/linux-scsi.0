From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: scsi: pm8001: fix double free in pm8001_pci_probe
Date: Tue, 8 Aug 2017 15:10:01 +0200
Message-ID: <CAMGffE=FRaU_NY2AH78st2=YtJxLbEsFER=hOmdkQD3=LSJFJw@mail.gmail.com>
References: <1502192430-12440-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:35259 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdHHNKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 09:10:23 -0400
Received: by mail-qt0-f176.google.com with SMTP id p3so19237543qtg.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2017 06:10:22 -0700 (PDT)
In-Reply-To: <1502192430-12440-1-git-send-email-bianpan2016@163.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Cc: lindar_liu <lindar_liu@usish.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Aug 8, 2017 at 1:40 PM, Pan Bian <bianpan2016@163.com> wrote:
> In function pm8001_pci_probe(), on errors that the control flow jumps to
> label err_out_ha_free, function pm8001_free() is called. In pm8001_free()=
,
> scsi_host_put() is called to release shost, which keeps the return value
> of scsi_host_alloc(). After pm8001_free() returns, kfree() is called to
> free shost again, resulting in a double free bug. This patch removes
> scsi_host_put() from pm8001_free() and explicitly calls scsi_host_put()
> to release Scsi_Host in need.
>
> Signed-off-by: Pan Bian <bianpan2016@163.com>
Thanks Pan!

Looks good to me!

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

> ---
>  drivers/scsi/pm8001/pm8001_init.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 034b2f7..2908881 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -160,8 +160,6 @@ static void pm8001_free(struct pm8001_hba_info *pm800=
1_ha)
>                         }
>         }
>         PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
> -       if (pm8001_ha->shost)
> -               scsi_host_put(pm8001_ha->shost);
>         flush_workqueue(pm8001_wq);
>         kfree(pm8001_ha->tags);
>         kfree(pm8001_ha);
> @@ -1073,7 +1071,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>  err_out_free:
>         kfree(SHOST_TO_SAS_HA(shost));
>  err_out_free_host:
> -       kfree(shost);
> +       scsi_host_put(shost);
>  err_out_regions:
>         pci_release_regions(pdev);
>  err_out_disable:
> @@ -1112,6 +1110,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
>                 for (j =3D 0; j < PM8001_MAX_MSIX_VEC; j++)
>                         tasklet_kill(&pm8001_ha->tasklet[j]);
>  #endif
> +       scsi_host_put(pm8001_ha->shost);
>         pm8001_free(pm8001_ha);
>         kfree(sha->sas_phy);
>         kfree(sha->sas_port);
> --
> 1.9.1
>
>



--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
