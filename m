From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3] use dynamically allocated sense buffer
Date: Wed, 23 Jan 2008 20:26:35 +0200
Message-ID: <479786DB.3070407@panasas.com>
References: <20080116133217D.fujita.tomonori@lab.ntt.co.jp>	<1200847016.3105.9.camel@localhost.localdomain> <20080121125936R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080005080307040908070903"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:40902 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYAWS1e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 13:27:34 -0500
In-Reply-To: <20080121125936R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

This is a multi-part message in MIME format.
--------------080005080307040908070903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Jan 21 2008 at 5:59 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Sun, 20 Jan 2008 10:36:56 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
>> On Wed, 2008-01-16 at 13:32 +0900, FUJITA Tomonori wrote:
>>> This is the third version of:
>>>
>>> http://marc.info/?l=linux-scsi&m=120038907123706&w=2
>> [...]
>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>> index 54ff611..0a4a5b8 100644
>>> --- a/drivers/scsi/scsi.c
>>> +++ b/drivers/scsi/scsi.c
>>> @@ -186,6 +190,21 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>>>  			list_del_init(&cmd->list);
>>>  		}
>>>  		spin_unlock_irqrestore(&shost->free_list_lock, flags);
>>> +
>>> +		if (cmd) {
>>> +			buf = cmd->sense_buffer;
>>> +			memset(cmd, 0, sizeof(*cmd));
>>> +			cmd->sense_buffer = buf;
>>> +		}
>>> +	} else {
>>> +		buf = kmem_cache_alloc(sense_buffer_slab, __GFP_DMA|gfp_mask);
>> This is going to cause the enterprise some angst because ZONE_DMA can be
>> very small, and the enterprise requrements for commands in flight very
>> large.  I also think its unnecessary if we know the host isn't requiring
>> ISA DMA.
> 
> Yes, I should have done properly.
> 
> 
>>  How about the below to fix this, it's based on the existing
>> infrastructure for solving the very same problem.
> 
> Looks nice. Integrating sense_buffer_pool into struct
> scsi_host_cmd_pool looks much better.
> 
> 
>> James
>>
>> ---
>>
>> >From e7ffbd81684779f5eb41d66d5f499b82af40e12b Mon Sep 17 00:00:00 2001
>> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date: Sun, 20 Jan 2008 09:28:24 -0600
>> Subject: [SCSI] don't use __GFP_DMA for sense buffers if not required
>>
>> Only hosts which actually have ISA DMA requirements need sense buffers
>> coming out of ZONE_DMA, so only use the __GFP_DMA flag for that case
>> to avoid allocating this scarce resource if it's not necessary.
>>
>> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>> ---
>>  drivers/scsi/hosts.c     |    9 +----
>>  drivers/scsi/scsi.c      |  106 +++++++++++++++++++--------------------------
>>  drivers/scsi/scsi_priv.h |    2 -
>>  3 files changed, 46 insertions(+), 71 deletions(-)
>>
> 
> (snip)
> 
>> @@ -310,7 +313,6 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
>>  {
>>  	struct scsi_host_cmd_pool *pool;
>>  	struct scsi_cmnd *cmd;
>> -	unsigned char *sense_buffer;
>>  
>>  	spin_lock_init(&shost->free_list_lock);
>>  	INIT_LIST_HEAD(&shost->free_list);
>> @@ -322,10 +324,13 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
>>  	mutex_lock(&host_cmd_pool_mutex);
>>  	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
>>  	if (!pool->users) {
>> -		pool->slab = kmem_cache_create(pool->name,
>> -				sizeof(struct scsi_cmnd), 0,
>> -				pool->slab_flags, NULL);
>> -		if (!pool->slab)
>> +		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
>> +						   sizeof(struct scsi_cmnd), 0,
>> +						   pool->slab_flags, NULL);
>> +		pool->sense_slab = kmem_cache_create(pool->sense_name,
>> +						     SCSI_SENSE_BUFFERSIZE, 0,
>> +						     pool->slab_flags, NULL);
>> +		if (!pool->cmd_slab || !pool->sense_slab)
>>  			goto fail;
> 
> 
> If one of the above allocations fails, the allocated slab leaks?
> 
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 045e69d..1a9fba6 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -327,11 +327,16 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
>  		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
>  						   sizeof(struct scsi_cmnd), 0,
>  						   pool->slab_flags, NULL);
> +		if (!pool->cmd_slab)
> +			goto fail;
> +
>  		pool->sense_slab = kmem_cache_create(pool->sense_name,
>  						     SCSI_SENSE_BUFFERSIZE, 0,
>  						     pool->slab_flags, NULL);
> -		if (!pool->cmd_slab || !pool->sense_slab)
> +		if (!pool->sense_slab) {
> +			kmem_cache_destroy(pool->cmd_slab);
>  			goto fail;
> +		}
>  	}
>  
>  	pool->users++;
> -
James Tomo Hi.

