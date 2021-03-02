Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1263C4332B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8401D64F25
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581593AbhCBS7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839026AbhCBP4M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 10:56:12 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC17C0617A7;
        Tue,  2 Mar 2021 06:32:28 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id bd6so12198568edb.10;
        Tue, 02 Mar 2021 06:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Am1a6SP1lIBYmPhsqzqN/wdobE8TF1PX/9qBt9ePMdE=;
        b=qPtUCPCo1olJ3B9E9rwQl3QrypoiL2tKAnbCXopbsVVBvw6fdTNtawzozZGwFXz9iD
         nkNmfJBtOt0HAx1f5PQcv2NihpNJOlvlihR8p1m/IM3pVH569sQLwLPFCUCuUWsEfdCF
         O31nNIGaHoyyyg5I1+2lsMGm+JiELOeE5H2FW0FkcMn/ci+wwD+SVB8y2wFXldhx5HAe
         6tb/a0SLA1S3UHWpp9LA+X+j3o4gsoO5JrDE5aJMhXSeIO3esejgrc4NSgr1TSqbgTPV
         IWaZOXr1KGhthoVJwBftWZZxkJ0cX8Dr0SZ4gSDW026KtIUbeXWp01oTUl5uGkT7TA2A
         7eog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Am1a6SP1lIBYmPhsqzqN/wdobE8TF1PX/9qBt9ePMdE=;
        b=SjK/UYGf7Uib20J2c9Ca4Fsai9QJ0YFnajwFqcKpE104J6cRuOEal1IziaV+6IvSkv
         l0Ce2oaqVCXSPylJtnHE3ebxxlhgVr+/Z4wUifSeyuBKGEjwPOzW+pihMAHbQ/P59Mvp
         0IOHq4i28+gaegRRxpz2lUdMk3D4UD2HdNI28vuD2CAi8f8cq2Jxpbewp59sr5J4V6bN
         iH1tDBbOE8o/knkTtA4MuacQgVSlra/6lg3u4sjlZr76Jyr9OAfTtScjvYTghA86FPvb
         AzRXsKQBj/0JMIcpLe+ckcEWMvtW01G9ksy6Ru1ijH/o1tQ1i3bN3lq1Xuh9aggImLMJ
         5qUA==
X-Gm-Message-State: AOAM532K24Bz8eZyaevVr3tPMwsuU9wjNVMKwLJD+b28CqXMyLkAeoHk
        hzH00MURrEcjcovK7qOE62M=
X-Google-Smtp-Source: ABdhPJxTPYjmiTLFJ/xr+8hRvlCShkvbocmTzo0rrgQEVYCzRgTmO4kwRNJxOTG7nk/s8afYethq0w==
X-Received: by 2002:a50:a086:: with SMTP id 6mr20503152edo.70.1614695547654;
        Tue, 02 Mar 2021 06:32:27 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id s13sm17250242edr.86.2021.03.02.06.32.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Mar 2021 06:32:27 -0800 (PST)
Message-ID: <1988de01138118e8361b90acce25332adb2c1e24.camel@gmail.com>
Subject: Re: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Tue, 02 Mar 2021 15:32:25 +0100
In-Reply-To: <DM6PR04MB6575372560ACA643845C891CFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
         <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p5>
         <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
         <fb70bf48fab65474bf2f15a436852ccf9a3db026.camel@gmail.com>
         <DM6PR04MB6575372560ACA643845C891CFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-03-02 at 13:15 +0000, Avri Altman wrote:
> > 
> > On Fri, 2021-02-26 at 16:35 +0900, Daejun Park wrote:
> > > +static void ufshpb_set_unmap_cmd(unsigned char *cdb, struct
> > > ufshpb_region *rgn)
> > > +{
> > > +       cdb[0] = UFSHPB_WRITE_BUFFER;
> > > +       cdb[1] = rgn ? UFSHPB_WRITE_BUFFER_INACT_SINGLE_ID :
> > > +                         UFSHPB_WRITE_BUFFER_INACT_ALL_ID;
> > 
> > Here is wrong,
> > Valid HPB Region is (0 ~ (Ceiling( Region size calculated by
> > bHPBRegionSize )- 1) ). how do you know the region==0 is not
> > a single normal region?
> 
> Please note that rgn  here is a ufshpb_region *rgn
> 
I see, thanks. 

> Thanks,
> Avri

