Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4511721766A
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 09:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751967351; cv=none; b=CPVxxdpcktCbAeAHLQQPo/tdwCZLHTP+ysoMIRxoCkhbk17GDn8R4YOzMQlXgnoaVfp1aqXGsax6WoQg6Mu7Dop37qK9AmnlP2bRYdbANKA+zkn8g0mfdz3PFPz08cnliKjFfPQAQLZXZiGDciRDEJw8svKgKHKgha90/4cJHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751967351; c=relaxed/simple;
	bh=mYQ/swpHP4M41aX880vkxIBveitC3ejN85ZdA2d2MjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rVwsyOmsbwKKYBlViztae7CI9vjhiHwzBiN+RfqE7Zz4dbF/Z96CRdK2alH3YKROB8MUU3JgI9P5e+8Ryq2c2uN/4GAeWFTMkLilScuRya3bm+6f2KWAaPt2d/WnuxrrK6nKioFGDHR7OVFOsbBQeoN30WE3z2BLnpnjNBw+Stc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TBGUZV5i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ogCyK1dx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TBGUZV5i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ogCyK1dx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TBGUZV5i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ogCyK1dx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TBGUZV5i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ogCyK1dx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 554F21F443;
	Tue,  8 Jul 2025 09:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751967348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIxAswFeaHobv02Z87+NVJayVXKDYgbUBdW4cNF67+M=;
	b=TBGUZV5i6662A4lUAH9Bv0+PmFnwgUZAt1yJ9x8HOGBK4ue9p94r+6AaAYqgwIsMUwXc5J
	YvkuZn6aBZ3NM+Q2Rw32k25gK5DGQEzQfjIU/pQcU52tdPKYLGoJP2ij6hUvI9tyUyUY2w
	lZSWrm1JLFU3x1WOeCpr6+shr958vP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751967348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIxAswFeaHobv02Z87+NVJayVXKDYgbUBdW4cNF67+M=;
	b=ogCyK1dxQqVMJ11HbGS6v8wpcAU3oiEU0xIDxb0h2/6oGAbdbSQdN/CequAlbG5Yrw8988
	Sci/VID50Mg/DlAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TBGUZV5i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ogCyK1dx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751967348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIxAswFeaHobv02Z87+NVJayVXKDYgbUBdW4cNF67+M=;
	b=TBGUZV5i6662A4lUAH9Bv0+PmFnwgUZAt1yJ9x8HOGBK4ue9p94r+6AaAYqgwIsMUwXc5J
	YvkuZn6aBZ3NM+Q2Rw32k25gK5DGQEzQfjIU/pQcU52tdPKYLGoJP2ij6hUvI9tyUyUY2w
	lZSWrm1JLFU3x1WOeCpr6+shr958vP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751967348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIxAswFeaHobv02Z87+NVJayVXKDYgbUBdW4cNF67+M=;
	b=ogCyK1dxQqVMJ11HbGS6v8wpcAU3oiEU0xIDxb0h2/6oGAbdbSQdN/CequAlbG5Yrw8988
	Sci/VID50Mg/DlAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A93C13A54;
	Tue,  8 Jul 2025 09:35:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nyUABXTmbGg4bAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 09:35:48 +0000
Message-ID: <c72cc8b7-f55d-4691-9161-c20d07fde99e@suse.de>
Date: Tue, 8 Jul 2025 11:35:47 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] pps: Fix IDR memory leak in module exit
To: Anders Roxell <anders.roxell@linaro.org>, lduncan@suse.com,
 cleech@redhat.com, michael.christie@oracle.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, arnd@arndb.de
References: <20250704125536.1091187-1-anders.roxell@linaro.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250704125536.1091187-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 554F21F443
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 7/4/25 14:55, Anders Roxell wrote:
> Add missing idr_destroy() call in pps_exit() to properly free the pps_idr
> radix tree nodes. Without this, module load/unload cycles leak 576-byte
> radix tree node allocations, detectable by kmemleak as:
> 
> unreferenced object (size 576):
>    backtrace:
>      [<ffffffff81234567>] radix_tree_node_alloc+0xa0/0xf0
>      [<ffffffff81234568>] idr_get_free+0x128/0x280
> 
> The pps_idr is initialized via DEFINE_IDR() at line 32 and used throughout
> the PPS subsystem for device ID management. The fix follows the documented
> pattern in lib/idr.c and matches the cleanup approach used by other drivers
> such as drivers/uio/uio.c.
> 
> This leak was discovered through comprehensive module testing with cumulative
> kmemleak detection across 10 load/unload iterations per module.
> 
> Fixes: eae9d2ba0cfc ("LinuxPPS: core support")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index c75a806496d6..adbedb58930d 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -5024,6 +5024,7 @@ static void __exit iscsi_transport_exit(void)
>   	class_unregister(&iscsi_endpoint_class);
>   	class_unregister(&iscsi_iface_class);
>   	class_unregister(&iscsi_transport_class);
> +	idr_destroy(&iscsi_ep_idr);
>   }
>   
>   module_init(iscsi_transport_init);

Errm.
The description doesn't match the patch.
Care to fix it up?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
