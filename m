Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5821C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 12:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 915C264FC8
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 12:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhBEMia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 07:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhBEMgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 07:36:08 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E38C061794;
        Fri,  5 Feb 2021 04:35:18 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id y9so11653112ejp.10;
        Fri, 05 Feb 2021 04:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AT0z2+krtagF9TnHeGWlw7h1FxBZRAw3QiEktEHlnNw=;
        b=Jk9mvWt4iT+vlWdSI+yLyj6+Ye8L3lul0SPLiF0RhYlB4XV6J9kWWbMzJdJ9MzCXVF
         f6WCZLIh+zVQfLvKE5SFgl4U4lyqWI+WmVj64UjAs7OchIEMCyC/KCJ6TbvNvfTU90kE
         pOK4e+WoJcv07Hml6+s7CTl0TX3Ch/ZnEj149Bc7HY+vyKG5/WrJoKyXi9dWplsqJ8s2
         nZHeaJN8bEnymInlRuy/q/9kk8jov7WK4i1YSQm1/mehKJWSyOkmbBcK6g9wrkIFuZfl
         YfLweTIhgAO2RdWK1McCZDrLFZgiWA0KYVWjsWPrg+VKuOv1sVAhaxCJwOob4BVj7zqv
         AwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AT0z2+krtagF9TnHeGWlw7h1FxBZRAw3QiEktEHlnNw=;
        b=XJlXAG2SDOTOuSHkKyGVFuEe5PeNkdyGlX/2/NPO4p1LLUB79A2UKmhrisMBmbUp8w
         FI83VTF20SdjCeIWdBO9QN02UiC2kICsB8Z+m8y0dkL1mg/XkkSB5JPzigx9xwAP35D+
         xmzGyMAj1wczr0kMtjxCl8e2iaMizPbqGViFWhaKbchVgwT1Pkvsk3VA/39vemBzj05I
         0m/wLQlPpq81HxobelQvGB+TdSlbLLRwa29Lp/bB8miL/mwBQMHp/J1nhocFTFvCtuf0
         uwREO/0puJlfyzlwtFCbd17zMQizKt51uLzvqj8OPDlh0Ft2mdTT7/dTI2N72zdYzgFQ
         wbVQ==
X-Gm-Message-State: AOAM533ZihxQsGXMBm5AWBJ/QHOOMVn+527Gh7nNvTbj2plOqlWP1NIO
        xFKGmG2rTFw/1SZjVGE6AlA=
X-Google-Smtp-Source: ABdhPJzlBMhP/pbPIFtQfhc+wcXoLvUszfFvT+56V+qRq5QrCOcOncp/bTQGjCbiW6HtKt0i6sP7qA==
X-Received: by 2002:a17:906:3e96:: with SMTP id a22mr3859367ejj.144.1612528515950;
        Fri, 05 Feb 2021 04:35:15 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id c27sm752270eja.104.2021.02.05.04.35.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Feb 2021 04:35:15 -0800 (PST)
Message-ID: <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
Subject: Re: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached
 sub-region
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Fri, 05 Feb 2021 13:35:13 +0100
In-Reply-To: <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
         <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
         <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-05 at 11:29 +0800, Can Guo wrote:
> > +     *rgn_idx = lpn >> hpb->entries_per_rgn_shift;
> > +     rgn_offset = lpn & hpb->entries_per_rgn_mask;
> > +     *srgn_idx = rgn_offset >> hpb->entries_per_srgn_shift;
> > +     *offset = rgn_offset & hpb->entries_per_srgn_mask;
> > +}
> > +
> > +static void
> > +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct
> > ufshcd_lrb 
> > *lrbp,
> > +                               u32 lpn, u64 ppn,  unsigned int
> > transfer_len)
> > +{
> > +     unsigned char *cdb = lrbp->cmd->cmnd;
> > +
> > +     cdb[0] = UFSHPB_READ;
> > +
> > +     put_unaligned_be64(ppn, &cdb[6]);
> 
> You are assuming the HPB entries read out by "HPB Read Buffer" cmd
> are 
> in Little
> Endian, which is why you are using put_unaligned_be64 here. However, 
> this assumption
> is not right for all the other flash vendors - HPB entries read out
> by 
> "HPB Read Buffer"
> cmd may come in Big Endian, if so, their random read performance are 
> screwed.

For this question, it is very hard to make a correct format since the
Spec doesn't give a clear definition. Should we have a default format,
if there is conflict, and then add quirk or add a vendor-specific
table?

Hi Avri
Do you have a good idea?

Bean

