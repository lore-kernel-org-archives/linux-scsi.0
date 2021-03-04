Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE160C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C2464E12
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbhCDJkP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbhCDJj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:39:57 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7B1C061756
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:39:16 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id do6so48130586ejc.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0badxaDicwXjVF088v7BmpAmSQRd5QolZlHDOo/VSN0=;
        b=OXzXfywnZlSptTU0zqE5anGHmJSQEWHUCsoF2v1LgG069obPD81DvSCDJGibZB/A60
         NIvNeCHADBA/tWPe2Fwo29RO3CbKXyMWmSqIyBMzwVqPcpdWQve36gGTW7cYzOcKlPzD
         wncs03jIBN8xeK1O7Z/WSI9Dg6nA1S0VvmSlEJ/ddBVMjOOwwnK046gwS5k75QC3kUXj
         /JF+qBVt90TpvguNGHDwJGGOKzfA/nyu/B/Cw+f9chLCEtAofi4DYp2VKwqDBXXYzEQJ
         moI7zMzsjPWpwFmGqjcKITDSNDdLths8qhOw4INQMkSTsEmzKG2RhvnctKI/gVWgrsKF
         VKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0badxaDicwXjVF088v7BmpAmSQRd5QolZlHDOo/VSN0=;
        b=TQZYrbmi1UCmQ/EVIQFL/YtFnLaswUUqwRXy0br0RR8VljGnLzu5/goN+ngm385Y8f
         LDDZT0jYE/VGgmg3uADtLbZkyb/I4Z/UJo69gj2IyQEDnujTRr/ElZYio7axO2W66+qA
         XW2FXpdvBndnojiX/NTMVWEPLoHdeJq9N8Afd4/codJvx7vcwuJxNSUcMprCAvluW0dA
         y7d+w+duhQjRAcyYKzSW/KzrG1YATz9PvW/PUGOoil0YIt/B22SBIMRS3yqx2yHKfKQK
         L9Ej1es1LaPXI1gBTxZX4tRJ/mKwLIkZRqKoV6gcIOZJpHzZ20T2cDnpDB+JbL9Jo05B
         3vpA==
X-Gm-Message-State: AOAM533WJBU3VZneTJ1nLopSHyVOLM3vqS7pPnAMALBwAHKC3b5GXm7F
        z7S5dwvPrvEE7yVrIM0ZH+SvV8Rlpm/rNWBDusoavmn/meI=
X-Google-Smtp-Source: ABdhPJzrgyAtWMknoBz+y+2rERb3e9Iv14RGg97bzNhmLyyNEkCILykdcDwiEwV25ca7dVgs1km+bNg1fcQKqRrmCbA=
X-Received: by 2002:a17:906:2804:: with SMTP id r4mr3157453ejc.521.1614850755669;
 Thu, 04 Mar 2021 01:39:15 -0800 (PST)
MIME-Version: 1.0
References: <20210224155802.13292-1-Viswas.G@microchip.com> <20210224155802.13292-8-Viswas.G@microchip.com>
In-Reply-To: <20210224155802.13292-8-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:39:05 +0100
Message-ID: <CAMGffE=ByJSOw9JGd-2s6aQRdvBYvE0RjShGFYn4QXTeamjxFg@mail.gmail.com>
Subject: Re: [PATCH 7/7] pm80xx: remove global lock from outbound queue processing
To:     Viswas G <Viswas.G@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com,
        Vishakha Channapattan <vishakhavc@google.com>,
        Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 24, 2021 at 4:48 PM Viswas G <Viswas.G@microchip.com> wrote:
>
> Introduced spin lock for outbound queue. With this, driver need not
> acquire hba global lock for outbound queue processing.
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Looks ok to me!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 9 ++++++---
>  drivers/scsi/pm8001/pm8001_sas.h  | 1 +
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 4 ++--
>  3 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index bd626ef876da..a3c8fb9a885f 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -267,7 +267,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>  {
>         int i, count = 0, rc = 0;
>         u32 ci_offset, ib_offset, ob_offset, pi_offset;
> -       struct inbound_queue_table *circularQ;
> +       struct inbound_queue_table *ibq;
> +       struct outbound_queue_table *obq;
>
>         spin_lock_init(&pm8001_ha->lock);
>         spin_lock_init(&pm8001_ha->bitmap_lock);
> @@ -315,8 +316,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>         pm8001_ha->memoryMap.region[IOP].alignment = 32;
>
>         for (i = 0; i < count; i++) {
> -               circularQ = &pm8001_ha->inbnd_q_tbl[i];
> -               spin_lock_init(&circularQ->iq_lock);
> +               ibq = &pm8001_ha->inbnd_q_tbl[i];
> +               spin_lock_init(&ibq->iq_lock);
>                 /* MPI Memory region 3 for consumer Index of inbound queues */
>                 pm8001_ha->memoryMap.region[ci_offset+i].num_elements = 1;
>                 pm8001_ha->memoryMap.region[ci_offset+i].element_size = 4;
> @@ -345,6 +346,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>         }
>
>         for (i = 0; i < count; i++) {
> +               obq = &pm8001_ha->outbnd_q_tbl[i];
> +               spin_lock_init(&obq->oq_lock);
>                 /* MPI Memory region 4 for producer Index of outbound queues */
>                 pm8001_ha->memoryMap.region[pi_offset+i].num_elements = 1;
>                 pm8001_ha->memoryMap.region[pi_offset+i].element_size = 4;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 36cd37c8c29a..f835557ee354 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -457,6 +457,7 @@ struct outbound_queue_table {
>         u32                     dinterrup_to_pci_offset;
>         __le32                  producer_index;
>         u32                     consumer_idx;
> +       spinlock_t              oq_lock;
>  };
>  struct pm8001_hba_memspace {
>         void __iomem            *memvirtaddr;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 0f2c57e054ac..f1276baebe1d 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4133,8 +4133,8 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
>                         return ret;
>                 }
>         }
> -       spin_lock_irqsave(&pm8001_ha->lock, flags);
>         circularQ = &pm8001_ha->outbnd_q_tbl[vec];
> +       spin_lock_irqsave(&circularQ->oq_lock, flags);
>         do {
>                 /* spurious interrupt during setup if kexec-ing and
>                  * driver doing a doorbell access w/ the pre-kexec oq
> @@ -4160,7 +4160,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
>                                 break;
>                 }
>         } while (1);
> -       spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +       spin_unlock_irqrestore(&circularQ->oq_lock, flags);
>         return ret;
>  }
>
> --
> 2.16.3
>
