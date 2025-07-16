Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EE317A2EB
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 06:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752646079; cv=none; b=YK7C0bF1+HmzmMBRPaoZNYAcLczTppZq+rD620CH6BfpJnWMvgikMyArMMIGwo5XoDTNtzWFXdP7yrSpM07bxUDOu7HTJVPXLvEYH+AWPh7DbJSZCJEYJjji2x63nn8BM/TnEJGcME7VCCzNqz+/hQDz8Tbg9T6g3aLwCuXmlcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752646079; c=relaxed/simple;
	bh=QuMcMlWfsix44g7bGvuvejP/S0qgh8mFWNR9Rm6X9n0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPEaQiPTIaBnuj8Ixe6F8xx5/B7NuMBi43UnnZ6oCHIQkuvqwsT2D1pqsTdBf7KAyvgMCrXhfLlaTUfBnAHS0c5/DA1ICXZnRSu8WE6XgQt4auA3d5eu+fKFbL9F2uN2feRO2RlXg+FcQzM7RJiTfWx8FqtLPYaFcvdd4gHlXKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vl29AnZT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9vQ3DX3O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vl29AnZT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9vQ3DX3O; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vl29AnZT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9vQ3DX3O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vl29AnZT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9vQ3DX3O"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B74F921245;
	Wed, 16 Jul 2025 06:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752646072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0e1SUfxNlwATJ9GKQOGvJVqQtEh7kUZtHLagVZpWars=;
	b=vl29AnZTjxlFqmmjlZ+1TUNH4G7Z1azN8kGPXqkbBNSPNo3xi6GH4CFIJFBK244MqHJhCb
	bUsLsEmHqh3RXxpNaemvRobvE6T0jhllyj8fuPbmGni+IU5B+ptbq3ZjGQ+t2U7zGVzh9K
	5+WHEdpgK5S4Ko5lMuwFIAbIoPeAT3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752646072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0e1SUfxNlwATJ9GKQOGvJVqQtEh7kUZtHLagVZpWars=;
	b=9vQ3DX3OgONEYJAfFPbfu94TxdfyQ+5S4QH7MZxgl6xpXUHvjUbCzgoF7QEVVuW0B8mZ4P
	ea90wvGE4HUhm4Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752646072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0e1SUfxNlwATJ9GKQOGvJVqQtEh7kUZtHLagVZpWars=;
	b=vl29AnZTjxlFqmmjlZ+1TUNH4G7Z1azN8kGPXqkbBNSPNo3xi6GH4CFIJFBK244MqHJhCb
	bUsLsEmHqh3RXxpNaemvRobvE6T0jhllyj8fuPbmGni+IU5B+ptbq3ZjGQ+t2U7zGVzh9K
	5+WHEdpgK5S4Ko5lMuwFIAbIoPeAT3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752646072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0e1SUfxNlwATJ9GKQOGvJVqQtEh7kUZtHLagVZpWars=;
	b=9vQ3DX3OgONEYJAfFPbfu94TxdfyQ+5S4QH7MZxgl6xpXUHvjUbCzgoF7QEVVuW0B8mZ4P
	ea90wvGE4HUhm4Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53CDB138D2;
	Wed, 16 Jul 2025 06:07:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AiBAErhBd2hdZQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 16 Jul 2025 06:07:52 +0000
Message-ID: <ccb69ee6-bd5e-4585-9ccc-0c49cb30f1a9@suse.de>
Date: Wed, 16 Jul 2025 08:07:51 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/8] nvme: sysfs: emit the marginal path state in
 show_state()
To: Keith Busch <kbusch@kernel.org>, John Meneghini <jmeneghi@redhat.com>
Cc: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 hch@lst.de, sagi@grimberg.me, axboe@kernel.dk, james.smart@broadcom.com,
 dick.kennedy@broadcom.com, njavali@marvell.com, linux-scsi@vger.kernel.org
References: <20250709211919.49100-1-bgurney@redhat.com>
 <20250709211919.49100-8-bgurney@redhat.com> <aG7pSA6TOAANYrru@kbusch-mbp>
 <35738598-0733-408c-8597-20c3599a8973@redhat.com>
 <aHa0JpsASqGuHdOA@kbusch-mbp>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aHa0JpsASqGuHdOA@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 7/15/25 22:03, Keith Busch wrote:
> On Tue, Jul 15, 2025 at 03:42:32PM -0400, John Meneghini wrote:
>> On 7/9/25 6:12 PM, Keith Busch wrote:
>>> On Wed, Jul 09, 2025 at 05:19:18PM -0400, Bryan Gurney wrote:
>>>> If a controller has received a link integrity or congestion event, and
>>>> has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
>>>> instead of "live", to identify the marginal paths.
>>>
>>> IMO, this attribute looks more aligned to report in the ana_state
>>> instead of overriding the controller's state.
>>>
>>
>> We can't really do this because the ANA state is a documented protocol state.
>>
>> The linux controller state is purely a linux software defined state.  Unless
 >> I am wrong, there is nothing in the NVMe specification which defines
 >> the nvme_ctrl_state.>
> Totally correct.
>   
>> This is purely a linux definition and we should be able to change is any way we want.
> 
> My kneejerk reaction is against adding new controller states. We have
> state checks sprinkled about, and special states just make that more
> fragile.
>   
Yeah, controller states are not a good fit. We've seen the issues when
trying to introduce a new state for firmware update.

>> We debated adding a new NVME_CTRL_MARGINAL state to this data structure,
>>
>> enum nvme_ctrl_state {
>>          NVME_CTRL_NEW,
>>          NVME_CTRL_LIVE,
>>          NVME_CTRL_RESETTING,
>>          NVME_CTRL_CONNECTING,
>>          NVME_CTRL_DELETING,
>>          NVME_CTRL_DELETING_NOIO,
>>          NVME_CTRL_DEAD,
>> };
>>
>> If you don't like the flag we can do that. However, that doesn't seem worth the effort since Hannes has this working now with a flag.
> 
> What you're describing is a "path" state, not a controller state which
> is why I'm suggesting the "ana_state" attribute since nothing else
> represents the path fitness. If nvme can't describe this condition, then
> maybe it should?
> 
We probably could, but that feels a bit cumbersome.
Thing is, the FPIN LI (link integrity) message is just one a set of
possible messages (congestion is another, but even more are defined).
When adding a separate ANA state for that question would be raised
how the other state would fit into that.
 From a conceptual side FPIN LI really is equivalent to a flaky
path, which can happen at any time without any specific information
anyway.
Again making it questionable whether it should be specified in terms
of ANA states.

> Where does this 'FPIN LI' message originate from? The end point or
> something inbetween? If it's the endpoint (or if both sides get the same
> message?), then an ANA state to non-optimal should be possible, no? And
> we already have the infrastructure to react to changing ANA states, so
> you can transition to optimal if something gets repaired.

It's typically generated by the fabric/switch once it detects a link
integrity problem on one of the links on a given path.

As mentioned above, it really is a attempt to codify the 'flaky path'
scenario, where occasionaly errors are generated but I/O remains
possible. So it really is an overlay over the ANA states, as _any_
path might be affected.
This discussion only centered around 'optimal' paths as our path
selectors really only care about optimized paths; non-optimized
paths are not considered here.
Which might skew the view of this patchset somewhat.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
