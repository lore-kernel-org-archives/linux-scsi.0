Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8652127A130
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 06:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764226783; cv=none; b=BQYxvIVYwWDCuC/2AGkS/7iamAJZFkR1R3xljubk/eXBoNnlVnNqy2pfgiiPci8ovlYnUOttDN3XKT8vdzRYBDkWE4n7qwhqLIqj9STU1ERnmFtqU1lp6RsAJFDeqkz8G+8hXji6xBUDqBgtiEDwjzXvQP+b+wDPCh+4HXT7GuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764226783; c=relaxed/simple;
	bh=Q8B4dr0F2jhH+6ZSNM3Jm0o5s++d63d6QYi23gNTU54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X08hmTRPsSZFjxHNahYS0a51k5ztUajiZLT+3unKXrr0Srj+P8/BSlJgAFOTDxHR7Pj3lOG8zvQ41lE3hI1OiKTTFf446H1jv4Yzs3tvPWH372zjL7omZw/eTYli5mWghjjlUeyq+nu3f4Ygs98NYqJKYY3Uy7Acx4DAFqyDJUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P5aMKMwX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JQhnohtU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P5aMKMwX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JQhnohtU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P5aMKMwX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JQhnohtU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P5aMKMwX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JQhnohtU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 933FE22D40;
	Thu, 27 Nov 2025 06:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764226779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HeqQZW1gX+eEv4L7CXQt3MYXZqQUQ+f3DaDi/otRfsM=;
	b=P5aMKMwXN19E9s86LvC6ZDdK6eZeNuhjZUmL3tzmzIeH4DPNnOXapbP6FEyuALD6ExxJ72
	Hgxm7HeeD3aev/kLIF4qlg8XMFBUJK2BYsOa3KcQ+72K6rVvTIBbr8cWgA/rvuPPx9eG01
	f2bHuPryBpVHrUQ0ROE3UjrDsk+TPJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764226779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HeqQZW1gX+eEv4L7CXQt3MYXZqQUQ+f3DaDi/otRfsM=;
	b=JQhnohtUhvs78M0rQyC0M0xVHLPmhEWy/9ggqI4atG4QVLgdzy0PZa0WKHEmkEz30tYvWA
	WbpUf5ISn98nMbCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P5aMKMwX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JQhnohtU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764226779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HeqQZW1gX+eEv4L7CXQt3MYXZqQUQ+f3DaDi/otRfsM=;
	b=P5aMKMwXN19E9s86LvC6ZDdK6eZeNuhjZUmL3tzmzIeH4DPNnOXapbP6FEyuALD6ExxJ72
	Hgxm7HeeD3aev/kLIF4qlg8XMFBUJK2BYsOa3KcQ+72K6rVvTIBbr8cWgA/rvuPPx9eG01
	f2bHuPryBpVHrUQ0ROE3UjrDsk+TPJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764226779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HeqQZW1gX+eEv4L7CXQt3MYXZqQUQ+f3DaDi/otRfsM=;
	b=JQhnohtUhvs78M0rQyC0M0xVHLPmhEWy/9ggqI4atG4QVLgdzy0PZa0WKHEmkEz30tYvWA
	WbpUf5ISn98nMbCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E7EC3EA63;
	Thu, 27 Nov 2025 06:59:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n/SjCdv2J2mdUwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Nov 2025 06:59:39 +0000
Message-ID: <a8173918-f0d2-42c7-82d8-3fa6ff944d5f@suse.de>
Date: Thu, 27 Nov 2025 07:59:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: sd: reject invalid pr_read_keys() num_keys
 values
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Mike Christie <michael.christie@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251126163600.583036-1-stefanha@redhat.com>
 <20251126163600.583036-2-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251126163600.583036-2-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email]
X-Spam-Level: 
X-Spam-Score: -4.51
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 933FE22D40
X-Rspamd-Action: no action
X-Spam-Flag: NO

On 11/26/25 17:35, Stefan Hajnoczi wrote:
> The pr_read_keys() interface has a u32 num_keys parameter. The SCSI
> PERSISTENT RESERVE IN command has a maximum READ KEYS service action
> size of 65536 bytes. Reject num_keys values that are too large to fit
> into the SCSI command.
> 
> This will become important when pr_read_keys() is exposed to untrusted
> userspace via an <linux/pr.h> ioctl.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   drivers/scsi/sd.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 0252d3f6bed17..d65646f35f453 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1974,9 +1974,18 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info)
>   {
>   	int result, i, data_offset, num_copy_keys;
>   	u32 num_keys = keys_info->num_keys;
> -	int data_len = num_keys * 8 + 8;
> +	int data_len;
>   	u8 *data;
>   
> +	/*
> +	 * Each reservation key takes 8 bytes and there is an 8-byte header
> +	 * before the reservation key list. The total size must fit into the
> +	 * 16-bit ALLOCATION LENGTH field.
> +	 */
> +	if (num_keys > (65536 - 8) / 8)

Odd coding. Maybe (USHRT_MAX / 8) - 1 ?

> +		return -EINVAL;
> +
> +	data_len = num_keys * 8 + 8;
>   	data = kzalloc(data_len, GFP_KERNEL);
>   	if (!data)
>   		return -ENOMEM;

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
