Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF411196C7C
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 09:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779181710; cv=none; b=TwCIXq5Rqr2526iKWYsi0OcghjYacIG+NJpMZAMLPKcD+o46CtWKfjNU7H7vVH4VvalnN6bcOBYgOWDl8jPI/6M4SWpc4JhHV9FICMAy9kc0z4htsksTZxs58Sw1J0jMPJwRKnakAat9sP+z+xx59dWH5e0OP+mL1rDNLkxyHSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779181710; c=relaxed/simple;
	bh=5qem9xeDBLOjPObJ+ajvr45pkblO/CPqU8pDxMA0CJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i5rO3Kw8gKvStEFe3nHO6He2WmjrWTDoGxrqSwSmR2oEpDouim2SwJrUPnkSPWeNiQOQCnzFvFcy9s6jlrPPuz6IfKHNL2hD9ulJe6C7wDhbofFprK7FM3n6kdQFEHqzfTRfx2zr09rFcwnS+Nga8B5toE9zzSPRxvlE5VYjvPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cJxq7hn4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n7Vs6Z48; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XJg2Nfaf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AIBweUZB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cJxq7hn4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n7Vs6Z48";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XJg2Nfaf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AIBweUZB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B59E4643A0;
	Tue, 19 May 2026 09:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779181707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cf7WKDfC8ND/EjFPlOxWa0GLrcl0KBv9QU8CiQnpCRA=;
	b=cJxq7hn4QegpftjApFNInGBmkiPgpi8NrgMcmt10I4gUZOuVR3tgO6ZTxpvoErCDIqTOzv
	ZCfZjRpGWARdERwy//1cQtib2FeitjhQEBfsh70Q4nVsT+AvM0ZNnMi3/Ce5L6yUlz+tGG
	vCurwFNzxYFKQP6dAtT+zNX8cE4O9D8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779181707;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cf7WKDfC8ND/EjFPlOxWa0GLrcl0KBv9QU8CiQnpCRA=;
	b=n7Vs6Z48K6pxOH1rbHY0RUGtNrA6OfUNJX/INA5GHvkVZ4pDm2K6zHyOHNohgfsP3waWg6
	FebDNiVUZuO4/UBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779181705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cf7WKDfC8ND/EjFPlOxWa0GLrcl0KBv9QU8CiQnpCRA=;
	b=XJg2NfafMIilhRJUcbIW4oQs6UuGPG2l6WnoX2iwzS5iWx3VPMPGy+OGIYpe9uyX4umVin
	wfu2KUiu9xadKvpPYO4sPUwdL1HlG5OYc/Cfee0zO6Nl8N+FxfZS9oDg6R5c0BHwQ9ZejW
	bKzHIkKznGVtvJjjELd3goBxZXqTSTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779181705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cf7WKDfC8ND/EjFPlOxWa0GLrcl0KBv9QU8CiQnpCRA=;
	b=AIBweUZBJw7Uv4mfTg8RAI6Gywq+ncZR91N7gm1NhigEcYEt7y//TN9JqdUnfOvveysit0
	//23Ysy/r167XQBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A724593A8;
	Tue, 19 May 2026 09:08:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jE8eIYkoDGoDNQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 19 May 2026 09:08:25 +0000
Message-ID: <9c6e8497-5e92-4d2b-ac87-3c941e6890a1@suse.de>
Date: Tue, 19 May 2026 11:08:17 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] Revert "scsi: Fix sas_user_scan() to handle
 wildcard and multi-channel scans"
To: Martin Wilck <martin.wilck@suse.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microchip.com>,
 ranjan.kumar@broadcom.com
Cc: linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
 Martin Wilck <mwilck@suse.com>, mpi3mr-linuxdrv.pdl@broadcom.com,
 storagedev@microchip.com,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com
References: <20260513174236.430465-1-mwilck@suse.com>
 <20260513174236.430465-3-mwilck@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260513174236.430465-3-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.com:email,microchip.com:email,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,broadcom.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[microchip.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 5/13/26 19:42, Martin Wilck wrote:
> This reverts commit 37c4e72b0651e7697eb338cd1fb09feef472cc1a.
> 
> Said commit causes excessive resource usage and even system freeze with
> some controllers, e.g. smartpqi and hisi_sas. The justification provided
> by the patch authors [1] was supporting a special mode of the mpi3mr and
> mpt3sas, so-called "Tri-mode", in which NVMe drives are exposed as SCSI
> devices on a separate channel. While that's useful for these drivers, it
> seems wrong to cause major breakage for other drivers for the sake of
> this feature.
> 
> [1] https://lore.kernel.org/linux-scsi/CAFdVvOwjy+2ORJ6uJkspiLTPF05481U7gcS4QohFOFGPqAs8ig@mail.gmail.com/
> 
> Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: Don Brace <don.brace@microchip.com>
> Cc: storagedev@microchip.com
> Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
> Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: mpi3mr-linuxdrv.pdl@broadcom.com
> Cc: MPT-FusionLinux.pdl@broadcom.com
> Cc: Yihang Li <liyihang9@h-partners.c
> ---
>   drivers/scsi/scsi_scan.c          |  2 +-
>   drivers/scsi/scsi_transport_sas.c | 60 +++++++------------------------
>   2 files changed, 13 insertions(+), 49 deletions(-)
> 
While I'm generally in favour of keeping things simple,
reverting the mentioned commit might cause regressions
with te mpi3mr and/or mpt3sas controller.
Have you tested with these controllers?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
