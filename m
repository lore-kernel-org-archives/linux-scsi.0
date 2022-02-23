Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA9EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 07:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238566AbiBWHLQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 02:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbiBWHLP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 02:11:15 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB2F3C488
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 23:10:47 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id bq11so21406244edb.2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 23:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UK0FMpnilIY5H9qpDsAkFFsa77DQcWp0UGnQewDP0CU=;
        b=MKpGzdKRbICyjHiA2RuLTwF3Vo+TXCzrd9Sbs6tkzaMwa33gBPAbqe4GilzlddmZXY
         6BfJ0WxFN3O0TLuXlKA0cFjYsuGwPbCqRVBYFky8LEwhnPFL9EmOG7j+qpCj9DK5HKJ6
         knZQaTm8TWRkBSlRpgj7aZBjVpKkTn781ZT6F4BiyOAp8Q6oZgckciEv6E1Uoo6cEmui
         /cpaIQSs2Ng12N9zqC6xXz5XJyJ8V8cL+TUx8vhRBA7iGjl52JuL2MUaE0raGu7Xt1XA
         WdoXbl8+Dw2y93w+TVHcG7IOrOT54sX9QShX/wbuNP+hlHAkZPF09T+Igjli2VVemo9F
         NO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UK0FMpnilIY5H9qpDsAkFFsa77DQcWp0UGnQewDP0CU=;
        b=qn9YwEjaZz9mC12McvWp5BJMYkQuF1aoYaszIA+MCmhqZSI43xROYiDTLRAKcazgqw
         GkK5kjz4/LxzA/Bka8vjJZigchh/VEW+uZoYgTApIgYSO85FdR/1gIQEs9MsvUsIC7Gx
         uKDd+EDKWeRNtjO9AmMDHRyyO1C38xdy/Bxj+KH+8ePI2bfhV001LeG4RNNhSBEtXtxw
         hXVdP8BnE1/A7dIxgV8ceh07O48/tc/+hPk2povktskbOe6qZNyRVFqKqdiuS4q3NTgd
         kKgz6tC7YVLNxRCOxGiM6BceqdIai8TLDJwzEjiskQ8dDulhBkSRAfLJk4Q47PT/g5ko
         s7og==
X-Gm-Message-State: AOAM532z/C0J24Up28H+iYgCzZ+mxH11jcE0dw/WPHvimmkm2w6yTrWJ
        yw5cE3X2E34xT0obMw9Jg+u8MEmrLiF8Ys0pRMJNgA==
X-Google-Smtp-Source: ABdhPJyqiYUueKi/hmiL+xXx0/LXhJmF48/BoJTV1VFIAi0yPruLN0mgl8LrEq8E2WiFyDIpDT5TxJLUXUk/gIwr/d0=
X-Received: by 2002:a50:9b12:0:b0:410:b926:d2d3 with SMTP id
 o18-20020a509b12000000b00410b926d2d3mr30055571edi.331.1645600246414; Tue, 22
 Feb 2022 23:10:46 -0800 (PST)
MIME-Version: 1.0
References: <20220222092618.108198-1-Ajish.Koshy@microchip.com> <2ad7f76c-a14b-6cae-942a-b93d792a8034@opensource.wdc.com>
In-Reply-To: <2ad7f76c-a14b-6cae-942a-b93d792a8034@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 23 Feb 2022 08:10:35 +0100
Message-ID: <CAMGffEmPpsEfA-qo05CuE0Dyy69vVACpn1aTGJW1VS+WhaFf5w@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: pm80xx: handle non-fatal errors
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Ajish Koshy <Ajish.Koshy@microchip.com>,
        linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 23, 2022 at 1:47 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 2/22/22 18:26, Ajish Koshy wrote:
