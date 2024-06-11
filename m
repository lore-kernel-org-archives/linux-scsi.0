Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F10152178;
	Tue, 11 Jun 2024 06:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718087530; cv=none; b=USsoVYww1NYmDbZB5gH62oUrMOT+b671JBL32aJQm/7HIOWFBq+gHvbbB5UaObew2bFGWq5zIq3+6FlmGeZ8PSbE/Tm9eTeEOBvHdwkhItlwdY3Xaf8z4QKPSWE2L4NERHTpPhYUeB7DyKiOFOCz5QdOSsWhmcV6tUOhb+qvhVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718087530; c=relaxed/simple;
	bh=m3v7bIMelWgUVf/DUN5U+U1w4YoGz1ZSZwp2WgkLTZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SSrZegZxIBT6Rw3RaMRN+MaVkd6NssD0VC+aHz4Vdt9FSIk4aEjVRpcg2CXxuyqdX59T4ktqBusLGS0XtNgaXCknJHgtunMiFxThYb7vgSrqoUzGObvqNfBAxNbDWYe7mDFhB5fPkAdOwi/vo0iBAPat5+FHHo1veQIt19I+/2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uzXiX4mK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DCxs2I3x; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uzXiX4mK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DCxs2I3x; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uzXiX4mK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DCxs2I3x";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uzXiX4mK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DCxs2I3x"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5E693204CE;
	Tue, 11 Jun 2024 06:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718087526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OSlvump8vgDt5bVm8NtMN8OD3zkBrU5FGwgSKAAEgWU=;
	b=uzXiX4mKsM0zqjTErBbgMK6Ks6lVn90NdO16U34e7uRA82uY6Tyy372MI/L0WApUMNEv66
	y1EaS/UhK6Ukau+BLldBOMTFmAWkYfVDNZOmo26K61hIvPy5LrFo+0q2JovyqKdPjpDN9m
	axwQMQzuHDnp4hd9tJVOM7XXNirtmlE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718087526;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OSlvump8vgDt5bVm8NtMN8OD3zkBrU5FGwgSKAAEgWU=;
	b=DCxs2I3x2Ke+KIjFHUdTu/5FmcTBN7CR3Hb7De4MRs6/ccs9yBdu8+zeE+chYY8752szh0
	gT7kVRkFGHCKfzBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uzXiX4mK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DCxs2I3x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718087526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OSlvump8vgDt5bVm8NtMN8OD3zkBrU5FGwgSKAAEgWU=;
	b=uzXiX4mKsM0zqjTErBbgMK6Ks6lVn90NdO16U34e7uRA82uY6Tyy372MI/L0WApUMNEv66
	y1EaS/UhK6Ukau+BLldBOMTFmAWkYfVDNZOmo26K61hIvPy5LrFo+0q2JovyqKdPjpDN9m
	axwQMQzuHDnp4hd9tJVOM7XXNirtmlE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718087526;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OSlvump8vgDt5bVm8NtMN8OD3zkBrU5FGwgSKAAEgWU=;
	b=DCxs2I3x2Ke+KIjFHUdTu/5FmcTBN7CR3Hb7De4MRs6/ccs9yBdu8+zeE+chYY8752szh0
	gT7kVRkFGHCKfzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D6E0137DF;
	Tue, 11 Jun 2024 06:32:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b7AKJGXvZ2ZnOgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 11 Jun 2024 06:32:05 +0000
Message-ID: <6b5e96e6-8c57-44ee-a763-3b91791813af@suse.de>
Date: Tue, 11 Jun 2024 08:32:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] scsi: fnic: Replace shost_printk with
 pr_info/pr_err
Content-Language: en-US
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-2-kartilak@cisco.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240610215100.673158-2-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5E693204CE
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]

On 6/10/24 23:50, Karan Tilak Kumar wrote:
> Sending host information to shost_printk
> prior to host initialization in fnic is unnecessary.
> Replace shost_printk and a printk prior to this
> initialization with pr_info and pr_err accordingly.
> 
Please use 'dev_info' and 'dev_err' instead.
pr_info/pr_err have the problem that they don't reference
the device generating the message, making tracking of
related messages in a large message log problematic.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

