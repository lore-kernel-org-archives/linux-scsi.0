Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FBD3254B4
	for <linux-scsi@vger.kernel.org>; Mon,  8 Dec 2025 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765204037; cv=none; b=lxNoAtOXt9zcugxtPPVrjJsjTFT+eBKEHhmpyKo5C+lQSYOlXjeXJxEYm4V2HeUcdovRa3EVoAjoLUkrppQp/mdrLr4d1GwueMd80+5EmLN+PiJEsFjXib9JYlXRV+j/NejmwPuVkwm63oiV2rmzXTAIIT5AE9jXKVgj2qELjPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765204037; c=relaxed/simple;
	bh=wZRr4EYXAJeKiH9j8GMwDn8nMFX+x7KpKNCWSoqTFtY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bCwV6GBtvjK3RJhQgxzJTPWLb/ED42pGUg0eUeI2/5SHhCUWtMS6CLdWDn4HuONuFaTzYvqIlXTYnyZIuRDTgob4oyipC9aK8JC2PiVYzeddrtFIh5t3HFCPzpfeYOvuQhS7fnUlgl3v+v/iJwajwToj0Mamvp2Yyu5qHuI1RSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XVmjJisS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XVmjJisS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XVmjJisS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XVmjJisS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3194E337AD;
	Mon,  8 Dec 2025 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765204034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZRr4EYXAJeKiH9j8GMwDn8nMFX+x7KpKNCWSoqTFtY=;
	b=XVmjJisSoEkt3gIXWwOVeaQ035JlRf1+YTbhUww8hGQnxNJBrwi4IkXwLnDpPzwBxPnj2Z
	wIhdsfTQnA1T4eTF966A9Hw3x167o4Vfe6F7WSSzpzDociLDgUj9thofKOGE9sVMZ30h5i
	2TPgBIVIbSpBKk6QhmOjBAX8t1WXpSA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765204034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZRr4EYXAJeKiH9j8GMwDn8nMFX+x7KpKNCWSoqTFtY=;
	b=XVmjJisSoEkt3gIXWwOVeaQ035JlRf1+YTbhUww8hGQnxNJBrwi4IkXwLnDpPzwBxPnj2Z
	wIhdsfTQnA1T4eTF966A9Hw3x167o4Vfe6F7WSSzpzDociLDgUj9thofKOGE9sVMZ30h5i
	2TPgBIVIbSpBKk6QhmOjBAX8t1WXpSA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 045D03EA63;
	Mon,  8 Dec 2025 14:27:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tgmKO0HgNmkPNQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 08 Dec 2025 14:27:13 +0000
Message-ID: <246581b55b4f88277410bd22d9761ca7215194b9.camel@suse.com>
Subject: Re: [PATCH v2] scsi: scsi_dh: Return error pointer in
 scsi_dh_attached_handler_name
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, "James E . J . Bottomley"
	 <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>
Cc: linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Date: Mon, 08 Dec 2025 15:27:13 +0100
In-Reply-To: <20251206010015.1595225-1-bmarzins@redhat.com>
References: <20251206010015.1595225-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.26 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.784];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.26

On Fri, 2025-12-05 at 20:00 -0500, Benjamin Marzinski wrote:
> If scsi_dh_attached_handler_name() fails to allocate the handler
> name,
> dm-multipath (its only caller) assumes there is no attached device
> handler, and sets the device up incorrectly. Return an error pointer
> instead, so multipath can distinguish between failure, success where
> there is no attached device handler, or when the path device is not
> a scsi device at all.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
