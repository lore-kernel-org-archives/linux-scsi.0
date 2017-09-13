From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V2 5/9] pm80xx : cleanup in pm8001_abort_task function.
Date: Wed, 13 Sep 2017 15:12:29 +0200
Message-ID: <CAMGffEnrKYFJXSFEzi_za=9Zz5G8Xorqd_PEszz0a-SHFJK7Hg@mail.gmail.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com> <20150217233650.9091-6-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:45721 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdIMNMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 09:12:51 -0400
Received: by mail-wm0-f50.google.com with SMTP id g206so6503216wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2017 06:12:50 -0700 (PDT)
In-Reply-To: <20150217233650.9091-6-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Feb 18, 2015 at 12:36 AM, Viswas G <Viswas.G@microsemi.com> wrote:
> Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 49 +++++++++++-----------------------=
------
>  1 file changed, 13 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
> index ce584c31d36e..e80b0542a67f 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -1159,40 +1159,35 @@ int pm8001_query_task(struct sas_task *task)
>  int pm8001_abort_task(struct sas_task *task)
>  {
>         unsigned long flags;
> -       u32 tag =3D 0xdeadbeef;
> +       u32 tag;
>         u32 device_id;
>         struct domain_device *dev ;
> -       struct pm8001_hba_info *pm8001_ha =3D NULL;
> +       struct pm8001_hba_info *pm8001_ha;
>         struct pm8001_ccb_info *ccb;
>         struct scsi_lun lun;
>         struct pm8001_device *pm8001_dev;
>         struct pm8001_tmf_task tmf_task;
>         int rc =3D TMF_RESP_FUNC_FAILED;
>         if (unlikely(!task || !task->lldd_task || !task->dev))
> -               return rc;
> +               return TMF_RESP_FUNC_FAILED;
> +       dev =3D task->dev;
> +       pm8001_dev =3D dev->lldd_dev;
> +       pm8001_ha =3D pm8001_find_ha_by_dev(dev);
> +       device_id =3D pm8001_dev->device_id;
> +       rc =3D pm8001_find_tag(task, &tag);
> +       if (rc =3D=3D 0) {
> +               pm8001_printk("no tag for task:%p\n", task);
> +               return TMF_RESP_FUNC_FAILED;
> +       }
>         spin_lock_irqsave(&task->task_state_lock, flags);
>         if (task->task_state_flags & SAS_TASK_STATE_DONE) {
>                 spin_unlock_irqrestore(&task->task_state_lock, flags);
> -               rc =3D TMF_RESP_FUNC_COMPLETE;
> -               goto out;
> +               return TMF_RESP_FUNC_COMPLETE;
>         }
>         spin_unlock_irqrestore(&task->task_state_lock, flags);
>         if (task->task_proto & SAS_PROTOCOL_SSP) {
>                 struct scsi_cmnd *cmnd =3D task->uldd_task;
> -               dev =3D task->dev;
> -               ccb =3D task->lldd_task;
> -               pm8001_dev =3D dev->lldd_dev;
> -               pm8001_ha =3D pm8001_find_ha_by_dev(dev);
>                 int_to_scsilun(cmnd->device->lun, &lun);
> -               rc =3D pm8001_find_tag(task, &tag);
> -               if (rc =3D=3D 0) {
> -                       printk(KERN_INFO "No such tag in %s\n", __func__)=
;
> -                       rc =3D TMF_RESP_FUNC_FAILED;
> -                       return rc;
> -               }
> -               device_id =3D pm8001_dev->device_id;
> -               PM8001_EH_DBG(pm8001_ha,
> -                       pm8001_printk("abort io to deviceid=3D %d\n", dev=
ice_id));
>                 tmf_task.tmf =3D TMF_ABORT_TASK;
>                 tmf_task.tag_of_task_to_be_managed =3D tag;
>                 rc =3D pm8001_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task)=
;
> @@ -1200,28 +1195,10 @@ int pm8001_abort_task(struct sas_task *task)
>                         pm8001_dev->sas_device, 0, tag);
>         } else if (task->task_proto & SAS_PROTOCOL_SATA ||
>                 task->task_proto & SAS_PROTOCOL_STP) {
> -               dev =3D task->dev;
> -               pm8001_dev =3D dev->lldd_dev;
> -               pm8001_ha =3D pm8001_find_ha_by_dev(dev);
> -               rc =3D pm8001_find_tag(task, &tag);
> -               if (rc =3D=3D 0) {
> -                       printk(KERN_INFO "No such tag in %s\n", __func__)=
;
> -                       rc =3D TMF_RESP_FUNC_FAILED;
> -                       return rc;
> -               }
>                 rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_=
dev,
>                         pm8001_dev->sas_device, 0, tag);
>         } else if (task->task_proto & SAS_PROTOCOL_SMP) {
>                 /* SMP */
> -               dev =3D task->dev;
> -               pm8001_dev =3D dev->lldd_dev;
> -               pm8001_ha =3D pm8001_find_ha_by_dev(dev);
> -               rc =3D pm8001_find_tag(task, &tag);
> -               if (rc =3D=3D 0) {
> -                       printk(KERN_INFO "No such tag in %s\n", __func__)=
;
> -                       rc =3D TMF_RESP_FUNC_FAILED;
> -                       return rc;
> -               }
>                 rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_=
dev,
>                         pm8001_dev->sas_device, 0, tag);
>
> --
> 2.12.3
>

Thanks,
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>

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
