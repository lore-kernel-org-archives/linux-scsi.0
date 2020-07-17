Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390CAC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 10:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 214A52083E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 10:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgGQKN1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 06:13:27 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2495 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbgGQKN1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 06:13:27 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 31D0E2E6071145B9A0EA;
        Fri, 17 Jul 2020 11:13:25 +0100 (IST)
Received: from [127.0.0.1] (10.210.167.164) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 17 Jul
 2020 11:13:23 +0100
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
To:     <Don.Brace@microchip.com>, <don.brace@microsemi.com>,
        <hare@suse.de>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <SN6PR11MB2848FA24579653F347A4E552E17F0@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <dc0e72d8-7076-060c-3cd3-3d51ac7e6de8@huawei.com>
Date:   Fri, 17 Jul 2020 11:11:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848FA24579653F347A4E552E17F0@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.167.164]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Don,

Thanks for checking this.

> I cloned:
> https://github.com/hisilicon/kernel-dev
> switched to branch: origin/private-topic-blk-mq-shared-tags-rfc-v8

I would have suggested to use v7 for now, but does not look relevant here.

> 
> And built the kernel. The hpsa driver oopsed on load. It was attempting to do driver initiated commands, so there would need to be some reserved tags set aside to communicate with the controller.
> 
> Was I supposed to add this patch on top of Hannes's hpsa patches?

I didn't think so, but I now realize that it may be necessary here - 
please see below. And since Hannes's reserved commands work is not 
merged, I do not include it.

> [   14.717025] Call Trace:
> [   14.717034]  __enqueue_cmd_and_start_io.isra.60+0x20/0x170 [hpsa]
> [   14.717039]  hpsa_scsi_do_simple_cmd.isra.62+0x6b/0xd0 [hpsa]
> [   14.717042]  hpsa_scsi_do_simple_cmd_with_retry+0x63/0x160 [hpsa]
> [   14.717045]  hpsa_scsi_do_inquiry+0x62/0xc0 [hpsa]
> [   14.717048]  hpsa_init_one+0x1167/0x1400 [hpsa]
> [   14.717052]  local_pci_probe+0x42/0x80
> [   14.717054]  work_for_cpu_fn+0x16/0x20
> [   14.717057]  process_one_work+0x1a7/0x370
> [   14.717059]  ? process_one_work+0x370/0x370
> [   14.717061]  worker_thread+0x1c9/0x370
> [   14.717062]  ? process_one_work+0x370/0x370
> [   14.717064]  kthread+0x114/0x130
> [   14.717065]  ? kthread_park+0x80/0x80
> [   14.717068]  ret_from_fork+0x22/0x30
> [   14.717070] Modules linked in: crc32c_intel libahci(+) uas tg3(+) libata usb_storage i2c_algo_bit hpsa(+) scsi_transport_sas wmi dm_mirror dm_region_hash dm_log dm_mod
> [   14.717077] CR2: 0000000000000010
> [   14.717099] ---[ end trace 3845f459e9223caa ]---
> [   14.724750] ERST: [Firmware Warn]: Firmware does not respond in time.
> [   14.724753] RIP: 0010:blk_mq_unique_tag+0x5/0x20
> [   14.724754] Code: cd 0f 1f 40 00 0f 1f 44 00 00 8b 87 cc 00 00 00 83 f8 02 75 03 83 06 01 b8 01 00 00 00 c3 0f 1f 80 00 00 00 00 0f 1f 44 00 00 <48> 8b 47 10 0f b7 57 20 8b 80 94 01 00 00 c1 e0 10 09 d0 c3 0f 1f
> [   14.724755] RSP: 0000:ffff989f42893d08 EFLAGS: 00010246
> [   14.724756] RAX: ffffffffc0493f80 RBX: ffff8ab761c00000 RCX: 0000000000000000
> [   14.724757] RDX: ffff8ab9b7600000 RSI: ffff8ab761c00000 RDI: 0000000000000000
> [   14.724757] RBP: ffff8ab9a5b98000 R08: ffffffffffffffff R09: 0000000000000000
> [   14.724758] R10: ffff8ab8b5280070 R11: 0000000000000000 R12: 000000000000000a
> [   14.724758] R13: 0000000000000002 R14: ffff8ab761c00000 R15: ffffffffc0493b60
> [   14.724759] FS:  0000000000000000(0000) GS:ffff8ab9b7600000(0000) knlGS:0000000000000000
> [   14.724760] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   14.724760] CR2: 0000000000000010 CR3: 000000024f33e006 CR4: 00000000001606f0
> [   14.724761] Kernel panic - not syncing: Fatal exception
> [   14.724833] Kernel Offset: 0x38400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [   16.487017] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> 
> 
>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>> ---
>>    drivers/scsi/hpsa.c | 44 +++++++-------------------------------------
>>    drivers/scsi/hpsa.h |  1 -
>>    2 files changed, 7 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c index
>> 1e9302e99d05..f807f9bdae85 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -980,6 +980,7 @@ static struct scsi_host_template hpsa_driver_template = {
>>        .shost_attrs = hpsa_shost_attrs,
>>        .max_sectors = 2048,
>>        .no_write_same = 1,
>> +     .host_tagset = 1,
>>    };
>>
>>    static inline u32 next_command(struct ctlr_info *h, u8 q) @@
>> -1144,12 +1145,14 @@ static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
>>    static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
>>        struct CommandList *c, int reply_queue)
>>    {
>> +     u32 blk_tag = blk_mq_unique_tag(c->scsi_cmd->request);

For the hpsa_scsi_do_inquiry() -> fill_cmd(HPSA_INQUIRY) call, 
c->scsi_cmd = SCSI_CMD_BUSY, which just seems to be a pointer flag.

And so I guess that c->scsi_cmd->request == NULL, and we deference this 
in blk_mq_unique_tag() -> oops. I figure that the code should look like 
this for now:

static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
struct CommandList *c, int reply_queue)
{
	if (c->scsi_cmd->request) {
		u32 blk_tag = blk_mq_unique_tag(c->scsi_cmd->request);

		reply_queue = blk_mq_unique_tag_to_hwq(blk_tag);
	}

