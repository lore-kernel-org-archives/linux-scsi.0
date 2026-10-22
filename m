Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792670180;
	b=NhHoKz2GTSbhLzrl1Ej3GsxGzOJGgugBubJSgHDqSreDLsGOOdwZxH9N2iewCUv3Ypjr
	 M9GL1eoTezu+FcZ8MD8DDqz1MU1UqPqKheNBNnmBFO4urMzm2ozKw64NKK6sqfjHv+vER
	 a2eIJDoIGlj/+EGBdh27GLonwxaH33BbXBqfj1QuIyz/BS+Dh+XR1z5d7ZFY/nML9V/KT
	 pB4VU71nr81LGI5YVuoOPl+JuqDdncATngk+cx7wqS0ywSiSmOVXocH+45j7T+x0VbGaE
	 vf3BBZPpHImYEWfn0M7yPkyH4leJeOvdejN/Lbys/LxFIBgnyvYQSBqbuSq2ahQV01A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792670180;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=BL3OkK7DxS1S8u+YHgvGJrrdiAib0lWqASpKeGzjVec=;
	b=vN0pLvaVqSh82BMyo7vbSjVvhYIyaYxQwPUR/WJOdf7xKRrUgkaXsGhHwzrgMnVkD4Kc
	 I1Nzb6ybNr7JTTf3sRR+kNEb92Rn+coJHOc0ukdhltPhfyrwUFEMpM0U9qyoznYiHmP7f
	 dp8S9abMg5MZWObSqVsFV+qM6H2XiIZGdymNrMEYuHaU92LyfW96JPiLchW5j9G1tLLMk
	 8Tbs5J4YnK8BDdZ1n1fsEnj0mZZZk8nmfR1a7SlGPQfkm58LNO2U8MtEty4EVxtLLQA8T
	 Y/HI1QQUF8g4VkRPvpzD5fS7EjP3lJy5Pxbjvv3Glm8H50u1ofxQB0bLEu9AYvRqJtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=btAu7H9K;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SQlIzuLI;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=btAu7H9K;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SQlIzuLI;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D95606A325
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 11:56:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1D95606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=btAu7H9K;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SQlIzuLI;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=btAu7H9K;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SQlIzuLI
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1D40622163;
	Thu, 22 Oct 2026 11:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792670178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BL3OkK7DxS1S8u+YHgvGJrrdiAib0lWqASpKeGzjVec=;
	b=btAu7H9KsPoQPPoam5cqetxYV0o+BfTzM6FjcLfdgLoxaK5/PbkURsk7fgwLQsL3TaewoP
	u989eKeAq+G3eiMJFh78vsWe9TsX38qovqHoSB5ZDCFvWCG78g/9dekm2nDemWIyogl5D0
	yaNl53mIeCXPGAVUPEGDAfSOkB/n3G8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792670178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BL3OkK7DxS1S8u+YHgvGJrrdiAib0lWqASpKeGzjVec=;
	b=SQlIzuLIALZgmTiUb1BcZNH1jUwh3K9eplPj0qHjVH/Uul8khQgxQ+IPMq5+/UJk5VZNiJ
	yvT6sSlvzuOpbmCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=btAu7H9K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SQlIzuLI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792670178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BL3OkK7DxS1S8u+YHgvGJrrdiAib0lWqASpKeGzjVec=;
	b=btAu7H9KsPoQPPoam5cqetxYV0o+BfTzM6FjcLfdgLoxaK5/PbkURsk7fgwLQsL3TaewoP
	u989eKeAq+G3eiMJFh78vsWe9TsX38qovqHoSB5ZDCFvWCG78g/9dekm2nDemWIyogl5D0
	yaNl53mIeCXPGAVUPEGDAfSOkB/n3G8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792670178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BL3OkK7DxS1S8u+YHgvGJrrdiAib0lWqASpKeGzjVec=;
	b=SQlIzuLIALZgmTiUb1BcZNH1jUwh3K9eplPj0qHjVH/Uul8khQgxQ+IPMq5+/UJk5VZNiJ
	yvT6sSlvzuOpbmCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF999133F3;
	Thu, 22 Oct 2026 11:56:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0JPsLuH52WrRCAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 22 Oct 2026 11:56:17 +0000
