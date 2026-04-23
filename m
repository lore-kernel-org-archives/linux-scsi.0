Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F180835B632
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 09:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776937531; cv=none; b=SV0IqewGA14T+AMyRuhE3Xjj3fepFyeIS6CTBFPBuMARyYMa3Ie2ECdVpECDdIwpwRemsRXlKGQh7xm5+2FTs45fZuGZQv7ZBs/aj4E7ZcOnksdeqhI9E87BMCsyJOvQIrZpM59vQAr9s0XptUpmPT9cUOZq9IbTC+zPouLrT48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776937531; c=relaxed/simple;
	bh=J8ZIgR2/NW0ODjwfWr/w4gfzhedZCqKurHbY03F2JJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NssyRd3bJfhMjmxbwWkGnNc9o0TXuBloLd+i/N2OV+kxvcJJYE8VieMiGHTKFPHafOQX6yEXQBEgb/20/7HuxZHWtmnvMcc7T8hq7NSMLhFXWvIuqsMTA/DSKD/nhm6iYnmchg46O8YfVIFgf3bmmS0cJyfuCUW28JgSHutEwck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eHKMKZG8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vrjMe1rZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eHKMKZG8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vrjMe1rZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eHKMKZG8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vrjMe1rZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eHKMKZG8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vrjMe1rZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4AFF55BD44;
	Thu, 23 Apr 2026 09:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776937528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJGsmZUi7Cvl/Tdjv3Mfq1vJDVPKxLIEmZ1qR8Rb9/c=;
	b=eHKMKZG8/SG19CZBSlft22VQDiPnahm5Gilt3odDD+AGkqMqeTy4KHEVlywXaiC03P3CJy
	AlkBdr2q2C/3GExnU3kY1eoQfSG/G48StKVaUTR5mb0mf56c5D1F5Ls307NvwOPYRSWBc1
	Txhzh4Z7MUgBDtUbJDhRHdhH+oGMHhc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776937528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJGsmZUi7Cvl/Tdjv3Mfq1vJDVPKxLIEmZ1qR8Rb9/c=;
	b=vrjMe1rZsjCSai9WFOtBtQcDBgbK5jTvarexj6GhJDCeY5rRQ/u/GekFHrsZvhZRQNYk0p
	SP8binAVmmbH1iBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776937528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJGsmZUi7Cvl/Tdjv3Mfq1vJDVPKxLIEmZ1qR8Rb9/c=;
	b=eHKMKZG8/SG19CZBSlft22VQDiPnahm5Gilt3odDD+AGkqMqeTy4KHEVlywXaiC03P3CJy
	AlkBdr2q2C/3GExnU3kY1eoQfSG/G48StKVaUTR5mb0mf56c5D1F5Ls307NvwOPYRSWBc1
	Txhzh4Z7MUgBDtUbJDhRHdhH+oGMHhc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776937528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJGsmZUi7Cvl/Tdjv3Mfq1vJDVPKxLIEmZ1qR8Rb9/c=;
	b=vrjMe1rZsjCSai9WFOtBtQcDBgbK5jTvarexj6GhJDCeY5rRQ/u/GekFHrsZvhZRQNYk0p
	SP8binAVmmbH1iBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2285C593A3;
	Thu, 23 Apr 2026 09:45:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r8D9Bzjq6Wl+QwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 23 Apr 2026 09:45:28 +0000
Message-ID: <9ce439b8-4e56-4a8c-8ef9-d8d9e93ab77a@suse.de>
Date: Thu, 23 Apr 2026 11:45:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] scsi: Support devices that don't have a cmd_per_lun
 limit
To: Mike Christie <michael.christie@oracle.com>,
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
 mst@redhat.com, pbonzini@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260420173352.GB405461@fedora>
 <603eee86-9914-4ac8-b937-a38922e69a45@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <603eee86-9914-4ac8-b937-a38922e69a45@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 4/22/26 20:05, Mike Christie wrote:
> On 4/20/26 12:33 PM, Stefan Hajnoczi wrote:
>> On Fri, Apr 17, 2026 at 05:57:20PM -0500, Mike Christie wrote:
>>> The following patches were made over Linus's and Martin's 7.1 trees.
>>> They fix an issue where for virtio-scsi we export a lot of non-scsi
>>> devices but are getting throttled by the cmd_per_lun_limit too early.
>>> For example we export 1 or more NVMe or block devices and would like
>>> to just pass command to them in way where virtio-scsi's hw queue
>>> limits match the physical hardware. Or in some cases we are doing
>>> cgroup based throttling on the host side, and we don't want the guest
>>> to block IO when the host knows we have extra bandwidth.
>>>
>>> The patches add a new cmd_per_lun value so drivers can indicate
>>> when to avoid tracking queueing at the device wide level. They
>>> then rely on just the block layer hw queue limits. And the patches
>>> convert virtio-scsi. They also fix some can_queue related issues
>>> discovered while testing/reviewing.
>>
>> Hi Mike,
>> Is there a difference between setting cmd_per_lun to U32_MAX with your
>> patches versus setting cmd_per_lun to the virtqueue size without your
>> patches (this can already be done today without code changes in the
>> driver)?
> 
> The problem today is that cmd_per_lun doesn't take into account the
> multiqueue queues (virtqueues in virtio) so we have a low limit of 1024
> commands total. On a 32-128 vCPU VM we can easily hit that as there's
> lots of IO submission threads spread over lots of those CPUs. CPUs are
> then mapped to block mq queues which are mapped to virtqueues so we are
> hitting them hard.
> 
> That 1024 value comes from QEMU which limits virtqueue_size to 1024.
> We could increase that to 4096 or 32K or whatever. The problem is that
> we would then be wasting a lot of memory as we would be allocating lots
> of really large virtqueues that would go underutilized (we are submitting
> 10s of thousands of total IOs but not to just a single queue).
> 
> So a possibly good balance between not having to use a magic number
> (U32_MAX) plus having to update the spec would be to:
> 
> 1. Fix up scsi-ml and virtio-scsi so they allow cmd_per_lun to be
> greater than can_queue (virtqueue_size for virtio-scsi).
> 
> 2. Increase the scsi-ml cap cmd_per_lun cap from 4096 to S16_MAX
> (scsi-ml uses a short for cmd_per_lun).
> 
> The only drawback to this would be that for each scsi_device we track
> running IO with a sbitmap. For my cases, we don't need it, so it would
> be a waste of memory. For a S16_MAX worth of commands I think it would
> be 128K wasted so not too bad for us as we don't have lots of these
> types of high perf devices per VM.
> 
Ideally I would kill cmd_per_lun.
This really is a poor man's fairness algorithm (sole purpose is to
avoid starvation with many luns), and we really should look at if
we cannot replace it with tagsets.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
