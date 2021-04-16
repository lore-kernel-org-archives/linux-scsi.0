Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC03C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 16:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F996113D
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 16:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbhDPQNF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 12:13:05 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:43707 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbhDPQNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 12:13:05 -0400
Received: by mail-pj1-f50.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso14875492pjh.2;
        Fri, 16 Apr 2021 09:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HfgRk7HBJxJFSfeAkcoggDihaPqrhhPGYCbAGgHqBV4=;
        b=WVFtfqoj1pOz4tTEYVks7nbbRiBh7dKxMeSn6RoJ9MDaMMEt7I0MX250J94e3GH+n2
         bGZzKnxt2QmMjMxmy1T2+UCrsoSFmrbkk9H0GHVVwhqMZwKfzTveM5fQMSYFI5rR2chi
         UyUeRryY8OBR76B45QpVM5SvyI3DBRSG6uTQUPtBtsQlKAZaxoG/iS+QRHH4+J0huznL
         2C8Aoks5IYCj36oxyxeJ9MS//5HwIMYWzI7npgEvTpaUmBTRZ0ybPnd/wxdQf5G8rbzo
         HgqYARJbLp7Nxxob8eUwV6ilV+pJhSGMSujnOtNdFGljEXsYN17qDrRhIVgLM4E/douh
         htPA==
X-Gm-Message-State: AOAM533X4xjLIROZdGQoJjpmC2Jzt/445UxoTtmzSecAa6NLn9zQYoiz
        FuQ4pnwMLI5gxlC4wv65ps4=
X-Google-Smtp-Source: ABdhPJwOKBGLJ9D5o+YzqydbDezbntDi8qFzwCQvI+tJGq1GVqezstR3//gc4b+M15AS+8SjwAIuNA==
X-Received: by 2002:a17:902:e812:b029:eb:59d9:e550 with SMTP id u18-20020a170902e812b02900eb59d9e550mr10179817plg.26.1618589558957;
        Fri, 16 Apr 2021 09:12:38 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:deb4:c899:3eb6:a154? ([2601:647:4000:d7:deb4:c899:3eb6:a154])
        by smtp.gmail.com with ESMTPSA id m15sm5572100pjz.36.2021.04.16.09.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 09:12:38 -0700 (PDT)
Subject: Re: [PATCH v4 5/7] target: srpt replace enable attr to ops.enable
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210416082632.2000-1-d.bogdanov@yadro.com>
 <20210416082632.2000-6-d.bogdanov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <268fce7b-ed7d-05e9-d337-23a476305e1c@acm.org>
Date:   Fri, 16 Apr 2021 09:12:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210416082632.2000-6-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 1:26 AM, Dmitry Bogdanov wrote:
> Remove tpg/enable attribute.
> Add fabric ops enable_tpg implementation instead.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
