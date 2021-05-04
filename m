Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD56C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7EB66139A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhEDDIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 23:08:02 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:36720 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhEDDH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 23:07:56 -0400
Received: by mail-pf1-f175.google.com with SMTP id p4so6026273pfo.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2021 20:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rV6esDMydiqtCG4DapjwCkRjHSYPeiPgftg6WgJUq8Q=;
        b=NnYRG7ddI+HaumrHVngGiVcwUhAOcU89tuOkSR1Ad0l54iZ8Y6t+BheHYUZCBERUAc
         UyDmjlBpesivwRzWKsoquWegjYaho5n4D1TZFh7HrX6ZtZGLWoRVbzxzz4n0ztS7j7os
         o5lJDn3fHTm2eYQ/6dT/baPgwpp51xhZyAb7iyDhBdw0JP+w2fbsPsdydCLnULWEK2Uz
         MSYeerofj4J23GUBcqRXJYZqVW7n70OLTbKUuQYEkb3R1APXW9Hen7zFb8LVdepojF9m
         wGmYlkmGT+mBHce2ECW1VTxlFaHI+nBjdwJj7WrcHPw7saxdqXmKQ8nv2mB+CHvc2i7S
         4k5Q==
X-Gm-Message-State: AOAM532YOb8OTt3eIjlwzi+ELaXjVJIl88ZeSW/WjlrnAVWIeeT1oQNf
        rLWIp9ms7Kd8FMIMErJ7SENp3jam8Lg=
X-Google-Smtp-Source: ABdhPJwFQSnrBSB/qtdqCCOb1X67RUoGGsQR2AKBwmm4pzU8PBwu5U0YIl0W2YJlOS/NTkBp0TGu0Q==
X-Received: by 2002:a63:ff52:: with SMTP id s18mr21193599pgk.163.1620097620381;
        Mon, 03 May 2021 20:07:00 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6b81:314d:2541:7829? ([2601:647:4000:d7:6b81:314d:2541:7829])
        by smtp.gmail.com with ESMTPSA id j13sm10301941pfn.103.2021.05.03.20.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 20:06:59 -0700 (PDT)
Subject: Re: [PATCH 07/18] scsi: revamp host device handling
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-8-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6bfedbcf-8698-f00c-838e-78a1c4a0059a@acm.org>
Date:   Mon, 3 May 2021 20:06:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> + *	Attach a single scsi_device to the Scsi_Host. The primary aim
> + *	for this device is to serve as a container from which valid
> + *	scsi commands can be allocated from. Each scsi command will carry
> + *	an unused/free command tag,

Shouldn't introducing this comment be deferred to the patch that
actually reserves a tag for internal commands (this does not mean that
I'm convinced that this is the right approach)?

> + *   which then can be used by the LLDD to
> + *	send internal or passthrough commands without having to find a
> + *	valid command tag internally.

Please change "valid SCSI commands" into "internal SCSI commands".

Thanks,

Bart.