Has it been decided if this work will be accepted for 2.6.25 merge window?
If so will it be through the first stage scsi-misc or the second stage scsi-bidi?

And lastly will it be in the squashed form, attached.
The reason I ask is because I want to rebase some work on top of that.

Just my $0.02, I think it should go even into the backport versions of 2.6.24.x
after proper testing.

Thanks
Boaz


--------------080005080307040908070903
Content-Type: text/plain;
 name="0001-use-dynamically-allocated-sense-buffer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-use-dynamically-allocated-sense-buffer.patch"

>From 047640aa77747a6ab49b3b38866a8146cf7fcbf4 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 23 Jan 2008 19:56:04 +0200
Subject: [PATCH] use dynamically allocated sense buffer

  This removes static array sense_buffer in scsi_cmnd and uses
  dynamically allocated DMA able sense_buffer.

  The reason for doing this is that some architectures need cacheline
  aligned buffer for DMA:

  http://lkml.org/lkml/2007/11/19/2

  The problems are that scsi_eh_prep_cmnd puts scsi_cmnd::sense_buffer
  to sglist and some LLDs directly DMA to scsi_cmnd::sense_buffer. It's
  necessary to DMA to scsi_cmnd::sense_buffer safely. This patch solves
  these issues.

  __scsi_get_command allocates sense_buffer via kmem_cache_alloc and
  attaches it to a scsi_cmnd so everything just work as before.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi.c      |   92 ++++++++++++++++++++++++++++++++++-----------
 include/scsi/scsi_cmnd.h |    2 +-
 2 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 834d329..b35d194 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -141,20 +141,24 @@ const char * scsi_device_type(unsigned type)
 EXPORT_SYMBOL(scsi_device_type);
 
 struct scsi_host_cmd_pool {
-	struct kmem_cache	*slab;
-	unsigned int	users;
-	char		*name;
-	unsigned int	slab_flags;
-	gfp_t		gfp_mask;
+	struct kmem_cache	*cmd_slab;
+	struct kmem_cache	*sense_slab;
+	unsigned int		users;
+	char			*cmd_name;
+	char			*sense_name;
+	unsigned int		slab_flags;
+	gfp_t			gfp_mask;
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_pool = {
-	.name		= "scsi_cmd_cache",
+	.cmd_name	= "scsi_cmd_cache",
+	.sense_name	= "scsi_sense_cache",
 	.slab_flags	= SLAB_HWCACHE_ALIGN,
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
-	.name		= "scsi_cmd_cache(DMA)",
+	.cmd_name	= "scsi_cmd_cache(DMA)",
+	.sense_name	= "scsi_sense_cache(DMA)",
 	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
 	.gfp_mask	= __GFP_DMA,
 };
@@ -172,9 +176,10 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
+	unsigned char *buf;
 
-	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
-			gfp_mask | shost->cmd_pool->gfp_mask);
+	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
+			       gfp_mask | shost->cmd_pool->gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -186,6 +191,22 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 			list_del_init(&cmd->list);
 		}
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
+
+		if (cmd) {
+			buf = cmd->sense_buffer;
+			memset(cmd, 0, sizeof(*cmd));
+			cmd->sense_buffer = buf;
+		}
+	} else {
+		buf = kmem_cache_alloc(shost->cmd_pool->sense_slab,
+				       gfp_mask | shost->cmd_pool->gfp_mask);
+		if (likely(buf)) {
+			memset(cmd, 0, sizeof(*cmd));
+			cmd->sense_buffer = buf;
+		} else {
+			kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+			cmd = NULL;
+		}
 	}
 
 	return cmd;
