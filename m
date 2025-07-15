Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80248202C48
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752591286; cv=none; b=Kkh7Zx6zqaq0zMKc9VBJjsP0cUaHKbekMc6tW3t4lgn00vy+prTONrQnbgEYeKC9vm485Nq4dOIBYgC8PRwclMc7VIN7S90+oopxbBtZYxJEuomRcLZdXCQDXnxPukbi7luPh3p6p78xZAcTXuaFTfnvXemshPXrzkAfhCaopUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752591286; c=relaxed/simple;
	bh=9AIcixY5uSGBPESz/ht9U5oZJn0hWvh16SIIWhz/OtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gAUzMx02V3i4AUN0JGCq7oXOLCSPRzNCowR5gAX5kR9HhtwE1biS49GbQpQPYXjLc8SfdfNuqeGn8ImVaxnFVqhpNBWz9oyg+epaAqkZ6OJRQevOrKzzSmabGLQpgb1oxNF2u3E8VnqBhkOWzzR1n5480hyoBvrGd4vWr+ybTds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k/uuHw81; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4en5KfqZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k/uuHw81; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4en5KfqZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k/uuHw81";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4en5KfqZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k/uuHw81";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4en5KfqZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9ECA52127B;
	Tue, 15 Jul 2025 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752591281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GS9AhS/K9gTV+4s3jqSI48gQjC2+IXKWjX5+Xx5Y8fE=;
	b=k/uuHw81p097OaXQX7hnZbZlUO2ZQJ/MOwpuALhlw6ZwvY6Sy3CciFcg0oPj+44Y5g8HeL
	tLTCdxjCiep6EeZButt9nBgxY05j2IpoBXeQeWaTckgg6V55gcwzYHkrVdY7LBc9/fq/hU
	A2VH9kQ6+DWmAIsnZEqJjmC9ywutt28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752591281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GS9AhS/K9gTV+4s3jqSI48gQjC2+IXKWjX5+Xx5Y8fE=;
	b=4en5KfqZVFrUE4yzS2dDNVy+HaPdhzzFdJdBeJeoikSFGjT5WLkkwypPyH/qG1nM6faNw0
	97kz8J4B48zJUjCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752591281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GS9AhS/K9gTV+4s3jqSI48gQjC2+IXKWjX5+Xx5Y8fE=;
	b=k/uuHw81p097OaXQX7hnZbZlUO2ZQJ/MOwpuALhlw6ZwvY6Sy3CciFcg0oPj+44Y5g8HeL
	tLTCdxjCiep6EeZButt9nBgxY05j2IpoBXeQeWaTckgg6V55gcwzYHkrVdY7LBc9/fq/hU
	A2VH9kQ6+DWmAIsnZEqJjmC9ywutt28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752591281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GS9AhS/K9gTV+4s3jqSI48gQjC2+IXKWjX5+Xx5Y8fE=;
	b=4en5KfqZVFrUE4yzS2dDNVy+HaPdhzzFdJdBeJeoikSFGjT5WLkkwypPyH/qG1nM6faNw0
	97kz8J4B48zJUjCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B7FB13306;
	Tue, 15 Jul 2025 14:54:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OMIlGbFrdmhFUwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 15 Jul 2025 14:54:41 +0000
Message-ID: <e34b48c2-1a07-4d4e-af5a-dfa8d96dca8b@suse.de>
Date: Tue, 15 Jul 2025 16:54:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] Documentation: driver-api: Update libata error
 handler information
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>
References: <20250711083544.231706-1-dlemoal@kernel.org>
 <20250711083544.231706-4-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250711083544.231706-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 7/11/25 10:35, Damien Le Moal wrote:
> Update ``->error_handler()`` section of the libata documentation file
> Documentation/driver-api/libata.rst to remove the reference to the
> function ata_do_eh() as that function was removed. The reference to the
> function ata_bmdma_drive_eh() is also removed as that function does not
> exist at all. And while at it, cleanup the description of the various
> reset operations using a bullet list.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   Documentation/driver-api/libata.rst | 25 ++++++++++++++++---------
>   1 file changed, 16 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
