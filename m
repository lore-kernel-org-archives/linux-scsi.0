Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E6BC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 15:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADAF7613BF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 15:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFCPmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 11:42:10 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3147 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhFCPmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 11:42:07 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FwqXS5lBBz6J9DW;
        Thu,  3 Jun 2021 23:27:52 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 17:40:20 +0200
Received: from [10.47.80.115] (10.47.80.115) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 16:40:20 +0100
Subject: Re: [PATCH 1/4] scsi: core: fix error handling of scsi_host_alloc
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-2-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <69d18ab1-f304-0d5c-c63a-ac8a39014b05@huawei.com>
Date:   Thu, 3 Jun 2021 16:40:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-2-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.115]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/06/2021 14:30, Ming Lei wrote:
> After device is initialized via device_initialize(), or its name is
> set via dev_set_name(), the device has to be freed via put_device(),
> otherwise device name will be leaked because it is allocated
> dynamically in dev_set_name().
> 
> Fixes the issue by replacing kfree(shost) via put_device(&shost->shost_gendev)
> which can help to free dev_name(&shost->shost_dev) when host state is
> in SHOST_CREATED. Meantime needn't to remove IDA and stop the kthread of
> shost->ehandler in the error handling code.
> 
> Cc: Bart Van Assche<bvanassche@acm.org>
> Cc: John Garry<john.garry@huawei.com>
> Cc: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Ming Lei<ming.lei@redhat.com>

Reviewed-by: John Garry <john.garry@huawei.com>
