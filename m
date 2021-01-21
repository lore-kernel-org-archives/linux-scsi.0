Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2718CC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 12:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF99F2395B
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 12:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbhAUMCW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 07:02:22 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:46899 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730722AbhAUMCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 07:02:14 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DFB2420645D57;
        Thu, 21 Jan 2021 13:01:28 +0100 (CET)
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     John Garry <john.garry@huawei.com>, mwilck@suse.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
Date:   Thu, 21 Jan 2021 13:01:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20.01.21 21:26, John Garry wrote:
> On 20/01/2021 18:45, mwilck@suse.com wrote:
>> From: Martin Wilck <mwilck@suse.com>
>>
>> Donald: please give this patch a try.
>>
>> Commit 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
>> contained this hunk:
>>
>> -       busy = atomic_inc_return(&shost->host_busy) - 1;
>>          if (atomic_read(&shost->host_blocked) > 0) {
>> -               if (busy)
>> +               if (scsi_host_busy(shost) > 0)
>>                          goto starved;
>>
>> The previous code would increase the busy count before checking host_blocked.
>> With 6eb045e092ef, the busy count would be increased (by setting the
>> SCMD_STATE_INFLIGHT bit) after the if clause for host_blocked above.
>>
>> Users have reported a regression with the smartpqi driver [1] which has been
>> shown to be caused by this commit [2].
>>
> 
> Please note these, where potential issue was discussed before:
> https://lore.kernel.org/linux-scsi/8a3c8d37-8d15-4060-f461-8d400b19cb34@suse.de/
> https://lore.kernel.org/linux-scsi/20200714104437.GB602708@T590/
> 
>> It seems that by moving the increase of the busy counter further down, it could
>> happen that the can_queue limit of the controller could be exceeded if several
>> CPUs were executing this code in parallel on different queues.
>>
>> This patch attempts to fix it by moving setting the SCMD_STATE_INFLIGHT before
>> the host_blocked test again. It also inserts barriers to make sure
>> scsi_host_busy() on once CPU will notice the increase of the count from another.
>>
>> [1]: https://marc.info/?l=linux-scsi&m=160271263114829&w=2
>> [2]: https://marc.info/?l=linux-scsi&m=161116163722099&w=2
>>
>> Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
> 
> For failing test, it would be good to know:
> - host .can_queue
> - host .nr_hw_queues
> - number of LUNs in test and their queue dept>> All can be got from lsscsi, apart from nr_hw_queues, which can be got from scsi_host sysfs for kernel >= 5.10

The last test was on 6eb045e092ef + Martins experimental patch, which technically is 5.4.0-rc1

I'm not 100% sure about which data you need and where to find  nr_hw_queues exposed. Please ask, if you need more data.

+ lsscsi
[0:0:0:0]    disk    ATA      ST500NM0011      PA09  /dev/sda
[0:0:32:0]   enclosu DP       BP13G+           2.23  -
[12:0:0:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdb
[12:0:1:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdc
[12:0:2:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdd
[12:0:3:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sde
[12:0:4:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdf
[12:0:5:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdg
[12:0:6:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdh
[12:0:7:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdi
[12:0:8:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdj
[12:0:9:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdk
[12:0:10:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdl
[12:0:11:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdm
[12:0:12:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdn
[12:0:13:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdo
[12:0:14:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdp
[12:0:15:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdq
[12:0:16:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdr
[12:0:17:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sds
[12:0:18:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdt
[12:0:19:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdu
[12:0:20:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdv
[12:0:21:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdw
[12:0:22:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdx
[12:0:23:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdy
[12:0:24:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdz
[12:0:25:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdaa
[12:0:26:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdab
[12:0:27:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdac
[12:0:28:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdad
[12:0:29:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdae
[12:0:30:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdaf
[12:0:31:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdag
[12:0:32:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
[12:0:33:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
[12:0:34:0]  enclosu Adaptec  Smart Adapter    3.21  -
[12:2:0:0]   storage Adaptec  1100-8e          3.21  -
+ for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
+ lsscsi -L 12:2:0:0
[12:2:0:0]   storage Adaptec  1100-8e          3.21  -
   device_blocked=0
   iocounterbits=32
   iodone_cnt=0x1e
   ioerr_cnt=0x0
   iorequest_cnt=0x1e
   queue_depth=1013
   queue_type=simple
   scsi_level=6
   state=running
   timeout=30
   type=12
+ for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
+ lsscsi -L 12:0:34:0
[12:0:34:0]  enclosu Adaptec  Smart Adapter    3.21  -
   device_blocked=0
   iocounterbits=32
   iodone_cnt=0x12
   ioerr_cnt=0x0
   iorequest_cnt=0x12
   queue_depth=1
   queue_type=none
   scsi_level=6
   state=running
   timeout=30
   type=13
+ for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
+ lsscsi -L 12:0:33:0
[12:0:33:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
   device_blocked=0
   iocounterbits=32
   iodone_cnt=0x12
   ioerr_cnt=0x0
   iorequest_cnt=0x12
   queue_depth=1
   queue_type=simple
   scsi_level=6
   state=running
   timeout=30
   type=13
+ for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
+ lsscsi -L 12:0:31:0
[12:0:31:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdag
   device_blocked=0
   iocounterbits=32
   iodone_cnt=0x19b94
   ioerr_cnt=0x0
   iorequest_cnt=0x19bba
   queue_depth=64
   queue_type=simple
   scsi_level=8
   state=running
   timeout=30
   type=0
+ cat /sys/bus/scsi/devices/host12/scsi_host/host12/can_queue
1013

Best
   Donald

> 
> Cheers,
> John
> 
>>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Don Brace <Don.Brace@microchip.com>
>> Cc: Kevin Barnett <Kevin.Barnett@microchip.com>
>> Cc: Donald Buczek <buczek@molgen.mpg.de>
>> Cc: John Garry <john.garry@huawei.com>
>> Cc: Paul Menzel <pmenzel@molgen.mpg.de>
>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>> ---
>>   drivers/scsi/hosts.c    | 2 ++
>>   drivers/scsi/scsi_lib.c | 8 +++++---
>>   2 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index 2f162603876f..1c452a1c18fd 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -564,6 +564,8 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data,
>>       int *count = data;
>>       struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>> +    /* This pairs with set_bit() in scsi_host_queue_ready() */
>> +    smp_mb__before_atomic();
>>       if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
>>           (*count)++;
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index b3f14f05340a..0a9a36c349ee 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1353,8 +1353,12 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>>       if (scsi_host_in_recovery(shost))
>>           return 0;
>> +    set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>> +    /* This pairs with test_bit() in scsi_host_check_in_flight() */
>> +    smp_mb__after_atomic();
>> +
>>       if (atomic_read(&shost->host_blocked) > 0) {
>> -        if (scsi_host_busy(shost) > 0)
>> +        if (scsi_host_busy(shost) > 1)
>>               goto starved;
>>           /*
>> @@ -1379,8 +1383,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>>           spin_unlock_irq(shost->host_lock);
>>       }
>> -    __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>> -
>>       return 1;
>>   starved:
>>
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
