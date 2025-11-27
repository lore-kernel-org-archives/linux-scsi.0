Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACAD313E0F
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227230; cv=none; b=ouEzj+yFwqZVMjoBtN1YUkryJ7kWzySf12fEKyTsop7s40w8aHyl7qzfGLBgYiFriXkFeTPedrnIHqBXKnx51Bg9cLysNoLcN3lzcUMXhQ1+dQwjhPC1VDUfpeRuLaMO1EiNW3mC3NFGWIWsihAewcFOpCZzbhudsce9E2GV0zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227230; c=relaxed/simple;
	bh=JtCS+oaUuF04ZseEi6kavAIZr/UbfteXiWeaJu6j1V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YN3vLOpRYkobZ3X+i6YBETnDjJfxa7TaFtEw84s4b5T4MQW0sCBfKj+MQqQdOA9nwGsR66md2EFLmYLfE6s4PYqy9x6M3v3mGU7DDEVzECJXZTC2Lf9R+zvu/0GEJWgkKCP55OoHIwpfv76GcJzlNxMdt0//OMsA+6jfBhiMLRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IDkeeXOI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bkKEB8mc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IDkeeXOI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bkKEB8mc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IDkeeXOI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bkKEB8mc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IDkeeXOI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bkKEB8mc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 326FA33691;
	Thu, 27 Nov 2025 07:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764227225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1qzYYJ7kwZAUUmOs9r7CidtfwqOqZeh6mEQUeiWGMo=;
	b=IDkeeXOIlx2+i0NeWHPWuXdpyT58dSWbFsMMM3mnerqf9Jqi+CWdspkKgT7hdlSvRQsYmY
	+Tda0UKX+w1Udc+dQo17RQZvqf3oLZlPmKV7ASpF+LG5yWJakmls5TcGszKPGFdObrnekO
	MVLjokItJyWw6U6fJx+99hG00tngUwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764227225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1qzYYJ7kwZAUUmOs9r7CidtfwqOqZeh6mEQUeiWGMo=;
	b=bkKEB8mcmIS5ERjtqI6phWLbfsCKAgN3cJTfc2hfT2vfuZ2qPHLmZdQFsUIp56I9v+Qa6/
	UrWJ8n40v8dgW/Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764227225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1qzYYJ7kwZAUUmOs9r7CidtfwqOqZeh6mEQUeiWGMo=;
	b=IDkeeXOIlx2+i0NeWHPWuXdpyT58dSWbFsMMM3mnerqf9Jqi+CWdspkKgT7hdlSvRQsYmY
	+Tda0UKX+w1Udc+dQo17RQZvqf3oLZlPmKV7ASpF+LG5yWJakmls5TcGszKPGFdObrnekO
	MVLjokItJyWw6U6fJx+99hG00tngUwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764227225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1qzYYJ7kwZAUUmOs9r7CidtfwqOqZeh6mEQUeiWGMo=;
	b=bkKEB8mcmIS5ERjtqI6phWLbfsCKAgN3cJTfc2hfT2vfuZ2qPHLmZdQFsUIp56I9v+Qa6/
	UrWJ8n40v8dgW/Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AA6E3EA63;
	Thu, 27 Nov 2025 07:07:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HX2xI5j4J2ntWgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Nov 2025 07:07:04 +0000
