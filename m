Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5F73328FD
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 07:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773386823; cv=none; b=drlbdlbbIkHiC/Yo2TKXDjJFZkajNrXMujKikmFhKbYN4W4gQowgLK5wx8TPSI1DYxchJEpGVBxQIihnvh9Btw2c3s3cJwA16/Rg5giRo7MHQW4c34QuYzKbfK8Gfi88cSwrG0BOzYnwAnzrTg98ACkLwDYfetEDrg8NA2BVFfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773386823; c=relaxed/simple;
	bh=7/kWKIAn8otSyf8npfzJ8mMSxO+fgVWGDhmhpLH2jwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Om/TK7QLvOYswWlBpJORjl2zu+ooKFK0HB2frzdyfyXQJtU85F4LnI6Pnh7a5/2E23OVQQi3rZGuDlngX0Fvm+5/3v8Que1BIgdBt/1peBXF+H3RB9vlILjUwgW9d2HTKG60SKh0spMGdaPARGennShaagJNhC5zucoFDy4871o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TbqEIBvK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QoqrnTlh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1U9Cdl33; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d3vL2gHc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TbqEIBvK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QoqrnTlh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1U9Cdl33";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d3vL2gHc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EB5804E3E0;
	Fri, 13 Mar 2026 07:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773386817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLUNktoxeRo5WB7tb5liojkrKL2uuwe/4f0iWU2kjgo=;
	b=TbqEIBvKHW6pVby6KzvPzGArQlHNO1l2SORcMdDcJ1Iyr9WQ3nELBlmWYpi0a9dfjiQ9F2
	UGz6KqL9F452xHqz3lliz4jjn4wmHfBv14/8LB9vji9wHhViWdjYTIvc92HAa1SiAcI+mg
	ZMt/3UI/JPdATdSdLBYXRGh4LEqDZUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773386817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLUNktoxeRo5WB7tb5liojkrKL2uuwe/4f0iWU2kjgo=;
	b=QoqrnTlhkj6itclS4GfLOMAvOLLceglYecD5jL82WrYLVtjcM3CtQ3Sgu+YjO9sFG+MS6Y
	Q1x4nQBZCI45OFAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1U9Cdl33;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d3vL2gHc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773386816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLUNktoxeRo5WB7tb5liojkrKL2uuwe/4f0iWU2kjgo=;
	b=1U9Cdl33286uzfSoKPav3iO1r4PJ6+hK0xHaEB8demd1o+TYS4Fal+o1Kgdcir5KBNDoxS
	3X9RNwznyB9KV0Kz9OVsTxQEA0EhRkjot975L/mYUlujTI6QfJfOu25WhYqXTEzEnTcBt4
	uxCjRDQWT3zMll8D5cWzNhpEoqH/H4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773386816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLUNktoxeRo5WB7tb5liojkrKL2uuwe/4f0iWU2kjgo=;
	b=d3vL2gHc1V2B0J2SjlsqKugkHWUtnn2BTlfTbp+qUXgbNwK7mRJMr8SGWrN6XK4aQ6lqBf
	gtCXjwS8mRxgxFAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B632403E1;
	Fri, 13 Mar 2026 07:26:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GCCaID+8s2ndAgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 13 Mar 2026 07:26:55 +0000
Message-ID: <f2d5a521-adc1-46c6-9ce0-996935e989d5@suse.de>
Date: Fri, 13 Mar 2026 08:26:40 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: scsi_debug: enable sdebug_sector_size >
 PAGE_SIZE
To: Damien Le Moal <dlemoal@kernel.org>, sw.prabhu6@gmail.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, pankaj.raghav@linux.dev,
 bvanassche@acm.org, Swarna Prabhu <s.prabhu@samsung.com>
References: <20260214011829.508272-1-sw.prabhu6@gmail.com>
 <20260214011829.508272-3-sw.prabhu6@gmail.com>
 <9f4cc1a9-d475-4835-ab8e-d8c69017ea96@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <9f4cc1a9-d475-4835-ab8e-d8c69017ea96@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com,HansenPartnership.com,oracle.com,vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: EB5804E3E0
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

On 2/16/26 23:57, Damien Le Moal wrote:
> On 2/14/26 10:18, sw.prabhu6@gmail.com wrote:
>> From: Swarna Prabhu <s.prabhu@samsung.com>
>>
>> Now that block layer can support block size > PAGE_SIZE
>> and the issue with WRITE_SAME(16) and WRITE_SAME(10) are
>> fixed for sector sizes > PAGE_SIZE, enable sdebug_sector_size
>>> PAGE_SIZE in scsi_debug.
>>
>> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
