Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D28421771B
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 09:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751965486; cv=none; b=FJUNZS9LxruvQrQmfTpnjEfZzSkSF+OICMErM5yr1vTdh+ofv+5Cy1P9S/okcfYzUOM4xYvdPtqPLSPlYE6nTzjYaFQJqRXGiDqzkogeCNiTc2HTJzr+7HCRWGaF7DP71HMMrSbri6KuG8bVrp/muIeaNXode9jK5opk7L9Uv8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751965486; c=relaxed/simple;
	bh=WNhd3m8Dg2LgB68UjsnjzktyiN8y16CTifGdfuorDgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GFNI5wQTlJ+34Qr+15i7PNFGg+Txf0WP4l/m1oHO+HhFzM5jAgdDLtgk+8CKNlAnpcVrMoGPyvkW7QsTNA1T8dHSoFE+BM+OljccKWRVPg2heHzsI0mUSHBWheOU1xeSSUBmyIrARKbEGelT/efMObSkOm0xlgZHepQpbYIv44Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jbXs6rrj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VYGYDlq5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jbXs6rrj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VYGYDlq5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jbXs6rrj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VYGYDlq5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jbXs6rrj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VYGYDlq5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6E40F1F458;
	Tue,  8 Jul 2025 09:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751965482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NV4hN1Y39sFJflUarD+8UiB2fo2fSulG+qVsHsSi1U0=;
	b=jbXs6rrjF21ytqFo47/V1+RxWIwTsUAr3VqHCW7CjRIgRomt0Hujwh4DrV8tB2xNwhVSXH
	WA/0G5GJL89QnZsK9PI935eRgTXvNvuYZE/KVMv1yMyagfVHmeFyrYF1Awkr4J4H1GEziD
	+7yqUVRvg0WXeBjFDand/9HyTzA1txA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751965482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NV4hN1Y39sFJflUarD+8UiB2fo2fSulG+qVsHsSi1U0=;
	b=VYGYDlq5SHTRJ3MwC9dF+Tyy5mdFgMdB76S73QwFe/T7o7E5xhfBTH0qdIn7C4FIWvAJSn
	EO496q2hi6gLGyCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jbXs6rrj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VYGYDlq5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751965482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NV4hN1Y39sFJflUarD+8UiB2fo2fSulG+qVsHsSi1U0=;
	b=jbXs6rrjF21ytqFo47/V1+RxWIwTsUAr3VqHCW7CjRIgRomt0Hujwh4DrV8tB2xNwhVSXH
	WA/0G5GJL89QnZsK9PI935eRgTXvNvuYZE/KVMv1yMyagfVHmeFyrYF1Awkr4J4H1GEziD
	+7yqUVRvg0WXeBjFDand/9HyTzA1txA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751965482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NV4hN1Y39sFJflUarD+8UiB2fo2fSulG+qVsHsSi1U0=;
	b=VYGYDlq5SHTRJ3MwC9dF+Tyy5mdFgMdB76S73QwFe/T7o7E5xhfBTH0qdIn7C4FIWvAJSn
	EO496q2hi6gLGyCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 211BC13A70;
	Tue,  8 Jul 2025 09:04:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G8k9ByrfbGh/YgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 09:04:42 +0000
Message-ID: <3f45a525-59a7-42fa-b51c-45eacdf038bd@suse.de>
Date: Tue, 8 Jul 2025 11:04:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link
 down
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, jmeneghi@redhat.com, revers@redhat.com,
 dan.carpenter@linaro.org, stable@vger.kernel.org
References: <20250612002212.4144-1-kartilak@cisco.com>
 <20250612002212.4144-4-kartilak@cisco.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250612002212.4144-4-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 6E40F1F458
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[cisco.com:email,suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 6/12/25 02:22, Karan Tilak Kumar wrote:
> When the link goes down and comes up, FDMI requests are not sent out
> anymore.
> Fix bug by turning off FNIC_FDMI_ACTIVE when the link goes down.
> 
> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Reviewed-by: Arun Easi <aeasi@cisco.com>
> Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fdls_disc.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
