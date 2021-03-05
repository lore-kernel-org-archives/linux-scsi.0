Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5F4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 06:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63F5E65000
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 06:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhCEGqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 01:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEGqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 01:46:03 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DEBC061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 22:46:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id bd6so1053765edb.10
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 22:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X4cihsrsdwxzY37DByAY/17ek7ZZmCX6L8vdaVjNsWg=;
        b=hRW/pRKwptKi1Pt3kdTv5xhtbassyxLix4bYsiFHngVtlEMqcH6N4okPKOv2YdeIyE
         5Py4nILH2XY7RbG+P3dcc5qS8HLE7rZXliBqLojf634rsIPMnpBBmIWtTAlQxmovUNzU
         n+g0oChAnuI8TLUsU7zRBvUG+PK2a8H+/1dFfci/PrMgtxlCDAie2tf1sm5LDimKkjDl
         cvToLqTAVuxWWq3JzPEClRT0CuwMla7GhHCl/SoS4JXgi3dxVi60yYJouHXKxx2HowUF
         kJLqaXNBoGErFOv2J5KEwY8pRI6Ic7iwKs9Nyr1aBRONwJ06xl100am2PqXXA+FLC2P3
         lWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X4cihsrsdwxzY37DByAY/17ek7ZZmCX6L8vdaVjNsWg=;
        b=EkZBu0XzFp1qzQ9pCxmKXUTfiEPNMyp6E1kefjJ5OVO81eB0VItTG+gQCqPcB7Sc2y
         RVyRgg8qPyoedXr5eqR43S7NhMN0MLMmbmu6jm9uqGlsqFxfwkQcHMFhBftBEVM2YLoE
         3acnOwtGW5TFjxN5692Lt0roTMwIveZChckLt3sMYgbuKSJ5rh7leJb6p8xHeBbIU7+c
         /sul4GEnoFYrovVAJGp26mx65noPkfdwbL2PJMu7unxHNP3aZL2dbKZi1cKkikjN0eHM
         3li9wV/3EYW4BoOBqdEam9Wqt1Jot1Uvzc8hlHnNoKEAReoEzZoeWiPxhTrm2WOmVRSv
         x0+w==
X-Gm-Message-State: AOAM531EQWdY7vyb1XnhN9694ra1oJlxBMYiLrS1X4vPHsVlo6+2ZQmX
        M3QMz9AwPpGZtuvJcUEfj8Z4e1z41t1U0BSuHZq7ZA==
X-Google-Smtp-Source: ABdhPJzjufaF6hm23avjHhT6/c33rBRDmjeRmYfi/pkopttoqnJDUfoLA7PthN0trd5nr3mounUoQ71mRGMV8PcN2nQ=
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr7899231edu.252.1614926762072;
 Thu, 04 Mar 2021 22:46:02 -0800 (PST)
MIME-Version: 1.0
References: <20210224155802.13292-1-Viswas.G@microchip.com>
 <20210224155802.13292-7-Viswas.G@microchip.com> <CAMGffEnmGcP9C3swBDugRAchzwdhrEt0QUz9m96d3SkVLQXR6g@mail.gmail.com>
 <SN6PR11MB3488054ABDA164ADF9E36EAC9D979@SN6PR11MB3488.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB3488054ABDA164ADF9E36EAC9D979@SN6PR11MB3488.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 5 Mar 2021 07:45:51 +0100
Message-ID: <CAMGffEkTd2N_Uh-KPq1btvhMRQ-N5rDJfGRx-v3jqjB8n00JPA@mail.gmail.com>
Subject: Re: [PATCH 6/7] pm80xx: Reset PI and CI memory during re-initialize
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

