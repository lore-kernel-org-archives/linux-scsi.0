Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76E525632;
	Thu, 13 Jun 2024 06:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718260069; cv=none; b=XnhGfBz9/NzQFj1w4sZAt1T3Vrm27RQkvO2UdANvVr+LU47TUvo6W7YxJFP5voutkU0aqkJxcY9tHFAKUDt7mG8BZEFH5yCXamLVIcBILxbz31dSUrd6I8PLFppIHg11MjkuX4jKjsSAj2FG2ap3ljDEdXy9n1aH6+UX6AdQYpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718260069; c=relaxed/simple;
	bh=8N05ZrcYdaSdzJIVWtXezJaBbiufobkZ7bPvBszzLLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qynlrRLB1Oar8VVuFCmvrgb2XD7H8huZfKsZZQg8n5m8Ulqx1umwkBTOZGz9ubJf2oiXymtQJeppE5lMDH+i4h0vkrFkT0tqaP8wISPVfHuoqNyVAM573Ed315Rq7lq9POHQaNGXysgJepddTEFqgJdDHu6VFBH6gz+NwacgpcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OLA4ctHp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=D2iIflGZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zrHpMIUm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+c2cjqe6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OLA4ctHp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="D2iIflGZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zrHpMIUm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+c2cjqe6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E4D715CE74;
	Thu, 13 Jun 2024 06:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718260059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElbTrtHcGPLHtNQdT2BSZs64OtL7aUUhrtyxF38Z6KQ=;
	b=OLA4ctHpMgVsIY7659Y2TmEStR5QeQOwX6DN1SZDPndHu5LaCG9bobx7w0gpMVaZxOBdGx
	38NnCGbw3Wk6VPbLyRi1cqzRt0DI+vjcQnFjJIPe+jgB/YWGalTQ9OzP8LVX0fqeTxR6Da
	Uw9L6MGOhDp+lZIJmU7Tz/WNljG5ieM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718260059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElbTrtHcGPLHtNQdT2BSZs64OtL7aUUhrtyxF38Z6KQ=;
	b=D2iIflGZ9kr/E8yoo8qNacU5cTyGMS2M3hMxo5rVnfEh+Mn4tDchFBVyTXiW3MMaeBsz0R
	UXUShF5xZIuc0FAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zrHpMIUm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+c2cjqe6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718260058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElbTrtHcGPLHtNQdT2BSZs64OtL7aUUhrtyxF38Z6KQ=;
	b=zrHpMIUm55G0aZmocdojO82sY1ePqvptEYjWoiC/N0e0wBWzWkw3SU59pVrCoyWtoFgHnL
	VJwiym/BtbcOi6dpOEGu10OeAnKd7IvsZ+US49+34dxbogNUkznqtI9tBW/Hf1S98OcbFK
	6aTh7N8mx1/qZ1uq7qu0459yntn4hkU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718260058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElbTrtHcGPLHtNQdT2BSZs64OtL7aUUhrtyxF38Z6KQ=;
	b=+c2cjqe6JRcTiONrzEPsSzsr/FhSDoBuT+sgDjY4LDIKSp7ykXyw+5t8XC5qSNAplblSmq
	k+EOksE770AQxDAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEB4213A7F;
	Thu, 13 Jun 2024 06:27:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8XdsKFqRambWNwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 13 Jun 2024 06:27:38 +0000
Message-ID: <698d4b22-719c-4e57-94ed-f507e425ee12@suse.de>
Date: Thu, 13 Jun 2024 08:27:38 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] scsi: core: Add new helper to iterate all devices
 of host
Content-Language: en-US
To: Wenchao Hao <haowenchao22@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
 <20240605091731.3111195-2-haowenchao22@gmail.com>
 <3b24ef4a-996b-4a8b-89f3-385872573039@suse.de>
 <c1ecd21b-7b97-4ef6-94a1-86b2cf520a67@gmail.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <c1ecd21b-7b97-4ef6-94a1-86b2cf520a67@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,HansenPartnership.com,oracle.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E4D715CE74
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Spam-Level: 