@@ -212,7 +233,6 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 	if (likely(cmd != NULL)) {
 		unsigned long flags;
 
-		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
 		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
@@ -246,8 +266,11 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 	}
 	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
-	if (likely(cmd != NULL))
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
+	if (likely(cmd != NULL)) {
+		kmem_cache_free(shost->cmd_pool->sense_slab,
+				cmd->sense_buffer);
+		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+	}
 
 	put_device(dev);
 }
@@ -301,11 +324,19 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	mutex_lock(&host_cmd_pool_mutex);
 	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
 	if (!pool->users) {
-		pool->slab = kmem_cache_create(pool->name,
-				sizeof(struct scsi_cmnd), 0,
-				pool->slab_flags, NULL);
-		if (!pool->slab)
+		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
+						   sizeof(struct scsi_cmnd), 0,
+						   pool->slab_flags, NULL);
+		if (!pool->cmd_slab)
+			goto fail;
+
+		pool->sense_slab = kmem_cache_create(pool->sense_name,
+						     SCSI_SENSE_BUFFERSIZE, 0,
+						     pool->slab_flags, NULL);
+		if (!pool->sense_slab) {
+			kmem_cache_destroy(pool->cmd_slab);
 			goto fail;
+		}
 	}
 
 	pool->users++;
@@ -315,17 +346,28 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
-			GFP_KERNEL | shost->cmd_pool->gfp_mask);
+	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
+			       GFP_KERNEL | shost->cmd_pool->gfp_mask);
 	if (!cmd)
 		goto fail2;
+
+	cmd->sense_buffer = kmem_cache_alloc(shost->cmd_pool->sense_slab,
+					     GFP_KERNEL |
+					     shost->cmd_pool->gfp_mask);
+	if (!cmd->sense_buffer)
+		goto fail2;
+
 	list_add(&cmd->list, &shost->free_list);
 	return 0;
 
  fail2:
+	if (cmd)
+		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	mutex_lock(&host_cmd_pool_mutex);
-	if (!--pool->users)
-		kmem_cache_destroy(pool->slab);
+	if (!--pool->users) {
+		kmem_cache_destroy(pool->cmd_slab);
+		kmem_cache_destroy(pool->sense_slab);
+	}
  fail:
 	mutex_unlock(&host_cmd_pool_mutex);
 	return -ENOMEM;
@@ -342,12 +384,16 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 
 		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
 		list_del_init(&cmd->list);
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
+		kmem_cache_free(shost->cmd_pool->sense_slab,
+				cmd->sense_buffer);
+		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	}
 
 	mutex_lock(&host_cmd_pool_mutex);
-	if (!--shost->cmd_pool->users)
-		kmem_cache_destroy(shost->cmd_pool->slab);
+	if (!--shost->cmd_pool->users) {
+		kmem_cache_destroy(shost->cmd_pool->cmd_slab);
+		kmem_cache_destroy(shost->cmd_pool->sense_slab);
+	}
 	mutex_unlock(&host_cmd_pool_mutex);
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9811666..de28aab 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -84,7 +84,7 @@ struct scsi_cmnd {
 				   	   working on */
 
 #define SCSI_SENSE_BUFFERSIZE 	96
-	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
 				 * command (auto-sense) */
-- 
1.5.3.3


--------------080005080307040908070903--
