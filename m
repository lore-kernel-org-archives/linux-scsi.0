Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65A8CA9ECF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 17:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3422080F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 17:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbfJaRzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 13:55:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33587 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJaRzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 13:55:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so3033636plk.0;
        Thu, 31 Oct 2019 10:55:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rfu7xisG1VzK9l1fM8rUWCXjY+Vu9qgC5rX7Api65YQ=;
        b=sVLCWYoob04UbUMLPirKTHrvWcBOotdRwKhsfJWBQOvCSVnm6iEgVJdycxjh2EKLNH
         4DunIVF1bBAbyrz+xtnpDu8O0/CR2BrimsKIaNsileWcLvDrsCNI3P6nR/uBmAzhjkqu
         bCDiYESXsHIS0eHtIj88B2eS4yjCRf26YEp9JrAVi4eAjAPIE+Vq9wwjgWiMhLWktpcS
         a9i1UXkEdoGbbia4FpkPjewNtmQoGx4aP7ikTrTJdxMl73/OHxKF/qR9+a4+xHxODcHb
         LJMOrXcN+ZdpSVkwOtXECVbzfCoEffRT/YQ6217RnJAe04azadxxGhSns1LrbvXKrdCl
         hNMQ==
X-Gm-Message-State: APjAAAW/f6DRTLEnx+D4OeCVT3vxqCaIjUFzA0TtosPueKlLnmTOVUQS
        /s60eYkMwm3IzuNI39mXKX0=
X-Google-Smtp-Source: APXvYqxOhQdnJ4HJ42l58Y2HemuWrKPK4wsg/9OWnqDaXmkG9u5MJ57Bd6czOyPkmD9iZ1pC0U6XfQ==
X-Received: by 2002:a17:902:b687:: with SMTP id c7mr7654265pls.52.1572544511272;
        Thu, 31 Oct 2019 10:55:11 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 22sm3859912pfo.131.2019.10.31.10.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 10:55:10 -0700 (PDT)
Subject: Re: [PATCH 4/9] drivers/iio: Sign extend without triggering
 implementation-defined behavior
To:     dgilbert@interlog.com, Peter Zijlstra <peterz@infradead.org>
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
 <bc4941a9-25f0-c931-61f1-b4f96c4bdff9@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a5863854-037d-55d5-69c8-ae15aa4a861a@acm.org>
Date:   Thu, 31 Oct 2019 10:55:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <bc4941a9-25f0-c931-61f1-b4f96c4bdff9@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/19 3:13 PM, Douglas Gilbert wrote:
> On 2019-10-30 4:02 p.m., Peter Zijlstra wrote:
>> On Mon, Oct 28, 2019 at 01:06:55PM -0700, Bart Van Assche wrote:
>>>  From the C standard: "The result of E1 >> E2 is E1 right-shifted E2 bit
>>> positions. If E1 has an unsigned type or if E1 has a signed type and a
>>> nonnegative value, the value of the result is the integral part of the
>>> quotient of E1 / 2E2 . If E1 has a signed type and a negative value, the
>>> resulting value is implementation-defined."
>>
>> FWIW, we actually hard rely on this implementation defined behaviour all
>> over the kernel. See for example the generic sign_extend{32,64}()
>> functions.
>>
>> AFAIR the only reason the C standard says this is implementation defined
>> is because it wants to support daft things like 1s complement and
>> saturating integers.
> 
> See:
>     http://www.open-std.org/jtc1/sc22/wg14/www/docs/n2218.htm
> 
> That is in C++20 and on the agenda for C2x:
>     https://gustedt.wordpress.com/2018/11/12/c2x/

Thanks Peter and Doug. This is very useful feedback. I will drop the 
sign_extend_24_to_32() function and use sign_extend32() instead.

Bart.
