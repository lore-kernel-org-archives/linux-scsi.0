Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7692CC6FA90
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 16:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiIZQDL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 12:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiIZQCg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 12:02:36 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B31AC39C
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 07:50:45 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id 138so5392306iou.9
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 07:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=pTDxk9oXLcyzLIlge9oEls0XIl60bM4FjSB09bCJi7I=;
        b=HYvDGszNu1gu6URMqy5VyPO0q1CjLZEc24iAopQm0fNr/8L0QweBd44p9s0Sy+yCiB
         ugqpaw+OzNCG5QFs9LmXrwSLt+OFDxXFtU4qrSW5Mq0MX75/UGFUftTXqK0UyXjEvFdh
         ZeP3ryaZrtP2yaocnW4b6ax+wiab+q3J3a23bPfNR12QrJRBe0vsqZMWHh4geLH+zGNv
         MdXBFXHKqXiFB0Dr9J4bRDOIJj2sfngS7KX7Y037Im/Fw/LEQdF6a5q6XT1ypWs7P+Jb
         JuwmSEAcV/ZQ4/YnWr3LwJEHbMHze15ZmdqBs68ASLe4yJWt1rSMDR4ipzZbTmfoTGpC
         6shg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=pTDxk9oXLcyzLIlge9oEls0XIl60bM4FjSB09bCJi7I=;
        b=XVzxrTFywln/ZL2FlZBFmxnncNtcWc03BJxBXBXf84jWZflFtjecZFX/mLhU0Xoe1j
         GNb2JspTZARn5ZQ00jd6JZ+aDnf0WQ8hUXkjWr23vICDVVDH8yuh4mv7hUdLoSa0Fd9K
         S84uU7/gaqH3Wwh67bAMcO7BceDLjaoVNMPmHMYMKKrhnyt2DzHjZ06Qqk6NGn5Sc0Vm
         Wmvar8eRcR4bYAJtc7kcQ9mdycEOrSiVD28qRL6jjfwu3WxKr+B9n91wVPp9skEeoEbC
         ypdwsbhiF+u0aPqNF/yu21hgdYos/dNW2RjclmAb3n5pM9Ok+onsqHFhZdUsfDjLrRVm
         MeXQ==
X-Gm-Message-State: ACrzQf30n17QtXodE8wFYeDOVSPgW61G9TdUq4XoN56LyYM5p8Fawh6c
        7xHF2t41EOKLLA7wmKDH3JI00918crjcHA==
X-Google-Smtp-Source: AMsMyM4ezesDcR/VrCIT8c4MqwXXAKedbbvzEcJmc1qxfhQgzw/YFvqad1860zJhGdYZ9FeErmdgJw==
X-Received: by 2002:a02:b681:0:b0:349:b7d5:7c25 with SMTP id i1-20020a02b681000000b00349b7d57c25mr11526271jam.228.1664203844319;
        Mon, 26 Sep 2022 07:50:44 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e21-20020a056602159500b0067ba7abc4cesm7638553iow.50.2022.09.26.07.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 07:50:43 -0700 (PDT)
Message-ID: <25b9899f-0c60-39f2-179b-789b914e0f0a@kernel.dk>
Date:   Mon, 26 Sep 2022 08:50:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4/5] nvme: split out metadata vs non metadata end_io
 uring_cmd completions
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, Stefan Roesch <shr@fb.com>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-5-axboe@kernel.dk> <Yy3O7wH16t6AhC3j@infradead.org>
 <d09e1645-919f-9239-f86d-a8e85a133e5c@kernel.dk>
 <YzG5/1zSdiMlMLnB@infradead.org>
 <69598e37-fb91-5b92-bb80-b68457a7b6f8@kernel.dk>
 <YzG6mZhtd/QysvdH@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YzG6mZhtd/QysvdH@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/22 8:43 AM, Christoph Hellwig wrote:
> On Mon, Sep 26, 2022 at 08:41:38AM -0600, Jens Axboe wrote:
>> Sure, I don't really care. What name do you want for it?
> 
> Maybe slow and fast?  Or simple and meta?

So you want 'result' in a named struct too then? Because right now
it looks like this:

struct nvme_uring_cmd_pdu {
         union {
                 struct bio *bio;
                 struct request *req;
         };
         u32 meta_len;
         u32 nvme_status;
         union {
                 struct {
                         void *meta; /* kernel-resident buffer */
                         void __user *meta_buffer;
                 };
                 u64 result;
         };
};

Or just the union named so it's clear it's a union? That'd make it

pdu->u.meta

and so forth. I think that might be cleaner.

-- 
Jens Axboe
