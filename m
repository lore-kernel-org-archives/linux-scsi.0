Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66485C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 09:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiFNJaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 05:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiFNJaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 05:30:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2606840E53;
        Tue, 14 Jun 2022 02:30:20 -0700 (PDT)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LMjmY2nw7z6H7Tb;
        Tue, 14 Jun 2022 17:28:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 11:30:18 +0200
Received: from [10.195.33.253] (10.195.33.253) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 10:30:17 +0100
Message-ID: <731c26d2-5124-60a6-c8de-d979ee2af467@huawei.com>
Date:   Tue, 14 Jun 2022 10:33:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH RFC v2 02/18] scsi: core: Resurrect
 scsi_{get,free}_host_dev()
To:     Christoph Hellwig <hch@lst.de>
CC:     <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <brking@us.ibm.com>, <hare@suse.de>, <linux-block@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <chenxiang66@hisilicon.com>
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-3-git-send-email-john.garry@huawei.com>
 <20220614064403.GB31683@lst.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220614064403.GB31683@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.33.253]
X-ClientProxiedBy: lhreml746-chm.china.huawei.com (10.201.108.196) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/06/2022 07:44, Christoph Hellwig wrote:
> On Thu, Jun 09, 2022 at 06:29:03PM +0800, John Garry wrote:
>> This reverts commit 6bd49b1a8d43ec118c55f3aaa7577729b52bde15.
> 
> Please add an actual text describing why you are doing this and how
> insteasd of this completely pointless revert line.
> 
> 
> .

OK. And in hindsight it would have been a good opportunity to mention 
something which I am undecided on - that is which scsi_device to use for 
these reserved commands?

In this series I use the scsi shost sdev for all reserved commands, but 
maybe we should use the target sdev.

Pros of using scsi host sdev:
- don't need to worry about request queue freezing
- don't need to worry about running out of request queue budget
- available when scsi host is added - libata adds target sdev after some 
internal commands are sent, and this would be a bit painful to change, 
however adding the sdev earlier would seem to be a good change to make

Cons:
- generally better to use same scsi device as target (or is it?). For 
example, it seems better to have reserved scsi_cmnd.device actually set 
to the target sdev.
- don't need to add stuff like ata_is_scmd_ata_internal() later in this 
series

Prob other reasons which I have forgot about. Please let me know if you 
have any thoughts on this.

Cheers,
John
