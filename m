Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793264179;
	b=YgLnIlZcFOr5HWjCo/d/ME/meKQTJRLoQvTc2tgLjiHQeBb9/yrT6jjpNGglVqMCTtKn
	 +TMZdvr5ZmBWaUP7r0hiYntsibCk1tfuh9uf3GsI86H8GNFOt/mk7OvNSGgFjX6gaHpRD
	 UFBvFaWmCnaxzLvjlJZReqA8v1mdO8j/xerCkvYUOmowuHuBgEAlYVdaiAqoqs8UXq+yB
	 llew4bPsFhPNii2S8BE6DiIrsN08E3kyRjpsEWdNY7vOcOOrUh5CxHm/rqY6m9WmElzDj
	 7dIixTGkvEbmG6r0FmVicQkR+a+F4exnjIimoQsONyfSVdzbZxqbz3z7yEB9sWNWRvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793264179;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=Cn4mvpI3CQXH8KofFjVeO7J734N/9Tp65TQCTShEYpE=;
	b=JyNuxwQlSj+G0ULh+7LfxOksvb/bREj4ZUQgERu4iXxqtuPt6fiW23zdx4aigZ3ASn1i
	 Yhhcg0LZ20oj9+fd3qxfbPwVEB3GB2oHypB7+i2y7DsX9UJDKAetGV30eXvoS4QI0zDGD
	 vANKvFDgyaMy11U1KjhbNoQ7GBG9xywTFWQrXsfS/z/3NYRzAcc5iLKsLLKKI7J8VJhMF
	 CdsRZRHTsYbObTe+qlhHu11frmDIWN2uKnM8NlTufeS3FGf7XDhJI8U2WmIiccLAMwROT
	 KVa/ZW7ToKfjsp3hnOkwOzBXMz1lTXPz5taFHFF76dcyt1Xw8NV3PetxhdOufo1MUhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FJQjM9uu;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IlMqHSjV;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=egIy5273;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EA7L1MLH;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A0F606A31F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 08:56:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59A0F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FJQjM9uu;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IlMqHSjV;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=egIy5273;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EA7L1MLH
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6BBBB22313;
	Thu, 29 Oct 2026 08:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793264177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn4mvpI3CQXH8KofFjVeO7J734N/9Tp65TQCTShEYpE=;
	b=FJQjM9uufEggum0MlfT/oswx3CGLyDbiXx/AF63i15T6KJ8714YSEJZtUvaBGJSA7NlXBq
	42gYZvUid8PC/7ASSVx3D/BA9UxNDtzRh2NGLDMoEdD3eVZ4GNLa3mPQQgFbHJUrjCsboH
	oQTJlX01MuuAyC+PacDhAfHC65WRPx0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793264177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn4mvpI3CQXH8KofFjVeO7J734N/9Tp65TQCTShEYpE=;
	b=IlMqHSjVdmw3LsgLDzvKfYH3aq/WU8trWApXJ4ml8OeBvMd+QKDU5OjboZAeiQUVkNuN2+
	ShqewLb+9/oweCDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793264176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn4mvpI3CQXH8KofFjVeO7J734N/9Tp65TQCTShEYpE=;
	b=egIy52738JQWjP8kch0p9uy1xnKkMQ9eNLxZVFs91Pj14l/tpBLytrptwtBuTcOoCLq3es
	rQ2h3zLNt9Fa0PO60TjdT5B6uHcQR2grd3h6R/6eZz38RwChHgDnIl/kaQkkWIvD0mM8pw
	gchp/Yi4f3fQSdgCIMuA6tnvyzqTa8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793264176;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn4mvpI3CQXH8KofFjVeO7J734N/9Tp65TQCTShEYpE=;
	b=EA7L1MLHEGKHPnwgT0vxC5lY1Xikxk6/X+f+YH/0Rn2pYbCXFEoeQy8hRaDR97E4YbWkzM
	7Ucyc5+1DuUiqHCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 219591339F;
	Thu, 29 Oct 2026 08:56:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sSjNOi8K42rpYQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 29 Oct 2026 08:56:16 +0000
Message-ID: <c789fed6-2c01-44c5-a26a-54dacb710319@suse.de>
Date: Thu, 29 Oct 2026 09:56:15 +0100
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
Subject: Re: [PATCH v3 3/3] scsi: core: Match ULDs to logical units in the
 ALUA unavailable state
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Hannes Reinecke <hare@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
 Krishna Kant <krishna.kant@purestorage.com>
References: <20261029002531.82824-1-brian@purestorage.com>
 <20261029002531.82824-4-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261029002531.82824-4-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.998];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 10/29/26 1:25 AM, Brian Bunker wrote:
> scsi_bus_match() only matches devices with peripheral qualifier 000b,
> so a LU that is in the ALUA unavailable state on a target port when
> the host scans it never gets an upper-level driver on that path. When
> the target port becomes available again, nothing binds sd and the path
> stays unusable until the device is deleted and rescanned. A host that
> was already running when the path became unavailable keeps sd bound,
> so the result depends on when the host scanned.
> 
> Peripheral qualifier 001b cannot be matched on its own: an unmapped
> LUN reports it as well, and some targets report every possible LUN in
> REPORT LUNS. Binding sd to all of those would create disks with no
> backing LU.
> 
> The SCSI core now reads the access state of a device that supports
> target port groups with REPORT TARGET PORT GROUPS before the device is
> registered, and an unmapped LUN fails that command. SPC-4 requires a LU
> in the unavailable state to report PQ 001b, and the command shows that
> the LU is mapped, so record in the device whether it reported PQ 001b
> and its access state could be read, and match such a device. sd then
> binds to the unavailable path like it does to a standby path, the path
> stays in the multipath map as a failed path, and the existing UNIT
> ATTENTION handling brings it back when the target port becomes
> available.
> 
> The decision is made once, at scan time, and not from access_state when
> the match is made. access_state follows the ALUA state, but the
> peripheral qualifier it relates to does not change after the scan. If
> the match depended on access_state, a device scanned in the unavailable
> state would stop matching as soon as its path became available, e.g.
> when the upper-level driver module is loaded later, or the driver is
> rebound, or the ALUA device handler updates access_state before the
> driver is probed. It also does not depend on the state that the command
> returns, which can already be available if the path recovered between
> the INQUIRY and the command.
> 
> This is the same situation as a path in the standby state, to which sd
> already binds: SPC-4 requires READ CAPACITY in neither state. The
> unavailable state does not require MODE SENSE either, which the standby
> state does.
> 
> The cached INQUIRY data in sysfs keeps the peripheral qualifier
> reported at scan time, like the rest of the INQUIRY data; access_state
> shows the current ALUA state.
> 
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi_scan.c   | 26 +++++++++++++++++++++-----
>   drivers/scsi/scsi_sysfs.c  | 14 +++++++++++++-
>   include/scsi/scsi_device.h |  6 ++++++
>   3 files changed, 40 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
