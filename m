Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD66470115;
	Mon,  7 Sep 2026 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788619; cv=none; b=jLKloxmrMv/wQnOboGx61II6guEa0MAk2X8SN6A2BRWIzt1K/ITxsYOWyL+zFaRbp7tX/sUnBnobEDTAyhTsN+9ZOdMOUm9SugNkgbUN3Ko+VyFWl4NO3ir3wIuvl1amTpAhH41P3A0mDKE082mMWINyg3eSlxWDFNd8ztUFkx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788619; c=relaxed/simple;
	bh=zg4W1n3E9BbLoMS2QZbiUdq3cZswWm8htfbT1MMigSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=u4RFAHiTx4Q18gCUxuK3vg2KX+PxNPs9ETQ/r/LDEE658h4U+fYdYn6SX5ijM/8NzPyjkwhidkFpmYyky5G1JiTSWYvStBQsdzyUUp8x0yyJ18JbojFq57fnq/EagYvr/9/R8c8ai2Yl2pZn9MGNVjw5WmabNUmRhnbfSCcZeIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wy1c4hqr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SpJ81Q+N; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FexUShfA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cFKU6/Oh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wy1c4hqr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SpJ81Q+N";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FexUShfA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cFKU6/Oh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7036121AE4;
	Mon,  7 Sep 2026 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Czz/xaxc3fwYpH3AGU0u3ygtqDsELk0PolyKWoqKLNM=;
	b=wy1c4hqr36nqOpwVLzgx0b9fZyADwGdAIdz/B/gymr5T0BfisYYa0wdeBnmuCM68CShqNN
	9XxtEPjw3NMR4R6t/DUUCGw85EjvHHs3etJaW8yHuSl9dkb38Elkz4ddFaGg4ByPchc5t/
	1ivpMREqSAC+JFHkQuvY4WAlIKCzRdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Czz/xaxc3fwYpH3AGU0u3ygtqDsELk0PolyKWoqKLNM=;
	b=SpJ81Q+NhiFxgpjbDHK04Wve9fYVFMXb8FLkfeR35Y6cyGEGTOwciPh0muqO3Bfzznp3Ba
	s2qwd0nQ5PKoyIDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FexUShfA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cFKU6/Oh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Czz/xaxc3fwYpH3AGU0u3ygtqDsELk0PolyKWoqKLNM=;
	b=FexUShfA8V7XICPRoTc4Rbjdp9dvyBX65F9rpOtgih1KrJxEZsii6o3ApoDimfAx7b37nZ
	59DrhQcetCg0XCIC6glRiUFt1T8+qYSHPSlsI+4iFCkX3A3EcWrLN6Qi/e/NRTukOvOs7B
	DEi+9gZ30kjvgaIxMLCRYhx8+hSYEfM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788599;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Czz/xaxc3fwYpH3AGU0u3ygtqDsELk0PolyKWoqKLNM=;
	b=cFKU6/OhEWv5oFN7PUfbASfwBNw/EDODlY87/cwJHxTKw9iHhLuZYLD3P0QK4ECRWrUUxU
	u3NnRa/54RWn3qBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1512D13432;
	Mon,  7 Sep 2026 13:43:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qdTHA3e/nmpFeQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:43:19 +0000
Message-ID: <e5ef0695-167c-49b9-b31e-b5f38507f227@suse.de>
Date: Mon, 7 Sep 2026 15:43:18 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 40/40] scsi: remove scsi_build_sense() and
 scsi_build_sense_buffer()
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-41-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-41-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7036121AE4
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:42 AM, Damien Le Moal wrote:
> Now that all code has been converted to use 16-bits sense codes and to
> initialize sense with scsi_set_sense() and scsi_set_sense_buffer(), remove
> the inline definitions of these new functions, change scsi_build_sense()
> and scsi_build_sense_buffer() to use a single 16-bits sense code as
> argument (instead of separate arguments for the ASC and ASCQ), and
> rename them to scsi_set_sense()  and scsi_set_sense_buffer().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/scsi_common.c | 12 +++++++-----
>   drivers/scsi/scsi_lib.c    |  8 ++++----
>   include/scsi/scsi_cmnd.h   | 10 +---------
>   include/scsi/scsi_common.h |  8 +-------
>   4 files changed, 13 insertions(+), 25 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
