Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CC3C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89AB261168
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhDIGHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbhDIGHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 02:07:52 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249C0C061761
        for <linux-scsi@vger.kernel.org>; Thu,  8 Apr 2021 23:07:37 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e7so5127588edu.10
        for <linux-scsi@vger.kernel.org>; Thu, 08 Apr 2021 23:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qw+rYW0fzLb+3GKey/TyfjTz/0+LRJjUz/6dnMaN51w=;
        b=gDCELGMjr7OOtBUpNWRLGZ75NK00Ga4m6WULPHRuU2Egtx6eOMmL65+SwtA9+qWYhL
         VwV7RA04qleAlzWB76atq/kVEz8wGe665Nr0az4Q2zcdJgTzENgb14NxRttuhO7C/wES
         ClYWJiwkXKfcfzdMi2W2bjtYmP4SHSfIVuRi6O/hG+TpHESAQd5Jkk72D9cSWEGEd1Dh
         2aDCHJxUl+LcD1iSYmkLw8BDmHl4fmRLJFuFdnONzja8uzXQ3VoQ/Y7lhL39yo9zJNwh
         YfXjz2k8hORLGIDunrgRF1zpTEEhWWkkWJ4sgJlKewKeOl6V8lavTTaMZ3KN8zoxtyxR
         SoTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qw+rYW0fzLb+3GKey/TyfjTz/0+LRJjUz/6dnMaN51w=;
        b=sn+jI1f/GVXEOBWFjr2xsjoiMrv9Qln756Qvh3DytUwReY62Y7RLhhAJWjmYGt/Q7m
         M00pgqtjPw45fospvPkcsY25336rdKhFo3OhsOvCt/GXLoT3ZewXsnVoCQlgyiqXxLqH
         M3yDOWoosmRhB/FUVN9W5ouIueqBQjfr8WIromTlR5Xf8rkX+26P2s8hozhGrnkfYPjN
         020wnd4NMZWpGK6hwAVHaa7wFFTOWk6pJ5AjuIeY5ZfaQIWhmOlk2s+GzZ4u7oXq7gYh
         DQfTHJk9eHhVrAlp/dULwzZ7LZ53hjznU1RRBDkQrXeizz4PkcS1778pjbSvTrt6ucW+
         9pUA==
X-Gm-Message-State: AOAM532wM1T0JUPV8uBfacvgbFCSEt1Vr6WRa7DjGtu+aXB4ZlzbSE9p
        jB5TzDsVozgBM/xotLq+qeqUs0ZYVuGS42a3SWzJbm3F1v4=
X-Google-Smtp-Source: ABdhPJx98U6D6SojG3j6/b/A4M2pc68bxOLpJ/dvv5UOZhQWHk/pfcmEEtGC8SNzo8WVmsAkWt0M1iGTXE3eewa6OWE=
X-Received: by 2002:a05:6402:42c9:: with SMTP id i9mr15930176edc.35.1617948455414;
 Thu, 08 Apr 2021 23:07:35 -0700 (PDT)
