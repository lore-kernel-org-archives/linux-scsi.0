Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611117C64;
	Wed,  3 Apr 2024 06:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712127059; cv=none; b=iXCvhDLe3NgBq1WiIuGDznyTgStxgD7Oa6jD84GvfICftqCJ7/lpORDWerwsHBb3F+jOAWuVf/NyWCPYolcehCJYQwpKnmnnNBrf/DPUdHpP9yW1+bOQo8Q0EGSDKYnr3sYtDk4krfB0FopBxbRPyDIKBWyNDqAgOwS0Qh0zNMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712127059; c=relaxed/simple;
	bh=KgHw1aji28T5H/xvaw3m8Q9RpeEuiGuKu9hh8MlcvJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pl200kOZxON50fTDfMLHhkwVbsvl15kFzQWfPpY9JaVFCJjOP7dECN59lQxtEyJH4FOnMoOoTKAGIGSyiet+EvXwNIIhYeFpghyKRYCdrxLXU6y0CJLWpPiTwh5Uq0ub2+U3VCpe3pgQfvoZdSiHhxHt/tLDQciuttgB+4UZ4hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jMJSMYZC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RAu4SnNR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jMJSMYZC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RAu4SnNR"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B2ABE34A60;
	Wed,  3 Apr 2024 06:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712127054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9UBIdS/5pVDyT4gx08b7Vz/3wFtzLCPe0c2nJQdTgE=;
	b=jMJSMYZCnRM81XQslvJv9zFcmAXETtXlzIQvbj1Nrl9oLR5uaAb0FzQIheEi3Ih/yfpJKI
	oKHLE1imPfa4mvm+IM7qfAKqpnuK33bHiSKQmYAzcn3G7o31cFIUeft85AS59YzFFzWWtz
	soPgPtkyqr9YgV4fEJj1wuwvGZ/IxVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712127054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9UBIdS/5pVDyT4gx08b7Vz/3wFtzLCPe0c2nJQdTgE=;
	b=RAu4SnNRbzb8WlW+FcIR+SklHi/p/vCcItct5GU6zLNHckaUEI3+yNfUq0mWSZ3fdosNfy
	vFkJz0AKgAC/WZDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id D74E013357;
	Wed,  3 Apr 2024 06:50:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id YKjTMkz8DGYtCwAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 06:50:52 +0000
Message-ID: <db9cefa4-b9c0-4a40-b232-68423fa98271@suse.de>
Date: Wed, 3 Apr 2024 08:50:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/23] scsi_transport_fc: add a max_bsg_segments field to
 struct fc_function_template
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
 <20240402130645.653507-6-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402130645.653507-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B2ABE34A60
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	MIME_TRACE(0.00)[0:+];
	R_DKIM_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap2.dmz-prg2.suse.org:rdns,imap2.dmz-prg2.suse.org:helo,lst.de:email]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO

On 4/2/24 15:06, Christoph Hellwig wrote:
> ibmvfc only supports a single segment for BSG FC passthrough.  Instead of
> having it set a queue limits after creating the BSD queues, add a field so
> that the FC transport can set it before allocating the queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/ibmvscsi/ibmvfc.c   | 5 +----
>   drivers/scsi/scsi_transport_fc.c | 2 ++
>   include/scsi/scsi_transport_fc.h | 1 +
>   3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 05b126bfd18b55..a3d1013c83075c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -5541,8 +5541,6 @@ static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
>   			rport->supported_classes |= FC_COS_CLASS2;
>   		if (be32_to_cpu(tgt->service_parms.class3_parms[0]) & 0x80000000)
>   			rport->supported_classes |= FC_COS_CLASS3;
> -		if (rport->rqst_q)
> -			blk_queue_max_segments(rport->rqst_q, 1);
>   	} else
>   		tgt_dbg(tgt, "rport add failed\n");
>   	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> @@ -6391,8 +6389,6 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>   
>   	ibmvfc_init_sub_crqs(vhost);
>   
> -	if (shost_to_fc_host(shost)->rqst_q)
> -		blk_queue_max_segments(shost_to_fc_host(shost)->rqst_q, 1);
>   	dev_set_drvdata(dev, vhost);
>   	spin_lock(&ibmvfc_driver_lock);
>   	list_add_tail(&vhost->queue, &ibmvfc_head);
> @@ -6547,6 +6543,7 @@ static struct fc_function_template ibmvfc_transport_functions = {
>   	.get_starget_port_id = ibmvfc_get_starget_port_id,
>   	.show_starget_port_id = 1,
>   
> +	.max_bsg_segments = 1,
>   	.bsg_request = ibmvfc_bsg_request,
>   	.bsg_timeout = ibmvfc_bsg_timeout,
>   };
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 0799700b0fca77..7d088b8da07578 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -4288,6 +4288,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
>   	snprintf(bsg_name, sizeof(bsg_name),
>   		 "fc_host%d", shost->host_no);
>   	scsi_init_limits(shost, &lim);
> +	lim.max_segments = min_not_zero(lim.max_segments, i->f->max_bsg_segments);
>   	q = bsg_setup_queue(dev, bsg_name, &lim, fc_bsg_dispatch,
>   			fc_bsg_job_timeout, i->f->dd_bsg_size);
>   	if (IS_ERR(q)) {
> @@ -4320,6 +4321,7 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
>   		return -ENOTSUPP;
>   
>   	scsi_init_limits(shost, &lim);
> +	lim.max_segments = min_not_zero(lim.max_segments, i->f->max_bsg_segments);
>   	q = bsg_setup_queue(dev, dev_name(dev), &lim, fc_bsg_dispatch_prep,
>   				fc_bsg_job_timeout, i->f->dd_bsg_size);
>   	if (IS_ERR(q)) {
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index 483513c575976c..fd039306ffbb20 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -709,6 +709,7 @@ struct fc_function_template {
>   	int  	(*vport_delete)(struct fc_vport *);
>   
>   	/* bsg support */
> +	u32				max_bsg_segments;
>   	int	(*bsg_request)(struct bsg_job *);
>   	int	(*bsg_timeout)(struct bsg_job *);
>   
That looks like an odd alignment...

Anyway:
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

