Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC81055E74;
	Wed,  3 Apr 2024 07:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712128116; cv=none; b=cMAkKAte2UvfoEgTqncw+rdvA74QN1J1lU/u6kzidNUtA5HPoKCU+C6vneHenLuxUeSh/1BlgLv2p4tRis96S5iThQNOfT+NENAThRJTCWamIPvDWm3awu/YiMrJEDaHLZ60ZNNgauJSkqkWj7a0BCnChH6ELJ36wEJg9/yB0vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712128116; c=relaxed/simple;
	bh=ylES4d7jjxTEdQvLeuFRxt2JGixnH+heDFe4hCks/M0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ATO36s934PSZSyg4vAD29kM/XRoYFYTSYuYU6GqFiRN48I8Wo/+57ph8oNEHvoKkd6S4QAFKotP8uRBbJENrdyNjc2MGuNzrU2Re+S5JaloJeTQ09cX8aGZR7stXlaeVUTykwzMiQURiogOkt5BgppjDRqw61R3CveHqjs556UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pIjIFZvG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=19qBfQNh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pIjIFZvG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="19qBfQNh"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EB3BC3501F;
	Wed,  3 Apr 2024 07:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712128112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+9Qflfrrg7coTqjTjYc20vYzCht7wOLKF+4E1QBLxk=;
	b=pIjIFZvGBzVQ9wpG7lIZ450xx1No1iinjsZSEaeF6s7rDKQrJhong1Fil35FDnA7ybvEyF
	Rz1xWV5o4cd9jeoR0PkYwMVoFChaXarqbG0m60XehEmvLsTLbf/IRun42RbcD5FfuYI8Y1
	MzKCgc9BaQDKeqFxgNA6Cvxj5+oLy3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712128112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+9Qflfrrg7coTqjTjYc20vYzCht7wOLKF+4E1QBLxk=;
	b=19qBfQNhuTRcwZ3kqHR8nRfeEX0VoiKKWLzJOb5iSa6TkICUEL4pMehXd+79W/6M5OHIlW
	18VmgjSHD3g9goAg==
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 8ACAB13357;
	Wed,  3 Apr 2024 07:08:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 1GXfH28ADWYlEQAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 07:08:31 +0000
Message-ID: <031d6f0c-7d94-4adc-b194-929dbfe80c6b@suse.de>
Date: Wed, 3 Apr 2024 09:08:26 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/23] mpt3sas: switch to using ->device_configure
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
 <20240402130645.653507-13-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402130645.653507-13-hch@lst.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,lst.de:email]
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
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c | 18 ++++++++----------
>   1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index ef8ee93005eae6..89ef43a5ef862d 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -2497,14 +2497,15 @@ _scsih_enable_tlr(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev)
>   }
>   
>   /**
> - * scsih_slave_configure - device configure routine.
> + * scsih_device_configure - device configure routine.
>    * @sdev: scsi device struct
> + * @lim: queue limits
>    *
>    * Return: 0 if ok. Any other return is assumed to be an error and
>    * the device is ignored.
>    */
>   static int
> -scsih_slave_configure(struct scsi_device *sdev)
> +scsih_device_configure(struct scsi_device *sdev, struct queue_limits *lim)
>   {
>   	struct Scsi_Host *shost = sdev->host;
>   	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
> @@ -2609,8 +2610,7 @@ scsih_slave_configure(struct scsi_device *sdev)
>   			    raid_device->num_pds, ds);
>   
>   		if (shost->max_sectors > MPT3SAS_RAID_MAX_SECTORS) {
> -			blk_queue_max_hw_sectors(sdev->request_queue,
> -						MPT3SAS_RAID_MAX_SECTORS);
> +			lim->max_hw_sectors = MPT3SAS_RAID_MAX_SECTORS;
>   			sdev_printk(KERN_INFO, sdev,
>   					"Set queue's max_sector to: %u\n",
>   						MPT3SAS_RAID_MAX_SECTORS);
> @@ -2675,8 +2675,7 @@ scsih_slave_configure(struct scsi_device *sdev)
>   				pcie_device->connector_name);
>   
>   		if (pcie_device->nvme_mdts)
> -			blk_queue_max_hw_sectors(sdev->request_queue,
> -					pcie_device->nvme_mdts/512);
> +			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
>   
>   		pcie_device_put(pcie_device);
>   		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
> @@ -2687,8 +2686,7 @@ scsih_slave_configure(struct scsi_device *sdev)
>   		 **/
>   		blk_queue_flag_set(QUEUE_FLAG_NOMERGES,
>   				sdev->request_queue);
> -		blk_queue_virt_boundary(sdev->request_queue,
> -				ioc->page_size - 1);
> +		lim->virt_boundary_mask = ioc->page_size - 1;
>   		return 0;
>   	}
Here the same argument as done for the previous patch could be made; if 
we had the possibility to set NOMERGES in the queue limits we could do 
away with the reference to the request queue here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

