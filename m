Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C4936C5B6
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820046; cv=none; b=bnv9O2BUn9jGDqLQGxbs4RJy8p9eAtabw2p+MbzKmXOJ/81yEXioTbw81T0OCj21Ilgb/coOT43rYiYLMKfd2VE0EonJI4WuRWOgcIroDas3F3zBN3UbaSsUUxwJy3lKu5XW2TVxGo9SqBBw8pawrhsE0Sq6qHuxmr0h5HyfORU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820046; c=relaxed/simple;
	bh=+lZUvICpL9gtUN2Elt9HmjBXjmfgP5GVh9n6pD6MK+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RIl+wTQ00YjTxoh/ga7P7RfLIEH07uXeJziIeoy6VoYBc+79uY7da/VXgTJACjhXnNTZWWlo57UllwwVG76MzTc5Ka6FiMZtMDIvSVz6mS3ZW911+6FEwh9/sdVmYNCYL8CXFo+CpsLpI7BVpdpPblary0Jz+8vsBDmlN0wR4pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Il6QbHjx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+tq3P4qO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h1KrpRhT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LN/wM5BO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Il6QbHjx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+tq3P4qO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="h1KrpRhT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LN/wM5BO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 543904D3DA;
	Wed, 18 Mar 2026 07:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqdoGi+GbfPDFsEqwGpoJq9a4pvVW8Ucqfydr5LlJwE=;
	b=Il6QbHjxapnOf83lfxBGQlF3Qv+wcvLkAksVXcnS5gisAi4XHRNwusxo9JVfgkO2WwinjT
	yqKFUdjpIE3W5wRniHP4Gw4ubWk6m1ASekbCVQ62agZ8Eh6YbgV+UkCAV+v7eHcKJANBBB
	Bqp+o3KyRSSrvj7PyqOenUPp1/Jhe6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqdoGi+GbfPDFsEqwGpoJq9a4pvVW8Ucqfydr5LlJwE=;
	b=+tq3P4qOIKeTaP/e1lkOcuIDv7j7uhizpYxHV7piEOQrkXNyVISk1M8+pV8kYF6Wyau2IG
	b2W76itHTh53YfCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h1KrpRhT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="LN/wM5BO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqdoGi+GbfPDFsEqwGpoJq9a4pvVW8Ucqfydr5LlJwE=;
	b=h1KrpRhTSIRSRDVyQZq927oLMhxBfmMX/LqJTLTaiuHJ9zDy1c/LFxPEEIBRWLlA4k4Tcn
	k6LURUjWMKKcbGJJ726m/8M7tXkMJHWYmnlXQCsWl2wZ+xP+TM87Il58FAa5QrlmFEObiS
	h+8sTXuK8pCYeYaQMTwM6Z0RzWQBUdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqdoGi+GbfPDFsEqwGpoJq9a4pvVW8Ucqfydr5LlJwE=;
	b=LN/wM5BOmn6RfyJkcvEPT0963ZqDkjYWbP3sMrirLb/vc18H7ur1NMbl2BCbHkhxLrdta4
	ANA+uDfju+Ipu0Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F143E4273B;
	Wed, 18 Mar 2026 07:47:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SjlSOYlYummTQwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Mar 2026 07:47:21 +0000
Message-ID: <25fd3a82-2a0e-4279-aed5-30c9b6f0a107@suse.de>
Date: Wed, 18 Mar 2026 08:47:17 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] scsi: alua: Create a core ALUA driver
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260317120703.3702387-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 543904D3DA
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 3/17/26 13:06, John Garry wrote:
> Add a dedicated ALUA driver which can be used for native SCSI multipath
> and also DH-based ALUA support.
> 
Is this really a 'driver'? It's more additional functionality for a SCSI
device, and not really a driver.
At least I _think_ it is ...

