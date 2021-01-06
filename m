Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA29C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 01:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97C9222D04
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 01:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbhAFBVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 20:21:40 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:26420 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbhAFBVh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 20:21:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609896072; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=8LuODshmJKkZRkhvezbZ2OPGFAbgzYQkWLm6mxDXMto=;
 b=bYDiYuqQTkLmkCLNmtz3XBW3iei+U17dUU7juPfGc7CwUny+DeBj0+50TguDq90yw4ChLk/3
 xWG4yvGtIL8rP5+jL7OTWI3cIRT+BEOdoZ4T69+swlpymTixMMA4JqStCzcVi78HnCSnI69L
 rlFyGXcscgd+BzrFrvaQeGb1ero=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5ff5106e570e7133a26a0433 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 06 Jan 2021 01:20:46
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4B010C4346B; Wed,  6 Jan 2021 01:20:45 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3AFC9C433C6;
        Wed,  6 Jan 2021 01:20:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 06 Jan 2021 09:20:44 +0800
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
In-Reply-To: <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
 <1609595975-12219-3-git-send-email-cang@codeaurora.org>
 <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
 <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
 <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
Message-ID: <f814b71d1d4ea87a72df4851a8190807@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On 2021-01-06 02:38, Bean Huo wrote:
> On Tue, 2021-01-05 at 09:07 +0800, Can Guo wrote:
>> On 2021-01-05 04:05, Bean Huo wrote:
>> > On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
>> > > + * @shutting_down: flag to check if shutdown has been invoked
>> >
>> > I am not much sure if this flag is need, since once PM going in
>> > shutdown path, what will be returnded by pm_runtime_get_sync()?
>> >
>> > If pm_runtime_get_sync() will fail, just check its return.
>> >
>> 
>> That depends. During/after shutdown, for UFS's case only,
>> pm_runtime_get_sync(hba->dev) will most likely return 0,
>> because it is already RUNTIME_ACTIVE, pm_runtime_get_sync()
>> will directly return 0... meaning you cannot count on it.
>> 
>> Check Stanley's change -
>> https://lore.kernel.org/patchwork/patch/1341389/
>> 
>> Can Guo.
> 
> Can,
> 
> Thanks for pointing out that.
> 
> Based on my understanding, that patch is redundent. maybe I
> misundestood Linux shutdown sequence.

Sorry, do you mean Stanley's change is redundant?

> 
> I checked the shutdown flow:
> 
> 1. Set the "system_state" variable
> 2. Disable usermod to ensure that no user from userspace can start a
> request

I hope it is like what you interpreted, but step #2 only stops UMH(#265)
but not all user space activities. Whereas, UMH is for kernel space 
calling
user space.

264 	system_state = state;
265 	usermodehelper_disable();
266 	device_shutdown();

Thanks,
Can Guo.

> 3. device_shutdown()
> So, userspace thread can not start a request to trigger runtime
> resume(pm_runtime_get_sync) after step 2.
> 
> also,  no need to add that flag to checkup if shutdwon is running,
> maybe it is better to check variable system_state:
> 
> if (system_state == SYSTEM_POWER_OFF || system_state == SYSTEM_HALT
> || system_state == SYSTEM_RESTART)
> 	//shutdown start
> 
> 
> I still hope Rafael or someone else can confirm that if
> pm_runtime_get_sync() will really return ok in shutdown flow.
> 
> 
> thanks,
> Bean
> 
>> 
>> > Hi Rafael
>> > would you please help us confirm this?
>> >
>> > thanks,
>> > Bean
