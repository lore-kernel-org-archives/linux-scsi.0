Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD258C19437
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD3CF23B23
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgLHVeK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbgLHVeK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:34:10 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE59C061793
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 13:33:23 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id o8so28486ioh.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 13:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zdoQ9yJW9tTgrj6ngha5GHf9EI9TYgRrrDlU2gawLsk=;
        b=zvMHpPJu2d1u8/8TejNX0MesMmrN3FPXs5J3WEOOn6RSWpISqNdpekFsYkMdWWR91s
         eE1YddCBvNFv1fErpT/jUTa+M5+RTHY+RFn5jlZ1kj6E6HaiPKc4pgvJoofSytJFse+M
         GegJPeWNQHOd41OLTst4QJ0mfYVx46CJmkpDRcaf9QriSV86nha2hc0Baescb30h0rzv
         PW57A+a6bCTUyhxFVqe2VVglXsdVrGQ9hPu0HMxwEFHj6cBUsgc8He67JMY6P+NR2o+V
         swnsaSzjpIFQJfrCnw5v/CPgP4r6u96JwI0BkIRWgiwSkk2ey1QrfjzMjuSBDB5pBjkZ
         ljLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zdoQ9yJW9tTgrj6ngha5GHf9EI9TYgRrrDlU2gawLsk=;
        b=dt3/34RjDEon9GzUfb/DmBU1fy3SxRyr+lY4j9opAb/0rPqJ+SdEGo15x/w961aT+j
         xVwJC74nQaWDksofzc4YuuX8XEvQX5vFEZQcodRgpYNJ/vKCNZy+Khyakt8TCCeRzMzi
         A844YFmQDAVsi4VgYV+/3XWZLrPocrY4IbjwyNT4GBEHxjLBNFi5jnqkDQeVTgeTRrF0
         DYFg1d1xxzw56SWa5Jk9cN+4xsxDTIxcxqucb6hDAd3d/66k6pYtPZNTWrx4s2J8rM7w
         3A6kzzQZZlb8Am/XzSueJwTzJo/5JvRxd/K9nqKNH0oc7XBqKdheXxrgTDBgViJeJIT7
         Ki/w==
X-Gm-Message-State: AOAM530pNSog8EckG3LY16yI++htlCtSBX8y0ryCGfkY1rZswcVyeJHY
        C4otmdnvCTZfOAQqWdRBLW4sKw==
X-Google-Smtp-Source: ABdhPJzQheY8hh+c2jPwntFjfV62RpaVDCD04oY7VjALdEnTr5RuNzE83IP/tjylmq1hCPS0rgIoTQ==
X-Received: by 2002:a5d:824b:: with SMTP id n11mr2322787ioo.27.1607463202778;
        Tue, 08 Dec 2020 13:33:22 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d18sm6383019ilo.49.2020.12.08.13.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:33:22 -0800 (PST)
Subject: Re: problem booting 5.10
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        John Garry <john.garry@huawei.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
 <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
 <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
 <CAHk-=wi=Xs6K7-Yj83yoGr=z5fTw+=MUHrLpFJZ0FOeHA2fjuA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <22f9a723-aaba-3a1b-b2bc-3f1d82840dd7@kernel.dk>
Date:   Tue, 8 Dec 2020 14:33:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi=Xs6K7-Yj83yoGr=z5fTw+=MUHrLpFJZ0FOeHA2fjuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/20 2:25 PM, Linus Torvalds wrote:
> [ Just re-sending with Jens added back - he's been on a couple of the
> emails, but wean't on this one. Sorry for the duplication ]

Don't think I was, but gmail shows me the rest of the thread now.

> On Tue, Dec 8, 2020 at 1:23 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> On Tue, Dec 8, 2020 at 1:14 PM John Garry <john.garry@huawei.com> wrote:
>>>
>>> JFYI, About "scsi: megaraid_sas: Added support for shared host tagset
>>> for cpuhotplug", we did have an issue reported here already from Qian
>>> about a boot hang:
>>
>> Hmm. That does sound like it might be it.
>>
>> At this point, the patches from Ming Lei seem to be a riskier approach
>> than perhaps just reverting the megaraid_sas change?
>>
>> It looks like those patches are queued up for 5.11, and we could
>> re-apply the megaraid_sas change then?
>>
>> Jens, comments?
>>
>> And Julia - if it's that thing, then a
>>
>>     git revert 103fbf8e4020
>>
>> would be the thing to test.

Ming's series is queued up for 5.11, so if the revert does show that
this is indeed the issue (and it sure looks like it), then I'd suggest
we simply revert this commit from 5.10 and we can revisit after the
merge window opens and Ming's patches are in anyway.

-- 
Jens Axboe

