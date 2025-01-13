Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388F0230D1C;
	Mon, 13 Jan 2025 07:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752303; cv=none; b=flcd56czLAOxAVAFqPEetQJxpcfZ3zBINY8els4eAy6Z6ad+chq1IE3ZUr+oeDDscKVUmCdp6CVAdmd2CBx9VQ0IPryQ3wezSbpuGET0ipBPz42AIbjtk77E7eTiPFf+Z9V0HbQYVSstMde1iBmboMXIrXx7ajlZLZzpT7Qtenc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752303; c=relaxed/simple;
	bh=ijWIBu5qKvIuru6O4gWbyKv0lLmqPVSYaFUjQrliE5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OMeNYQRTwlqk3v/8k4hX+hg28HvRvsRM6c8r1HuUD0D2ttZS37uXqhIdic/V1QKZjdZ/CqrYwRTqZpapvQn1bE/9sjhUU2omfUrAi/FBJd3q3QdZ0rMAvUkTm6uIUI6heRM2MVzgSg4cgC7RXQv3axNk0gNDFb/4S9phUSiio0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1VBOYfQs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qEDxEnIY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1VBOYfQs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qEDxEnIY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1VBOYfQs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qEDxEnIY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1VBOYfQs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qEDxEnIY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62F062115E;
	Mon, 13 Jan 2025 07:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYbX/qmEoqUt7H7blkrv+2RbE6JCseGRge7shAs2s9A=;
	b=1VBOYfQsALUTcnGDEQyYcsP2XCJXf+yXlpGaEsDDjpeK5ksbd4FQtKVc+sgLKsb5JbgLJN
	9ETQwaOmmfoVrqY2L1qef5XJbcEPzxm/vcwE8aTMrF+wEK4uXksPTLqgyuj1bhervvZl5E
	FPbZemL+ffy3KMlLU2lKJ+axnx8faBc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752300;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYbX/qmEoqUt7H7blkrv+2RbE6JCseGRge7shAs2s9A=;
	b=qEDxEnIYZfkJQraGiKUoP3PsleF3nfYBa0QwBozC/OaNKx09i5yk6XEauuK7i+Es97mwgQ
	yrpj6bttToAqCuBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1VBOYfQs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qEDxEnIY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYbX/qmEoqUt7H7blkrv+2RbE6JCseGRge7shAs2s9A=;
	b=1VBOYfQsALUTcnGDEQyYcsP2XCJXf+yXlpGaEsDDjpeK5ksbd4FQtKVc+sgLKsb5JbgLJN
	9ETQwaOmmfoVrqY2L1qef5XJbcEPzxm/vcwE8aTMrF+wEK4uXksPTLqgyuj1bhervvZl5E
	FPbZemL+ffy3KMlLU2lKJ+axnx8faBc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752300;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYbX/qmEoqUt7H7blkrv+2RbE6JCseGRge7shAs2s9A=;
	b=qEDxEnIYZfkJQraGiKUoP3PsleF3nfYBa0QwBozC/OaNKx09i5yk6XEauuK7i+Es97mwgQ
	yrpj6bttToAqCuBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4D7013876;
	Mon, 13 Jan 2025 07:11:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dBGqJqu8hGfFKgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:11:39 +0000
Message-ID: <a7cd43e3-fac8-4917-8dc6-e2e8ba6cc797@suse.de>
Date: Mon, 13 Jan 2025 08:11:39 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/9] virtio: blk/scsi: use block layer helpers to
 calculate num of queues
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev,
 GR-QLogic-Storage-Upstream@marvell.com
References: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
 <20250110-isolcpus-io-queues-v5-5-0e4f118680b0@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250110-isolcpus-io-queues-v5-5-0e4f118680b0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62F062115E
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 1/10/25 17:26, Daniel Wagner wrote:
> Multiqueue devices should only allocate queues for the housekeeping CPUs
> when isolcpus=managed_irq is set. This avoids that the isolated CPUs get
> disturbed with OS workload.
> 
> Use helpers which calculates the correct number of queues which should
> be used when isolcpus is used.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   drivers/block/virtio_blk.c | 5 ++---
>   drivers/scsi/virtio_scsi.c | 1 +
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
