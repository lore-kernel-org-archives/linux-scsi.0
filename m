Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3DEC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 14:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiGAOHU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 10:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGAOHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 10:07:19 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3870C3205E
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 07:07:16 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id w24so2717307pjg.5
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 07:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JwyedXJnIui3flR8my7rC9vuflesL5gbqLDgX+yj0XQ=;
        b=LJVPeCNKJ32gbAcz2Tce1tlFE3QMbOk+twyid910zNBRYNhZOBRxqxUuxaZA6eqL7M
         X5Mtl6AxhUXl2XNjWBdRMzTVAisqq7DxZiA4e4lii4elkzLZS9eRD7UySBkL5FyLyHmp
         I51c+2MewPldNvitBwS5ghDrDZMK/JhREwHiblSuRZqsaDq7SS96AhSfL2wzJExZaz1L
         eiZNBwOqQf1yb+UjPbbZRUqqaO1za69tXOZaramX22MocMOPhVmyj2OQ+1o6ebpJuKhD
         k4GQCER53dX1dbHVS0jgt8hZOOVYcySGfzACNIZl3fBbFwz9DDlGCuT4aO1RjoigDVnp
         n3SQ==
X-Gm-Message-State: AJIora93IKJF0aMTRfu9NyGEPyAQHxGvzUB3aCajdZpAxIGHBYSUBqOi
        KFrzvLv7o9fQl59e5g7af9Q=
X-Google-Smtp-Source: AGRyM1vm0ID62WiF6YD+h0CL72Z0qiiuCfUZQnmK3J7Lf2FcvU+hwd7u2UQRlA64wqtmL9jS0O8ooA==
X-Received: by 2002:a17:902:e3cd:b0:16a:6db:bf80 with SMTP id r13-20020a170902e3cd00b0016a06dbbf80mr19902995ple.0.1656684435572;
        Fri, 01 Jul 2022 07:07:15 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 132-20020a62198a000000b0051bc5f4df1csm15600388pfz.154.2022.07.01.07.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 07:07:14 -0700 (PDT)
Message-ID: <4753a2ce-0cab-ce19-68d2-de7b3c15828a@acm.org>
Date:   Fri, 1 Jul 2022 07:07:13 -0700
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
        Li Zhijian <lizhijian@fujitsu.com>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-4-bvanassche@acm.org> <Yr5tlDkrTTldwjSq@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Yr5tlDkrTTldwjSq@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 20:44, Ming Lei wrote:
> On Thu, Jun 30, 2022 at 02:37:33PM -0700, Bart Van Assche wrote:
>> There are two .exit_cmd_priv implementations. Both implementations use
>> resources associated with the SCSI host. Make sure that these resources are
> 
> Please document what the exact resources associated with this SCSI host is.
> 
> We need the root cause.
> 
> I understand it might be related with module unloading, since ib_srp may
> be gone already, but not sure if it is the exact one in this report.

It is not necessary to unload ib_srp to trigger this scenario. 
Hot-unplugging an RDMA adapter used by the ib_srp driver is sufficient. 
Hot-unplugging triggers a call of srp_remove_one(). srp_remove_one() 
itself and also its caller free resources used by srp_exit_cmd_priv(), 
e.g. struct ib_device.

>> still available when .exit_cmd_priv is called by moving the .exit_cmd_priv
>> calls from scsi_host_dev_release() to scsi_forget_host(). Moving
>> blk_mq_free_tag_set() from scsi_host_dev_release() to scsi_forget_host() is
>> safe because scsi_forget_host() drains all the request queues that use the
>> host tag set. This guarantees that no requests are in flight and also that
>> no new requests will be allocated from the host tag set.
>>
>> This patch fixes the following use-after-free:
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>> Read of size 8 at addr ffff888100337000 by task multipathd/16727
> 
> What is the 8bytes buffer which triggers UAF? what does srp_exit_cmd_priv+0x27
> point to?

I think that Li already answered this question.

Thanks,

Bart.
