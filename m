Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF4F8635D
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 09:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791019006; cv=none; b=A4HcyQZrjCfrbOfr3w8uBE66ebwB5+41D2KmVNqBXqWcXQyDgXxSGmeANDY04EYoeN4Zm+WbX8TShZMbVj3kABVq8YhakqqPdN979oW7287GYUmmjAc9nuAL3KOVyBRyz2RFDEo2xGnJpCrhRD9UB9JqTivKYaAkUDBD7/HPia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791019006; c=relaxed/simple;
	bh=SUUk64eJnhP/TGAj1w2w9akAg6HgeO0JfDyhdEY9TWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hvN6z8NGE5cXTYjzdwW4NR/mcmeHhlFuJBbbQKPJZuAHoIc1MWZnDOFrPWyWXEX+l7c/+awEIvVAeyt0WuMtHUgj6si4XUkdIH9gvjsR5gFu6JjOcGGMrS6b9dy4YW2ZkixaVk2P1Yaq0srf7uwbvO9QnTdrJ6XxPSOQwI7EAnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MG7MxNst; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nhF/mZls; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PLHnzjpr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Zb+pRp9W; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MG7MxNst";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nhF/mZls";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PLHnzjpr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Zb+pRp9W"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF3DB1FECE;
	Sat,  3 Oct 2026 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791018997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pCMJtY2Ivn94OKTY6P5+JCVCNOsp4/yToIGDtu5fYjQ=;
	b=MG7MxNstK7BRTLRSZGWDuYBEwBN2gOPIoMDszS766s7ph9WPK1OFzN5bsATr/JNFgVM8jE
	XMY0zWodmTCWP3a81OKSZqnHeR5KRfn/KSmBSEAGBX7UmUGKU2sXjM/SepntNDobCqLI+x
	x2FA5mEkTjsbLjAj/ZVRRHb9YImdgAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791018997;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pCMJtY2Ivn94OKTY6P5+JCVCNOsp4/yToIGDtu5fYjQ=;
	b=nhF/mZlsvyp4Ilhy1Rfa9SjsV68y8jVAmS0Iuq6ttJTKDuTBdk9/bhOYoc3spXWlVhrCbD
	AtfYB1B4dgTn2TDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791018992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pCMJtY2Ivn94OKTY6P5+JCVCNOsp4/yToIGDtu5fYjQ=;
	b=PLHnzjpr2piyt9ulf9r9y0W7lmP18doqdq2ncJ/CQXp9YydLsTmE88M5+uN++Lr56+qnUp
	S3Ito57mueiZWQlxE4hh80+7RIDzNuHkqNuvW/ov1NWz8EMmFfa1ieQXEARep9o1hjbMco
	yMUOKC4KXLRjN6FLmJKYkiGrSkxJlBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791018992;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pCMJtY2Ivn94OKTY6P5+JCVCNOsp4/yToIGDtu5fYjQ=;
	b=Zb+pRp9Wn9t6kSjd1JH/UO8agliR9cyBi58nmCx4ct8GjFCUtVcNRwCbv/kAjGM62v3BLR
	d7uBEKZuwQQbJNDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 408F713712;
	Sat,  3 Oct 2026 09:16:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cBlWAvDHwGpBJAAAD6G6ig
	(envelope-from <hare@suse.de>); Sat, 03 Oct 2026 09:16:32 +0000
Message-ID: <c1c6edda-ec01-46e3-a122-940c0a233eb7@suse.de>
Date: Sat, 3 Oct 2026 11:16:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Micro-optimize the hot path
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>,
 Hannes Reinecke <hare@kernel.org>
References: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.28 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-0.98)[-0.985];
	NEURAL_HAM_SHORT(-0.20)[-0.980];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email]
X-Spam-Flag: NO
X-Spam-Score: -4.28
X-Spam-Level: 

On 9/25/26 8:09 PM, Bart Van Assche wrote:
> Every code path that inserts scmd->eh_entry into a list uses
> list_add_tail() (see also scsi_abort_command() and scsi_eh_scmd_add()).
> list_add_tail() overwrites the next and prev pointers. Hence, the only
> code that depends on the initialization of scmd->eh_entry is the
> BUG_ON(!list_empty(&scmd->eh_entry)) statement in scsi_abort_command().
> Remove this statement because scsi_timeout() already prevents
> scsi_abort_command() from being called twice for the same command by
> setting SCMD_STATE_COMPLETE. Remove the scmd->eh_entry initialization
> because the only statement that relied on this initialization has been
> removed.
> 
> Cc: John Garry <john.garry@linux.dev>
> Cc: Hannes Reinecke <hare@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_error.c | 1 -
>   drivers/scsi/scsi_lib.c   | 3 ---
>   2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 2e0b1909dc69..75442d60c30e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -270,7 +270,6 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>   	spin_lock_irqsave(&shost->host_lock, flags);
>   	if (shost->eh_deadline != -1 && !shost->last_reset)
>   		shost->last_reset = jiffies;
> -	BUG_ON(!list_empty(&scmd->eh_entry));
>   	list_add_tail(&scmd->eh_entry, &shost->eh_abort_list);
>   	spin_unlock_irqrestore(&shost->host_lock, flags);
>   
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index db64470f5229..f695a6605815 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1322,7 +1322,6 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>   	}
>   
>   	cmd->device = dev;
> -	INIT_LIST_HEAD(&cmd->eh_entry);
>   	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
>   }
>   
> @@ -1590,8 +1589,6 @@ static void scsi_complete(struct request *rq)
>   		return;
>   	}
>   
> -	INIT_LIST_HEAD(&cmd->eh_entry);
> -
>   	atomic_inc(&cmd->device->iodone_cnt);
>   	if (cmd->result)
>   		atomic_inc(&cmd->device->ioerr_cnt);

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
