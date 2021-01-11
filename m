Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CD8C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 12:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF05C224BD
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 12:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbhAKMHt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 07:07:49 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2302 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbhAKMHt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 07:07:49 -0500
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DDsnR6hZLz67Zyf;
        Mon, 11 Jan 2021 20:04:11 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 11 Jan 2021 13:07:07 +0100
Received: from [10.210.171.188] (10.210.171.188) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 12:07:05 +0000
Subject: Re: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx hw
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Viswas G <Viswas.G@microchip.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <akshatzen@google.com>, <Ruksar.devadi@microchip.com>,
        Radha Ramachandran <radha@google.com>, <bjashnani@google.com>,
        <vishakhavc@google.com>, <Ashokkumar.N@microchip.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        <ming.lei@redhat.com>
References: <1609845423-110410-1-git-send-email-john.garry@huawei.com>
 <CAMGffEmJwH26VJm+Pr8FA5Dk0HxZstcuj+3S_5zK+RM9SahU0w@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a84777c9-9247-794e-b593-109a858d3b76@huawei.com>
Date:   Mon, 11 Jan 2021 12:05:59 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAMGffEmJwH26VJm+Pr8FA5Dk0HxZstcuj+3S_5zK+RM9SahU0w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.188]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/01/2021 11:57, Jinpu Wang wrote:
> Hi John,
> 
> 
> On Tue, Jan 5, 2021 at 12:21 PM John Garry <john.garry@huawei.com> wrote:
>>
>> In commit 05c6c029a44d ("scsi: pm80xx: Increase number of supported
>> queues"), support for 80xx chip was improved by enabling multiple HW
>> queues.
>>
>> In this, like other SCSI MQ HBA drivers, the HW queues were not exposed
>> to upper layer, and instead the driver managed the queues internally.
>>
>> However, this management duplicates blk-mq code. In addition, the HW queue
>> management is sub-optimal for a system where the number of CPUs exceeds
>> the HW queues - this is because queues are selected in a round-robin
>> fashion, when it would be better to make adjacent CPUs submit on the same
>> queue. And finally, the affinity of the completion queue interrupts is not
>> set to mirror the cpu<->HQ queue mapping, which is suboptimal.
>>
>> As such, for when MSIX is supported, expose HW queues to upper layer. Flag
>> PCI_IRQ_AFFINITY is set for allocating the MSIX vectors to automatically
>> assign affinity for the completion queue interrupts.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>>
>> ---
>> I sent as an RFC/RFT as I have no HW to test. In addition, since HW queue
>> #0 is used always for internal commands (like in send_task_abort()), if
>> all CPUs associated with HW queue #0 are offlined, the interrupt for that
>> queue will be shutdown, and no CPUs would be available to service any
>> internal commands completion. To solve that, we need [0] merged first and
>> switch over to use the new API. But we can still test performance in the
>> meantime.
>>
>> I assume someone else is making the change to use the request tag for IO
>> tag management.
>>
>> [0] https://lore.kernel.org/linux-scsi/47ba045e-a490-198b-1744-529f97192d3b@suse.de/
> Thanks for the patch, maybe Viswas can help to test?
> 

That's what I am hoping for :)

Thanks!

> 

