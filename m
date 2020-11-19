Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36FFC6369E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 18:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96933246F3
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 18:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="moKefmMk";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="I7WDFyj1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgKSSJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 13:09:40 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35110 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbgKSSJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 13:09:40 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605809378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S+E33Uzzr7zAnLy0AQRsQOmLC1q/PMKuY7ohh67YdQM=;
        b=moKefmMkd6ZQNU9+1ZmFPmSDmArkJR9i/y6D9FitEwpBJ8xV5eTjuOZmm55jCW9Ndpc3OU
        8YMG9JQp83Xf67y27Y1lNIK0gm3scYUW8oqtJnmqMzPNrfcybInoWrneQeCnVlbPQzB3MZ
        sgwH1XCgB9lp50kBbWM6appg2hsDVPtLjMKKFKdvk+KLu8HKCe4TqqLdPgZjpUbqxKL4Hx
        SYk90SU02uDwv9EDoChOrAhSR6jjUvkYIhzHfQDnHDeCFsT5wE4YJglYQfry6d4q1DNmeF
        oUIQbY+jh7vd5MfWl8wUBBBSuTIPWFcGtuMA6ZpiGV7SBGu78y0qbhtbDXv5SA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605809378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S+E33Uzzr7zAnLy0AQRsQOmLC1q/PMKuY7ohh67YdQM=;
        b=I7WDFyj1cXy2r4vOuLQk1tLq9bRVnyYq/OxbqnH6i9JRRIqEdkh/yCyNiyBc8V2zGHB91a
        WGRTcAnHJbN0v4Cw==
To:     John Garry <john.garry@huawei.com>, gregkh@linuxfoundation.org,
        rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
In-Reply-To: <b86af904-2288-8b53-7e99-e763b73987d0@huawei.com>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de> <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com> <874klmqu2r.fsf@nanos.tec.linutronix.de> <b86af904-2288-8b53-7e99-e763b73987d0@huawei.com>
Date:   Thu, 19 Nov 2020 19:09:37 +0100
Message-ID: <87lfexp6am.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 19 2020 at 09:31, John Garry wrote:
>>   1) Interrupt does not exist. Definitely a full fail
>> 
>>   2) Interrupt is already started up. Not a good idea on init() and
>>      a clear fail.
>> 
>>   3) Interrupt has already been switched to managed. Double init is not
>>      really a good sign either.
>
> I just tested that and case 3) would be a problem. I don't see us 
> clearing the managed flag when free'ing the interrupt. So with 
> CONFIG_DEBUG_TEST_DRIVER_REMOVE=y, we attempt this affinity update 
> twice, and error from the irqd_affinity_is_managed() check.

That means the interrupt is not deallocated and reallocated, which does
not make sense to me.

Thanks,

        tglx
