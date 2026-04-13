Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93E82F1FC7
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 08:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776069076; cv=none; b=IsiBESpwPYYJN3y8i88V5XA0hWicJ0l6SEtpqPuF9w0ZbsGEMQ51TGJrXj3RhQ1KJ7JEH4q+Ktxx5Nx9BECWjTiO1PLs9Mdm+aUMbfmgUWBOak2Kwo2pny3cpxbpVlqzQ39B3PPkC7VAP9nZVzZuymLx6Hgflv9LmAzXeh4FV8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776069076; c=relaxed/simple;
	bh=fdkklMCbojnfNiYtw3kGEIgd1ibUE0TSAFYaewur45s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QeWw+vUqp0sfe8Y0umw7W8vrXCmSrAkkUTyCdhJfOYl+mgWPQHlhSmqIHaJptvg3hQClca/9kYD5AioPe3/Im3LoOVxO3tZsYYEQ0NIuI69Q6r3USjvqARpsFyKZMeHwXS9yesDtsN6QJJbyaWN4tRFtLsKFSPMR9iN9qYnxoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RwZLb/8t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EBODtRp6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ljDofN1+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2SZkS9vg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RwZLb/8t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EBODtRp6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ljDofN1+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2SZkS9vg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC6FA5BD98;
	Mon, 13 Apr 2026 08:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776069073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sv8pWDWWoOBrXr74WSnQmH+WSrRD4Yzl1Gmj+wFr/QA=;
	b=RwZLb/8tPG39inTiQ1+PkFtEoCnmDibXlLUE9EQfP21QiS9RtPzVHl6GXQPj7zlcaUWXbp
	k7Rzypl3ZeZpJxMS2agYICCtq6GgCMxIZVx4yWXcSYdP/QEry6FsqgrdptuxM29CuCe5+1
	cFvUZybdenmePIQHKg9449ocQ1KZ0uM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776069073;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sv8pWDWWoOBrXr74WSnQmH+WSrRD4Yzl1Gmj+wFr/QA=;
	b=EBODtRp62wm3tMg6+KM8NC3MSB4FM0UtR3iRXjNHJUSzM4nX3Y1W0FUc9R6kHfeYs9Koho
	THeHIijoIFNyVFAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ljDofN1+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2SZkS9vg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776069072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sv8pWDWWoOBrXr74WSnQmH+WSrRD4Yzl1Gmj+wFr/QA=;
	b=ljDofN1+Pb2DFUHC6mucqxuDJ9loBSOOP8Hfvln+kZtkiXLoQ5EMbvhSjE11S3AgqgB/Im
	bnwPpdQ9DHlPQZ4qRFdRkfF1cu1bEsK+k3D7/Dw4R6kvdpJHQi6Olm+RWgHvJpj1aDLDO0
	zKkE31s+ltozxRfTxpciLnrb/UwTeRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776069072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sv8pWDWWoOBrXr74WSnQmH+WSrRD4Yzl1Gmj+wFr/QA=;
	b=2SZkS9vgXP/o/o1DS/NIDXxp+nI1uxpgo8SKp6pzTTuKZhZoOFRkNEMKqoi+sMfQjHfMwx
	KO9czEu2NRrz/VDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9279E4ADBC;
	Mon, 13 Apr 2026 08:31:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 24caItCp3GnjEgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Apr 2026 08:31:12 +0000
Message-ID: <ba5e3570-ec42-4642-9dbe-2344a72adcff@suse.de>
Date: Mon, 13 Apr 2026 10:31:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ata: libata-scsi: enable multi-LUN support for ATAPI
 devices
To: Phil Pemberton <philpem@philpem.me.uk>,
 Damien Le Moal <dlemoal@kernel.org>, cassel@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260409210559.155864-1-philpem@philpem.me.uk>
 <20260409210559.155864-3-philpem@philpem.me.uk>
 <c62f11f0-6127-41c6-98c6-cb6794125e70@kernel.org>
 <f57b1b0f-4425-40be-8c8b-437fd609ed46@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <f57b1b0f-4425-40be-8c8b-437fd609ed46@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: DC6FA5BD98
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/12/26 21:40, Phil Pemberton wrote:
> On 12/04/2026 08:38, Damien Le Moal wrote:
>> On 4/9/26 23:05, Phil Pemberton wrote:
>>>    - Raises max_lun from 1 to 8 (matching the SCSI host default).
>>>      Sequential LUN scanning stops at the first non-responding LUN, so
>>>      single-LUN devices are unaffected.
>>
>> If the only case that we can encounter with libata are these special 
>> ATAPI
>> devices with 2 LUNs, I would limit the maximum to 2.
> 
> I'm inclined to agree, but there are devices with higher LUN counts: the 
> Nakamichi CD changers. The MJ-4.4 and MJ-5.16 were available in an ATAPI 
> variant which exposed a LUN for each disc in the changer stack. There's 
> a Cathode Ray Dude video demonstrating the latter.
> 
Don't get too excited. This is ancient technology, with an extremely 
narrow user-base :-)
'Were available' is not identical to 'in current use', and I'm somewhat
disinclined to add support for technology with no users.

> I like the idea of the lower LUN cap for compatibility, but I think I'd 
> hedge bets by also having a module parameter (e.g. libata.atapi_max_lun) 
> to override it. Default 2 seems like a good compromise.
> 
Hmm. I really would like to restrict max lun to 1 (as it somewhat mimics 
the master/slave thingie on IDE). But higher than that really is 
arbitrary; the next sensible limit would be '7', as this is what SCSI-2
could handle. I completely fail to see the motivation to have a limit
somewhere in between.

> In any case, the BLIST_FORCELUN gate should limit things to one LUN for 
> any device which isn't on the device list.
> 
> 
>>>    - ata_scsi_dev_config() previously assigned dev->sdev = sdev for 
>>> every
>>>      LUN configured.  With multiple LUNs sharing one ata_device, this
>>>      caused dev->sdev to be overwritten by each non-LUN-0 sdev.  
>>> Restrict
>>>      the assignment to LUN 0 so that dev->sdev always tracks the
>>>      canonical scsi_device for the underlying ATA device.
>>
>> Special casing this does not seem nice at all. Why not simply 
>> increasing the
>> sdev reference count when it is assigned to a LUN that is not LUN 0 ? 
>> And drop
>> that reference when the LUN is torn down ? That will remove any 
>> dependency on
>> the order in which LUNs are torn down too.
> 
> The if (sdev->lun == 0) guard isn't about teardown ordering; it's about 
> which device dev->sdev points at.
> 
> dev->sdev is a single pointer, but with multi-LUN ATAPI there are now 
> multiple sdevs sharing one ata_device. Without the guard, each call to 
> ata_scsi_dev_config() overwrites the pointer, so it ends up tracking the 
> last-configured LUN (likely the highest-numbered one).
> 
And how would you address the 'sdev' of LUN 1?
(and how of LUN 2, if we decide to have one?)

Please, don't. The correct way would be to convert 'dev->sdev' into
a list.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
