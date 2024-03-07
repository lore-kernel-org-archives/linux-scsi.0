Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D085643
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 11:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709811765; cv=none; b=Y/hT5+1KQRMHB1R5Y3obqD18OEAx6DwItzZfsXTyM/jqRvwF6N0JlzScykO3tZ77iVwYhhW0CeBIz9JEJV1z5wnDPnzwxS7NQjgbfeXa2WeWTOJm+i2S1QHU6iowRvDlSjyD+Id/upkx5upVu2DWE4xqgw2fEbeUVNcDa1HY7v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709811765; c=relaxed/simple;
	bh=Y6cqgVYbfVRCY/dqaFL/g1Ul7dt0Cb2NXLI82ZOziq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kprJGrp/tca8GLsSsDtP77pdu+t9zsMSMMxwKAnOQ+IiVk3GcESEqxQCxQxa7ZbOFu5yMQRHrI+ZU/ZIbnmELMh7uQp+QMponcawMS2fPZzkJvc4CqqSuRJAeEONH2m0r9wVT9j5NDYhvEJNf3MW5xo5c03eTyRDuYl/lPJ2Io0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fFgke+yl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uSNN1uvU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fFgke+yl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uSNN1uvU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fFgke+yl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uSNN1uvU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fFgke+yl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uSNN1uvU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 12941681EC;
	Thu,  7 Mar 2024 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709810980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5+Rn81DlI700R67V0SRwWkuoZyyhtaN926nVIX60kPY=;
	b=fFgke+ylOhMnbtsy7Pd8duPPu8MlbfEJImqA91WY/2Y30NdV8svOYYsUhPgRUC1wIjobCT
	dyW68CHTBRFOAb37xtJOr8Zt7CmOru/GG8PSdVNMxF47QUB2MzZn/VlcuVVp5C04/LcHPt
	9Xd3e+wNVksn6D3+VtNAxQi68+ZYFK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709810980;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5+Rn81DlI700R67V0SRwWkuoZyyhtaN926nVIX60kPY=;
	b=uSNN1uvUY0TqQI2RRaz3PSf0I8aC2nffyiTmDeW/8fBR2E/6aoEpSnCtsLR5ttSySyCUZA
	q2rDG5oPpfV4hVCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709810980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5+Rn81DlI700R67V0SRwWkuoZyyhtaN926nVIX60kPY=;
	b=fFgke+ylOhMnbtsy7Pd8duPPu8MlbfEJImqA91WY/2Y30NdV8svOYYsUhPgRUC1wIjobCT
	dyW68CHTBRFOAb37xtJOr8Zt7CmOru/GG8PSdVNMxF47QUB2MzZn/VlcuVVp5C04/LcHPt
	9Xd3e+wNVksn6D3+VtNAxQi68+ZYFK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709810980;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5+Rn81DlI700R67V0SRwWkuoZyyhtaN926nVIX60kPY=;
	b=uSNN1uvUY0TqQI2RRaz3PSf0I8aC2nffyiTmDeW/8fBR2E/6aoEpSnCtsLR5ttSySyCUZA
	q2rDG5oPpfV4hVCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C99FD12FC5;
	Thu,  7 Mar 2024 11:29:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mHOkMCOl6WVMOAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 07 Mar 2024 11:29:39 +0000
Message-ID: <1c3eea31-b80f-4b95-ab15-ac42f7c45c16@suse.de>
Date: Thu, 7 Mar 2024 12:29:39 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] nvme-fc: FPIN link integrity handling
Content-Language: en-US
To: Sagi Grimberg <sagi@grimberg.me>, hare@kernel.org,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, James Smart <james.smart@broadcom.com>,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240219085929.31255-1-hare@kernel.org>
 <1dfa9a4e-e4a2-4d48-b569-85e48ce4311c@grimberg.me>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <1dfa9a4e-e4a2-4d48-b569-85e48ce4311c@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.29
X-Spamd-Result: default: False [-1.29 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[39.28%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On 3/7/24 11:10, Sagi Grimberg wrote:
> 
> 
> On 19/02/2024 10:59, hare@kernel.org wrote:
>> From: Hannes Reinecke <hare@suse.de>
>>
>> FPIN LI (link integrity) messages are received when the attached
>> fabric detects hardware errors. In response to these messages the
>> affected ports should not be used for I/O, and only put back into
>> service once the ports had been reset as then the hardware might
>> have been replaced.
> 
> Does this mean it cannot service any type of communication over
> the wire?
> 
It means that the service is impacted, and communication cannot be 
guaranteed (CRC errors, packet loss, you name it).
So the link should be taken out of service until it's been (manually)
replaced.

>> This patch adds a new controller flag 'NVME_CTRL_TRANSPORT_BLOCKED'
>> which will be checked during multipath path selection, causing the
>> path to be skipped.
> 
> While this looks sensible to me, it also looks like this introduces a 
> ctrl state
> outside of ctrl->state... Wouldn't it make sense to move the controller to
> NVME_CTRL_DEAD ? or is it not a terminal state?
> 
Actually, I was trying to model it alongside the 
'devloss_tmo'/'fast_io_fail' mechanism we have in SCSI.
Technically the controller is still present, it's just that we shouldn't
send I/O to it. And I'd rather not disconnect here as we're trying to
do an autoconnect on FC, so manually disconnect would interfere with
that and we probably end in a death spiral doing disconnect/reconnect.

We could 'elevate' it to a new controller state, but wasn't sure how big
an appetite there is. And we already have flags like 'stopped' which
seem to fall into the same category.

So I'd rather not touch the state machine.

Cheers,

Hannes

