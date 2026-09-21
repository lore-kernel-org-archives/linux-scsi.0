Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061E136212C;
	Mon, 21 Sep 2026 08:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980519; cv=none; b=fgR9gkNAuH/IKeCTa8P2KHcJy+E21w/E6NQwJIZiDM1GS9I87WeUkU2Nnd1j3WoSK4mMXAGbLyYDDFkHzdfoziIBbCyA42LYLQxvEP6dyuAickzqGFYM39euwzdZjO4YDL3FG4lylCyqjPyrMc9pAfLzrFAsG/+4p3j2fzD2wc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980519; c=relaxed/simple;
	bh=iNcD90TOEC4up8mJomSEGrqN8iDhcW+0IhnuQe1zqzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHYfc8g/7aeW4dR0cTEa24RhxCIjdKumwOC98bS6mWV6aFN4os52qQQbfsOjQphYpSCJ3/MNYS/RTcPBV77CnkMX1dTSbiVeLRPan3E6GezmKnhpnjRpwCuK151uWuVfJs3czNg7wjitDfhH5wRRbNTiGQSTDtQ9w1wHZgOslec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ICEwSlGN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mJf0rSx8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UCL//Dwm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3UiEHUj2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ICEwSlGN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mJf0rSx8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UCL//Dwm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3UiEHUj2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 569B41F74A;
	Mon, 21 Sep 2026 08:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789980511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=delK6S1uyACp4+jf+Vgb66XpupmK4x7dstB7NGDmOn4=;
	b=ICEwSlGNTckXIgC5ijJ+X7n7UOMaVq2dhWXdAfG8+6ELnruYjetScCpZ7QuxBAP6H8YExZ
	aWli/v1KmC56ak8hldg+qTSUD0wCoK9ya3uZea6L68Wbi1qm6s4yKFw9ZRED40qss5aFiz
	m4vtyFWivMBeqnsiAKYlZVHIMnC4lcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789980511;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=delK6S1uyACp4+jf+Vgb66XpupmK4x7dstB7NGDmOn4=;
	b=mJf0rSx8l7acXlaNG+dLgebq44mJ4zkjSTnq+a8Hd2FWtoBl5MfeBvWsVb93Zw0Yhoky9Q
	0tdPuqG2AIOhh3CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="UCL//Dwm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3UiEHUj2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789980507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=delK6S1uyACp4+jf+Vgb66XpupmK4x7dstB7NGDmOn4=;
	b=UCL//DwmnYPfRPKT0CkG2T4L+VF1ecYTHeiYyajj2giNusk8apOXncAjd7t3vtXd4T7TW0
	6nOucIXJTZAg4/3elXISb9sAGWEVX1zddAsMoYaDHg9XxuZ21DlEFT3D/x33adx05lboRI
	AVKD8H8PVQCRWUvn0/Es+J01qSVpIc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789980507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=delK6S1uyACp4+jf+Vgb66XpupmK4x7dstB7NGDmOn4=;
	b=3UiEHUj2OiMg7fqLEPr70btHSi2RG72dZHFeV6g7OxV4RtoEwj5zLuVVqzFfCQgzaT9HmF
	48qrHqv7qvm7EWBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6BA01368D;
	Mon, 21 Sep 2026 08:48:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ngbKKVrvsGrlTAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Sep 2026 08:48:26 +0000
Message-ID: <4ca4f5c5-5021-4a63-bb14-4b7d0502eef6@suse.de>
Date: Mon, 21 Sep 2026 10:48:26 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libfc: fix directory server rport memory leak
To: Guangshuo Li <lgs201920130244@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Robert Love <robert.w.love@intel.com>,
 James Bottomley <James.Bottomley@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260919173405.3718408-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260919173405.3718408-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 569B41F74A
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,HansenPartnership.com,oracle.com,intel.com,suse.de,cisco.com,vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/19/26 7:34 PM, Guangshuo Li wrote:
> fc_rport_recv_plogi_req() creates an rport before allocating the frame
> used for the PLOGI LS_ACC response.
> 
> fc_rport_create() does not add FC_FID_DIR_SERV rports to the discovery
> rport list. If fc_frame_alloc() fails while handling a PLOGI from the
> directory server, the function returns without starting the rport state
> machine or dropping the initial rport reference.
> 
> Since the directory server rport is not present in the discovery list,
> there is no later teardown path that can find the object and release
> that reference. The allocated fc_rport_priv is therefore leaked.
> 
> Record when the failed frame allocation leaves an unlisted directory
> server rport behind and drop its initial reference after releasing the
> rport mutex. Keep the existing lifetime unchanged for ordinary rports,
> which remain owned by the discovery list.
> 
> The issue was identified by a static analysis tool I developed and
> confirmed by manual review.
> 
> Fixes: 3ac6f98f4113 ("[SCSI] libfc: correctly handle incoming PLOGI request.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>   drivers/scsi/libfc/fc_rport.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
> index c25979d96808..884b233c2f72 100644
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -1848,6 +1848,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
>   	struct fc_els_flogi *pl;
>   	struct fc_seq_els_data rjt_data;
>   	u32 sid;
> +	bool drop_rdata = false;
>   
>   	lockdep_assert_held(&lport->lp_mutex);
>   
> @@ -1940,8 +1941,10 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
>   	 * Send LS_ACC.	 If this fails, the originator should retry.
>   	 */
>   	fp = fc_frame_alloc(lport, sizeof(*pl));
> -	if (!fp)
> +	if (!fp) {
> +		drop_rdata = sid == FC_FID_DIR_SERV;
>   		goto out;
> +	}
>   
>   	fc_plogi_fill(lport, fp, ELS_LS_ACC);
>   	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
> @@ -1949,6 +1952,8 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
>   	fc_rport_enter_prli(rdata);
>   out:
>   	mutex_unlock(&rdata->rp_mutex);
> +	if (drop_rdata)
> +		kref_put(&rdata->kref, fc_rport_destroy);
>   	fc_frame_free(rx_fp);
>   	return;
>   

Wouldn't it be better to always create an rport for the directory
server?
That would make the teardown path far easier.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
