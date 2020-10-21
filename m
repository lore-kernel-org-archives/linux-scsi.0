Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAAEC4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 03:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2339222249
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 03:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411609AbgJUDPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 23:15:18 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:43493 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406162AbgJUDPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 23:15:18 -0400
Received: by mail-pg1-f169.google.com with SMTP id r10so584998pgb.10;
        Tue, 20 Oct 2020 20:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zLK0ORafK0KDpva8BzNX2/lsIVw44lu8GrUhiNwTfW8=;
        b=kxlQCY4nmfmQzjd3W1R6V0BojSYmM2uiqBZHxVyMS/p12vSdT8/yqIv/z7T60kLLNB
         0OLUPqp+0HNjJ7iawvZtZldvsGbGkc/I9uaeHCqf69i8r5p04eN8dumAGCIU6wkMdkE6
         3RtMs2CpeWYm5MfKtzKxsVLAC0NXn7wRFSFVDLLL5GAdxxwi1CPZxaklf6CgdJYHElpI
         Gl+zp08rODIleOthIvWqG/4DI4429h3m4J8P6jVejWx2YYbtC/4NEZx0MGpAcg5uHDfj
         LZJqNFhiVpbUGHHDsa9pbH1jRKuW75M6X3adrxLyWMoaMiNjkeHKkp/ZzFBcoVXoUlZl
         sbnw==
X-Gm-Message-State: AOAM530xlSlDYeBjUx7tixSuE6YZIvCL8olP001/c9sdrf5h6SDPTV8g
        cvlIXE5H+4muEm4BY1TDK5Mhol6E4oMDyw==
X-Google-Smtp-Source: ABdhPJzG/0VYHS2eerxHf9q9IwkM45s/NnCsva7zXxw9WRxmdfOLjU4TkhshqtlRQCbphLoYb7WgrQ==
X-Received: by 2002:aa7:9a4a:0:b029:155:323e:adae with SMTP id x10-20020aa79a4a0000b0290155323eadaemr1138878pfj.70.1603250117184;
        Tue, 20 Oct 2020 20:15:17 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id m13sm443682pjl.45.2020.10.20.20.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 20:15:15 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
To:     Chanho Park <chanho61.park@samsung.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d@epcas2p2.samsung.com>
 <20201020070516.129273-1-chanho61.park@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7fafcc82-2c42-8ef5-14a6-7906b5956363@acm.org>
Date:   Tue, 20 Oct 2020 20:15:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201020070516.129273-1-chanho61.park@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/20 12:05 AM, Chanho Park wrote:
> By doing scan as asynchronous way, scsi device scannning can be out of
> order execution. It is no problem if there is a ufs host but the scsi
> device name of each host can be changed according to the scan sequences.
> 
> Ideal Case) host0 scan first
> host0 will be started from /dev/sda
>  -> /dev/sdb (BootLUN0 of host0)
>  -> /dev/sdc (BootLUN1 of host1)
> host1 will be started from /dev/sdd
> 
> This might be an ideal case and we can easily find the host device by
> this mappinng.
> 
> However, Abnormal Case) host1 scan first,
> host1 will be started from /dev/sda and host0 will be followed later.
> 
> To make sure the scan sequences according to the host, we can use a
> bitmap which hosts are scanned and wait until previous hosts are
> finished to scan.

This sounds completely wrong to me. No code should depend on the order in
which LUNs are scanned. Please use the soft links created by udev instead
of serializing LUN scanning.

Thanks,

Bart.
