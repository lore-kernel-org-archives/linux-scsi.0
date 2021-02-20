Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526F3C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 23:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201EA64E5F
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 23:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhBTXjP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 18:39:15 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:37320 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhBTXjN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 18:39:13 -0500
Received: by mail-pj1-f44.google.com with SMTP id t2so6432424pjq.2;
        Sat, 20 Feb 2021 15:38:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6/w/e0bNnUx0dHDixXkXEBITtx/XbAqYFak03Tye2k=;
        b=dC/uUDj1XzTM+1nf6H9IcbXIuyr21cgFa3eZXLgyeGB28eXmqAB+lx5MndXVYjlOZO
         x1O0LM74pNgSRbR01AzhQOA3+Y6GMNpQ6bkIwTwFzoFvoEzAOLvoQka+JIJItKyslstX
         cN9fa0aw6slm+oSTJva++URRrR5ThLHSt/P/HBR2iGcAxBjAuLlCLA09KQa9RcBTOpYc
         Kl2zvi+3gBmZ7iVdn6B9yqKuAfA5l5bhex09HiCQwJ+JfI38wlw9Bj0JaLM2V717vSle
         eccZElPdhBEkCrmmLeaJgC3Jk3jjhb4FtG9GwYrslMlQfdTQZmCJkQHxIKhq0N9bGPq9
         XbLA==
X-Gm-Message-State: AOAM5338Onj/MbNI2IBYiGqETTiyVZTCHQD8tnr01Kx/mocce1Dcm+d9
        IlzpVGzpf1H7VJ4snZ+tIWg=
X-Google-Smtp-Source: ABdhPJxUTs0R71nIM2ohlIMCAMuNDWnT539QExRTNzsz6xLDlnXzJWjFKEhFvTI5OJKs3oDt/RS8sQ==
X-Received: by 2002:a17:90a:4287:: with SMTP id p7mr16064765pjg.226.1613864312296;
        Sat, 20 Feb 2021 15:38:32 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:a813:9a51:fed9:102b? ([2601:647:4000:d7:a813:9a51:fed9:102b])
        by smtp.gmail.com with ESMTPSA id i184sm11309834pfe.19.2021.02.20.15.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 15:38:31 -0800 (PST)
Subject: Re: [RFC PATCH 00/24] target: code cleanup
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com
References: <20210220213652.6290-1-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fb69b912-445a-7933-987d-843e68df97ca@acm.org>
Date:   Sat, 20 Feb 2021 15:38:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210220213652.6290-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/20/21 1:36 PM, Chaitanya Kulkarni wrote:
> This removes unused macros, various memsets, extra variable
> in the target/iblock for bio get and fixes some type mismatch for the
> same with fix for smatch warnings.
> 
> Marking it as RFC as I don't know if these cleanups are acceptable or
> not.
> 
> I've geterated this on the linux-block, we decided to move forward wicth
> this then I'll send series based on right repo.

Please mention in the cover letter how these issues have been
discovered. Have these issues been discovered by inspecting the code
manually or perhaps by a tool (e.g. checkpatch)?

>   target/pscsi: remove unsed macro ISPRINT

Please fix the spelling in the patch subjects and also in the cover letter.

Thanks,

Bart.
