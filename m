Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF617484;
	Thu, 27 Jun 2024 06:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470413; cv=none; b=ODzzcGITSFAwVaDcygbWut8ELFrQLSP9u+0hF8y5Fljola48MqWjTMkVT3agES3FAzQ8E0gpk9z0TMHm0slC5Q4zd9teysUlz8yno2MmUbzYbRKUzm6sb4p6b4f6QfWVdE0S6cBHMR32FrCq/hlGlgqeB1kYM/N+v3EqRDeYpXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470413; c=relaxed/simple;
	bh=YM2iahnZ9CU9cq+5ijnAkqSXZ7Vh2AmKy5zxU9XtG/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N0eNJEb9P9ftpHMiPC6T3tWw3CTi/tYHcXf/Lelzhrmj7/xfU8wMLg6XoIMz/9bl7oCdJ/rqxPUx6W4a5pGQFNlRcJ1bX+5SQrJ+bEKNmB5zL6m1QAssrrQTL68ol10v7UdZZ+pbWUSdyBcN6fOHI/wtPp554NXrYXH24BQz4Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2CaPLZoU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aNKlG/ai; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2CaPLZoU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aNKlG/ai; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2CaPLZoU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aNKlG/ai";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2CaPLZoU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aNKlG/ai"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A6C421985;
	Thu, 27 Jun 2024 06:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7VB+E7K5Yu/tewztYf7aP+RmrYwOM0RzGQ4MXr4hTo=;
	b=2CaPLZoUCBW+/gcHueUOKw85tZKNrfbizsQf2anflNe6fsHeV49c4o5x/CGPtyAq7jfMx9
	iURV2C3EDNMs6a1KHCxpnPOHUJ+89mnop5DL4gimcv517ZYEzQ9YGauGqevzsBfZ+uRGA8
	nTThQs4bBlLjVWpSbG70vlOFmVEGwtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7VB+E7K5Yu/tewztYf7aP+RmrYwOM0RzGQ4MXr4hTo=;
	b=aNKlG/aikmDuvYb7bt+XA7lBqkUKSoToV1odgxnJAdPqKM4/9hI5Agp6eTKyhxrovSpXZ3
	yScbSXxftKMMMsBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2CaPLZoU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="aNKlG/ai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7VB+E7K5Yu/tewztYf7aP+RmrYwOM0RzGQ4MXr4hTo=;
	b=2CaPLZoUCBW+/gcHueUOKw85tZKNrfbizsQf2anflNe6fsHeV49c4o5x/CGPtyAq7jfMx9
	iURV2C3EDNMs6a1KHCxpnPOHUJ+89mnop5DL4gimcv517ZYEzQ9YGauGqevzsBfZ+uRGA8
	nTThQs4bBlLjVWpSbG70vlOFmVEGwtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7VB+E7K5Yu/tewztYf7aP+RmrYwOM0RzGQ4MXr4hTo=;
	b=aNKlG/aikmDuvYb7bt+XA7lBqkUKSoToV1odgxnJAdPqKM4/9hI5Agp6eTKyhxrovSpXZ3
	yScbSXxftKMMMsBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2290A1384C;
	Thu, 27 Jun 2024 06:40:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ADgyBEoJfWaAagAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:40:10 +0000
Message-ID: <07a912d0-c7a3-4ab4-a74d-01b399ecb7ee@suse.de>
Date: Thu, 27 Jun 2024 08:40:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] ata,scsi: Remove useless ata_sas_port_alloc()
 wrapper
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-27-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-27-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 8A6C421985
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Spam-Level: 

On 6/26/24 20:00, Niklas Cassel wrote:
> Now when the ap->print_id assignment has moved to ata_port_alloc(),
> we can remove the useless ata_sas_port_alloc() wrapper.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c     |  1 +
>   drivers/ata/libata-sata.c     | 35 -----------------------------------
>   drivers/ata/libata.h          |  1 -
>   drivers/scsi/libsas/sas_ata.c | 10 ++++++++--
>   include/linux/libata.h        |  3 +--
>   5 files changed, 10 insertions(+), 40 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

