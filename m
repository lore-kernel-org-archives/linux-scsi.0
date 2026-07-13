Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D229F3043BE
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 09:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783935069; cv=none; b=Z/3PxA6WVA4mH5uKd2wabTxpGJ0aGVcyh8kY3ezmUExKqqLvB1yd+YVNKOvaqH2fhGC6SQp/Xg1sjuRWEUuVdOfO+xUyzlJPINSfE1nMMLJ0Sqhti4kp4E48c705yyRhY6fGDeIWQIA300pbcQrttRxny9HU5Lz6W7ZEHU13o5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783935069; c=relaxed/simple;
	bh=Lt9CbKHM2dEyt8pJFUtYtECqcJs2AWJuEaFHZmUtwFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y51bZNhDdjY4Idp1ZMlo5wzOfU5MbnBcY5lUhtuLPazqNAxqIYtz0gT8B/F1rLTsC9Bdi7X9YH+Ciug/iaKYudYA6eSRi22W6PESle9+iwlJBFCAAJ6d2+Tc0J79cu3OqjQKhC4u6yvpuVwzNExJmHgrVUcuBCumsw596a7f5ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pPu/+Nys; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2zrRRxgj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pPu/+Nys; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2zrRRxgj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pPu/+Nys";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2zrRRxgj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pPu/+Nys";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2zrRRxgj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0ACE67585D;
	Mon, 13 Jul 2026 09:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TsUdVrwUrMhswX+8JA+Xpt+8ICU4YT00IedOjZersEo=;
	b=pPu/+NysXok8fPf/GYbPNgefWx2mt035Oj1eNUcJurT2l3IxqygBhdBHSLlWpIXkjargCE
	vTlQNV0Wg2pQfkumGUM5Bx21mMGh64N3gvyuCDixAHh9Tdibfvh3WXKIPI62XOzgnzkvZR
	+oebGdDNIt2M1O1SsN9ePVFH92WHAjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TsUdVrwUrMhswX+8JA+Xpt+8ICU4YT00IedOjZersEo=;
	b=2zrRRxgjbuR45buCjjWE13fC5gfMP7p7JghSgzgEHqkjdorrshInTCc6dq1YNYgIDWTdcd
	INtrwFUSVmZviUAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="pPu/+Nys";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2zrRRxgj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TsUdVrwUrMhswX+8JA+Xpt+8ICU4YT00IedOjZersEo=;
	b=pPu/+NysXok8fPf/GYbPNgefWx2mt035Oj1eNUcJurT2l3IxqygBhdBHSLlWpIXkjargCE
	vTlQNV0Wg2pQfkumGUM5Bx21mMGh64N3gvyuCDixAHh9Tdibfvh3WXKIPI62XOzgnzkvZR
	+oebGdDNIt2M1O1SsN9ePVFH92WHAjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TsUdVrwUrMhswX+8JA+Xpt+8ICU4YT00IedOjZersEo=;
	b=2zrRRxgjbuR45buCjjWE13fC5gfMP7p7JghSgzgEHqkjdorrshInTCc6dq1YNYgIDWTdcd
	INtrwFUSVmZviUAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EEAE3779AE;
	Mon, 13 Jul 2026 09:31:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tO/YOViwVGqdeQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jul 2026 09:31:04 +0000
Message-ID: <5f934a87-d87b-4f64-b915-5c39c391c56b@suse.de>
Date: Mon, 13 Jul 2026 11:31:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/9] scsi: define depopulation capabilities related
 service actions
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
 <20260706065610.3559692-3-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260706065610.3559692-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0ACE67585D
X-Spam-Score: -4.51

On 7/6/26 8:56 AM, Damien Le Moal wrote:
> Add to include/scsi/scsi_proto.h the definition of the four service
> actions of the SERVICE ACTION IN (16) command for the storage element
> depopulation and restoration capabilities, as defined in the SBC5 and
> ZBC2 specifications. These are:
>   - SAI_GET_PHYSICAL_ELEMENT_STATUS (GET PHYSICAL ELEMENT STATUS command)
>   - SAI_REMOVE_ELEMENT_AND_TRUNCATE (REMOVE ELEMENT AND TRUNCATE command)
>   - SAI_RESTORE_ELEMENTS_AND_REBUILD (RESTORE ELEMENTS AND REBUILD command)
>   - SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES (REMOVE ELEMENT AND MODIFY ZONES
>     command)
> 
> The physical element types and physical element health values reported by
> the GET PHYSICAL ELEMENT STATUS command are also defined.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   include/scsi/scsi_proto.h | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
