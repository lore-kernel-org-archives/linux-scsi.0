Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8D3C4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 11:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiJSLAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 07:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbiJSK72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 06:59:28 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92D8D42;
        Wed, 19 Oct 2022 03:29:24 -0700 (PDT)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MslmW4F1Kz689J4;
        Wed, 19 Oct 2022 17:29:15 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 11:32:27 +0200
Received: from [10.126.171.238] (10.126.171.238) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 10:32:26 +0100
Message-ID: <4011744f-d6b5-acab-4efa-95465df4e98b@huawei.com>
Date:   Wed, 19 Oct 2022 10:32:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   John Garry <john.garry@huawei.com>
Subject: Re: libata and software reset
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
 <Y07AmUoyq8+HVzQU@x1-carbon>
In-Reply-To: <Y07AmUoyq8+HVzQU@x1-carbon>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.171.238]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/10/2022 16:04, Niklas Cassel wrote:
>> Hi guys,
>>
>> In the hisi_sas driver there are times in which we need to issue an ATA
>> software reset. For this we use hisi_sas_softreset_ata_disk() ->
>> sas_execute_ata_cmd() -> sas_execute_tmf(), which uses libsas "slow task"
>> mechanism to issue the command.
>>
>> I would like if libata provided such a function to issue a software reset,
>> such that we can send the command as an ATA queued command.
>>
>> The problem is that often when we would want to issue this software reset
>> the associated ata port is frozen, like in ATA EH, and so we cannot issue
>> ATA queued commands - internal or normal - at that time.
>>
>> Is there any way to solve this? Or I am just misunderstanding how and when
>> ATA queued commands can and should be used?
>>
> Hello John,

Hi Niklas,

> 
> See the kdoc above __ata_port_freeze():
> "This function is called when HSM violation or some other
> condition disrupts normal operation of the port.  Frozen port
> is not allowed to perform any operation until the port is
> thawed, which usually follows a successful reset.

ok, I see.

> 
> ap->ops->freeze() callback can be used for freezing the port
> hardware-wise (e.g. mask interrupt and stop DMA engine).  If a
> port cannot be frozen hardware-wise, the interrupt handler
> must ack and clear interrupts unconditionally while the port
> is frozen."
> 
> 
> ata_port_operations.qc_issue() is obviously an operation on the port,
> so it makes sense that it is not allowed.

hmmm..ok, then.


> Interrupts are also usually masked or disabled at this time, so we
> won't get an IRQ with the completion.

Doesn't this policy really just depend on the host controller driver?

> 
> Perhaps one could argue that there could be an API to execute a polled
> command. But if the port is in a bad state,
  e.g. a HSM error (RDY bit
> is not set), issuing a command would likely fail anyway, regardless if
> using polling or IRQs.
> 
> 
>> I assume that ata_port_operations.softreset callback requires a method to be
>> able to issue the softreset directly from the driver, like ahci_softreset()
>> -> ahci_do_softreset() -> ahci_exec_polled_cmd().
> Yes, looking .softreset in a few ata drivers, they all seem issue the
> softreset directly from the driver.
> (e.g. ahci_do_softreset() calls ahci_exec_polled_cmd() which just always
> uses bit 0 in PORT_CMD_ISSUE, so it ignores hw_tag.)
> 
> But I don't think that I fully understand your problem.
> 
> hisi_sas_softreset_ata_disk() -> sas_execute_ata_cmd() -> sas_execute_tmf()
> calls lldd_execute_task() (hisi_sas_queue_command()) and then calls
> waits for completion.
> 
> How is this different from e.g. the libahci case?

The difference really comes down to the controller programming interface.

For ahci we have a MMIO interface to issue the software reset command.

For my SAS controller of interest, there is no such MMIO interface. To 
issue the reset we build a h2d fis with a SRST set, and send on the 
controller ring buffer like any other IO.

As I mentioned, we can set the SRST for the h2d fis on the HW interface 
without issue, and it works fine. The problem for me is that the command 
comes via libsas/driver, and I would like it to come from libata such 
that it has a ATA queued command associated. But then we have the 
problem that the port is frozen at such times that we want to issue this 
command.

> Doesn't this end up being the same as resetting the port directly from the
> driver? (if we ignore all the callbacks)
> Or do you actually get stuck on a ata_port_is_frozen() check somewhere?


Thanks,
John
