Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4432DC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12CAB20842
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="IVWBvYaE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgHEEl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgHEEl2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:41:28 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96A5C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 21:41:27 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id jp10so18324300ejb.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 21:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTKaqOx2msHZCyWsM8+kgLu05HXsN8y3eifrw51nfV8=;
        b=IVWBvYaEYNfhtQGPqYqEMe8JgGV/ErhLpli6uH45m8p1uT6CLFrhqnu/3lQSvEr7ms
         0kej/CNR5mHW3FugRrgx/sdMiztPMBSJtWDRamfhadkEvWfC9rtRrodrCRs44YNWQ3tI
         S6LWH4YoHxDTPyYQjqtkQIuNxVCF17sTp9diIihP5xkVYlwfARXuDhkf05b3jrkDsvM6
         AMCVSwNtilpRLzqfS7d5iX/gm6Pzho5nGv2PuEC+FZUUa77WBc/eEFOYZyh/YWbVD/NA
         hUMA+MjRNbHuSC/aKGWcklqzUjuuc8VC2AmFwp7geYULs8d3O1xzOgyBoPNoyglt230l
         ChHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTKaqOx2msHZCyWsM8+kgLu05HXsN8y3eifrw51nfV8=;
        b=ePb9zF2eimerD0vOreHcOZKtGQZ4/bKkpZQNnxRe2P6bYEEWndoaOMKhlMXFe3hknn
         n2LbfHLj4WlEp7y1MhpTNTjf4QuYyYJtNRojhMXQuOrnsY+iK5zTwp/M/Kf/Dw0BIrfm
         H1PbCFWeqG3s1Me43TFCC7fUz9jZ/cHHokKYV16vGejtHpdKMPLsLssMfDabz675sKMV
         1K3l2ATD9CJmCJUgm0Ul4kspuJoN7pOtPqBT6iZzIC+FgX6m3/vw0yWt0F/+UNbyiCPR
         KTKtecYtccaOc7hpATijPLP5VniCeQsCGOVGZpXfDjHIqTAoQotuiBDhYjT2/9zX7VGr
         FPsw==
X-Gm-Message-State: AOAM533BbLDEtzYYg3yspE4okQ6TfdNTF4xwBejUCR6ZSWgLMNTV+SUr
        ZzHFRD4ENefgIjeydpwF/dP7pR0YaKtjJ7LrBuxO7g==
X-Google-Smtp-Source: ABdhPJyG5bZa5/hDJryi/KLgPvqKrgyCo/FyPVpydQZ6ZZaorcrRRhn0AVxsMrpM2Yjhlmc92otTqvgikJA8Q1voJTE=
X-Received: by 2002:a17:906:ca5a:: with SMTP id jx26mr1367734ejb.62.1596602485213;
 Tue, 04 Aug 2020 21:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200804045628.6590-1-deepak.ukey@microchip.com> <20200804045628.6590-2-deepak.ukey@microchip.com>
In-Reply-To: <20200804045628.6590-2-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 5 Aug 2020 06:41:14 +0200
Message-ID: <CAMGffEk+ax0eKvFKyuxpKerLCf-no3pVjPXWQA2GgS+Mw7Ow2A@mail.gmail.com>
Subject: Re: [PATCH V6 1/2] pm80xx : Support for get phy profile functionality.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jinpu Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 4, 2020 at 6:46 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> Added the support to get the phy profile which gives information
> about the phy states, port and errors on phy.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks!

