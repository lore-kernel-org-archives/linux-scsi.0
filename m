From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] use dynamically allocated sense buffer
Date: Tue, 15 Jan 2008 17:44:14 +0200
Message-ID: <478CD4CE.1000703@panasas.com>
References: <20080115182342Q.fujita.tomonori@lab.ntt.co.jp>	<478CBBA8.4050202@panasas.com> <20080116000836Y.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:50672 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYAOPog (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2008 10:44:36 -0500
In-Reply-To: <20080116000836Y.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, Jan 15 2008 at 17:08 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
> On Tue, 15 Jan 2008 15:56:56 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On Tue, Jan 15 2008 at 11:23 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> This is the second version of
>>>
>>> http://marc.info/?l=linux-scsi&m=119933628210006&w=2
>>>
>>> I gave up once, but I found that the performance loss is negligible
>>> (within 1%) by using kmem_cache_alloc instead of mempool.
>>>
>>> I use scsi_debug with fake_rw=1 and disktest (DIO reads with 8
>>> threads) again:
>>>
>>> scsi-misc (slub)         | 486.9 MB/s  IOPS 124652.9/s
>>> dynamic sense buf (slub) | 483.2 MB/s  IOPS 123704.1/s
>>>
>>> scsi-misc (slab)         | 467.0 MB/s  IOPS 119544.3/s
>>> dynamic sense buf (slab) | 468.7 MB/s  IOPS 119986.0/s
>>>
>>> The results are the averages of three runs with a server using two
>>> dual-core 1.60 GHz Xeon processors with DDR2 memory.
>>>
>>>
>>> I doubt think that someone will complain about the performance
>>> regression due to this patch. In addition, unlike scsi_debug, the real
>>> LLDs allocate the own data structure per scsi_cmnd so the performance
>>> differences would be smaller (and with the real hard disk overheads).
>>>
>>> Here's the full results:
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/tomo/sense/results.txt
>>>
>> TOMO Hi.
>> This is grate news. Thanks I like what you did here. and it's good
>> to know. Why should a mempool be so slow ;)
>>
>> I have a small concern of a leak, please see below, but otherwise
>> this is grate.
>>> =
>>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>> Subject: [PATCH] use dynamically allocated sense buffer
>>>
>>> This removes static array sense_buffer in scsi_cmnd and uses
>>> dynamically allocated sense_buffer (with GFP_DMA).
>>>
>>> The reason for doing this is that some architectures need cacheline
>>> aligned buffer for DMA:
>>>
>>> http://lkml.org/lkml/2007/11/19/2
>>>
>>> The problems are that scsi_eh_prep_cmnd puts scsi_cmnd::sense_buffer
>>> to sglist and some LLDs directly DMA to scsi_cmnd::sense_buffer. It's
>>> necessary to DMA to scsi_cmnd::sense_buffer safely. This patch solves
>>> these issues.
>>>
>>> __scsi_get_command allocates sense_buffer via kmem_cache_alloc and
>>> attaches it to a scsi_cmnd so everything just work as before.
>>>
>>> A scsi_host reserves one sense buffer for the backup command
>>> (shost->backup_sense_buffer).
>>>
>>>
>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>> ---
>>>  drivers/scsi/hosts.c     |   10 ++++++-
>>>  drivers/scsi/scsi.c      |   67 ++++++++++++++++++++++++++++++++++++++++++++-
>>>  drivers/scsi/scsi_priv.h |    2 +
>>>  include/scsi/scsi_cmnd.h |    2 +-
>>>  include/scsi/scsi_host.h |    3 ++
>>>  5 files changed, 80 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index 9a10b43..35c5f0e 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -205,10 +205,14 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
>>>  	if (!shost->shost_gendev.parent)
>>>  		shost->shost_gendev.parent = dev ? dev : &platform_bus;
>>>  
>>> -	error = device_add(&shost->shost_gendev);
>>> +	error = scsi_setup_command_sense_buffer(shost);
>>>  	if (error)
>>>  		goto out;
>>>  
>>> +	error = device_add(&shost->shost_gendev);
>>> +	if (error)
>>> +		goto destroy_pool;
>>> +
>>>  	scsi_host_set_state(shost, SHOST_RUNNING);
>>>  	get_device(shost->shost_gendev.parent);
>>>  
>>> @@ -248,6 +252,8 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
>>>  	class_device_del(&shost->shost_classdev);
>>>   out_del_gendev:
>>>  	device_del(&shost->shost_gendev);
>>> + destroy_pool:
>>> +	scsi_destroy_command_sense_buffer(shost);
>>>   out:
>>>  	return error;
>>>  }
>>> @@ -267,6 +273,8 @@ static void scsi_host_dev_release(struct device *dev)
>>>  		scsi_free_queue(shost->uspace_req_q);
>>>  	}
>>>  
>>> +	scsi_destroy_command_sense_buffer(shost);
>>> +
>>>  	scsi_destroy_command_freelist(shost);
>>>  	if (shost->bqt)
>>>  		blk_free_tags(shost->bqt);
>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>> index 54ff611..d153da3 100644
>>> --- a/drivers/scsi/scsi.c
>>> +++ b/drivers/scsi/scsi.c
>>> @@ -161,6 +161,9 @@ static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
>>>  
>>>  static DEFINE_MUTEX(host_cmd_pool_mutex);
>>>  
>>> +static struct kmem_cache *sense_buffer_slab;
>>> +static int sense_buffer_slab_users;
>>> +
>>>  /**
>>>   * __scsi_get_command - Allocate a struct scsi_cmnd
>>>   * @shost: host to transmit command
>>> @@ -186,6 +189,22 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>>>  			list_del_init(&cmd->list);
>>>  		}
>>>  		spin_unlock_irqrestore(&shost->free_list_lock, flags);
>>> +
>>> +		if (cmd) {
>>> +			memset(cmd, 0, sizeof(*cmd));
>>> +			cmd->sense_buffer = shost->backup_sense_buffer;
>> [1]
>> If command was put on free_list in __put_command(), then this here will leak the 
>> sense_buffer that was allocated for that command. See explanations below.
>>
>>> +		}
>>> +	} else {
>>> +		unsigned char *buf;
>>> +
>>> +		buf = kmem_cache_alloc(sense_buffer_slab, __GFP_DMA|gfp_mask);
>>> +		if (likely(buf)) {
>>> +			memset(cmd, 0, sizeof(*cmd));
>>> +			cmd->sense_buffer = buf;
>>> +		} else {
>>> +			kmem_cache_free(shost->cmd_pool->slab, cmd);
>>> +			cmd = NULL;
>>> +		}
>>>  	}
>>>  
>>>  	return cmd;
>>> @@ -212,7 +231,6 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
>>>  	if (likely(cmd != NULL)) {
>>>  		unsigned long flags;
>>>  
>>> -		memset(cmd, 0, sizeof(*cmd));
>>>  		cmd->device = dev;
>>>  		init_timer(&cmd->eh_timeout);
>>>  		INIT_LIST_HEAD(&cmd->list);
>>> @@ -246,8 +264,10 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
>>>  	}
>>>  	spin_unlock_irqrestore(&shost->free_list_lock, flags);
>>>  
>>> -	if (likely(cmd != NULL))
>>> +	if (likely(cmd != NULL)) {
>>> +		kmem_cache_free(sense_buffer_slab, cmd->sense_buffer);
>>>  		kmem_cache_free(shost->cmd_pool->slab, cmd);
>>> +	}
>>>  
>>>  	put_device(dev);
>>>  }
>>> @@ -351,6 +371,49 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
>>>  	mutex_unlock(&host_cmd_pool_mutex);
>>>  }
>>>  
>>> +int scsi_setup_command_sense_buffer(struct Scsi_Host *shost)
>>> +{
>>> +	unsigned char *sense_buffer;
>>> +
>>> +	mutex_lock(&host_cmd_pool_mutex);
>>> +	if (!sense_buffer_slab_users) {
>>> +		sense_buffer_slab = kmem_cache_create("scsi_sense_buffer",
>>> +						      SCSI_SENSE_BUFFERSIZE,
>>> +						      0, SLAB_CACHE_DMA, NULL);
>>> +		if (!sense_buffer_slab) {
>>> +			mutex_unlock(&host_cmd_pool_mutex);
>>> +			return -ENOMEM;
>>> +		}
>>> +	}
>>> +	sense_buffer_slab_users++;
>>> +	mutex_unlock(&host_cmd_pool_mutex);
>>> +
>>> +	sense_buffer = kmem_cache_alloc(sense_buffer_slab,
>>> +					GFP_KERNEL | __GFP_DMA);
>>> +	if (!sense_buffer)
>>> +		goto fail;
>>> +
>>> +	shost->backup_sense_buffer = sense_buffer;
>>> +
>>> +	return 0;
>>> +fail:
>>> +	mutex_lock(&host_cmd_pool_mutex);
>>> +	if (!--sense_buffer_slab_users)
>>> +			kmem_cache_destroy(sense_buffer_slab);
>>> +	mutex_unlock(&host_cmd_pool_mutex);
>>> +	return -ENOMEM;
>>> +}
>>> +
>>> +void scsi_destroy_command_sense_buffer(struct Scsi_Host *shost)
>>> +{
>>> +	kmem_cache_free(sense_buffer_slab, shost->backup_sense_buffer);
>>> +
>>> +	mutex_lock(&host_cmd_pool_mutex);
>>> +	if (!--sense_buffer_slab_users)
>>> +		kmem_cache_destroy(sense_buffer_slab);
>>> +	mutex_unlock(&host_cmd_pool_mutex);
>>> +}
>>> +
>>>  #ifdef CONFIG_SCSI_LOGGING
>>>  void scsi_log_send(struct scsi_cmnd *cmd)
>>>  {
>>> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
>>> index 3f34e93..55c6f71 100644
>>> --- a/drivers/scsi/scsi_priv.h
>>> +++ b/drivers/scsi/scsi_priv.h
>>> @@ -27,6 +27,8 @@ extern void scsi_exit_hosts(void);
>>>  extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
>>>  extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
>>>  extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
>>> +extern int scsi_setup_command_sense_buffer(struct Scsi_Host *shost);
>>> +extern void scsi_destroy_command_sense_buffer(struct Scsi_Host *shost);
>>>  extern void __scsi_done(struct scsi_cmnd *cmd);
>>>  #ifdef CONFIG_SCSI_LOGGING
>>>  void scsi_log_send(struct scsi_cmnd *cmd);
>>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>>> index 3f47e52..abd7479 100644
>>> --- a/include/scsi/scsi_cmnd.h
>>> +++ b/include/scsi/scsi_cmnd.h
>>> @@ -88,7 +88,7 @@ struct scsi_cmnd {
>>>  				   	   working on */
>>>  
>>>  #define SCSI_SENSE_BUFFERSIZE 	96
>>> -	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
>>> +	unsigned char *sense_buffer;
>>>  				/* obtained by REQUEST SENSE when
>>>  				 * CHECK CONDITION is received on original
>>>  				 * command (auto-sense) */
>>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>>> index 0fd4746..65d2bcf 100644
>>> --- a/include/scsi/scsi_host.h
>>> +++ b/include/scsi/scsi_host.h
>>> @@ -520,6 +520,9 @@ struct Scsi_Host {
>>>  	struct list_head	free_list; /* backup store of cmd structs */
>>>  	struct list_head	starved_list;
>>>  
>>> +	/* sense buffer for the backup command */
>>> +	unsigned char *backup_sense_buffer;
>>> +
>>>  	spinlock_t		default_lock;
>>>  	spinlock_t		*host_lock;
>>>  
>> commands can be put on the free list in 2 places:
>> [1]
>> void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
>> 			struct device *dev)
>> {
>> 	unsigned long flags;
>>
>> 	/* changing locks here, don't need to restore the irq state */
>> 	spin_lock_irqsave(&shost->free_list_lock, flags);
>> 	if (unlikely(list_empty(&shost->free_list))) {
>> 		list_add(&cmd->list, &shost->free_list);
>> 		cmd = NULL;
>> 	}
>>  ...
>> and 
>> [2]
>> int scsi_setup_command_freelist(struct Scsi_Host *shost)
>> {
>>  ...
>> 	if (!cmd)
>> 		goto fail2;
>> 	list_add(&cmd->list, &shost->free_list);
>> 	return 0;
>>  ...
>>
>> case [1] cmnd had a sense_buffer with it, case [2] did not. The easiest fix
>> would be to remove just the sense buffer from [1] and have an empty cmnd
>> on the free_list in all cases.
> 
> I'm not sure about what you mean.
> 
> scsi_setup_command_freelist is called only by
> scsi_host_alloc. It puts only one backup command to
> shost->free_list. The patch allocates one sense_buffer to the backup
> command (it's hooked on shost->backup_sense_buffer).
> 
> __scsi_get_command always uses shost->backup_sense_buffer for the
> backup command. It allocates sense_buffer from sense_buffer_slab for
> commands allocated from shost->cmd_pool->slab.
> 
> 
> If __scsi_put_command puts a command to shost->free_list, it doesn't
> free scmd->sense_buffer since it's the sense_buffer for the backup
> sense_buffer. If __scsi_put_command puts a command to
> shost->cmd_pool->slab (if shost->free_list isn't empty), it alos puts
> its sense_buffer to sense_buffer_slab.

Yes, but these are not necessarily the same commands. Think of this,
The run queues have commands in them, a request comes that demands
a cmnd, out-of-memory condition causes the spare from free_list cmnd to
be issued, and is put at tail of some run queue. Now comes the first
done cmnd, it is immediately put to free_list, but it's sense_buffer
was from sense_buffer_slab.

I think the solution is simple just immediately allocate the sense_buffer
in scsi_setup_command_freelist() and put it on that first free_list command.
Then make sure that also the sense_buffer is freed in 
scsi_destroy_command_freelist().

This way sense_buffer is always allocated/freed together with cmnd and
you don't need the shost->backup_sense_buffer pointer.

> 
> 
>> But I would suggest to just put the extra allocated sense_buffer on the
>> cmnd in case [2] and always have cmnd+sense_buffer, this way you can get
>> rid of the pointer for the backup_sense_buffer in host struct. (and have
>> the code localized to scsi.c only)
>>
>> Also, is there a kmem_cache_zalloc()? I would use it for the command allocation
>> just to make sure when we do scsi_destroy_command_freelist() in the case that
>> a sense_buffer allocation failed and the host is unloaded.
>>
>> Boaz
>>
Boaz
