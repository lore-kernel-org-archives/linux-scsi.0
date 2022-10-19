Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395C2C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 16:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiJSQSX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 12:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiJSQSV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 12:18:21 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D07D1BF21D;
        Wed, 19 Oct 2022 09:18:19 -0700 (PDT)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Msm0V4VFhz6813Y;
        Wed, 19 Oct 2022 17:39:38 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 11:42:50 +0200
Received: from [10.126.171.238] (10.126.171.238) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 10:42:49 +0100
Message-ID: <28c7127f-f577-9a43-2f2f-80ef89d85a0e@huawei.com>
Date:   Wed, 19 Oct 2022 10:42:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   John Garry <john.garry@huawei.com>
Subject: Re: libata and software reset
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>
CC:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
 <7e8ef4b4-928f-895f-05ef-df111a052e8e@opensource.wdc.com>
 <a5026aa0-2674-9b2d-1a0f-ed3847fa69cc@opensource.wdc.com>
In-Reply-To: <a5026aa0-2674-9b2d-1a0f-ed3847fa69cc@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.171.238]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/10/2022 06:04, Damien Le Moal wrote:
> On 10/19/22 14:03, Damien Le Moal wrote:
>> On 10/18/22 22:24, John Garry wrote:
>>> Hi guys,
>>>
>>> In the hisi_sas driver there are times in which we need to issue an ATA
>>> software reset. For this we use hisi_sas_softreset_ata_disk() ->
>>> sas_execute_ata_cmd() -> sas_execute_tmf(), which uses libsas "slow
>>> task" mechanism to issue the command.
>> Something is wrong here... The reset command sent by that function is
>> for ATAPI (DEVICE RESET command). There is no device reset command for
>> SATA disks following the ACS standard.

Yeah, that looks wrong.

>>
>> So hisi_sas_softreset_ata_disk() seems totally bogus to me, unless you
>> have a CD/DVD drive connected to the HBA:)

Sure

>>
>> This is why the softreset function is a port operation defined by LLDs.
>> How you reset the device depends on the adapter. E.g., for AHCI, you
>> need to send a host2device FIS with the software reset bit set.

This would be quite a standard method, right?

> See: ahci_do_softreset() for AHCI.

For ahci_do_softreset(), do you just implicitly use ATA_CMD_NOP as the 
command?

For hisi_sas, maybe ATA_CMD_DEV_RESET is silently ignored when issued 
for a SATA disk, but having SRST set/unset still takes effect (and that 
is how it still works). I need to check on that.

Thanks,
John
