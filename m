Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2371E531
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752591255; cv=none; b=FI6gE5hgEKJzJihgAODNJizofzEMKmnivH17b1pLL/co+5cDo67ed6sSInuGrs4gIQ+aFOzUYFwkrALBfJjEod24gYH1jrIBbsomKKLLgkBMExgTVaeeW41ONrLwZLkmTltAUn3vMA66MhXXZ7lSEe+wT4Ppt2PPc2+Yh078lDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752591255; c=relaxed/simple;
	bh=LR5Ko6mtltCaSHnCHo7Hgxz7GQF6L4tflBBfZfWNbJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SuIOYhRSPKeIcQiU1eiU9gS8q+8MA1SDrgHXyTExxz9l+VbG1UJ1vzw07qaObigIFnT3UrebJYJcOFnApPK5uO8RRwmRunLoI4zttaNA4zw/cCeeyqpHaiJPR5ledjLl+6Css0m0l2SgRyhRtFpcIbBmERvj9vGzvXs/6d6AD04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QM4nZgVH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X+ZjYBIF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QM4nZgVH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X+ZjYBIF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QM4nZgVH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X+ZjYBIF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QM4nZgVH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X+ZjYBIF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 095291F7E1;
	Tue, 15 Jul 2025 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752591252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qw4wQ/gda9lIt609LHTHOERJwKwir8AGl28fkLdGh+w=;
	b=QM4nZgVHhSbiAlZhD33MBW1PVpx3QIxQCLxqET1mchd0ge2ySJ11lNLJ9YQfKDUk4PYenx
	Mr/Sf4scoI++KhQcDJIHm53RGAX37Weoxm+xVzAj8jwsvDb6RxbfnwQFVSYchpohBbSfUQ
	qsT+eaiCrziTWs/Ia5B4W6imrd/+y30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752591252;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qw4wQ/gda9lIt609LHTHOERJwKwir8AGl28fkLdGh+w=;
	b=X+ZjYBIFXZ3wJuExxN/u82zWPkZgNVxarRZv1D3f8jENz5I3csdolrzuYmS9hY2/S2LhyX
	1kp/nzMWFzr+S8Ag==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QM4nZgVH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=X+ZjYBIF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752591252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qw4wQ/gda9lIt609LHTHOERJwKwir8AGl28fkLdGh+w=;
	b=QM4nZgVHhSbiAlZhD33MBW1PVpx3QIxQCLxqET1mchd0ge2ySJ11lNLJ9YQfKDUk4PYenx
	Mr/Sf4scoI++KhQcDJIHm53RGAX37Weoxm+xVzAj8jwsvDb6RxbfnwQFVSYchpohBbSfUQ
	qsT+eaiCrziTWs/Ia5B4W6imrd/+y30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752591252;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qw4wQ/gda9lIt609LHTHOERJwKwir8AGl28fkLdGh+w=;
	b=X+ZjYBIFXZ3wJuExxN/u82zWPkZgNVxarRZv1D3f8jENz5I3csdolrzuYmS9hY2/S2LhyX
	1kp/nzMWFzr+S8Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D17F713306;
	Tue, 15 Jul 2025 14:54:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0Af1MZNrdmgfUwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 15 Jul 2025 14:54:11 +0000
