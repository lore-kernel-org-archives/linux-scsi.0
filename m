Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ECEC43217
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 13:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiJRNYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 09:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiJRNYF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 09:24:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DE3C90D5;
        Tue, 18 Oct 2022 06:24:03 -0700 (PDT)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MsDzv0jRNz67tKy;
        Tue, 18 Oct 2022 21:22:19 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Tue, 18 Oct 2022 15:24:01 +0200
Received: from [10.48.144.241] (10.48.144.241) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 14:24:01 +0100
Message-ID: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
Date:   Tue, 18 Oct 2022 14:24:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>
From:   John Garry <john.garry@huawei.com>
CC:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: libata and software reset
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.144.241]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi guys,

In the hisi_sas driver there are times in which we need to issue an ATA 
software reset. For this we use hisi_sas_softreset_ata_disk() -> 
sas_execute_ata_cmd() -> sas_execute_tmf(), which uses libsas "slow 
task" mechanism to issue the command.

I would like if libata provided such a function to issue a software 
reset, such that we can send the command as an ATA queued command.

The problem is that often when we would want to issue this software 
reset the associated ata port is frozen, like in ATA EH, and so we 
cannot issue ATA queued commands - internal or normal - at that time.

Is there any way to solve this? Or I am just misunderstanding how and 
when ATA queued commands can and should be used?

I assume that ata_port_operations.softreset callback requires a method 
to be able to issue the softreset directly from the driver, like 
ahci_softreset() -> ahci_do_softreset() -> ahci_exec_polled_cmd().

Thanks,
John