> The core driver will provide ALUA support for when a scsi_device does not
> have a DH attachment.
> 
> The core driver will provide functionality to handle RTPG and STPG, but
> the scsi DH ALUA driver will be responsible for driving these when DH
> attached.
> 
> New structure alua_data holds all ALUA-related scsi_device info.
> 
> Hannes Reinecke originally authored the kernel ALUA code.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/Kconfig                | 10 +++-
>   drivers/scsi/Makefile               |  1 +
>   drivers/scsi/device_handler/Kconfig |  1 +
>   drivers/scsi/scsi.c                 |  7 +++
>   drivers/scsi/scsi_alua.c            | 78 +++++++++++++++++++++++++++++
>   drivers/scsi/scsi_scan.c            |  4 ++
>   drivers/scsi/scsi_sysfs.c           |  3 ++
>   include/scsi/scsi_alua.h            | 45 +++++++++++++++++
>   include/scsi/scsi_device.h          |  1 +
>   9 files changed, 149 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/scsi/scsi_alua.c
>   create mode 100644 include/scsi/scsi_alua.h
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 19d0884479a24..396cc0fda9fcc 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -76,8 +76,16 @@ config SCSI_LIB_KUNIT_TEST
>   
>   	  If unsure say N.
>   
> -comment "SCSI support type (disk, tape, CD-ROM)"
> +config SCSI_ALUA
> +	tristate "SPC-3 ALUA support"
>   	depends on SCSI
> +	help
> +	  SCSI support for generic SPC-3 Asymmetric Logical Unit
> +	  Access (ALUA).
> +
> +	  If unsure, say Y.
> +
> +comment "SCSI support type (disk, tape, CD-ROM)"
>   
>   config BLK_DEV_SD
>   	tristate "SCSI disk support"
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 16de3e41f94c4..90c25f36ea3a8 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -153,6 +153,7 @@ obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
>   
>   obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
>   
> +obj-$(CONFIG_SCSI_ALUA) += scsi_alua.o
>   # This goes last, so that "real" scsi devices probe earlier
>   obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
>   scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
> diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/device_handler/Kconfig
> index 368eb94c24562..ff06aea8c272c 100644
> --- a/drivers/scsi/device_handler/Kconfig
> +++ b/drivers/scsi/device_handler/Kconfig
> @@ -35,6 +35,7 @@ config SCSI_DH_EMC
>   config SCSI_DH_ALUA
>   	tristate "SPC-3 ALUA Device Handler"
>   	depends on SCSI_DH && SCSI
> +	select SCSI_ALUA
>   	help
>   	  SCSI Device handler for generic SPC-3 Asymmetric Logical Unit
>   	  Access (ALUA).
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 76cdad063f7bc..fc90ee19bb962 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -58,6 +58,7 @@
>   #include <linux/unaligned.h>
>   
>   #include <scsi/scsi.h>
> +#include <scsi/scsi_alua.h>
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_dbg.h>
>   #include <scsi/scsi_device.h>
> @@ -1042,12 +1043,17 @@ static int __init init_scsi(void)
>   	error = scsi_sysfs_register();
>   	if (error)
>   		goto cleanup_sysctl;
> +	error = scsi_alua_init();
> +	if (error)
> +		goto cleanup_sysfs;
>   
>   	scsi_netlink_init();
>   
>   	printk(KERN_NOTICE "SCSI subsystem initialized\n");
>   	return 0;
>   
> +cleanup_sysfs:
> +	scsi_sysfs_unregister();
>   cleanup_sysctl:
>   	scsi_exit_sysctl();
>   cleanup_hosts:
> @@ -1066,6 +1072,7 @@ static int __init init_scsi(void)
>   static void __exit exit_scsi(void)
>   {
>   	scsi_netlink_exit();
> +	scsi_exit_alua();
>   	scsi_sysfs_unregister();
>   	scsi_exit_sysctl();
>   	scsi_exit_hosts();
> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> new file mode 100644
> index 0000000000000..a5a67c6deff17
> --- /dev/null
> +++ b/drivers/scsi/scsi_alua.c
> @@ -0,0 +1,78 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Generic SCSI-3 ALUA SCSI driver
> + *
> + * Copyright (C) 2007-2010 Hannes Reinecke, SUSE Linux Products GmbH.
> + * All rights reserved.
> + */
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_proto.h>
> +#include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_alua.h>
> +
> +#define DRV_NAME "alua"
> +
> +static struct workqueue_struct *kalua_wq;
> +
> +int scsi_alua_sdev_init(struct scsi_device *sdev)
> +{
> +	int rel_port, ret, tpgs;
> +
> +	tpgs = scsi_device_tpgs(sdev);
> +	if (!tpgs)
> +		return 0;
> +
> +	sdev->alua = kzalloc(sizeof(*sdev->alua), GFP_KERNEL);
> +	if (!sdev->alua)
> +		return -ENOMEM;
> +

Why do you allocate a separate structure?
Is this structure shared with something?
Wouldn't it be better to just add some field to the scsi_device?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