> ---
>  drivers/scsi/pm8001/pm8001_ctl.h  | 33 +++++++++++++++
>  drivers/scsi/pm8001/pm8001_init.c |  2 +
>  drivers/scsi/pm8001/pm8001_sas.h  |  5 +++
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 88 ++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/pm8001/pm80xx_hwi.h  |  2 +
>  5 files changed, 128 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
> index d0d43a250b9e..f7aadaf5c6aa 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.h
> +++ b/drivers/scsi/pm8001/pm8001_ctl.h
> @@ -41,6 +41,39 @@
>  #ifndef PM8001_CTL_H_INCLUDED
>  #define PM8001_CTL_H_INCLUDED
>
> +#ifdef __LITTLE_ENDIAN_BITFIELD
> +struct phy_status {
> +       char            phy_id;
> +       unsigned int    phy_state:4;
> +       unsigned int    nlr:4;
> +       unsigned int    plr:4;
> +       unsigned int    reserved1:12;
> +       unsigned char   port_id;
> +       unsigned int    prts:4;
> +       unsigned int    reserved2:20;
> +} __packed;
> +#else
> +struct phy_status {
> +       char            phy_id;
> +       unsigned int    reserved1:12;
> +       unsigned int    plr:4;
> +       unsigned int    nlr:4;
> +       unsigned int    phy_state:4;
> +       unsigned char   port_id;
> +       unsigned int    reserved2:20;
> +       unsigned int    prts:4;
> +} __packed;
> +#endif
> +
> +struct phy_errcnt {
> +       unsigned int    InvalidDword;
> +       unsigned int    runningDisparityError;
> +       unsigned int    codeViolation;
> +       unsigned int    LossOfSyncDW;
> +       unsigned int    phyResetProblem;
> +       unsigned int    inboundCRCError;
> +};
> +
>  #define IOCTL_BUF_SIZE         4096
>  #define HEADER_LEN                     28
>  #define SIZE_OFFSET                    16
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 9e99262a2b9d..ff65d6cf6d31 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -398,6 +398,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>                 pm8001_ha->ccb_info[i].task = NULL;
>                 pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
>                 pm8001_ha->ccb_info[i].device = NULL;
> +               pm8001_ha->ccb_info[i].completion = NULL;
> +               pm8001_ha->ccb_info[i].resp_buf = NULL;
>                 ++pm8001_ha->tags_num;
>         }
>         pm8001_ha->flags = PM8001F_INIT_TIME;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index ae7ba9b3c4bc..488af79dec47 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -56,6 +56,7 @@
>  #include <scsi/sas_ata.h>
>  #include <linux/atomic.h>
>  #include "pm8001_defs.h"
> +#include "pm8001_ctl.h"
>
>  #define DRV_NAME               "pm80xx"
>  #define DRV_VERSION            "0.1.39"
> @@ -244,6 +245,8 @@ struct pm8001_dispatch {
>         int (*sas_diag_execute_req)(struct pm8001_hba_info *pm8001_ha,
>                 u32 state);
>         int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
> +       int (*get_phy_profile_req)(struct pm8001_hba_info *pm8001_ha,
> +               int phy, int page, struct completion *comp, void *buf);
>  };
>
>  struct pm8001_chip_info {
> @@ -318,6 +321,8 @@ struct pm8001_ccb_info {
>         struct pm8001_prd       buf_prd[PM8001_MAX_DMA_SG];
>         struct fw_control_ex    *fw_control_context;
>         u8                      open_retry;
> +       struct completion       *completion;
> +       void                    *resp_buf;
>  };
>
>  struct mpi_mem {
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 4d205ebaee87..baccb082e65f 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3792,7 +3792,6 @@ static int mpi_set_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
>         PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
>                         "SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x\n",
>                         status, err_qlfr_pgcd));
> -
>         return 0;
>  }
>
> @@ -3818,9 +3817,63 @@ static int mpi_get_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
>  static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
>                         void *piomb)
>  {
> +       u32 tag, page_code;
> +       struct phy_status *phy_status, *phy_stat;
> +       struct phy_errcnt *phy_err, *phy_err_cnt;
> +       struct pm8001_ccb_info *ccb;
> +       struct get_phy_profile_resp *pPayload =
> +               (struct get_phy_profile_resp *)(piomb + 4);
> +       u32 status = le32_to_cpu(pPayload->status);
> +
> +       page_code = (u8)((pPayload->ppc_phyid & 0xFF00) >> 8);
> +
>         PM8001_MSG_DBG(pm8001_ha,
> -                       pm8001_printk(" pm80xx_addition_functionality\n"));
> +               pm8001_printk(" pm80xx_addition_functionality\n"));
> +       if (status) {
> +               /* status is FAILED */
> +               PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> +                       "mpiGetPhyProfileReq failed  with status 0x%08x\n",
> +                       status));
> +       }
>
> +       tag = le32_to_cpu(pPayload->tag);
> +       ccb = &pm8001_ha->ccb_info[tag];
> +       if (ccb->completion != NULL) {
> +               if (status) {
> +                       /* signal fail status */
> +                       memset(&ccb->resp_buf, 0xff, sizeof(ccb->resp_buf));
> +               } else if (page_code == SAS_PHY_GENERAL_STATUS_PAGE) {
> +                       phy_status = (struct phy_status *)ccb->resp_buf;
> +                       phy_stat =
> +                       (struct phy_status *)pPayload->ppc_specific_rsp;
> +                       phy_status->phy_id =
> +                               le32_to_cpu((__force __le32)phy_stat->phy_id);
> +                       phy_status->phy_state =
> +                               le32_to_cpu((__force __le32)phy_stat->phy_state);
> +                       phy_status->plr =
> +                               le32_to_cpu((__force __le32)phy_stat->plr);
> +                       phy_status->nlr =
> +                               le32_to_cpu((__force __le32)phy_stat->nlr);
> +                       phy_status->port_id =
> +                               le32_to_cpu((__force __le32)phy_stat->port_id);
> +                       phy_status->prts =
> +                               le32_to_cpu((__force __le32)phy_stat->prts);
> +               } else if (page_code == SAS_PHY_ERR_COUNTERS_PAGE) {
> +                       phy_err = (struct phy_errcnt *)ccb->resp_buf;
> +                       phy_err_cnt =
> +                       (struct phy_errcnt *)pPayload->ppc_specific_rsp;
> +                       phy_err->InvalidDword =
> +                       le32_to_cpu((__force __le32)phy_err_cnt->InvalidDword);
> +                       phy_err->runningDisparityError = le32_to_cpu
> +                       ((__force __le32)phy_err_cnt->runningDisparityError);
> +                       phy_err->LossOfSyncDW = le32_to_cpu
> +                       ((__force __le32)phy_err_cnt->LossOfSyncDW);
> +                       phy_err->phyResetProblem = le32_to_cpu
> +                       ((__force __le32)phy_err_cnt->phyResetProblem);
> +               }
> +               complete(ccb->completion);
> +       }
> +       pm8001_tag_free(pm8001_ha, tag);
>         return 0;
>  }
>
> @@ -5013,6 +5066,36 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
>         return IRQ_HANDLED;
>  }
>
> +static int pm8001_chip_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
> +       int phy_id, int page_code, struct completion *comp, void *buf)
> +{
> +       u32 tag;
> +       struct get_phy_profile_req payload;
> +       struct inbound_queue_table *circularQ;
> +       struct pm8001_ccb_info *ccb;
> +       int rc, ppc_phyid;
> +       u32 opc = OPC_INB_GET_PHY_PROFILE;
> +
> +       memset(&payload, 0, sizeof(payload));
> +
> +       rc = pm8001_tag_alloc(pm8001_ha, &tag);
> +       if (rc)
> +               PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Invalid tag\n"));
> +
> +       ccb = &pm8001_ha->ccb_info[tag];
> +       ccb->completion = comp;
> +       ccb->resp_buf = buf;
> +       circularQ = &pm8001_ha->inbnd_q_tbl[0];
> +
> +       payload.tag = cpu_to_le32(tag);
> +       ppc_phyid = (page_code & 0xFF)  << 8 | (phy_id & 0xFF);
> +       payload.ppc_phyid = cpu_to_le32(ppc_phyid);
> +
> +       pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
> +                       sizeof(payload), 0);
> +       return rc;
> +}
> +
>  void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
>         u32 operation, u32 phyid, u32 length, u32 *buf)
>  {
> @@ -5113,4 +5196,5 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
>         .set_nvmd_req           = pm8001_chip_set_nvmd_req,
>         .fw_flash_update_req    = pm8001_chip_fw_flash_update_req,
>         .set_dev_state_req      = pm8001_chip_set_dev_state_req,
> +       .get_phy_profile_req    = pm8001_chip_get_phy_profile,
>  };
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index 701951a0f715..b5119c5479da 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -175,7 +175,9 @@
>  #define PHY_STOP_ERR_DEVICE_ATTACHED   0x1046
>
>  /* phy_profile */
> +#define SAS_PHY_ERR_COUNTERS_PAGE      0x01
>  #define SAS_PHY_ANALOG_SETTINGS_PAGE   0x04
> +#define SAS_PHY_GENERAL_STATUS_PAGE    0x05
>  #define PHY_DWORD_LENGTH               0xC
>
>  /* Thermal related */
> --
> 2.16.3
>
