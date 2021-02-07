Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D759C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 07:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F51664E78
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 07:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhBGHhM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 02:37:12 -0500
Received: from so15.mailgun.net ([198.61.254.15]:22710 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhBGHhJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 Feb 2021 02:37:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612683406; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=vFvvHLjgjdxstAnQa5f3esWGzIkB2tiB9mU/LldaNe8=;
 b=vxgudXWB4TI5vfcn8lIxBrAiE+1+5zqBY3BOt3sS60m/RMUxYEozqM0yoAqFVwRgO1w5EtxD
 EGpDuyq6+E7D2Dh+DH2AY3b46ypG21yQUxqVrKkjTuWkDjQMYnaqKv+MEQFNcR+/f5KWEo/f
 YiEaitZc1UPRLucY4trxgDbyiJM=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 601f98658e43a988b7be10f3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 07 Feb 2021 07:36:05
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81162C433ED; Sun,  7 Feb 2021 07:36:05 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C702EC433C6;
        Sun,  7 Feb 2021 07:36:04 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 07 Feb 2021 15:36:04 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>, daejun7.park@samsung.com,
        Greg KH <gregkh@linuxfoundation.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, bvanassche@acm.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached sub-region
In-Reply-To: <12a011cd895dc9be5ec6c4f964b6011af492f06d.camel@gmail.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
 <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
 <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
 <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
 <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
 <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
 <12a011cd895dc9be5ec6c4f964b6011af492f06d.camel@gmail.com>
Message-ID: <ba7943ab40720df96a9fedb04ab0e4c8@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-05 23:08, Bean Huo wrote:
> On Fri, 2021-02-05 at 14:06 +0000, Avri Altman wrote:
>> > > > +     put_unaligned_be64(ppn, &cdb[6]);
>> > >
>> > > You are assuming the HPB entries read out by "HPB Read Buffer"
>> > > cmd
>> > > are
>> > > in Little
>> > > Endian, which is why you are using put_unaligned_be64 here.
>> > > However,
>> > > this assumption
>> > > is not right for all the other flash vendors - HPB entries read
>> > > out
>> > > by
>> > > "HPB Read Buffer"
>> > > cmd may come in Big Endian, if so, their random read performance
>> > > are
>> > > screwed.
>> >
>> > For this question, it is very hard to make a correct format since
>> > the
>> > Spec doesn't give a clear definition. Should we have a default
>> > format,
>> > if there is conflict, and then add quirk or add a vendor-specific
>> > table?
>> >
>> > Hi Avri
>> > Do you have a good idea?
>> 
>> I don't know.  Better let Daejun answer this.
>> This was working for me for both Galaxy S20 (Exynos) as well as
>> Xiaomi Mi10 (8250).
>> 
> 
> Thanks, I tested Daejun's patchset before, it is also ok (I don't know
> which version patchset). maybe we can keep current implementation as
> default, then if there is conflict, and submit the quirk.
> 

Yeah, you've tested it, are you sure that Micron's UFS devices are OK
with this specific code line?

Micron UFS FW team has confirmed that Micron's HPB entries read out by
"HPB Buffer Read" cmd are in big-endian byte ordering.

If Micron FW team is right, I am pretty sure that you would have seen
random read performance regression on Micron UFS devices caused by
invalid HPB entry format in HPB Read cmd UPIU (which leads to L2P cache
miss in device side all the time) during your test.

Can Guo.

> Thanks,
> Bean
> 
>> Thanks,
>> Avri
