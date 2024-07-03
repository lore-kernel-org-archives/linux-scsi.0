Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30B9143879
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 11:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005206; cv=none; b=sdJV5HHv4ojg89cLeyxSK0pRSLDU77NNokTmJljHny7UD8zdUBk1nAL8j2frNcLNL5e72AzrTcH6FPBUZYGWjtCBM+ri6ImI2rLbLEOdh+gTybG8SFLT8217WDJOFcfYohmpZ8spw/3Rp6mNq75//RZCqo7GoOvtMOgv3OU2neU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005206; c=relaxed/simple;
	bh=kz+FFGYQA1uMyZjM/HDLifDynfXPhXGzq/HYUKS9jA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=enonVWATvaELPZtHI9QZ/vWSUfqlpsb1O7m24XrJYv9DKggs/OWNUzNUlE/pgM98WRyDfavkTKtLkgadgvVDsKegT8m36heXzEVePyn53mSKjy1sKjx8lpX9SxVMF8mswHtNdVsrp53vv5YESb3CeYzyYQBliFs8wtkVpv5xD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=R8EuXd0t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wwDb8D4F; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=R8EuXd0t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wwDb8D4F; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="R8EuXd0t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wwDb8D4F";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="R8EuXd0t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wwDb8D4F"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D1681FCDA;
	Wed,  3 Jul 2024 11:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1720005203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tt1TfQUdUDUFfwkPg4spPyyIgY89+4QX8VztXYjD34=;
	b=R8EuXd0t0t/ZBXb26CGB+JXGufEHncR+pxLIliykYvaDgUOKQYK+iyBXcg0JCxTLCjVfsP
	cHA20Oh6zckSiY4zos1gGrEfQMcnlj8ex1NeT3+YiOMI99KxUBbJ424SlQOYG28FoiG3c3
	8L1OutKnWXKnHzCu4Klo32dx2W5/oYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1720005203;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tt1TfQUdUDUFfwkPg4spPyyIgY89+4QX8VztXYjD34=;
	b=wwDb8D4Fyb2KFXFwLfQbDmkXYXLRseHkBwgh2NQcNRxtWjtLkL+WQCX/4OGU79XbwfiFV6
	OWXQF8jraUBIDMBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1720005203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tt1TfQUdUDUFfwkPg4spPyyIgY89+4QX8VztXYjD34=;
	b=R8EuXd0t0t/ZBXb26CGB+JXGufEHncR+pxLIliykYvaDgUOKQYK+iyBXcg0JCxTLCjVfsP
	cHA20Oh6zckSiY4zos1gGrEfQMcnlj8ex1NeT3+YiOMI99KxUBbJ424SlQOYG28FoiG3c3
	8L1OutKnWXKnHzCu4Klo32dx2W5/oYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1720005203;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tt1TfQUdUDUFfwkPg4spPyyIgY89+4QX8VztXYjD34=;
	b=wwDb8D4Fyb2KFXFwLfQbDmkXYXLRseHkBwgh2NQcNRxtWjtLkL+WQCX/4OGU79XbwfiFV6
	OWXQF8jraUBIDMBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9D5A13974;
	Wed,  3 Jul 2024 11:13:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KDjKN1IyhWawdAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 03 Jul 2024 11:13:22 +0000
Message-ID: <f32e1411-6acb-43a7-886e-20d0dae95cc7@suse.de>
Date: Wed, 3 Jul 2024 13:13:22 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/18] scsi: myrs: Simplify an alloc_ordered_workqueue()
 invocation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240702215228.2743420-1-bvanassche@acm.org>
 <20240702215228.2743420-12-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240702215228.2743420-12-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On 7/2/24 23:51, Bart Van Assche wrote:
> Let alloc_ordered_workqueue() format the workqueue name instead of calling
> snprintf() explicitly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/myrs.c | 6 ++----
>   drivers/scsi/myrs.h | 1 -
>   2 files changed, 2 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

