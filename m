Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3211CC47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 16:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1349E61184
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 16:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbhE0Qlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 12:41:49 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:43874 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbhE0Qli (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 12:41:38 -0400
Received: by mail-pf1-f172.google.com with SMTP id d78so992262pfd.10;
        Thu, 27 May 2021 09:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GOs4o9P7MW3xf962v8OmDYwflfOn7MeLduQg4KcUsT0=;
        b=U22bmK+LVnSA+5I+gGqG1cqsZ4Keb/8QKkfxXprlztXC3wVAF38eJznm5sQ+WEUKks
         KbZwQNbg5iuullgzYBwKWOshVakJ9onplMmBhLgV+TEV1Kk1hpVhjRAE8liGn7jcPGPx
         icKCLEEJVSUW9ZDQAKW+pCfozIIR8cazWp7laQMyBfPGh4US91sC1go7aLfJnvbLGxT7
         KI8GGS1hO9JLa6DJY8ge1TsIsp/t9JzFWRe2xaGS/2D+QVT8P2wcHkBO8zPpzYEvDtLt
         OshUudSUklkEuivslq1sY/Y2y55L/Yo52yu+uqTG6UlJnKsw7Nm9q92dyWMHUvyU4X/B
         vndg==
X-Gm-Message-State: AOAM530NvNYKZFqPKgoWRvrI+IZjyrE0f7eCXtK/hGR+gGBsihIa0c7S
        XoKkK/VRWwfOLIOc5016o+k=
X-Google-Smtp-Source: ABdhPJwbfxTATuefsWErJl+Gh57yZEu0Gu9XBSoM5TvDzN8zvmBF8bILXrEm9w8Gg3LWVWUJr4KPbg==
X-Received: by 2002:aa7:8f37:0:b029:2db:551f:ed8e with SMTP id y23-20020aa78f370000b02902db551fed8emr4478007pfr.43.1622133604807;
        Thu, 27 May 2021 09:40:04 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g15sm2122855pfv.127.2021.05.27.09.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 09:40:04 -0700 (PDT)
Subject: Re: [PATCH 0/3] Add quirk to support exynos ufshci
To:     jongmin jeong <jjmin.jeong@samsung.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, cang@codeaurora.org,
        beanhuo@micron.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
References: <CGME20210527031217epcas2p44b9d999edcc55b345dfd0749acefeaec@epcas2p4.samsung.com>
 <20210527030901.88403-1-jjmin.jeong@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8bc342ef-b434-6a56-97e8-582a6588e920@acm.org>
Date:   Thu, 27 May 2021 09:40:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210527030901.88403-1-jjmin.jeong@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/26/21 8:08 PM, jongmin jeong wrote:
> In ExynosAuto(variant of the Exynos for automotive), the UFS Storage needs
> to be accessed from multi-OS.
> To increase IO performance and reduce SW complexity, we implemented UFS-IOV
> to support storage IO virtualization feature on UFS.
> 
> IO virtualization increases IO performance and reduce SW complexity
> with small area cost. And IO virtualization supports virtual machine isolation
> for Security and Safety which are requested by Multi-OS system such as
> automotive application.
> 
> Below figure is the conception of UFS-IOV architeture.
> 
>     +------+          +------+
>     | OS#1 |          | OS#2 |
>     +------+          +------+
>        |                 |
>  +------------+     +------------+
>  |  Physical  |     |   Virtual  |
>  |    Host    |     |    Host    |
>  +------------+     +------------+
>    |      |              | <-- UTP_CMD_SAP, UTP_TM_SAP
>    |   +-------------------------+
>    |   |    Function Arbitor     |
>    |   +-------------------------+
>  +-------------------------------+
>  |           UTP Layer           |
>  +-------------------------------+
>  +-------------------------------+
>  |           UIC Layer           |
>  +-------------------------------+
> 
> There are two types of host controllers on the UFS host controller
> that we designed.
> The UFS device has a Function Arbitor that arranges commands of each host.
> When each host transmits a command to the Arbitor, the Arbitor transmits it
> to the UTP layer.
> Physical Host(PH) support all UFSHCI functions(all SAPs) same as conventional
> UFSHCI.
> Virtual Host(VH) support only data transfer function(UTP_CMD_SAP and UTP_TM_SAP).
> 
> In an environment where multiple OSs are used, the OS that has the leadership of
> the system is called System OS. This system OS uses PH and controls error handling.
> 
> Since VH can only use less functions than PH, it is necessary to send a request
> to PH for Detected Error Handling in VH. To interface among PH and VHs,
> UFSHCI HW supports mailbox. PH can broadcast mail to other VH at the same time
> with arguments and VH can mail to PH with arguments.
> PH and VH generate interrupts when mails from PH or VH.
> 
> In this structure, the virtual host can't support some feature and need to skip
> the some part of ufshcd code by using quirk.
> This patchs add quirks so that the UIC command is ignored and the ufshcd init
> process can be skipped for VH. Also, according to our UFS-IOV policy,
> we added a quirk to the abort handler or device reset handler to call
> the host reset handler.

More information is needed about how multiple operating systems share a
single UFS device. Are LUNs shared across operating systems, does each
OS access separate LUNs or does each OS access different partitions on
the same LUN? Do you agree that for the latter two it is not necessary
to provide the virtual host access to the UTP layer?

Bart.
