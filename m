Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAC11E1C2B
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 09:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730280377; cv=none; b=D49K97SOMv35LILjZW/nfm+dSTpISp7r6xFxXMMvldyJmZrwFUGu+05E2vqY+BEzUjPJr6+Gs9hYX8/7QCg6UtN655LKb72DmwhYOqpqaniapRYhCwe9qt3Tc98pTDheVnlbYd1VCw3NZaRzbEImDAcLKjOXiPjJ62qSwOUJ4hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730280377; c=relaxed/simple;
	bh=fJWLFvaKc7pPH8GF/Z9J3TgSeV/DOUTB51omZOYhLZY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKE+GjGeyrhU9Zq5o6JQS8TdGG0+hZaBf1lCSEYYAH1JzyYI1kz+/l+jWsWgIQf6Jjf5X7x4/9XMcMQPnuVBFC2TIf2y1nBxzuYFLmdmReXacHr5RZQXHDQl6SyuMDfu2wFsjntRSzP6s2AFrYXhamGMEa8JLndcKw2rKeyhOz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1KBUuNBD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4axmEAl4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1KBUuNBD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4axmEAl4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1KBUuNBD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4axmEAl4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1KBUuNBD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4axmEAl4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DE8681FD89;
	Wed, 30 Oct 2024 09:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730280373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fJWLFvaKc7pPH8GF/Z9J3TgSeV/DOUTB51omZOYhLZY=;
	b=1KBUuNBDVwpss5wp1CQ50NoXD7dM6QjQ+TEGOwAkf/5iXgmZtP48EoZZ0MmDOKxzfyOAgU
	uFFIr3x8MyzR2+eQSnkSB3Mq6uy7rz1BPe8PnMulOOdJZ9b54i2EIulBn8MdqGQlEJUA01
	t0cfK4zJYixB6hd5ipuIcUmcEgqZpj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730280373;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fJWLFvaKc7pPH8GF/Z9J3TgSeV/DOUTB51omZOYhLZY=;
	b=4axmEAl4V1aawjx9q+9OLc2FS0u3ru1CRen6xdpssuddivjcuPUR5rFKKHsoUdr/r23OGL
	WcuePBX+D1/2QIBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730280373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fJWLFvaKc7pPH8GF/Z9J3TgSeV/DOUTB51omZOYhLZY=;
	b=1KBUuNBDVwpss5wp1CQ50NoXD7dM6QjQ+TEGOwAkf/5iXgmZtP48EoZZ0MmDOKxzfyOAgU
	uFFIr3x8MyzR2+eQSnkSB3Mq6uy7rz1BPe8PnMulOOdJZ9b54i2EIulBn8MdqGQlEJUA01
	t0cfK4zJYixB6hd5ipuIcUmcEgqZpj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730280373;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fJWLFvaKc7pPH8GF/Z9J3TgSeV/DOUTB51omZOYhLZY=;
	b=4axmEAl4V1aawjx9q+9OLc2FS0u3ru1CRen6xdpssuddivjcuPUR5rFKKHsoUdr/r23OGL
	WcuePBX+D1/2QIBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE11213AD9;
	Wed, 30 Oct 2024 09:26:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZOkqLbX7IWd3IwAAD6G6ig
	(envelope-from <tbogendoerfer@suse.de>); Wed, 30 Oct 2024 09:26:13 +0000
Date: Wed, 30 Oct 2024 10:25:49 +0100
From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
To: Magnus Lindholm <linmag7@gmail.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
Message-ID: <20241030102549.572751ec@samweis>
In-Reply-To: <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
	<yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com>
	<CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
	<CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
	<yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
	<alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
	<CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, 30 Oct 2024 08:52:44 +0100
Magnus Lindholm <linmag7@gmail.com> wrote:

> I've found a few datasheets from qlogic, on ISP1040x, ISP1080 and
> ISP10160. The ISP1040 doesn't mention any 64-bit capabilities in the
> chip.

the datasheet is wrong. QL1040 supports 64bit addresses via DAC,
otherwise it wouldn't work on SGI Origin and SGI Octane systems.
Your patch breaks them (verified on a Octane).

So your problem might not be in the scsi driver, but a PCI setup
problem for the bus of the 32bit PCI slot in your system. If this
bus doesn't support DAC it IMHO shoulnd't allow 64bit PCI addresses.

Thomas.

--=20
SUSE Software Solutions Germany GmbH
HRB 36809 (AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
