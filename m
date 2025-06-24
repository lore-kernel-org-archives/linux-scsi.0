Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCBE2153C1
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750775402; cv=none; b=R72JqMoHPJveRyjTnXBK0CBhJN1PDN1hjEidDWCzAc96qq+GsxOHRKQ+VNg+ysYOYUIe18B/F3m0rw8qP6bweOE8bpgBeVjkgQK1KakzL3fr8iZrB2Fzdprnu3XeCyLTdGpOQlKq/09qzeptHg0tFWzQnvaI9mdzIrYXtibMVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750775402; c=relaxed/simple;
	bh=qpvaQFDW+0dHZvXO/+ldJtYYEf/g7b/ifdIXwLxnrs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E12w6oTQPmUi7jah7FXzDR7MTV7lGg9Vrmo+m+gAO9eJfrmgV4LCHZfoC4n85+ynxCJ0gdqYLa9ZV5439euTbdciHQicZGK3LQ3b3gJMhKrrWP6DnAoAp8q6QK6k3wXYI+q7bK18tJKPN5otKBLyBDTqE/HABU2kcgml4J70AJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=URFyznW8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y0oAZeI1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=URFyznW8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y0oAZeI1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="URFyznW8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y0oAZeI1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="URFyznW8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y0oAZeI1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73B6E2116E;
	Tue, 24 Jun 2025 14:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750775399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GdzHCZdpOzN9qk+zX9xpsiMsUBeRg80+Yr/M8DrT0PI=;
	b=URFyznW8jNAukftcOhGRh/TSh7iDXB85HE9FUSbFS0SHWKSIsJfOh4YO8BlzxpwK1w/Hgk
	RPJl9r9VU1NJafACnnb7p+zGb3x8tAF4dnoVZn2dZhrjJXf1RqbGRdTqdzOjiLaAfj7kmm
	mRcxvgBsOj7yujle13duzbydnne8DwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750775399;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GdzHCZdpOzN9qk+zX9xpsiMsUBeRg80+Yr/M8DrT0PI=;
	b=y0oAZeI176k7LZhMYHZ7cNE3YlmVmtjDIsJF6VfF9KBrTgqeSEaibJpE9dK2Y6k5krx3nE
	XMjD6S13/dH72ZAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=URFyznW8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y0oAZeI1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750775399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GdzHCZdpOzN9qk+zX9xpsiMsUBeRg80+Yr/M8DrT0PI=;
	b=URFyznW8jNAukftcOhGRh/TSh7iDXB85HE9FUSbFS0SHWKSIsJfOh4YO8BlzxpwK1w/Hgk
	RPJl9r9VU1NJafACnnb7p+zGb3x8tAF4dnoVZn2dZhrjJXf1RqbGRdTqdzOjiLaAfj7kmm
	mRcxvgBsOj7yujle13duzbydnne8DwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750775399;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GdzHCZdpOzN9qk+zX9xpsiMsUBeRg80+Yr/M8DrT0PI=;
	b=y0oAZeI176k7LZhMYHZ7cNE3YlmVmtjDIsJF6VfF9KBrTgqeSEaibJpE9dK2Y6k5krx3nE
	XMjD6S13/dH72ZAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58EA813A24;
	Tue, 24 Jun 2025 14:29:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9sBLE2e2WmgPfQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 24 Jun 2025 14:29:59 +0000
Date: Tue, 24 Jun 2025 16:29:58 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: John Garry <john.g.garry@oracle.com>, Daniel Wagner <wagi@kernel.org>, 
	"Sean A." <sean@ashe.io>, 
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "atomlin@atomlin.com" <atomlin@atomlin.com>, 
	"kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, 
	"sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
Message-ID: <0233e47b-894f-49e0-822c-bc1436352c98@flourine.local>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
 <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
 <aFjjf3qbuEOeWUjt@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFjjf3qbuEOeWUjt@infradead.org>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 73B6E2116E
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On Sun, Jun 22, 2025 at 10:17:51PM -0700, Christoph Hellwig wrote:
> On Wed, Jun 18, 2025 at 07:49:16AM +0100, John Garry wrote:
> > BTW, if you use taskset to set the affinity of a process and ensure that
> > /sys/block/xxx/queue/rq_affinity is set so that we complete on same CPU as
> > submitted, then I thought that this would ensure that interrupts are not
> > bothering other CPUs.
> 
> The RT folks want to not even have interrupts on the application CPUs.
> That's perfectly reasonable and a common request.  Why doing driver
> hacks as in this patch and many others is so completely insane.  Instead
> we need common functionality for that.  The core irq layer has added
> them for managed interrupts, and Daniel has been working on the blk-mq side
> for a while.

Indeed, I am in the process to finish the work on my next version for
the isolcpus support in the block layer. I hope to send it out the next
version this week.
