Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532C11DF744
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738173274; cv=none; b=vEPnxp0SkhyZjJfg24ns0f6CzEkQG3/JaG7lkFuAgoTRJhGar6zMDrV1uDFsqpB5aR9mcHwKWWISjOflXunqPdvALVwvsk7ZvvMOlmdyqSmevq1QdC+lnlx6Z7b+0B7yaTPF6QJovtxCneC+csl59tI7IL9W8wpARw7drFw1jq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738173274; c=relaxed/simple;
	bh=im3e7mObsHL8rSavJFhI07jcL+XoVhJ/ZJYS4wL1dR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FT+kdOVnDKHufZ4TUPXMzq6B+aLD2bRY3u0lfMhBV6Yk1Z1I5ZD1wwcv/XhNOESD8STul6iPgTUmNBR1bvmiwXm95joLrrZbZXnyGvLs4cCIaobrl9ADNmMEZNJw8/LWNXVYGJl2+BldG5+gnO/xxaxS3lu9XJ0+AL9AZ5zGUD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JXuYJVG3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXuYJVG3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738173271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LF9dhdi2Ms99sJ/8eCwPN+j4ILEi7Kjm92lXDqdKv/k=;
	b=JXuYJVG3R/RUdvL+a/gAh1NQFfKn/bj80ZvkWrcEyMSojU/pxHG9a5b+436BT1BqOUn2wl
	OO8nFR7AMdapBViq8HqKxWZMX6OSSNhd6qL83DaQVGtgURIZx0iY19OOFCFt9EgvlePiiV
	2zQDQCMY1evzXFt95nT3PuPNcSCNlpo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-kpX-6MS_M_Wrx0gJk-HR6w-1; Wed,
 29 Jan 2025 12:54:27 -0500
X-MC-Unique: kpX-6MS_M_Wrx0gJk-HR6w-1
X-Mimecast-MFC-AGG-ID: kpX-6MS_M_Wrx0gJk-HR6w
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F40001801F10;
	Wed, 29 Jan 2025 17:54:25 +0000 (UTC)
