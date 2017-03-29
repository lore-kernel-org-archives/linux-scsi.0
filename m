From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH 6/6] scsi: pm8001: remove the SAS host after the SCSI host
Date: Wed, 29 Mar 2017 12:27:14 +0200
Message-ID: <CAMGffEmv-fkF1NOvOsc=YooJWeGW4BjJa00gXUoOYCi6rhYsFg@mail.gmail.com>
References: <cover.1490775958.git.jthumshirn@suse.de> <20170329094122.9997-4-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:35416 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755116AbdC2K1g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 06:27:36 -0400
Received: by mail-qt0-f174.google.com with SMTP id x35so8432444qtc.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2017 03:27:35 -0700 (PDT)
In-Reply-To: <20170329094122.9997-4-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

On Wed, Mar 29, 2017 at 11:41 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> After commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive") changed the
> removal path of kernfs to make it recursive we have to remove the SAS host
> before the SCSI host or we will see sysfs warnings on not found sysfs groups for
> kobjects.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 417368c..9116e9c 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1086,11 +1086,21 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
>  {
>         struct sas_ha_struct *sha = pci_get_drvdata(pdev);
>         struct pm8001_hba_info *pm8001_ha;
> +       unsigned long flags;
> +       struct Scsi_Host *shost;
>         int i, j;
>         pm8001_ha = sha->lldd_ha;
> -       scsi_remove_host(pm8001_ha->shost);
> +       shost = pm8001_ha->shost;
> +
> +       spin_lock_irqsave(shost->host_lock, flags);
> +       if (scsi_host_set_state(shost, SHOST_CANCEL))
> +               WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
> +       spin_unlock_irqrestore(shost->host_lock, flags);
> +
>         sas_unregister_ha(sha);
> -       sas_remove_host(pm8001_ha->shost);
> +       sas_remove_host(shost);
> +       scsi_remove_host(shost);
> +
>         list_del(&pm8001_ha->list);
>         PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
>         PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
> --
> 1.8.5.6
>
Thanks Johannes for taking care of this. Looks good to me,

I have a question regarding the scsi_host_set_state change, why do we need that?
Can't we simply change the order of sas_remove_host and scsi_remove_host?

Cheers?
-- 
Jack Wang
