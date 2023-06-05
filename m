Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FCDC7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 04:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjFEEnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 00:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjFEEnl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 00:43:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57A9B0;
        Sun,  4 Jun 2023 21:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AD6A60FF2;
        Mon,  5 Jun 2023 04:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0084BC433D2;
        Mon,  5 Jun 2023 04:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685940218;
        bh=Q2LYPU3tLkyhQ4Pp64yIytDL2o67Pr2wna2sgrcUcpM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=br5SZ4RyOoGkIRtZ5ayTXvpjkF9uaWeLKWgUCteluljBEyALZfPobF4beAnmMcL39
         XN1/ooUQjseEsPwv2SPF1JuH+h4oCwk4lv0siLcz/+3gHeaaU8v7twWzpp8sG/MVEK
         /tgYm0yfS9rX3lcIbZbfHL2L3A6jKZaLjqRhwkgD6H2+Ibxgnysf//ejIDIXdRwQMH
         wlDH6rLVbqYe/8S1XAru2XgRHaE6geXSOPqCXHj+aDMQdTDsfKMu1M8CEG3ZhVJ/4N
         tLfWt0Cd80n+Nxerh6bRZlmRx7KcAAA71rGhvC4kG7TwB8nGjUzeipiOdLHYNJKUPv
         KpUXRBdfMr/0g==
Message-ID: <8a405b3b-b630-8cf6-6062-57034dfa6086@kernel.org>
Date:   Mon, 5 Jun 2023 13:43:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] block: improve ioprio value validity checks
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230530061307.525644-1-dlemoal@kernel.org>
 <ZHW9IQvePaG0yxY8@x1-carbon>
 <CACRpkdZskZ-GktsYL0MXbMwdOQmF=-4yyns3u+-2eHP1Nt_RHg@mail.gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CACRpkdZskZ-GktsYL0MXbMwdOQmF=-4yyns3u+-2eHP1Nt_RHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/30/23 20:30, Linus Walleij wrote:
> On Tue, May 30, 2023 at 11:09 AM Niklas Cassel <Niklas.Cassel@wdc.com> wrote:
> 
>> We noticed that the LTP test case:
>> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/ioprio/ioprio_set03.c
>>
>> Started failing since this commit in linux-next:
>> eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
>>
>> The test case expects that a syscall that sets ioprio with a class of 8
>> should fail.
>>
>> Before this commit in linux next, the 16 bit ioprio was defined like this:
>> 3 bits class | 13 bits level
>>
>> However, ioprio_check_cap() rejected any priority levels in the range
>> 8-8191, which meant that the only bits that could actually be used to
>> store an ioprio were:
>> 3 bits class | 10 bits unused | 3 bits level
>>
>> The 10 unused bits were defined to store an ioprio hint in commit:
>> 6c913257226a ("scsi: block: Introduce ioprio hints"), so it is now:
>> 3 bits class | 10 bits hint | 3 bits level
>>
>> This meant that the LTP test trying to set a ioprio level of 8,
>> will no longer fail. It will now set a level of 0, and a hint of value 1.
> 
> Wow good digging! I knew the test would be good for something.
> Like for maintaining the test.
> 
>> The fix that Damien suggested, which adds multiple boundary checks in the
>> IOPRIO_PRIO_VALUE() macro will fix any user space program that uses the uapi
>> header.
> 
> Fixing things in the UAPI headers make it easier to do things right
> going forward with classes and all.
> 
>> However, some applications, like the LTP test case, do not use the
>> uapi header, but defines the macros inside their own header.
> 
> IIRC that was because there were no UAPI headers when the test
> was created, I don't think I was just randomly lazy... Well maybe I
> was. The numbers are ABI anyway, not the header files.
> 
>> Note that even before commit:
>> eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
>>
>> The exact same problem existed, ioprio_check_cap() would not give an
>> error if a user space program sent in a level that was higher than
>> what could be represented by the bits used to define the level,
>> e.g. a user space program using IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 8192)
>> would not have the syscall return error, even though the level was higher
>> than 7. (And the effective level would be 0.)
>>
>> The LTP test case needs to be updated anyway, since it copies the ioprio
>> macros instead of including the uapi header.
> 
> Yeah one of the reasons the kernel fails is in order to be
> able to slot in new behaviour in response to these ioctls,
> so the test should probably just be updated to also test
> the new scheduling classes and all that, using the UAPI
> headers.
> 
> Will you send a patch?

Linus,

I sent a couple of patches for ltp to fix this. As I am not subscribed to the
ltp list, I got the usual "Your mail to 'ltp' with the subject ... Is being held
until the list moderator can review it for approval.".


> 
> Yours,
> Linus Walleij

-- 
Damien Le Moal
Western Digital Research

