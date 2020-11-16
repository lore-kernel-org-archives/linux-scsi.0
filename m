Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69092C63697
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 18:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3042922447
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 18:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388060AbgKPSBw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:01:52 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43142 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731246AbgKPSBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 13:01:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id 34so10622246pgp.10;
        Mon, 16 Nov 2020 10:01:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SYjS2cBSGMMdMPWDBVlWkkqUFP7ukoe+DuKLnGILBxc=;
        b=DF59bHRE5nGaZaayFGyWwCStoS3GYt1LsV7KM4S2GlEgqI6sXIiKVYviWU+6w9U+8B
         yM8LLovA9tq5Lx/rrCPXEs2SPgmfj1vkZAzqT7QX3JLRpGZFqF9WS5KDTeNL8yRI1p52
         0tKWPD34FlVSuITdlAHAO9g20srmjMdptQYQt0lQ+IisF5iwCNmPJqZvgoI36QIA00t+
         TbqnkL6PM5PrbH44Tf+y2abIZQVDbqX5CY8zVG3qs1EDifkaNqQoSsK/g4bjpnR/JJ2s
         kjRqPHqgVpCrhrDUJ1VciGx4LQPSuMhxrfiCWq2YEKoW/KstVxrRnNjAGY+NNJU1gW+K
         13og==
X-Gm-Message-State: AOAM5329G1PB8BgymhNeupFKszVAqOISgUd/tGxvdZPYfJNVQW5rJcyg
        l39keIhfysFD1cucsG1ZWNE=
X-Google-Smtp-Source: ABdhPJyTWvdhAYU07f9OvipmdQtB198cLjT1cyJGmdQOg3xwKt68qt5bQnly7nIgZA8lv+5VndbzqA==
X-Received: by 2002:a63:6ecb:: with SMTP id j194mr343911pgc.420.1605549710669;
        Mon, 16 Nov 2020 10:01:50 -0800 (PST)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mv5sm39935pjb.42.2020.11.16.10.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 10:01:49 -0800 (PST)
Subject: Re: [PATCH v2 4/9] scsi: Rework scsi_mq_alloc_queue()
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20201116030459.13963-1-bvanassche@acm.org>
 <20201116030459.13963-5-bvanassche@acm.org> <20201116171755.GD22007@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cf82c6f3-698c-4dad-b123-fda710e0741e@acm.org>
Date:   Mon, 16 Nov 2020 10:01:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116171755.GD22007@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/20 9:17 AM, Christoph Hellwig wrote:
> On Sun, Nov 15, 2020 at 07:04:54PM -0800, Bart Van Assche wrote:
>> Do not modify sdev->request_queue. Remove the sdev->request_queue
>> assignment. That assignment is superfluous because scsi_mq_alloc_queue()
>> only has one caller and that caller calls scsi_mq_alloc_queue() as follows:
>>
>> 	sdev->request_queue = scsi_mq_alloc_queue(sdev);
> 
> This looks ok to me.  But is there any good to keep scsi_mq_alloc_queue
> around at all?  It is so trivial that it can be open coded in the
> currently only caller, as well as a new one if added.

Hi Christoph,

A later patch in this series introduces a second call to 
scsi_mq_alloc_queue(). Do we really want to have multiple functions that 
set QUEUE_FLAG_SCSI_PASSTHROUGH? I'm concerned that if the logic for 
creating a SCSI queue would ever be changed that only the copy in the 
SCSI core would be updated but not the copy in the SPI code.

Thanks,

Bart.
