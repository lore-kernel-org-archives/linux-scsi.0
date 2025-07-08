Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296242BDC0C
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 08:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751962970; cv=none; b=Wg1bPA+NJtEvGriwKz9NHkorxP/uhW8/Q+IDWmn7oqW/RyG7sP+v5tqyuHe/ODS1v6pWwjlMOk6FGkYlK40tLZ66HrGOQ43DoeD0DzuKGDmx4ctZr93zo23xYTXVOB3QHeTLOJna1QelA3tgTc/IetZOkIkLEGEouTsQJur4p3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751962970; c=relaxed/simple;
	bh=SKhI0x3s0VOMzJU0jLRZHTkPzD4+gIJE3omLuevs4Zs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tzEy/LKbG688Xo9UfM21TcsZKIoqjJXCa0RexEBJmddEIwu+N9/QOpZswmTZEo7HNaXTn/aWbL1ZuMDNab1/qNTv7a1c5irNj/Y7gqpOgMcuNI6hot8bp6pCEGgofCbgDbsd1HMvYtMdocwGqWHdEv4PeLmi1OVMLPvezVbwZnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mMr0hn3G; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bxHJlZa8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mMr0hn3G; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bxHJlZa8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mMr0hn3G";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bxHJlZa8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mMr0hn3G";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bxHJlZa8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3844F21167;
	Tue,  8 Jul 2025 08:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751962966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HwDl9fw4ffn1gfBHn6poEUTpPmTpiruPjjrtX0i896o=;
	b=mMr0hn3GOPng0dnRECg3QMZn7BowsIfAt1RQr1WfUfwXw7abgSa1hGGE9K8r1h/0dtJO6c
	oPE3Bpn8qOdPK/jReZll9BiWI3Se37QMRo5Tp5HjyMig+682CmB13bYPv7Oy8tKblt+4PU
	8/EJe7IQ3WLHAOly00VSCLzKu0cK/OY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751962966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HwDl9fw4ffn1gfBHn6poEUTpPmTpiruPjjrtX0i896o=;
	b=bxHJlZa8Wxq/X89yV6+4ORQtF2LDfvxIjHlGTG7sap9ttm7oQsO7l6/T0XumQfZsf4Mo0X
	ND2U8xaAFUSuPjCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751962966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HwDl9fw4ffn1gfBHn6poEUTpPmTpiruPjjrtX0i896o=;
	b=mMr0hn3GOPng0dnRECg3QMZn7BowsIfAt1RQr1WfUfwXw7abgSa1hGGE9K8r1h/0dtJO6c
	oPE3Bpn8qOdPK/jReZll9BiWI3Se37QMRo5Tp5HjyMig+682CmB13bYPv7Oy8tKblt+4PU
	8/EJe7IQ3WLHAOly00VSCLzKu0cK/OY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751962966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HwDl9fw4ffn1gfBHn6poEUTpPmTpiruPjjrtX0i896o=;
	b=bxHJlZa8Wxq/X89yV6+4ORQtF2LDfvxIjHlGTG7sap9ttm7oQsO7l6/T0XumQfZsf4Mo0X
	ND2U8xaAFUSuPjCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25D2713A68;
	Tue,  8 Jul 2025 08:22:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r1DwB1bVbGg+VQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 08:22:46 +0000
Message-ID: <dbf131f9-f28b-442c-8047-c0d8c32ab53c@suse.de>
Date: Tue, 8 Jul 2025 10:22:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_transport_fc: Change to use per-rport
 devloss_work_q
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20250707202225.1203189-1-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250707202225.1203189-1-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 7/7/25 22:22, Ewan D. Milne wrote:
> Configurations with large numbers of FC rports per host instance are taking a
> very long time to complete all devloss work.  Increase potential parallelism
> by using a per-rport devloss_work_q for dev_loss_work and fast_io_fail_work.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_transport_fc.c | 70 ++++++++++++++++++--------------
>   include/scsi/scsi_transport_fc.h |  5 +--
>   2 files changed, 42 insertions(+), 33 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
