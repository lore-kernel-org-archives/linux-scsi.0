Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EE1C2BB55
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 11:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E2121D7F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 11:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="VkVYYnh9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633976AbgDPLn0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 07:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506472AbgDPLm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2020 07:42:57 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519EBC061A0C
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 04:42:56 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id h6so20603761iok.11
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 04:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HhEnXMIzN+dq+vtNXrAaQG3NfMrvxjDrqAwJNrXBjaY=;
        b=VkVYYnh9FDLFnR6xpOSxzc98+UjtSOiZHsPVaXV6cKTEIlT+Pf9b7TqXVpOra9auFE
         ZsYV06ZcE6Z8oUg1gEeeXA3jV+TXO7S6JG5l8rImaSRBljrIt7jqza2F2XPYj0RxbF+O
         ZTpVsd/xHIyYu0x3GsEKxZ8v5CAwRIkmOSAuVgVuAVSVb42x4jzBg1w3+po6b24ZH94p
         FTLimvxdjRYGlp9jr9eHpz+/j6ztaSBlXKW5oCVX+FInYKkb1AEmdzAtWakqMUpXQF8E
         we2v5ZkxapogpvoKvmCMLPa77tf/ae8QmkEQhbq7T06E331w0QbOpV2tuPi5GOEVf2vI
         B2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HhEnXMIzN+dq+vtNXrAaQG3NfMrvxjDrqAwJNrXBjaY=;
        b=sLIsLMK54Y58qgu6h+BVTL8XIilsC2qNRYDBrgKPbkC1uJodUZGELuPmzIhjl1oLrK
         6oTvuN77Q+VE0CcmwbCgF8MBxOvGokpZOi2yehsUKYFeFQBHnd55/fVyRKYXpQHtaROz
         hNGcO5rX26xFNvBDzwjTOpQcP3egL6bZ9P5Q+75isRoOtqXfugSkd5kY9Gp8IgRM+Eyf
         jKUfNxtVwqzuXUPhOK/q/vSTOk/m0eXfqNKTzUjtzG9yefvzTmv3CGn3H3lJev5Jev/X
         u1fG1L/RUT2rm9UDqvMbqp3P/CKGSScc/0YAgLT0lPmD+Iaw1rIyGfJtcQS+UFSclQ2+
         TiKw==
X-Gm-Message-State: AGi0PuaTtqvxfWB2n0rTRjpHpNPf9Tx0/dKKmjiC6zo8uVDymHPriX9f
        +7VnFJ42irYaurVFNOC8XLt92Zdr5xBLaiXjofPuUA==
X-Google-Smtp-Source: APiQypKHCVJqjySXYFBGvw3l2oapS4xHX1RxieL9UAU27kjo2mnob34qvjaj5f8m/gCqqPA+KExsJ2N6x9z9wFXI9kw=
X-Received: by 2002:a6b:b955:: with SMTP id j82mr30813970iof.54.1587037375317;
 Thu, 16 Apr 2020 04:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200413094938.6182-1-deepak.ukey@microchip.com> <20200413094938.6182-3-deepak.ukey@microchip.com>
