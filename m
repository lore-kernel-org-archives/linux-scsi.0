Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B26CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 18:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiGNStx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 14:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239146AbiGNStp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 14:49:45 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6586925E89
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 11:49:44 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id a15so3709433pjs.0
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 11:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+zKy5g2YDAb5huifDDSF/8JUexdcTAQ89IVa8OT51pw=;
        b=RQbojeR0Yf5yBdR2R65CI80/Tx3f0hrY0icFwCy/PnQB7RDAK6FvPXfBPhtJJlc+7l
         TWnmIaSftcbXVrkksIkmFm4BU0F2YVDjygk5p5MryUO17cYjD9bj2FYWl7/k3YZksEXo
         iEs4mZgxUe/6kc+ESz87mA1VrcufPE46v9dc0RRDTXuKovsypzXQoDoqeJythdt7+Ccp
         6WsdsHqCku6qszxKYenuVFmpPhbZ4AamXt5mmunf1zOTa2jcMv7zB259zMKazuYgNzW+
         z7hEHOYBCV6BMDP+cwRa9sj9IMNi5MVzJsqjDNlz2hcot32/vpofO+lmNjj3imGJdZ3O
         zfjw==
X-Gm-Message-State: AJIora8LnJXjfqNEqkDtwHmNrpgagoRHwBy1/Mumjpe1RYU8hvmXeIdA
        Bpgvwrv+WMf1CnVYsvyKU4eENAYa74U=
X-Google-Smtp-Source: AGRyM1sz4KJyilFWnNKZbQks9xUhq4UaX1JNjBUUZDmwzR1gvsu6St8UUpvneXWKnT2l1YX1voLzpQ==
X-Received: by 2002:a17:903:191:b0:16c:3d49:b0c8 with SMTP id z17-20020a170903019100b0016c3d49b0c8mr9659827plg.95.1657824583851;
        Thu, 14 Jul 2022 11:49:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9fab:70d1:f0e7:922b? ([2620:15c:211:201:9fab:70d1:f0e7:922b])
        by smtp.gmail.com with ESMTPSA id 125-20020a620483000000b00528c4c770c5sm2051215pfe.77.2022.07.14.11.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 11:49:43 -0700 (PDT)
Message-ID: <4ba6ff46-435a-9ea4-e928-7f168162f4c0@acm.org>
Date:   Thu, 14 Jul 2022 11:49:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 4/4] scsi: core: Call blk_mq_free_tag_set() earlier
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Li Zhijian <lizhijian@fujitsu.com>
References: <20220712221936.1199196-1-bvanassche@acm.org>
 <20220712221936.1199196-5-bvanassche@acm.org>
 <3c0f352a-0be6-7322-3556-8ce0d66ba8f3@huawei.com>
 <98e6554a-5d88-fcb6-d46d-a267009da014@acm.org>
 <b5f807d5-3ea0-22bb-206c-327549298b8d@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b5f807d5-3ea0-22bb-206c-327549298b8d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/22 05:25, John Garry wrote:
> On 13/07/2022 21:04, Bart Van Assche wrote:
>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>> index 2aca0a838ca5..295c48fdb650 100644
>>>> --- a/drivers/scsi/scsi_lib.c
>>>> +++ b/drivers/scsi/scsi_lib.c
>>>> @@ -1990,7 +1990,10 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>>>>   void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>>>>   {
>>>> +    if (!shost->tag_set.tags)
>>>> +        return;
>>>>       blk_mq_free_tag_set(&shost->tag_set);
>>>> +    WARN_ON_ONCE(shost->tag_set.tags);
>>>
>>> blk_mq_free_tag_set() clears the tagset tags pointer, so I don't know 
>>> why you don't trust the semantics of that API - this seems like 
>>> paranoia.
>>
>> Semantics of the API? Shouldn't this rather be called an undocumented 
>> aspect of blk_mq_free_tag_set()?
>>
>> My concern is that the "set->tags = NULL" statement might be removed 
>> in the future from blk_mq_free_tag_set() and also that it is possible 
>> that scsi_mq_destroy_tags() is not updated after that change.
> 
> Sure, so how it is possible that set->tags == NULL ever when calling 
> scsi_mq_setup_tags()? I'm just wondering why you even care.

How about applying the patch below on top of patch 4/4?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 295c48fdb650..2aca0a838ca5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1990,10 +1990,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)

  void scsi_mq_destroy_tags(struct Scsi_Host *shost)
  {
-	if (!shost->tag_set.tags)
-		return;
  	blk_mq_free_tag_set(&shost->tag_set);
-	WARN_ON_ONCE(shost->tag_set.tags);
  }


Thanks,

Bart.
