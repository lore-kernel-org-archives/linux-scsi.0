Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC3B26AF3;
	Wed, 10 Apr 2024 05:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712728028; cv=none; b=ow5Fj9Yj4cnR80co+yrFK1/1XgC7v5tq6b2WT3a1qaMPiawqyQN0pmyD6MFIWXZuUn0W4LGTrosjRXMddaLUbnMGavHS/7VV1sZfEAxR5cpD8qiktoqsUH39Kc1QefbOFYpOua9OgjZ0etydXM5EMAcYZMHO6cwYkIDNf5YeNyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712728028; c=relaxed/simple;
	bh=27A+t/9/l6S9E8H6MrMFO4cb0P3DYZrCeAC0g6v/gpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iEuqyRtN1jAnVoWBFwO58FtNBWUUERiWFaEJ74cT+W49mu2XybL+CKoH/RNpc2k3XiqZ5ZJuSXDuRfhFqAzx9t++QrvyFOrUBY+rmOajFyrkKlaZFFPasPoSR8Fb6ubxxAOFX3J3mrxlxUa4NlBF+11IiA++BFbaYwXbiVZze4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vluTwHRE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W5Pw+nUN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vluTwHRE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W5Pw+nUN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vluTwHRE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W5Pw+nUN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vluTwHRE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W5Pw+nUN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6547734949;
	Wed, 10 Apr 2024 05:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712728018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRdYzu8WwJ7OMWbdtUC8z4ABrFZz9Blh7sjaG+J9I54=;
	b=vluTwHRETqxvWmcp3THGr4N5t/GuYVBjVxlJgD4in3D2fmpzOjzXkUAjYB0Wf1NjA/8c0E
	KJhKcBUJHitj7P8gZ688UpdIcINCS7xGSapz5wpS0UOQVD4KIn9zSoqdsGqvbKmt4nkG+L
	XclBuNbxraAYhaANuW/gNdXhY0hYhCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712728018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRdYzu8WwJ7OMWbdtUC8z4ABrFZz9Blh7sjaG+J9I54=;
	b=W5Pw+nUN27Um529nacUFGYGR4IrypjJTB6+1K6ppV83FWHJqkYYZpyX4qvZ/ESLs2Huyws
	yau5h+iv8IPMW2BQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vluTwHRE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=W5Pw+nUN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712728018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRdYzu8WwJ7OMWbdtUC8z4ABrFZz9Blh7sjaG+J9I54=;
	b=vluTwHRETqxvWmcp3THGr4N5t/GuYVBjVxlJgD4in3D2fmpzOjzXkUAjYB0Wf1NjA/8c0E
	KJhKcBUJHitj7P8gZ688UpdIcINCS7xGSapz5wpS0UOQVD4KIn9zSoqdsGqvbKmt4nkG+L
	XclBuNbxraAYhaANuW/gNdXhY0hYhCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712728018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRdYzu8WwJ7OMWbdtUC8z4ABrFZz9Blh7sjaG+J9I54=;
	b=W5Pw+nUN27Um529nacUFGYGR4IrypjJTB6+1K6ppV83FWHJqkYYZpyX4qvZ/ESLs2Huyws
	yau5h+iv8IPMW2BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0D2813942;
	Wed, 10 Apr 2024 05:46:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NLiZJdAnFmZ5EQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 10 Apr 2024 05:46:56 +0000
Message-ID: <b22949af-c543-4c82-b6eb-3b89d4c34f00@suse.de>
Date: Wed, 10 Apr 2024 07:46:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/23] megaraid_sas: switch to using ->device_configure
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-12-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240409143748.980206-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	R_RATELIMIT(0.00)[to_ip_from(RLghztw5pzjjmtx4kirkcu9cad)];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,lst.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6547734949
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 4/9/24 16:37, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
>   drivers/scsi/megaraid/megaraid_sas_base.c   | 29 ++++++++++++---------
>   drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 ++-
>   3 files changed, 20 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

