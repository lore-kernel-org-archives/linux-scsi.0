Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3054C6FA82
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 15:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbiIZPyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 11:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbiIZPyO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 11:54:14 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB8397B0C
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 07:41:40 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id g8so5436773iob.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 07:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=k+bNrBOkz7J5I/U3tfdFW68L9IU+eq1o0F5bYCHeShE=;
        b=KxG6NDdhHIZwR1XoVLdH5nitEfjTRC1pvN7c3TPSSqAS6FKCFPyrabhhR1uf9InP1l
         CBcRxAEr+ICU8HvlADa07We8mBADg4dvVknQsAF4tSKII1bxdL/57CjZAAYss0W4d9c1
         DANcSEJsXWWvj8TNABwryOFXa8yHn+W2uee8AokrleMAlzz8iSTcBVdEl0oLB+Vb3zI8
         UiHljPSOXbVFXqv803pKcFSTGemLP/qW7tsJza64o2QYJvVrda1WT3Ti6VPDJwzZerrl
         3CxrPryIupCGZOP/jiZ+UuOBLT+Ztw5x50BDB5yX2xJtqqZMHs30mRYrSJnDDgNnAIVl
         F5eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=k+bNrBOkz7J5I/U3tfdFW68L9IU+eq1o0F5bYCHeShE=;
        b=wY5F7uHKM/pTs+lWT0KqBuE0LkStck+zFOYuFT6eqpaabw0ABJLrjOLkbmy1O0AxPj
         dgnR0UtOyKq88KcvxJrk5xkww2KZeETVPwDAnyu0d0rFbN01O90zRLdRjTBGckcaHgLM
         MsDVU8ZaRrfl+psBnBK+xVpcNItPyf5wa/O0STwhY/RwGU8H0ibGPGdI6w+Z4Sl6kTLh
         JksGCEg6KiS/SQ7ivvZN8n1b5O31aX+buRqDZ7+QeY9x41KdgaZHj042UuaD9izri2iA
         6bNIn1LfwYxkdv5gAKD7rO7t8y21pspqFOqzY7pNWDk3BEOAl6BOyqNyvBeXBMgTOxEM
         oVtg==
X-Gm-Message-State: ACrzQf2alEVvfiS6EV7SDhNe0F+hWMJf03KY7PtDL94a44ueP9dy9O36
        +kK6YxUhcxke6lc1GSgB/Cs0LA==
X-Google-Smtp-Source: AMsMyM76CCQsz6YIyMEtt6BslnsWjMtjauQWuveAF39q5APdh5N7VWcKVGqtLK9Mm/u/6W25LaMDGA==
X-Received: by 2002:a05:6602:3c1:b0:6a4:16a0:984b with SMTP id g1-20020a05660203c100b006a416a0984bmr7525590iov.125.1664203299800;
        Mon, 26 Sep 2022 07:41:39 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q48-20020a056638347000b003583a010e85sm7041438jav.94.2022.09.26.07.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 07:41:39 -0700 (PDT)
Message-ID: <69598e37-fb91-5b92-bb80-b68457a7b6f8@kernel.dk>
Date:   Mon, 26 Sep 2022 08:41:38 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YzG5/1zSdiMlMLnB@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/22 8:41 AM, Christoph Hellwig wrote:
> On Fri, Sep 23, 2022 at 02:52:54PM -0600, Jens Axboe wrote:
>> For both of these, how about we just simplify like below? I think
>> at that point it's useless to name them anyway.
> 
> I think this version is better than the previous one, but I'd still
> prefer a non-anonymous union.

Sure, I don't really care. What name do you want for it?

-- 
Jens Axboe


