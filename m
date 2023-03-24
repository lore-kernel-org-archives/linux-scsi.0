Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46DFC6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 19:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjCXTpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjCXTpL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 15:45:11 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC236191;
        Fri, 24 Mar 2023 12:45:11 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso2646651pjb.3;
        Fri, 24 Mar 2023 12:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679687110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mzEyCZHLH4Zfj5DYk4naroNB2YGbHeAPk3MJAB81cn0=;
        b=yXz+9p/Qy/Tq7riURNiqm2h2hiOP1jYAfB94Y+iHlVKve4R5aQUQ+6zYppamjldXdA
         XG1NA3P76rmv+wWJXCeRTmYrgC0tdKht6HTjl1y7v4ntqlTWjFj7qIGDQu2KIvRW97hk
         Pe4E6WtjHL1xuQRpJGKTe7cTho/drgWKGT1U2sQGmb0vu9/gDE3ozkLNltM3cDW7x3H9
         8rAFEX7W/04Lag5zPpKCXh311NNUe02dwdRzEhuu2jvgAQxUyDhhnCNsDugjImNw6H2H
         nTtzc6mC+wSrIl0ZyNXOAAIxvnsuVi+HAi6vnJeSYSz4OGrERgCNCc0AWtwE1yX3+riq
         nTEw==
X-Gm-Message-State: AO0yUKUYnzwt98uDVrM/PEKR/Sp0JPWAsdvCavyaxSC8tXnQADG2ta5A
        Wg3i55nX+EENAYUn1BtuXlE=
X-Google-Smtp-Source: AK7set+WBcQsEOXCQ/txqOh9eErFNTaYEWF2xegD7KrWmJzmFiNv92WvD5FLTUar7NcICYJm6jYnKg==
X-Received: by 2002:a05:6a20:7a98:b0:cc:868f:37b3 with SMTP id u24-20020a056a207a9800b000cc868f37b3mr3618846pzh.58.1679687110519;
        Fri, 24 Mar 2023 12:45:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:386d:2249:7df8:ecf? ([2620:15c:211:201:386d:2249:7df8:ecf])
        by smtp.gmail.com with ESMTPSA id a14-20020a62e20e000000b00625d84a0194sm14306035pfi.107.2023.03.24.12.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:45:09 -0700 (PDT)
Message-ID: <0dfa3352-cdca-90c1-a6c9-ea4a4c85dfa1@acm.org>
Date:   Fri, 24 Mar 2023 12:45:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 01/18] block: Add PR callouts for read keys and
 reservation
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-2-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230324181741.13908-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/24/23 11:17, Mike Christie wrote:
> Add callouts for reading keys and reservations. This allows LIO to support
> the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
> to optimize it's error handling so it can check if it's getting an error
> because there's an existing reservation or if we need to retry different
> paths.
> 
> Note: This only initially adds the struct definitions in the kernel as I'm
> not sure if we wanted to export the interface to userspace yet. read_keys
> and read_reservation are exactly what dm-multipath and LIO need, but for a
> userspace interface we may want something like SCSI's READ_FULL_STATUS and
> NVMe's report reservation commands. Those are overkill for dm/LIO and
> READ_FULL_STATUS is sometimes broken for SCSI devices.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
