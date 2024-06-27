Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028547484;
	Thu, 27 Jun 2024 06:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469840; cv=none; b=DNpwyFV+/j1afsimc7EbbLav9P7Vi235UO5N4dwJfRBs48b22QH48mZZ72UdEiK7HlQA51dhd2kRJ5yg3Pxnj1jB/+5vV8c7iI2+65gVrZN1Ddy/TSMyv0bYRM40viZhn9XPsa5Sfny6BuDxTq1J3+QzkpJ71uVtK9eJNmlxG4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469840; c=relaxed/simple;
	bh=8WtXSEEFe99ZintW8TAvBt9W+OTxTb56DnnM9m+tKCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MQD+dFKD9V2Jm8Kp6XWlaVuS7Ag9btdkHAb9PylphU2ZKZ9GrcBEu2wte9G3BQX+giLGr/sUYBrpgYgBLT6roUpwL/nOKa0wNKBbD4rfiiOpmvk/MgEfMsG2OnsJmntRd5BKPvBiOq3RI5mycQaqZF4FtM6ZbT+45hDOaDdJOso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Es5SRr5e; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Scke7xcS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Es5SRr5e; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Scke7xcS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Es5SRr5e";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Scke7xcS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Es5SRr5e";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Scke7xcS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D1DB1FBA7;
	Thu, 27 Jun 2024 06:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LiK0tcQnaZvG4zw4LwmG2wVe39gPUi/Pb225mqKilqk=;
	b=Es5SRr5eaGh2FtOp3fp6eZgzGbmfOK3potXKv+PpsbpOBYEiRdJfVeCjCFvzvp6YGum1GN
	WCtGF/5tZ59XF5iw4vut/92FUWPw4d/AzK14gzwZamdd1uT186inKtIeZfHSpJ3SRdehZr
	3nBeXFgum8s945DFCaQCmCJ9QAuE35M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LiK0tcQnaZvG4zw4LwmG2wVe39gPUi/Pb225mqKilqk=;
	b=Scke7xcSXYV4f8MBh19f0fYXv1R5h5mhA9zYfK4Up/fHqcsMruPw1cQ8k4o69V1Z5k28F6
	xcRNFa7aE10MgIAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Es5SRr5e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Scke7xcS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LiK0tcQnaZvG4zw4LwmG2wVe39gPUi/Pb225mqKilqk=;
	b=Es5SRr5eaGh2FtOp3fp6eZgzGbmfOK3potXKv+PpsbpOBYEiRdJfVeCjCFvzvp6YGum1GN
	WCtGF/5tZ59XF5iw4vut/92FUWPw4d/AzK14gzwZamdd1uT186inKtIeZfHSpJ3SRdehZr
	3nBeXFgum8s945DFCaQCmCJ9QAuE35M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LiK0tcQnaZvG4zw4LwmG2wVe39gPUi/Pb225mqKilqk=;
	b=Scke7xcSXYV4f8MBh19f0fYXv1R5h5mhA9zYfK4Up/fHqcsMruPw1cQ8k4o69V1Z5k28F6
	xcRNFa7aE10MgIAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49333137DF;
	Thu, 27 Jun 2024 06:30:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8Ac2DgwHfWa2aAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:30:36 +0000
Message-ID: <b9b1f10f-48af-4350-b02b-aa9924a33d4c@suse.de>
Date: Thu, 27 Jun 2024 08:30:36 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] ata,scsi: libata-core: Add ata_port_free()
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-20-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-20-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D1DB1FBA7
X-Spam-Score: -4.50
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/26/24 20:00, Niklas Cassel wrote:
> Add a function, ata_port_free(), that is used to free a ata_port.
> It makes sense to keep the code related to freeing a ata_port in its own
> function, which will also free all the struct members of struct ata_port.
> 
> libsas is currently not freeing all the struct ata_port struct members,
> e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c          | 19 +++++++++++++------
>   drivers/scsi/libsas/sas_ata.c      |  2 +-
>   drivers/scsi/libsas/sas_discover.c |  2 +-
>   include/linux/libata.h             |  1 +
>   4 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index c916cbe3e099..591020ea8989 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5490,6 +5490,18 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
>   	return ap;
>   }
>   
> +void ata_port_free(struct ata_port *ap)
> +{
> +	if (!ap)
> +		return;
> +
> +	kfree(ap->pmp_link);
> +	kfree(ap->slave_link);
> +	kfree(ap->ncq_sense_buf);
> +	kfree(ap);
> +}
> +EXPORT_SYMBOL_GPL(ata_port_free);
> +
>   static void ata_devres_release(struct device *gendev, void *res)
>   {
>   	struct ata_host *host = dev_get_drvdata(gendev);
> @@ -5518,12 +5530,7 @@ static void ata_host_release(struct kref *kref)
>   	for (i = 0; i < host->n_ports; i++) {
>   		struct ata_port *ap = host->ports[i];
>   
> -		if (ap) {
> -			kfree(ap->pmp_link);
> -			kfree(ap->slave_link);
> -			kfree(ap->ncq_sense_buf);
> -			kfree(ap);
> -		}
> +		ata_port_free(ap);
>   		host->ports[i] = NULL;
>   	}
>   	kfree(host);

Can't you squish this into the first patch?

Otherwise looks good.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

