Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A98FC636D7
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 22:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjBAWBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 17:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBAWBW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 17:01:22 -0500
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABBD721D2;
        Wed,  1 Feb 2023 14:01:21 -0800 (PST)
Received: by mail-pg1-f175.google.com with SMTP id 7so13567407pga.1;
        Wed, 01 Feb 2023 14:01:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tjbGinFPAyqXGNjz/JLnJ2ll9M3JNlpJozCDNf6dBSc=;
        b=wrA5VWxnJHBLeZdQ7UmUxPVMHpwn+LKwuFCBT3f0CVqS1as8db3qcQW7CkpWp9g5Ev
         kI5qcr3MCppw/pjk6w2sZK4fhJE0a+KCrRweSgqktQf8ld4rQFlcBA1u9msLhbsfacF+
         uvW31Y2LuazY7pkcmRUXL1uyBe/JrB1qHdF4zkU+wxXjD5r2P6BzU196w8ySOld1u9sG
         VeFUkbTpclV4tIDW7Y7cQOuqe78uyxeKL2RsNw4VpcxUx9ON1jAJXfRjEzsXZXOj4TDM
         PvZf/rWKhNVyVjlzQOLlVLs/2PpNJFktwI3qh0zXPVH0QEwKAOwCBZvbNQd2gcXUGlI/
         zgjA==
X-Gm-Message-State: AO0yUKWRyn5WC0iEa2sJti12b/gByDtk4yUIDYDgLmtGNU4BsfOokwZ9
        GcImZDCgzohBmLGIZpPAqxc=
X-Google-Smtp-Source: AK7set+n40bDrvOzrKkgIqPzcRQgGyx1bAsjkH1UYYe3Vp7nNr0qs6mHkfRiFz1BeJBBpBqeKAgjtw==
X-Received: by 2002:aa7:949d:0:b0:592:52d7:6af7 with SMTP id z29-20020aa7949d000000b0059252d76af7mr3183914pfk.32.1675288880856;
        Wed, 01 Feb 2023 14:01:20 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:f3cf:17ca:687:af15? ([2620:15c:211:201:f3cf:17ca:687:af15])
        by smtp.gmail.com with ESMTPSA id j14-20020a62e90e000000b00590684f016bsm11950734pfh.137.2023.02.01.14.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 14:01:20 -0800 (PST)
Message-ID: <4c9b87dc-aeeb-43b6-0c18-4d04495683da@acm.org>
Date:   Wed, 1 Feb 2023 14:01:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4 1/7] block: Introduce blk_mq_debugfs_init()
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <p.raghav@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-2-bvanassche@acm.org>
 <20230201205800.t3gpx7w3aw2ozab7@garbanzo>
 <20230201212332.p3mdb5ab3qisuo2x@garbanzo>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230201212332.p3mdb5ab3qisuo2x@garbanzo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/1/23 13:23, Luis Chamberlain wrote:
> On Wed, Feb 01, 2023 at 12:58:00PM -0800, Luis Chamberlain wrote:
>> On Mon, Jan 30, 2023 at 01:26:50PM -0800, Bart Van Assche wrote:
>>> Move the code for creating the block layer debugfs root directory into
>>> blk-mq-debugfs.c. This patch prepares for adding more debugfs
>>> initialization code by introducing the function blk_mq_debugfs_init().
>>>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Ming Lei <ming.lei@redhat.com>
>>> Cc: Keith Busch <kbusch@kernel.org>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>
>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> 
> Sorry but actually a neuron triggered after this to remind me of commit
> 85e0cbbb8a  ("block: create the request_queue debugfs_dir on
> registration") and so using the terminology on that commit, wouldn't
> this not create now the root block debugfs dir for request-based block
> drivers?

Hi Luis,

This patch should not change any behavior with CONFIG_DEBUG_FS=y.

As one can see in include/linux/debugfs.h, debugfs_create_dir() does not 
create a directory with CONFIG_DEBUG_FS=n:

static inline struct dentry *debugfs_create_dir(const char *name,
						struct dentry *parent)
{
	return ERR_PTR(-ENODEV);
}

I think the only behavior change introduced by this patch is that 
blk_debugfs_root remains NULL with CONFIG_DEBUG_FS=n instead of being 
set to ERR_PTR(-ENODEV).

Thanks,

Bart.

