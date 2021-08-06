Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0899FC4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 16:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB273611C5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 16:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhHFQhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 12:37:31 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:40926 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbhHFQh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 12:37:27 -0400
Received: by mail-pl1-f178.google.com with SMTP id c16so7799527plh.7;
        Fri, 06 Aug 2021 09:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eed/Vd3ZBT9dv64+e9iMg0kWdbsU8GjPWvNnrpC/C8E=;
        b=tWrJ6dA/dUgxl+IRrplbCyZE81g6Gv+A8E9xUUxNeCyraR/CigvrHJpkn4px9Aomsu
         VQSS36sbVTJ7vLuQJ56H+agQrH/ewJB9jedRuF1zK+N3Kv1R4wT9GWYDjIDRvXHt/PkW
         J//1oRR5lyhM4BzNFbJJP6LJFtSgDpmnjHe3KJrNOt/h2/SiWKbAhNiB8KTcx9UDHVty
         Se5SKuedrw23MT1LPOdYpE9x+7U7il4qU98Rh4VcLhi4vLRiCAkF8qHMlOAKiU2MBXrr
         n9Uo7bfskTVkx8ahQaQX4leqDOe/E+kFKEy0rwi+tUGDXfKOt6kA/sjURG3a6T4NhxF9
         Y50w==
X-Gm-Message-State: AOAM532aL+OzMXjOKGvVFiP+7oh/oc6fEizHQ5A5QfO9kANPbVhg9MWP
        JVXv6JXRgphxrUBTY732E8o=
X-Google-Smtp-Source: ABdhPJzPQEemJ4Am+DbnjqKSEA3yj1+ohkfrn7pTVLXUr06oO0E/U9yYFQ/EsewFrG7SnkI+W+szwA==
X-Received: by 2002:a17:90a:d308:: with SMTP id p8mr11396925pju.65.1628267831025;
        Fri, 06 Aug 2021 09:37:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:1655:15af:599e:3de1])
        by smtp.gmail.com with ESMTPSA id y4sm9601666pjw.57.2021.08.06.09.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 09:37:09 -0700 (PDT)
Subject: Re: [RFC PATCH v1 2/2] scsi: ufs: ufs-exynos: implement exynos isr
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <cover.1628231581.git.kwmad.kim@samsung.com>
 <CGME20210806064925epcas2p2ba7e711758614384c17648d4924d025c@epcas2p2.samsung.com>
 <7d2030d91425a01f964f7a9309c1aa3a0ce6a2d6.1628231581.git.kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <597a96f4-9cd4-c1bb-5c8d-dd5d00f0948d@acm.org>
Date:   Fri, 6 Aug 2021 09:37:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7d2030d91425a01f964f7a9309c1aa3a0ce6a2d6.1628231581.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/21 11:34 PM, Kiwoong Kim wrote:
> Based on some events in the real world

Which events? Please clarify.

> I implement
> this to block the host's working in some abnormal
> conditions using an vendor specific interrupt for
> cases that some contexts of a pending request in the
> host isn't the same with those of its corresponding UPIUs
> if they should have been the same exactly.

The entire patch description sounds very vague to me. Please make the 
description more clear.

> +enum exynos_ufs_vs_interrupt {
> +	/*
> +	 * This occurs when information of a pending request isn't
> +	 * the same with incoming UPIU for the request. For example,
> +	 * if UFS driver rings with task tag #1, subsequential UPIUs
> +	 * for this must have one as the value of task tag. But if
> +	 * it's corrutped until the host receives it or incoming UPIUs
> +	 * has an unexpected value for task tag, this raises.
> +	 */
> +	RX_UPIU_HIT_ERROR	= 1 << 19,
> +};

The above description needs to be improved. If a request is submitted 
with task tag one, only one UPIU can have that task tag instead of all 
subsequent UPIUs.

>   	hci_writel(ufs, UFS_SW_RST_MASK, HCI_SW_RST);
> -
>   	do {
>   		if (!(hci_readl(ufs, HCI_SW_RST) & UFS_SW_RST_MASK))
> -			goto out;
> +			return 0;
>   	} while (time_before(jiffies, timeout));

Since the above loop is a busy-waiting loop, please insert an msleep() 
or cpu_relax() call.

> +	 * some unexpected events could happen, such as tranferring
                                                         ^^^^^^^^^^^
Please fix the spelling of this word.

Thanks,

Bart.