In-Reply-To: <20200413094938.6182-3-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 16 Apr 2020 13:42:44 +0200
Message-ID: <CAMGffE=oc4fqXdOqHwVRp-eysMsJ61-5JW0sR7dwMFaY8mt3FQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] pm80xx : Staggered spin up support.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jinpu Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 13, 2020 at 11:40 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> As a part of drive discovery, driver will initaite the drive spin up.
> If all drives do spin up together, it will result in large power
> consumption. To reduce the power consumption, driver provide an option
> to make a small group of drives (say 3 or 4 drives together) to do the
> spin up. The delay between two spin up group and no of drives to
> spin up (group) can be programmed by the customer in seeprom and
> driver will use it to control the spinup.
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Deepak Ukey <Deepak.Ukey@microchip.com>
> ---
>  drivers/scsi/pm8001/pm8001_defs.h |   3 +
>  drivers/scsi/pm8001/pm8001_hwi.c  |  14 ++++-
>  drivers/scsi/pm8001/pm8001_init.c |  53 +++++++++++++++-
>  drivers/scsi/pm8001/pm8001_sas.c  |  37 ++++++++++-
>  drivers/scsi/pm8001/pm8001_sas.h  |  14 +++++
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 125 +++++++++++++++++++++++++++++++++-----
>  6 files changed, 223 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
> index 1c7f15fd69ce..fd700ce5e80c 100644
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -101,6 +101,9 @@ enum port_type {
>  #define USI_MAX_MEMCNT         (PI + PM8001_MAX_SPCV_OUTB_NUM)
>  #define        CONFIG_SCSI_PM8001_MAX_DMA_SG   528
>  #define PM8001_MAX_DMA_SG      CONFIG_SCSI_PM8001_MAX_DMA_SG
> +#define SPINUP_DELAY_OFFSET            0x890 /* 0x890 - delay */
> +#define SPINUP_GROUP_OFFSET            0x892 /* 0x892 - group */
> +#define PM80XX_MAX_SPINUP_DELAY        10000 /* 10000 ms */
>  enum memory_region_num {
>         AAP1 = 0x0, /* application acceleration processor */
>         IOP,        /* IO processor */
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index fb9848e1d481..6378c8e8d6b2 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3237,7 +3237,7 @@ int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 (struct local_phy_ctl_resp *)(piomb + 4);
>         u32 status = le32_to_cpu(pPayload->status);
>         u32 phy_id = le32_to_cpu(pPayload->phyop_phyid) & ID_BITS;
> -       u32 phy_op = le32_to_cpu(pPayload->phyop_phyid) & OP_BITS;
> +       u32 phy_op = (le32_to_cpu(pPayload->phyop_phyid) & OP_BITS) >> 8;
>         tag = le32_to_cpu(pPayload->tag);
>         if (status != 0) {
>                 PM8001_MSG_DBG(pm8001_ha,
> @@ -3248,6 +3248,13 @@ int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         pm8001_printk("%x phy execute %x phy op success!\n",
>                         phy_id, phy_op));
>                 pm8001_ha->phy[phy_id].reset_success = true;
> +               if (phy_op == PHY_NOTIFY_ENABLE_SPINUP &&
> +                       !pm8001_ha->reset_in_progress){
> +                       /* Notify the sas layer to discover
> +                        * the the whole sas domain
> +                        */
> +                       pm8001_bytes_dmaed(pm8001_ha, phy_id);
> +               }
>         }
>         if (pm8001_ha->phy[phy_id].enable_completion) {
>                 complete(pm8001_ha->phy[phy_id].enable_completion);
> @@ -3643,7 +3650,10 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         pm8001_printk("DEVREG_FAILURE_DEVICE_TYPE_NOT_SUPPORTED\n"));
>                 break;
>         }
> -       complete(pm8001_dev->dcompletion);
> +       if (pm8001_dev->dcompletion) {
> +               complete(pm8001_dev->dcompletion);
> +               pm8001_dev->dcompletion = NULL;
> +       }
>         ccb->task = NULL;
>         ccb->ccb_tag = 0xFFFFFFFF;
>         pm8001_tag_free(pm8001_ha, htag);
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 68005d0cb33d..6cbb8fa74456 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -55,6 +55,12 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
>                 " 4: Link rate 6.0G\n"
>                 " 8: Link rate 12.0G\n");
>
> +bool staggered_spinup;
> +module_param(staggered_spinup, bool, 0644);
> +MODULE_PARM_DESC(staggered_spinup, "enable the staggered spinup feature.\n"
> +               " 0/N: false\n"
> +               " 1/Y: true\n");
> +
>  static struct scsi_transport_template *pm8001_stt;
>
>  /**
> @@ -164,7 +170,7 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
>
>         if (!pm8001_ha)
>                 return;
> -
> +       del_timer(&pm8001_ha->spinup_timer);
>         for (i = 0; i < USI_MAX_MEMCNT; i++) {
>                 if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
>                         dma_free_coherent(&pm8001_ha->pdev->dev,
> @@ -486,6 +492,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
>         pm8001_ha->shost = shost;
>         pm8001_ha->id = pm8001_id++;
>         pm8001_ha->logging_level = logging_level;
> +       pm8001_ha->staggered_spinup = staggered_spinup;
>         pm8001_ha->non_fatal_count = 0;
>         if (link_rate >= 1 && link_rate <= 15)
>                 pm8001_ha->link_rate = (link_rate << 8);
> @@ -620,7 +627,8 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
>   * Currently we just set the fixed SAS address to our HBA,for manufacture,
>   * it should read from the EEPROM
>   */
> -static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
> +static void pm8001_init_sas_add_and_spinup_config
> +               (struct pm8001_hba_info *pm8001_ha)
>  {
>         u8 i, j;
>         u8 sas_add[8];
> @@ -706,6 +714,45 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>         memcpy(pm8001_ha->sas_addr, &pm8001_ha->phy[0].dev_sas_addr,
>                 SAS_ADDR_SIZE);
>  #endif
> +
> +       /* For spinning up drives in group */
> +       pm8001_ha->phy_head = -1;
> +       pm8001_ha->phy_tail = -1;
> +
> +       for (i = 0; i < PM8001_MAX_PHYS; i++)
> +               pm8001_ha->phy_up[i] = 0xff;
> +
> +       timer_setup(&pm8001_ha->spinup_timer,
> +               (void *)pm8001_spinup_timedout, 0);
> +
> +       if (pm8001_ha->staggered_spinup == true) {
> +               /* spinup interval in unit of 100 ms */
> +               pm8001_ha->spinup_interval =
> +                       payload.func_specific[SPINUP_DELAY_OFFSET] * 100;
> +               pm8001_ha->spinup_group =
> +                       payload.func_specific[SPINUP_GROUP_OFFSET];
> +       } else {
> +               pm8001_ha->spinup_interval = 0;
> +               pm8001_ha->spinup_group = pm8001_ha->chip->n_phy;
> +       }
> +
> +       if (pm8001_ha->spinup_interval > PM80XX_MAX_SPINUP_DELAY) {
> +               PM8001_DISC_DBG(pm8001_ha, pm8001_printk(
> +               "Spinup delay from Seeprom is %d ms, reset to %d ms\n",
> +               pm8001_ha->spinup_interval * 100, PM80XX_MAX_SPINUP_DELAY));
> +               pm8001_ha->spinup_interval = PM80XX_MAX_SPINUP_DELAY;
> +       }
> +
> +       if (pm8001_ha->spinup_group > pm8001_ha->chip->n_phy) {
> +               PM8001_DISC_DBG(pm8001_ha, pm8001_printk(
> +               "Spinup group from Seeprom is %d, reset to %d\n",
> +               pm8001_ha->spinup_group, pm8001_ha->chip->n_phy));
> +               pm8001_ha->spinup_group = pm8001_ha->chip->n_phy;
> +       }
> +
> +       PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
> +               "Spinup interval : %d Spinup group %d\n",
> +               pm8001_ha->spinup_interval, pm8001_ha->spinup_group));
>  }
>
>  /*
> @@ -1104,7 +1151,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>                 pm80xx_set_thermal_config(pm8001_ha);
>         }
>
> -       pm8001_init_sas_add(pm8001_ha);
> +       pm8001_init_sas_add_and_spinup_config(pm8001_ha);
>         /* phy setting support for motherboard controller */
>         if (pm8001_configure_phy_settings(pm8001_ha))
>                 goto err_out_shost;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 3a69d8d1d52e..806845203602 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -267,12 +267,38 @@ void pm8001_scan_start(struct Scsi_Host *shost)
>         int i;
>         struct pm8001_hba_info *pm8001_ha;
>         struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       DECLARE_COMPLETION(comp);
>         pm8001_ha = sha->lldd_ha;
>         /* SAS_RE_INITIALIZATION not available in SPCv/ve */
>         if (pm8001_ha->chip_id == chip_8001)
>                 PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
> -       for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
> -               PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
> +
> +       if (pm8001_ha->pdev->device == 0x8001 ||
> +               pm8001_ha->pdev->device == 0x8081 ||
> +               (pm8001_ha->spinup_interval != 0)) {
> +               for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
> +                       PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
> +       } else {
> +               for (i = 0; i < pm8001_ha->chip->n_phy; ++i) {
> +                       spin_lock_irqsave(&pm8001_ha->lock,
> +                               pm8001_ha->lock_flags);
> +                       pm8001_ha->phy_started = i;
> +                       pm8001_ha->scan_completion = &comp;
> +                       pm8001_ha->phystart_timedout = 1;
> +                       spin_unlock_irqrestore(&pm8001_ha->lock,
> +                               pm8001_ha->lock_flags);
> +                       PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
> +                       wait_for_completion_timeout(&comp,
> +                               msecs_to_jiffies(500));
> +                       if (pm8001_ha->phystart_timedout)
> +                               PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
> +                               "Timeout happened for phyid = %d\n", i));
> +               }
> +               spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
> +               pm8001_ha->phy_started = -1;
> +               pm8001_ha->scan_completion = NULL;
> +               spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
> +       }
>  }
>
>  int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time)
> @@ -663,6 +689,13 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
>                         flag = 1; /* directly sata */
>                 }
>         } /*register this device to HBA*/
> +
> +       if (pm8001_ha->phy_started == pm8001_device->attached_phy) {
> +               if (pm8001_ha->scan_completion != NULL) {
> +                       pm8001_ha->phystart_timedout = 0;
> +                       complete(pm8001_ha->scan_completion);
> +               }
> +       }
>         PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
>         PM8001_CHIP_DISP->reg_dev_req(pm8001_ha, pm8001_device, flag);
>         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index cba4e9b95c58..df02c6cd116a 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -261,6 +261,7 @@ struct pm8001_port {
>         u8                      port_attached;
>         u16                     wide_port_phymap;
>         u8                      port_state;
> +       u8                      port_id;
>         struct list_head        list;
>  };
>
> @@ -503,6 +504,7 @@ struct pm8001_hba_info {
>         unsigned long           flags;
>         spinlock_t              lock;/* host-wide lock */
>         spinlock_t              bitmap_lock;
> +       unsigned long           lock_flags;
This seems fine, only one question: why do you need this lock_flags in hba?
>         struct pci_dev          *pdev;/* our device */
>         struct device           *dev;
>         struct pm8001_hba_memspace io_mem[6];
> @@ -566,6 +568,17 @@ struct pm8001_hba_info {
>         u32                     non_fatal_read_length;
>         struct completion       *phyprofile_completion;
>         struct phy_prof_resp    phy_profile_resp;
> +       bool                    staggered_spinup;
> +       struct completion       *scan_completion;
> +       u32                     phy_started;
> +       u16                     phystart_timedout;
> +       int                     spinup_group;
> +       int                     spinup_interval;
> +       int                     phy_up[PM8001_MAX_PHYS];
> +       struct timer_list       spinup_timer;
> +       int                     phy_head;
> +       int                     phy_tail;
> +       spinlock_t              phy_q_lock;
>  };
>
>  struct pm8001_work {
> @@ -684,6 +697,7 @@ void pm8001_open_reject_retry(
>  int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
>         dma_addr_t *pphys_addr, u32 *pphys_addr_hi, u32 *pphys_addr_lo,
>         u32 mem_size, u32 align);
> +void pm8001_spinup_timedout(struct timer_list *t);
>
>  void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha);
>  int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 0f4f18b0e480..0040bb4e1b71 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -46,6 +46,72 @@
>  #define SMP_DIRECT 1
>  #define SMP_INDIRECT 2
>
> +static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
> +       u32 phyId, u32 phy_op);
> +
> +void  pm8001_queue_phyup(struct pm8001_hba_info *pm8001_ha, int phy_id)
> +{
> +       int i;
> +
> +       if (pm8001_ha->phy_head == -1) {
> +               pm8001_ha->phy_head = pm8001_ha->phy_tail = 0;
> +       } else {
> +               /* If the phy id is already queued , discard the phy up */
> +               for (i = 0; i < pm8001_ha->chip->n_phy; i++)
> +                       if (pm8001_ha->phy_up[i] == phy_id)
> +                               return;
> +               pm8001_ha->phy_tail =
> +                       (pm8001_ha->phy_tail + 1) % PM8001_MAX_PHYS;
> +       }
> +       pm8001_ha->phy_up[pm8001_ha->phy_tail] = phy_id;
> +}
> +
> +void pm8001_spinup_timedout(struct timer_list *t)
> +{
> +       struct pm8001_hba_info *pm8001_ha =
> +                       from_timer(pm8001_ha, t, spinup_timer);
> +       struct pm8001_phy *phy;
> +       unsigned long flags;
> +       int i = 0, phy_id = 0xff;
> +
> +       spin_lock_irqsave(&pm8001_ha->phy_q_lock, flags);
> +
> +       do {
> +               if (i++ >= pm8001_ha->spinup_group && pm8001_ha->spinup_group)
> +                       break;
> +
> +               if (pm8001_ha->phy_head == -1 || pm8001_ha->reset_in_progress)
> +                       break; /* No phys to spinup */
> +
> +               phy_id = pm8001_ha->phy_up[pm8001_ha->phy_head];
> +               /* Processed phy id, make it invalid 0xff for
> +                * checking repeated phy ups
> +                */
> +               pm8001_ha->phy_up[pm8001_ha->phy_head] = 0xff;
> +               if (pm8001_ha->phy_head == pm8001_ha->phy_tail) {
> +                       pm8001_ha->phy_head = pm8001_ha->phy_tail = -1;
> +               } else {
> +                       pm8001_ha->phy_head =
> +                               (pm8001_ha->phy_head+1) % PM8001_MAX_PHYS;
> +               }
> +
> +               if (phy_id == 0xff)
> +                       break;
> +               phy = &pm8001_ha->phy[phy_id];
> +               if (phy->phy_type & PORT_TYPE_SAS) {
> +                       PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,
> +                                       PHY_NOTIFY_ENABLE_SPINUP);
> +               } else {
> +                       PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,
> +                                       PHY_LINK_RESET);
> +               }
> +       } while (1);
> +
> +       if (pm8001_ha->phy_head != -1 && pm8001_ha->spinup_group)
> +               mod_timer(&pm8001_ha->spinup_timer,
> +                       jiffies + msecs_to_jiffies(pm8001_ha->spinup_interval));
> +       spin_unlock_irqrestore(&pm8001_ha->phy_q_lock, flags);
> +}
>
>  int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
>  {
> @@ -3302,11 +3368,12 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         port->port_state = portstate;
>         port->wide_port_phymap |= (1U << phy_id);
>         phy->phy_state = PHY_STATE_LINK_UP_SPCV;
> +       phy->port = port;
>         PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
>                 "portid:%d; phyid:%d; linkrate:%d; "
>                 "portstate:%x; devicetype:%x\n",
>                 port_id, phy_id, link_rate, portstate, deviceType));
> -
> +       port->port_id = port_id;
>         switch (deviceType) {
>         case SAS_PHY_UNUSED:
>                 PM8001_MSG_DBG(pm8001_ha,
> @@ -3314,8 +3381,12 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 break;
>         case SAS_END_DEVICE:
>                 PM8001_MSG_DBG(pm8001_ha, pm8001_printk("end device.\n"));
> -               pm80xx_chip_phy_ctl_req(pm8001_ha, phy_id,
> -                       PHY_NOTIFY_ENABLE_SPINUP);
> +               spin_lock_irqsave(&pm8001_ha->phy_q_lock, flags);
> +               pm8001_queue_phyup(pm8001_ha, phy_id);
> +               spin_unlock_irqrestore(&pm8001_ha->phy_q_lock, flags);
> +               if (!timer_pending(&pm8001_ha->spinup_timer))
> +                       mod_timer(&pm8001_ha->spinup_timer,
> +                       jiffies + msecs_to_jiffies(pm8001_ha->spinup_interval));
>                 port->port_attached = 1;
>                 pm8001_get_lrate_mode(phy, link_rate);
>                 break;
> @@ -3351,9 +3422,10 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         phy->frame_rcvd_size = sizeof(struct sas_identify_frame) - 4;
>         pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);
>         spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
> -       if (pm8001_ha->flags == PM8001F_RUN_TIME)
> -               msleep(200);/*delay a moment to wait disk to spinup*/
> -       pm8001_bytes_dmaed(pm8001_ha, phy_id);
> +       if (!pm8001_ha->reset_in_progress) {
> +               if (deviceType != SAS_END_DEVICE)
> +                       pm8001_bytes_dmaed(pm8001_ha, phy_id);
> +       }
>  }
>
>  /**
> @@ -3388,11 +3460,17 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         port->port_state = portstate;
>         phy->phy_state = PHY_STATE_LINK_UP_SPCV;
>         port->port_attached = 1;
> +       phy->port = port;
> +       port->port_id = port_id;
>         pm8001_get_lrate_mode(phy, link_rate);
>         phy->phy_type |= PORT_TYPE_SATA;
>         phy->phy_attached = 1;
>         phy->sas_phy.oob_mode = SATA_OOB_MODE;
> -       sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
> +       if (!pm8001_ha->reset_in_progress) {
> +               sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
> +       } else
> +               PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
> +                       "HW_EVENT_PHY_UP: not notified to host\n"));
>         spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
>         memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
>                 sizeof(struct dev_to_host_fis));
> @@ -3401,7 +3479,8 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         phy->identify.device_type = SAS_SATA_DEV;
>         pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);
>         spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
> -       pm8001_bytes_dmaed(pm8001_ha, phy_id);
> +       if (!pm8001_ha->reset_in_progress)
> +               pm8001_bytes_dmaed(pm8001_ha, phy_id);
>  }
>
>  /**
> @@ -3497,12 +3576,14 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 status, phy_id));
>         if (status == 0) {
>                 phy->phy_state = PHY_LINK_DOWN;
> -               if (pm8001_ha->flags == PM8001F_RUN_TIME &&
> -                               phy->enable_completion != NULL) {
> -                       complete(phy->enable_completion);
> -                       phy->enable_completion = NULL;
> -               }
>         }
> +
> +       if (pm8001_ha->flags == PM8001F_RUN_TIME &&
> +               phy->enable_completion != NULL) {
> +               complete(phy->enable_completion);
> +               phy->enable_completion = NULL;
> +       }
> +
>         return 0;
>
>  }
> @@ -3580,7 +3661,14 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         case HW_EVENT_SATA_SPINUP_HOLD:
>                 PM8001_MSG_DBG(pm8001_ha,
>                         pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD\n"));
> -               sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
> +               spin_lock_irqsave(&pm8001_ha->phy_q_lock, flags);
> +               pm8001_queue_phyup(pm8001_ha, phy_id);
> +               spin_unlock_irqrestore(&pm8001_ha->phy_q_lock, flags);
> +
> +               /* Start the timer if not started */
> +               if (!timer_pending(&pm8001_ha->spinup_timer))
> +                       mod_timer(&pm8001_ha->spinup_timer,
> +                       jiffies + msecs_to_jiffies(pm8001_ha->spinup_interval));
>                 break;
>         case HW_EVENT_PHY_DOWN:
>                 PM8001_MSG_DBG(pm8001_ha,
> @@ -4889,7 +4977,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
>         PM8001_INIT_DBG(pm8001_ha,
>                 pm8001_printk("PHY START REQ for phy_id %d\n", phy_id));
>
> -       payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
> +       payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_ENABLE |
>                         LINKMODE_AUTO | pm8001_ha->link_rate | phy_id);
>         /* SSC Disable and SAS Analog ST configuration */
>         /**
> @@ -4951,6 +5039,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>         u16 ITNT = 2000;
>         struct domain_device *dev = pm8001_dev->sas_device;
>         struct domain_device *parent_dev = dev->parent;
> +       struct pm8001_phy *phy;
> +       struct pm8001_port *port;
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>
>         memset(&payload, 0, sizeof(payload));
> @@ -4982,8 +5072,11 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>         linkrate = (pm8001_dev->sas_device->linkrate < dev->port->linkrate) ?
>                         pm8001_dev->sas_device->linkrate : dev->port->linkrate;
>
> +       phy = &pm8001_ha->phy[phy_id];
> +       port = phy->port;
> +
>         payload.phyid_portid =
> -               cpu_to_le32(((pm8001_dev->sas_device->port->id) & 0xFF) |
> +               cpu_to_le32(((port->port_id) & 0xFF) |
>                 ((phy_id & 0xFF) << 8));
>
>         payload.dtype_dlr_mcn_ir_retry = cpu_to_le32((retryFlag & 0x01) |
> --
> 2.16.3
>
