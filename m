Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775A1C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 08:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45982619F3
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 08:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhCXIhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 04:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbhCXIhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 04:37:35 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35B1C061763;
        Wed, 24 Mar 2021 01:37:32 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j3so26600115edp.11;
        Wed, 24 Mar 2021 01:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=+Yn/c99sha9x0AR3OIjw5HVrcH840u6NK0md/eavcQo=;
        b=pJ9mG3Flb1NO0F5TeSMY80pqrvLEZfH4Ub2EREgVDTyXH/yVFG9mP6E4Q/uVECjmFE
         T039oYVcMzegtgqh93K/wi/Z06XouaP3MmHQkkHAOZC+zDGRIDjBeDvW99jQYwmp2s2P
         in5firugNCOVad8ADTBHFrAxTog1y68ykowDLE8WkcmQaO5C6rovzmNJdDf+d7aF3t96
         JVfxIagbHl1SLVnLcfV1Cy2Kd2al2UfbyPP0y1tA1IepaRaJbwBbf/NImgwYPR/VJGJa
         Nj5NmfnAFuL9J+nto61Gz0R2I986/IqK+sI8lUA85ZQJNPqyR1g3rb6QOuM83HGSzlDP
         SPhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+Yn/c99sha9x0AR3OIjw5HVrcH840u6NK0md/eavcQo=;
        b=a6fYgkwjc1vhQEwUsCmLz5J12Qnb7q/4uz+mfq5+K32vEgzyxbIPeBHeZzZvL39FUQ
         of/TI5W455/+AljCbxUxIy4u7g2IE8iz1D4A/oBMH3SrdmmOLjgcIC671NZ2RaFhvMME
         oymphWIPXPSIurV28g1e7SK3wZQXdJi1Fsb7A/N/EP8G7RVcNMFFK4BU8BtS8vphd0iZ
         rz07rLikUxRxgSk6Qs03doTvu3e2a+4fFz2E/olGVSFjlCSC1d4CJtEqGLPgHAB/5iD+
         +7LVpnryRKKprQALXTTSRcbiRl6a4vsz3OEPqUPYHoA8uSE/iVbdCV0QPZ3/hPpFIR0l
         3X/g==
X-Gm-Message-State: AOAM531T0CkfN8BRMETudJN/46RK+ARUZkzzI1ttk4pK2tjxYx30zQWy
        qIlR8OilLylhCz/K4vjk5hI=
X-Google-Smtp-Source: ABdhPJygKn2Tvv5CfZzso39knrIOT3QjAjiI9KIVTItvqnG914kvy4TlEY6NGFNPZCxK1+A1VaKgKg==
X-Received: by 2002:aa7:cf16:: with SMTP id a22mr2145731edy.288.1616575051601;
        Wed, 24 Mar 2021 01:37:31 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id s18sm785972edc.21.2021.03.24.01.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 01:37:31 -0700 (PDT)
Message-ID: <020853d32271f0a16b26a343a72fd930e9505ffe.camel@gmail.com>
Subject: Re: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, Avri Altman <Avri.Altman@wdc.com>
Cc:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Date:   Wed, 24 Mar 2021 09:37:29 +0100
In-Reply-To: <dfb68d3632340c2ddffa487c69723aa3@codeaurora.org>
References: <f224bea78cf235ee94823528f07e28a6@codeaurora.org>
         <1df7bb51dc481c3141cdcf85105d3a5b@codeaurora.org>
         <e9b912bca9fd48c9b2fd76bea80439ae@codeaurora.org>
         <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
         <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
         <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
         <d6a032261a642a4afed80188ea4772ee@codeaurora.org>
         <20210323053731epcms2p70788f357b546e9ca21248175a8884554@epcms2p7>
         <20210323061922epcms2p739666492ebb458d70deab026d074caf4@epcms2p7>
         <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p2>
         <20210323063726epcms2p28aadb16bb96943ade1d2b288bb634811@epcms2p2>
         <a9017bbb57618c5560b21c1cdadb4f80@codeaurora.org>
         <DM6PR04MB657535F2F25BB41CAD191DB6FC649@DM6PR04MB6575.namprd04.prod.outlook.com>
         <dfb68d3632340c2ddffa487c69723aa3@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-03-24 at 09:45 +0800, Can Guo wrote:
