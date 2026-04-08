Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C11C3D6CC1
	for <linux-scsi@vger.kernel.org>; Wed,  8 Apr 2026 15:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775662919; cv=none; b=kMsI9nyHUmAI9C8LWtxFpznPkOflJN8B8ltJW2RUxL3Kd/NnzaocxpX9lF80Fd1XG9xPTBWDFp1q9isMz0WX9s6lKmumpPmg26Hd8a0idgyf5Zr8uivwT+217421ILjbfgTfjO5sfXuXXRaeXJJwBMK8KHLto3MP6U1Drj4cCog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775662919; c=relaxed/simple;
	bh=4c7twZ8nDsMKlUk06bspsNbt/cmWWBpiiX5UEfOs9+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsMPc02XU1b/o1HinXeRm6sQtyF066ymmZjdFOcRR+EWyWbYJrR1lKqMJ1wRSqNOh1m7LKrwLyGcAcZme0G9+R8Bgsdn2JzRICGncC3zGRoNSatiVhHmBMxkQp9TONgOv7jqbX1dNv95N7DYRX+h6KaW24yA6uli9JVVvlV+UPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k2eayePs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8sYiXysc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=evDDdQQU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9JxmCYKv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k2eayePs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8sYiXysc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="evDDdQQU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9JxmCYKv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7FD735BCC1;
	Wed,  8 Apr 2026 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775662914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKz9ql1CuufnhSBLMjDpQRkRbaUAZqr1/g/ZA3DBTWw=;
	b=k2eayePsHN24KrTjLlCi/sepoKdrvZMmCAWNSV5B/EVM1NaGqcVr9U+Fx7uuc/MyriKh3J
	oA+f7SrTfq8cpi97GLJ5d306ERvI53w/zYdLyoA4NyXVKEpCnCPd2aLpmDuljC61lMxXwW
	JORaa+6wSIhaEPpb8rhfhEj1fEC7bnY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775662914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKz9ql1CuufnhSBLMjDpQRkRbaUAZqr1/g/ZA3DBTWw=;
	b=8sYiXysct9640fyxm/Z720qfo//fRhVg378J9Ss51JZWv8qBL+/nILYpgw3tt9CtxHxkKj
	yusr4T/EBb2djSDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=evDDdQQU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9JxmCYKv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775662913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKz9ql1CuufnhSBLMjDpQRkRbaUAZqr1/g/ZA3DBTWw=;
	b=evDDdQQUr9qwYu/74zTru1hTH+ZokQBQeyOc6WIphRZghh5G4oZQDxW7Y39HHBt9emzcmM
	VMifsQyBFe34i7ul6SzTbF4ersDGQGaix0Yt3+rhJDJyasBYrMAHi+mfp5O8UU0yXUYXbN
	6hQGb5q5Q7zZsosgh0JDHp6Yy8HZgLE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775662913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKz9ql1CuufnhSBLMjDpQRkRbaUAZqr1/g/ZA3DBTWw=;
	b=9JxmCYKvCChP9i0KLYQTHAEJA3G21j/Vq1vltfHDI7QisB/a0Yr/5k87FWwVH/3e7TUVIf
	XAUE3eNQASo7EsDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EDDA4A0B3;
	Wed,  8 Apr 2026 15:41:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dKW5ET131mm2MQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 08 Apr 2026 15:41:49 +0000
Message-ID: <6d7a4076-a4ad-4185-8e82-8e27d704d20e@suse.de>
Date: Wed, 8 Apr 2026 17:41:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: John Garry <john.g.garry@oracle.com>, Nilay Shroff <nilay@linux.ibm.com>,
 hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
 <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7FD735BCC1

On 4/8/26 13:28, John Garry wrote:
> On 02/03/2026 12:41, Nilay Shroff wrote:
>>> +
>>>   void mpath_add_sysfs_link(struct mpath_disk *mpath_disk)
>>>   {
>>>       struct mpath_head *mpath_head = mpath_disk->mpath_head;
>>> @@ -793,6 +868,8 @@ struct mpath_head *mpath_alloc_head(void)
>>>       mutex_init(&mpath_head->lock);
>>>       kref_init(&mpath_head->ref);
>>> +    mpath_head->delayed_removal_secs = 0;
>>> +
>>>       INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
>>>       spin_lock_init(&mpath_head->requeue_lock);
>>>       bio_list_init(&mpath_head->requeue_list);
>>
>> I think we also need to initialize ->drv_module here.
> 
> Hi Nilay,
> 
> I am just coming back to this now. About NVMe multipath delayed disk 
> removal, did you consider a blktests testcase to cover it? I might look 
> at it if I have a chance (and it makes sense to do so).
> 

That look patently like the 'queue_if_no_path' feature from 
dm-multipath. Any chance of reconciling these two?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
