Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308FAECAAD5
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 15:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiIFPFT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 11:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiIFPEz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 11:04:55 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20AF1B7AC;
        Tue,  6 Sep 2022 07:19:51 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id r12so2295447pfl.10;
        Tue, 06 Sep 2022 07:19:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8z+ngUdgRfZSNBd8l0oMIcTPjlLmd2UOWV/IwBCVAfU=;
        b=p+8PH4SH5P4k0l/GnRHFkZNZG1JQn3N/83GpgO+3gAnuUA4nEPIvwBMqy5Bo46eSw+
         f/4i9EzXVA3hhpwdeJXNNahHjQssXF0WhGqGV3/fF5jKodHP9/gVNM9K6/sNXI3eRv+j
         3lKmdC4zYLgVgLHkXCPALPGJpRnKcDHUzCHkh0mvIzBvg+abLwv61tbk4Y7Yn46gme9M
         Kll3l5W33LA1fCtKn/zvZ6VN9o1rydoIm5Yl8WPpII+yqg8mTTivWzp2R3bpuV40y7ZE
         GTNHebbntddrB8bUeDlKFa8162574UWJJn7vpGhevt3ok4+MYLNu1Ly1QtqFyFSnXUHV
         YzJQ==
X-Gm-Message-State: ACgBeo1H3qaDqOY15p+AF6y1pEtuyw5BNhFc3FLuybmMxNJ06t5cy4Tk
        m8cS0yxFNdodrN8Z2dXUr2U=
X-Google-Smtp-Source: AA6agR6XOdN2aEBhWvd4c7pK+bXTS/Ch8bb+Y6PEzCwePrt21LVWKFUu9naCrelNpPV7MTJyZP2hVA==
X-Received: by 2002:aa7:9f82:0:b0:538:5e1e:86dc with SMTP id z2-20020aa79f82000000b005385e1e86dcmr40711351pfr.54.1662473886337;
        Tue, 06 Sep 2022 07:18:06 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id z27-20020aa7991b000000b005385e2e86eesm9608397pff.18.2022.09.06.07.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 07:18:05 -0700 (PDT)
Message-ID: <97f7a666-39b5-0132-368d-06985436c377@acm.org>
Date:   Tue, 6 Sep 2022 07:18:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [Bisected] Disconnecting pendrive with opened files causes
 trouble on 6.0.0-rc3
Content-Language: en-US
To:     =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, adrian.hunter@intel.com,
        martin.petersen@oracle.com, jaegeuk@kernel.org,
        michael.christie@oracle.com, hch@lst.de, ming.lei@redhat.com,
        hare@suse.de, john.garry@huawei.com
References: <fbd28a8c-858d-8891-f6be-a5c2ca3131da@o2.pl>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fbd28a8c-858d-8891-f6be-a5c2ca3131da@o2.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/4/22 11:28, Mateusz Jończyk wrote:
> I have bisected this down to
> commit 16728aaba62e ("scsi: core: Make sure that hosts outlive targets")
> 
> With the previous
> commit fe442604199e ("scsi: core: Make sure that targets outlive devices")
> the problem does not happen.

Hi Mateusz,

A revert for the patch series "Call blk_mq_free_tag_set() earlier" has been
queued and is expected to be sent soon to Linus. See also
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=6.0/scsi-fixes

Thanks,

Bart.


