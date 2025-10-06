Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC88422D4DC
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 07:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759734708; cv=none; b=DTKmkF93kGwfIZmBUsRTjye9f8iQ7qIShhM5XKpF2yar72nOGxnlaW1sZaxSrkt7Q654Md6EWBZSZ8qkbvyiYW4wReXLKwjodBOQl+8oR7k7E5Pt0piA0cpMwB9XzaPZDatPKtTrqgPnJGrIhgznbSwht17hf99kP0US3z1qVyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759734708; c=relaxed/simple;
	bh=d3Gi5PAJ/CaBJ6jcAiIl46f028ralx7ivhnQ5XmlCqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLWAI/Bg3Ddvm4FTJaBTka1W9cnK7BDJ2EtBG4VzEG/IUw/FbSYFYwAcApGemVEbOwZ/wGDx9qhcwDiqNFVVz/WufCFcZ+2AM1PQ+t9innI2Z7z3QNAGKNlPPQymStKTzt5MXou/UdVkF9LNVaU1j7bkaydkyUOYKbJ4OY+OoNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V5kZcSA3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XuEab5os; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=S/NiZBwt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i+Oyl2M/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V5kZcSA3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XuEab5os";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="S/NiZBwt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i+Oyl2M/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DAAFE1F452;
	Mon,  6 Oct 2025 07:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/XPkHSjUDLB9iff8+58DPenjwVjl4ij8zcltrcAgXns=;
	b=V5kZcSA3eh9dRCfOhoTJieXS6sErYcweZZJEafykuB0Y0Lzirb380yXEADh7978D1CKODj
	ZJmnVtJd1TEHJVVVThO7PeL/4nluFgmQmJGBAcGfrouiIvGHVcbwqXqnBP9r9CZjduMTN/
	2ADKNzAcSjZDaGux86ZpHePn8XTEC4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/XPkHSjUDLB9iff8+58DPenjwVjl4ij8zcltrcAgXns=;
	b=XuEab5oscKqphGkg+J8v584CukXM/L9i30zELe5zVFqWsdMspmRi+81+w9LkmV+MfTjG5E
	ukdqvLa5gmGBCNDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="S/NiZBwt";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="i+Oyl2M/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/XPkHSjUDLB9iff8+58DPenjwVjl4ij8zcltrcAgXns=;
	b=S/NiZBwt7nwzv1IysQFlMUL4KAP28LrKDhHLu45FYilf79k9ViFPgliX/oSD09Ck9vLTWO
	WZHRowpCKIQF2jaevDh4nhH3QTo6z0+f3DWyeEiUVXgFUb3INJud4qwgJapzAO/Vwtr0wf
	qTLf8OwA0B1//wDlU4L3KRsHahgNQaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/XPkHSjUDLB9iff8+58DPenjwVjl4ij8zcltrcAgXns=;
	b=i+Oyl2M/kMjW3bS89mqz0l8YZXPy3ghpjSD15NotoKxh5sjNKmb4pLcuN5ho3E5e07hJ3v
	CjRYu+tdQ7wPvdCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A834313700;
	Mon,  6 Oct 2025 07:11:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B7KLJ7Br42jPFAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 07:11:44 +0000
Message-ID: <93f4b34a-5ce9-47e7-9ba5-0f2e3ee958c3@suse.de>
Date: Mon, 6 Oct 2025 09:11:44 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/9] scsi: Simplify nested if conditional in
 scsi_probe_lun()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-8-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251002192510.1922731-8-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: DAAFE1F452
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 10/2/25 21:25, Ewan D. Milne wrote:
> Make code congruent with similar code in read_capacity_16()/read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_scan.c | 18 ++++++++----------
>   1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index c754b1d566e0..348ecfe5cdb0 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -717,16 +717,14 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   				"scsi scan: INQUIRY %s with code 0x%x\n",
>   				result ? "failed" : "successful", result));
>   
> -		if (result == 0) {
> -			/*
> -			 * if nothing was transferred, we try
> -			 * again. It's a workaround for some USB
> -			 * devices.
> -			 */
> -			if (resid == try_inquiry_len)
> -				continue;
> -		}
> -		break;
> +		if (result || resid != try_inquiry_len)
> +			break;
> +
> +		/*
> +		 * If the status was good but nothing was transferred,
> +		 * we retry. It is a workaround for some buggy devices
> +		 * or SAT which sometimes do not return any data.
> +		 */
>   	}
>   
>   	if (result == 0) {

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
