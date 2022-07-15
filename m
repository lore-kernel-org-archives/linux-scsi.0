Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D09C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 07:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiGOHyZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 03:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiGOHyY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 03:54:24 -0400
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3437D78E
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 00:54:23 -0700 (PDT)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.156.147])
        by sinmsgout02.his.huawei.com (SkyGuard) with ESMTP id 4LkkBB5xldz9v7J0;
        Fri, 15 Jul 2022 15:53:22 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Jul 2022 09:54:12 +0200
Received: from [10.126.169.233] (10.126.169.233) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2375.24; Fri, 15 Jul 2022 08:54:11 +0100
Message-ID: <8c8b5cca-a9ac-52b5-dea5-0f1d96358c49@huawei.com>
Date:   Fri, 15 Jul 2022 08:54:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 4/4] scsi: core: Call blk_mq_free_tag_set() earlier
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Li Zhijian <lizhijian@fujitsu.com>
References: <20220712221936.1199196-1-bvanassche@acm.org>
 <20220712221936.1199196-5-bvanassche@acm.org>
 <3c0f352a-0be6-7322-3556-8ce0d66ba8f3@huawei.com>
 <98e6554a-5d88-fcb6-d46d-a267009da014@acm.org>
 <b5f807d5-3ea0-22bb-206c-327549298b8d@huawei.com>
 <4ba6ff46-435a-9ea4-e928-7f168162f4c0@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <4ba6ff46-435a-9ea4-e928-7f168162f4c0@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.169.233]
X-ClientProxiedBy: lhreml702-chm.china.huawei.com (10.201.108.51) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2022 19:49, Bart Van Assche wrote:
>>> Semantics of the API? Shouldn't this rather be called an undocumented 
>>> aspect of blk_mq_free_tag_set()?
>>>
>>> My concern is that the "set->tags = NULL" statement might be removed 
>>> in the future from blk_mq_free_tag_set() and also that it is possible 
>>> that scsi_mq_destroy_tags() is not updated after that change.
>>
>> Sure, so how it is possible that set->tags == NULL ever when calling 
>> scsi_mq_setup_tags()? I'm just wondering why you even care.
> 
> How about applying the patch below on top of patch 4/4?
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 295c48fdb650..2aca0a838ca5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1990,10 +1990,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
> 
>   void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>   {
> -    if (!shost->tag_set.tags)
> -        return;
>       blk_mq_free_tag_set(&shost->tag_set);
> -    WARN_ON_ONCE(shost->tag_set.tags);
>   }

That looks better.

Thanks,
John
