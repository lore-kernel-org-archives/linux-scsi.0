Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E30C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD61229CA
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbhAKJXg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 04:23:36 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:59416 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbhAKJXg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 04:23:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610356997; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=lTjykblV8tDGM9es9mjJrFFmMVEipVxBCLhQLHO2kAA=;
 b=BRzZXUIvtMD5H5qqL6y+tWAYTqOeCHvU9cfczNoxoBXlfK1jE+FOmlmuP2JWcnbH4R08Fi1Z
 yOVNAHlhYARjnsTyPsvLrgN92QFvKhQxTl8dbbmxcRA3Erc/VHnBIaqlvJErCHzbUgixIHK9
 yQDWZ2Cbh1/RG+Q6NbIDYifumRo=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5ffc18ea8fb3cda82ffcdeb0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Jan 2021 09:22:50
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2E471C4346B; Mon, 11 Jan 2021 09:22:49 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 03E76C433C6;
        Mon, 11 Jan 2021 09:22:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 11 Jan 2021 17:22:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        rjw@rjwysocki.net, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
In-Reply-To: <976641f42211af23d90464d0c4841cc40740b0d7.camel@gmail.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
 <1609595975-12219-3-git-send-email-cang@codeaurora.org>
 <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
 <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
 <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
 <f814b71d1d4ea87a72df4851a8190807@codeaurora.org>
 <cb388d8ea15b2c80a072dec74d9ededecb183a08.camel@gmail.com>
 <e69bd5a6b73d5c652130bf4fa077aac0@codeaurora.org>
 <606774efd4d89f0ea78cefeb428cc9e1@codeaurora.org>
 <146b46a5c38f4582a9a8e6df1d87cdfc0684f549.camel@gmail.com>
 <fa0e976387070c64752c972d32ce15df@codeaurora.org>
 <976641f42211af23d90464d0c4841cc40740b0d7.camel@gmail.com>
Message-ID: <7f193fe5abfb41aa72d17f7884cbd113@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-11 16:23, Bean Huo wrote:
> On Mon, 2021-01-11 at 09:27 +0800, Can Guo wrote:
>> >
>> > If accessing sysfs nodes, which triggers a UFS UPIU request to
>> > read/write UFS device descriptors during shutdown flow, there is
>> > only
>> > one issue that sysfs node access failure since UFS device and LINK
>> > has
>> > been shutdown. Strictly speaking, the failure comes after
>> > ufshcd_set_dev_pwr_mode().
>> >
>> >     __ufshcd_query_descriptor: opcode 0x01 for idn 0 failed, index
>> > 0,
>> > err = -11
>> 
>> You misunderstood it again. You are expecting a simple query cmd
>> error.
>> But what really matters are NoC issues[1] and OCP[2]. And
>> while/after
>> UFS
>> shutting down, either of them may happen.
>> 
>> [1] When a un-clocked register access issue happens, we call it a
>> NoC
>> issue,
>> meaning you are tring to access a register when clocks are disabled.
>> This
>> leads to system CRASH.
>> 
> 
> OK, let it simple, share this kind of crash log becuase of access sysfs
> node in the shutdown flow.
> 
> 
>> [2] OCP is over current protection. While UFS shutting down, you may
>> have put UFS regulators to LPM. After that, if you are still trying
>> to
>> talk to UFS, OCP can happen on VCCQ/VCCQ2. This leads to system
>> CRASH
>> too.
> 
> the same as above, share the crash log.
> 

If you have hand-on experiences on NoC and/or OCP issues, you won't ask
for the crash log. The tricky parts about critial NoC and OCP issues is
that they don't print much logs (maybe no logs at all) in uart, which is
why they are hard to debug and why I add another flag to help debug.

Take OCP as an example, when OCP happens on VCCQ/VCCQ2, PMIC will do a
hard reset and put the system to crash dump mode (this is a general 
design
in our mutual customers, but it may vary platform by platform).

And if you have a crash dump tool to collect the dump, after the dump is
parsed, the best part which you can count on is the last callstacks and
related flags, variables in hba. The callstack is pretty much same with
the one I shared with my debug patch applied during the weekend.

Stanley can correct me if I am wrong.

Thanks,
Can Guo.

>> 
>> >
>> > Since the shutdown is oneway process, this failure is not big
>> > issue. If
>> > you meant to avoid this failure for unsafe shutdown, I agree with
>> > you,
>> > But for the race issue, I don't know.
>> >
>> 
>> Easy for you to say. System crash is a big issue to any SoC vendors
>> I
>> belive.
>> 
> 
> indeed, crash is serious issue, share the log.
> 
> 
> Thanks,
> Bean
> 
> 
>> Can Guo.