Message-ID: <524b50e3-cdcf-4cf3-861f-a647a07ae6e8@suse.de>
Date: Thu, 22 Oct 2026 13:56:17 +0200
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
To: Brian Bunker <brian@purestorage.com>, Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James.Bottomley@HansenPartnership.com, krishna.kant@purestorage.com
References: <b4ea3aa9-7db5-4af9-a893-ae2af3c05eed@suse.de>
 <20261021185031.35091-1-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261021185031.35091-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D40622163
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 10/21/26 8:50 PM, Brian Bunker wrote:
> On 10/21/26 12:45 PM, Hannes Reinecke wrote:
>> Aw. The mysteries of SPC. Can't you simply use 'Standby' state?
>> That would not require all this weird rescanning.
> 
> We do use standby today, and have since 2017. That is where the
> trouble is. SPC-4 5.15.2.4.4 says that in standby the device server
> "shall support those of the following commands that it supports while
> in the active/optimized primary target port asymmetric access state",
> and the list includes:
> 
>    l) PERSISTENT RESERVE IN;
>    m) PERSISTENT RESERVE OUT;
> 
> We support persistent reservations in active/optimized, so standby has
> to accept them too. When the link between the two arrays is down, the
> array that has stopped serving the volume can't mirror a reservation
> change to its peer, so it can't accept one without the two arrays
> ending up with different reservation state. Making standby work in
> that situation takes a lot of extra handling on the array. The
> unavailable list in 5.15.2.4.5 has no PR commands, which is exactly
> what this case needs.
> 
> Standby also isn't handled the same way by every host. ESX and AIX,
> for example, don't treat a path as down when RTPG reports it as
> standby; their path checkers keep trying to use it. So we carry
> OS-specific exceptions for how standby is presented to each host type.
> 
> ESX and AIX both handle unavailable. Linux is the one we can't use it
> with today, because of the problem this series addresses. If Linux
> handled it too, unavailable could be the rule for us, and most of the
> OS-specific code and the extra PR handling could go away. That is the
> motivation for doing this in Linux.
> 
> Bart, on Windows: I don't know how current Windows handles
> unavailable. If it still doesn't handle it well, we can keep using
> standby for Windows hosts, but that would be the one exception rather
> than the rule.
> 
>> Weelll ... an 'unavailable' device _never_ comes back.
>> The only chance it had to 'come back' would be to set a UNIT ATTENTION.
>> But that we will only ever see if we send commands to that device,
>> which we don't as it's unavailable ...
> [...]
>> What it the proposed strategy to get it back?
> 
> It depends on whether sd is bound, and after Bart's reply sd will stay
> bound on a running host (I've agreed to drop unbinding; see my reply to
> Bart from earlier today).
> 
>    - A host that was running when the path became unavailable keeps sd
>      bound. This is the case you describe for standby: the multipath
>      map stays intact, multipathd's path checker keeps polling the
>      path, and when the array leaves unavailable the UNIT ATTENTIONs it
>      posts (ALUA state changed, INQUIRY DATA HAS CHANGED) are seen on
>      those polls and the path is reinstated.
> 
>    - A host that scanned while the path was unavailable has no sd on
>      it, so nothing polls it, and you're right that a UNIT ATTENTION
>      alone would never be seen. For that case the array makes the host
>      look again when it leaves unavailable: on iSCSI it sends an
>      asynchronous event with REPORTED LUNS DATA HAS CHANGED, and iscsid
>      rescans each device on the session; on FC it logs out the
>      initiators, and the transport scans the target after the re-login.
>      That rescan is where v9 binds sd.
> 
>> Also we have to worry about the implications for multipathing:
>> If the device is set to 'unavailable' we'll be disconnecting it
>> from multipathing as the 'sd' driver will be detached.
> 
> With unbinding dropped, that no longer happens. A bound path stays in
> the map as a failed path, as it would in standby.
> 
Hmm.
But if you want to have this behaviour it would make sense to modify
scsi_bus_match() to extend to pqual 01b, too; then 'sd' would stay
bound to the scsi device even after rescan, and we wouldn't need
to worry about driver detaching and multipathd becoming inoperational.

>> When do you do the LOGO? When entering the unavaiblable state?
>> Or when resetting it back to normal?
> 
> When leaving unavailable. Entering it, the array only posts INQUIRY
> DATA HAS CHANGED and the ALUA state change; sd is bound and sees them
> on its next command. Leaving it, the array posts both UNIT ATTENTIONs
> and then, on FC, logs out the initiators so that a host with no sd on
> the path rescans.
> 
Ah. That'll explain it.

>> Yes, but that was the point.
>> If reprobe fails, what are you going to do?
>> You cannot 'magically' get it back, as _normally_ you would do a reprobe
>> to get it back. But that failed. So you _really_ need to delete that
>> device and restart from scratch.
> 
> In v9 the reprobe only ever binds a driver to a LU that has none. If
> the bind fails, the device is left in the state it was already in: a
> scsi_device with no ULD, exactly what the scan creates for a PQ = 1 LU.
> Nothing that worked before is lost, and the next rescan the array
> triggers tries again. Deleting the device and scanning from scratch
> would end at the same sd probe, so I'd rather log the failure and leave
> the device for the next rescan than add a removal path.
> 
Which if fine (I think).
But still it might be worthwhile exploring the idea of extending
scsi_bus_match(), as that will solve any ambiguity with 'sd' attaching
to the device.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
