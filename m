Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E7B59B6C;
	Wed,  3 Apr 2024 07:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712127981; cv=none; b=IJZVYbXbVuf7h4aCJIRTWopQLQTYW6mvfhp5+pgAOKxq7Gk9yz2mKZSv1/MffXoyqwwidhD8hFXiV4uEC7uUw82iuhjco4MCqVbsKmF+mRGa1gmK2iqXvtmWWeqzPhSDRmAHGEkex3fNYV/x3zIe16rdQmQpWg/K8H4ZW7DNBZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712127981; c=relaxed/simple;
	bh=huDHheKMY5U475bzaGJTBzo8Q4KK113xdOgQZbqtBQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DOu0DSCHrPAxEuEVCnvgMksebFalG15UkHj0YIG5IHtHv6hrI9ZT4adMMg2FOMBxf+UDEAtpYfLN1Bn6FF69MCv016L+DDzw80fbwcHQBU/KWRsa/I0Wp1WfRjH5ZqdtULJ3BtGzBlgwk64ChY5mCRArhd4ZVmDP76qz2PN6z60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=szckVdgs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eG2x1N0U; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="szckVdgs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eG2x1N0U"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C3725C3A6;
	Wed,  3 Apr 2024 07:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712127976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wIvsQfFIhfnJPerBO+JoS38ScrQ+EYMMEjWxZ5bIlsM=;
	b=szckVdgs7Bt9xjOjcM+YeKNSSn9qcJJPOOUGp4y+B0vEbB7f6iHdH7AkW5pLSQnefHaHRL
	ODNiErxXCjNWqMGtXNjQmdAAcy4TdTGFxSJtYPsnc1O+t/txm14uLbNOvMcmi7LPxS0m3g
	aunKNQehXdktYBG/s6QdjhrDhdBP7f4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712127976;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wIvsQfFIhfnJPerBO+JoS38ScrQ+EYMMEjWxZ5bIlsM=;
	b=eG2x1N0Ux9i7YH334r9nHzv3GUkooSAe1Sfgtc4HJ45jmgk9eLpN7s4aaDNvXpCe+xylyG
	NIRrPgCWlBul+tBQ==
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id A476913357;
	Wed,  3 Apr 2024 07:06:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id MvFsJub/DGZnEAAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 07:06:14 +0000
Message-ID: <9f555953-6b41-4962-8f43-339326e30d6a@suse.de>
Date: Wed, 3 Apr 2024 09:06:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/23] megaraid_sas: switch to using ->device_configure
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20240402130645.653507-1-hch@lst.de>
 <20240402130645.653507-12-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402130645.653507-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap2.dmz-prg2.suse.org:rdns,imap2.dmz-prg2.suse.org:helo,suse.de:email,lst.de:email]
X-Spam-Score: -3.29
X-Spam-Level: 
X-Spam-Flag: NO

On 4/2/24 15:06, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
>   drivers/scsi/megaraid/megaraid_sas_base.c   | 29 ++++++++++++---------
>   drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 ++-
>   3 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 56624cbf7fa5e7..5680c6cdb22193 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2701,7 +2701,7 @@ int megasas_get_ctrl_info(struct megasas_instance *instance);
>   int
>   megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend);
>   void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
> -					   bool is_target_prop);
> +		struct queue_limits *lim, bool is_target_prop);
>   int megasas_get_target_prop(struct megasas_instance *instance,
>   			    struct scsi_device *sdev);
>   void megasas_get_snapdump_properties(struct megasas_instance *instance);
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 3d4f13da1ae873..def0d905b6d9e3 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1888,7 +1888,7 @@ static struct megasas_instance *megasas_lookup_instance(u16 host_no)
>   * Returns void
>   */
>   void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
> -					   bool is_target_prop)
> +		struct queue_limits *lim, bool is_target_prop)
>   {
>   	u16 pd_index = 0, ld;
>   	u32 device_id;
> @@ -1915,8 +1915,10 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
>   			return;
>   		raid = MR_LdRaidGet(ld, local_map_ptr);
>   
> -		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
> -			blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
> +		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER) {
> +			if (lim)
> +				lim->dma_alignment = 0x7;
> +		}
>   
>   		mr_device_priv_data->is_tm_capable =
>   			raid->capability.tmCapable;
> @@ -1967,7 +1969,8 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
>    *
>    */
>   static inline void
> -megasas_set_nvme_device_properties(struct scsi_device *sdev, u32 max_io_size)
> +megasas_set_nvme_device_properties(struct scsi_device *sdev,
> +		struct queue_limits *lim, u32 max_io_size)
>   {
>   	struct megasas_instance *instance;
>   	u32 mr_nvme_pg_size;
> @@ -1976,10 +1979,10 @@ megasas_set_nvme_device_properties(struct scsi_device *sdev, u32 max_io_size)
>   	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
>   				MR_DEFAULT_NVME_PAGE_SIZE);
>   
> -	blk_queue_max_hw_sectors(sdev->request_queue, (max_io_size / 512));
> +	lim->max_hw_sectors = max_io_size / 512;
> +	lim->virt_boundary_mask = mr_nvme_pg_size - 1;
>   
>   	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, sdev->request_queue);
> -	blk_queue_virt_boundary(sdev->request_queue, mr_nvme_pg_size - 1);
>   }
That now looks odd.
We're taking great pains to have everything in queue_limits and avoid 
having to use the request_queue directly, yet this one call we're missing.
Wouldn't it make sense to move that into queue_limits, too?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

