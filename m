Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0549C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 17:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3428613C6
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 17:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhEDRGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 13:06:16 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:40453 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhEDRGP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2021 13:06:15 -0400
Received: by mail-pf1-f176.google.com with SMTP id x188so6259134pfd.7
        for <linux-scsi@vger.kernel.org>; Tue, 04 May 2021 10:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=04fNtBwv2O7s4S5bq16dNkM3p33JTWrNLFaXeSWwqfk=;
        b=j6Uud4MUXrslF8/BIDZGR4TZ/7XFGHeRQjAPbTOBbVXeef7OFUzuizEALkS8zOO7Ed
         AZqjIqeYwmSOYbIKVy8oTlREujNcPgi2Z4gsHOmO6jB8eFLDU1JGNS5249sSrjoFK7t6
         1La8Ua+3gSkjBc2UvdPPFa+875j+uOZU1lBexXIp7FrNBzoBP3geaP0JAOxPiLGvVN/R
         VAJ3PAwDvhFMUskWxxiMowKnTxi2hX1Xg533UL0OWo0VbCkiGkaPJ7/SAuKpLFbwB653
         IZChwxceTIV+6EM7/DcK9nBf2/c6gRdy2K7b4XXPYXzb3zqheuP86Bu6wEEzg17nwIVt
         g4Gg==
X-Gm-Message-State: AOAM533FRA0P3nrgwfRm+OTzijLlxX4jw4fGZcXGRqdKw5evDRATZi5J
        tiv8DAwUdcuLWPhTlXzFBFgqAqw7Wks=
X-Google-Smtp-Source: ABdhPJznASMpBZ9+rwCafrDiSg8jL97csDEPCoz7fB049Mvhen8DUuaYtGsRfUwg/4RGXEcqxwZkgw==
X-Received: by 2002:a17:90b:1b03:: with SMTP id nu3mr6241234pjb.62.1620147919918;
        Tue, 04 May 2021 10:05:19 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o21sm4315724pgd.63.2021.05.04.10.05.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 10:05:19 -0700 (PDT)
Subject: Re: [PATCH 3/3] fnic: check for started requests in
 fnic_wq_copy_cleanup_handler()
To:     Martin Wilck <mwilck@suse.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210429122517.39659-1-hare@suse.de>
 <20210429122517.39659-4-hare@suse.de> <YIrD87Ekh3xBqE6u@T590>
 <8c971d37-e1ae-246f-9b9a-8170c76276b1@suse.de>
 <1f62775363a5e9050b1a660ae5b114868dbbb9bc.camel@suse.com>
 <YJEAlV3IQ6HQL9jU@T590>
 <00b7270360f6427e752f941a9e8ae04df05c3a1f.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2a826fa4-4814-b588-8c6f-23bc14afec05@acm.org>
Date:   Tue, 4 May 2021 10:03:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <00b7270360f6427e752f941a9e8ae04df05c3a1f.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 1:57 AM, Martin Wilck wrote:
> No, I can't. I haven't reviewed every caller. I thought about the
> function's documentation, which simply says "find the tagged command by
> host". Maybe I got this wrong.
> 
> You're right that returning non-in-flight requests makes no sense for
> drivers calling this function in the request completion code path.
> 
> The situation was a bit different until recently, when drivers used
> scsi_host_find_tag() also for iterating over commands. The commit
> message of e73a5e8e8003 stated that it avoids 'random errors' in this
> case; I am not sure if that's actually the case. I can at least imagine
> that a driver would want to abort or otherwise invalidate requests even
> if they're not in flight yet (e.g. when shutting down a controller).
> As the drivers have now been fixed to use blk_mq_tagset_busy_iter(),
> there's no need to discuss this further.

Unless if there is a strong argument I'd like to keep commit
e73a5e8e8003 ("scsi: core: Only return started requests from
scsi_host_find_tag()"). I think that commit implements the behavior that
is needed in the completion path of SCSI LLDs.

Thanks,

Bart.
