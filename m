Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1875D7484;
	Thu, 27 Jun 2024 06:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470444; cv=none; b=RMr/VNxoZs/KEJPkZQJkUV6d+01nI1NFXasQms0bC+6Bf4J5UaVPPAxBPCCy6usHcOAQkjXrqwrqfnziXKpgGmUsE17UaLLwcz9LZM5qhd5445IxigD8rO+1wg10B2op+XUfYApO+/i43gioZd60K6qNIKaqXce6ve4h+rxbLMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470444; c=relaxed/simple;
	bh=fdZw3UEcy/OqjOiM756U2pnRYYZxqnb2PwjDcf1hDWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SlmCV/0tY3HIZHiOasQOgNpXzVqiHd6LcjKe5W7jFieAMMwBdbMpn6D6dZeXb9eaUeuWV2XRSwyrJQvIWS5ldpL0BSNBrKSRXvqAMCLDNktN+lMZXqQe2+Siuin8tqVhfEKVaJZei3ZPOmKTqyQ1exm9NyhjU4w0mlesb2Mw9y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rlUccpjc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zDnAaBxI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rlUccpjc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zDnAaBxI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rlUccpjc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zDnAaBxI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rlUccpjc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zDnAaBxI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D2A8721B70;
	Thu, 27 Jun 2024 06:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyVLM4pG6jloZQ2CaGAYC23ZBr3dfxBr7YstfBlXXIM=;
	b=rlUccpjc98gGIZuqeaojcTBLTqiGZvVHrb2gnfsNgTvdj4Oao26d5VHmmJI9iUKComnRHj
	OGcIKM/XjFxSwdXzPvhfdOmmkmVL6do4H6LUujbfBa4ws/kBdliiI6CcdJsyefc2sK46rA
	U5GDaJxW7wIvcGV5J9GIfMt5PdhX+2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyVLM4pG6jloZQ2CaGAYC23ZBr3dfxBr7YstfBlXXIM=;
	b=zDnAaBxIWnAS4FsTMWa/uAIugJPOkY0SsAIVNm3vdrR+FqO/9vnJnot0AOSIEDi/BSVNHi
	bfrB3KhLuLMZ1vCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rlUccpjc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zDnAaBxI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyVLM4pG6jloZQ2CaGAYC23ZBr3dfxBr7YstfBlXXIM=;
	b=rlUccpjc98gGIZuqeaojcTBLTqiGZvVHrb2gnfsNgTvdj4Oao26d5VHmmJI9iUKComnRHj
	OGcIKM/XjFxSwdXzPvhfdOmmkmVL6do4H6LUujbfBa4ws/kBdliiI6CcdJsyefc2sK46rA
	U5GDaJxW7wIvcGV5J9GIfMt5PdhX+2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyVLM4pG6jloZQ2CaGAYC23ZBr3dfxBr7YstfBlXXIM=;
	b=zDnAaBxIWnAS4FsTMWa/uAIugJPOkY0SsAIVNm3vdrR+FqO/9vnJnot0AOSIEDi/BSVNHi
	bfrB3KhLuLMZ1vCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 086141384C;
	Thu, 27 Jun 2024 06:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4HtNM2YJfWaAagAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:40:38 +0000
Message-ID: <ef01b28b-b671-478a-80e2-521b4099820e@suse.de>
Date: Thu, 27 Jun 2024 08:40:38 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/13] ata: ahci: Add debug print for external port
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-28-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-28-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D2A8721B70
X-Spam-Score: -4.50
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/26/24 20:00, Niklas Cassel wrote:
> Add a debug print that tells us if LPM is not getting enabled because the
> port is external.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/ahci.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index fc6fd583faf8..a05c17249448 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1732,8 +1732,10 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
>   	 * Management Interaction in AHCI 1.3.1. Therefore, do not enable
>   	 * LPM if the port advertises itself as an external port.
>   	 */
> -	if (ap->pflags & ATA_PFLAG_EXTERNAL)
> +	if (ap->pflags & ATA_PFLAG_EXTERNAL) {
> +		ata_port_dbg(ap, "external port, not enabling LPM\n");
>   		return;
> +	}
>   
>   	/* If no LPM states are supported by the HBA, do not bother with LPM */
>   	if ((ap->host->flags & ATA_HOST_NO_PART) &&

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

