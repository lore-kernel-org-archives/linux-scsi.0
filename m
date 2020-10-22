Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2C8C55179
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2AD124199
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507500AbgJVA3s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:29:48 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35375 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442502AbgJVA3s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:29:48 -0400
Received: by mail-pj1-f68.google.com with SMTP id h4so42743pjk.0;
        Wed, 21 Oct 2020 17:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dUeNcD/rSVmf+Pk8OZBPYlT6SvQDBlvdiZtGeA8kpo=;
        b=QbnuY3VDB5iJ4A5Br6LI4Y+ZMPFpf31RCjMyJmqHUzwgypfZlTl9y1lXb43qIfEA09
         lSL+lEVaHNKB2u4hTRPkKTYlOEtWHANDKY2W0Os6NvZvjffNu+wPMJ13o9W5Sf10Eb9z
         6I+ni13o3fM+fRBNo50B0aw17Okifk5SgS4/dH7UNmLbcDMIp3yl+MJbDnyXZogxjrRy
         2P6mQKVn42URyIKi0HaEhXMUPTHp1pgLw+CNa0j4Y6+cZnSw3q17eLviFf82X/CXiD2D
         eL1Bju3dHid40By2Va1MOwmGSv51pKZWayQb5xt9ho988JNkDAHTIMLKibXdjcDb4xfq
         l/wg==
X-Gm-Message-State: AOAM530qzJIKBayP/u4aH4dInKR51iZHMPZKppDCHXDQTM8Y0D6GB5U+
        Cr6qZd7lZWT/YqP0iEi7OJ2l7gtLjXIbHg==
X-Google-Smtp-Source: ABdhPJx6NsM5oFnZfxk3dgaLC4TTcwI+hFU8KC1uwTTWY05T+0vy9BUy7doYcb1o7SwRfCul3xGtHQ==
X-Received: by 2002:a17:902:501:b029:d2:628a:d59f with SMTP id 1-20020a1709020501b02900d2628ad59fmr153897plf.43.1603326586805;
        Wed, 21 Oct 2020 17:29:46 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y13sm3382123pfr.209.2020.10.21.17.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 17:29:45 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
To:     "chanho61.park" <chanho61.park@samsung.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d@epcas2p2.samsung.com>
 <20201020070516.129273-1-chanho61.park@samsung.com>
 <7fafcc82-2c42-8ef5-14a6-7906b5956363@acm.org>
 <000a01d6a761$efafcaf0$cf0f60d0$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0a5eb555-af2a-196a-2376-01dc4a92ae0c@acm.org>
Date:   Wed, 21 Oct 2020 17:29:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <000a01d6a761$efafcaf0$cf0f60d0$@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/20 9:23 PM, chanho61.park wrote:
> Did you mean /dev/disk/by-[part]label/ symlink? It's quite reasonable to
> use them by udev in userspace such as initramfs but some cases does not use
> initramfs or initrd. In that case, we need to load the root
> device(/dev/sda[N]) directly from kernel.

Please use udev or systemd instead of adding code in the UFS driver that is
not necessary when udev or systemd is used.

Thanks,

Bart.

