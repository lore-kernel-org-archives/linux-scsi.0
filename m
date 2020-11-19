Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FAAC56201
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 21:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDC7221EB
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 21:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vBgRz02M";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="aeWxDm4x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgKSVDv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 16:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgKSVDv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 16:03:51 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15531C0613CF;
        Thu, 19 Nov 2020 13:03:51 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605819829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D0V6XhfIWrizdLNMw5VqPtl0WoDG5eGzCDqsK3ZiWRE=;
        b=vBgRz02M0Lb+A18LcJpN4nG0MVNmuCuiYHqTjMwat5Et3WsTfKTgSdVTQ/lkW5pXd7pH6F
        LYH1qkYiTNtcdXbKa0VFWtQDHPMtaPSkHLuoolkRrdgWu+ugHAtTrXHXBMr9RTxe975zCe
        6HbYtMUWWh4A4bOo5XNvILqI+2CBGh4KoltgzwoKOf8n8Hqeuuqex9dQUNpMctlLmHYTGg
        SK34EgjSkOzp2RENTFCxV1LvxOphnwqMR7OHwP8IkWdvWMh5b+AaDUqVlMQJ0sG+JfPhB2
        MzCM5amH9JVYgxDBJgsPjbAKbpj4KfNnioFxN5tXMVfMvl1Gk7K05IITR7Kobg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605819829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D0V6XhfIWrizdLNMw5VqPtl0WoDG5eGzCDqsK3ZiWRE=;
        b=aeWxDm4xMqI94NoOtPZ+KlgMg5ZrKp6JUAJ+tVdPo2GRVtN18DJcG2fgGFJc0l7m+A6CYA
        9p8k88/BLl5uiyAg==
To:     John Garry <john.garry@huawei.com>, gregkh@linuxfoundation.org,
        rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
In-Reply-To: <3acb7fde-eae2-a223-9cfd-f409cc2abba6@huawei.com>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de> <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com> <874klmqu2r.fsf@nanos.tec.linutronix.de> <b86af904-2288-8b53-7e99-e763b73987d0@huawei.com> <87lfexp6am.fsf@nanos.tec.linutronix.de> <3acb7fde-eae2-a223-9cfd-f409cc2abba6@huawei.com>
Date:   Thu, 19 Nov 2020 22:03:49 +0100
Message-ID: <873615oy8a.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 19 2020 at 19:56, John Garry wrote:
>>>>    3) Interrupt has already been switched to managed. Double init is not
>>>>       really a good sign either.
>>> I just tested that and case 3) would be a problem. I don't see us
>>> clearing the managed flag when free'ing the interrupt. So with
>>> CONFIG_DEBUG_TEST_DRIVER_REMOVE=y, we attempt this affinity update
>>> twice, and error from the irqd_affinity_is_managed() check.
>> That means the interrupt is not deallocated and reallocated, which does
>> not make sense to me.
>> 
>
> Just mentioning a couple of things here, which could be a clue to what 
> is going on:
> - the device is behind mbigen secondary irq controller
> - the flow in the LLDD is to allocate all 128 interrupts during probe, 
> but we only register handlers for a subset with device managed API

Right, but if the driver is removed then the interrupts should be
deallocated, right?

Thanks,

        tglx
