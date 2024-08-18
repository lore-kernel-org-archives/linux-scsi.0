Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481551A291
	for <linux-scsi@vger.kernel.org>; Sun, 18 Aug 2024 23:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724025101; cv=none; b=Ce7yI5H24H2ka6CB2mO1MGJrpOkTsh+QYgcRIc+vFMVEvraMrFb/xKpZj6SLLfXrwAKiGUjXK1H3VAAhcnWyd0QUY8ZIBhedRx8PqmRZSIKEGABCDx17NQGYUsdvH342/LriNCQMntWvDDUnvNeA/fzajhkHElArmSPvmnKBlGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724025101; c=relaxed/simple;
	bh=rGBx+c3Z7k0yXDZUUpPuxzPeLtXM7nEm0n6FTkRB0qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WWJw4RaPB30jsA+XrydHDa3t48exkmNOYWmFBFQC6s0J0begA0UvZ1Cg3EQte+Pyt/WK0ZEqbWBVCeb7ENBsqwd+4wCAYO9+Dh4lsZmvRRYVE+0u2bJSFsc5P2YDXXYOmtOkADbC7bM74iHYC2/wKMDz2eb6RQreem//oDaL8xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CY504SuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CY504SuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAFEC32786;
	Sun, 18 Aug 2024 23:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724025101;
	bh=rGBx+c3Z7k0yXDZUUpPuxzPeLtXM7nEm0n6FTkRB0qg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CY504SuQkl/6EzlVY5wqungO0Qg+o33lV9Nkjn7Fn1ZUKvcdtxCFKB5UrCsW9iMKl
	 hgG7a07lPET8fQo6hBuWUWvzwcyIidlmJHDEsXJpgRCPvFESryqJ7MizY6fl+T5JuF
	 +SigjEuuRFkwyVI8kvt7Nz8Xcu2KhMEz6zrxqmd+swIHAB2hZ0waEeNqFcRznrs0vT
	 yWVFEAgWOaf6iNnVlA/XMfrvlb9h9rcXKlCRDfC+eaLj2X9xRzCyg0l+XWZpGF/NE3
	 FKkQfUc5VQaEYgnRdt9E/0FdC6Hd7CX9OsUby+7vn0rFfTJdWxfB147l5FID5RFWRy
	 3erRhcjb61sUw==
Message-ID: <c1d0468d-eaf0-46c2-ba62-846ffdae6993@kernel.org>
Date: Mon, 19 Aug 2024 08:51:39 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/18] scsi: mptfusion: Simplify the alloc*_workqueue()
 invocations
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
References: <20240816215605.36240-1-bvanassche@acm.org>
 <20240816215605.36240-3-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240816215605.36240-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/24 06:55, Bart Van Assche wrote:
> Let alloc*_workqueue() format the workqueue names instead of calling
> snprintf() explicitly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

In patch 1, you have all the changes for removing the use of
create_singlethread_workqueue() in a single patch, touching different drivers.
But the series has 17 more patches to further cleanup the workqueue API use in
various drivers. So why not have the changes in patch 1 split into these
different driver patches with a title like "Cleanup and simplify workqueue API
use" ? That would make reviewing easier I think and avoid having the patch 2-17
changing again code that was changed in patch 1...

> ---
>  drivers/message/fusion/mptbase.c | 10 +++-------
>  drivers/message/fusion/mptbase.h |  3 ---
>  drivers/message/fusion/mptfc.c   |  7 ++-----
>  3 files changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 4bf669c55649..738bc4e60a18 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1856,10 +1856,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  	/* Initialize workqueue */
>  	INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_reset_work);
>  
> -	snprintf(ioc->reset_work_q_name, MPT_KOBJ_NAME_LEN,
> -		 "mpt_poll_%d", ioc->id);
> -	ioc->reset_work_q = alloc_workqueue(ioc->reset_work_q_name,
> -					    WQ_MEM_RECLAIM, 0);
> +	ioc->reset_work_q =
> +		alloc_workqueue("mpt_poll_%d", WQ_MEM_RECLAIM, 0, ioc->id);
>  	if (!ioc->reset_work_q) {
>  		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
>  		    ioc->name);
> @@ -1986,9 +1984,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	INIT_LIST_HEAD(&ioc->fw_event_list);
>  	spin_lock_init(&ioc->fw_event_lock);
> -	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
> -	ioc->fw_event_q = alloc_workqueue(ioc->fw_event_q_name,
> -					  WQ_MEM_RECLAIM, 0);
> +	ioc->fw_event_q = alloc_workqueue("mpt/%d", WQ_MEM_RECLAIM, 0, ioc->id);
>  	if (!ioc->fw_event_q) {
>  		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
>  		    ioc->name);
> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> index 8031173c3655..b406fd676da0 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -729,7 +729,6 @@ typedef struct _MPT_ADAPTER
>  	struct list_head	 fw_event_list;
>  	spinlock_t		 fw_event_lock;
>  	u8			 fw_events_off; /* if '1', then ignore events */
> -	char 			 fw_event_q_name[MPT_KOBJ_NAME_LEN];
>  
>  	struct mutex		 sas_discovery_mutex;
>  	u8			 sas_discovery_runtime;
> @@ -764,7 +763,6 @@ typedef struct _MPT_ADAPTER
>  	u8			 fc_link_speed[2];
>  	spinlock_t		 fc_rescan_work_lock;
>  	struct work_struct	 fc_rescan_work;
> -	char			 fc_rescan_work_q_name[MPT_KOBJ_NAME_LEN];
>  	struct workqueue_struct *fc_rescan_work_q;
>  
>  	/* driver forced bus resets count */
> @@ -778,7 +776,6 @@ typedef struct _MPT_ADAPTER
>  	spinlock_t		  scsi_lookup_lock;
>  	u64			dma_mask;
>  	u32			  broadcast_aen_busy;
> -	char			 reset_work_q_name[MPT_KOBJ_NAME_LEN];
>  	struct workqueue_struct *reset_work_q;
>  	struct delayed_work	 fault_reset_work;
>  
> diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
> index a3c17c4fe69c..91242f26defb 100644
> --- a/drivers/message/fusion/mptfc.c
> +++ b/drivers/message/fusion/mptfc.c
> @@ -1349,11 +1349,8 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	/* initialize workqueue */
>  
> -	snprintf(ioc->fc_rescan_work_q_name, sizeof(ioc->fc_rescan_work_q_name),
> -		 "mptfc_wq_%d", sh->host_no);
> -	ioc->fc_rescan_work_q =
> -		alloc_ordered_workqueue(ioc->fc_rescan_work_q_name,
> -					WQ_MEM_RECLAIM);
> +	ioc->fc_rescan_work_q = alloc_ordered_workqueue(
> +		"mptfc_wq_%d", WQ_MEM_RECLAIM, sh->host_no);
>  	if (!ioc->fc_rescan_work_q) {
>  		error = -ENOMEM;
>  		goto out_mptfc_host;
> 

-- 
Damien Le Moal
Western Digital Research

