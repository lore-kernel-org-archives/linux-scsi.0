Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669C53D9699
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2026 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374300; cv=none; b=oLeZZ8DLl9tK8cnrih74v5E5PfnOxdHycDSkToiywSpDSHjn4x5uIae8heZFemdl1JLN8NzkzSqW3LkQksmLJaTDi2alIeSEQPWMxK4w53cv52I27HYPV5Y5l/yLBYGlAvEZ9b9HUf4HQZzjYIT1VWOxAzdcvXHLqDI+xoPPGGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374300; c=relaxed/simple;
	bh=rZuVIoGZYamVlEqOMuVjKVBF6ilJFycF2rJ7oyrctv4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwnKtGAOQVHM3KaHWalmLouYuSCSNrQF9LY1OyLMEmGbR398+LQnEOkjFtIBv7KtGnBSM+LPor14HHd1dy0JzqUNpMzlLTQ3SovuMBp9Lx1Sau14nbbrerVGBSG4Bop4S0Nkkdw+tFaiWZODIRpShg9fkGN1t3S+RAequbaiEsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1HQGcChP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y9oia7Ur; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1HQGcChP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y9oia7Ur; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1HQGcChP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y9oia7Ur";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1HQGcChP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y9oia7Ur"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9D24A6B699;
	Thu, 21 May 2026 14:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779374296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcDLsvIMH3on9Kq7hVKZzUxcZKYt8Cyp90fVMi3NqaE=;
	b=1HQGcChPYSguxJWQiKrLEM7q9/hTEFw2g0b7tPMpgcUYZOTDcbFSCuY5MzG9pIWbH0IhmP
	l5GlG1gRR3vD9g9Hex8tvEJqM5vcBdo0EcUb1163uguuT8bCf1I+hVpdZlcGtuWHjZVCOe
	KZB/Xy7Hc5y77HysjQ73EGEcHcv+yyI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779374296;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcDLsvIMH3on9Kq7hVKZzUxcZKYt8Cyp90fVMi3NqaE=;
	b=y9oia7UrupXSHUBkVw/ishDk6mxRbIBd9dgqqwJP0XK1IqV/aUYdE370aPkvvPfUiA4mhW
	cHXwNMABJFYrfACw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1HQGcChP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y9oia7Ur
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779374296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcDLsvIMH3on9Kq7hVKZzUxcZKYt8Cyp90fVMi3NqaE=;
	b=1HQGcChPYSguxJWQiKrLEM7q9/hTEFw2g0b7tPMpgcUYZOTDcbFSCuY5MzG9pIWbH0IhmP
	l5GlG1gRR3vD9g9Hex8tvEJqM5vcBdo0EcUb1163uguuT8bCf1I+hVpdZlcGtuWHjZVCOe
	KZB/Xy7Hc5y77HysjQ73EGEcHcv+yyI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779374296;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcDLsvIMH3on9Kq7hVKZzUxcZKYt8Cyp90fVMi3NqaE=;
	b=y9oia7UrupXSHUBkVw/ishDk6mxRbIBd9dgqqwJP0XK1IqV/aUYdE370aPkvvPfUiA4mhW
	cHXwNMABJFYrfACw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10774593AC;
	Thu, 21 May 2026 14:38:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wjfrLtUYD2qiWAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Thu, 21 May 2026 14:38:13 +0000
Date: Fri, 22 May 2026 00:38:00 +1000
From: David Disseldorp <ddiss@suse.de>
To: Alexandru Hossu <hossu.alexandru@gmail.com>
Cc: martin.petersen@oracle.com, bvanassche@acm.org, mlombard@arkamax.eu,
 target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
Message-ID: <20260522003800.2323e11a.ddiss@suse.de>
In-Reply-To: <20260520165259.272808-1-hossu.alexandru@gmail.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
	<20260520165259.272808-1-hossu.alexandru@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.01
X-Rspamd-Queue-Id: 9D24A6B699
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Wed, 20 May 2026 18:52:59 +0200, Alexandru Hossu wrote:

> chap_server_compute_hash() allocates client_digest as
> kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
> passes chap_r directly to chap_base64_decode() without checking whether
> the input length could produce more than digest_size bytes of output.
> 
> chap_base64_decode() writes to the destination unconditionally as long
> as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
> the "0b" prefix stripped by extract_param(), up to 127 base64 characters
> can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
> (digest_size=32) this overflows client_digest by 63 bytes; for MD5
> (digest_size=16) the overflow is 79 bytes.
> 
> The length check at line 344 fires after the write has already happened.
> 
> The HEX branch in the same switch statement already validates the length
> up front. Apply the same approach to the BASE64 branch: strip trailing
> base64 padding characters, then reject any input whose data length
> exceeds DIV_ROUND_UP(digest_size * 4, 3) before calling the decoder.
> 
> Stripping trailing '=' before the comparison handles both padded and
> unpadded encodings. chap_base64_decode() already returns early on '=',
> so the full original string is still passed to the decoder unchanged.
> 
> Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
> ---
> v3: strip trailing '=' before length check to handle padded encodings
>     (reported by Maurizio Lombardi)
> v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp
> 
>  drivers/target/iscsi/iscsi_target_auth.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
> index c46c69a..00487d0 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -340,13 +340,22 @@ static int chap_server_compute_hash(
>  			goto out;
>  		}
>  		break;
> -	case BASE64:
> +	case BASE64: {
> +		size_t r_len = strlen(chap_r);
> +
> +		while (r_len > 0 && chap_r[r_len - 1] == '=')
> +			r_len--;
> +		if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
> +			pr_err("Malformed CHAP_R: base64 payload too long\n");
> +			goto out;
> +		}
>  		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
>  		    chap->digest_size) {
>  			pr_err("Malformed CHAP_R: invalid BASE64\n");
>  			goto out;
>  		}
>  		break;
> +	}
>  	default:
>  		pr_err("Could not find CHAP_R\n");
>  		goto out;


This looks a bit fragile, but moving the overflow check into
chap_base64_decode() probably won't make it any cleaner. I'd like to see
a comment or build-time assert in the mutual CHAP path as to why the
length check can be skipped there. Aside from that I think it makes
sense to merge this.

FWIW, I've added some base64 CHAP coverage to the libiscsi test suite
over at https://github.com/sahlberg/libiscsi/pull/469 .

Thanks, David
