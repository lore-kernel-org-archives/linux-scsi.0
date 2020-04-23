Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20E6C55185
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D055320767
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u2j/cdK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgDWC7v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 22:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgDWC7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 22:59:50 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD00BC03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 19:59:49 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id re23so3556700ejb.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 19:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lrEOogouW2LqKyxhU1moGNsRz1jHY9Pm23tDJuWHs80=;
        b=u2j/cdK90FToq+KrD3HvllsqHmvOMq1Sig23UTtr/18NNFbauiO4mggIEwejnpBjpV
         TNuNksRKoPAnjIMtqzJJrZhC+yCEWEKt5+1xW9SJKWrIKhJg38Fk+vOcND9FLwRUjtV6
         jST7xoTYMmi3t4QdFgUO4k+G+joZPyi9070t+KCkf5lcvy8dXQOvg8Qoy9UcU0BLecWj
         pj3MfjGaI0Tvsi4/q2h3EJQ4fAYQPel6fLn8QIvwkl8y/Y4zyqkQKctCui7LfDelsbAx
         3gMd2pvH0T8+OQm6l3VxJqaIE4Y+b0rCZVvdRzPqALIHRE4Lkiy28pjer8WLI/G+FHWm
         B6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lrEOogouW2LqKyxhU1moGNsRz1jHY9Pm23tDJuWHs80=;
        b=D9cLwZ7/IAU6nXlabLMj1DdSrdGHTR+3XtxR9AkR9EhKzYPRqaIEAPASFF5SBHySUK
         XuOARP/GsZzFpqEB3zK7Wftb3PKVnizXC4TMFWfP/jirRfooYwBqmOKQcQ/yN2LQqe39
         /yGstnCanqwRmXqVF/XtXoZYuwu1IEYGKVMNs5jQE/CsPU0uD0ujQo9AesPyrSO1QMpO
         xNGzbAGz/YSl8ZOhoM5AP1K3PS2cniLCMDdNQ64UwR2qSfQdQZjgYs9g5LY3FPXtIkfE
         7lc2KEScPr0UKNXOANqTWcM1WVT2EobruUc+MrYz5lBqiM4s0Ng9uZlyaVf1tlKMWaEV
         XGtA==
X-Gm-Message-State: AGi0Puatdz57Ar2jd9V5kf263jiB3ugyGK7XkM51RiJqblPuSLdScdmR
        6Ie835jKQq/05Pi3BLYYWZI=
X-Google-Smtp-Source: APiQypKor0VoPQasyGMtY1tds43xy9nXxP+ZjSClFKVc1Zne4lvCbV++bJQggyAhjOkJErzBQB1kbA==
X-Received: by 2002:a17:906:3443:: with SMTP id d3mr1076029ejb.18.1587610788719;
        Wed, 22 Apr 2020 19:59:48 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id z18sm232755ejl.37.2020.04.22.19.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 19:59:48 -0700 (PDT)
Subject: Re: [PATCH v3 15/31] elx: efct: Data structures and defines for hw
 operations
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-16-jsmart2021@gmail.com>
 <20200416072227.n2zmu4znwjah6vow@carbon>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <5759f081-2e2e-fb00-c523-00aa39907e8e@gmail.com>
Date:   Wed, 22 Apr 2020 19:59:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416072227.n2zmu4znwjah6vow@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/2020 12:22 AM, Daniel Wagner wrote:
...
>> +/**
>> + * HW IO object.
>> + *
>> + * Stores the per-IO information necessary
>> + * for both the lower (SLI) and upper
>> + * layers (efct).
>> + */
>> +struct efct_hw_io {
>> +	/* Owned by HW */
> 
> What are the rules? Live time properties?
> 
>> +
>> +	/* reference counter and callback function */
> 
> Make kerneldoc out of it?
> 

I'll see if there's something we can write about it.

Agree with rest of comments.

-- james


