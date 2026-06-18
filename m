Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DC581724
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 11:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781782956; cv=none; b=B4rtZ6hz1nSfYEWQLBiQwR4DhbmDr7KJ87sbrvY8n4VMnvfQSYmRm82QQ/FLLRCpNKkiIdcJH1EEPgNcQYqfEF2ihvfPzj0KssDEhLugOIT63Fwt6QFDNVKue3JkM+tAOOdhsJwCfhDLgNqGzhiqliNIm2TAZ6qwL4NFykVRgQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781782956; c=relaxed/simple;
	bh=D7IQRydJHUvZ3DTmr4MgiGdFfu7BJekEGZHty957g/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MU/pnVwW0P9ewp4lfyw6N0DrBdQyXspPRO0NHn/TTebGJ8xQLDVcdwJeo5zBSu1zlGPKC8Tezd4wN+b+1c48I8ORSkD9WU6koe4PuTEZJ2DeT6B+n/aYY34QpG+hA3Flf6D2JXouS06JAuH831CI6/nwvrp4s2YsvRLxGZWJOQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YF+6r2c0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wkuuCbYV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YF+6r2c0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wkuuCbYV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YF+6r2c0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wkuuCbYV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YF+6r2c0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wkuuCbYV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 320946C265;
	Thu, 18 Jun 2026 11:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781782953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D7IQRydJHUvZ3DTmr4MgiGdFfu7BJekEGZHty957g/I=;
	b=YF+6r2c0cQcwx/QqOLvhZvuA0Abw8NcbZouRIQQHK9uZNf/AQT1nVR5gSN3PfBYLvIj2ye
	jnouWFUZPp6ZqS9ZJluc/fVp9tL2DBGl5uxbJOZn0MEVz+lveHBS4BszNWdsf6/3r7AyoH
	P/8o+cD+ktq6lw6H0k6mWtdFX5QASxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781782953;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D7IQRydJHUvZ3DTmr4MgiGdFfu7BJekEGZHty957g/I=;
	b=wkuuCbYVi7AzPu+0dN5nnUQVqOwKg4e6O9uH+H9XkEcMp4y7pXneyQptB1ufCpB5b0zIwk
	mmDbUrFrdNDmjtDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781782953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D7IQRydJHUvZ3DTmr4MgiGdFfu7BJekEGZHty957g/I=;
	b=YF+6r2c0cQcwx/QqOLvhZvuA0Abw8NcbZouRIQQHK9uZNf/AQT1nVR5gSN3PfBYLvIj2ye
	jnouWFUZPp6ZqS9ZJluc/fVp9tL2DBGl5uxbJOZn0MEVz+lveHBS4BszNWdsf6/3r7AyoH
	P/8o+cD+ktq6lw6H0k6mWtdFX5QASxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781782953;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D7IQRydJHUvZ3DTmr4MgiGdFfu7BJekEGZHty957g/I=;
	b=wkuuCbYVi7AzPu+0dN5nnUQVqOwKg4e6O9uH+H9XkEcMp4y7pXneyQptB1ufCpB5b0zIwk
	mmDbUrFrdNDmjtDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F06D779A8;
	Thu, 18 Jun 2026 11:42:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UojrBanZM2rqcgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 18 Jun 2026 11:42:33 +0000
Date: Thu, 18 Jun 2026 13:42:24 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Justin Tee <justintee8345@gmail.com>
Cc: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, paul.ely@broadcom.com, thinhtr@linux.ibm.com, 
	Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix race conditions in ELS retry handling
Message-ID: <3cf79f92-a492-45f4-838b-dcbef0a44147@flourine.local>
References: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
 <CABPRKS_Ek4JHDs9pBg2nium+AjHhM_JQ8su1=vrcOg+xME7PjQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPRKS_Ek4JHDs9pBg2nium+AjHhM_JQ8su1=vrcOg+xME7PjQ@mail.gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,flourine.local:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

Hi Justin,

On Mon, Apr 13, 2026 at 09:28:38AM -0700, Justin Tee wrote:
> Broadcom is currently reviewing this patch set and will report back.

Any updates here? We just started to see crashes in our QA which
show the same backtrace. I am going to ship these patches to our QA to
see if it addresses the issue we are seeing. But it would be great to
get this reviewed too.

Thanks,
Daniel

