Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDABC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 09:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0397E61A04
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 09:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhCXJeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 05:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbhCXJdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 05:33:45 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC9DC061763;
        Wed, 24 Mar 2021 02:33:44 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kt15so22228103ejb.12;
        Wed, 24 Mar 2021 02:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=v/E6C3caqS+yX4Js+LYDHx8WD7YNLpPp6fRlzI3Vgko=;
        b=upafuQETnBvUKULUt+6GYBhUaI81T0JW6NhcqQ/uzvmDR+lkAV7G69lHAxMRzRUJs8
         u+Z/frl09a1k+xyPVMB5Stc7j8wPsGWUFadWhoyjZ8/ap4Yp8VutLe9Evty15tfiTcOP
         6SUMW7WalvUtLAhwUZUepIF51l3gZviav5uadpbgUusQc3rYfp1UdG5BJNhKGHifB3ju
         FnISvO4PkshDtGUCQEUfwJXr3MCjP/GKLZKJhh/pT3yXvLXiXAmt0SQxlas2MBUqY1t0
         CmEqeOTx3io8J5OWcjF/irRFiVGfIKlggTgwTomKMCi+qh67SlLPoB46TH9jyvUbCkRq
         LH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=v/E6C3caqS+yX4Js+LYDHx8WD7YNLpPp6fRlzI3Vgko=;
        b=YsnCNdRKqdmv3luJNwHbn3YZx3FXwQGJqMfduAJkHyDremA/3lVs1IoEekiKYoezfg
         FNhSkBAVYLEda8wWWFOu2fH991hpi+d8449FLu2/rw0RW8lLrAp13MOZFVdNNy9y3E+T
         i3H1Sh8JvE7Nyz3OQgQBzaJ064X2DrEMS6EfGvKmnQ04/4U32Sl/FC6CjCHEnnfaHsgG
         W9F+k+Z0rQ0aAn/Ov7y22emR1C4gA1+uTxB60iM8ZzP+zQQolKKLNVakAwSpm3rcR41X
         E98tFGyr/Y/nMI+Pjy6FQpX3mp4v856Fg4SMneGtlhXKe4EYEz/VPaOpDds79m46bX0J
         ItRQ==
X-Gm-Message-State: AOAM533CRBna/nNhwUJTKtdszdzkcNyiFNY9A13rn9Vudf6mwm30rR5g
        LbHsZSWxtp4i9ZyTHxaerwk=
X-Google-Smtp-Source: ABdhPJze6qgcqjQPc163Aq6L/CCebTUxC1VKmnogwCCFgqDFe0BDJjfU5C8cVCMGA5ALt03mLpmOLw==
X-Received: by 2002:a17:906:6bd1:: with SMTP id t17mr2657325ejs.319.1616578423366;
        Wed, 24 Mar 2021 02:33:43 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id kj3sm635319ejc.117.2021.03.24.02.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 02:33:42 -0700 (PDT)
Message-ID: <7bfcc7d6cedd1d674172722f8cc074dac9c2a640.camel@gmail.com>
Subject: Re: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     Avri Altman <Avri.Altman@wdc.com>, daejun7.park@samsung.com,
        Greg KH <gregkh@linuxfoundation.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Date:   Wed, 24 Mar 2021 10:33:40 +0100
In-Reply-To: <5f68a41406b157f4ed4b3765e1d8e032@codeaurora.org>
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
         <020853d32271f0a16b26a343a72fd930e9505ffe.camel@gmail.com>
         <5f68a41406b157f4ed4b3765e1d8e032@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-03-24 at 17:24 +0800, Can Guo wrote:
