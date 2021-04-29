Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8EDC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 06:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A20CC60720
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 06:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhD2GDA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 02:03:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:33318 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhD2GC7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 02:02:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE8ECAF16;
        Thu, 29 Apr 2021 06:02:12 +0000 (UTC)
Subject: Re: dm: dm_blk_ioctl(): implement failover for SG_IO on dm-multipath
To:     Mike Snitzer <snitzer@redhat.com>, mwilck@suse.com
Cc:     Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
References: <20210422202130.30906-1-mwilck@suse.com>
 <20210428195457.GA46518@lobo>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7124009b-1ea5-61eb-419f-956e659a0996@suse.de>
Date:   Thu, 29 Apr 2021 08:02:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210428195457.GA46518@lobo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/21 9:54 PM, Mike Snitzer wrote:
> On Thu, Apr 22 2021 at  4:21P -0400,
> mwilck@suse.com <mwilck@suse.com> wrote:
> 
>> From: Martin Wilck <mwilck@suse.com>
>>
>> In virtual deployments, SCSI passthrough over dm-multipath devices is a
>> common setup. The qemu "pr-helper" was specifically invented for it. I
>> believe that this is the most important real-world scenario for sending
>> SG_IO ioctls to device-mapper devices.
>>
>> In this configuration, guests send SCSI IO to the hypervisor in the form of
>> SG_IO ioctls issued by qemu. But on the device-mapper level, these SCSI
>> ioctls aren't treated like regular IO. Until commit 2361ae595352 ("dm mpath:
>> switch paths in dm_blk_ioctl() code path"), no path switching was done at
>> all. Worse though, if an SG_IO call fails because of a path error,
>> dm-multipath doesn't retry the IO on a another path; rather, the failure is
>> passed back to the guest, and paths are not marked as faulty.  This is in
>> stark contrast with regular block IO of guests on dm-multipath devices, and
>> certainly comes as a surprise to users who switch to SCSI passthrough in
>> qemu. In general, users of dm-multipath devices would probably expect failover
>> to work at least in a basic way.
>>
>> This patch fixes this by taking a special code path for SG_IO on request-
>> based device mapper targets. Rather then just choosing a single path,
>> sending the IO to it, and failing to the caller if the IO on the path
>> failed, it retries the same IO on another path for certain error codes,
>> using the same logic as blk_path_error() to determine if a retry would make
>> sense for the given error code. Moreover, it sends a message to the
>> multipath target to mark the path as failed.
>>
>> I am aware that this looks sort of hack-ish. I'm submitting it here as an
>> RFC, asking for guidance how to reach a clean implementation that would be
>> acceptable in mainline. I believe that it fixes an important problem.
>> Actually, it fixes the qemu SCSI-passthrough use case on dm-multipath,
>> which is non-functional without it.
>>
>> One problem remains open: if all paths in a multipath map are failed,
>> normal multipath IO may switch to queueing mode (depending on
>> configuration). This isn't possible for SG_IO, as SG_IO requests can't
>> easily be queued like regular block I/O. Thus in the "no path" case, the
>> guest will still see an error. If anybody can conceive of a solution for
>> that, I'd be interested.
>>
>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>> ---
>>   block/scsi_ioctl.c     |   5 +-
>>   drivers/md/dm.c        | 134 ++++++++++++++++++++++++++++++++++++++++-
>>   include/linux/blkdev.h |   2 +
>>   3 files changed, 137 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
>> index 6599bac0a78c..bcc60552f7b1 100644
>> --- a/block/scsi_ioctl.c
>> +++ b/block/scsi_ioctl.c
>> @@ -279,8 +279,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>>   	return ret;
>>   }
>>   
>> -static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>> -		struct sg_io_hdr *hdr, fmode_t mode)
>> +int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>> +	  struct sg_io_hdr *hdr, fmode_t mode)
>>   {
>>   	unsigned long start_time;
>>   	ssize_t ret = 0;
>> @@ -369,6 +369,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>>   	blk_put_request(rq);
>>   	return ret;
>>   }
>> +EXPORT_SYMBOL_GPL(sg_io);
>>   
>>   /**
>>    * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND ioctl
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 50b693d776d6..443ac5e5406c 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -29,6 +29,8 @@
>>   #include <linux/part_stat.h>
>>   #include <linux/blk-crypto.h>
>>   #include <linux/keyslot-manager.h>
>> +#include <scsi/sg.h>
>> +#include <scsi/scsi.h>
>>   
>>   #define DM_MSG_PREFIX "core"
>>   
> 
> Ngh... not loving this at all.  But here is a patch (that I didn't
> compile test) that should be folded in, still have to think about how
> this could be made cleaner in general though.
> 
> Also, dm_sg_io_ioctl should probably be in dm-rq.c (maybe even dm-mpath.c!?)
> 
I fully share your sentiments; this just feels so awkward, having to 
redo the logic in scsi_cmd_ioctl().

My original idea to that was to _use_ scsi_cmd_ioctl() directly from 
dm_blk_ioctl:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 50b693d776d6..007ff981f888 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -567,6 +567,9 @@ static int dm_blk_ioctl(struct block_device *bdev, 
fmode_t mode,
         struct mapped_device *md = bdev->bd_disk->private_data;
         int r, srcu_idx;

+       if (cmd == SG_IO)
+               return scsi_cmd_blk_ioctl(bdev, mode, cmd, arg);
+
         r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
         if (r < 0)
                 goto out;


But that crashes horribly as sg_io() expects the request pdu to be of 
type 'scsi_request', which it definitely isn't here.

We _could_ prepend struct dm_rq_target_io with a struct scsi_request, 
seeing that basically _all_ dm-rq installations are on SCSI devices:

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 13b4385f4d5a..aa7856621f83 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -16,6 +16,7 @@
   * One of these is allocated per request.
   */
  struct dm_rq_target_io {
+       struct scsi_request scsi_req;
         struct mapped_device *md;
         struct dm_target *ti;
         struct request *orig, *clone;

Then the above should work, but we would increase the size of 
dm_rq_target_io by quite a lot. Although, given the current size of it, 
question is whether it matters...

Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