On 6/12/24 17:06, Wenchao Hao wrote:
> On 6/12/24 4:33 PM, Hannes Reinecke wrote:
>> On 6/5/24 11:17, Wenchao Hao wrote:
>>> shost_for_each_device() would skip devices which is in SDEV_CANCEL or
>>> SDEV_DEL state, for some scenarios, we donot want to skip these devices,
>>> so add a new macro shost_for_each_device_include_deleted() to handle it.
>>>
>>> Following changes are introduced:
>>>
>>> 1. Rework scsi_device_get(), add new helper __scsi_device_get() which
>>>      determine if skip deleted scsi_device by parameter "skip_deleted".
>>> 2. Add new parameter "skip_deleted" to __scsi_iterate_devices() which
>>>      is used when calling __scsi_device_get()
>>> 3. Update shost_for_each_device() to call __scsi_iterate_devices() with
>>>      "skip_deleted" true
>>> 4. Add new macro shost_for_each_device_include_deleted() which call
>>>      __scsi_iterate_devices() with "skip_deleted" false
>>>
>>> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
>>> ---
>>>    drivers/scsi/scsi.c        | 46 ++++++++++++++++++++++++++------------
>>>    include/scsi/scsi_device.h | 25 ++++++++++++++++++---
>>>    2 files changed, 54 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>> index 3e0c0381277a..5913de543d93 100644
>>> --- a/drivers/scsi/scsi.c
>>> +++ b/drivers/scsi/scsi.c
>>> @@ -735,20 +735,18 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
>>>        return 0;
>>>    }
>>>    -/**
>>> - * scsi_device_get  -  get an additional reference to a scsi_device
>>> +/*
>>> + * __scsi_device_get  -  get an additional reference to a scsi_device
>>>     * @sdev:    device to get a reference to
>>> - *
>>> - * Description: Gets a reference to the scsi_device and increments the use count
>>> - * of the underlying LLDD module.  You must hold host_lock of the
>>> - * parent Scsi_Host or already have a reference when calling this.
>>> - *
>>> - * This will fail if a device is deleted or cancelled, or when the LLD module
>>> - * is in the process of being unloaded.
>>> + * @skip_deleted: when true, would return failed if device is deleted
>>>     */
>>> -int scsi_device_get(struct scsi_device *sdev)
>>> +static int __scsi_device_get(struct scsi_device *sdev, bool skip_deleted)
>>>    {
>>> -    if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
>>> +    /*
>>> +     * if skip_deleted is true and device is in removing, return failed
>>> +     */
>>> +    if (skip_deleted &&
>>> +        (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL))
>>>            goto fail;
>>
>> Nack.
>> SDEV_DEL means the device is about to be deleted, so we _must not_ access it at all.
>>
> 
> Sorry I added SDEV_DEL here at hand without understanding what it means.
> Actually, just include scsi_device which is in SDEV_CANCEL would fix the
> issues I described.
> 
> The issues are because device removing concurrent with error handle.
> Normally, error handle would not be triggered when scsi_device is in
> SDEV_DEL. Below is my analysis, if it is wrong, please correct me.
> 
> If there are scsi_cmnd remain unfinished when removing scsi_device,
> the removing process would waiting for all commands to be finished.
> If commands error happened and trigger error handle, the removing
> process would be blocked until error handle finished, because
> __scsi_remove_device called  del_gendisk() which would wait all
> requests to be finished. So now scsi_device is in SDEV_CANCEL.
> 
> If the scsi_device is already in SDEV_DEL, then no scsi_cmnd has been
> dispatched to this scsi_device, then error handle would never triggered.
> 
> I want to change the new function __scsi_device_get() as following,
> please help to review.
> 
> /*
>   * __scsi_device_get  -  get an additional reference to a scsi_device
>   * @sdev:	device to get a reference to
>   * @skip_canceled: when true, would return failed if device is deleted
>   */
> static int __scsi_device_get(struct scsi_device *sdev, bool skip_canceled)
> {
> 	/*
> 	 * if skip_canceled is true and device is in removing, return failed
> 	 */
> 	if (sdev->sdev_state == SDEV_DEL ||
> 	    (sdev->sdev_state == SDEV_CANCEL && skip_canceled))
> 		goto fail;
> 	if (!try_module_get(sdev->host->hostt->module))
> 		goto fail;
> 	if (!get_device(&sdev->sdev_gendev))
> 		goto fail_put_module;
> 	return 0;
> 
> fail_put_module:
> 	module_put(sdev->host->hostt->module);
> fail:
> 	return -ENXIO;
> }
> 
I don't think that's required.
With your above analysis, wouldn't the problem be solved with:

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 775df00021e4..911fcfa80d69 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1470,6 +1470,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
         if (sdev->sdev_state == SDEV_DEL)
                 return;

+       scsi_block_when_processing_errors(sdev);
+
         if (sdev->is_visible) {
                 /*
                  * If scsi_internal_target_block() is running concurrently,

Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