> On 2021-03-24 16:37, Bean Huo wrote:
> > On Wed, 2021-03-24 at 09:45 +0800, Can Guo wrote:
> > > On 2021-03-23 20:48, Avri Altman wrote:
> > > 
> > > > > On 2021-03-23 14:37, Daejun Park wrote:
> > > > > > > On 2021-03-23 14:19, Daejun Park wrote:
> > > > > > > > > On 2021-03-23 13:37, Daejun Park wrote:
> > > > > > > > > > > On 2021-03-23 12:22, Can Guo wrote:
> > > > > > > > > > > > On 2021-03-22 17:11, Bean Huo wrote:
> > > > > > > > > > > > > On Mon, 2021-03-22 at 15:54 +0900, Daejun
> > > > > > > > > > > > > Park
> > > > > > > > > > > > > wrote:
> > > > > > > > > > > > > > +       switch (rsp_field->hpb_op) {
> > > > > > > > > > > > > > +       case HPB_RSP_REQ_REGION_UPDATE:
> > > > > > > > > > > > > > +               if (data_seg_len !=
> > > > > > > > > > > > > > DEV_DATA_SEG_LEN)
> > > > > > > > > > > > > > +                       dev_warn(&hpb-
> > > > > > > > > > > > > > > sdev_ufs_lu->sdev_dev,
> > > > > > > > > > > > > > +                                "%s: data
> > > > > > > > > > > > > > seg
> > > > > > > > > > > > > > length is not
> > > > > > > > > > > > > > same.\n",
> > > > > > > > > > > > > > +                                __func__);
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > ufshpb_rsp_req_region_update(hpb,
> > > > > > > > > > > > > > rsp_field);
> > > > > > > > > > > > > > +               break;
> > > > > > > > > > > > > > +       case HPB_RSP_DEV_RESET:
> > > > > > > > > > > > > > +               dev_warn(&hpb->sdev_ufs_lu-
> > > > > > > > > > > > > > > sdev_dev,
> > > > > > > > > > > > > > +                        "UFS device lost
> > > > > > > > > > > > > > HPB
> > > > > > > > > > > > > > information
> > > > > > > > > > > > > > during
> > > > > > > > > > > > > > PM.\n");
> > > > > > > > > > > > > > +               break;
> > > > > > > > > > > > > Hi Deajun,
> > > > > > > > > > > > > This series looks good to me. Just here I
> > > > > > > > > > > > > have
> > > > > > > > > > > > > one question. You
> > > > > > > > > > > > > didn't
> > > > > > > > > > > > > handle HPB_RSP_DEV_RESET, just a
> > > > > > > > > > > > > warning.  Based
> > > > > > > > > > > > > on your SS UFS,
> > > > > > > > > > > > > how
> > > > > > > > > > > > > to
> > > > > > > > > > > > > handle HPB_RSP_DEV_RESET from the host side?
> > > > > > > > > > > > > Do
> > > > > > > > > > > > > you think we
> > > > > > > > > > > > > shoud
> > > > > > > > > > > > > reset host side HPB entry as well or what
> > > > > > > > > > > > > else?
> > > > > > > > > > > > > Bean
> > > > > > > > > > > > Same question here - I am still collecting
> > > > > > > > > > > > feedbacks from flash
> > > > > > > > > > > > vendors
> > > > > > > > > > > > about
> > > > > > > > > > > > what is recommanded host behavior on reception
> > > > > > > > > > > > of
> > > > > > > > > > > > HPB Op code
> > > > > > > > > > > > 0x2,
> > > > > > > > > > > > since it
> > > > > > > > > > > > is not cleared defined in HPB2.0 specs.
> > > > > > > > > > > > Can Guo.
> > > > > > > > > > > I think the question should be asked in the
> > > > > > > > > > > HPB2.0
> > > > > > > > > > > patch, since in
> > > > > > > > > > > HPB1.0 device
> > > > > > > > > > > control mode, a HPB reset in device side does not
> > > > > > > > > > > impact anything
> > > > > > > > > > > in
> > > > > > > > > > > host side -
> > > > > > > > > > > host is not writing back any HPB entries to
> > > > > > > > > > > device
> > > > > > > > > > > anyways and HPB
> > > > > > > > > > > Read
> > > > > > > > > > > cmd with
> > > > > > > > > > > invalid HPB entries shall be treated as normal
> > > > > > > > > > > Read(10) cmd
> > > > > > > > > > > without
> > > > > > > > > > > any
> > > > > > > > > > > problems.
> > > > > > > > > > Yes, UFS device will process read command even the
> > > > > > > > > > HPB
> > > > > > > > > > entries are
> > > > > > > > > > valid or
> > > > > > > > > > not. So it is warning about read performance drop
> > > > > > > > > > by
> > > > > > > > > > dev reset.
> > > > > > > > > Yeah, but still I am 100% sure about what should host
> > > > > > > > > do
> > > > > > > > > in case of
> > > > > > > > > HPB2.0
> > > > > > > > > when it receives HPB Op code 0x2, I am waiting for
> > > > > > > > > feedbacks.
> > > > > > > > I think the host has two choices when it receives 0x2.
> > > > > > > > One is nothing on host.
> > > > > > > > The other is discarding all HPB entries in the host.
> > > > > > > > In the JEDEC HPB spec, it as follows:
> > > > > > > > When the device is powered off by the host, the device
> > > > > > > > may
> > > > > > > > restore
> > > > > > > > L2P
> > > > > > > > map
> > > > > > > > data upon power up or build from the host’s HPB READ
> > > > > > > > command.
> > > > > > > > If some UFS builds L2P map data from the host's HPB
> > > > > > > > READ
> > > > > > > > commands, we
> > > > > > > > don't
> > > > > > > > have to discard HPB entries in the host.
> > > > > > > > So I thinks there is nothing to do when it receives
> > > > > > > > 0x2.
> > > > > > > But in HPB2.0, if we do nothing to active regions in host
> > > > > > > side, host
> > > > > > > can
> > > > > > > write
> > > > > > > HPB entries (which host thinks valid, but actually
> > > > > > > invalid in
> > > > > > > device
> > > > > > > side since
> > > > > > > reset happened) back to device through HPB Write Buffer
> > > > > > > cmds
> > > > > > > (BUFFER
> > > > > > > ID
> > > > > > > = 0x2).
> > > > > > > My question is that are all UFSs OK with this?
> > > > > > Yes, it must be OK.
> > > > > > Please refer the following the HPB 2.0 spec:
> > > > > > If the HPB Entries sent by HPB WRITE BUFFER are removed by
> > > > > > the
> > > > > > device,
> > > > > > for example, because they are not consumed for a long
> > > > > > enough
> > > > > > period of
> > > > > > time,
> > > > > > then the HPB READ command for the removed HPB entries shall
> > > > > > be
> > > > > > handled
> > > > > > as a
> > > > > > normal READ command.
> > > > > No, it is talking about the subsequent HPB READ cmd sent
> > > > > after a
> > > > > HPB
> > > > > WRITE BUFFER cmd,
> > > > > but not the HPB WRITE BUFFER cmd itself...
> > > > Looks like this discussion is going the same way as we had in
> > > > host
> > > > mode.
> > > > HPB-WRITE-BUFFER 0x2, if exist,  is always a companion to HPB-
> > > > READ.
> > > > You shouldn't consider them separately.
> > > > The device is expected to handle invalid ppn by itself, and
> > > > specifically for this case,
> > > > As Daejun explained, Handle each HPB-READ (and its companion
> > > > HPB-WRITE-BUFFER) like READ10.
> > > > For device mode, doing nothing in case of dev reset, seems to
> > > > me
> > > > like
> > > > the right thing to do.
> > > 
> > > I just got some feedbacks from other flash vendors, they all
> > > commit
> > > that
> > > 
> > > their devices can work well in this scenario [1]. Some of them
> > > proposed
> > > 
> > > even complicated (maybe better) principles of handling the "HPB
> > > reset",
> > > 
> > > but since the device works well in [1], I am OK with current
> > > (simpler)
> > > 
> > > handling of "HPB reset" - in device mode doing nothing, in host
> > > mode
> > > 
> > > re-activate regions that host is trying to do a read to.
> > > 
> > > 
> > > 
> > 
> > Our suggestion on this indication 0x2:
> > 
> > 1. If current mode is device control mode, we suggest host just
> > deactivate all active regions and don't send HPB READ BUFFER
> > command to
> > device unless device indicate host to activate certain region in
> > later
> > response. In another way, it is a signal telling host to reset host
> > side L2P entry and to rebuild the L2P mapping entry in host memroy.
> > 
> > 2. If current mode is host control mode, we suggest host send HPB
> > READ
> > BUFFER command before it wants to send read command on this region,
> > rather than sending HPB READ BUFFER commands on all regions at the
> > same
> > time.
> > 
> > 
> > Bean
> 
> Hi Bean,
> 
> I got this proposal from your side too, after that I've checked with
> Leon Ge from your side and he confirmed that it is fine that host
> just
> ignores the "HPB reset" indication. We can leave it as it is as of
> now
> and revisit it if any UFS needs extra care. What do you say?
> 
> Thanks,
> Can Guo.

Hi Can,

Agree. Current handling is ok to us, but if we want to change it, we
hope it is the same with the above suggestion. We can keep current
implementation, seeing if need changes in the near future based on the
feedback or new updates in the Spec.

Thanks,
Bean



> 
> > > Thanks,
> > > 
> > > Can Guo.

