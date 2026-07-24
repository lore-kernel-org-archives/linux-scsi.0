Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72913939BD
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 06:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784875846; cv=none; b=A6N7jU5ojhvLuki6ZO51g8eBULMvRo3Fe7s9QSOeic9dcIOAC5bcZ8FWDOTqRakRbmA/XS0ZTu8et2RghEHcgSq+IcFUBrEUfAcjZCjAUX46Wh8BbnAvPC2GzY+WOvyPqv7pJ7gxOwRgPFG5GLmicFd8fv54fkStXN7EoyrP1Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784875846; c=relaxed/simple;
	bh=16bU0WrMwEyfHh5tvaf+npHAw/dPC2h0p1YZL9NlOr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ybsbs4nl96fi8Rx0otV/aBpFMZrwFYrF6ck2fD0/g1uiZW+VWZY9C51iEECJCQ3N0mDJKpxc4DWE5neGX2RPkbiEshb7hb9jwumP1XZmJ35qY1nsmjk+yQeT7FBL5jcZprhuAVGsK6tFEqZLmNrcmn1I/u03OFT4n/bDz42D6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1DF6ESVR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H5iSvW/Z; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h8X5sHhp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DwT+81od; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1DF6ESVR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H5iSvW/Z";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="h8X5sHhp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DwT+81od"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 83B5C7B5EE;
	Fri, 24 Jul 2026 06:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784875842; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+RSFpykKOUTqd7WkvOVrV3OPDMsttrf26+eOKjrsxM=;
	b=1DF6ESVREmpfuoc7+PkUn/2y2YWxyW6gRzWfNCcFcizXTlE7llEUe+9DPiTF9J/JLhh68R
	CLPM8TQZVamvUk6r4ZipOUxZFUkXZLofoVd+2P7QJBk2uyI+SElQuxPpeBI59TdtSfzNYc
	9WeVXTY3FEwECJTxZDWXVueHMPFIezY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784875842;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+RSFpykKOUTqd7WkvOVrV3OPDMsttrf26+eOKjrsxM=;
	b=H5iSvW/ZVn+7VdlHmyv5jIl/MeobbktNVs6i68Az8lS1JnkfJ9nDhhWsEptz8le3tQB+LB
	+kzUL7pKMrDX2/Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h8X5sHhp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DwT+81od
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784875841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+RSFpykKOUTqd7WkvOVrV3OPDMsttrf26+eOKjrsxM=;
	b=h8X5sHhp0NE0ljXkDrlh5LerVflX5t0P7q0wiHbrD7G/XSaxw04zLjixks0tNDVY+ZYQNE
	I7L1uqmisYCkdWBjMgORKiTIClt5YWYmMd3jPWurgrlQquGSH6R2CkGCt2lWshHr0LOFX6
	vpI8EMA3Lt5zhQoAjlKF313TJNUOiB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784875841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+RSFpykKOUTqd7WkvOVrV3OPDMsttrf26+eOKjrsxM=;
	b=DwT+81odnwWdvd/joqrKLy3V+4DqL5n7EshK+yWfS2V5J3zSdV3xQ4m4JN6UuI90OwbL+u
	uuouiuFSK/O6LHBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F217C779BA;
	Fri, 24 Jul 2026 06:50:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M1I0OUALY2qQFwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 24 Jul 2026 06:50:40 +0000
Message-ID: <ba62d294-6954-44d3-af79-6c7da33a5ccd@suse.de>
Date: Fri, 24 Jul 2026 08:50:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/28] libmultipath: Add initial framework
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com, john.garry@linux.dev, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260723093627.2327456-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 83B5C7B5EE
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[17];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,lst.de:email,suse.de:mid,suse.de:email,suse.de:dkim,oracle.com:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 7/23/26 11:35 AM, John Garry wrote:
> Add initial framework for libmultipath. libmultipath is a library for
> multipath-capable block drivers, such as NVMe. The main function is to
> support path management, path selection, and failover handling.
> 
> Basic support to add and remove the head structure - mpath_head - is
> included.
> 
> This main purpose of this structure is to manage available paths and path
> selection. It is quite similar to the multipath functionality in
> nvme_ns_head. It also manages the multipath gendisk.
> 
> Each path is represented by the mpath_device structure. It should hold a
> pointer to the per-path gendisk and also a list element for all siblings
> of paths. For NVMe, there would be a mpath_device per nvme_ns.
> 
> All the libmultipath code is more or less taken from
> drivers/nvme/host/multipath.c, which was originally authored by Christoph
> Hellwig <hch@lst.de>.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   include/linux/multipath.h | 28 +++++++++++++++++
>   lib/Kconfig               |  6 ++++
>   lib/Makefile              |  2 ++
>   lib/multipath.c           | 66 +++++++++++++++++++++++++++++++++++++++
>   4 files changed, 102 insertions(+)
>   create mode 100644 include/linux/multipath.h
>   create mode 100644 lib/multipath.c
> 
> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
> new file mode 100644
> index 0000000000000..e98b4b241020a
> --- /dev/null
> +++ b/include/linux/multipath.h
> @@ -0,0 +1,28 @@

