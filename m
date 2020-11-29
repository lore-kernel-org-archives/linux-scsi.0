Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C45C64E7C
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Nov 2020 06:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638A9207CD
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Nov 2020 06:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJOjacqi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgK2GzD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 01:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgK2GzD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 01:55:03 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC25C0613D1
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2020 22:54:22 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id x24so8128319pfn.6
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2020 22:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Qd1zMef8smRmt1MSDBr44hR7RRlwq8GkeDTCXZKvr6k=;
        b=mJOjacqihAZ+RuOvaFhQ//lBWuk6ZOkIj0/zgm60UkpZg4lGDt+ajjLNoXeqp8DqBg
         kxZyD1FmJSp2/4Artkcw75Fr0wmraZQiDtq+ZkqopDkhIm47ItuDeeY8kMsShjLxjvk/
         E9G9Nqfm/J7e4bMDVOVa9FUsVh2Mw++dRevU8w6MbLkuPFYE+tINYGKhX+Snm+HxwQPs
         izwCicalUTFqfqT5KdAlkJ+fIyEPPF/NpuVfFrWTbNNVn5chEclRs528FlhBKZ4k2YX/
         IhGmTpw9/gwnNZoI/qAx6kY3D0XGO1CwsAsG9DtHQ9801/kS7/c4rEFHmq4okAJro7bC
         kbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Qd1zMef8smRmt1MSDBr44hR7RRlwq8GkeDTCXZKvr6k=;
        b=VXvPISOyd09nO7BWvOgMruBCaZTWutsVJ+ScvkXmhHqVqtmLLl1CDRLlcI+Cr55nrA
         SUyTr3Um8kgvpCKyBE45b2Oy19xjYHHZy/548dmtxtJ2Xvuu8lF8Xw1l1tS7p+XLXYH6
         eMqQQuCQ5DjJP8fmalRq+7YcfTycxFEPIOYPSuG3AEaeNn66iYzjXf0QFjIK8L4JQH3t
         8PsRurMpZo3YGyn9sm+or4C5gDMRvvhC+l04PCX11CF4BH/Zng8DAS82B0NYBwahkHZT
         cCFcMGS61nc84gFP7PAAovAZm46FBPxWB8FKBtQbfN4jQ6nfnIMKpUUQQ85g8F75Y6ZX
         yuJQ==
X-Gm-Message-State: AOAM533EzIs9xaoPpAsjhf8O4+aoN/CX8eNrsG17YJUSg4DFQq5QgTF8
        7NXooRd/DBon0qYgHezNQBw=
X-Google-Smtp-Source: ABdhPJxOAySBK5pjqAGkvbkolIoFeomJKyW4p9iHneMHxm/5STlzO9merpA2eC545WUkaE4OXOa7GQ==
X-Received: by 2002:a62:e416:0:b029:197:eed6:c8b9 with SMTP id r22-20020a62e4160000b0290197eed6c8b9mr13772491pfh.57.1606632862381;
        Sat, 28 Nov 2020 22:54:22 -0800 (PST)
Received: from Schmitz-MBP.telecom (122-58-181-142-adsl.sparkbb.co.nz. [122.58.181.142])
        by smtp.googlemail.com with ESMTPSA id t8sm15976965pjs.43.2020.11.28.22.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Nov 2020 22:54:21 -0800 (PST)
Subject: Re: [PATCH 12/14] scsi: NCR5380: Remove in_interrupt().
To:     Finn Thain <fthain@telegraphics.com.au>,
        Andreas Schwab <schwab@linux-m68k.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-13-bigeasy@linutronix.de>
 <alpine.LNX.2.23.453.2011271524140.15@nippy.intranet>
 <alpine.LNX.2.23.453.2011280802170.6@nippy.intranet>
 <alpine.LNX.2.23.453.2011280827270.14@nippy.intranet>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <3bf3baef-ea46-a9c3-10e9-7705650d07a6@gmail.com>
Date:   Sun, 29 Nov 2020 19:54:04 +1300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.23.453.2011280827270.14@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

Am 28.11.20 um 10:48 schrieb Finn Thain:
> On Sat, 28 Nov 2020, Finn Thain wrote:
>
>> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
>> index d654a6cc4162..739def70cffb 100644
>> --- a/drivers/scsi/NCR5380.c
>> +++ b/drivers/scsi/NCR5380.c
>> @@ -223,7 +223,10 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
>>  		cpu_relax();
>>  	} while (n--);
>>  
>> -	if (irqs_disabled() || in_interrupt())
>> +	/* We can't sleep when local irqs are disabled and callers ensure
>> +	 * that local irqs are disabled whenever we can't sleep.
>> +	 */
>> +	if (irqs_disabled())
>>  		return -ETIMEDOUT;
>>  
>>  	/* Repeatedly sleep for 1 ms until deadline */
>>
> Michael, Andreas, would you please confirm that this is workable on Atari? 
> The driver could sleep when IPL == 2 because arch_irqs_disabled_flags() 
> would return false (on Atari). I'm wondering whether that would deadlock.

Pretty sure this would deadlock when in interrupt context here.
Otherwise, IPL 2 is perfectly OK (which is why
arch_irqs_disabled_flags() returns false in that case).

If you want to be 100% certain, I can give this one a spin.

Cheers,

    Michael

