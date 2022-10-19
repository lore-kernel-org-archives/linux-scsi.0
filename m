Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5DCC4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 13:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiJSNek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 09:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiJSNeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 09:34:22 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937962BCD;
        Wed, 19 Oct 2022 06:23:26 -0700 (PDT)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MsnB31g8cz67Zm5;
        Wed, 19 Oct 2022 18:32:59 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 12:34:03 +0200
Received: from [10.126.171.238] (10.126.171.238) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 11:34:02 +0100
Message-ID: <3963334b-6c76-474f-0003-28da53d0ca76@huawei.com>
Date:   Wed, 19 Oct 2022 11:34:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
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
 <28c7127f-f577-9a43-2f2f-80ef89d85a0e@huawei.com>
 <399805b2-d632-997b-5f90-c5e98357d53a@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <399805b2-d632-997b-5f90-c5e98357d53a@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.171.238]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/10/2022 11:15, Damien Le Moal wrote:
>> For hisi_sas, maybe ATA_CMD_DEV_RESET is silently ignored when issued
>> for a SATA disk, but having SRST set/unset still takes effect (and that
>> is how it still works). I need to check on that.
> Checked SATA-IO v3.5a. Software reset is explained in "11.4
> Software reset protocol" and involves 2 things for the host to do:
> 
> DSR0: Software_reset_asserted, this state is entered if a Register Host
> to Device FIS is received with the C bit in the FIS cleared to zero and
> the SRST bit set to one in the Device Control register.
> If in this state, the device begins its initialization and diagnostics
> processing and awaits the clearing of the SRST bit.
> 
> DSR1: Execute_diagnostics, this state is entered if a Register Host to
> Device FIS is received with the C bit in the FIS cleared to zero and the
> SRST bit cleared to zero in the Device Control register.
> If in this state, the device completes initialization and processing of
> its diagnostics.
> 
> Which confirms what libahci is doing: essentially zeroing a tf with
> ata_tf_init() and setting + resetting the SRST bit, sending the tf each
> time.

Ah, so since the C bit is not set in hisi_sas_fill_ata_reset_cmd(), I 
think that the command field is just ignored. Indeed, the spec says that 
setting C and SRST together is invalid.

Thanks,
John