> On 2021-03-23 20:48, Avri Altman wrote:
> 
> > > On 2021-03-23 14:37, Daejun Park wrote:
> > > > > On 2021-03-23 14:19, Daejun Park wrote:
> > > > > > > On 2021-03-23 13:37, Daejun Park wrote:
> > > > > > > > > On 2021-03-23 12:22, Can Guo wrote:
> > > > > > > > > > On 2021-03-22 17:11, Bean Huo wrote:
> > > > > > > > > > > On Mon, 2021-03-22 at 15:54 +0900, Daejun Park
> > > > > > > > > > > wrote:
> > > > > > > > > > > > +       switch (rsp_field->hpb_op) {
> > > > > > > > > > > > +       case HPB_RSP_REQ_REGION_UPDATE:
> > > > > > > > > > > > +               if (data_seg_len !=
> > > > > > > > > > > > DEV_DATA_SEG_LEN)
> > > > > > > > > > > > +                       dev_warn(&hpb-
> > > > > > > > > > > > >sdev_ufs_lu->sdev_dev,
> > > > > > > > > > > > +                                "%s: data seg
> > > > > > > > > > > > length is not
> > > > > > > > > > > > same.\n",
> > > > > > > > > > > > +                                __func__);
> > > > > > > > > > > > +              
> > > > > > > > > > > > ufshpb_rsp_req_region_update(hpb, rsp_field);
> > > > > > > > > > > > +               break;
> > > > > > > > > > > > +       case HPB_RSP_DEV_RESET:
> > > > > > > > > > > > +               dev_warn(&hpb->sdev_ufs_lu-
> > > > > > > > > > > > >sdev_dev,
> > > > > > > > > > > > +                        "UFS device lost HPB
> > > > > > > > > > > > information
> > > > > > > > > > > > during
> > > > > > > > > > > > PM.\n");
> > > > > > > > > > > > +               break;
> > > > > > > > > > > Hi Deajun,
> > > > > > > > > > > This series looks good to me. Just here I have
> > > > > > > > > > > one question. You
> > > > > > > > > > > didn't
> > > > > > > > > > > handle HPB_RSP_DEV_RESET, just a warning.  Based
> > > > > > > > > > > on your SS UFS,
> > > > > > > > > > > how
> > > > > > > > > > > to
> > > > > > > > > > > handle HPB_RSP_DEV_RESET from the host side? Do
> > > > > > > > > > > you think we
> > > > > > > > > > > shoud
> > > > > > > > > > > reset host side HPB entry as well or what else?
> > > > > > > > > > > Bean
> > > > > > > > > > Same question here - I am still collecting
> > > > > > > > > > feedbacks from flash
> > > > > > > > > > vendors
> > > > > > > > > > about
> > > > > > > > > > what is recommanded host behavior on reception of
> > > > > > > > > > HPB Op code
> > > > > > > > > > 0x2,
> > > > > > > > > > since it
> > > > > > > > > > is not cleared defined in HPB2.0 specs.
> > > > > > > > > > Can Guo.
> > > > > > > > > I think the question should be asked in the HPB2.0
> > > > > > > > > patch, since in
> > > > > > > > > HPB1.0 device
> > > > > > > > > control mode, a HPB reset in device side does not
> > > > > > > > > impact anything
> > > > > > > > > in
> > > > > > > > > host side -
> > > > > > > > > host is not writing back any HPB entries to device
> > > > > > > > > anyways and HPB
> > > > > > > > > Read
> > > > > > > > > cmd with
> > > > > > > > > invalid HPB entries shall be treated as normal
> > > > > > > > > Read(10) cmd
> > > > > > > > > without
> > > > > > > > > any
> > > > > > > > > problems.
> > > > > > > > Yes, UFS device will process read command even the HPB
> > > > > > > > entries are
> > > > > > > > valid or
> > > > > > > > not. So it is warning about read performance drop by
> > > > > > > > dev reset.
> > > > > > > Yeah, but still I am 100% sure about what should host do
> > > > > > > in case of
> > > > > > > HPB2.0
> > > > > > > when it receives HPB Op code 0x2, I am waiting for
> > > > > > > feedbacks.
> > > > > > I think the host has two choices when it receives 0x2.
> > > > > > One is nothing on host.
> > > > > > The other is discarding all HPB entries in the host.
> > > > > > In the JEDEC HPB spec, it as follows:
> > > > > > When the device is powered off by the host, the device may
> > > > > > restore
> > > > > > L2P
> > > > > > map
> > > > > > data upon power up or build from the host’s HPB READ
> > > > > > command.
> > > > > > If some UFS builds L2P map data from the host's HPB READ
> > > > > > commands, we
> > > > > > don't
> > > > > > have to discard HPB entries in the host.
> > > > > > So I thinks there is nothing to do when it receives 0x2.
> > > > > But in HPB2.0, if we do nothing to active regions in host
> > > > > side, host
> > > > > can
> > > > > write
> > > > > HPB entries (which host thinks valid, but actually invalid in
> > > > > device
> > > > > side since
> > > > > reset happened) back to device through HPB Write Buffer cmds
> > > > > (BUFFER
> > > > > ID
> > > > > = 0x2).
> > > > > My question is that are all UFSs OK with this?
> > > > Yes, it must be OK.
> > > > Please refer the following the HPB 2.0 spec:
> > > > If the HPB Entries sent by HPB WRITE BUFFER are removed by the
> > > > device,
> > > > for example, because they are not consumed for a long enough
> > > > period of
> > > > time,
> > > > then the HPB READ command for the removed HPB entries shall be
> > > > handled
> > > > as a
> > > > normal READ command.
> > > No, it is talking about the subsequent HPB READ cmd sent after a
> > > HPB
> > > WRITE BUFFER cmd,
> > > but not the HPB WRITE BUFFER cmd itself...
> > Looks like this discussion is going the same way as we had in host 
> > mode.
> > HPB-WRITE-BUFFER 0x2, if exist,  is always a companion to HPB-READ.
> > You shouldn't consider them separately.
> > The device is expected to handle invalid ppn by itself, and
> > specifically for this case,
> > As Daejun explained, Handle each HPB-READ (and its companion
> > HPB-WRITE-BUFFER) like READ10.
> > For device mode, doing nothing in case of dev reset, seems to me
> > like
> > the right thing to do.
> 
> 
> I just got some feedbacks from other flash vendors, they all commit
> that
> 
> their devices can work well in this scenario [1]. Some of them
> proposed
> 
> even complicated (maybe better) principles of handling the "HPB
> reset",
> 
> but since the device works well in [1], I am OK with current
> (simpler)
> 
> handling of "HPB reset" - in device mode doing nothing, in host mode
> 
> re-activate regions that host is trying to do a read to.
> 
> 
> 

Our suggestion on this indication 0x2:

1. If current mode is device control mode, we suggest host just
deactivate all active regions and don't send HPB READ BUFFER command to
device unless device indicate host to activate certain region in later
response. In another way, it is a signal telling host to reset host
side L2P entry and to rebuild the L2P mapping entry in host memroy.

2. If current mode is host control mode, we suggest host send HPB READ
BUFFER command before it wants to send read command on this region,
rather than sending HPB READ BUFFER commands on all regions at the same
time.


Bean

> Thanks,
> 
> Can Guo.