Message-ID: <cfd7cace-563b-4fcb-9415-72ac0eb3e811@suse.de>
Date: Thu, 27 Nov 2025 08:07:04 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: add IOC_PR_READ_KEYS ioctl
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Mike Christie <michael.christie@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251126163600.583036-1-stefanha@redhat.com>
 <20251126163600.583036-4-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251126163600.583036-4-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 11/26/25 17:35, Stefan Hajnoczi wrote:
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
>   include/uapi/linux/pr.h |  7 ++++++
>   block/ioctl.c           | 51 +++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 58 insertions(+)
> 
> diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
> index d8126415966f3..fcb74eab92c80 100644
> --- a/include/uapi/linux/pr.h
> +++ b/include/uapi/linux/pr.h
> @@ -56,6 +56,12 @@ struct pr_clear {
>   	__u32	__pad;
>   };
>   
> +struct pr_read_keys {
> +	__u32	generation;
> +	__u32	num_keys;
> +	__u64	keys_ptr;
> +};
> +
>   #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
>   
>   #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
> @@ -64,5 +70,6 @@ struct pr_clear {
>   #define IOC_PR_PREEMPT		_IOW('p', 203, struct pr_preempt)
>   #define IOC_PR_PREEMPT_ABORT	_IOW('p', 204, struct pr_preempt)
>   #define IOC_PR_CLEAR		_IOW('p', 205, struct pr_clear)
> +#define IOC_PR_READ_KEYS	_IOWR('p', 206, struct pr_read_keys)
>   
>   #endif /* _UAPI_PR_H */
> diff --git a/block/ioctl.c b/block/ioctl.c
> index d7489a56b33c3..e87c424c15ae9 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -1,5 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   #include <linux/capability.h>
> +#include <linux/cleanup.h>
>   #include <linux/compat.h>
>   #include <linux/blkdev.h>
>   #include <linux/export.h>
> @@ -423,6 +424,54 @@ static int blkdev_pr_clear(struct block_device *bdev, blk_mode_t mode,
>   	return ops->pr_clear(bdev, c.key);
>   }
>   
> +static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
> +		struct pr_read_keys __user *arg)
> +{
> +	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
> +	struct pr_keys *keys_info __free(kfree) = NULL;
> +	struct pr_read_keys inout;
> +	int ret;
> +
> +	if (!blkdev_pr_allowed(bdev, mode))
> +		return -EPERM;
> +	if (!ops || !ops->pr_read_keys)
> +		return -EOPNOTSUPP;
> +
> +	if (copy_from_user(&inout, arg, sizeof(inout)))
> +		return -EFAULT;
> +
> +	if (inout.num_keys > -sizeof(*keys_info) / sizeof(keys_info->keys[0]))
> +		return -EINVAL;
> +

0-sizeof()? What's that supposed to achieve? Plus inout.numkeys is 
unsigned (as the kbuild robot indicated).

> +	size_t keys_info_len = struct_size(keys_info, keys, inout.num_keys);
> +
> +	keys_info = kzalloc(keys_info_len, GFP_KERNEL);
> +	if (!keys_info)
> +		return -ENOMEM;
> +
> +	keys_info->num_keys = inout.num_keys;
> +
> +	ret = ops->pr_read_keys(bdev, keys_info);
> +	if (ret)
> +		return ret;
> +
> +	/* Copy out individual keys */
> +	u64 __user *keys_ptr = u64_to_user_ptr(inout.keys_ptr);
> +	u32 num_copy_keys = min(inout.num_keys, keys_info->num_keys);
> +	size_t keys_copy_len = num_copy_keys * sizeof(keys_info->keys[0]);

We just had the discussion about variable declarations on the ksummit 
lists; I really would prefer to have all declarations at the start of 
the scope (read: at the start of the function here).

> +
> +	if (copy_to_user(keys_ptr, keys_info->keys, keys_copy_len))
> +		return -EFAULT;
> +
> +	/* Copy out the arg struct */
> +	inout.generation = keys_info->generation;
> +	inout.num_keys = keys_info->num_keys;
> +
> +	if (copy_to_user(arg, &inout, sizeof(inout)))
> +		return -EFAULT;
> +	return ret;
> +}
> +
>   static int blkdev_flushbuf(struct block_device *bdev, unsigned cmd,
>   		unsigned long arg)
>   {
> @@ -644,6 +693,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
>   		return blkdev_pr_preempt(bdev, mode, argp, true);
>   	case IOC_PR_CLEAR:
>   		return blkdev_pr_clear(bdev, mode, argp);
> +	case IOC_PR_READ_KEYS:
> +		return blkdev_pr_read_keys(bdev, mode, argp);
>   	default:
>   		return blk_get_meta_cap(bdev, cmd, argp);
>   	Cheers,Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
