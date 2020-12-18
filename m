Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8406C2BBCF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9814423405
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732861AbgLRGbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 01:31:01 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:32665 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732785AbgLRGbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 01:31:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608273037; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=f/emvhlPCHn+Sh53iWp8Ew1VVewyQayEPXGejZeXtsk=;
 b=OP0zIBJjUf3A5LuHM42YkzpojYdScPWGwDfpCj9VTD0Onw534YftIyEHYdDviu50j9YbFwnf
 L9pxpo5XihFg8nwCvPuaVsx82nUF3Df8MLC0ZD1PXPIPqNCjAc4fpDpVpSZx8ry1rKYDe7uE
 /YWZ10FHusocymekTIGIvKjIVRo=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5fdc4c71ca81d9e6259728bf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 18 Dec 2020 06:30:09
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 48947C43463; Fri, 18 Dec 2020 06:30:09 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6BA43C433C6;
        Fri, 18 Dec 2020 06:30:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Dec 2020 14:30:08 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH v2 0/4] scsi: ufs: Cleanup and refactor clock scaling
In-Reply-To: <1608272678.10163.40.camel@mtkswgap22>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
 <e939a0fd4afd1691f3e1a8182515ca64@codeaurora.org>
 <1608272678.10163.40.camel@mtkswgap22>
Message-ID: <ee0f3ffc6d86098fc5704c1726fc69f3@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-18 14:24, Stanley Chu wrote:
> Hi Can,
> 
> On Fri, 2020-12-18 at 14:20 +0800, Can Guo wrote:
>> On 2020-12-16 21:16, Stanley Chu wrote:
>> > Hi,
>> > This series cleans up and refactors clk-scaling feature, and shall not
>> > change any functionality.
>> >
>> > This series is based on Can's series "Three changes related with UFS
>> > clock scaling" in 5.10/scsi-fixes branch in Martin's tree.
>> >
>> 
>> Hi Stanley,
>> 
>> Thanks for noticing my changes, will you review them?
>> I see customers manipulte UFS scaling related sysfs
>> nodes more often than before, so we may want to fix it asap.
> 
> I have gave my review tag in all patches in this series : )
> 
> Thanks,
> Stanley Chu
> 

Hi Stanley,

oops, just saw it - I opened the wrong series.
I will push a new version which incorporates your comments soon.
Since the new changes would only be some words in ufshcd.h, so you
won't need to rebase.

Thanks,

Can Guo.

>> 
>> Regards,
>> 
>> Can Guo.
>> 
>> > However this series may not be required to be merged to 5.10. The
>> > choice of base branch is simply making these patches easy to be
>> > reviewed because this series is based on clk-scaling fixes by Can. If
>> > this series is decided not being merged to 5.10, then I would rebase
>> > it to 5.11/scsi-queue.
>> >
>> > Changes since v1:
>> >   - Refactor ufshcd_clk_scaling_suspend() in patch [3/4]
>> >   - Change function name from ufshcd_clk_scaling_pm() to
>> > ufshcd_clk_scaling_suspend() in patch [3/4]
>> >   - Refine patch titles
>> >
>> > Stanley Chu (4):
>> >   scsi: ufs: Refactor cancelling clkscaling works
>> >   scsi: ufs: Remove redundant null checking of devfreq instance
>> >   scsi: ufs: Cleanup and refactor clk-scaling feature
>> >   scsi: ufs: Fix build warning by incorrect function description
>> >
>> >  drivers/scsi/ufs/ufshcd.c | 90 +++++++++++++++++++--------------------
>> >  1 file changed, 43 insertions(+), 47 deletions(-)
