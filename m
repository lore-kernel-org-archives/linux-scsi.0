Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D81C2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 16:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5422100A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 16:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="0MPDPZ7E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389084AbgKWQr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 11:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388731AbgKWQr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 11:47:28 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19019C0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 08:47:27 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t37so14686285pga.7
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 08:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lsEvSSdUQFp0oECaRYk7+1ABbhEJMev6nFl4IALo0t8=;
        b=0MPDPZ7E7KUcYrttiouEUl/2pXo8dtrfB9R6izb3p9ndoStNBqVmRzsOVQKtK1S4Yk
         JKQGJswLHcMGRtczhRIXS16RKbvdEYZKhjYpJ2BnWw+OAKhuBAMM7JPRWUbivQdEqH5K
         j4grFoq/e7mUQtD3zo3h0kOr3ojUEeCes9a5ZnA/fwxYeUP39eFWZkxFlJVFkp8+Bbn8
         TCH+tjorEK9U78XOV3i5si4vXR5U8Raq7EPKxqYXdsZtKPZGWhpbi73IQM9bIo68RREn
         92HGg1I6x8NJURVxa3mg4NoW5fCXyV2UYbiMi6KH7KbraVWGi6TQlXnxw6YpORWloIe6
         LAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lsEvSSdUQFp0oECaRYk7+1ABbhEJMev6nFl4IALo0t8=;
        b=NVQQF6oW8UZFImWv5BNLgMKo7b9K6NGnPH+ucZht1jKeGy3zbgv5wr7rpLcrmIqyNi
         pe/1wNLCC+XBqM9d6FzC1cGvp0WIEcql6+fUHAGdpLlSEXnExiCWNZ5cK9i1Uk5c04kw
         pSGrTTXrMi/BB7SpWpNW5REq8lf3KxI6RE5QGbjQpSiKW9/5ggr9yhC2FwQJ82C2nJhR
         dI/3SVpd0SgBLvBspdAywWxK3egKzml4zhQoQDBkr8uB4y6WvCnuc/V/bFPJx+Gmdq20
         JBhtykheUhAkGZoZkUxf08Bhgbkh6Aa20Oxaw8/s5C5MEwAhJQChthqnjCUepfivO7NV
         TD3A==
X-Gm-Message-State: AOAM532IFljFBunHGuCk1Z4Y4Yf4dw7M7FoY4kLEo3NRWmk+prd3vXT8
        VOd179K8aVrLa7wHc5FerNKocg==
X-Google-Smtp-Source: ABdhPJzXXq2e/MpNzZe67SQdfQdx+TLLTFkq0HCZ+xRJjaUM9dXXmE+XrWPx8SdFNCNShRas3jpFzw==
X-Received: by 2002:a17:90a:e604:: with SMTP id j4mr668677pjy.19.1606150046494;
        Mon, 23 Nov 2020 08:47:26 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o198sm5576218pfg.102.2020.11.23.08.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 08:47:25 -0800 (PST)
Subject: Re: Potential double fetch in sg_scsi_ioctl()
To:     Alexander Potapenko <glider@google.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Dmitriy Vyukov <dvyukov@google.com>,
        Merna Zakaria <mernazakaria@google.com>,
        linux-scsi@vger.kernel.org, mengxu.gatech@gmail.com
References: <CAG_fn=V5LczhvXzU5D-NF1sDPF3sr_DfKi-RbyeTT175kcPVxw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f57364cb-481e-87bc-773a-f5e0057e7d7b@kernel.dk>
Date:   Mon, 23 Nov 2020 09:47:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG_fn=V5LczhvXzU5D-NF1sDPF3sr_DfKi-RbyeTT175kcPVxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/20 9:15 AM, Alexander Potapenko wrote:
> Hi Christof, Jens,
> 
> We've found a double-fetch in sg_scsi_ioctl() using a prototype tool
> (see the report below).
> 
> Turns out that sg_scsi_ioctl() reads the first byte of sic->data
> twice: first when getting the opcode
> (https://elixir.bootlin.com/linux/latest/source/block/scsi_ioctl.c#L439),
> then when reading the command of the size calculated from that opcode
> (https://elixir.bootlin.com/linux/latest/source/block/scsi_ioctl.c#L464).
> 
> At this point opcode and req->cmd[0] may mismatch.
> The opcode is then used to determine rq->timeout and req->retries,
> whereas req->cmd[0] is used by the underlying device drivers.
> Not sure invalid timeout or retries is a big deal, but since the
> command length also depends on the opcode, it is possible to trick the
> kernel into using the remnants of the previous command by first
> announcing a short command and then changing the opcode to a longer
> one.
> 
> I've noticed that three years ago Meng Xu has reported the very same
> bug already: https://patchwork.kernel.org/project/linux-block/patch/1505834638-37142-1-git-send-email-mengxu.gatech@gmail.com/
> Was there any followup to that patch?

Doesn't look like it - Christoph made a suggestion, and then the
original reporter didn't follow up. FWIW, I do agree that just copying
it once is a better idea than copying twice and then copying the opcode
again.

-- 
Jens Axboe

