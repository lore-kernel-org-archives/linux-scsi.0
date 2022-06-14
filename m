Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCEDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 09:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238904AbiFNJ0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 05:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiFNJ0O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 05:26:14 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98A5B7FC;
        Tue, 14 Jun 2022 02:26:12 -0700 (PDT)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LMjjW2RRcz67vDG;
        Tue, 14 Jun 2022 17:26:07 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 11:26:10 +0200
Received: from [10.195.33.253] (10.195.33.253) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 10:26:09 +0100
Message-ID: <3aee8ffe-d8c6-71b2-8725-028406efef5c@huawei.com>
Date:   Tue, 14 Jun 2022 10:29:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH RFC v2 01/18] blk-mq: Add a flag for reserved requests
To:     Christoph Hellwig <hch@lst.de>
CC:     <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <brking@us.ibm.com>, <hare@suse.de>, <linux-block@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <chenxiang66@hisilicon.com>
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-2-git-send-email-john.garry@huawei.com>
 <20220614064303.GA31683@lst.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220614064303.GA31683@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.33.253]
X-ClientProxiedBy: lhreml746-chm.china.huawei.com (10.201.108.196) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/06/2022 07:43, Christoph Hellwig wrote:
> On Thu, Jun 09, 2022 at 06:29:02PM +0800, John Garry wrote:
>> Add a flag for reserved requests so that drivers may know this for any
>> special handling.
>>
>> The 'reserved' argument in blk_mq_ops.timeout callback could now be
>> replaced by using this flag.
> And we should probably do that ASAP, independent of the rest of this
> series. 

We only have 2x users of the 'reserved' arg for 11x implementations of 
blk_mq_ops.timeout:
- mtip32xx.c
- scsi_lib.c

scsi_lib.c is dubious as currently scsi does use reserved commands. So 
we really only have 1x.

I'd be happy to take any spin-off series to make this one more 
manageable, but is just removing an arg a strong enough reason for that? 
That reserved arg is passed around a lot in the blk-mq iter functions, 
so probably yes.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Thanks