Please add an SPDX tag.
And possibly a copyright.

> +
> +#ifndef _LIBMULTIPATH_H
> +#define _LIBMULTIPATH_H
> +
> +#include <linux/blkdev.h>
> +#include <linux/srcu.h>
> +
> +struct mpath_device {
> +	struct list_head	siblings;
> +	struct gendisk		*disk;
> +};
> +
> +struct mpath_head {
> +	struct srcu_struct	srcu;
> +	struct list_head	dev_list;	/* list of all mpath_devs */
> +	struct mutex		lock;
> +
> +	refcount_t		refcount;
> +
> +	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
> +};
> +
> +int mpath_get_head(struct mpath_head *mpath_head);
> +void mpath_put_head(struct mpath_head *mpath_head);
> +int mpath_head_init(struct mpath_head *mpath_head);
> +void mpath_head_uninit(struct mpath_head *mpath_head);
> +
> +#endif // _LIBMULTIPATH_H
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 55748b68714e0..d0258bef374a1 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -636,3 +636,9 @@ config UNION_FIND
>   
>   config MIN_HEAP
>   	bool
> +
> +config LIBMULTIPATH
> +	bool "MULTIPATH BLOCK DRIVER LIBRARY"
> +	depends on BLOCK
> +	help
> +	  If you say yes here then you get a multipath lib for block drivers
> diff --git a/lib/Makefile b/lib/Makefile
> index 7f75cc6edf94a..7ba5e13be4171 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -334,3 +334,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
>   obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
>   
>   subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
> +
> +obj-$(CONFIG_LIBMULTIPATH)	+= multipath.o
> diff --git a/lib/multipath.c b/lib/multipath.c
> new file mode 100644
> index 0000000000000..9cc398d266adf
> --- /dev/null
> +++ b/lib/multipath.c
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2017-2018 Christoph Hellwig.
A bit unusual, creating a new file and add a copyright
from _another_ person ...

> + * Copyright (c) 2026 Oracle and/or its affiliates.
> + */
> +#include <linux/module.h>
> +#include <linux/multipath.h>
> +
> +static struct workqueue_struct *mpath_wq;
> +
> +int mpath_get_head(struct mpath_head *mpath_head)
> +{
> +	if (!refcount_inc_not_zero(&mpath_head->refcount))
> +		return -ENXIO;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(mpath_get_head);
> +
> +void mpath_put_head(struct mpath_head *mpath_head)
> +{
> +	refcount_t *refcount = &mpath_head->refcount;
> +
> +	if (refcount_dec_and_test(&mpath_head->refcount))
> +		wake_up_var(refcount);
> +}
> +EXPORT_SYMBOL_GPL(mpath_put_head);
> +
> +void mpath_head_uninit(struct mpath_head *mpath_head)
> +{
> +	refcount_t *refcount = &mpath_head->refcount;
> +
> +	if (!refcount_dec_and_test(refcount))
> +		wait_var_event(refcount, !refcount_read(refcount));
> +	cleanup_srcu_struct(&mpath_head->srcu);
> +}
> +EXPORT_SYMBOL_GPL(mpath_head_uninit);
> +
> +int mpath_head_init(struct mpath_head *mpath_head)
> +{
> +	memset(mpath_head, 0, sizeof(*mpath_head));
> +	INIT_LIST_HEAD(&mpath_head->dev_list);
> +	mutex_init(&mpath_head->lock);
> +	refcount_set(&mpath_head->refcount, 1);
> +
> +	return init_srcu_struct(&mpath_head->srcu);
> +}
> +EXPORT_SYMBOL_GPL(mpath_head_init);
> +
> +static int __init mpath_init(void)
> +{
> +	mpath_wq = alloc_workqueue("mpath-wq",
> +			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
> +	if (!mpath_wq)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void __exit mpath_exit(void)
> +{
> +	destroy_workqueue(mpath_wq);
> +}
> +
> +module_init(mpath_init);
> +module_exit(mpath_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("libmultipath");

Otherwise:
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
