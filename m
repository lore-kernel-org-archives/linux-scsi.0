Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2300F25EF98
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2025 11:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756380195; cv=none; b=gjZ3UoRfvd4LftBstA/p0E1v3DOfdbIGQsN4BIoTz63p4eqnh6OECWr2IIJcD+ipHQFhGHy+wGOdKFNqceZUrghXNdXmHy5KnHtNtv4ojCahiJBoMXdwrdqrAiuTyaSjThkgT//JKxGevXa/IY6fmlcVuOtXMxCgbEEKuvfqVEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756380195; c=relaxed/simple;
	bh=k2Hnz7Yfk490J0yXmRdzVF390FzDCX8Iq6FXFhiDlGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jYlfVjd+mDOW+JEl8VDJhQC8v+2VWdQd1chvE5Y1oZwA9foEgcMDlv/dzmqc+KhZSOnfnS/12FDPwdsfCEa5AV/J1SvW+1AQuMCtf/2bZ04T27sTi8Iu9gUCYVpTFtNspmjeuiQPVwpEJchXTru2T/9hPptmRtHUcI56SiAFvUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=R6gLAtmE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WhU2a+1t; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Zr+pZ4Kc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lF9uGQ2D; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="R6gLAtmE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WhU2a+1t";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Zr+pZ4Kc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lF9uGQ2D"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 441E920B22;
	Thu, 28 Aug 2025 11:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756380192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9Wu7KajHAGUCXUCXQAF6k0KRiHaprdIOlCrXPWrJ1E=;
	b=R6gLAtmEv/SUDwZvaHDrXtzHPXqar9r9XnwLeh/lGDqIJ0e+MmUXmtlD3ikjayDbppIMkR
	RB0Q+RxH3e+fTEFrGE5rUyflsfG1idbRIob1hgup3jDmEgl2zkapKVPadzZ83VcpXKAEJw
	taEtGlQkhARz37V3Rz5ES4coM+xPyRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756380192;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9Wu7KajHAGUCXUCXQAF6k0KRiHaprdIOlCrXPWrJ1E=;
	b=WhU2a+1tS8zK0ZDXiktq5WtPFCMqDqNuTbx6TWoEpn6/RW8O0C3f0NIby99dPElxHleJhr
	INL63/I+kkyGrXDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756380191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9Wu7KajHAGUCXUCXQAF6k0KRiHaprdIOlCrXPWrJ1E=;
	b=Zr+pZ4Kcns5c6sWn8mOjTkFqiF2dnzDoCUXwSssfciyyCRmNpR6fylddWHFglKK+utSRdq
	afPLoWrqz4V/p11GMPBaWxtOT+rlSqe5gFnQyKvWiLKOKKSbBTC0yDUEjVlCyBkrGmgXZr
	SU9KVXMYn5BVYcTurvEHWffhKrQ2NHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756380191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9Wu7KajHAGUCXUCXQAF6k0KRiHaprdIOlCrXPWrJ1E=;
	b=lF9uGQ2DnSTmVRBIyINM35GGTndLaqjjkjq/B9Oq05QjXuBiAlUcP4JQS0znv7tlyugHN0
	UUkiig3TVThPldAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 31E2D1368B;
	Thu, 28 Aug 2025 11:23:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QHrBCx88sGiyZAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 28 Aug 2025 11:23:11 +0000
Message-ID: <c11bacd8-56d5-4df0-b053-3b618e454855@suse.de>
Date: Thu, 28 Aug 2025 13:23:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v24 00/18] Improve write performance for zoned UFS devices
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
References: <20250827212937.2759348-1-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250827212937.2759348-1-bvanassche@acm.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/27/25 23:29, Bart Van Assche wrote:
> Hi Jens,
> 
> This patch series improves small write IOPS by a factor of two for zoned UFS
> devices on my test setup. The changes included in this patch series are as
> follows:
>   - A new request queue limits flag is introduced that allows block drivers to
>     declare whether or not the request order is preserved per hardware queue.
>   - The order of zoned writes is preserved in the block layer by submitting all
>     zoned writes from the same CPU core as long as any zoned writes are pending.
>   - A new member 'from_cpu' is introduced in the per-zone data structure
>     'blk_zone_wplug' to track from which CPU to submit zoned writes. This data
>     member is reset to -1 after all pending zoned writes for a zone have
>     completed.
>   - The retry count for zoned writes is increased in the SCSI core to deal with
>     reordering caused by unit attention conditions or the SCSI error handler.
>   - New functionality is added in the null_blk and scsi_debug drivers to make it
>     easier to test the changes introduced by this patch series.
> 
> Please consider this patch series for the next merge window.
> 
Before we're doing yet another round here, have you checked whether
the patchset from Yu Kuai ("PATCH RFC v2 00/10: block: fix disordered IO 
in the case of recurse split") does help in your case, too?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
