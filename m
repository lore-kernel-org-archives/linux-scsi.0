Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70036C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 306E722286
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503155AbgLNUeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503248AbgLNUdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 15:33:43 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03290C0613D6;
        Mon, 14 Dec 2020 12:33:01 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id b9so24471222ejy.0;
        Mon, 14 Dec 2020 12:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XGRbUsgrZUCddja/BqC2r/x11/O5f/TK7TN/AMbIvbY=;
        b=llIvmbDLbvM4qJ+0lVfbuG0zz2bRdzjLnxOmu1rJwjTbbatJq/1npwWlgepvHS5W7M
         RgEvyq4z2fTu+0pdYtVWlISqDRrOS7NiHQEu7eTzyVUBp7VSCDM4dBBixHpUls7ptBfp
         UIWOkBhs5Jjx47VkO/0N4tDsAGUrwKUgO8/GuW26IBvip0BokUr1GhRKKR6Xrnwd8M/1
         ghXSQym0zsSEuRISFCMgcB5QvahYfQP+3ggtKDjlTlegUnuiaHkYqsI8lSgB/w9VwAnX
         4gWcR0S9ZAPWFUEsw26rVXbNJM7XaBhU2fDb5qUtzvWa+ilvb7DiLnxOAnXRPO3bqhVE
         0XLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XGRbUsgrZUCddja/BqC2r/x11/O5f/TK7TN/AMbIvbY=;
        b=syniTbVMRvhL+2u1oH507DNuYUmnFj+RlPs3qtIAetenXlvR/+PIiQEepQnrrBuOAP
         eKXlAvcCQYZ7qy4ORzjVFl3zrGNIRG1F5txKcdoet86djwq3I1WEgrspTFAxzWQRaFrj
         8LuBzXc2ph348EQVU09Z5bPV/DjRUZvyP6bmZp62oD1zhyHTKkoQXwKzU8LOjoUfXUXc
         02oCeD6gnj1yCfvjQ6EaLmm1a58L98Aa96LtV1VHieryjcGLt14M0atiEsReuWF0yS6e
         xvsisLL7qG0ItWa+7MVsVW09KomwCoz5/bzeSjZ4574H7WDfHIKKj+MhZYaYomZbKpGD
         SBOA==
X-Gm-Message-State: AOAM533ZwTaGqmETKcx1kv3JAPbnt56jvjgWCQVEo3I6fQjKC1QYxosZ
        dY+ZQbhYyPV5Cti+gJTZdvQ=
X-Google-Smtp-Source: ABdhPJzfzL20bcd7uCQoX39BGGgmI/+CETD/bRgLdpMhgNaXSl0//iyJF23APVGECsCEWmyWh6Pofg==
X-Received: by 2002:a17:906:da08:: with SMTP id fi8mr23885831ejb.517.1607977979727;
        Mon, 14 Dec 2020 12:32:59 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id c11sm16850719edx.38.2020.12.14.12.32.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 12:32:59 -0800 (PST)
Message-ID: <53cf543b503900847ea776aa3edd24cc33252501.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Re-enable WriteBooster after device
 reset
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nguyenb@codeaurora.org, bjorn.andersson@linaro.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Date:   Mon, 14 Dec 2020 21:32:57 +0100
In-Reply-To: <1607476170.3580.29.camel@mtkswgap22>
References: <20201208135635.15326-1-stanley.chu@mediatek.com>
         <20201208135635.15326-2-stanley.chu@mediatek.com>
         <970af8b1abf565184bf37c3c055bf42ad760201a.camel@gmail.com>
         <1607476170.3580.29.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-12-09 at 09:09 +0800, Stanley Chu wrote:
> > >   
> > > -               if (!err)
> > > +               if (!err) {
> > >                          ufshcd_set_ufs_dev_active(hba);
> > > +                       if (ufshcd_is_wb_allowed(hba)) {
> > > +                               hba->wb_enabled = false;
> > > +                               hba->wb_buf_flush_enabled =
> > > false;
> > > +                       }
> > > +               }
> > 
> > Stanley,
> > how do you think group wb_buf_flush_enabled and wb_enabled to the
> > dev_info, since they are UFS device attributes. means they are set
> > only
> > when UFS device flags being set.
> 
> Hi Bean,
> 
> Thanks for your review.
> 
> Yes, I agreed that wb related variables is a mess currently. I would
> like to clean them up once I have time. Feel free to post your patch
> if
> you want to take it up : )
> 

Hi Stanley
I updated this change in my new "Several changes for UFS WriteBooster"
series patch, are you interested in reviewing that? to help Martin
easier pick up the changes.

Thanks,
Bean


