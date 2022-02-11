Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABB3C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 23:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353966AbiBKXX3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 18:23:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBKXX2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 18:23:28 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C733C5F
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 15:23:26 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id om7so9357531pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 15:23:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XEZANdFEPwB7Qp2uGiRFgd1CG/FLMeXDfsr06ypOhpM=;
        b=NEKiS4nSgPT31lYJOMkM6oW4UJVJRz0ghvJN4kOzr70VgNHdwDswrrM8azwprBS974
         7/zM0STwZKtp5naOcK7t6guZQOgNEdS1Zn2oKEYuBlIgnF8U0vBQlqnstZz+EGHUlf5L
         wdzjDE7H1JFxDilxg0GItJi2zBohKR+X0mkwr9rLkMTE0Q1wLUSkTkS0DD1M8HaMopNT
         YckxJNQpMzseaWRrDifuw+Uz7L0BZbQ9b1meHS6bZSQ+g8qnzIAC+AagfR9eXTNCqqtG
         1tX8sLZWFqXm6cyoC0Z0rnJd5WKQMhVxmcBKYIYRY9/uRQtCV8D2vmtGEs03Pylp5Gvs
         zPwg==
X-Gm-Message-State: AOAM530iIvxC1RDuytqMfwzQ9maU6ydcSReeJL/CAogTtDZdCUCLSonQ
        mmzyVtUplGC3SSLswc6P6KoVfeU8gXI2Tw==
X-Google-Smtp-Source: ABdhPJxrpRLZcruSX5Qbj7QOr8SBTrSIifnhD3UcEwR9PWuz3Ka59RGntZsnkOET2NOm8X3weY2tHw==
X-Received: by 2002:a17:902:e74e:: with SMTP id p14mr3673672plf.95.1644621805645;
        Fri, 11 Feb 2022 15:23:25 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y41sm29114744pfa.213.2022.02.11.15.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 15:23:24 -0800 (PST)
Message-ID: <e3580324-6a3c-deb2-30f1-2d39c5ccda88@acm.org>
Date:   Fri, 11 Feb 2022 15:23:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] scsi: ufs: Fix runtime PM messages never-ending cycle
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20220211111727.161799-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220211111727.161799-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 03:17, Adrian Hunter wrote:
> Kernel messages produced during runtime PM can cause a never-ending
> cycle because user space utilities (e.g. journald or rsyslog) write the
> messages back to storage, causing runtime resume, more messages, and so
> on.
> 
> Messages that tell of things that are expected to happen, are arguably
> unnecessary, so suppress them.

Instead of making the logging statements conditional, how about removing 
the logging statements entirely? That would simplify the code. I don't 
think the logging statements provide more information than what can 
already be obtained with ftrace.

Thanks,

Bart.
