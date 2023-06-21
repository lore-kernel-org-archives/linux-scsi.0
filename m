Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F81EB64DC
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jun 2023 07:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjFUHbH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 03:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjFUHas (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 03:30:48 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB82173F;
        Wed, 21 Jun 2023 00:30:46 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QmFXf6ssHz4f3pP0;
        Wed, 21 Jun 2023 15:30:42 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHvbAhp5JkeBTBMA--.29521S3;
        Wed, 21 Jun 2023 15:30:42 +0800 (CST)
Subject: Re: block test failure with scsi_debug
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <1760da91-876d-fc9c-ab51-999a6f66ad50@nvidia.com>
 <zgp4nnbryukbgnv4cdtdnn3hwqvgggeknljmobk4moobiffseu@hiytoqbf7pol>
 <fqix34ny4enu26rqgbohuknosejgn5uikloeam7rbzjyf5zvux@f2uuriyeddhb>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <35cece9a-0790-c7bf-ffdf-2ba14fb5479d@huaweicloud.com>
Date:   Wed, 21 Jun 2023 15:30:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fqix34ny4enu26rqgbohuknosejgn5uikloeam7rbzjyf5zvux@f2uuriyeddhb>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHvbAhp5JkeBTBMA--.29521S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFyfXF4xGrW3tw18Jr4Dtwb_yoW8urWDpa
        yxJa98KrWDW3yUG3W0vw4UXas3t3yS934rXFWFkw15uF98Ar9rWrykJFyUX3Z0vrZxGayj
        yFsrKFZ5KF1kXw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

ÔÚ 2023/06/21 15:02, Shinichiro Kawasaki Ð´µÀ:
> CC+: Yu Kuai, linux-scsi,
> 
> On Jun 21, 2023 / 02:46, Shinichiro Kawasaki wrote:
>> On Jun 20, 2023 / 06:11, Chaitanya Kulkarni wrote:
>>> Hi,
>>>
>>> I found few failures, are you also getting the same ?
>>>
>>> linux-block/for-next observed block test failure :-
>>
>> Yes, I've jtried the kernel on linux-block/for-next at git hash 334bdb61bbea,
>> and see the same failure symptoms. It looks that the first test case block/001
>> left scsi_debug in weird status, and following test cases were affected.
>>
>> I tried simple commands below and found that scsi_debug module unload fails.
>>
>>      # modprobe scsi_debug
>>      # modprobe -r scsi_debug
>>      modprobe: FATAL: Module scsi_debug is in use.

Thanks for the test, this is because /dev/sg will grab reference for
scsi_device, and this will block remove module.

I tested following patch can work, I'll send a fix.

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2433eeef042a..dcb73787c29d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1497,7 +1497,7 @@ sg_add_device(struct device *cl_dev)
         int error;
         unsigned long iflags;

-       error = scsi_device_get(scsidp);
+       error = blk_get_queue(scsidp->request_queue);
         if (error)
                 return error;

@@ -1558,7 +1558,7 @@ sg_add_device(struct device *cl_dev)
  out:
         if (cdev)
                 cdev_del(cdev);
-       scsi_device_put(scsidp);
+       blk_put_queue(scsidp->request_queue);
         return error;
  }

@@ -1575,7 +1575,7 @@ sg_device_destroy(struct kref *kref)
          */

         blk_trace_remove(q);
-       scsi_device_put(sdp->device);
+       blk_put_queue(q);

         write_lock_irqsave(&sg_index_lock, flags);
         idr_remove(&sg_index_idr, sdp->index);

>>
>> I'll try to bisect and identify which commit triggers the unload failure.
> 
> The commit db59133e9279 ("scsi: sg: fix blktrace debugfs entries leakage") [1]
> triggers the scsi_debug unload failure on my test system.
> 
> Yu, could you check the failure symptom?
> 
> [1] https://lore.kernel.org/linux-block/20230610022003.2557284-3-yukuai1@huaweicloud.com/
> .
> 