MIME-Version: 1.0
References: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com> <1617886593-36421-2-git-send-email-luojiaxing@huawei.com>
In-Reply-To: <1617886593-36421-2-git-send-email-luojiaxing@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 9 Apr 2021 08:07:24 +0200
Message-ID: <CAMGffEnA9PO8u1CBdJ9kOuQLd3nFVBaiVNwMq8uw05FShojJHA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: pm8001: clean up for white space
To:     Luo Jiaxing <luojiaxing@huawei.com>
Cc:     Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 8, 2021 at 2:56 PM Luo Jiaxing <luojiaxing@huawei.com> wrote:
>
> Some errors are found like below when run checkpatch.pl
>
> ERROR: space prohibited before that ',' (ctx:WxW)
> +int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb);
>
> It all about white space, so fix them.
>
> Signed-off-by: Jianqin Xie <xiejianqin@hisilicon.com>
> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
looks good to me, thx!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 20 +++++++++-----------
>  drivers/scsi/pm8001/pm8001_ctl.h |  5 +++++
>  drivers/scsi/pm8001/pm8001_hwi.c | 14 +++++++-------
>  drivers/scsi/pm8001/pm8001_sas.c | 20 ++++++++++----------
>  drivers/scsi/pm8001/pm8001_sas.h |  2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c | 14 +++++++-------
>  6 files changed, 39 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 12035ba..90b816f 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -369,24 +369,22 @@ static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
>         struct Scsi_Host *shost = class_to_shost(cdev);
>         struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>         struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       u8 *ptr = (u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr;
>         int i;
> -#define AAP1_MEMMAP(r, c) \
> -       (*(u32 *)((u8*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 \
> -       + (c)))
>
>         char *str = buf;
>         int max = 2;
>         for (i = 0; i < max; i++) {
>                 str += sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x"
>                                "0x%08x 0x%08x\n",
> -                              AAP1_MEMMAP(i, 0),
> -                              AAP1_MEMMAP(i, 4),
> -                              AAP1_MEMMAP(i, 8),
> -                              AAP1_MEMMAP(i, 12),
> -                              AAP1_MEMMAP(i, 16),
> -                              AAP1_MEMMAP(i, 20),
> -                              AAP1_MEMMAP(i, 24),
> -                              AAP1_MEMMAP(i, 28));
> +                              pm8001_ctl_aap1_memmap(ptr, i, 0),
> +                              pm8001_ctl_aap1_memmap(ptr, i, 4),
> +                              pm8001_ctl_aap1_memmap(ptr, i, 8),
> +                              pm8001_ctl_aap1_memmap(ptr, i, 12),
> +                              pm8001_ctl_aap1_memmap(ptr, i, 16),
> +                              pm8001_ctl_aap1_memmap(ptr, i, 20),
> +                              pm8001_ctl_aap1_memmap(ptr, i, 24),
> +                              pm8001_ctl_aap1_memmap(ptr, i, 28));
>         }
>
>         return str - buf;
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
> index d0d43a2..4743f0d 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.h
> +++ b/drivers/scsi/pm8001/pm8001_ctl.h
> @@ -59,5 +59,10 @@
>  #define SYSFS_OFFSET                    1024
>  #define PM80XX_IB_OB_QUEUE_SIZE         (32 * 1024)
>  #define PM8001_IB_OB_QUEUE_SIZE         (16 * 1024)
> +
> +static inline u32 pm8001_ctl_aap1_memmap(u8 *ptr, int idx, int off)
> +{
> +       return *(u32 *)(ptr + idx * 32 + off);
> +}
>  #endif /* PM8001_CTL_H_INCLUDED */
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 49bf2f7..6887fa3 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1826,7 +1826,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>   * that the task has been finished.
>   */
>  static void
> -mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
> +mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
>         struct sas_task *t;
>         struct pm8001_ccb_info *ccb;
> @@ -2058,7 +2058,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
>  }
>
>  /*See the comments for mpi_ssp_completion */
> -static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
> +static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
>         struct sas_task *t;
>         unsigned long flags;
> @@ -2294,9 +2294,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 (status != IO_UNDERFLOW)) {
>                 if (!((t->dev->parent) &&
>                         (dev_is_expander(t->dev->parent->dev_type)))) {
> -                       for (i = 0 , j = 4; j <= 7 && i <= 3; i++ , j++)
> +                       for (i = 0, j = 4; j <= 7 && i <= 3; i++, j++)
>                                 sata_addr_low[i] = pm8001_ha->sas_addr[j];
> -                       for (i = 0 , j = 0; j <= 3 && i <= 3; i++ , j++)
> +                       for (i = 0, j = 0; j <= 3 && i <= 3; i++, j++)
>                                 sata_addr_hi[i] = pm8001_ha->sas_addr[j];
>                         memcpy(&temp_sata_addr_low, sata_addr_low,
>                                 sizeof(sata_addr_low));
> @@ -2625,7 +2625,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  }
>
>  /*See the comments for mpi_ssp_completion */
> -static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
> +static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
>         struct sas_task *t;
>         struct task_status_struct *ts;
> @@ -3602,7 +3602,7 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
>         return 0;
>  }
>
> -int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
> +int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
>         u32 status;
>         int i;
> @@ -3685,7 +3685,7 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   * @pm8001_ha: our hba card information
>   * @piomb: IO message buffer
>   */
> -static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
> +static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
>         unsigned long flags;
>         struct hw_event_resp *pPayload =
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index a98d449..43b77ac 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -877,8 +877,8 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
>                            pm8001_dev->device_id, pm8001_dev->dev_type);
>                 if (atomic_read(&pm8001_dev->running_req)) {
>                         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> -                       pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
> -                               dev, 1, 0);
> +                       pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
> +                                                       dev, 1, 0);
>                         while (atomic_read(&pm8001_dev->running_req))
>                                 msleep(20);
>                         spin_lock_irqsave(&pm8001_ha->lock, flags);
> @@ -1013,8 +1013,8 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
>                         goto out;
>                 }
>                 msleep(2000);
> -               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
> -                       dev, 1, 0);
> +               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
> +                                                    dev, 1, 0);
>                 if (rc) {
>                         pm8001_dbg(pm8001_ha, EH, "task abort failed %x\n"
>                                    "with rc %d\n", pm8001_dev->device_id, rc);
> @@ -1059,8 +1059,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
>                         goto out;
>                 }
>                 /* send internal ssp/sata/smp abort command to FW */
> -               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
> -                                                       dev, 1, 0);
> +               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
> +                                                    dev, 1, 0);
>                 msleep(100);
>
>                 /* deregister the target device */
> @@ -1075,8 +1075,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
>                 wait_for_completion(&completion_setstate);
>         } else {
>                 /* send internal ssp/sata/smp abort command to FW */
> -               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
> -                                                       dev, 1, 0);
> +               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
> +                                                    dev, 1, 0);
>                 msleep(100);
>
>                 /* deregister the target device */
> @@ -1104,8 +1104,8 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
>         DECLARE_COMPLETION_ONSTACK(completion_setstate);
>         if (dev_is_sata(dev)) {
>                 struct sas_phy *phy = sas_get_local_phy(dev);
> -               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
> -                       dev, 1, 0);
> +               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
> +                                                    dev, 1, 0);
>                 rc = sas_phy_reset(phy, 1);
>                 sas_put_local_phy(phy);
>                 pm8001_dev->setds_completion = &completion_setstate;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 039ed91..e7f693a 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -705,7 +705,7 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
>  int pm8001_mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
>  int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
>                                                         void *piomb);
> -int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb);
> +int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha, void *piomb);
>  int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
>  struct sas_task *pm8001_alloc_task(void);
>  void pm8001_task_done(struct sas_task *task);
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 8431556..5e02446 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -90,7 +90,7 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>         struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>         struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>         void __iomem *fatal_table_address = pm8001_ha->fatal_tbl_addr;
> -       u32 accum_len , reg_val, index, *temp;
> +       u32 accum_len, reg_val, index, *temp;
>         u32 status = 1;
>         unsigned long start;
>         u8 *direct_data;
> @@ -1904,7 +1904,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
>   * that the task has been finished.
>   */
>  static void
> -mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
> +mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
>         struct sas_task *t;
>         struct pm8001_ccb_info *ccb;
> @@ -2194,7 +2194,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
>  }
>
>  /*See the comments for mpi_ssp_completion */
> -static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
> +static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
>         struct sas_task *t;
>         unsigned long flags;
> @@ -2444,9 +2444,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 (status != IO_UNDERFLOW)) {
>                 if (!((t->dev->parent) &&
>                         (dev_is_expander(t->dev->parent->dev_type)))) {
> -                       for (i = 0 , j = 4; i <= 3 && j <= 7; i++ , j++)
> +                       for (i = 0, j = 4; i <= 3 && j <= 7; i++, j++)
>                                 sata_addr_low[i] = pm8001_ha->sas_addr[j];
> -                       for (i = 0 , j = 0; i <= 3 && j <= 3; i++ , j++)
> +                       for (i = 0, j = 0; i <= 3 && j <= 3; i++, j++)
>                                 sata_addr_hi[i] = pm8001_ha->sas_addr[j];
>                         memcpy(&temp_sata_addr_low, sata_addr_low,
>                                 sizeof(sata_addr_low));
> @@ -2788,7 +2788,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  }
>
>  /*See the comments for mpi_ssp_completion */
> -static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
> +static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
>         struct sas_task *t;
>         struct task_status_struct *ts;
> @@ -4918,7 +4918,7 @@ static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
>                                     u32 operation, u32 phyid,
>                                     u32 length, u32 *buf)
>  {
> -       u32 tag , i, j = 0;
> +       u32 tag, i, j = 0;
>         int rc;
>         struct set_phy_profile_req payload;
>         struct inbound_queue_table *circularQ;
> --
> 2.7.4
>
