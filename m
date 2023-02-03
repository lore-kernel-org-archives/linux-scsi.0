Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38A5C05027
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 20:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjBCUxb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 15:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBCUxa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 15:53:30 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B24ABD4
        for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2023 12:53:29 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id ge21-20020a17090b0e1500b002308aac5b5eso140602pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2023 12:53:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7XgB42Dr4UJyIkVr89/RbfU4Kx+trPS34tp6N/SSmPY=;
        b=YYIh5kU2OuajkN3B1L+VCJK4wtkOPrcmL7PGkTvg7furdio3awm8TsJD3ADn72INrW
         GQf8YRufHmEE2/PYcJQF8PKnGWXKReZ4ZFpW63zEfS7M1bspel6UNLmMLBS6f8IkkIsL
         P6yLe2mNvnF1wxCBkPEg2CbUgM547QGGC/H0Nk+DirqLkxdZXID2cZD/I16S3+dEmEx5
         9A2N0z3HYmDL50euSaEWdtw7Y3QDEkhsD6L2NRwfKMNNnsaXnsqBtCmHyrYYFST/Ftzw
         N01UgxnjVpB6xAyIPtpLL+hjNl2g7LTzAKJjdv/6Hjj1INAac2KTl5kSMqg7yYZNjUo7
         1B/w==
X-Gm-Message-State: AO0yUKWcdBRQHDEU1bAB3Y2/PVD7W+Nu2Vic3ePIJutQgSpCcSAyiPJq
        xpENwRDPqGVlJB6QyWABiB0=
X-Google-Smtp-Source: AK7set8A7jodj3FgJVB1ZE9rw+Qz0WAc6BkhbCoyT5ZT/PwQvA8is+fAbk2Wslrqs3M7NEQjW55Hxg==
X-Received: by 2002:a05:6a20:e60c:b0:bc:c663:41b6 with SMTP id my12-20020a056a20e60c00b000bcc66341b6mr10737858pzb.28.1675457608997;
        Fri, 03 Feb 2023 12:53:28 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:b752:5d03:ec5e:7be5? ([2620:15c:211:201:b752:5d03:ec5e:7be5])
        by smtp.gmail.com with ESMTPSA id n18-20020a639712000000b004a281fb63c3sm1883510pge.87.2023.02.03.12.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 12:53:28 -0800 (PST)
Message-ID: <90e4fb52-6b09-00d9-7591-7140b859ed15@acm.org>
Date:   Fri, 3 Feb 2023 12:53:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] scsi: ufs: probe hba and add lus synchronously
Content-Language: en-US
To:     Adrien Thierry <athierry@redhat.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230202182116.38334-1-athierry@redhat.com>
 <0e955a31-1d3a-beca-4581-dbcdefc47674@acm.org> <Y91xPMM+/BfaRLle@fedora>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y91xPMM+/BfaRLle@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/23 12:40, Adrien Thierry wrote:
> Another solution could be to change the kernel Kconfigs to force
> DEVFREQ_GOV_SIMPLE_ONDEMAND (and possibly other devfreq-related options as
> well) to be builtin when SCSI_UFSHCD is enabled (builtin or module). Is
> that what you meant?

Are all UFS users using the devfreq framework? Otherwise this sounds good to me.

Thanks,

Bart.

