Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDA4C05027
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 01:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBBBG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 20:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBBBG0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 20:06:26 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE81B6A69;
        Wed,  1 Feb 2023 17:06:25 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso322965pjb.4;
        Wed, 01 Feb 2023 17:06:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7U/ZC/7mH3sydJX/MVCCCZAUEhdYO6ljg7mvo+RSKFs=;
        b=ZrlrVEZ8NRyped347qBbu3c/ejYT83nqUe6fmqnbNA+gLDphPU6HP7Mx3eiuVDxake
         L12fJxSLSUnnMgs1DUkrtwlEtyhXluG4kJleW7IGT8CeHqSf+qen5cRVoZBwFCdPR96X
         EuocOW8s1bWpJR49M/Lzz2lpO9MzG1oYK+X4A5aFK8Z+5Z8BVy2fMzNz1Ej7AbRFVJcf
         utOzQILsf7mqRhKELwpIbzTashWOWi7PVetlsqD9YzDW5kwUt7k6TEXYJ0oBD2cdiHoF
         K4cLpOWN9VexRsppPOYcfwpJAaMDos8iLZRedZEHIKpfZc6FdTYHCxM8KDv3PCVGGntU
         hDsg==
X-Gm-Message-State: AO0yUKVDzgiZrD+nMEmFOArHn3Q+cF+KT3V0b1Jlslz8xlpqbKgVoZoI
        bh0ep+J65Xbc0QIJaWxQP3U=
X-Google-Smtp-Source: AK7set91PfOxWXp7jnbumlVGRvclUWAHYMaUebcWZSbJrB6WUkYdkaumobI/3Ix1684OntcP+cof9A==
X-Received: by 2002:a17:90a:5:b0:230:2052:1c2 with SMTP id 5-20020a17090a000500b00230205201c2mr4582885pja.42.1675299985093;
        Wed, 01 Feb 2023 17:06:25 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:f3cf:17ca:687:af15? ([2620:15c:211:201:f3cf:17ca:687:af15])
        by smtp.gmail.com with ESMTPSA id bt21-20020a17090af01500b0021904307a53sm1964023pjb.19.2023.02.01.17.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 17:06:24 -0800 (PST)
Message-ID: <ea0eff5f-5c05-ebca-58a4-1e772a6fa739@acm.org>
Date:   Wed, 1 Feb 2023 17:06:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4 1/7] block: Introduce blk_mq_debugfs_init()
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-2-bvanassche@acm.org>
 <20230201205800.t3gpx7w3aw2ozab7@garbanzo>
 <20230201212332.p3mdb5ab3qisuo2x@garbanzo>
 <4c9b87dc-aeeb-43b6-0c18-4d04495683da@acm.org>
 <20230201235919.q5rhglvgw7uduexy@garbanzo>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230201235919.q5rhglvgw7uduexy@garbanzo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/1/23 15:59, Luis Chamberlain wrote:
> My point was commit 85e0cbbb8a made blk_debugfs_root non-null always now
> when debugfs is enabled for both request-based block drivers and for
> make_request block drivers (multiqueue). My reading is that with your
> patch blk_debugfs_root will not be created for request-based block
> drivers.

Hi Luis,

The empty version of blk_mq_debugfs_init() in my patch is only selected 
if  CONFIG_BLK_DEBUG_FS=n. I think that my patch preserves the behavior 
that /sys/kernel/debug/block/ is created independent of the type of 
request queues that is created. Am I perhaps misunderstanding your feedback?

Thanks,

Bart.
