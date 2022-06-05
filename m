Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B660BC43334
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jun 2022 04:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiFEEBg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jun 2022 00:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiFEEBf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jun 2022 00:01:35 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955864D9CF;
        Sat,  4 Jun 2022 21:01:33 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id q123so10326385pgq.6;
        Sat, 04 Jun 2022 21:01:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kuBV28makeSJfzsiM72bJh6iWdW/+SIKOX/bljICWXs=;
        b=YzJOEeVDr2tehRbeWtQN1+yxNXrlSG9BRXvpmUEXqglbctnxn9CEXN3pblLsHIXy9j
         vjuqh6R8fDqY1IJXDwsYnMxcPa1fxL82SFOl7h7W/Bz3ifubsW/A1w/wM160idiINY2W
         ghedBMRPJta9Tc1Oj4946ttWBRon9A4uae10ktUFCtP9sz5A/dTyChjt5WA/npPMjdIq
         SQQU1aHs33bGbVeanPj3A76pZ+0SjmUBt4Tq+Y4ZjBiGvtDII6EnPE3XJeH7QpxbIB6Q
         5xc5iDQ7hBcMzvzCxWtJLrUzNTP/XdBukDyCQCqWYNHNdh+uph/F08grOTNQrJZyXiPL
         wjJw==
X-Gm-Message-State: AOAM530n0AOEss2OYNnrz84Smu5zQhdxDJCtlZ74NCm20otw31c1gBgv
        ZFtgWPHUHSnb2/WAJMbmU54=
X-Google-Smtp-Source: ABdhPJwYW0FtIavUiAKHq2ahwqUsR7QXrUYXGE2TjFS43H3ZZMXLSDtjSEEEhAGF0VfBDFPuWNQxzw==
X-Received: by 2002:a63:f5e:0:b0:3fd:23e1:e086 with SMTP id 30-20020a630f5e000000b003fd23e1e086mr9499008pgp.61.1654401692985;
        Sat, 04 Jun 2022 21:01:32 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b0015e8d4eb267sm8148225plp.177.2022.06.04.21.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jun 2022 21:01:32 -0700 (PDT)
Message-ID: <923053d3-adf8-e4b4-9ef3-8e920ae90a79@acm.org>
Date:   Sat, 4 Jun 2022 21:01:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [dm-devel] [PATCH 0/8] Use block pr_ops in LIO
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/22 23:55, Mike Christie wrote:
> The following patches were built over Linus's tree. They allow us to use
> the block pr_ops with LIO's target_core_iblock module to support cluster
> applications in VMs.
> 
> Currently, to use something like windows clustering in VMs with LIO and
> vhost-scsi, you have to use tcmu or pscsi or use a cluster aware
> FS/framework for the LIO pr file. Setting up a cluster FS/framework is
> pain and waste when your real backend device is already a distributed
> device, and pscsi and tcmu are nice for specific use cases, but iblock
> gives you the best performance and allows you to use stacked devices
> like dm-multipath. So these patches allow iblock to work like pscsi/tcmu
> where they can pass a PR command to the backend module. And then iblock
> will use the pr_ops to pass the PR command to the real devices similar
> to what we do for unmap today.
> 
> Note that this is patchset does not attempt to support every PR SCSI
> feature in iblock. It has the same limitations as tcmu and pscsi where
> you can have a single I_T nexus per device and only supports what is
> needed for windows clustering right now.

How has this patch series been tested? Does LIO pass the libiscsi 
persistent reservation tests with this patch series applied?

Thanks,

Bart.