Received: from [10.22.66.117] (unknown [10.22.66.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC29030001BE;
	Wed, 29 Jan 2025 17:54:23 +0000 (UTC)
Message-ID: <1c2b135a-cb9c-4107-a198-7544d2433d5b@redhat.com>
Date: Wed, 29 Jan 2025 12:54:22 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IRQ
 affinity
To: Sagar Biradar <sagar.biradar@microchip.com>, jejb@linux.vnet.ibm.com,
 linux-scsi@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>, Marco Patalano <mpatalan@redhat.com>,
 Scott Benesh <Scott.Benesh@microchip.com>,
 Don Brace <Don.Brace@microchip.com>, Tom White <Tom.White@microchip.com>,
 Abhinav Kuchibhotla <Abhinav.Kuchibhotla@microchip.com>
References: <20250127213223.318751-1-sagar.biradar@microchip.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250127213223.318751-1-sagar.biradar@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Sagar,

I'm having trouble applying this patch to scsi/6.14/staging.

Please re-base your patch and submit a v2.

You might want to fix the broken "--cc=" argument in your email.

/John

Applying: aacraid: Fix reply queue mapping to CPUs based on IRQ affinity
Patch failed at 0001 aacraid: Fix reply queue mapping to CPUs based on IRQ affinity
error: patch failed: drivers/scsi/aacraid/linit.c:1488
error: drivers/scsi/aacraid/linit.c: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort".
hint: Disable this message with "git config set advice.mergeConflict false"

John A. Meneghini
Senior Principal Platform Storage Engineer
RHEL SST - Platform Storage Group
jmeneghi@redhat.com

On 1/27/25 4:32 PM, Sagar Biradar wrote:
> Fixes: "(c5becf57dd56 Revert "scsi: aacraid: Reply queue mapping to CPUs
> based on IRQ affinity)"
> Original patch: "(9dc704dcc09e scsi: aacraid: Reply queue mapping to
> CPUs based on IRQ affinity)"
> 
> Fix a rare I/O hang that arises because of an MSIx vector not having a
> mapped online CPU upon receiving completion.
> 
> A new modparam "aac_cpu_offline_feature" to control CPU offlining.
> By default, it's disabled (0), but can be enabled during driver load
> with:
> 	insmod ./aacraid.ko aac_cpu_offline_feature=1
> Enabling this feature allows CPU offlining but may cause some IO
> performance drop. It is recommended to enable it during driver load
> as the relevant changes are part of the initialization routine.
> 
> SCSI cmds use the mq_map to get the vector_no via blk_mq_unique_tag()
> and blk_mq_unique_tag_to_hwq() - which are setup during the blk_mq init.
> For reserved cmds, or the ones before the blk_mq init, use the vector_no
> 0, which is the norm since don't yet have a proper mapping to the queues.
> 
> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
> Reviewed-by: John Meneghini <jmeneghi@redhat.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Tested-by: Marco Patalano <mpatalan@redhat.com>
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
> ---
>   drivers/scsi/aacraid/aachba.c  |  6 ++++++
>   drivers/scsi/aacraid/aacraid.h |  2 ++
>   drivers/scsi/aacraid/commsup.c | 10 +++++++++-
>   drivers/scsi/aacraid/linit.c   | 16 ++++++++++++++++
>   drivers/scsi/aacraid/src.c     | 28 ++++++++++++++++++++++++++--
>   5 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index abf6a82b74af..f325e79a1a01 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -328,6 +328,12 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
>   	"\t1 - Array Meta Data Signature (default)\n"
>   	"\t2 - Adapter Serial Number");
>   
> +int aac_cpu_offline_feature;
> +module_param_named(aac_cpu_offline_feature, aac_cpu_offline_feature, int, 0644);
> +MODULE_PARM_DESC(aac_cpu_offline_feature,
> +	"This enables CPU offline feature and may result in IO performance drop in some cases:\n"
> +	"\t0 - Disable (default)\n"
> +	"\t1 - Enable");
>   
>   static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
>   		struct fib *fibptr) {
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 8c384c25dca1..dba7ffc6d543 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1673,6 +1673,7 @@ struct aac_dev
>   	u32			handle_pci_error;
>   	bool			init_reset;
>   	u8			soft_reset_support;
> +	u8			use_map_queue;
>   };
>   
>   #define aac_adapter_interrupt(dev) \
> @@ -2777,4 +2778,5 @@ extern int update_interval;
>   extern int check_interval;
>   extern int aac_check_reset;
>   extern int aac_fib_dump;
> +extern int aac_cpu_offline_feature;
>   #endif
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index ffef61c4aa01..5e12899823ac 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -223,8 +223,16 @@ int aac_fib_setup(struct aac_dev * dev)
>   struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
>   {
>   	struct fib *fibptr;
> +	u32 blk_tag;
> +	int i;
> +
> +	if (aac_cpu_offline_feature == 1) {
> +		blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +		i = blk_mq_unique_tag_to_tag(blk_tag);
> +		fibptr = &dev->fibs[i];
> +	} else
> +		fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
>   
> -	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
>   	/*
>   	 *	Null out fields that depend on being zero at the start of
>   	 *	each I/O
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 68f4dbcfff49..56c5ce10555a 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -504,6 +504,15 @@ static int aac_slave_configure(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> +static void aac_map_queues(struct Scsi_Host *shost)
> +{
> +	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
> +
> +	blk_mq_map_hw_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +				&aac->pdev->dev, 0);
> +	aac->use_map_queue = true;
> +}
> +
>   /**
>    *	aac_change_queue_depth		-	alter queue depths
>    *	@sdev:	SCSI device we are considering
> @@ -1488,6 +1497,7 @@ static const struct scsi_host_template aac_driver_template = {
>   	.bios_param			= aac_biosparm,
>   	.shost_groups			= aac_host_groups,
>   	.slave_configure		= aac_slave_configure,
> +	.map_queues			= aac_map_queues,
>   	.change_queue_depth		= aac_change_queue_depth,
>   	.sdev_groups			= aac_dev_groups,
>   	.eh_abort_handler		= aac_eh_abort,
> @@ -1775,6 +1785,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	shost->max_lun = AAC_MAX_LUN;
>   
>   	pci_set_drvdata(pdev, shost);
> +	if (aac_cpu_offline_feature == 1) {
> +		shost->nr_hw_queues = aac->max_msix;
> +		shost->can_queue    = aac->vector_cap;
> +		shost->host_tagset = 1;
> +	}
>   
>   	error = scsi_add_host(shost, &pdev->dev);
>   	if (error)
> @@ -1906,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)
>   	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>   
>   	aac_cancel_rescan_worker(aac);
> +	aac->use_map_queue = false;
>   	scsi_remove_host(shost);
>   
>   	__aac_shutdown(aac);
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 28115ed637e8..befc32353b84 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)
>   #endif
>   
>   	u16 vector_no;
> +	struct scsi_cmnd *scmd;
> +	u32 blk_tag;
> +	struct Scsi_Host *shost = dev->scsi_host_ptr;
> +	struct blk_mq_queue_map *qmap;
>   
>   	atomic_inc(&q->numpending);
>   
> @@ -505,8 +509,28 @@ static int aac_src_deliver_message(struct fib *fib)
>   		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
>   			&& dev->sa_firmware)
>   			vector_no = aac_get_vector(dev);
> -		else
> -			vector_no = fib->vector_no;
> +		else {
> +			if (aac_cpu_offline_feature == 1) {
> +				if (!fib->vector_no || !fib->callback_data) {
> +					if (shost && dev->use_map_queue) {
> +						qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
> +						vector_no = qmap->mq_map[raw_smp_processor_id()];
> +					}
> +					/*
> +					 *	We hardcode the vector_no for
> +					 *	reserved commands as a valid shost is
> +					 *	absent during the init
> +					 */
> +					else
> +						vector_no = 0;
> +				} else {
> +					scmd = (struct scsi_cmnd *)fib->callback_data;
> +					blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +					vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
> +				}
> +			} else
> +				vector_no = fib->vector_no;
> +		}
>   
>   		if (native_hba) {
>   			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {

