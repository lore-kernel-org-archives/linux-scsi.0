Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CC714F125
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2025 06:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760594811; cv=none; b=rYaFc7NZa5hP9A4KTwP+lIRHrIXVqRBPxKdCcTXMhrVkPGs+Ar3rnZOl7bd/RprI9Bl0Xub6E1qNpk/5q0ZDKP2Rh3vCaofmUXwxF2i2q2vK6arzTEO5kZ8ssKS6IP+cHw1LNR26ekE6XIyIZ/20Pj6EYk4gCxaLKRdtJvG54Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760594811; c=relaxed/simple;
	bh=KY6LvOhNFRyWbRnbK+FKniuxLbro+CWb6bAOdHj5D9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U2KIeuINCkZvcs/OlqSMRnI/8y8sAgwrAyj1M/uMlXIqq0OHhcFRZbzcYBjh2d31jSc/Z9OMadaynwBGTnfaextbN+mZZscnXf5p14DBXMYTht83kKaKF+/C/+uoAMdrYtwbBDnRaufGvCnnNhvhhiKhafXqmVclM2QlmwVya/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gcojdETI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ejmvpp2t; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gcojdETI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ejmvpp2t; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gcojdETI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ejmvpp2t";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gcojdETI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ejmvpp2t"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3850E1F7C0;
	Thu, 16 Oct 2025 06:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760594806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=itHwfctiy4kQU+ueXTMQiXwbv87bQaVIqtWQE9BB24s=;
	b=gcojdETIGc8CdL9ynaOwhcD7FRfai82UIjkyXg2estLVDSZCO6TZbQ9ROLQFOE8VwDoRuE
	sIdAlDi2vJu9ru1/jBYgGhQPZuWJmaNhRdxi++895rPD7Vb7FhW0D3NImQFSy/skeWwlqt
	FkeG7T5I6uq1O8EDYUpgboXU4a/hZ6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760594806;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=itHwfctiy4kQU+ueXTMQiXwbv87bQaVIqtWQE9BB24s=;
	b=Ejmvpp2t3+0eJKvSB1JrTMmc36MDkysx6qIbezo2xyn1dxzVdoLYA7CRzEWm5r/dD4EuK+
	AQZ4fFaqlmyeohAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gcojdETI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ejmvpp2t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760594806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=itHwfctiy4kQU+ueXTMQiXwbv87bQaVIqtWQE9BB24s=;
	b=gcojdETIGc8CdL9ynaOwhcD7FRfai82UIjkyXg2estLVDSZCO6TZbQ9ROLQFOE8VwDoRuE
	sIdAlDi2vJu9ru1/jBYgGhQPZuWJmaNhRdxi++895rPD7Vb7FhW0D3NImQFSy/skeWwlqt
	FkeG7T5I6uq1O8EDYUpgboXU4a/hZ6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760594806;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=itHwfctiy4kQU+ueXTMQiXwbv87bQaVIqtWQE9BB24s=;
	b=Ejmvpp2t3+0eJKvSB1JrTMmc36MDkysx6qIbezo2xyn1dxzVdoLYA7CRzEWm5r/dD4EuK+
	AQZ4fFaqlmyeohAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3A5A1376E;
	Thu, 16 Oct 2025 06:06:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BO3FOXWL8Gg2DgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 16 Oct 2025 06:06:45 +0000
Message-ID: <de6b3536-9a83-4038-88e1-476c9d68a7e3@suse.de>
Date: Thu, 16 Oct 2025 08:06:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/28] scsi: core: Make the budget map optional
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-4-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251014201707.3396650-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3850E1F7C0
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 10/14/25 22:15, Bart Van Assche wrote:
> Prepare for not allocating a budget map for pseudo SCSI devices by
> checking whether a budget map has been allocated before using it.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi.c       | 5 +++++
>   drivers/scsi/scsi_error.c | 3 +++
>   drivers/scsi/scsi_lib.c   | 9 +++++++--
>   3 files changed, 15 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
