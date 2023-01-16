Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB8FC677F1
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 18:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjAPSD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 13:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjAPSDH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 13:03:07 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387332FCD6;
        Mon, 16 Jan 2023 09:48:37 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id y5so21521109pfe.2;
        Mon, 16 Jan 2023 09:48:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tit7frNWplwiubvm/1MuVeYu2Eshy1M+B/nDt9WYfGE=;
        b=w8F5wjBC4Ma44P9TgBjw2t4MJ2hhg8NT1XufBM34WwL+E7WAJ7fsq3vWdrud95tHzn
         kAKUTNQKiE3nes7QVa4Xs8qwnMiObqPT/pupGsQdeeMJOAvhXl0nbq3qQbgHp+cezeIz
         T8ibuhavj5817cwZCj3ucn/yFdP/FtXdmuFkuA8Dw/B/N1hfiCupsZ7kGDHDY955RJjy
         2MhP8m6dXt3IRRdSUuTEBSfkvdzPynl16QXMcoEOEl9IsVDg4CxTgaBcuxQ1Z0gegaNE
         kCuGQ+KIaWdXEmax35YD/nDCG3gEtAl0STtz2LpDYKjnwFaI3WLLAEj1O+LnrHGZzYza
         QDiw==
X-Gm-Message-State: AFqh2krlJ2h4GAgWLLSTRhHkQ4bczdAbo9qE3NThDlZe9DOus6JE1ifH
        PMydR+9x+tddFxMJZpBepLc=
X-Google-Smtp-Source: AMrXdXt/lzviJiU6mCsJtyfzw8nrVxU7FTXgUUGGH8DjyuUT/SunhdnvUXECdasns380VC2lnRi//A==
X-Received: by 2002:a62:190e:0:b0:58d:be61:8bc8 with SMTP id 14-20020a62190e000000b0058dbe618bc8mr1785259pfz.8.1673891316656;
        Mon, 16 Jan 2023 09:48:36 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id s2-20020a625e02000000b0057ef155103asm16899420pfb.155.2023.01.16.09.48.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 09:48:35 -0800 (PST)
Message-ID: <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
Date:   Mon, 16 Jan 2023 09:48:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
 <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/23 08:57, Martin Wilck wrote:
> Can we simply defer the scsi_device_put() to a workqueue?

I'm concerned that would reintroduce a race condition when LLD kernel 
modules are removed.

Thanks,

Bart.

