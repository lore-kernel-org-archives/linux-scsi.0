From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,v2 04/10] scsi: allocate scsi_cmnd-s from the device's local numa node
Date: Mon, 05 Nov 2012 09:09:43 -0500
Message-ID: <x49bofccfa0.fsf@segfault.boston.devel.redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
	<1351892763-21325-5-git-send-email-jmoyer@redhat.com>
	<50954818.8050908@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50954818.8050908@acm.org> (Bart Van Assche's message of "Sat, 03
	Nov 2012 17:36:40 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 11/02/12 22:45, Jeff Moyer wrote:
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 2936b44..4db6973 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -173,16 +173,20 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
>>    * NULL on failure
>>    */
>>   static struct scsi_cmnd *
>> -scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
>> +scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask,
>> +			int node)
>>   {
>>   	struct scsi_cmnd *cmd;
>>
>> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
>> +	cmd = kmem_cache_alloc_node(pool->cmd_slab,
>> +				    gfp_mask | pool->gfp_mask | __GFP_ZERO,
>> +				    node);
>>   	if (!cmd)
>>   		return NULL;
>>
>> -	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
>> -					     gfp_mask | pool->gfp_mask);
>> +	cmd->sense_buffer = kmem_cache_alloc_node(pool->sense_slab,
>> +					gfp_mask | pool->gfp_mask | __GFP_ZERO,
>> +					node);
>
> It's not clear to me why __GFP_ZERO is added to the allocation flags ?

Hmm, seems I thought this was another case of kmem_cache_zalloc.  I'll
fix it up.

Cheers,
Jeff
