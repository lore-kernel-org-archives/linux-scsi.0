Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703623932CE
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 08:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117075; cv=none; b=gyegDoyr5UUs5UlvFXUEZmzIUVE0CzvXp6oxFEd4OFXQSf/y4mKT3MupNhHbKyLL+RGKG5Ti3+6hDWbraGEXfbUfHPdRCmBCWp6Q8OMqEOK2S2dEfgytZG3p1ghZ9zP64jPQeZkpFBWp5Fhbxila4OFDaq3yKSkoGNGeCw1B4L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117075; c=relaxed/simple;
	bh=UIrGJQRLoeLZ+6bqNUe5Pb5lnSByTOg2YlrKxWry3r8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFeKgvCIjTk1SIkTUi3nZQLL5awta1yNppJ+VsWWWjiVGSlq6HIE+ekW9RZ/Lq9LMvDrdyFEvxSYbkhjhbfWMZ2HA79qd3NqYHBgXoSXSEmtb2hWKBhggTAP4mFUR5wnm6U5Qy07JIcy2ogJ0KgSQBohuboWr2Xe+zGxaQ71030=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RT09Vz+E; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ja5gRp23; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q1PvMtCe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XR+mV1tt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RT09Vz+E";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ja5gRp23";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q1PvMtCe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XR+mV1tt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59E9B70660;
	Mon, 22 Jun 2026 08:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782117069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8EArO4dwg83BiygLJAYyP6Bvz/p+P7hQnbAm2VrjDow=;
	b=RT09Vz+EXu23S+fNXCC6sfFhn5hoLY2QoyBeB/ELDO+51qpYZaX+n8zvmPgZuhDbJPChKk
	sNCcY+95aphsEitfXA7TnJX9lrJ3+G14qGG4EW5oe0LU0mqQVB9Ow8r20Lz+ZYLqfNJH2a
	/bY9U12+Yua4c9/xZiHW803/LvceEXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782117069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8EArO4dwg83BiygLJAYyP6Bvz/p+P7hQnbAm2VrjDow=;
	b=Ja5gRp23Rxu4X0FBv614DeJkgpAbWUYn/ROj1GyQ/eBDsHu4GNbCou9jvWCwJZ8je/koaE
	eYtQ6ZipwSravIDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782117068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8EArO4dwg83BiygLJAYyP6Bvz/p+P7hQnbAm2VrjDow=;
	b=q1PvMtCeH6SjXGoxNr83bWk1Gb8rzgHLkKmz3WUZU5MvzzZ4jy4sDj2JB3ZZ2QgwufaD3z
	sCLKd2vlXBuX6nsj4nY1NTkwy5ZBWxsr4ld5P2UpJQzZBm3rPMx6YkkoDqtJP1RwPrLmRH
	RhFMzHS7X9Q++Dj7hJkvj0Fr4vyQiag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782117068;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8EArO4dwg83BiygLJAYyP6Bvz/p+P7hQnbAm2VrjDow=;
	b=XR+mV1ttiW1CdzgCw9DSrWwYD7YWd8kCssL7jKoVSI5ogVd6FXC2slWAOjdmq1xMTEsKSc
	AAUo48trJE04GrCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46C94779A8;
	Mon, 22 Jun 2026 08:31:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GwC2D8zyOGqRfQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 22 Jun 2026 08:31:08 +0000
Date: Mon, 22 Jun 2026 10:31:07 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Haoxiang Li <haoxiang_li2024@163.com>
Cc: ram.vegesna@broadcom.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, jsmart2021@gmail.com, hare@suse.de, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: Fix IO leak on unsupported additional
 CDB
Message-ID: <ce64efec-3c5a-43b2-8950-14073d9f6f1d@flourine.local>
References: <20260622075844.832871-1-haoxiang_li2024@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622075844.832871-1-haoxiang_li2024@163.com>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[163.com,gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[broadcom.com,hansenpartnership.com,oracle.com,gmail.com,suse.de,vger.kernel.org];
	FREEMAIL_TO(0.00)[163.com];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,flourine.local:mid]
X-Spam-Level: 

On Mon, Jun 22, 2026 at 03:58:44PM +0800, Haoxiang Li wrote:
> efct_dispatch_fcp_cmd() allocates an efct_io before dispatching an
> unsolicited FCP command. If the command has an unsupported additional
> CDB, the function returns -EIO before handing the IO to the SCSI layer.
> 
> Free the allocated IO before returning from this error path.
> 
> Fixes: f45ae6aac0a0 ("scsi: elx: efct: Unsolicited FC frame processing routines")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>

Looks good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
