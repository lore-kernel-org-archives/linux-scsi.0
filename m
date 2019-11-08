Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13259FA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E766221924
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKHQWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 11:22:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41368 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfKHQWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 11:22:25 -0500
Received: by mail-pg1-f196.google.com with SMTP id h4so4249276pgv.8;
        Fri, 08 Nov 2019 08:22:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=en9WUJ9X89SjjF9CTlrCmTNQeXUESwNxqFVmQoqItkE=;
        b=nSbUCRi1kj4nRnTw25WBT+FM39CSmgTi2pKpHe5XC+pysucudSkWTkmKfRreaAi/ZI
         Rv2Z8bjfUlEi9+eB/S7QcqZB2P3ByS/IfKvi5W78HvGcg4Bop0Bylq/3kJy2ZoffiLPi
         3CHWKk4zh3+BTGS5v7IbnxR5mOKJwXwRHftFRVyBeAZ7xeV5U6MDpu9vYHLd/U+bblZn
         bJaDCnlyLoiq1wu19OiJEhwEKnp7SeGihwjKUa5hZ6lyqb/xUknecM5pQ2fmylzrVZrJ
         9AZm80kOe57SOOdkdVeBXX33SvMdxqXcRD4G0QV1fR/YnfBWrw3PZoGgESLk9Q6umA/0
         CneQ==
X-Gm-Message-State: APjAAAV/Xt9/8aOI3pINU7VJI2MVA1CuBvyFQALTdsEcl6+q7G/5fdwH
        NeFyLh6a5MZs2PPXaVUlGXc4f/By
X-Google-Smtp-Source: APXvYqz1smKpDvlxCnH61v80JypNc65JkLbpYRS0BmaRwZyFC1HHApW3z1nUF4hmETSJ+yP4Ip8gMw==
X-Received: by 2002:a63:fb15:: with SMTP id o21mr12764111pgh.193.1573230144217;
        Fri, 08 Nov 2019 08:22:24 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a21sm6120297pjq.1.2019.11.08.08.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 08:22:23 -0800 (PST)
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
Date:   Fri, 8 Nov 2019 08:22:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108082901.417950-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/19 12:29 AM, Damien Le Moal wrote:
> Prevent recursion into the IO path under low memory conditions by using
> GFP_NOIO in place of GFP_KERNEL when allocating a new command with
> tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().
> 
> Reported-by: Masato Suzuki <masato.suzuki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> 
> Changes from v1:
> * Added reported-by tag
> 
>   drivers/target/target_core_user.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

The patch subject is weird. Shouldn't the patch subject start with 
"tcmu" instead of "target: core"?

Has the recursion mentioned in the patch description been observed or is 
this a theoretical issue? I'm asking this because GFP_NOIO only prevents 
recursion if it is used inside a block driver or filesystem. The tcmu 
driver is neither - it submits block I/O or filesystem I/O instead of 
implementing a block driver or filesystem. Should we really disallow 
tcmu to use the swap subsystem?

Thanks,

Bart.

