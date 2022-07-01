Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCABC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 23:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiGAX6G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 19:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiGAX6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 19:58:05 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F2A369CB
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 16:58:03 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id 65so3788984pfw.11
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 16:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0+Kg+tcc3WYT2/OeUJCWWNY0G/qEqWJsb8DHBc/SCds=;
        b=ieQ6yy4qttu+qE+zqYqXhtQZclNWZoPK3C4xHby031aS5sW5ong5PMGHmr/POGpzFe
         spey6XH0laVgSYbC9tUTbyN8w2C/pkd7Xzl3v1Ls0dL8W4fOsKQXHIF5C4fPdFDQphQU
         dT+lb29OCjl7ihD4MMHOUCWu7Nw0abCUCZBf1557LF1tHpgyIjvpGXhvo1I+fK7m0atP
         PkhdjSmeZVPJdtn7+5PJkeffErMc160lsfuWA9LOch0MKb4rBesUUU2SmYj8BF/6tKUO
         QCK+W0l9j4Y9Pc90mTmky9fob8Ys+FrojGeIhdfjLn2oDDoZVAeYIJEq7XPPpND8o1em
         i/hA==
X-Gm-Message-State: AJIora8DTixYQF1TkVpRFPQ5+AQo74YYrTQhpSh24tjKt0b7e29mBEbg
        MQAreKyMg+OrVv6FcaydNko=
X-Google-Smtp-Source: AGRyM1uy+X0NlyonGRnRY+i2gehcu1HnN0Ryy6BGqYnFBUw2vNby1nJqkj19/7fEwjIwlPrNJYe0Iw==
X-Received: by 2002:a63:af1c:0:b0:40c:f9d6:9f07 with SMTP id w28-20020a63af1c000000b0040cf9d69f07mr14057252pge.384.1656719882949;
        Fri, 01 Jul 2022 16:58:02 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id x4-20020a63db44000000b003fc4cc19414sm16195040pgi.45.2022.07.01.16.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 16:58:01 -0700 (PDT)
Message-ID: <b7cd659e-718d-5498-6a0b-3f6d424bfd55@acm.org>
Date:   Fri, 1 Jul 2022 16:58:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 3/3] scsi: core: Call blk_mq_free_tag_set() earlier
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Mike Christie <michael.christie@oracle.com>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-4-bvanassche@acm.org> <Yr5tlDkrTTldwjSq@T590>
 <4753a2ce-0cab-ce19-68d2-de7b3c15828a@acm.org> <Yr8GkVCJUMMSYZZA@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Yr8GkVCJUMMSYZZA@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/22 07:37, Ming Lei wrote:
> On Fri, Jul 01, 2022 at 07:07:13AM -0700, Bart Van Assche wrote:
>> On 6/30/22 20:44, Ming Lei wrote:
>>> On Thu, Jun 30, 2022 at 02:37:33PM -0700, Bart Van Assche wrote:
>>>> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>>>> Read of size 8 at addr ffff888100337000 by task multipathd/16727
>>>
>>> What is the 8bytes buffer which triggers UAF? what does srp_exit_cmd_priv+0x27
>>> point to?
>>
>> I think that Li already answered this question.
> 
> OK, from Li's input, the UAF is on the following code:
> 
> 	struct srp_device *dev = target->srp_host->srp_dev;
> 
> So looks you meant target->srp_host is freed by srp_remove_one() before calling
> srp_exit_cmd_priv?
> 
> Then when is srp_remove_one() triggered? And why is it called before
> scsi_remove_host()? Sorry for the stupid question since I am not familiar with srp.

Hi Ming,

I think that can happen as the result of the following sequence (will 
look into converting this into a blktests test):
* The Soft-RoCE (or soft-iWARP) driver is bound to a network interface.
   This results in the instantation of an RDMA interface that supports
   RDMA loopback.
* ib_srp and ib_srpt are told to connect to each other over that RDMA
   loopback interface. This results in the creation of a SCSI host and
   one or more SCSI devices.
* The Soft-RoCE (or soft-iWARP) driver is dissociated from all network
   interfaces. This causes the RDMA core to report a hot-unplug event.
   That results in a call of srp_remove_one(). I think the call chain is
   as follows:

rxe_notify()
   ib_unregister_device_queued()
     ib_unregister_work()
         __ib_unregister_device()
           disable_device()
             remove_client_context()
               srp_remove_one()

Bart.
