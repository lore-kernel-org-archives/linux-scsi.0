Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9003101B7
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 08:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762504171; cv=none; b=BrLBf2ubdVKLUT237dwXPFxVUA0/W5er5YkPFwztIMjMGgvAEiCHlIAdPpu/HhTObyDc6ZBczSVT9qpkVW24OrS0GiJoASsHhoLfXByiht0E9wTN/Iv3P8hYwUzgk6gHxdOHStaCT57+4IsVkSVhB2TWDo88aF/TxSMPP7i+LLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762504171; c=relaxed/simple;
	bh=8CeuLoVTEr8ZsCbdaH0QRyKDJDSnHv4QUV1FytbyFh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0f4Tp+yGJjeQO9Q5fFXyH1j/Fiut3eOWYwWk19aZRmFwPiL8ps6GWemxrJ1LXffZi5VBfn9qADu/Dx65dqkllhVQ+o7+VkfBPl+q+efUr9AeRsQ1XWtlrLCri6DNRj5+mUe2ixvbjAzIkDZoABtYef2Ox6rMdaOGDqxdCWUI8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nVIc40WX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cM+MhUHL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nVIc40WX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cM+MhUHL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nVIc40WX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cM+MhUHL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nVIc40WX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cM+MhUHL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7AD071F7A1;
	Fri,  7 Nov 2025 08:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762504167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1eLgnxDYznONidggwD9YWH0yu1N9mAO7cl3bnaMr1hk=;
	b=nVIc40WXj913We8n5cAfm7slEu49ofO+foQh2/KMjoZNbNQjFFMwI2BjwCdOh69NlM0zjJ
	R5Ki9K7Gg+esaWEOBVQbf/XgSHaRFXykBw/OlPstB+MO78gYecxSn1yPTsy2Xy/qUK2U09
	GGQM82aHV3xJUs5vqMiH/bTwDNsrnGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762504167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1eLgnxDYznONidggwD9YWH0yu1N9mAO7cl3bnaMr1hk=;
	b=cM+MhUHLwAEsF8PDd7TKh/lEi87zcuKP0EeyJQ3hskYmQcDxuxJodHEIUb0zhnayy6HMyq
	V6MYGdWIVLCUW1Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762504167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1eLgnxDYznONidggwD9YWH0yu1N9mAO7cl3bnaMr1hk=;
	b=nVIc40WXj913We8n5cAfm7slEu49ofO+foQh2/KMjoZNbNQjFFMwI2BjwCdOh69NlM0zjJ
	R5Ki9K7Gg+esaWEOBVQbf/XgSHaRFXykBw/OlPstB+MO78gYecxSn1yPTsy2Xy/qUK2U09
	GGQM82aHV3xJUs5vqMiH/bTwDNsrnGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762504167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1eLgnxDYznONidggwD9YWH0yu1N9mAO7cl3bnaMr1hk=;
	b=cM+MhUHLwAEsF8PDd7TKh/lEi87zcuKP0EeyJQ3hskYmQcDxuxJodHEIUb0zhnayy6HMyq
	V6MYGdWIVLCUW1Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E950C132DD;
	Fri,  7 Nov 2025 08:29:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zTdsNeatDWkLSQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Nov 2025 08:29:26 +0000
Message-ID: <b8631995-a3df-4232-9f89-514d7a502bc0@suse.de>
Date: Fri, 7 Nov 2025 09:29:26 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] fnic: make interrupt mode configurable
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
 Hannes Reinecke <hare@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
 "Satish Kharat (satishkh)" <satishkh@cisco.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-5-hare@kernel.org>
 <SJ0PR11MB5896BDD3102F17EA15356C95C3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <SJ0PR11MB5896BDD3102F17EA15356C95C3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 11/6/25 23:09, Karan Tilak Kumar (kartilak) wrote:
