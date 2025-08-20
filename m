Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEE1242D72
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690037; cv=none; b=KLoSTro/2f0XwBnIL/2K3r0tInZHS5o3e8tTTFrkRaTqVcrq3u8Odys/DYFBKd4gYXA+v6qRskaR1RzFUWY9rS95x1pOBR6UHihwvV0OXiF19iwIHFasBEiqQ2Y9wevNe8v6Yof80a7DxuiGDTk6ZIRYll98kJN+GhhqGR7gQnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690037; c=relaxed/simple;
	bh=H1ztq5+qw+cSJb2N79wn4uGL4N71pyAkntSc+OmcEgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U8PLGsbQcl0N+ikyjGb7LvnLRNffpxrrVEjTEHqCF+hpP815UHkarYcJO3uwTzD9YwosgDTbSPyJ17pvU3i0Hfw5d//2V73HlQ7ZZ2DXFrlamrfi2arDzJVsf9WN6W7v1wOtTdgTWGTbu9O+TMMGMDrHxNV0ZEaKUL9l6QU3qkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=srPEWOIM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T81jzm+E; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SX5U2OX2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mGFQNjtJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="srPEWOIM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T81jzm+E";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SX5U2OX2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mGFQNjtJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 483841F7F2;
	Wed, 20 Aug 2025 11:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFEqyv0fg++OwDnyNXI+N3d4hUYJBU6/2QhGRo1yBZk=;
	b=srPEWOIM3tkXhCI6LX4byaF18sQZ4J6RoZl9MmZEA7Ec2CXhnsNYjlgl83nAWxoaeCdHWo
	8oTDSn41EJdfRksEY8dtYmLsGb4w471NZWlnTXonLSoGZ/RsPz4om43qJjkPivAW+X+HQG
	CyjVrq4cyvF1lsc++JUF3BPl6BlexF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690033;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFEqyv0fg++OwDnyNXI+N3d4hUYJBU6/2QhGRo1yBZk=;
	b=T81jzm+E5tb+5AhDjJ2F/8QlpMjwgURI95oTeY+CeQEKm6OCoGm07C6H3wXxD7HeREiYPF
	oYtmDiv+zj53rTDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SX5U2OX2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mGFQNjtJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFEqyv0fg++OwDnyNXI+N3d4hUYJBU6/2QhGRo1yBZk=;
	b=SX5U2OX2kHLTr+MaExTAqvQ1AELg5MLK6rXDUCb1YAGjfXiEpWL3mJ2yloB/r62nfcxrSk
	YyMzp1vyIfMUV+f+9hlL+Dmz21jMwgS2FfUo7wsdh4s0TKsHrQtmshRHmlQYOPNJY2PeJh
	PYP4ossxNlj4NN3to8958KF1/xZipxg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFEqyv0fg++OwDnyNXI+N3d4hUYJBU6/2QhGRo1yBZk=;
	b=mGFQNjtJxDJHTxR47UG3W1tCTzvbe2HLAdnuzIzEQZ8erZsf4GRR+HO++/kmUqcdSsTPC1
	WrPxyWmFXUESPiBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 329BE1368B;
	Wed, 20 Aug 2025 11:40:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NGbnCzC0pWhRJwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 11:40:32 +0000
Message-ID: <479f9bed-3c06-4e18-9202-9f30d7857441@suse.de>
Date: Wed, 20 Aug 2025 13:40:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/8] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-4-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250815211525.1524254-4-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 483841F7F2
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 8/15/25 23:15, Ewan D. Milne wrote:
> This has read_capacity_16 have scsi-ml retry errors instead of driving
> them itself.
> 
> There are 2 behavior changes with this patch:
> 1. There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs since the block layer waits/retries for us. For possible
> memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
> retrying will probably not help.
> 2. For the specific UAs we checked for and retried, we would get
> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
> from the main loop's retries. Each UA now gets
> READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
> retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
> is already 10 and is not based on anything specific like a spec or
> device, so the extra 3 we got from the main loop was probably just an
> accident and is not going to help.
> 
> Original patch by Mike Christie <michael.christie@oracle.com> modified
> based upon review comments for an earlier version of this patch.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 107 +++++++++++++++++++++++++++++++---------------
>   1 file changed, 73 insertions(+), 34 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
