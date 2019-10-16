Return-Path: <SRS0=T0eU=YJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7525FA372A
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Oct 2019 18:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD34121A49
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Oct 2019 18:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394418AbfJPSvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:51:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731889AbfJPSvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Oct 2019 14:51:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9GIkqFf090006;
        Wed, 16 Oct 2019 14:51:12 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vp8bah28h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 14:51:12 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9GIlWOj091588;
        Wed, 16 Oct 2019 14:51:12 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vp8bah284-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 14:51:11 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9GIp3nr011605;
        Wed, 16 Oct 2019 18:51:11 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 2vk6f7ex0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 18:51:11 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9GIpAqZ52166996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:51:11 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAF4228059;
        Wed, 16 Oct 2019 18:51:10 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95E5128064;
        Wed, 16 Oct 2019 18:51:10 +0000 (GMT)
Received: from [9.60.75.213] (unknown [9.60.75.213])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 16 Oct 2019 18:51:10 +0000 (GMT)
Subject: Re: [PATCH v5 5/7] block: Delay default elevator initialization
From:   Eric Farman <farman@linux.ibm.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
 <20190905095135.26026-6-damien.lemoal@wdc.com>
 <9355c25f-61d7-b290-7d60-552ef4206e8c@linux.ibm.com>
Message-ID: <f5f3a25b-19f5-bf29-2f38-f40f59860aeb@linux.ibm.com>
Date:   Wed, 16 Oct 2019 14:51:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9355c25f-61d7-b290-7d60-552ef4206e8c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-16_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910160153
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 10/1/19 4:46 PM, Eric Farman wrote:
> 
> 
> On 9/5/19 5:51 AM, Damien Le Moal wrote:
>> When elevator_init_mq() is called from blk_mq_init_allocated_queue(),
>> the only information known about the device is the number of hardware
>> queues as the block device scan by the device driver is not completed
>> yet for most drivers. The device type and elevator required features
>> are not set yet, preventing to correctly select the default elevator
>> most suitable for the device.
>>
>> This currently affects all multi-queue zoned block devices which default
>> to the "none" elevator instead of the required "mq-deadline" elevator.
>> These drives currently include host-managed SMR disks connected to a
>> smartpqi HBA and null_blk block devices with zoned mode enabled.
>> Upcoming NVMe Zoned Namespace devices will also be affected.
>>
>> Fix this by adding the boolean elevator_init argument to
>> blk_mq_init_allocated_queue() to control the execution of
>> elevator_init_mq(). Two cases exist:
>> 1) elevator_init = false is used for calls to
>>    blk_mq_init_allocated_queue() within blk_mq_init_queue(). In this
>>    case, a call to elevator_init_mq() is added to __device_add_disk(),
>>    resulting in the delayed initialization of the queue elevator
>>    after the device driver finished probing the device information. This
>>    effectively allows elevator_init_mq() access to more information
>>    about the device.
>> 2) elevator_init = true preserves the current behavior of initializing
>>    the elevator directly from blk_mq_init_allocated_queue(). This case
>>    is used for the special request based DM devices where the device
>>    gendisk is created before the queue initialization and device
>>    information (e.g. queue limits) is already known when the queue
>>    initialization is executed.
>>
>> Additionally, to make sure that the elevator initialization is never
>> done while requests are in-flight (there should be none when the device
>> driver calls device_add_disk()), freeze and quiesce the device request
>> queue before calling blk_mq_init_sched() in elevator_init_mq().
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> 
> Coincidentally, I had been looking into a problem that is fixed in
> 5.4-rc1 by this patch.  Thanks for that!
> 
> The problem was a delay during boot of a KVM guest with virtio-scsi
> devices (or hotplug of such a device to a guest) in recent releases,
> especially when virtio-scsi is configured as a module.  The symptoms
> look like:
> 
> [    0.975315] virtio_blk virtio2: [vda] 1803060 4096-byte logical
> blocks (7.39 GB/6.88 GiB)
> [    0.977859] scsi host0: Virtio SCSI HBA
> [    0.980339] scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK
> 2.5+ PQ: 0 ANSI: 5
> [    0.981685]  vda:VOL1/  0XA906: vda1
> [    0.988253] alg: No test for crc32be (crc32be-vx)
> ...stall...
> [   24.544920] sd 0:0:0:0: Power-on or device reset occurred
> [   24.545176] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [   24.545292] sd 0:0:0:0: [sda] 385 512-byte logical blocks: (197
> kB/193 KiB)
> [   24.545368] sd 0:0:0:0: [sda] Write Protect is off
> [   24.545416] sd 0:0:0:0: [sda] Mode Sense: 63 00 00 08
> [   24.545456] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [   24.547033] sd 0:0:0:0: [sda] Attached SCSI disk
> 
> I debugged this down to the same behavior described/fixed back in 3.18
> by commit 17497acbdce9 ("blk-mq, percpu_ref: start q->mq_usage_counter
> in atomic mode"), and for the same reason.  The delay starts occurring
> as soon as q->q_usage_counter is converted to percpu for the one LUN tha
> twas found, while scsi_scan_channel() is still working on its loop of
> mostly non-existent devices.  Exactly when this problem started
> re-occuring is not certain to me, though I did see this problem with 5.2
> on linux-stable.

This problem started occurring reliably with kernel 4.16 because of
commit b5b6e8c8d3b4 ("scsi: virtio_scsi: fix IO hang caused by automatic
irq vector affinity") which forced blk-mq on for virtio-scsi devices.

I'm able to reproduce the behavior (fixed by this commit) on 4.15.0, as
well as 4.14.0 and 4.9.0, if I enable SCSI_MQ_DEFAULT in the kernel
config.  I cannot reproduce it with 4.4.0, but didn't chase further to
see why that was the case.

That force_blk_mq commit went into linux-stable, so SCSI_MQ_DEFAULT need
not be enabled on 4.14.y or 4.9.y stable branches to see the behavior
fixed by this commit.

> 
> When I run with a 5.3 kernel, the problem is easily reproducible.  So I
> bisected between 5.3 and 5.4-rc1, and got here.  Cherry-picking this
> patch on top of 5.3 cleans up the boot/hotplug process and removes any
> stall.  Any chance this could be cc'd to stable?  

Please?  Anything I can do to help with that effort?

Thanks,
Eric

> Any data someone wants
> to see behavioral changes?
> 
> Thanks,
> Eric
> 
>> ---
>>  block/blk-mq.c         | 12 +++++++++---
>>  block/elevator.c       |  7 +++++++
>>  block/genhd.c          |  9 +++++++++
>>  drivers/md/dm-rq.c     |  2 +-
>>  include/linux/blk-mq.h |  3 ++-
>>  5 files changed, 28 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index ee4caf0c0807..240416057f28 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -2689,7 +2689,11 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
>>  	if (!uninit_q)
>>  		return ERR_PTR(-ENOMEM);
>>  
>> -	q = blk_mq_init_allocated_queue(set, uninit_q);
>> +	/*
>> +	 * Initialize the queue without an elevator. device_add_disk() will do
>> +	 * the initialization.
>> +	 */
>> +	q = blk_mq_init_allocated_queue(set, uninit_q, false);
>>  	if (IS_ERR(q))
>>  		blk_cleanup_queue(uninit_q);
>>  
>> @@ -2840,7 +2844,8 @@ static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
>>  }
>>  
>>  struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>> -						  struct request_queue *q)
>> +						  struct request_queue *q,
>> +						  bool elevator_init)
>>  {
>>  	/* mark the queue as mq asap */
>>  	q->mq_ops = set->ops;
>> @@ -2902,7 +2907,8 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>>  	blk_mq_add_queue_tag_set(set, q);
>>  	blk_mq_map_swqueue(q);
>>  
>> -	elevator_init_mq(q);
>> +	if (elevator_init)
>> +		elevator_init_mq(q);
>>  
>>  	return q;
>>  
>> diff --git a/block/elevator.c b/block/elevator.c
>> index 520d6b224b74..096a670d22d7 100644
>> --- a/block/elevator.c
>> +++ b/block/elevator.c
>> @@ -712,7 +712,14 @@ void elevator_init_mq(struct request_queue *q)
>>  	if (!e)
>>  		return;
>>  
>> +	blk_mq_freeze_queue(q);
>> +	blk_mq_quiesce_queue(q);
>> +
>>  	err = blk_mq_init_sched(q, e);
>> +
>> +	blk_mq_unquiesce_queue(q);
>> +	blk_mq_unfreeze_queue(q);
>> +
>>  	if (err) {
>>  		pr_warn("\"%s\" elevator initialization failed, "
>>  			"falling back to \"none\"\n", e->elevator_name);
>> diff --git a/block/genhd.c b/block/genhd.c
>> index 54f1f0d381f4..26b31fcae217 100644
>> --- a/block/genhd.c
>> +++ b/block/genhd.c
>> @@ -695,6 +695,15 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
>>  	dev_t devt;
>>  	int retval;
>>  
>> +	/*
>> +	 * The disk queue should now be all set with enough information about
>> +	 * the device for the elevator code to pick an adequate default
>> +	 * elevator if one is needed, that is, for devices requesting queue
>> +	 * registration.
>> +	 */
>> +	if (register_queue)
>> +		elevator_init_mq(disk->queue);
>> +
>>  	/* minors == 0 indicates to use ext devt from part0 and should
>>  	 * be accompanied with EXT_DEVT flag.  Make sure all
>>  	 * parameters make sense.
>> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
>> index 21d5c1784d0c..3f8577e2c13b 100644
>> --- a/drivers/md/dm-rq.c
>> +++ b/drivers/md/dm-rq.c
>> @@ -563,7 +563,7 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
>>  	if (err)
>>  		goto out_kfree_tag_set;
>>  
>> -	q = blk_mq_init_allocated_queue(md->tag_set, md->queue);
>> +	q = blk_mq_init_allocated_queue(md->tag_set, md->queue, true);
>>  	if (IS_ERR(q)) {
>>  		err = PTR_ERR(q);
>>  		goto out_tag_set;
>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>> index 62a3bb715899..0bf056de5cc3 100644
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -248,7 +248,8 @@ enum {
>>  
>>  struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
>>  struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>> -						  struct request_queue *q);
>> +						  struct request_queue *q,
>> +						  bool elevator_init);
>>  struct request_queue *blk_mq_init_sq_queue(struct blk_mq_tag_set *set,
>>  						const struct blk_mq_ops *ops,
>>  						unsigned int queue_depth,
>>
