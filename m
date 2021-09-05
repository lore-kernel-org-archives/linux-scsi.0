Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2991C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Sep 2021 04:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 920D760E94
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Sep 2021 04:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhIEEun (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 00:50:43 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:36784 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhIEEum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2021 00:50:42 -0400
Received: by mail-pg1-f181.google.com with SMTP id t1so3284735pgv.3;
        Sat, 04 Sep 2021 21:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EOYB1KxFAVgDdS3yLIwc9PdjH+MHLY7d6qXq21McNz0=;
        b=Yaz8qkDMnk4XZl+D01zVcBqYsd1RIgQUj8F1+OpNVHd55r58FxkeFLvcKyHfaQcnqD
         4YCn1GQPXB92D08n318lt2iBc1Tc3DLiRj0aWpp+pVo9NgWvEO/p2q5Z6bOjILbHMbYz
         Th7YrNs4Ot7zcmx0E5AkJZUuiUuQEl7azoXJrERdKz0RUHv7KVAlXpSmgZjF/xKLwmTP
         B7NnzOgqnYxUqb/4WFSUZXJeMK0cea4K/7gJmTPrZTaCbi6RkmCgl7Vfid3vXJuXjAcM
         BizOGCCzyI3+LfBuBgGNS7pEb6VXMYDPsGkDGAFEk1/kjbo4qQFOirHl0N49Z/SZlkSE
         nGcQ==
X-Gm-Message-State: AOAM5331OQMudCpk1hLs2D1DyoPITvA4j/AaojjNZt6hQuxK9oOHRKCq
        bDzsEBn3rO/C82GWfHeUbE8=
X-Google-Smtp-Source: ABdhPJxPGHpV88TdVDKHneSWhdVMIr6oZ5koD0O4q4C2QcruYcA891h1jnR5LTdAEr+ALHUJbcM2dg==
X-Received: by 2002:a62:b615:0:b0:3f9:1c5a:2671 with SMTP id j21-20020a62b615000000b003f91c5a2671mr6193712pff.10.1630817379902;
        Sat, 04 Sep 2021 21:49:39 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:f591:655e:bc:ec9f? ([2601:647:4000:d7:f591:655e:bc:ec9f])
        by smtp.gmail.com with UTF8SMTPSA id ml10sm3725742pjb.9.2021.09.04.21.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 21:49:38 -0700 (PDT)
Message-ID: <388781f8-b9ce-abc2-148a-0498d32b6cb4@acm.org>
Date:   Sat, 4 Sep 2021 21:49:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH -next] [SCSI] Fix NULL pointer dereference in handling for
 passthrough commands
Content-Language: en-US
To:     Laibin Qiu <qiulaibin@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.de
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210904064534.1919476-1-qiulaibin@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210904064534.1919476-1-qiulaibin@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/21 23:45, Laibin Qiu wrote:
> In passthrough path. If the command size for ioctl request from userspace
> is 0. The original process will get cmd_len from cmd->cmnd, but It has
> not been assigned at this time. So it will trigger a NULL pointer BUG.

A Friday night in the middle of the merge window is not the best time to 
post a kernel patch. Anyway:
  Reviewed-by: Bart Van Assche <bvanassche@acm.org>
