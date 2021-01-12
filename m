Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC6EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A930522510
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbhALAql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:46:41 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:56362 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731235AbhALAqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 19:46:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610412370; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Nv/zP2h6yHmultnitPDgLlwcKLI62F6LDdyCUTp686A=;
 b=uukft+lCOJ+3a63Qz055xp2svanPRdAr2a9kXDm2DP6uVdRGhBL+jdauCCuwcj0Tf6yu7Sla
 dlAk0vLCnVucmiM0Ycr14zyChPp1QP+z1Cm652oX7xP+GWtlp2ez1T27IH7ewfkveytipJSV
 eGZYl3q1yDObVu4rHhtVrCktibk=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5ffcf12bd84bad3547658e9f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 12 Jan 2021 00:45:31
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DC9DEC43478; Tue, 12 Jan 2021 00:45:30 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7F5D2C433C6;
        Tue, 12 Jan 2021 00:45:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 12 Jan 2021 08:45:29 +0800
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
In-Reply-To: <6eaa5c51c0b17968e0169b8a16bdbfa4934af5d8.camel@gmail.com>
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
 <7f193fe5abfb41aa72d17f7884cbd113@codeaurora.org>
 <6eaa5c51c0b17968e0169b8a16bdbfa4934af5d8.camel@gmail.com>
Message-ID: <9d74b57f9a26878705b7162a36b2bceb@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-11 18:04, Bean Huo wrote:
> On Mon, 2021-01-11 at 17:22 +0800, Can Guo wrote:
>> > > meaning you are tring to access a register when clocks are
>> > > disabled.
>> > > This
>> > > leads to system CRASH.
>> > >
>> >
>> > OK, let it simple, share this kind of crash log becuase of access
>> > sysfs
>> > node in the shutdown flow.
>> >
>> >
>> > > [2] OCP is over current protection. While UFS shutting down, you
>> > > may
>> > > have put UFS regulators to LPM. After that, if you are still
>> > > trying
>> > > to
>> > > talk to UFS, OCP can happen on VCCQ/VCCQ2. This leads to system
>> > > CRASH
>> > > too.
>> >
>> > the same as above, share the crash log.
>> >
>> 
>> If you have hand-on experiences on NoC and/or OCP issues, you won't
>> ask
>> for the crash log. The tricky parts about critial NoC and OCP issues
>> is
> 
> OK, interesting. would you tell me which register access node in ufs-
> sysfs.c can trigger this crash? let me verify your statement.
> 
> 

I believe I have explained enough to prove we need this change.

If you are really interested in NoC and OCP, feel free to ping me
on teams, I will show you how to trigger one and what is it like
on my setup.

Can Guo.

> Bean
> 
>> 
