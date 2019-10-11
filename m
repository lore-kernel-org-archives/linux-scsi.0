Return-Path: <SRS0=6PDV=YE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD4EC4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Oct 2019 03:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23030206A1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Oct 2019 03:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfJKDIZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Oct 2019 23:08:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3693 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfJKDIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Oct 2019 23:08:25 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AF7A023E0C4A8E9E7193;
        Fri, 11 Oct 2019 11:08:23 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 11 Oct 2019
 11:08:15 +0800
Subject: Re: [PATCH] scsi: core: fix uninit-value access of variable sshdr
To:     Bart Van Assche <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>
References: <1570709143-147364-1-git-send-email-zhengbin13@huawei.com>
 <fe58cc1c-f15a-2b05-24b7-24d9ef6f4f34@acm.org>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <fd1239fd-96a9-1779-f5d4-5ce91d64819b@huawei.com>
Date:   Fri, 11 Oct 2019 11:07:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <fe58cc1c-f15a-2b05-24b7-24d9ef6f4f34@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2019/10/11 1:03, Bart Van Assche wrote:
> On 10/10/19 5:05 AM, zhengbin wrote:
>> kmsan report a warning in 5.1-rc4:
>>
>> BUG: KMSAN: uninit-value in sr_get_events drivers/scsi/sr.c:207 [inline]
>> BUG: KMSAN: uninit-value in sr_check_events+0x2cf/0x1090 drivers/scsi/sr.c:243
>> CPU: 1 PID: 13858 Comm: syz-executor.0 Tainted: G    B             5.1.0-rc4+ #8
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x173/0x1d0 lib/dump_stack.c:113
>>   kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:619
>>   __msan_warning+0x7a/0xf0 mm/kmsan/kmsan_instr.c:310
>>   sr_get_events drivers/scsi/sr.c:207 [inline]
>>   sr_check_events+0x2cf/0x1090 drivers/scsi/sr.c:243
>>
>> The reason is as follows:
>> sr_get_events
>>    struct scsi_sense_hdr sshdr;  -->uninit
>>    scsi_execute_req              -->If fail, will not set sshdr
>>    scsi_sense_valid(&sshdr)      -->access sshdr
>>
>> We can init sshdr in sr_get_events, but there have many callers of
>> scsi_execute, scsi_execute_req, we have to troubleshoot all callers,
>> the simpler way is init sshdr in __scsi_execute.
>>
>> BTW: we can't just init sshdr->response_code, sr_do_ioctl use
>> sshdr->sense_key(Need to troubleshoot all callers)
>>
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>> ---
>>   drivers/scsi/scsi_lib.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 5447738..037fb2a 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -255,6 +255,12 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>>       struct scsi_request *rq;
>>       int ret = DRIVER_ERROR << 24;
>>
>> +    /*
>> +     * need to initial sshdr to avoid uninit-value access
>> +     */
>> +    if (sshdr)
>> +        memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
>> +
>>       req = blk_get_request(sdev->request_queue,
>>               data_direction == DMA_TO_DEVICE ?
>>               REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
>
> From SAM-5: "Sense data shall be made available by the logical unit if a command terminates with CHECK CONDITION status or other conditions (e.g., the processing of a REQUEST SENSE command). The format, content, and conditions under which sense data shall be prepared by the logical unit are as defined in this standard, SPC-4, the applicable command standard, and the applicable SCSI transport protocol standard."

Even this, I suggest we should still init sshdr first(this is hard to understand)

>
> Apparently sr_check_events() submits a GET EVENT STATUS NOTIFICATION command and it even evaluates the sense data if that command succeeded. I'm not aware of other scsi_execute() callers that do this. So I'm not sure that modifying __scsi_execute() is the best approach. I'm wondering whether the sr driver should be fixed instead of modifying __scsi_execute().

I have troubleshoot callers, there are similar bug(scsi_report_opcode, cache_type_store, scsi_test_unit_ready, scsi_report_lun_scan, sd_spinup_disk, read_capacity_16,

read_capacity_10, sr_get_events, alua_rtpg, alua_stpg, send_trespass_cmd, hp_sw_tur, hp_sw_start_stop, send_mode_select, sd_sync_cache, sd_start_stop_device, sr_do_ioctl).

In __scsi_execute, if a command was executed, sshdr was set, so if failed, init sshdr should be ok too. Besides, scsi_sense_hdr is just 8 bytes, memset it to 0 will not affect performance

>
> Thanks,
>
> Bart.
>
> .
>

