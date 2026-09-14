Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273BD41DDE1;
	Mon, 14 Sep 2026 09:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377484; cv=none; b=Ou2iY7ZO4oIm1xgx8XBf96wOvctJXR3nnohM4Y+IRAp5Hgcj+HvwfT+YVutb4Ll1IZoo0j2XMqcxOxkE7dU2rOeY32Ovvwbo1Ud1M0Eekg13dshMIdderZFqiGMNQnlV4okdb+fyNNyTUBaUOblikOaREIsnRUv+qgXCnpdH1kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377484; c=relaxed/simple;
	bh=1m+U1m5FNizso74tA+oB8cWR7xF3X6JH6AIdNVozOQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GxNISClS+LJhjvNl3Vs9kqkyLPHCZiRuHN7K+3zcpJ6DotTI+n9kRqHl5s+6ytkCk+6hvGnSn7d03O0UfQ4zxsbgqAzzeIJAXTXwVrkhBshcP/fhzk1Uv+dKeK8W1FibDa1EhT2HCaLpUz/99cZA5TvpQQ4Y1WrjJhAHirx/wR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QBBD1Ch6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xquDvs4X; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j4vvTSt1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=20JZrJDa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QBBD1Ch6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xquDvs4X";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j4vvTSt1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="20JZrJDa"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0A8B91F848;
	Mon, 14 Sep 2026 09:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789377477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJoiPzJFbz/5ZchkpM/8m7FPSNUAGoIO5bwJam26yNE=;
	b=QBBD1Ch6otKicYpxRMCRKP/C/LRIh1XfaGUiQM4aJk7FHyj6u1i79R4fttTVopgMp3T8om
	qt2hv3Z8kTHLUM4JHwdGrY+7R5MpsSxW8Ri4mVqueAotcEK1gtozv2VAWkrtEucqhm0jIr
	pRgogvgE5AbkL6n5GsL+OIno/t8tmOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789377477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJoiPzJFbz/5ZchkpM/8m7FPSNUAGoIO5bwJam26yNE=;
	b=xquDvs4XJYhWeI+wIF7vo+VInbwvzF9fF3aRvQz6NGQ1nq0l/kswFG6YjNMnVM9vXFm27X
	toco/RxcQeQhXdAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j4vvTSt1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=20JZrJDa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789377473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJoiPzJFbz/5ZchkpM/8m7FPSNUAGoIO5bwJam26yNE=;
	b=j4vvTSt1zOFA5msdUyDh2kok70dkVLUmQvGBS+BbhG4oFk/jysePuKzZ2GWaPPF6rouNnS
	iTG4PTGkn0LcVqc0AbCQ+7Aar2UMA39TkCizOOQZOp4NIw+CpaKm5gYe40MDjZX9hGzXeo
	b9gK2RQc/lvyRn6yXa/6c+UY+7Zmuts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789377473;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJoiPzJFbz/5ZchkpM/8m7FPSNUAGoIO5bwJam26yNE=;
	b=20JZrJDayxJSZ83CzmgzZjDFVNAaE9hAKEf5lDe3GRbwfY6256C0Q4PzwKwMlxIAO5j95z
	CIXk1DPInU5z1XAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C307E1368C;
	Mon, 14 Sep 2026 09:17:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h64pL8C7p2o7TAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 14 Sep 2026 09:17:52 +0000
Message-ID: <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
Date: Mon, 14 Sep 2026 11:17:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] scsi: virtio_scsi: bound EH timer resets to avoid
 unkillable hang
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, mst@redhat.com,
 jasowangio@gmail.com, mkp@kernel.org, James.Bottomley@HansenPartnership.com
Cc: pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, sashiko-bot@kernel.org
References: <20260911163509.684191F000FF@smtp.kernel.org>
 <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 0A8B91F848
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,redhat.com,kernel.org,HansenPartnership.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/11/26 6:44 PM, Nguyen Ngoc Thang wrote:
> Thank you for the review -- the eh_host_reset_handler finding is correct,
> and the underlying mechanism is worse than a stale read.
> 
> Once virtscsi_eh_timed_out() lets SCSI EH run to completion on an
> unresponsive host, scsi_eh_bus_device_reset() leaves the command in
> work_q (device reset fails the same way abort does, via the same bounded
> virtscsi_tmf()), and since virtio_scsi implements neither
> eh_target_reset_handler, eh_bus_reset_handler nor eh_host_reset_handler,
> scsi_eh_target_reset()/scsi_eh_bus_reset()/scsi_eh_host_reset() all fail
> immediately (scsi_try_*_reset() return FAILED when the handler pointer is
> NULL) and the command falls through to scsi_eh_offline_sdevs(), which
> calls scsi_eh_finish_cmd() and frees the tag back to the block layer.
> 
[ .. ]
> 
> Happy to do the legwork on whichever direction you point at -- I have a
> QEMU virtio-scsi repro harness already wired up for the original hang
> (clearing PCI_COMMAND_MASTER mid-write) that I can extend to exercise
> the recovery path too.
> 
In short: you can't.
The linux kernel lacks the ability to abort an outstanding I/O from 
userspace; userspace (and that includes qemu) _has_ to wait for that
I/O to return.
Otherwise there is no guarantee that the DMA regions of that command
are ever freed, and the kernel can happily scribble over memory which
userspace already assumed to be free. As these DMA regions are mapped
into the qemu guest you essentially allow the kernel to overwrite guest
memory at any time.
Not a good idea.

In general: SCSI host_reset _is_ the bug hammer. If that doesn't work
(for whatever reason) you system is hosed as you can _never_ get the
memory and DMA regions of outstanding commands back to the system.
So the better fix would be to implement a host_reset() callback for
virtio-scsi which would reset the virtio setup, terminating all
outstanding commands and reset the queues.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
