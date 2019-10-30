Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5517FCA9EC7
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 22:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335CF20874
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 22:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfJ3WNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 18:13:19 -0400
Received: from smtp.infotech.no ([82.134.31.41]:56431 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfJ3WNT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 18:13:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 26C3E20418F;
        Wed, 30 Oct 2019 23:13:17 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qlYrrmIX-qhs; Wed, 30 Oct 2019 23:13:14 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 62F13204164;
        Wed, 30 Oct 2019 23:13:12 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 4/9] drivers/iio: Sign extend without triggering
 implementation-defined behavior
To:     Peter Zijlstra <peterz@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
References: <20191028200700.213753-1-bvanassche@acm.org>
 <20191028200700.213753-5-bvanassche@acm.org>
 <20191030200232.GC3079@worktop.programming.kicks-ass.net>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <bc4941a9-25f0-c931-61f1-b4f96c4bdff9@interlog.com>
Date:   Wed, 30 Oct 2019 18:13:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191030200232.GC3079@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-30 4:02 p.m., Peter Zijlstra wrote:
> On Mon, Oct 28, 2019 at 01:06:55PM -0700, Bart Van Assche wrote:
>>  From the C standard: "The result of E1 >> E2 is E1 right-shifted E2 bit
>> positions. If E1 has an unsigned type or if E1 has a signed type and a
>> nonnegative value, the value of the result is the integral part of the
>> quotient of E1 / 2E2 . If E1 has a signed type and a negative value, the
>> resulting value is implementation-defined."
> 
> FWIW, we actually hard rely on this implementation defined behaviour all
> over the kernel. See for example the generic sign_extend{32,64}()
> functions.
> 
> AFAIR the only reason the C standard says this is implementation defined
> is because it wants to support daft things like 1s complement and
> saturating integers.

See:
    http://www.open-std.org/jtc1/sc22/wg14/www/docs/n2218.htm

That is in C++20 and on the agenda for C2x:
    https://gustedt.wordpress.com/2018/11/12/c2x/

Doug Gilbert

> Luckily, Linux doesn't run on any such hardware and we hard rely on
> signed being 2s complement and tell the compiler that by using
> -fno-strict-overflow (which implies -fwrapv).
> 
> And the only sane choice for 2s complement signed shift right is
> arithmetic shift right.
> 
> (this recently came up in another thread, which I can't remember enough
> of to find just now, and I'm not sure we got a GCC person to confirm if
> -fwrapv does indeed guarantee arithmetic shift, the GCC documentation
> does not mention this)
> 

