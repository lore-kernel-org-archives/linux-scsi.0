From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 41/42] block: do not use REQ_FLUSH for tracking flush
 support
Date: Fri, 15 Apr 2016 13:58:17 -0500
Message-ID: <571139C9.8060405@redhat.com>
References: <1460716802-2294-1-git-send-email-mchristi@redhat.com>
 <1460716802-2294-42-git-send-email-mchristi@redhat.com>
 <5710C77F.2000405@pfupf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbcDOS62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 14:58:28 -0400
In-Reply-To: <5710C77F.2000405@pfupf.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <kernel@pfupf.net>, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 04/15/2016 05:50 AM, Juergen Gross wrote:
> On 15/04/16 12:40, mchristi@redhat.com wrote:
>> From: Mike Christie <mchristi@redhat.com>
>>
>> The last patch added a REQ_OP_FLUSH for request_fn drivers
>> and the next patch renames REQ_FLUSH to REQ_PREFLUSH which
>> will be used by file systems and make_request_fn drivers so
>> they can send a write/flush combo.
>>
>> This patch drops xen's use of REQ_FLUSH to track if it supports
>> REQ_OP_FLUSH requests, so REQ_FLUSH can be deleted.
>>
>> v6:
>> - Dropped parts of patch handled by Jens's QUEUE_FLAG_WC/FUA
>> patches and modified patch to check feature_flush/fua bits.
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>> Reviewed-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/block/xen-blkfront.c | 47 ++++++++++++++++++++++----------------------
>>  1 file changed, 24 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index f01691a..d6429e7 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
> 
> ...
> 
>> @@ -985,24 +981,22 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
>>  	return 0;
>>  }
>>  
>> -static const char *flush_info(unsigned int feature_flush)
>> +static const char *flush_info(struct blkfront_info *info)
>>  {
>> -	switch (feature_flush & ((REQ_FLUSH | REQ_FUA))) {
>> -	case REQ_FLUSH|REQ_FUA:
>> +	if (info->feature_flush && info->feature_fua)
>>  		return "barrier: enabled;";
>> -	case REQ_FLUSH:
>> +	else if (info->feature_fua)
> 
> Shouldn't this test feature_flush?
> 
>>  		return "flush diskcache: enabled;";
>> -	default:
>> +	else
>>  		return "barrier or flush: disabled;";
>> -	}
>>  }
>>  
>>  static void xlvbd_flush(struct blkfront_info *info)
>>  {
>> -	blk_queue_write_cache(info->rq, info->feature_flush & REQ_FLUSH,
>> -				info->feature_flush & REQ_FUA);
>> +	blk_queue_write_cache(info->rq, info->feature_flush ? true : false,
>> +			      info->feature_flush ? true : false);
> 
> And here the second test should be feature_fua?
> 

You are right. Will fix up and resend.

