Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCAF19067C
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 10:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759748355; cv=none; b=JCyfsYOBnXfoHSHmkQJxJ7waWPNuTL0nvfTfvJHfemDDWWd43KEzKp7PRvaptUSx6rsdiNHjhtlhC+h9RiIZaChCuyNpY5yl6jWy8TOWutoeEDjey4hYFUK8ePO4mh4yM65T+tuVRW6OaPiZoTqOphw8I9EaZkzkoGMaBszd9js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759748355; c=relaxed/simple;
	bh=+RUBAmDErk4fvy3Gbg9TmzJRafEDJjzTwg1Igtn3RO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cpXmnCj2iC7rEnstFLFtSS8zvSCGV0qRD8YQ5V+Pc6njV32IbMH+aJuzpMWMPBydeWGFEDeqdWsUQrYhOEp38llvbKlGX2MrvBtnFpDDxdpCxje7mor/kTTEDbaD8eBu1FMULiJuU5dY5NyPGcuOHA7whjOJ9wuJOvhkj6i4FOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iTQqU5vu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wNJUG+NF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eRMglbfz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uzxHbO9X; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iTQqU5vu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wNJUG+NF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eRMglbfz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uzxHbO9X"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1464B336BD;
	Mon,  6 Oct 2025 10:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759748351; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zEqzQtyAb34tsvnWDp033ujz/p1iGyt+rLmgkUdbLMg=;
	b=iTQqU5vuut/oqBByTLOUeberHxdI1GYrPYaVxJGlwYVPkytpw19OU1JcIS3y5Xpkx5EpN3
	vQb9eUwH0PG1tbBUMvcNLMN9BAx8BIaQxHKoJjh6t8fnEg1dCUPsq7lsuRtUjNEUbtVDAK
	KzCtKnqIKIdheBYL3yonDW87IfJV+D4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759748351;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zEqzQtyAb34tsvnWDp033ujz/p1iGyt+rLmgkUdbLMg=;
	b=wNJUG+NFk4v5538+9aX9eNy8/hFkO0okxqyaTo7vocePXn/+1G24HbtFtzvZ96MtM1UMyK
	pTiDWYvZwAUt9CDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759748350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zEqzQtyAb34tsvnWDp033ujz/p1iGyt+rLmgkUdbLMg=;
	b=eRMglbfzjrE0/oduHFp2YxOmBOZslIj9Z/qRh41vHqvtnYYq/WHwY4p8TnAY8VUMotXMSn
	qq/ZqyAFqgtkKpCSNy80JZodrABpQP5Kln+E5NgZ7HaIQjt7ikDOz/w43HadO9uxaAUBE5
	AF/B6vp/sdAtxUgpCMRHDmCjgkYPxIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759748350;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zEqzQtyAb34tsvnWDp033ujz/p1iGyt+rLmgkUdbLMg=;
	b=uzxHbO9XNwlmsRTsEMLz3+zAFH2hAxSfSlwDH0UqoZAGvnjT/CWGNfwFxsW6XcJPPotWu5
	X6a8sdzfllMidvBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F404413995;
	Mon,  6 Oct 2025 10:59:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aDUmO/2g42jmWgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 10:59:09 +0000
Message-ID: <ce4171ee-4464-41ef-8879-e62bdfe5ee02@suse.de>
Date: Mon, 6 Oct 2025 12:59:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/9] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: Damien Le Moal <dlemoal@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>,
 linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-7-emilne@redhat.com>
 <915d81dc-eb77-4b8d-aca8-636f1a41a1e7@suse.de>
 <4e014835-9022-442f-a80f-a0276ed3beda@kernel.org>
 <3c507002-7476-434e-8abf-f872611548d9@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <3c507002-7476-434e-8abf-f872611548d9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 10/6/25 09:25, Damien Le Moal wrote:
> On 10/6/25 16:20, Damien Le Moal wrote:
>> On 10/6/25 16:10, Hannes Reinecke wrote:
>>>> -	memset(buffer, 0, 8);
>>>> +	for (count = 0; count < 3; ++count) {
>>>> +		memset(buffer, 0, RC10_LEN);
>>>> +
>>>> +		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
>>>> +					      buffer, RC10_LEN, SD_TIMEOUT,
>>>> +					      sdkp->max_retries, &exec_args);
>>>> +
>>>> +		if (the_result || resid != RC10_LEN)
>>>> +			break;
>>>>    
>>> Hmm. What would happen if some data is returned, but less than the
>>> expected amount?
>>> We'd be having a hard time parsing that, wouldn't we?
>>
>> All data received would normally mean success, so result == 0.
>> Bad devices cases would be success with resid != 0 but less than RC10_LEN. So I
>> think the break is correct here since the result is checked after the loop.
> 
> Arg, no, bad device may return sucees with resid != 0... So yeah, together with
> the below change, this should probably be:
> 
> 	if (the_result || resid)
> 		break;
> 

Precisely what I tried to suggest :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
