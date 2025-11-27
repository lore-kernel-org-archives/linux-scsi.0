Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EBB2FB08A
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764266772; cv=none; b=me6eK4XDBRnJGMZ1m7nHPxIKTvHu0FTQhWa0Dd1ZTcdPUHq5t5swNAMMOiqvaZN4mG5Cvd8J56y6F+eCLBTi4TRmxyKi1kyGZRlVwluzG+pbED5z0HWjb8XVgygL/Y9WGp1A9yEAGuyKp2mR6WevGtJ/3Mz2WvvFlVomswbxXYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764266772; c=relaxed/simple;
	bh=04DaDUhXNsL9tB1E7rNDR6x/3UYMPAAxs8KSeqPmtHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XsotX+iO/M/pAGOYoVC1munzJ/dc4sDEo241Tt2WFZyK+7mWT4MjWd/2wTruIzH3sKuYHFJsFwl1IrQznnDr4jL7YZ2g9P9BOADMn1UHD87/OaPotr2KxTmxtIPaF2N4h02daj1zoRhaALqo3I6hzHHT7ttVwEeqWJMXmh4TVmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eDwVqPug; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nyEpEwLG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z64jjw/A; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NOidA1nK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eDwVqPug";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nyEpEwLG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z64jjw/A";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NOidA1nK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E86CF21B79;
	Thu, 27 Nov 2025 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764266769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtPV73G1Gp2Zh/9LF576yL4TOvZh3DIdUlCNi+QIn3E=;
	b=eDwVqPuggRg/XX1/Z/BMaMeLT29HPipLKT34qWhB9RjfBWijfA6NccqItpkCdA+e7kQfuN
	FiSzDIabvTBCM9jeZWCbywYdokVFJc//fI9F/ZN3W1/xesW/G5Fy9VSIFwzs5FM0gwyDLd
	Are+R1ZTmkAg98NsUW19UNDFcdBPnaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764266769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtPV73G1Gp2Zh/9LF576yL4TOvZh3DIdUlCNi+QIn3E=;
	b=nyEpEwLG645aFKh7amuLorS3TpQQAg2VO5dyGctpgi99ik72v1mveK97BeVNQXb1q9GCpV
	U0hyfMVCne791XAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="z64jjw/A";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NOidA1nK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764266767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtPV73G1Gp2Zh/9LF576yL4TOvZh3DIdUlCNi+QIn3E=;
	b=z64jjw/A8ZnuUVpqYsntVpXGchFJv9tII2uyOB1k4daPX06DcEW0PQIIGbb7w66f7gCHtA
	DVTxsXfXPY40FDswEV7HA6XDgFEsp1I0m4N4H5u3sWx6p6Hd6NxPoK4AtvHrcrdSQbH2uf
	IQCZrdP6h9siaJPLMWsR4PnB37NJI+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764266767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtPV73G1Gp2Zh/9LF576yL4TOvZh3DIdUlCNi+QIn3E=;
	b=NOidA1nKby2hwrXeYSunjs7dDiDZPzIJxNx46aJVO9p/FnhgvhT03anmjROPWEKLH/CHmH
	6oKNpfogW5Hgt/AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 845E23EA63;
	Thu, 27 Nov 2025 18:06:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W9alHg+TKGmAYAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Nov 2025 18:06:07 +0000
Message-ID: <4ea9e53e-6618-4821-8002-7dc5d1b7194a@suse.de>
Date: Thu, 27 Nov 2025 19:06:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] block: add IOC_PR_READ_KEYS ioctl
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Christoph Hellwig <hch@lst.de>, Mike Christie <michael.christie@oracle.com>,
 linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
References: <20251127155424.617569-1-stefanha@redhat.com>
 <20251127155424.617569-4-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251127155424.617569-4-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim];
	URIBL_BLOCKED(0.00)[suse.de:mid,suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E86CF21B79

On 11/27/25 16:54, Stefan Hajnoczi wrote:
> Add a Persistent Reservations ioctl to read the list of currently
> registered reservation keys. This calls the pr_ops->read_keys() function
> that was previously added in commit c787f1baa503 ("block: Add PR
> callouts for read keys and reservation") but was only used by the
> in-kernel SCSI target so far.
> 
> The IOC_PR_READ_KEYS ioctl is necessary so that userspace applications
> that rely on Persistent Reservations ioctls have a way of inspecting the
> current state. Cluster managers and validation tests need this
> functionality.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   include/uapi/linux/pr.h |  7 +++++
>   block/ioctl.c           | 59 +++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 66 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
