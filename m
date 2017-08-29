From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 2/6] pm80xx: ILA and inactive firmware version through sysfs
Date: Tue, 29 Aug 2017 13:26:20 +0200
Message-ID: <CAD+HZHVOhXDb1r+Njr+ucZE7vs_ryCZsL-1mbXK33=L+mM5ucQ@mail.gmail.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com> <20150130060645.23653-3-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35116 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752859AbdH2L0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 07:26:22 -0400
Received: by mail-wr0-f194.google.com with SMTP id a47so2082949wra.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2017 04:26:22 -0700 (PDT)
In-Reply-To: <20150130060645.23653-3-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com

2015-01-30 7:06 GMT+01:00 Viswas G <Viswas.G@microsemi.com>:
> Added support to read ILA version and inactive firmware version
> from MPI configuration table and export through sysfs.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 55 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/pm8001/pm8001_sas.h |  2 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c |  5 ++++
>  drivers/scsi/pm8001/pm80xx_hwi.h |  2 ++
>  4 files changed, 64 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index be8269c8d127..d278c807112f 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -98,6 +98,59 @@ static ssize_t pm8001_ctl_fw_version_show(struct device *cdev,
>         }
>  }
>  static DEVICE_ATTR(fw_version, S_IRUGO, pm8001_ctl_fw_version_show, NULL);
> +
> +/**
> + * pm8001_ctl_ila_version_show - ila version
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +static ssize_t pm8001_ctl_ila_version_show(struct device *cdev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +
> +       if (pm8001_ha->chip_id != chip_8001) {
> +               return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
> +               (u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version >> 24),
> +               (u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version >> 16),
> +               (u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version >> 8),
> +               (u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version));
> +       }
> +       return 0;
> +}
> +static DEVICE_ATTR(ila_version, 0444, pm8001_ctl_ila_version_show, NULL);
> +
> +/**
> + * pm8001_ctl_inactive_fw_version_show - Inacative firmware version number
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +static ssize_t pm8001_ctl_inactive_fw_version_show(struct device *cdev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +
> +       if (pm8001_ha->chip_id != chip_8001) {
> +               return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
> +               (u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version >> 24),
> +               (u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version >> 16),
> +               (u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version >> 8),
> +               (u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version));
> +       }
> +       return 0;
> +}
> +static
> +DEVICE_ATTR(inc_fw_ver, 0444, pm8001_ctl_inactive_fw_version_show, NULL);
> +
> +
>  /**
>   * pm8001_ctl_max_out_io_show - max outstanding io supported
>   * @cdev: pointer to embedded class device
> @@ -748,6 +801,8 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_bios_version,
>         &dev_attr_ib_log,
>         &dev_attr_ob_log,
> +       &dev_attr_ila_version,
> +       &dev_attr_inc_fw_ver,
>         NULL,
>  };
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 2e17505ed5b8..2eb3b670bf45 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -499,6 +499,8 @@ union main_cfg_table {
>         u32                     port_recovery_timer;
>         u32                     interrupt_reassertion_delay;
>         u32                     fatal_n_non_fatal_dump;         /* 0x28 */
> +       u32                     ila_version;
> +       u32                     inc_fw_version;
>         } pm80xx_tbl;
>  };
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index eb4fee61df72..8fb5ddf08cc4 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -312,6 +312,11 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
>         /* read port recover and reset timeout */
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer =
>                 pm8001_mr32(address, MAIN_PORT_RECOVERY_TIMER);
> +       /* read ILA and inactive firmware version */
> +       pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version =
> +               pm8001_mr32(address, MAIN_MPI_ILA_RELEASE_TYPE);
> +       pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version =
> +               pm8001_mr32(address, MAIN_MPI_INACTIVE_FW_VERSION);
>  }
>
>  /**
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index 1ee2ec210065..d8e5d81e83f1 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -1349,6 +1349,8 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
>  #define MAIN_SAS_PHY_ATTR_TABLE_OFFSET 0x90 /* DWORD 0x24 */
>  #define MAIN_PORT_RECOVERY_TIMER       0x94 /* DWORD 0x25 */
>  #define MAIN_INT_REASSERTION_DELAY     0x98 /* DWORD 0x26 */
> +#define MAIN_MPI_ILA_RELEASE_TYPE      0xA4 /* DWORD 0x29 */
> +#define MAIN_MPI_INACTIVE_FW_VERSION   0XB0 /* DWORD 0x2C */
>
>  /* Gereral Status Table offset - byte offset */
>  #define GST_GSTLEN_MPIS_OFFSET         0x00
> --
> 2.12.3
>
Thanks, looks good to me.
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