On Thu, Mar 4, 2021 at 5:47 PM <Viswas.G@microchip.com> wrote:
>
>
> > -----Original Message-----
> > From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
> > Sent: Thursday, March 4, 2021 3:07 PM
> > To: Viswas G - I30667 <Viswas.G@microchip.com>
> > Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>; Vasanthalakshmi
> > Tharmarajan - I30664 <Vasanthalakshmi.Tharmarajan@microchip.com>;
> > Ruksar Devadi - I52327 <Ruksar.devadi@microchip.com>; Vishakha
> > Channapattan <vishakhavc@google.com>; Radha Ramachandran
> > <radha@google.com>
> > Subject: Re: [PATCH 6/7] pm80xx: Reset PI and CI memory during re-initialize
> >
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> > content is safe
> >
> > On Wed, Feb 24, 2021 at 4:48 PM Viswas G <Viswas.G@microchip.com>
> > wrote:
> > >
> > > Producer index(PI) outbound queue and consumer index(CI) for Outbound
> > > queue are in DMA memory. These values should be reset to 0 during
> > > driver reinitialization.
> >
> > Why "reinitialization", the function  init_default_table_values is called from
> > chip init?
>
> Yes. This called from both probe() and resume(). During resume(), the stale PI and CI
> Values will leads to unexpected behavior.
Can you add this part to the commit message?
>
> > >
> > > Signed-off-by: Viswas G <Viswas.G@microchip.com>
> > > Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> > > Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
With that,
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > > ---
> > >  drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
> > > drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
> > >  2 files changed, 4 insertions(+)
> > >
> > > diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> > > b/drivers/scsi/pm8001/pm8001_hwi.c
> > > index 4e0ce044ac69..783149b8b127 100644
> > > --- a/drivers/scsi/pm8001/pm8001_hwi.c
> > > +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> > > @@ -240,6 +240,7 @@ static void init_default_table_values(struct
> > pm8001_hba_info *pm8001_ha)
> > >                         pm8001_ha->memoryMap.region[ci_offset + i].phys_addr_lo;
> > >                 pm8001_ha->inbnd_q_tbl[i].ci_virt               =
> > >                         pm8001_ha->memoryMap.region[ci_offset +
> > > i].virt_ptr;
> > > +               pm8001_write_32(pm8001_ha->inbnd_q_tbl[i].ci_virt, 0,
> > > + 0);
> > >                 offsetib = i * 0x20;
> > >                 pm8001_ha->inbnd_q_tbl[i].pi_pci_bar            =
> > >                         get_pci_bar_index(pm8001_mr32(addressib,
> > > @@ -268,6 +269,7 @@ static void init_default_table_values(struct
> > pm8001_hba_info *pm8001_ha)
> > >                         0 | (10 << 16) | (i << 24);
> > >                 pm8001_ha->outbnd_q_tbl[i].pi_virt              =
> > >                         pm8001_ha->memoryMap.region[pi_offset +
> > > i].virt_ptr;
> > > +               pm8001_write_32(pm8001_ha->outbnd_q_tbl[i].pi_virt, 0,
> > > + 0);
> > >                 offsetob = i * 0x24;
> > >                 pm8001_ha->outbnd_q_tbl[i].ci_pci_bar           =
> > >                         get_pci_bar_index(pm8001_mr32(addressob,
> > > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
> > > b/drivers/scsi/pm8001/pm80xx_hwi.c
> > > index 1aa3a499c85a..0f2c57e054ac 100644
> > > --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> > > +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> > > @@ -787,6 +787,7 @@ static void init_default_table_values(struct
> > pm8001_hba_info *pm8001_ha)
> > >                         pm8001_ha->memoryMap.region[ci_offset + i].phys_addr_lo;
> > >                 pm8001_ha->inbnd_q_tbl[i].ci_virt               =
> > >                         pm8001_ha->memoryMap.region[ci_offset +
> > > i].virt_ptr;
> > > +               pm8001_write_32(pm8001_ha->inbnd_q_tbl[i].ci_virt, 0,
> > > + 0);
> > >                 offsetib = i * 0x20;
> > >                 pm8001_ha->inbnd_q_tbl[i].pi_pci_bar            =
> > >                         get_pci_bar_index(pm8001_mr32(addressib,
> > > @@ -820,6 +821,7 @@ static void init_default_table_values(struct
> > pm8001_hba_info *pm8001_ha)
> > >                 pm8001_ha->outbnd_q_tbl[i].interrup_vec_cnt_delay = (i << 24);
> > >                 pm8001_ha->outbnd_q_tbl[i].pi_virt              =
> > >                         pm8001_ha->memoryMap.region[pi_offset +
> > > i].virt_ptr;
> > > +               pm8001_write_32(pm8001_ha->outbnd_q_tbl[i].pi_virt, 0,
> > > + 0);
> > >                 offsetob = i * 0x24;
> > >                 pm8001_ha->outbnd_q_tbl[i].ci_pci_bar           =
> > >                         get_pci_bar_index(pm8001_mr32(addressob,
> > > --
> > > 2.16.3
> > >
