Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C9DC43217
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 13:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiJSNRM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 09:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJSNQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 09:16:18 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7E21FF8D;
        Wed, 19 Oct 2022 06:02:06 -0700 (PDT)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MsmmM1fFCz67m9N;
        Wed, 19 Oct 2022 18:14:11 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Wed, 19 Oct 2022 12:15:15 +0200
Received: from [10.126.171.238] (10.126.171.238) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 11:15:14 +0100
Message-ID: <485beb99-d2a1-77d5-7a73-80bc3955f1f9@huawei.com>
Date:   Wed, 19 Oct 2022 11:15:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   John Garry <john.garry@huawei.com>
Subject: Re: libata and software reset
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     Hannes Reinecke <hare@suse.de>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Xiang Chen" <chenxiang66@hisilicon.com>
References: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
 <Y07AmUoyq8+HVzQU@x1-carbon>
 <4011744f-d6b5-acab-4efa-95465df4e98b@huawei.com>
 <01229332-aa52-0952-5ef5-a223d726a369@opensource.wdc.com>
In-Reply-To: <01229332-aa52-0952-5ef5-a223d726a369@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.171.238]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/10/2022 10:56, Damien Le Moal wrote:
>> The difference really comes down to the controller programming interface.
>>
>> For ahci we have a MMIO interface to issue the software reset command.
>>
>> For my SAS controller of interest, there is no such MMIO interface. To
>> issue the reset we build a h2d fis with a SRST set, and send on the
>> controller ring buffer like any other IO.
>>
>> As I mentioned, we can set the SRST for the h2d fis on the HW interface
>> without issue, and it works fine. The problem for me is that the command
>> comes via libsas/driver, and I would like it to come from libata such
>> that it has a ATA queued command associated. But then we have the
>> problem that the port is frozen at such times that we want to issue this
>> command.
> Yeah, qc is too high level for this to work.

Some more background is that this is all related to the "reserved" 
commands work. The issue is that it is difficult to differentiate 
between this libsas softreset command and normal ATA queued commands - 
the normal check is "is the device associated sata", but that doesn't 
work. If we could always have a ATA queued command, then that would be 
better. But, as you say, it is too high level.

Let me check what else I would do. BTW, I will send an update on that 
work in a day or so.

> But we could probably do
> something generic at TF or FIS level. libata-sata.c has already some
> code in that area, something for a "reset TF/FIS" would fit in that file
> too. libahci could also use that too.
>

yeah, that would seem a good consolidation.

Thanks!
