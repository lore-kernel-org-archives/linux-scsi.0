Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D400217BA2
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 13:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776863750; cv=none; b=T6FZnuwlBi15UQ4e/n0/PP7KE87YWy4BE1MOG4G7Y1MGXojKUVx/mO2hQF2KaM2UUJV3XZ6fU4bHfuWSa9CdVx142Kfy0i0+huoxmiM0UdRlcuHDegG7g/30fwxak0qcM4f8X/8b1vd5kfTAqyoN5jgkBU8cI8nTXdXCsgRLrac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776863750; c=relaxed/simple;
	bh=ajmAx5QnXGWOom4w9rQU6ozJvG7KJY0EMSZP3IZwbiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T5zCTiRuUa4O8DzAysKa2ex5V5TgaWYO1B60DdEwbTK/j0ZzKErqc98iESplfY79n0ahdMu7V/GU1kLyH0pCZ90Cx/YW9T/s5TnpwLKQyKcEP6/Sg9LteTNaIO+wo+hrJOfwyKzXZDydfI0CkCcVaoA42rtm8DCZWIo+kKXx9Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kURvamSQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5Eyz1mxK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xZlByWEb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9k316xQt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kURvamSQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5Eyz1mxK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xZlByWEb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9k316xQt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BED205BD94;
	Wed, 22 Apr 2026 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776863747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FY09U2FZedrRK93G4lYG3qncRi3YIx5WHWpsJzax04=;
	b=kURvamSQa4XtnOxsXcg0dwZ6v5RXIuSIHrMI2qGmi329Bs3rQGIfzHYfmWlovl+5IBO7ue
	SfpgVBzNG2KPUDSCfCQ67ficYSyCWMMgesaByjumBi/1lbWFGEVokBxv9LxL+Xq4B3xOQS
	Y+7ePDi8VUXRySkYMtLmZiHqn2Zkou0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776863747;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FY09U2FZedrRK93G4lYG3qncRi3YIx5WHWpsJzax04=;
	b=5Eyz1mxK11UqkknqtLsBwPpQjKPK8Y4ocR3Vr1ETFcJn+SaxP+TfcC0lcCHxJ+w6J30zLx
	h2LNmHIbGS/l5lBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xZlByWEb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9k316xQt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776863745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FY09U2FZedrRK93G4lYG3qncRi3YIx5WHWpsJzax04=;
	b=xZlByWEbxRn7ZRhbOShOoTTTJYukTYkPJlHCPLVvUIdoOBq7m1D1MFQlCg3fHx3KSjGrOf
	PUg/Y9mqFDv5Dr91i3Nu0hRFvm+Lm5f9EifxgEdXt5VMdei0GNL74pWBoO+GB1at7zYWfA
	nF/zRV486x1GzHm/ggCwnGq6cI8hoZI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776863745;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FY09U2FZedrRK93G4lYG3qncRi3YIx5WHWpsJzax04=;
	b=9k316xQtFN7Dug7kg0438dA25jF2wuXY8Hrm/cX6dqZn8886BjQW8Pk2pouBqvS2mZTcfo
	uF3e9D5lgkKbi+Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90EB9593AF;
	Wed, 22 Apr 2026 13:15:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7ZhvIgHK6Gl+GwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 22 Apr 2026 13:15:45 +0000
Message-ID: <448302b1-3950-4e6d-ae8b-337cad09f3fe@suse.de>
Date: Wed, 22 Apr 2026 15:15:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: Support scsi_devices without a device wide
 limit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
 stefanha@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-4-michael.christie@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260417230751.117836-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email,oracle.com:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BED205BD94

On 4/18/26 00:57, Mike Christie wrote:
> For virtio-scsi, we export a wide variety of non-scsi devices like
> NVMe (local and RDMA/TCP based) drives and block based devices using
> ublk. And then it's common to have multiple high perf devices im a LVM
> volume. The problem for these setups, is we can easily hit the 4096
> scsi_device queue depth limit so we end up throttling IO in the guest
> when the real device can handle more IO.
> 
> In these situations we don't have a device wide limit that maps to
> cmd_per_lun. We have per hw queue limits or on the host we are doing
> more dynamic throttling. To allow for these types of devices, this
> patch allows drivers to set SCSI_UNLIMITED_CMD_PER_LUN for the
> cmd_per_lun. When set, we will then only be limited by the per hw
> queue limits.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/hosts.c     |  5 +++--
>   drivers/scsi/scsi_scan.c | 25 ++++++++++++++-----------
>   include/scsi/scsi_host.h |  4 ++++
>   3 files changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index e047747d4ecf..c93c59e847c5 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -238,8 +238,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	}
>   
>   	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
> -	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
> -				   shost->can_queue);
> +	if (shost->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN)
> +		shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
> +					   shost->can_queue);
>   
>   	error = scsi_init_sense_cache(shost);
>   	if (error)
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 7b11bc7de0e3..ecc3638c1909 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -352,18 +352,20 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   	if (scsi_device_is_pseudo_dev(sdev))
>   		return sdev;
>   
> -	depth = sdev->host->cmd_per_lun ?: 1;
> +	if (sdev->host->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN) {
> +		depth = sdev->host->cmd_per_lun ?: 1;
>   
Why don't we use a simple flag in the host (or host template) to
indicate that cmd_per_lun should be ignored?
I'm not in favour of using magic values for a setting which
otherwise is a limit.
Look to dev_loss_tmo as a bad example ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
