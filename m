Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B82C47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 10:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47968613AF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 10:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhFAKgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 06:36:54 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3110 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhFAKgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 06:36:53 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FvSxF0H99z6Q2g7;
        Tue,  1 Jun 2021 18:26:09 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 12:35:11 +0200
Received: from [10.47.91.52] (10.47.91.52) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 1 Jun 2021
 11:35:10 +0100
Subject: Re: [PATCH V3 0/3] scsi: two fixes in scsi_add_host_with_dma
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d37d30cf-8293-e34e-0b4f-eebfcfa56bc9@huawei.com>
Date:   Tue, 1 Jun 2021 11:34:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210531050727.2353973-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.52]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/05/2021 06:07, Ming Lei wrote:
> Hello Martin,
> 
> 
> Fix two memory leaks and one double free issue in alloc/add host
> code path.
> 
> 
> V3:
> 	- fix memory leak caused in scsi_host_alloc
> 	- comment typo suggested by John
> 
> V2:
> 	- add patch 2 for addressing shost leak in case of adding host
> 	  failure, reported by John Garry.
> 
> Ming Lei (3):
>    scsi: core: use put_device() to release host
>    scsi: core: fix failure handling of scsi_add_host_with_dma
>    scsi: core: put ->shost_gendev.parent in failure handling path
> 
>   drivers/scsi/hosts.c | 25 ++++++++++++-------------
>   1 file changed, 12 insertions(+), 13 deletions(-)
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>


I tested this again with the same experiment as before to error in
scsi_add_host_with_dma(), and we don't call scsi_host_dev_release() now. 
The shost_gendev dev refcount is 2 upon exit in scsi_add_host_with_dma().

We don't call scsi_host_cls_release() either, so I guess a ref count is 
leaked for shost_dev - I see its refcount is 1 at exit in 
scsi_add_host_with_dma(). We have the device_initialize(), device_add(), 
device_del() in the alloc and add host functions, but I don't know who 
is responsible for the final "device put".

Thanks,
John
