Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A622C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE2E121531
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="thh63VHs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgFQI5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFQI5z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 04:57:55 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7A4C061573;
        Wed, 17 Jun 2020 01:57:55 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id j13so937068vsn.3;
        Wed, 17 Jun 2020 01:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e0GIsBatfapINbf1Qhrb6ieuf0yzr/q+/Cwq8LRbwso=;
        b=thh63VHsT+2xCdrOTfL871hB51pmQB0rlLEQYQ/D2M6BBadj7jBAS2z65tXfYR4Tr1
         wR7WeY24w9GxeO8dDxW8QmOUriK9jg6VA0m8OBsgFs2UT6IBWmPeK/H0qpKmzsbFkDhB
         +tS4KpohwMSQwCTUu8n1kBn0vnepV71BshhNwvVODL5DpczpxvnnqoLD4N3VYYSt0dCz
         ic78H2v3vDFdJ9rfVcCn+zBFlemn0htT7oBz8BnkILsQEEsL9RA0RFNevonUcoEbn0Ke
         i2OYagDGxBBInJ95+Za7ZZrUTzF0s7j3gFL+Gn+9RKr6boXRrNPz8fFWqNeh4sFBiz0+
         yBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e0GIsBatfapINbf1Qhrb6ieuf0yzr/q+/Cwq8LRbwso=;
        b=CIKDpvUFsFAqowGk4ZEpoQkT9nUCfuVUb8EELLkCNX+s4uDdZFfPuZKDIkewyFnF9z
         ApHTmfjbwOiasbWCRrAo5vWdwxPVys64Yc0unlbt9gaUafc5GIxkZGHp785DDtOSexU8
         YZJshu+d+AAy+StbR3VC5QwfiCFxFuMsI/5oqaSJb2Y2tRz9xNlbTajY6BzGFxQFQItm
         S7oqN+c5yn0SzZo2bTgDPn+tfCnCy6eDv+loRrxsPBSKaQKPxkvL4ODE1tFDRCnMBiG4
         cb09Mcll3uCREB6FAKQ3JLwMFvNCJWBkc5DKKdwysukafEAqlIY52DOyB3XTq50c62GY
         y7Lg==
X-Gm-Message-State: AOAM53230nHzdLjSXwa5+wpZunHcsMVBHM5bl0znepG36HNQwRwF0K4q
        mhmyzctaekcRWhtCfU9ggCxJLAfP02HS45Fsj3c=
X-Google-Smtp-Source: ABdhPJwFD40J/rabMT3XsR4v1Ox0g6ANGlzSspKwGjvnIWrfQ3tNbNLN5wNI3QvElV6zbvR8Nowyhk34KTrB0KLEmqI=
X-Received: by 2002:a67:a64c:: with SMTP id r12mr4847402vsh.127.1592384274215;
 Wed, 17 Jun 2020 01:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <47dcc56312229fc8f25f39c2beeb3a8ba811f3e9.camel@gmail.com>
 <336371513.41592205783606.JavaMail.epsvc@epcpadp2> <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
 <231786897.01592212081335.JavaMail.epsvc@epcpadp2> <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p6>
 <1210830415.21592275802431.JavaMail.epsvc@epcpadp1> <SN6PR04MB4640EE125CF504AF9362B23FFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB4640EE125CF504AF9362B23FFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 17 Jun 2020 14:27:19 +0530
Message-ID: <CAGOxZ50TUnvmmdspxr6dHWrpoxZqHtvR-1Wg6jAVH6k-w5LT2w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Bean Huo <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2020 at 12:27 PM Avri Altman <Avri.Altman@wdc.com> wrote:
>
> >
> > Hi, Bean
> > >
> > > On Mon, 2020-06-15 at 16:23 +0900, Daejun Park wrote:
> > > > +void ufsf_scan_features(struct ufs_hba *hba)
> > > > +{
> > > > +       int ret;
> > > > +
> > > > +       init_waitqueue_head(&hba->ufsf.sdev_wait);
> > > > +       atomic_set(&hba->ufsf.slave_conf_cnt, 0);
> > > > +
> > > > +       if (hba->dev_info.wspecversion >= HPB_SUPPORTED_VERSION &&
> > > > +           (hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT))
> > >
> > > How about removing this check "(hba->dev_info.wspecversion >=
> > > HPB_SUPPORTED_VERSION" since ufs with lower version than v3.1 can add
> > > HPB feature by FFU,
> > > if (hba->dev_info.b_ufs_feature_sup  &UFS_FEATURE_SUPPORT_HPB_BIT) is
> > > enough.
> > OK, changing it seems no problem. But I want to know what other people
> > think
> > about this version checking code.
> HPB1.0 isn't part of ufs3.1, but published only later.
> Allowing earlier versions will required to quirk the descriptor sizes.
> I see Bean's point here, but I vote for adding it in a single quirk, when the time comes.
>
I second Avri here, older devices need a quirk to handle, let do that
as a separate patch.
> Thanks,
> Avri



-- 
Regards,
Alim