	dial_down_lockup_detection_during_fw_flash(h, c);
	atomic_inc(&h->commands_outstanding);
	if (c->device)
	atomic_inc(&c->device->commands_outstanding);

	switch (c->cmd_type) {

But then reply_queue may be = DEFAULT_REPLY_QUEUE (=1), so I am not sure 
if that is a problem. However this issue should go away with Hannes's 
reserved command work, as we allocate a "real" SCSI cmd there.

@Hannes, any suggestion what to do here?

>> +
>>        dial_down_lockup_detection_during_fw_flash(h, c);
>>        atomic_inc(&h->commands_outstanding);
>>        if (c->device)
>>                atomic_inc(&c->device->commands_outstanding);
>>
>> -     reply_queue = h->reply_map[raw_smp_processor_id()];
>> +     reply_queue = blk_mq_unique_tag_to_hwq(blk_tag);
>>        switch (c->cmd_type) {
>>        case CMD_IOACCEL1:
>>                set_ioaccel1_performant_mode(h, c, reply_queue); @@
>> -5653,8 +5656,6 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
>>        /* Get the ptr to our adapter structure out of cmd->host. */
>>        h = sdev_to_hba(cmd->device);
>>
>> -     BUG_ON(cmd->request->tag < 0);
>> -
>>        dev = cmd->device->hostdata;
>>        if (!dev) {
>>                cmd->result = DID_NO_CONNECT << 16; @@ -5830,7 +5831,7
>> @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
>>        sh->hostdata[0] = (unsigned long) h;
>>        sh->irq = pci_irq_vector(h->pdev, 0);
>>        sh->unique_id = sh->irq;
>> -
>> +     sh->nr_hw_queues = h->msix_vectors > 0 ? h->msix_vectors : 1;
>>        h->scsi_host = sh;
>>        return 0;
>>    }
>> @@ -5856,7 +5857,8 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
>>     */
>>    static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
>>    {
>> -     int idx = scmd->request->tag;
>> +     u32 blk_tag = blk_mq_unique_tag(scmd->request);
>> +     int idx = blk_mq_unique_tag_to_tag(blk_tag);

@Hannes, This looks like a pointless change - we make a 32b unique tag, 
including the request->tag, and then convert back to the request->tag.

>>
>>        if (idx < 0)
>>                return idx;
>> @@ -7456,26 +7458,6 @@ static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
>>        h->msix_vectors = 0;
>>    }

Thanks,
John
