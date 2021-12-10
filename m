Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852A4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Dec 2021 17:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbhLJRpt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Dec 2021 12:45:49 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:42794 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhLJRps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Dec 2021 12:45:48 -0500
Received: by mail-pj1-f43.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so8117500pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2021 09:42:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x4uEfZSH8BdPbBHnokmArRQDG6aG22C+6N361beSqNU=;
        b=EF9VdcdBtukNzack8r8VlTyiu157FwGo3XYnSxlLjJ1MyY888A2xh4H4r5IigtgxUB
         h1Xx2a/jxClRuskqDPpyGTZh2mNpdKODsk/s3s2eFHI1U90BHP/QrBoJUfjg7ftnYnyE
         LU5T8n+BAnyb12qcP9w7t/X9liagWKBIfzeSPi5PVn2EsDB3Rm0/5f2WRzUqJL4FYz7Y
         eecnyu+DblACgqh19YaNZP/XT+cD/cujlvCNUsMT2U60WglBG+v7Ub2aZe7GnBmyMu9D
         dyGOk4JoYsZ3pm3V0kKjC7ztLAgFu6GhymVBncbot0GrsVGO7+JBBO1Rs4bP2BtkVCti
         D9GQ==
X-Gm-Message-State: AOAM532Xoh+SOhPTkWxCs909AsME1KTU+07Xyoh3Jkl9uPrae0KNkARr
        Sj5wofVZzx28TEo9pk+6t/aVHyJ9tZU=
X-Google-Smtp-Source: ABdhPJzbBBecdy5QhjU2tX3Txym/7Vi04x8gb1l2UIP0+ATSbFEjq2fMotsvCSwrjJbcOiPU4GDJRw==
X-Received: by 2002:a17:903:1c7:b0:141:e630:130c with SMTP id e7-20020a17090301c700b00141e630130cmr77666164plh.80.1639158133170;
        Fri, 10 Dec 2021 09:42:13 -0800 (PST)
Received: from ?IPv6:2620:0:1000:2514:85ed:ea0b:339:7b11? ([2620:0:1000:2514:85ed:ea0b:339:7b11])
        by smtp.gmail.com with ESMTPSA id m10sm3114366pgv.75.2021.12.10.09.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 09:42:12 -0800 (PST)
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b5002b52-3654-825c-f94f-f9ade708042e@acm.org>
Date:   Fri, 10 Dec 2021 09:42:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211126073310.87683-1-songyl@ramaxel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/21 11:33 PM, Yanling Song wrote:
> +config RAMAXEL_SPRAID
> +	tristate "Ramaxel spraid Adapter"
> +	depends on PCI && SCSI && BLK_DEV_BSGLIB
> +	depends on ARM64 || X86_64

Why is this driver restricted to ARM64 and X86_64 systems? What prevents
compilation of this driver on other CPU architectures?

> +	help
> +	  This driver supports Ramaxel spraid driver.

The help text is too short. Please add one or two sentences about the interface
type of this RAID controller (PCIe?) and also about the storage media supported
by this RAID controller (SAS? SATA? any other?).

> +struct spraid_bsg_request {
> +	u32  msgcode;
> +	u32 control;
> +	union {
> +		struct spraid_passthru_common_cmd admcmd;
> +		struct spraid_ioq_passthru_cmd    ioqcmd;
> +	};
> +};

Definitions like the above are required by user space software that uses the
BSG interface and hence should be moved into a header file under include/uapi/.
See e.g. include/uapi/scsi/scsi_bsg_ufs.h.

Thanks,

Bart.
