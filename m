Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12C31E51F1
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 11:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690341; cv=none; b=Cye4RAHqEw8YST1JsGkb2jetXc+Jxqp+JNs6uA8u9qWEYXiFcUS9S9fSMT4wUJRHD4F6iJ0uEbmv5rZ05VBhnZL49cNSsHY+JutwICvUFVo46ZP8C6Nj9/c6r4/UcOerTQv+Ha5hsdG+ChejUNOeggnNrWjSexCkeflYHVXKtzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690341; c=relaxed/simple;
	bh=URAExbIKnrT0wz7GI5lIV9FgQwlqXAU83PrflcoryCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KnUVei7W3UQMT1ozz4/UAhd2BuE5OZfWv7tt/FKXBW4++Q/1N0PXzgqVrMleXHQcDjTcAOqCX87zHmmNboitoLpdZSsyO6hokU9J8eoTm4CzGi1OF5wAFDnyoHZ0upHDIPNfboBAqyuktK9Xa7pnkPkeTSP8pFJOCDhyk1faJNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u1bEUSHh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=D3ZmJPaZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rpoEFoLL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cS2UfyxN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="u1bEUSHh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="D3ZmJPaZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rpoEFoLL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cS2UfyxN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB5F21F7F2;
	Wed, 20 Aug 2025 11:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2fXTmmfzgMCk/mK4Z5rtjmayT6uwhQr6M0HjPlnA8dc=;
	b=u1bEUSHh18R2mH7Wj1vONvbIbUTfigqAJpMA0oWvImefNIO6hJTzT12kcU0TkiDRJPgQHZ
	Ew+rHiTnVcDTrIX9nPmAts90abroh3RSxTV14wNLHbQxs/XvD13Zv3ZHsJc5k0nmTsKSWu
	HiUYI0uTVRYkcVS0GIMjHgN9RhgnfdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690338;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2fXTmmfzgMCk/mK4Z5rtjmayT6uwhQr6M0HjPlnA8dc=;
	b=D3ZmJPaZGs/HSwD8L1bQJTE2GL3byT9C5iwRGAbBhGGdE5iVPwrX3dW5IIZMBgBSYeNi5H
	t92VrfIR9J5swmDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2fXTmmfzgMCk/mK4Z5rtjmayT6uwhQr6M0HjPlnA8dc=;
	b=rpoEFoLL8jtg4Tq/H+MuzKYvp725YButDlWGvpjsK+61mb20WduIGZCYn/imN54gW3Z7Wd
	pY900E1mBs6ArUQYPJUxRMJqtYBqFvdTk+rPhR4DQr7qXjgJ28PDXDi0AjUOYhK6BYDfy/
	tt2L6vTyQNmiSxppOYh/KyWOUJnj8yQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690336;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2fXTmmfzgMCk/mK4Z5rtjmayT6uwhQr6M0HjPlnA8dc=;
	b=cS2UfyxNoXUHq9UeUne9p7xA+dRguK/GR5X0Cd4wXcLoXVNRBSIriWIqP9eB8cMgCps2Lb
	AfjllJ7xGPPDfRDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C84A61368B;
	Wed, 20 Aug 2025 11:45:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qQE3MGC1pWgIKQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 11:45:36 +0000
Message-ID: <0a292865-2369-400a-bd1a-cbbea131d63c@suse.de>
Date: Wed, 20 Aug 2025 13:45:36 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/8] scsi: scsi_debug: Add option to suppress returned
 data but return good status
To: Damien Le Moal <dlemoal@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>,
 linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-9-emilne@redhat.com>
 <cdd74665-9ab0-47d1-bc6b-f9ea731fefc9@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <cdd74665-9ab0-47d1-bc6b-f9ea731fefc9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/16/25 02:59, Damien Le Moal wrote:
> On 8/16/25 06:15, Ewan D. Milne wrote:
>> This is used to test the earlier read_capacity_10()/16() retry patch.
>>
>> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> 
> Looks OK, but it would be nice to be able to suppress the data only for the
> first X commands, so that the retires can be exercised with a success in them
> instead of all of them failing to give data.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 
> 
Seconded. The patches expect the device to return valid data after
retry, so we should be checking for that scenario in scsi_debug, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