> > Firmware expects host driver to clear scratchpad rsvd 0 register after
> > non-fatal error is found.
> >
> > This is done when firmware raises fatal error interrupt and indicates
> > non-fatal error. At this point firmware updates scratchpad rsvd 0
> > register with non-fatal error value. Here host has to clear the register
> > after reading it during non-fatal errors.
> >
> > Renamed
> > MSGU_HOST_SCRATCH_PAD_6 to MSGU_SCRATCH_PAD_RSVD_0
> > MSGU_HOST_SCRATCH_PAD_7 to MSGU_SCRATCH_PAD_RSVD_1
>
> Naming these registered "reserved" is very unfortunate since that
> generally means the they should not be touched at all...
+1
>
> In any case, this looks OK to me.
>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>
> >
> > Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> > Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> >  drivers/scsi/pm8001/pm80xx_hwi.c | 28 ++++++++++++++++++++++------
> >  drivers/scsi/pm8001/pm80xx_hwi.h |  9 +++++++--
> >  2 files changed, 29 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> > index bbf538fe15b3..9fcc332d685b 100644
> > --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> > +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> > @@ -1552,9 +1552,9 @@ pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha)
> >  {
> >       int ret = 0;
> >       u32 scratch_pad_rsvd0 = pm8001_cr32(pm8001_ha, 0,
> > -                                     MSGU_HOST_SCRATCH_PAD_6);
> > +                                         MSGU_SCRATCH_PAD_RSVD_0);
> >       u32 scratch_pad_rsvd1 = pm8001_cr32(pm8001_ha, 0,
> > -                                     MSGU_HOST_SCRATCH_PAD_7);
> > +                                         MSGU_SCRATCH_PAD_RSVD_1);
> >       u32 scratch_pad1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
> >       u32 scratch_pad2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
> >       u32 scratch_pad3 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
> > @@ -1663,9 +1663,9 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
> >                       PCI_VENDOR_ID_ATTO &&
> >                       pm8001_ha->pdev->subsystem_vendor != 0) {
> >                       ibutton0 = pm8001_cr32(pm8001_ha, 0,
> > -                                     MSGU_HOST_SCRATCH_PAD_6);
> > +                                            MSGU_SCRATCH_PAD_RSVD_0);
> >                       ibutton1 = pm8001_cr32(pm8001_ha, 0,
> > -                                     MSGU_HOST_SCRATCH_PAD_7);
> > +                                            MSGU_SCRATCH_PAD_RSVD_1);
> >                       if (!ibutton0 && !ibutton1) {
> >                               pm8001_dbg(pm8001_ha, FAIL,
> >                                          "iButton Feature is not Available!!!\n");
> > @@ -4138,9 +4138,9 @@ static void print_scratchpad_registers(struct pm8001_hba_info *pm8001_ha)
> >       pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_5: 0x%x\n",
> >                  pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_5));
> >       pm8001_dbg(pm8001_ha, FAIL, "MSGU_RSVD_SCRATCH_PAD_0: 0x%x\n",
> > -                pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_6));
> > +                pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_RSVD_0));
> >       pm8001_dbg(pm8001_ha, FAIL, "MSGU_RSVD_SCRATCH_PAD_1: 0x%x\n",
> > -                pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_7));
> > +                pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_RSVD_1));
> >  }
> >
> >  static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
> > @@ -4162,6 +4162,22 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
> >                       pm8001_handle_event(pm8001_ha, NULL, IO_FATAL_ERROR);
> >                       print_scratchpad_registers(pm8001_ha);
> >                       return ret;
> > +             } else {
> > +                     /*read scratchpad rsvd 0 register*/
> > +                     regval = pm8001_cr32(pm8001_ha, 0,
> > +                                          MSGU_SCRATCH_PAD_RSVD_0);
> > +                     switch (regval) {
> > +                     case NON_FATAL_SPBC_LBUS_ECC_ERR:
> > +                     case NON_FATAL_BDMA_ERR:
> > +                     case NON_FATAL_THERM_OVERTEMP_ERR:
> > +                             /*Clear the register*/
> > +                             pm8001_cw32(pm8001_ha, 0,
> > +                                         MSGU_SCRATCH_PAD_RSVD_0,
> > +                                         0x00000000);
> > +                             break;
> > +                     default:
> > +                             break;
> > +                     }
> >               }
> >       }
> >       circularQ = &pm8001_ha->outbnd_q_tbl[vec];
> > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> > index c7e5d93bea92..f0818540b2cd 100644
> > --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> > +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> > @@ -1366,8 +1366,8 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
> >  #define MSGU_HOST_SCRATCH_PAD_3                      0x60
> >  #define MSGU_HOST_SCRATCH_PAD_4                      0x64
> >  #define MSGU_HOST_SCRATCH_PAD_5                      0x68
> > -#define MSGU_HOST_SCRATCH_PAD_6                      0x6C
> > -#define MSGU_HOST_SCRATCH_PAD_7                      0x70
> > +#define MSGU_SCRATCH_PAD_RSVD_0                      0x6C
> > +#define MSGU_SCRATCH_PAD_RSVD_1                      0x70
> >
> >  #define MSGU_SCRATCHPAD1_RAAE_STATE_ERR(x) ((x & 0x3) == 0x2)
> >  #define MSGU_SCRATCHPAD1_ILA_STATE_ERR(x) (((x >> 2) & 0x3) == 0x2)
> > @@ -1435,6 +1435,11 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
> >  #define SCRATCH_PAD_ERROR_MASK               0xFFFFFC00 /* Error mask bits */
> >  #define SCRATCH_PAD_STATE_MASK               0x00000003 /* State Mask bits */
> >
> > +/*state definition for Scratchpad Rsvd 0, Offset 0x6C, Non-fatal*/
> > +#define NON_FATAL_SPBC_LBUS_ECC_ERR  0x70000001
> > +#define NON_FATAL_BDMA_ERR           0xE0000001
> > +#define NON_FATAL_THERM_OVERTEMP_ERR 0x80000001
> > +
> >  /* main configuration offset - byte offset */
> >  #define MAIN_SIGNATURE_OFFSET                0x00 /* DWORD 0x00 */
> >  #define MAIN_INTERFACE_REVISION              0x04 /* DWORD 0x01 */
>
>
> --
> Damien Le Moal
> Western Digital Research
