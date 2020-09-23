Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17330C4727D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 06:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAC0D20738
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 06:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgIWGur (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:50:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:53276 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIWGur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 02:50:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 65EB7AB0E;
        Wed, 23 Sep 2020 06:51:22 +0000 (UTC)
Subject: Re: [PATCH V3 for 5.11 12/12] scsi: replace sdev->device_busy with
 sbitmap
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20200923013339.1621784-1-ming.lei@redhat.com>
 <20200923013339.1621784-13-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <268a0b78-744a-a144-080f-d69e8144719b@suse.de>
Date:   Wed, 23 Sep 2020 08:50:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923013339.1621784-13-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/20 3:33 AM, Ming Lei wrote:
> scsi requires one global atomic variable to track queue depth for each LUN/
> request queue, meantime blk-mq tracks queue depth for each hctx. This SCSI's
> requirement can't be implemented in blk-mq easily, cause it is a bigger &
> harder problem to spread the device or request queue's depth among all hw
> queues.
> 
> The current approach by using atomic variable can't scale well when there
> is lots of CPU cores and the disk is very fast and IO are submitted to this
> device concurrently. It has been observed that IOPS is affected a lot by
> tracking queue depth via sdev->device_busy in IO path.
> 
> So replace the atomic variable sdev->device_busy with sbitmap for
> tracking scsi device queue depth.
> 
> It is observed that IOPS is improved ~30% by this patchset in the
> following test:
> 
> 1) test machine(32 logical CPU cores)
> 	Thread(s) per core:  2
> 	Core(s) per socket:  8
> 	Socket(s):           2
> 	NUMA node(s):        2
> 	Model name:          Intel(R) Xeon(R) Silver 4110 CPU @ 2.10GHz
> 
> 2) setup scsi_debug:
> modprobe scsi_debug virtual_gb=128 max_luns=1 submit_queues=32 delay=0 max_queue=256
> 
> 3) fio script:
> fio --rw=randread --size=128G --direct=1 --ioengine=libaio --iodepth=2048 \
> 	--numjobs=32 --bs=4k --group_reporting=1 --group_reporting=1 --runtime=60 \
> 	--loops=10000 --name=job1 --filename=/dev/sdN
> 
> [1] https://lore.kernel.org/linux-block/20200119071432.18558-6-ming.lei@redhat.com/
> 
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/scsi.c        |  2 ++
>   drivers/scsi/scsi_lib.c    | 33 +++++++++++++++------------------
>   drivers/scsi/scsi_priv.h   |  1 +
>   drivers/scsi/scsi_scan.c   | 22 ++++++++++++++++++++--
>   drivers/scsi/scsi_sysfs.c  |  2 ++
>   include/scsi/scsi_device.h |  5 +++--
>   6 files changed, 43 insertions(+), 22 deletions(-)
> 
Ah. Now it makes sense why 'no budget' has been set to -1.
Ok.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
