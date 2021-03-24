Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10589C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 09:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADBD961A06
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 09:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhCXJYy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 05:24:54 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21946 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhCXJYo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 05:24:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616577884; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=m1c5Rru0a8Bcnr+8jqD2JJW3Y+LAJ2fQ/LbGi4Ynt6o=;
 b=eYMUXHqVOEKGRPxatJNRDigIKmJI3KgxQWHIHvwPHRaacmHIV95FGGLWX05BTtK/LTMgx++N
 PZk5lbkVbCp9sh8MaHYgMc5KXH8Jg0MashlaoWGLCp8tZpKJXvbvVUXzwVtAov+IrbfyMghk
 es/Ax9p0x4RxDLNXp05i2goWBuQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 605b0546e2200c0a0d344dca (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 24 Mar 2021 09:24:22
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id ACE55C433C6; Wed, 24 Mar 2021 09:24:22 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7E1EC433CA;
        Wed, 24 Mar 2021 09:24:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 24 Mar 2021 17:24:20 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
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
Subject: Re: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
In-Reply-To: <020853d32271f0a16b26a343a72fd930e9505ffe.camel@gmail.com>
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
Message-ID: <5f68a41406b157f4ed4b3765e1d8e032@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-24 16:37, Bean Huo wrote:
> On Wed, 2021-03-24 at 09:45 +0800, Can Guo wrote:
>> On 2021-03-23 20:48, Avri Altman wrote:
>> 
>> > > On 2021-03-23 14:37, Daejun Park wrote:
>> > > > > On 2021-03-23 14:19, Daejun Park wrote:
>> > > > > > > On 2021-03-23 13:37, Daejun Park wrote:
>> > > > > > > > > On 2021-03-23 12:22, Can Guo wrote:
>> > > > > > > > > > On 2021-03-22 17:11, Bean Huo wrote:
>> > > > > > > > > > > On Mon, 2021-03-22 at 15:54 +0900, Daejun Park
>> > > > > > > > > > > wrote:
>> > > > > > > > > > > > +       switch (rsp_field->hpb_op) {
>> > > > > > > > > > > > +       case HPB_RSP_REQ_REGION_UPDATE:
>> > > > > > > > > > > > +               if (data_seg_len !=
>> > > > > > > > > > > > DEV_DATA_SEG_LEN)
>> > > > > > > > > > > > +                       dev_warn(&hpb-
>> > > > > > > > > > > > >sdev_ufs_lu->sdev_dev,
>> > > > > > > > > > > > +                                "%s: data seg
>> > > > > > > > > > > > length is not
>> > > > > > > > > > > > same.\n",
>> > > > > > > > > > > > +                                __func__);
>> > > > > > > > > > > > +
>> > > > > > > > > > > > ufshpb_rsp_req_region_update(hpb, rsp_field);
>> > > > > > > > > > > > +               break;
>> > > > > > > > > > > > +       case HPB_RSP_DEV_RESET:
>> > > > > > > > > > > > +               dev_warn(&hpb->sdev_ufs_lu-
>> > > > > > > > > > > > >sdev_dev,
>> > > > > > > > > > > > +                        "UFS device lost HPB
>> > > > > > > > > > > > information
>> > > > > > > > > > > > during
>> > > > > > > > > > > > PM.\n");
>> > > > > > > > > > > > +               break;
>> > > > > > > > > > > Hi Deajun,
>> > > > > > > > > > > This series looks good to me. Just here I have
>> > > > > > > > > > > one question. You
>> > > > > > > > > > > didn't
>> > > > > > > > > > > handle HPB_RSP_DEV_RESET, just a warning.  Based
>> > > > > > > > > > > on your SS UFS,
>> > > > > > > > > > > how
>> > > > > > > > > > > to
>> > > > > > > > > > > handle HPB_RSP_DEV_RESET from the host side? Do
>> > > > > > > > > > > you think we
>> > > > > > > > > > > shoud
>> > > > > > > > > > > reset host side HPB entry as well or what else?
>> > > > > > > > > > > Bean
>> > > > > > > > > > Same question here - I am still collecting
>> > > > > > > > > > feedbacks from flash
>> > > > > > > > > > vendors
>> > > > > > > > > > about
>> > > > > > > > > > what is recommanded host behavior on reception of
>> > > > > > > > > > HPB Op code
>> > > > > > > > > > 0x2,
>> > > > > > > > > > since it
>> > > > > > > > > > is not cleared defined in HPB2.0 specs.
>> > > > > > > > > > Can Guo.
>> > > > > > > > > I think the question should be asked in the HPB2.0
>> > > > > > > > > patch, since in
>> > > > > > > > > HPB1.0 device
>> > > > > > > > > control mode, a HPB reset in device side does not
>> > > > > > > > > impact anything
>> > > > > > > > > in
>> > > > > > > > > host side -
>> > > > > > > > > host is not writing back any HPB entries to device
>> > > > > > > > > anyways and HPB
>> > > > > > > > > Read
>> > > > > > > > > cmd with
>> > > > > > > > > invalid HPB entries shall be treated as normal
>> > > > > > > > > Read(10) cmd
>> > > > > > > > > without
>> > > > > > > > > any
>> > > > > > > > > problems.
>> > > > > > > > Yes, UFS device will process read command even the HPB
>> > > > > > > > entries are
>> > > > > > > > valid or
>> > > > > > > > not. So it is warning about read performance drop by
>> > > > > > > > dev reset.
>> > > > > > > Yeah, but still I am 100% sure about what should host do
>> > > > > > > in case of
>> > > > > > > HPB2.0
>> > > > > > > when it receives HPB Op code 0x2, I am waiting for
>> > > > > > > feedbacks.
>> > > > > > I think the host has two choices when it receives 0x2.
>> > > > > > One is nothing on host.
>> > > > > > The other is discarding all HPB entries in the host.
>> > > > > > In the JEDEC HPB spec, it as follows:
>> > > > > > When the device is powered off by the host, the device may
>> > > > > > restore
>> > > > > > L2P
>> > > > > > map
>> > > > > > data upon power up or build from the host’s HPB READ
>> > > > > > command.
>> > > > > > If some UFS builds L2P map data from the host's HPB READ
>> > > > > > commands, we
>> > > > > > don't
>> > > > > > have to discard HPB entries in the host.
>> > > > > > So I thinks there is nothing to do when it receives 0x2.
>> > > > > But in HPB2.0, if we do nothing to active regions in host
>> > > > > side, host
>> > > > > can
>> > > > > write
>> > > > > HPB entries (which host thinks valid, but actually invalid in
>> > > > > device
>> > > > > side since
>> > > > > reset happened) back to device through HPB Write Buffer cmds
>> > > > > (BUFFER
>> > > > > ID
>> > > > > = 0x2).
>> > > > > My question is that are all UFSs OK with this?
>> > > > Yes, it must be OK.
>> > > > Please refer the following the HPB 2.0 spec:
>> > > > If the HPB Entries sent by HPB WRITE BUFFER are removed by the
>> > > > device,
>> > > > for example, because they are not consumed for a long enough
>> > > > period of
>> > > > time,
>> > > > then the HPB READ command for the removed HPB entries shall be
>> > > > handled
>> > > > as a
>> > > > normal READ command.
>> > > No, it is talking about the subsequent HPB READ cmd sent after a
>> > > HPB
>> > > WRITE BUFFER cmd,
>> > > but not the HPB WRITE BUFFER cmd itself...
>> > Looks like this discussion is going the same way as we had in host
>> > mode.
>> > HPB-WRITE-BUFFER 0x2, if exist,  is always a companion to HPB-READ.
>> > You shouldn't consider them separately.
>> > The device is expected to handle invalid ppn by itself, and
>> > specifically for this case,
>> > As Daejun explained, Handle each HPB-READ (and its companion
>> > HPB-WRITE-BUFFER) like READ10.
>> > For device mode, doing nothing in case of dev reset, seems to me
>> > like
>> > the right thing to do.
>> 
>> 
>> I just got some feedbacks from other flash vendors, they all commit
>> that
>> 
>> their devices can work well in this scenario [1]. Some of them
>> proposed
>> 
>> even complicated (maybe better) principles of handling the "HPB
>> reset",
>> 
>> but since the device works well in [1], I am OK with current
>> (simpler)
>> 
>> handling of "HPB reset" - in device mode doing nothing, in host mode
>> 
>> re-activate regions that host is trying to do a read to.
>> 
>> 
>> 
> 
> Our suggestion on this indication 0x2:
> 
> 1. If current mode is device control mode, we suggest host just
> deactivate all active regions and don't send HPB READ BUFFER command to
> device unless device indicate host to activate certain region in later
> response. In another way, it is a signal telling host to reset host
> side L2P entry and to rebuild the L2P mapping entry in host memroy.
> 
> 2. If current mode is host control mode, we suggest host send HPB READ
> BUFFER command before it wants to send read command on this region,
> rather than sending HPB READ BUFFER commands on all regions at the same
> time.
> 
> 
> Bean

Hi Bean,

I got this proposal from your side too, after that I've checked with
Leon Ge from your side and he confirmed that it is fine that host just
ignores the "HPB reset" indication. We can leave it as it is as of now
and revisit it if any UFS needs extra care. What do you say?

Thanks,
Can Guo.

> 
>> Thanks,
>> 
>> Can Guo.
