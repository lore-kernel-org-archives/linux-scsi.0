Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4FDC47099
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 15:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5765D613F4
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 15:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFCPma (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 11:42:30 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3148 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhFCPma (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 11:42:30 -0400
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Fwqcn0XzHz6S1SD;
        Thu,  3 Jun 2021 23:31:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 17:40:44 +0200
Received: from [10.47.80.115] (10.47.80.115) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 16:40:43 +0100
Subject: Re: [PATCH 2/4] scsi: core: fix failure handling of
 scsi_add_host_with_dma
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-3-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e199f187-805e-6a99-3996-5f5834e32c9e@huawei.com>
Date:   Thu, 3 Jun 2021 16:40:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-3-ming.lei@redhat.com>
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
> When scsi_add_host_with_dma() return failure, the caller will call
> scsi_host_put(shost) to release everything allocated for this host
> instance. So we can't free allocated stuff in scsi_add_host_with_dma(),
> otherwise double free will be caused.
> 
> Strictly speaking, these host resources allocation should have been
> moved to scsi_host_alloc(), but the allocation may need driver's
> info which can be built between calling scsi_host_alloc() and
> scsi_add_host(), so just keep the allocations in
> scsi_add_host_with_dma().
> 
> Fixes the problem by relying on host device's release handler to
> release everything.
> 
> Cc: Bart Van Assche<bvanassche@acm.org>
> Cc: John Garry<john.garry@huawei.com>
> Cc: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Ming Lei<ming.lei@redhat.com>

Reviewed-by: John Garry <john.garry@huawei.com>
