Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE41C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 18:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF1060ED4
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 18:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhJYSmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 14:42:23 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:55185 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJYSmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 14:42:23 -0400
Received: by mail-pj1-f46.google.com with SMTP id np13so8958705pjb.4;
        Mon, 25 Oct 2021 11:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/m33XTTns9kFvu722oN1HYpwGFj5aZgy75LRmYzE07Q=;
        b=zbxpxki5NAE+SegugdG6AVYbx6JWeFeqiKbIFQmtqMeSPnoi+ktRxr186uDG4+eucl
         AkVXvfcA1kQLNDg6XRb+nAxo52gNZeJukNBCK91zV5hzG4a9mOB6uGTTfABKHq/coxtv
         T13rSfMvuaWLU81uUMK3khtv6E+/op+CytcKkU/SoISVQ3PpWP9DZGkj6rpBUdF+sQNL
         ooJkFcYbucjqCg0J6JUsCgfB6Sg8jAIFoB2m9nNEoea5epXxVi10f45bJOqo61ZEgrvg
         QE0yxoUK5V7amysH22iuIJv2EwXgIHz9SwGU/mvULzGtk+1RUkftvK4X1DE9LMwalEh0
         FFmw==
X-Gm-Message-State: AOAM530mwBAAKAenB65ZbMIXO4WX0Xi5d8voj07en0sDuOjmHNd8qSjI
        sFyq3cUp5nSWoLl0EnogS44=
X-Google-Smtp-Source: ABdhPJxd5KgThzcQ+ynLsdppaoQJHy554AcFL/dS+u5XtNMvoqmM3AIXqhIKyeRmckO0CgWNplofYA==
X-Received: by 2002:a17:90a:7b85:: with SMTP id z5mr15108922pjc.147.1635187200360;
        Mon, 25 Oct 2021 11:40:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f863:1daa:afe1:156])
        by smtp.gmail.com with ESMTPSA id z8sm18099251pgi.45.2021.10.25.11.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 11:39:59 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: revert HPB support
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Daejun Park <daejun7.park@samsung.com>
References: <20211022062011.1262184-1-hch@lst.de>
 <4199e780-32e5-a1ce-65ba-85e0b7a3eda5@acm.org> <YXb2uO55W33/6ZFq@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cafee169-32ab-76ce-db22-ebd472e5b756@acm.org>
Date:   Mon, 25 Oct 2021 11:39:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXb2uO55W33/6ZFq@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/21 11:26 AM, Greg Kroah-Hartman wrote:
> Is there a link to where the HPB developer said they would look into
> this?  Perhaps until that happens this should be marked as BROKEN?

Hi Greg,

Daejun wrote the following on Thursday: "I will find out how to make
the HPB code without blk_insert_cloned_request() API." Unfortunately
that email was sent as MIME-encoded so it was only received by the
people Cc-ed on that email and has not been archived by any of the
websites that archives linux-scsi or linux-block emails. The email
that I received is available below. I think it is fine to make this
email public given the presence of two mailing lists in the Cc-list.

Thanks,

Bart.



-------- Forwarded Message --------
Subject: 	Re: please revert the UFS HPB support
Date: 	Fri, 22 Oct 2021 07:41:43 +0900
From: 	박대준 <pdaejun@gmail.com>
To: 	Bart Van Assche <bvanassche@acm.org>
CC: 	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>, Jaegeuk Kim <jaegeuk@kernel.org>



Hi Bart,

2021년 10월 22일 (금) 오전 1:23, Bart Van Assche <bvanassche@acm.org <mailto:bvanassche@acm.org>>님이 작성:

     On 10/21/21 8:17 AM, Christoph Hellwig wrote:
      > On Thu, Oct 21, 2021 at 05:15:20PM +0200, Christoph Hellwig wrote:
      >>>> I just noticed the UFS HPB support landed in 5.15, and just as
      >>>> before it is completely broken by allocating another request on
      >>>> the same device and then reinserting it in the queue.  It is bad
      >>>> enough that we have to live with blk_insert_cloned_request for
      >>>> dm-mpath, but this is too big of an API abuse to make it into
      >>>> a release.  We need to drop this code ASAP, and I can prepare
      >>>> a patch for that.
      >>>
      >>> That sounds awful, do you have a link to the offending commit(s)?
      >>
      >> I'll need to look for it, busy in calls right now, but just grep for
      >> blk_insert_cloned_request.
      >
      > Might as well finish the git blame:
      >
      > commit 41d8a9333cc96f5ad4dd7a52786585338257d9f1
      > Author: Daejun Park <daejun7.park@samsung.com <mailto:daejun7.park@samsung.com>>
      > Date:   Mon Jul 12 18:00:25 2021 +0900
      >
      >      scsi: ufs: ufshpb: Add HPB 2.0 support
      >
      >      Version 2.0 of HBP supports reads of varying sizes from 4KB to 1MB.
      >
      >      A read operation <= 32KB is supported as single HPB read. A read between
      >      36KB and 1MB is supported by a combination of write buffer command and HPB
      >      read command to deliver more PPN. The write buffer commands may not be
      >      issued immediately due to busy tags. To use HPB read more aggressively, the
      >      driver can requeue the write buffer command. The requeue threshold is
      >      implemented as timeout and can be modified with requeue_timeout_ms entry in
      >      sysfs.

     (+Daejun)

     Daejun, can the HPB code be reworked such that it does not use
     blk_insert_cloned_request()? I'm concerned that if the HPB code is not
     reworked that it will be removed from the upstream kernel.

     Thanks,

     Bart.


I will find out how to make the HPB code without blk_insert_cloned_request() API.

Thanks,
Daejun
