Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEDC48A2B5;
	Mon, 21 Sep 2026 12:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993213; cv=none; b=M7Wr+IsWJGaKcKVL40btqfvgoy6xaXshMjTNulTBOxVyeilMHglNjaIrVCtZkxz7woS2xQ1FiUvsoFZLtxn7s5ipkcSc8dZmI+0syLr/6yz6RjM/aVOwV9mo+WvnJaFFUfnCYzqra5tlW02KdeUdBDNFVtgBhP9eNKsAd0E6wfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993213; c=relaxed/simple;
	bh=4HIejzb3u16Cr5ANljdLvK4OezxqZVkl2qfAaCbJ5TE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C9xOmqY/qkjZmvdi6ko+N3DmNLEtN/Kf/r3kH22mcatAc2NAyWeRMxk3NPG/vO7aUCM4UQNxV9toOvCIA4GbmI6IelOmRXd+Q6LcXi2Pu8gOEGCzedYcLXDbsVTcHTPoMYJTF3yWFZpmvuoXYxtMl7sF9g9U9UWIuV+RRLF5VqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wKXegHR6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9j3GrqTZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=owCSAm65; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cjRPmOoD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wKXegHR6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9j3GrqTZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="owCSAm65";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cjRPmOoD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C07B1F38C;
	Mon, 21 Sep 2026 12:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789993206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XwpiFYC8NMjfTNhwfCkZOAGpc1v1XoGkGw35BrG8hpQ=;
	b=wKXegHR6kxTz1Lqx/J3GfHYDZmqL3jyhBAacSx4Isuwwhm/hU9EWVNMUN1vi7Vs0u6aDJl
	fd1tWXSZFZhavy9Cc2p52ciuW+2JCi8I5C8SSyETKVqT9lzcKLI9+af9JTi1OwTbEFBW0Z
	p3RBJzSOJVXavRjU5ssdevcCXEpR1vQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789993206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XwpiFYC8NMjfTNhwfCkZOAGpc1v1XoGkGw35BrG8hpQ=;
	b=9j3GrqTZDb7bHIw/XXhROstdcbXytLej3Sv/U39qdEzVtT78BoHsAXYkbfnpbM/RkPR/uq
	YG5cWDyP19dir3CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=owCSAm65;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cjRPmOoD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789993202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XwpiFYC8NMjfTNhwfCkZOAGpc1v1XoGkGw35BrG8hpQ=;
	b=owCSAm65JD1DRw02PtJYDOZOX8Y648G5VHj+Ignxs2xFKotf6jv8hRWPG0Af3x4WoP/FQJ
	JkySIXii+U1+WOEVcX1Z4xrv96DMF2VYNN5Z8N0CFN72FBCAdw+5eOaPr0vkuR+mgbAxzK
	XPgGiFOxLGCBHlJDGBdDJxL0Szdap9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789993202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XwpiFYC8NMjfTNhwfCkZOAGpc1v1XoGkGw35BrG8hpQ=;
	b=cjRPmOoD8Rf3WLLtRrq24Zb/COpxv4FGicalqFo4xKgILEh1BtB2E0GowOiWtLl/rk1kAp
	OSXk+IJxhd/okiCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2A4313793;
	Mon, 21 Sep 2026 12:20:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f+xMLfEgsWo1NgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 21 Sep 2026 12:20:01 +0000
Date: Mon, 21 Sep 2026 14:20:00 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Ram Vegesna <ram.vegesna@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Thomas Gleixner <tglx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Hannes Reinecke <hare@suse.de>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: efct: clear MWI on remove
Message-ID: <6e80e9b4-231a-4299-a90d-a2181ea49261@flourine.local>
References: <20260918181326.3633765-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918181326.3633765-1-lgs201920130244@gmail.com>
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 2C07B1F38C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[broadcom.com,hansenpartnership.com,oracle.com,linutronix.de,kernel.org,suse.de,gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,flourine.local:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On Sat, Sep 19, 2026 at 02:13:26AM +0800, Guangshuo Li wrote:
> efct_pci_probe() enables PCI Memory-Write-Invalidate with pci_set_mwi().
> The probe failure path clears this state with pci_clear_mwi(), but the
> normal remove path does not perform the corresponding cleanup.
> 
> pci_disable_device() only disables PCI bus mastering and does not clear
> the PCI_COMMAND_INVALIDATE bit. As a result, the MWI configuration can
> remain enabled after the driver is removed.
> 
> Call pci_clear_mwi() in efct_pci_remove(), matching the probe error
> path.
> 
> This issue was found by manual code inspection.
> 
> Fixes: 4df84e8466242 ("scsi: elx: efct: Driver initialization routines")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
