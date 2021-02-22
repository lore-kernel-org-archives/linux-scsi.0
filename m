Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EA2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4657164DD3
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhBVIs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 03:48:27 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2592 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhBVIs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 03:48:26 -0500
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DkbH468F9z67rPq;
        Mon, 22 Feb 2021 16:40:32 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 22 Feb 2021 09:47:44 +0100
Received: from [10.210.165.112] (10.210.165.112) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 22 Feb 2021 08:47:44 +0000
Subject: Re: [PATCH 01/35] scsi: drop gdth driver
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
References: <20210113090500.129644-1-hare@suse.de>
 <20210113090500.129644-2-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <66b267da-2480-90fa-bf1a-193a0b477109@huawei.com>
Date:   Mon, 22 Feb 2021 08:45:58 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210113090500.129644-2-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.165.112]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/01/2021 09:04, Hannes Reinecke wrote:
> The gdth driver refers to a SCSI parallel, PCI-only HBA RAID adapter
> which was manufactured by the now-defunct ICP Vortex company, later
> acquired by Adaptec and superseded by the aacraid series of controllers.
> The driver itself would require a major overhaul before any modifications
> can be attempted, but seeing that it's unlikely to have any users left
> it should rather be removed completely.
> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> Cautiously-Acked-by: Christoph Hellwig<hch@lst.de>

So it seems that scsi_get_host_dev() and
scsi_free_host_dev() are still hanging around without a user...

Sounding like a very broken record - I would rather if we had the 
reserved commands patchset to use them now...
