Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F99AC4CEC5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 14:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EAD520856
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 14:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732348AbfILOEK convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 10:04:10 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43871 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731816AbfILOEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 10:04:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id d15so16057825pfo.10;
        Thu, 12 Sep 2019 07:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UW+vGhhaDwB8JUulVCeUl6DUls9Tf7byS++5Ic4BMgo=;
        b=IbImnIaLuQTkNHaup7cO4iFl/4wtq1LhVLxPzuAOwvBu0FDAk7pJweK/GP5gB0i5BM
         ZY0UC3zjiL15oYOzQYpe+OiKIb9nG+W7PIB0o900S0oYNCvcH09EL9HDWqZnfHtVtCEQ
         2x9yfi3hRa2FX/Swn3a4fXph/nuAsjymGAzlKafFxsrsEqCHHx6Ki+GA5mFh6i44l0m8
         HvGVd4N8CwjsjGA44wkI1N5LlPq/DfiZVjdOsMv6m7tVE8liMtWrjYXxFIHB3Tx0qvu+
         Lq0ox/cbO6hCoum0+kyAnGK/ItGdBM3Rh63dC71ms9/HikN4jjaSSsPuRA8zB9FMM8e/
         5ddQ==
X-Gm-Message-State: APjAAAW0e4A9gMPet9kw4xHs58deINjSAKSTQgJzyUYjqBU0elO15mOQ
        k5AE+DT5vG3KwwKu+OHwjSU=
X-Google-Smtp-Source: APXvYqxtVNhYO4w3FacKlb3XkfXk4WXO2cF+kGey0owBt4cG6OUwFWyvIIVkp/ooVH7793FzuO5+mA==
X-Received: by 2002:a63:d30c:: with SMTP id b12mr39057704pgg.235.1568297049432;
        Thu, 12 Sep 2019 07:04:09 -0700 (PDT)
Received: from [172.19.249.100] ([38.98.37.138])
        by smtp.gmail.com with ESMTPSA id m24sm29696055pfa.37.2019.09.12.07.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2019 07:04:08 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: core: change function comments to kernel-doc
 style
To:     =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, kernel@collabora.com, krisman@collabora.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20190911203735.1332398-1-andrealmeid@collabora.com>
 <20190911203735.1332398-3-andrealmeid@collabora.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <19eb6b7f-0a62-0e2a-c108-27887b825767@acm.org>
Date:   Thu, 12 Sep 2019 15:03:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911203735.1332398-3-andrealmeid@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/19 9:37 PM, André Almeida wrote:
> +/**
> + * scsi_queue_insert - Insert a command in the midlevel queue.
> + * @cmd:    command that we are adding to queue.
> + * @reason: why we are inserting command to queue.
>   *
> - * Returns:     Nothing.
> + * We do this for one of two cases. Either the host is busy and it cannot accept
> + * any more commands for the time being, or the device returned QUEUE_FULL and
> + * can accept no more commands.
>   *
> - * Notes:       We do this for one of two cases.  Either the host is busy
> - *              and it cannot accept any more commands for the time being,
> - *              or the device returned QUEUE_FULL and can accept no more
> - *              commands.
> - * Notes:       This could be called either from an interrupt context or a
> - *              normal process context.
> + * Context: This could be called either from an interrupt context or a normal
> + * process context.
>   */

What is the midlevel queue? I don't know anyone who still uses that
terminology today. Since the switch to scsi-mq we have software queues
(if no I/O scheduler has been configured), scheduler queue(s) (if an I/O
scheduler has been configured) and hardware queues.

> +/**
> + * scsi_io_completion - Completion processing for block device I/O requests.
> + * @cmd:	command that is finished.

That looks inconsistent: the function description refers to block device
I/O requests while what is being completed is a SCSI command.

> + * We will finish off the specified number of sectors.  If we are done, the
> + * command block will be released and the queue function will be goosed. If we
> + * are not done then we have to figure out what to do next:
> + *
> + *   a) We can call scsi_requeue_command().  The request
> + *	will be unprepared and put back on the queue.  Then
> + *	a new command will be created for it.  This should
> + *	be used if we made forward progress, or if we want
> + *	to switch from READ(10) to READ(6) for example.

I am not aware of any function in the kernel tree that has the name
scsi_requeue_command().

Thanks,

Bart.

