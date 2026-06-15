Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8112E3E5A25
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781527853; cv=none; b=KhpzzPuXmvTQKN7wDxF9zgu59XGXUKPzx/bqkhp4abctxeo42wljwQnIRodfiAp5OOWFoDT6iW8z5IyoSEYKkxM4liPDCIlpWqnsMDE+uL04oLkQVG5cJ23OFn6XmcVitqOaXpjd667Kcw3zEvPPr6eWwC/BsRgktqvPndN3dus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781527853; c=relaxed/simple;
	bh=90lNY/xulwxZB3P0r/Sl5+VB4wxDcP0LsgmgJy3StvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ilVeVY4FW98TA23PfD4vVSt/zsSImNRNfaCTFujP77MVZkzZ9g/m/3B2PkKUYJ9GbjS7plExs/P2TH7XEKjyreQeg6iZX7c9ZeXIe3Hoyndq51ch/vh8Ot5oB0pja+H9k5gG9R48bLflotCTMleSxYlilsnsEmnQERS7HTB/9Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Evbs9KgL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RyskRKZ9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Evbs9KgL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RyskRKZ9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Evbs9KgL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RyskRKZ9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Evbs9KgL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RyskRKZ9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D1DE67590E;
	Mon, 15 Jun 2026 12:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781527850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0zrWRe7Z9SAiwhFvATDSnMn5xVCuXFJp4Ikm9O6onk=;
	b=Evbs9KgLfizUaZ/VECHepxUbjD+yabEonPD0PYn3ZXleglxZzhmRRlTT5bwz+sAjw6bAcS
	9BepBxm28g5HceQuSWgs/AarLzazVuzRwVRIt6oXimC7jmvIPGr88YZ5rZ35ljfHC5u8MC
	l0szJyp8h3aF0CTm/jBXGTCjmICXxF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781527850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0zrWRe7Z9SAiwhFvATDSnMn5xVCuXFJp4Ikm9O6onk=;
	b=RyskRKZ9V6QtGltkNx3r/EmwY1e+Z0R2P9PA42VYr3sNdfhoo+OnRtyTlh5Ez5R9kvtkzA
	eyEJB2HcTRrpMLBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781527850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0zrWRe7Z9SAiwhFvATDSnMn5xVCuXFJp4Ikm9O6onk=;
	b=Evbs9KgLfizUaZ/VECHepxUbjD+yabEonPD0PYn3ZXleglxZzhmRRlTT5bwz+sAjw6bAcS
	9BepBxm28g5HceQuSWgs/AarLzazVuzRwVRIt6oXimC7jmvIPGr88YZ5rZ35ljfHC5u8MC
	l0szJyp8h3aF0CTm/jBXGTCjmICXxF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781527850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0zrWRe7Z9SAiwhFvATDSnMn5xVCuXFJp4Ikm9O6onk=;
	b=RyskRKZ9V6QtGltkNx3r/EmwY1e+Z0R2P9PA42VYr3sNdfhoo+OnRtyTlh5Ez5R9kvtkzA
	eyEJB2HcTRrpMLBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7DB9779A9;
	Mon, 15 Jun 2026 12:50:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SXpCKyr1L2qtCwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 15 Jun 2026 12:50:50 +0000
Date: Mon, 15 Jun 2026 14:50:49 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Ram Vegesna <ram.vegesna@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Kees Cook <kees@kernel.org>, Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: fix IO refcount leak in
 efct_hw_io_abort()
Message-ID: <faf11a92-55e0-49e3-955f-80fe5b44f83d@flourine.local>
References: <20260527100935.868042-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527100935.868042-1-vulab@iscas.ac.cn>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Wed, May 27, 2026 at 10:09:35AM +0000, Wentao Liang wrote:
>  drivers/scsi/elx/efct/efct_hw.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index 1838032f6486..4ecd6f4165f4 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -1997,6 +1997,7 @@ efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
>  	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
>  	if (!wqcb) {
>  		efc_log_err(hw->os, "can't allocate request tag\n");
> +		kref_put(&io_to_abort->ref, io_to_abort->release);
>  		return -ENOSPC;
>  	}

I think the Sashiko review is wrong. efct_hw_reqtag_alloc will only use
the list_del_init when it was able to allocate an element, thus it
wont return NULL. The Shashiko argument seems to miss how the life time
of those io object are handled and there doesn't seem to be any code
depended on the return value of efct_hw_io_abort too.

Thus it doesn't really matter if efct_hw_io_abort is set or not. It is
more consistent to do so. And efct_hw_init_free_io will initialize
abort_in_progress anyway.