Message-ID: <1a3e3418-18ae-4344-ad05-d7076a3bc8e4@suse.de>
Date: Tue, 15 Jul 2025 16:54:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] ata: libata-eh: Simplify reset operation
 management
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>
References: <20250711083544.231706-1-dlemoal@kernel.org>
 <20250711083544.231706-3-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250711083544.231706-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 095291F7E1
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
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
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 7/11/25 10:35, Damien Le Moal wrote:
> Introduce struct ata_reset_operations do aggregate in a single structure
> the definitions of the 4 reset methods (prereset, softreset, hardreset
> and postreset) for a port. This new structure is used in struct ata_port
> to define the reset methods for a regular port (reset field) and for a
> port-multiplier port (pmp_reset field). A pointer to either of these
> fields replaces the 4 reset method arguments passed to ata_eh_recover()
> and ata_eh_reset().
> 
> ata_std_error_handler() is modified to use the ATA_LFLAG_NO_HRST link
> flag to prevents the use of built-in hardreset methods for ports without
> a valid scr. This flag is checked in ata_eh_reset() and if set, the
> hardreset method is ignored.
> 
> The definition of the reset methods for all drivers is changed to use
> the reset and pmp_reset fields in struct ata_port_operations.
> 
> A large number of files is modifed, but no functional changes are
> introduced.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/ahci.c                      |  6 +--
>   drivers/ata/ahci_da850.c                |  6 +--
>   drivers/ata/ahci_dm816.c                |  2 +-
>   drivers/ata/ahci_imx.c                  | 13 ++++---
>   drivers/ata/ahci_qoriq.c                |  4 +-
>   drivers/ata/ahci_xgene.c                |  8 ++--
>   drivers/ata/ata_piix.c                  |  4 +-
>   drivers/ata/libahci.c                   | 10 ++---
>   drivers/ata/libata-core.c               |  4 +-
>   drivers/ata/libata-eh.c                 | 49 ++++++++++++-------------
>   drivers/ata/libata-pmp.c                | 26 +++++--------
>   drivers/ata/libata-sata.c               |  2 +-
>   drivers/ata/libata-sff.c                |  8 ++--
>   drivers/ata/libata.h                    |  8 ++--
>   drivers/ata/pata_acpi.c                 |  2 +-
>   drivers/ata/pata_ali.c                  | 10 ++---
>   drivers/ata/pata_amd.c                  |  4 +-
>   drivers/ata/pata_artop.c                |  4 +-
>   drivers/ata/pata_atiixp.c               |  2 +-
>   drivers/ata/pata_efar.c                 |  2 +-
>   drivers/ata/pata_ep93xx.c               |  4 +-
>   drivers/ata/pata_hpt366.c               |  2 +-
>   drivers/ata/pata_hpt37x.c               |  4 +-
>   drivers/ata/pata_hpt3x2n.c              |  2 +-
>   drivers/ata/pata_icside.c               |  2 +-
>   drivers/ata/pata_it8213.c               |  2 +-
>   drivers/ata/pata_jmicron.c              |  2 +-
>   drivers/ata/pata_marvell.c              |  2 +-
>   drivers/ata/pata_mpiix.c                |  2 +-
>   drivers/ata/pata_ns87410.c              |  2 +-
>   drivers/ata/pata_octeon_cf.c            |  2 +-
>   drivers/ata/pata_oldpiix.c              |  2 +-
>   drivers/ata/pata_opti.c                 |  2 +-
>   drivers/ata/pata_optidma.c              |  2 +-
>   drivers/ata/pata_parport/pata_parport.c |  3 +-
>   drivers/ata/pata_pdc2027x.c             |  2 +-
>   drivers/ata/pata_rdc.c                  |  2 +-
>   drivers/ata/pata_sis.c                  |  2 +-
>   drivers/ata/pata_sl82c105.c             |  2 +-
>   drivers/ata/pata_triflex.c              |  2 +-
>   drivers/ata/pata_via.c                  |  2 +-
>   drivers/ata/pdc_adma.c                  |  2 +-
>   drivers/ata/sata_dwc_460ex.c            |  2 +-
>   drivers/ata/sata_fsl.c                  |  6 +--
>   drivers/ata/sata_highbank.c             |  2 +-
>   drivers/ata/sata_inic162x.c             |  2 +-
>   drivers/ata/sata_mv.c                   | 10 ++---
>   drivers/ata/sata_nv.c                   |  2 +-
>   drivers/ata/sata_promise.c              |  4 +-
>   drivers/ata/sata_qstor.c                |  4 +-
>   drivers/ata/sata_rcar.c                 |  2 +-
>   drivers/ata/sata_sil24.c                |  8 ++--
>   drivers/ata/sata_svw.c                  |  4 +-
>   drivers/ata/sata_sx4.c                  |  2 +-
>   drivers/ata/sata_uli.c                  |  2 +-
>   drivers/ata/sata_via.c                  |  4 +-
>   drivers/scsi/libsas/sas_ata.c           |  4 +-
>   include/linux/libata.h                  | 17 +++++----
>   58 files changed, 143 insertions(+), 155 deletions(-)
> 
You may want to run a spell-checker for the description.
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
