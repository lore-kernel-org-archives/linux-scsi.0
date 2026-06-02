Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD9133A032
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 23:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780442389; cv=none; b=WuoQH8eUkvnVBv6VRIHzlcaVWaEO9pRuz5ODr/mCZLn8XlqAPjL8WsqSg8frQzLoE4z9FP3fhgcJYgBsYU1rMcw55qE+tCFJSptaRn63rYYzvjp5zxq0rL2OtorqfeQ6Ua0vWqre46LE8qQQOUM+UcSbb6WLZfWzXoNuk/0sNB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780442389; c=relaxed/simple;
	bh=Cptl/OhSaNbJGCWKUmuFA7ZhEi26Ak3cqf20BacvETQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARiqRBiuBTf3TyQeHoGE0Xv1jaszOvSA2o9lIX09Ufcsyjye8mSl9aYBSM/bwDUvxOxd2w0OtNBNPE5TLOmvGZvmsnToPMtAfL5Eoka5VrBAFY+71kU+FAKircX5reYGJZOZLKvQ6mu/GqepSxMjqJQWmGYfSArZQuHYiQMP+xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DhJXiRbC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+7BDEoiN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DhJXiRbC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+7BDEoiN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DhJXiRbC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+7BDEoiN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DhJXiRbC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+7BDEoiN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 318596A917;
	Tue,  2 Jun 2026 23:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780442386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e++y0Wf9YVomY4zfbzSnOjnZx3g+mdmpp0IskCPe2wg=;
	b=DhJXiRbC40qXIJstbfc7ku5MD35C/ODWCjwWwdCQPsnr+PpT8gRUorwU/UPQmjFf5qtNVi
	CYNqCHAmengkKIrfB8tuYnlm0nOM3DUUizGFE655K4arkcvTMqgcid3jjDLiB9QPM7hpuk
	v8LB6xjogEud65DN5yjY/KaJTyvCTWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780442386;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e++y0Wf9YVomY4zfbzSnOjnZx3g+mdmpp0IskCPe2wg=;
	b=+7BDEoiNnZ1A/EQ9xZgT8HsVVqdo2vTDtilmOs9HDbqJVWtdhKI8/QZsXpXzTfqfUhRfTM
	TJ4/iz2EgPMr8LBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DhJXiRbC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+7BDEoiN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780442386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e++y0Wf9YVomY4zfbzSnOjnZx3g+mdmpp0IskCPe2wg=;
	b=DhJXiRbC40qXIJstbfc7ku5MD35C/ODWCjwWwdCQPsnr+PpT8gRUorwU/UPQmjFf5qtNVi
	CYNqCHAmengkKIrfB8tuYnlm0nOM3DUUizGFE655K4arkcvTMqgcid3jjDLiB9QPM7hpuk
	v8LB6xjogEud65DN5yjY/KaJTyvCTWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780442386;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e++y0Wf9YVomY4zfbzSnOjnZx3g+mdmpp0IskCPe2wg=;
	b=+7BDEoiNnZ1A/EQ9xZgT8HsVVqdo2vTDtilmOs9HDbqJVWtdhKI8/QZsXpXzTfqfUhRfTM
	TJ4/iz2EgPMr8LBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1749779A7;
	Tue,  2 Jun 2026 23:19:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oAH0FBBlH2rgZQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 02 Jun 2026 23:19:44 +0000
Date: Wed, 3 Jun 2026 09:19:24 +1000
From: David Disseldorp <ddiss@suse.de>
To: John Garry <john.g.garry@oracle.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: target: fix CHAP_N handling
Message-ID: <20260603091924.0892d415.ddiss@suse.de>
In-Reply-To: <d8126fb0-85ac-4b1f-b6e0-b4e206ec90c3@oracle.com>
References: <20260602115840.26490-1-ddiss@suse.de>
	<d8126fb0-85ac-4b1f-b6e0-b4e206ec90c3@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 318596A917
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	REDIRECTOR_URL(0.00)[urldefense.com];
	MISSING_XM_UA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[urldefense.com:url,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue, 2 Jun 2026 17:42:57 +0100, John Garry wrote:

> On 02/06/2026 12:43, David Disseldorp wrote:
> > The sashiko bot pointed out issues with CHAP_N handling recently, when
> > reviewing a patch for a separate issue:
> > https://urldefense.com/v3/__https://sashiko.dev/*/patchset/20260521151121.808477-1-hossu.alexandru*40gmail.com__;IyU!!ACWV5N9M2RV99hQ!MNesZJ3IsH9Mv0iZxHUcVmbC_3uwDkJgMhAX8i1TelyqqZD_dAq1cwIy6RtYI8D3boJh5iFeGhtTvfTX$
> >    Since extract_param() unconditionally strips '0x' or '0b' prefixes and
> >    alters the returned type, wouldn't a valid user with a name like '0xalice' or
> >    '0bob' have their username mutated to 'alice' or 'ob'?  
> 
> is there a real world case or vulnerability being fixed here?

No vulnerability -  the "real world case" is as above: CHAP
authentication currently fails if the CHAP username begins with 0x, 0b
or the upper case variants. The bug is trivial to reproduce.

Thanks, David
