Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAE7C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D0C6144A
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242966AbhDUU5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:57:12 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:33356 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240376AbhDUU5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 16:57:09 -0400
Received: by mail-pg1-f172.google.com with SMTP id t22so31142556pgu.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 13:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VFUwMOD1LP3ovOqcd7d6GWzPhzxbj3VpIjt4DZFo9IQ=;
        b=YYW6aRN5lkeWqIe8gUVCXR+L2tQ93MqoWgas6U57gA3F3iRdfpmNQXSxYz+2imjdxV
         btxLhxhx7I5QSrxg8gtwkWWt1PG7dhF5nrt6+ad2wRjyOAHYiJRkc8uDto1fXJNBi+RO
         K+b0KXE+OWaa0o4gNtsEbxkjZSQiWVNDyFHWXLpD5e6x25ad7AeDY9ekV/5fIffVEMD9
         rfoKuIXcR3a6X0VnCUwEy5fktaGnkWfmptUtbTEtehnzAUlN8zfe5wR8Fvop+pBHMYth
         Zz2JVDZDZqUCnhB8Ax0AyHM4ck9X9PhZkvBTIx1ydwSDVT7Jrqdajphq8vdqdE7GIV/E
         G/eQ==
X-Gm-Message-State: AOAM531cERqibuMA/rPu0PfJ8Yei7ddpDHUvcY1ywFlJEA9pqKuw3kiy
        PKgWPpuvFa+dvumYhQebdUcd+ZMkD/wa2w==
X-Google-Smtp-Source: ABdhPJxQvUJm+vNugLKBcT9L/or2cxAHaOvexgoBXsB6WJqnDZe5epGSGK7xKQEl27JTUmAoF802Hw==
X-Received: by 2002:a63:1125:: with SMTP id g37mr86847pgl.56.1619038596032;
        Wed, 21 Apr 2021 13:56:36 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i18sm177626pfq.59.2021.04.21.13.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 13:56:34 -0700 (PDT)
Subject: Re: [PATCH 01/42] st: return error code in st_scsi_execute()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d05621de-c332-4b37-176d-dabf53a84c1e@acm.org>
Date:   Wed, 21 Apr 2021 13:56:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> The callers to st_scsi_execute already check for negative
> return values, so we can drop the use of DRIVER_ERROR and
> return the actual error code.

A nit: I could only find a single caller?

Thanks,

Bart.
