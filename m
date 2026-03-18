Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BF8375F9E
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 08:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820962; cv=none; b=ua9x5dDWxt2IK5CcXWtTfvnvEC7+3TNAHBxRsd5HgiTxJAReBqfIu1zQJetWVnxQqQYCPIiFhQvfFd5cMKBrOev3ElapSSNTqiRrzUZj664n6YG0vb+KJi1c7MC/M6o9RS5XUN0aGfg6uI07ic1GNCAU5vFHet996OG4b0bLvCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820962; c=relaxed/simple;
	bh=432l+slzRK0AJltgmQ7sHSOtB2/jg46RkQk/B/6F5t0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HQZyhR8Nfi2vpKhofGziYynrNVZkNMzuuc7P69WIq30MNdca7CTZ3IpvsvfHOaBIldo5WAwGW/DE/nkiUQjfjH8YmXWF4rIdl3i7nkRq5BNHpVI1LYQBO7zaT0zsnOP8/JJ7zk6fr3ggBTGOUM0LKCWdqbBOCw4T4wivPzg/YGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ltjJtPoe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AWeRuXBb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ltjJtPoe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AWeRuXBb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ltjJtPoe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AWeRuXBb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ltjJtPoe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AWeRuXBb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D3215BDBC;
	Wed, 18 Mar 2026 08:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qZTsv7VxQcDI0CVPxQuXhZN43pqhDEFR2xnwnnfB/aQ=;
	b=ltjJtPoe3aSktB21aN9qE145dd+YGbH8hWM004APw0QTkXcdD/JsSWQcG0GG9ilCQUiKEL
	6ERIpK6JNILHt0mcZ088qWFWatdjmCgdxxyDy7lFqzr8p5gpRxb+m/l0kbmhtVFFgbT837
	E9M3AY5xJC8mOR+dqZUhzLc7y6j3XB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qZTsv7VxQcDI0CVPxQuXhZN43pqhDEFR2xnwnnfB/aQ=;
	b=AWeRuXBbznOtrRe2DMduoG0CZYHlYXI00FddamTNQNKjGc8xKTn4wv06r8CEBP4o6pSm4i
	HZxJKbORpbETHHAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ltjJtPoe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AWeRuXBb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qZTsv7VxQcDI0CVPxQuXhZN43pqhDEFR2xnwnnfB/aQ=;
	b=ltjJtPoe3aSktB21aN9qE145dd+YGbH8hWM004APw0QTkXcdD/JsSWQcG0GG9ilCQUiKEL
	6ERIpK6JNILHt0mcZ088qWFWatdjmCgdxxyDy7lFqzr8p5gpRxb+m/l0kbmhtVFFgbT837
	E9M3AY5xJC8mOR+dqZUhzLc7y6j3XB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qZTsv7VxQcDI0CVPxQuXhZN43pqhDEFR2xnwnnfB/aQ=;
	b=AWeRuXBbznOtrRe2DMduoG0CZYHlYXI00FddamTNQNKjGc8xKTn4wv06r8CEBP4o6pSm4i
	HZxJKbORpbETHHAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DBD4A4273B;
	Wed, 18 Mar 2026 08:02:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TicXNB5cumm/UwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Mar 2026 08:02:38 +0000
Message-ID: <9d34285e-1230-40df-a7c0-d0efd9d4c495@suse.de>
Date: Wed, 18 Mar 2026 09:02:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] scsi: alua: Add scsi_device_alua_implicit()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-12-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260317120703.3702387-12-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,oracle.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3D3215BDBC

On 3/17/26 13:07, John Garry wrote:
> Add to function to check whether implicit support is available, as this
> will be the general check for ALUA support and no DH support.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_alua.c | 7 +++++++
>   include/scsi/scsi_alua.h | 6 ++++++
>   2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> index c269105dbae4a..d3fcd887e5018 100644
> --- a/drivers/scsi/scsi_alua.c
> +++ b/drivers/scsi/scsi_alua.c
> @@ -631,6 +631,13 @@ blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
>   }
>   EXPORT_SYMBOL_GPL(scsi_alua_prep_fn);
>   
> +bool scsi_device_alua_implicit(struct scsi_device *sdev)
> +{
> +	if (!sdev->alua)
> +		return false;
> +	return sdev->alua->tpgs & TPGS_MODE_IMPLICIT;
> +}
> +
>   int scsi_alua_init(void)
>   {
>   	kalua_wq = alloc_workqueue("kalua", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
> index c16d4adc915ec..2d5db944f75b7 100644
> --- a/include/scsi/scsi_alua.h
> +++ b/include/scsi/scsi_alua.h
> @@ -40,6 +40,8 @@ int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
>   
>   blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req);
>   
> +bool scsi_device_alua_implicit(struct scsi_device *sdev);
> +
>   int scsi_alua_init(void);
>   void scsi_exit_alua(void);
>   #else //CONFIG_SCSI_ALUA
> @@ -64,6 +66,10 @@ blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
>   {
>   	return BLK_STS_OK;
>   }
> +static inline bool scsi_device_alua_implicit(struct scsi_device *sdev)
> +{
> +	return false;
> +}
>   static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
>   {
>   	return 0;

Hmm. Can you fold it into the patch where it's actually called?
It's getting hard to review without that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
