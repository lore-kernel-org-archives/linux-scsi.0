Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5558C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1FD60FF2
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241418AbhJQCTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:19:17 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:50884 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhJQCTR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Oct 2021 22:19:17 -0400
Received: by mail-pj1-f43.google.com with SMTP id gn3so4345508pjb.0;
        Sat, 16 Oct 2021 19:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fV7wt55es3O887KqSyNg2L4d5z06f5+6gZKXYBgENbc=;
        b=aekhMvXjm9Hzbu4rI5DeiWkLacUQzqORFInqrv7XfRAJdCfPqt0FauZETQ0tC4m/p2
         2JSYdd6dzsR6WT8OlvQPb8d7+INyKYIBpwxkzw//rboYhGajAhblE1c89goHbpenrdIL
         CeH1d7/dDs4SfD5J+EUIrzyNxWKqe7hqqj0/NVaHcU3c5S20BcELuEs3o8wWdHnUcmtT
         UjkcE3heawnKiHE7Vo7TY1qd8wLXSjRpMDAPNzStwv7XQyq57JTAXvI5P1Li0A3htz6H
         jCACw6DF4CMcAnaXluIp7ziyKJljsM7+fLhCW1bTQ3v8yjxnE2wobjwrQ6ymzQp98ie+
         KYvg==
X-Gm-Message-State: AOAM531Mg2s9+0tlAXrqtIqfRbQUcv+PZ8jtB/LYP7SX3ugmzWSL8ubb
        z/hV76P6SHetIPBLaVj9rDs=
X-Google-Smtp-Source: ABdhPJwX4+eVa8trz7lYi/E7NLSGakuYDA/RZFWugFfp09y8UAxLNJgTnF/ZOArpyQJtQmEZD7yHKg==
X-Received: by 2002:a17:902:e5c7:b0:13f:1dd9:1f25 with SMTP id u7-20020a170902e5c700b0013f1dd91f25mr19485471plf.35.1634437028031;
        Sat, 16 Oct 2021 19:17:08 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:bf67:3ac:3e6:895b? ([2601:647:4000:d7:bf67:3ac:3e6:895b])
        by smtp.gmail.com with ESMTPSA id ng5sm8675025pjb.51.2021.10.16.19.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 19:17:07 -0700 (PDT)
Message-ID: <e567fc59-46b1-bc83-c90c-199257ff8c93@acm.org>
Date:   Sat, 16 Oct 2021 19:17:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 3/3] scsi, usb: storage: Complete the blk-request
 directly.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-4-bigeasy@linutronix.de>
 <YWmmn4MpTSGHRVOU@infradead.org>
 <20211015161653.muq37x6mkeru6lxc@linutronix.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211015161653.muq37x6mkeru6lxc@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/21 09:16, Sebastian Andrzej Siewior wrote:
> On 2021-10-15 09:04:47 [-0700], Christoph Hellwig wrote:
>> Bart has been working on removing the ->scsi_done indirection, so this
>> will need to find a way to interact with that
> 
> Okay. So I just wait until it is there. Is this v5.15/16 material?

Isn't it too late to submit patches for v5.15 other than bugfixes for 
patches merged during the v5.15 merge window?

Martin Petersen, the SCSI maintainer, has been so kind to queue the 
patch series that removes the scsi_done member for the v5.16 merge 
window. So that patch series should become available soon in the 
following git repository:
git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git

Thanks,

Bart.
