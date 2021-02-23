Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9CBC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 16:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2629764E62
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 16:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhBWQTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 11:19:39 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2598 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhBWQTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 11:19:39 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DlPJr6PKFz67rCB;
        Wed, 24 Feb 2021 00:14:52 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Feb 2021 17:18:53 +0100
Received: from [10.47.0.222] (10.47.0.222) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 23 Feb
 2021 16:18:51 +0000
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     Roger Willcocks <roger@filmlight.ltd.uk>
CC:     <Don.Brace@microchip.com>, <mwilck@suse.com>,
        <buczek@molgen.mpg.de>, <martin.petersen@oracle.com>,
        <ming.lei@redhat.com>, <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, <hare@suse.de>,
        <Kevin.Barnett@microchip.com>, <pmenzel@molgen.mpg.de>,
        <hare@suse.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
 <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
 <0DB85ADC-B962-4AF9-B106-3F3B412CE4DB@filmlight.ltd.uk>
 <4bff6232-6abd-dae8-c240-07a1a40178bf@huawei.com>
 <BF6685B6-B23F-49BC-B905-6ABE6FD3F44D@filmlight.ltd.uk>
From:   John Garry <john.garry@huawei.com>
Message-ID: <81afb054-fe31-3e67-0087-980a31d5adb6@huawei.com>
Date:   Tue, 23 Feb 2021 16:17:04 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <BF6685B6-B23F-49BC-B905-6ABE6FD3F44D@filmlight.ltd.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.0.222]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/02/2021 14:06, Roger Willcocks wrote:
> 
> 
>> On 23 Feb 2021, at 08:57, John Garry <john.garry@huawei.com> wrote:
>>
>> On 22/02/2021 14:23, Roger Willcocks wrote:
>>> FYI we have exactly this issue on a machine here running CentOS 8.3 (kernel 4.18.0-240.1.1) (so presumably this happens in RHEL 8 too.)
>>> Controller is MSCC / Adaptec 3154-8i16e driving 60 x 12TB HGST drives configured as five x twelve-drive raid-6, software striped using md, and formatted with xfs.
>>> Test software writes to the array using multiple threads in parallel.
>>> The smartpqi driver would report controller offline within ten minutes or so, with status code 0x6100c
>>> Changed the driver to set 'nr_hw_queues = 1’ and then tested by filling the array with random files (which took a couple of days), which completed fine, so it looks like that one-line change fixes it.
>>
>> That just makes the driver single-queue.
>>
> 
> All I can say is it fixes the problem. Write performance is two or three percent faster than CentOS 6.5 on the same hardware.
> 
> 
>> As such, since the driver uses blk_mq_unique_tag_to_hwq(), only hw queue #0 will ever be used in the driver.
>>
>> And then, since the driver still spreads MSI-X interrupt vectors over all CPUs [from pci_alloc_vectors(PCI_IRQ_AFFINITY)], if CPUs associated with HW queue #0 are offlined (probably just cpu0), there is no CPUs available to service queue #0 interrupt. That's what I think would happen, from a quick glance at the code.
>>
> 
> Surely that would be an issue even if it used multiple queues (one of which would be queue #0) ?
> 

Well, no. Because there is currently a symmetry between HW queue context 
in the block layer and the HW queues in the LLDD. So if hwq0 were mapped 
to cpu0 only, if cpu0 is offline, block layer will not send commands on 
hwq0. By setting nr_hw_queues=1, that symmetry breaks - every cpu tries 
to send on hwq0, but irq core code will disable hwq0 interrupt when cpu0 
is offline - that's because it is managed.

That's how it looks to me - I did not check the LLDD code too closely. 
Please discuss with Don.

Thanks,
John

>>
>>> Would, of course, be helpful if this was back-ported.
>>> —
>>> Roger
> 
> 
> .
> 

