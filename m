Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7439C3815F3
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115242; cv=none; b=tJRoFfv/ovISBz718RnZ7SDUP2lAsBVlv/cRVfD3TjOvBv9ujWWAJQdT2w6cJ6T9tuk/AAHhr6rNp8WflqG4Y6kxrSEfVnBfik/PahMna5CNdY1yHhnHF35Qozj9NoTbs+XoUJFWSKlP2PvfUz+qg7WTnxei5EDLLlPBNKwubGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115242; c=relaxed/simple;
	bh=GVaBP4oVJyjWY/K0OzRzK2HxtrErElkr7Zh+AbpY6bw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OjMQUGF+jgwazZtTQMLtZ28UIdxcN7qvy3+xccgVmreXlrSaDGdJk35a7QNHFknhX8g5Etogi7n8EoEJXzTp6mCanNRIAT12a3ED2H6478yjlD5tCV6llBKemNAVUa/EcDm6PWJcj9HkAkrSGKM9gEb81BgueCyCGf2XGVeo9CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KGlxgwB0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YYNmdcym; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KGlxgwB0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YYNmdcym; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KGlxgwB0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YYNmdcym";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KGlxgwB0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YYNmdcym"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B5BA66725B;
	Mon, 18 May 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779115237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c/fQRnTtYxxVFuJiDKmaSBAEwcnc6ikm6RUoQyTq4bA=;
	b=KGlxgwB05uqO/KH4rCC7W+vLoLQyVVqE05by0jFteXaFTOAUWrS/lMxCh1N5+vGhBv+ADl
	L9CeUJfIRmILAyw/f6LuyoUAkJgWl1O6chMnivk43JWsxG64CCF8wEsgYPQKGgQXsDXwn0
	rbFiDOAohFM0tHH5LDYl6erGXbegWU0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779115237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c/fQRnTtYxxVFuJiDKmaSBAEwcnc6ikm6RUoQyTq4bA=;
	b=YYNmdcymZIwt6f/6heZLQGOfLgKan7Gv3YXhwJ+nxZ+n57CLcu5OUyMNmrWBIQfxNXGmuT
	JtONyHI771HET/Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779115237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c/fQRnTtYxxVFuJiDKmaSBAEwcnc6ikm6RUoQyTq4bA=;
	b=KGlxgwB05uqO/KH4rCC7W+vLoLQyVVqE05by0jFteXaFTOAUWrS/lMxCh1N5+vGhBv+ADl
	L9CeUJfIRmILAyw/f6LuyoUAkJgWl1O6chMnivk43JWsxG64CCF8wEsgYPQKGgQXsDXwn0
	rbFiDOAohFM0tHH5LDYl6erGXbegWU0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779115237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c/fQRnTtYxxVFuJiDKmaSBAEwcnc6ikm6RUoQyTq4bA=;
	b=YYNmdcymZIwt6f/6heZLQGOfLgKan7Gv3YXhwJ+nxZ+n57CLcu5OUyMNmrWBIQfxNXGmuT
	JtONyHI771HET/Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 413D6593A8;
	Mon, 18 May 2026 14:40:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7LGZOeIkC2p8FgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Mon, 18 May 2026 14:40:34 +0000
Date: Tue, 19 May 2026 00:40:26 +1000
From: David Disseldorp <ddiss@suse.de>
To: Alexandru Hossu <hossu.alexandru@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche
 <bvanassche@acm.org>, target-devel@vger.kernel.org,
 linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
Message-ID: <20260519004026.3b7e07a2.ddiss@suse.de>
In-Reply-To: <20260518121811.385350-1-hossu.alexandru@gmail.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -1.80
X-Spamd-Result: default: False [-1.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

Hi Alexandru,

Thanks for the report and follow up patch...

On Mon, 18 May 2026 14:18:11 +0200, Alexandru Hossu wrote:

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
> up front. Apply the same approach to the BASE64 branch: reject any input
> whose maximum decoded length exceeds digest_size before calling the
> decoder.
> 
> The formula (digest_size * 4 + 2) / 3 is the ceiling of digest_size *
> 4/3, i.e. the maximum number of base64 characters that can decode to
> exactly digest_size bytes.
> 
> Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
> ---
>  drivers/target/iscsi/iscsi_target_auth.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
> index c46c69a..653be1a 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -341,6 +341,10 @@ static int chap_server_compute_hash(
>  		}
>  		break;
>  	case BASE64:
> +		if (strlen(chap_r) > (chap->digest_size * 4 + 2) / 3) {

nit: this could be DIV_ROUND_UP(chap->digest_size * 4, 3) to match
base64.h BASE64_CHARS(), right?

> +			pr_err("Malformed CHAP_R: base64 payload too long\n");
> +			goto out;
> +		}
>  		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
>  		    chap->digest_size) {
>  			pr_err("Malformed CHAP_R: invalid BASE64\n");

The above check doesn't appear to catch undersize base64 CHAP responses,
unlike the hex path. How does that affect the handshake?

Finally, don't we need a similar check for the mutual CHAP code-path?

Thanks, David
