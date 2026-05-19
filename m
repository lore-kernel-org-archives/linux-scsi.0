Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3BE3E122D
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 08:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179798; cv=none; b=rRLfc5AHVOyHCxr5G8Rl4iuMtyfAoQlZ1ys6vT5hQw5nnfgiOWarYRCoupZes97PzBqRcEsQTthHx6U6jBOF66dJKcH4LJ3zfgERoZ6vPGBmqJWAG0Gg9C9FmyGGg/mzPeN7zwTxvoK+54nSl9mP4VzwQ16n60S+DFAc8BLlDTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179798; c=relaxed/simple;
	bh=UsbaXnEt7lIMEviMpu/Wg8MXs/ZC7yK+07Y0fpwW+/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYZus4vKH7pF071Qsg2U4kHUEJAUmf9Pj22Vm0e3YH4WxHV7QdyqG4ryLkdCc7m3RfxoRqsUWAg1LIP/qDXhKwlafPCXaR5Jb5wx5ZcfSnE4BxXIRV/yAEw7TBCxJOTTowm64quzSJdNoXtvEP9W3GJsfgecFYFeGnmkDDGcYlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tzhPCMze; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vyETSHv/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tzhPCMze; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vyETSHv/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tzhPCMze";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vyETSHv/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tzhPCMze";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vyETSHv/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB1D267000;
	Tue, 19 May 2026 08:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779179794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tc1lOXRl9rBVLCCDfVBJ6FJak05/2tR6NqSXdX67C3c=;
	b=tzhPCMzef3Bj/IxMLg74Pk8VjlbYsciK5cvod7DtuiUZLngRbD9p4ppj75O0v980ZPomc8
	aL+FiQiPZ0utAq4G0wBTv/Kj+WZ6FkQJYHGQWUNsnyKI5EY/cS6LQdHD5cHwJ5fhAzoOc+
	8NYBWIwQU4abkcZkRKb1iRONgVNIOwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779179794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tc1lOXRl9rBVLCCDfVBJ6FJak05/2tR6NqSXdX67C3c=;
	b=vyETSHv/EG2KP3J0anV3abxGCpYlepJ4NaSvzcYtAPvGc2SscZuFtm6ZFxv6k8ic4cCyt5
	rPZ9c5k0q+f+gMDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tzhPCMze;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="vyETSHv/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779179794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tc1lOXRl9rBVLCCDfVBJ6FJak05/2tR6NqSXdX67C3c=;
	b=tzhPCMzef3Bj/IxMLg74Pk8VjlbYsciK5cvod7DtuiUZLngRbD9p4ppj75O0v980ZPomc8
	aL+FiQiPZ0utAq4G0wBTv/Kj+WZ6FkQJYHGQWUNsnyKI5EY/cS6LQdHD5cHwJ5fhAzoOc+
	8NYBWIwQU4abkcZkRKb1iRONgVNIOwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779179794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tc1lOXRl9rBVLCCDfVBJ6FJak05/2tR6NqSXdX67C3c=;
	b=vyETSHv/EG2KP3J0anV3abxGCpYlepJ4NaSvzcYtAPvGc2SscZuFtm6ZFxv6k8ic4cCyt5
	rPZ9c5k0q+f+gMDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D6A7593A8;
	Tue, 19 May 2026 08:36:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +O76IRIhDGoAFgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 19 May 2026 08:36:34 +0000
Message-ID: <2edead31-f2f8-4012-86c4-74cf630d1285@suse.de>
Date: Tue, 19 May 2026 10:36:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: fcoe: reject FIP descriptors with zero fip_dlen
 in CVL walker
To: Michael Bommarito <michael.bommarito@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Robert Love <robert.w.love@intel.com>, Vasu Dev <vasu.dev@intel.com>,
 Joe Eykholt <jeykholt@cisco.com>, Saurav Kashyap <skashyap@marvell.com>,
 Javed Hasan <jhasan@marvell.com>, Nilesh Javali <njavali@marvell.com>,
 Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela
 <sebaddel@cisco.com>, Arun Easi <aeasi@cisco.com>,
 Kees Cook <kees@kernel.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260518141150.2755252-1-michael.bommarito@gmail.com>
 <20260518144307.2820961-1-michael.bommarito@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260518144307.2820961-1-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	FREEMAIL_TO(0.00)[gmail.com,oracle.com,HansenPartnership.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CB1D267000
X-Spam-Level: 

On 5/18/26 16:43, Michael Bommarito wrote:
> drivers/scsi/fcoe/fcoe_ctlr.c::fcoe_ctlr_recv_clr_vlink() advanced
> the descriptor cursor by an attacker-supplied fip_dlen without
> ever requiring dlen >= sizeof(struct fip_desc) in the default
> branch.  The named descriptor cases (FIP_DT_MAC, FIP_DT_NAME,
> FIP_DT_VN_ID) checked their per-type minimum lengths, but a
> FIP_DT_NON_CRITICAL descriptor (fip_dtype >= 128, which the
> standard requires receivers to silently ignore) skipped that
> check entirely.
> 
> An unauthenticated L2 peer on the FCoE control VLAN could hang
> fcoe_ctlr_recv_work on an fcoe, qedf, or bnx2fc initiator
> indefinitely by emitting one FIP CVL frame whose single
> descriptor had fip_dtype == FIP_DT_NON_CRITICAL and fip_dlen
> == 0: the cursor advanced zero bytes per iteration and the
> loop condition rlen >= sizeof(*desc) stayed true forever,
> blocking every subsequent FIP frame on that controller.
> 
> Tighten the outer dlen guard to also reject dlen <
> sizeof(struct fip_desc), so a malformed descriptor whose
> length cannot even cover the descriptor header is rejected
> before the switch.  This is the same lower-bound the named
> cases already apply and is the minimum scope that closes the
> loop.
> 
> Fixes: 97c8389d54b9 ("[SCSI] fcoe, libfcoe: Add support for FIP. FCoE discovery and keep-alive.")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> ---
> v2: drop the redundant cover letter shipped with v1.  A
>      single-patch send should not carry a cover; the lead
>      belongs in the commit message, which the patch below
>      already has.  The v1 cover also carried stale drafting-
>      time envelope markers that should have been stripped
>      before send.  Apologies for the noise; please ignore the
>      v1 cover at
>      https://lore.kernel.org/linux-scsi/20260518141150.2755252-1-michael.bommarito@gmail.com/
>      The patch hunk below is byte-identical to v1's 0001.
> 
>   drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index 02cd4410efca7..496ddd45f74da 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -1385,7 +1385,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
>   
>   	while (rlen >= sizeof(*desc)) {
>   		dlen = desc->fip_dlen * FIP_BPW;
> -		if (dlen > rlen)
> +		if (dlen < sizeof(*desc) || dlen > rlen)
>   			goto err;
>   		/* Drop CVL if there are duplicate critical descriptors */
>   		if ((desc->fip_dtype < 32) &&

You could just have sent the patch; no need to have such an elaborate 
description for a simple buffer underflow...

But anyway.

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