> 
> Cisco Confidential
> On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke <hare@kernel.org> wrote:
>>
>> In some environments (eg kdump) not all CPUs are online, so the MQ
>> mapping might be resulting in an invalid layout. So make the interrupt
>> mode settable via an 'fnic_intr_mode' module parameter and switch
>> to INTx if the 'reset_devices' kernel parameter is specified.
>>
>> Signed-off-by: Hannes Reinecke <hare@kernel.org>
>> ---
>> drivers/scsi/fnic/fnic.h      |  2 +-
>> drivers/scsi/fnic/fnic_isr.c  | 13 +++++++++----
>> drivers/scsi/fnic/fnic_main.c | 10 +++++++++-
>> 3 files changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
>> index 1199d701c3f5..c679283955e9 100644
>> --- a/drivers/scsi/fnic/fnic.h
>> +++ b/drivers/scsi/fnic/fnic.h
>> @@ -484,7 +484,7 @@ extern struct workqueue_struct *fnic_fip_queue;
>> extern const struct attribute_group *fnic_host_groups[];
>>
>> void fnic_clear_intr_mode(struct fnic *fnic);
>> -int fnic_set_intr_mode(struct fnic *fnic);
>> +int fnic_set_intr_mode(struct fnic *fnic, unsigned int mode);
>> int fnic_set_intr_mode_msix(struct fnic *fnic);
>> void fnic_free_intr(struct fnic *fnic);
>> int fnic_request_intr(struct fnic *fnic);
>> diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
>> index e16b76d537e8..b6594ad064ca 100644
>> --- a/drivers/scsi/fnic/fnic_isr.c
>> +++ b/drivers/scsi/fnic/fnic_isr.c
>> @@ -319,20 +319,25 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
>> return 1;
>> }
>>
>> -int fnic_set_intr_mode(struct fnic *fnic)
>> +int fnic_set_intr_mode(struct fnic *fnic, unsigned int intr_mode)
>> {
>> int ret_status = 0;
>>
>> /*
>> * Set interrupt mode (INTx, MSI, MSI-X) depending
>> * system capabilities.
>> -      *
>> +      */
>> +     if (intr_mode != VNIC_DEV_INTR_MODE_MSIX)
>> +             goto try_msi;
>> +     /*
>> * Try MSI-X first
>> */
>> ret_status = fnic_set_intr_mode_msix(fnic);
>> if (ret_status == 0)
>> return ret_status;
>> -
>> +try_msi:
>> +     if (intr_mode != VNIC_DEV_INTR_MODE_MSI)
>> +             goto try_intx;
>> /*
>> * Next try MSI
>> * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 1 INTR
>> @@ -358,7 +363,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
>>
>> return 0;
>> }
>> -
>> +try_intx:
>> /*
>> * Next try INTx
>> * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 3 INTRs
>> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
>> index 870b265be41a..4bdd55958f59 100644
>> --- a/drivers/scsi/fnic/fnic_main.c
>> +++ b/drivers/scsi/fnic/fnic_main.c
>> @@ -97,6 +97,10 @@ module_param(pc_rscn_handling_feature_flag, uint, 0644);
>> MODULE_PARM_DESC(pc_rscn_handling_feature_flag,
>> "PCRSCN handling (0 for none. 1 to handle PCRSCN (default))");
>>
>> +static unsigned int fnic_intr_mode = VNIC_DEV_INTR_MODE_MSIX;
>> +module_param(fnic_intr_mode, uint, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(fnic_intr_mode, "Interrupt mode, 1 = INTx, 2 = MSI, 3 = MSIx (default: 3)");
> 
> Based on fnic team's review: there is a way to choose the interrupt mode using the UCS management platform.
> We do not want to expose this as a module parameter.
> 
Yeah, I know. It was primarily used during testing to easily change 
between the various modes.
I can drop it for the next round.

>> struct workqueue_struct *reset_fnic_work_queue;
>> struct workqueue_struct *fnic_fip_queue;
>>
>> @@ -869,7 +873,11 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>
>> fnic_get_res_counts(fnic);
>>
>> -     err = fnic_set_intr_mode(fnic);
>> +     /* Override interrupt selection during kdump */
>> +     if (reset_devices)
>> +             fnic_intr_mode = VNIC_DEV_INTR_MODE_INTX;
>> +
>> +     err = fnic_set_intr_mode(fnic, fnic_intr_mode);
>> if (err) {
>> dev_err(&fnic->pdev->dev, "Failed to set intr mode, "
>> "aborting.\n");
>> --
>> 2.43.0
>>
>>
> 
> Thanks for these changes, Hannes.
> For the other changes in this patch, I will need to test and get back to you.
> 

Thanks.
The 'reset_devices' thing is primarily there for kdump; might be an idea 
to make is explicit by using 'is_kdump_kernel()' directly.

Cheers,

Hannes

-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
