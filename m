Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D033208
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 07:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759734089; cv=none; b=jS/e+webJr0V32AlrCc7dxFvLcnofprRqETZ+V+PjgbThyNhht1PTorkpFN2kskVA5h3zMAYk84yrf4LQsZSED8wY8tR5oTRmCmHvFCNmJoL7y57UhDceue1hA7RFrpagHpeXhd6U+k4DJD+08ZlalTl9n+ECl1ztXqKU5uVmWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759734089; c=relaxed/simple;
	bh=JN8h3fzhaa+YmF0g6Ngn3AZHd/lRMG5t1jLeKcpD0bY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HcdEE6xn3++Xce97RaLkRJxkMve59Dy8+fppsiPcmQ2uWk4t9OCGhsdaCef7Qi3Y/cmWColpAwy95aUk83QmvF+QzArajJFFzZyBQZz1xPfjI8nBzlcioL1n+yiCsO+0SX5Z98uEWKYmXlId2n5l2BNJau9s/LaQBmN7nhm/PR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z9p9rfTI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xGpPs2di; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gS9S72mB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iHyptUQN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z9p9rfTI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xGpPs2di";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gS9S72mB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iHyptUQN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 17C0222CE7;
	Mon,  6 Oct 2025 07:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+m9A7AhlV9j/hFSjt8u5UiyMAZkxXA8CZTGv+RhkBM=;
	b=Z9p9rfTIJKR97agzdextZplkJIbbz1I7AjgpgN54c/wrX164igabYx8kZ8eEMwFgpUdTv6
	E9RiBUj3yXVvSISF7uvSZ6G2e5wxw2MYUwrTcAa6dIxebxmxNR7RGOTEHtvVPRNWHqIu9/
	BAoEjvUPqR8J+vvpOXcuVrfJWhZxz7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734086;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+m9A7AhlV9j/hFSjt8u5UiyMAZkxXA8CZTGv+RhkBM=;
	b=xGpPs2diZdboFE6pYboth+TveruLG0oGX47GhXPOyjxlpWkDcbsJ3Y+Pc2V1egO1XbhSu8
	bZOcQ9xcLjtT8RDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gS9S72mB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iHyptUQN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+m9A7AhlV9j/hFSjt8u5UiyMAZkxXA8CZTGv+RhkBM=;
	b=gS9S72mBYZMthV4fIlD12hKDMMmSMJEUV3rttGFkoNDiVt6kQ+USQWq3qmmxmkY43ZsAyH
	OLUURGBS2BZw8q+22SpzsG5YmzxeATFTjDUYM79okJJXKbxUGF7LPuqNTo1/7AbNScGZTI
	K1NpO2CjSyWrpzZ/6/dwmOB03SUV34E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+m9A7AhlV9j/hFSjt8u5UiyMAZkxXA8CZTGv+RhkBM=;
	b=iHyptUQNNz8XMwjmm+C1EO85ZqdiM7LPWdXtjhHk1hc+lqSVsY9W+XM6Po9xBg47AS7KjK
	ExyPmOZPqUjayACg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C701A13995;
	Mon,  6 Oct 2025 07:01:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PxfHLkRp42g3EgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 07:01:24 +0000
Message-ID: <92350826-c2ab-4a09-8c62-447750948c02@suse.de>
Date: Mon, 6 Oct 2025 09:01:24 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-4-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251002192510.1922731-4-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,oracle.com:email,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 17C0222CE7
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 10/2/25 21:25, Ewan D. Milne wrote:
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
