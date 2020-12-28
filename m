Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D22C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 01:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28A84221F7
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 01:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgL1Beg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Dec 2020 20:34:36 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:16554 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgL1Beg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Dec 2020 20:34:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609119257; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=eZTjBgbTUfr1OVRJYpoYf8PCujArXTjn/09ZaCNxY/w=;
 b=QyZO4y/QQwKGy4bwsGwtEAn9W9XCpqhJIIEbTaTz09RZ0tPKDzmu4K458T98aq947NlP4SfS
 1Smks3gxBrO67F7PY5ZCuIGMsxLWxxrEKNbxVq97V+HY2p96cvg0dKhmFuLlMx5sOH1xPOTR
 55JkdSMaztA4kRWj8+y2hJ6WLI4=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fe935f97036173f4f932bd8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 28 Dec 2020 01:33:45
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EAD00C433C6; Mon, 28 Dec 2020 01:33:44 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 434FDC433CA;
        Mon, 28 Dec 2020 01:33:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Dec 2020 09:33:44 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     Bean Huo <huobean@gmail.com>, Avri Altman <Avri.Altman@wdc.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
In-Reply-To: <1608817657.14045.30.camel@mtkswgap22>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
 <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
 <1608697172.14045.5.camel@mtkswgap22>
 <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
 <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
 <1608796334.14045.21.camel@mtkswgap22>
 <DM6PR04MB6575D0DD2C04692AEF771494FCDD0@DM6PR04MB6575.namprd04.prod.outlook.com>
 <5eb12622222bd9ba5e705801a204f3160ba3966b.camel@gmail.com>
 <1608817657.14045.30.camel@mtkswgap22>
Message-ID: <ed467feb9c692896ddffe3c36e0dbced@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-24 21:47, Stanley Chu wrote:
> Hi Avri, Bean,
> 
> On Thu, 2020-12-24 at 13:01 +0100, Bean Huo wrote:
>> On Thu, 2020-12-24 at 11:03 +0000, Avri Altman wrote:
>> > > > Do you see any substantial benefit of having
>> > > > fWriteBoosterBufferFlushEn
>> > > > disabled?
>> > >
>> > > 1. The definition of fWriteBoosterBufferFlushEn is that host allows
>> > > device to do flush in anytime after fWriteBoosterBufferFlushEn is
>> > > set as
>> > > on. This is not what we want.
>> > >
>> > > Just Like BKOP, We do not want flush happening beyond host's
>> > > expected
>> > > timing that device performance may be "randomly" dropped.
>> >
>> > Explicit flush takes place only when the device is idle:
>> > if fWriteBoosterBufferFlushEn is set, the device is idle, and before
>> > h8 received.
>> > If a request arrives, the flush operation should be halted.
>> > So no performance degradation is expected.
>> 
>> Hi Stanley
>> 
>> Avri's comment is correct, fWriteBoosterBufferFlushEn==1, device will
>> flush only when it is in idle, once there is new incoming request, the
>> flush will be suspended. You should be very careful when you want to
>> skip this stetting of this flag.
> 
> Very appreciate your the clarification.
> 
> However similar to "Background Operations Termination Latency", while
> the next request comes, device may need some time to suspend on-going
> flush operations. This delay may "randomly" degrade the performance
> right?

That can be case by case (or vendor by vendor), but generally I agree
with you on this.

> 
> Since the configuration, i.e., enable
> fWriteBoosterBufferFlushDuringHibernate only with
> fWriteBoosterBufferFlushEn disabled, has been applied in many of our
> mass-produced products these yeas, we would like to keep it unless the
> new setting has obvious benefits.

Thanks for sharing the info. I will leave the decision to Asutosh on 
this.

Thanks,
Can Guo.

> 
> Thanks,
> Stanley Chu
> 
>> 
>> Bean
>> 
