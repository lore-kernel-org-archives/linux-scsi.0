Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403DB37C93A
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776940335; cv=none; b=j4tfDnQy1pCUwW/IQtU3QTCDd6391dDewfx2hpHr3BvxbSpU9D//0sasfQfbpnULoZkbPXauzJCkEF10KH12SzIvSYOeoDCbe7qXYH0D3K7wuVYKhPldlzM3/CwYA6afyoA4Or7UdHZffJ1E1C4vLz9Fu+8k11h+erhPNb42cqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776940335; c=relaxed/simple;
	bh=jazL6SWfXa88LqvnS25KHp16ujLSD+9oZjDHoEXpKfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WZPRfb9Mtunz+Dd1uoLVCUtVgERF6z0x2v3dIZoh0NrMDL+GYMep50DM6Gf1jJ2raj0kgMQ/6Qi9eUQVt8+4TkeY9fA2jLingr8WCUkJ5+FI6TeUlBXtjRcDdtyFegI/i/0Vb1WVY1sAVOqlZswBUozrHZn+9KxcEBYhI5lqVww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qMUWITHh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F6nw+bkv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qMUWITHh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F6nw+bkv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qMUWITHh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F6nw+bkv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qMUWITHh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F6nw+bkv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 717E66A83A;
	Thu, 23 Apr 2026 10:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776940327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Y1CelddMwmsUPtrfyGtDqdrxRTsmdur6hdG7YN2XVo=;
	b=qMUWITHhDmGglclsDUzjlEWci3asJjzOj9u6m+2L2hsezB+cEF9SoI5ivhg9UxcpBsbvli
	w8nULU+QabqvM65qJmZZvJwXDnXOQgi7OGITH4Hj5/VVEW2LLaA4kye4eQLO6qxmd01DUZ
	buT/9kDquhJUv5+3mTD2hMpumpgHLD8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776940327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Y1CelddMwmsUPtrfyGtDqdrxRTsmdur6hdG7YN2XVo=;
	b=F6nw+bkvE9dgklUyjLgbPExq7QEwxM/IeiJrTVb5MPTmAIFSCBP92ZFECK0Xx+zGbdAm4o
	9snjovgT91qdraBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776940327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Y1CelddMwmsUPtrfyGtDqdrxRTsmdur6hdG7YN2XVo=;
	b=qMUWITHhDmGglclsDUzjlEWci3asJjzOj9u6m+2L2hsezB+cEF9SoI5ivhg9UxcpBsbvli
	w8nULU+QabqvM65qJmZZvJwXDnXOQgi7OGITH4Hj5/VVEW2LLaA4kye4eQLO6qxmd01DUZ
	buT/9kDquhJUv5+3mTD2hMpumpgHLD8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776940327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Y1CelddMwmsUPtrfyGtDqdrxRTsmdur6hdG7YN2XVo=;
	b=F6nw+bkvE9dgklUyjLgbPExq7QEwxM/IeiJrTVb5MPTmAIFSCBP92ZFECK0Xx+zGbdAm4o
	9snjovgT91qdraBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 326B04B327;
	Thu, 23 Apr 2026 10:32:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n5PJCyf16WnWdAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 23 Apr 2026 10:32:07 +0000
Message-ID: <3c57a174-ce83-43cd-a46b-d0eea752deda@suse.de>
Date: Thu, 23 Apr 2026 12:32:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: Support scsi_devices without a device wide
 limit
To: John Garry <john.g.garry@oracle.com>,
 Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
 stefanha@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-4-michael.christie@oracle.com>
 <448302b1-3950-4e6d-ae8b-337cad09f3fe@suse.de>
 <65e78d0c-23a5-4702-9946-60b83532a61b@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <65e78d0c-23a5-4702-9946-60b83532a61b@oracle.com>
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
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 4/23/26 12:02, John Garry wrote:
> On 22/04/2026 14:15, Hannes Reinecke wrote:
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -352,18 +352,20 @@ static struct scsi_device 
>>> *scsi_alloc_sdev(struct scsi_target *starget,
>>>       if (scsi_device_is_pseudo_dev(sdev))
>>>           return sdev;
>>> -    depth = sdev->host->cmd_per_lun ?: 1;
>>> +    if (sdev->host->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN) {
>>> +        depth = sdev->host->cmd_per_lun ?: 1;
>> Why don't we use a simple flag in the host (or host template) to
>> indicate that cmd_per_lun should be ignored?
>> I'm not in favour of using magic values for a setting which
>> otherwise is a limit.
>> Look to dev_loss_tmo as a bad example ...
> 
> I think it's better to not have a flag and also keep cmd_per_lun, as 
> then we need to sanitize one vs the other. As mentioned in the cover 
> letter response, cmd_per_lun could be got rid off / reworked.
> 
> Personally I also dislike how the scsi budget code checks for a budget 
> map being non-NULL (which is for reserved scsi devices, which doesn't 
> need a per-sdev budget map).

Let's see if we can schedule a session at LSF; I really would like to
get this one sorted out.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
