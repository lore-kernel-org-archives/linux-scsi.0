Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8836E800
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2024 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732285657; cv=none; b=YupffQjy7aXKolK08/PKKRqFGkJZDPzN1pDe/hEqDK0U+aLCuxM8Gfk+pMg81Y/mArEVk7hg2j+O1sapbvkLkYDDcAx7U7u5oA4wifKmgeKoDhZw+5+QX76yCDWmiIzxJVBHFN6PENC5A7kEZECfzr2a4dJX9zYNH/Iurx0g7ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732285657; c=relaxed/simple;
	bh=COAzaN5TR5I7LJHEsZ/rWxg3xsa/mX59IZ2Q45H2Xr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ooi0a00bEmjqCkSCFA/+FW6dsoGY7nvgcHxbjVI7FkKyRXKB4PeiJVTW+3k9z7lcJBD4CU0eahRGclU7JfDwi9tzADBZkimkgPL/c82naLzTA6BkD0CrRpOpPRE0ytZHbu/jQw+4vl5bPbwoOgRipXyn1HE1J8LoABimcKgje6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PdWzIWci; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wyxCZ/Qt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PdWzIWci; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wyxCZ/Qt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PdWzIWci";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wyxCZ/Qt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PdWzIWci";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wyxCZ/Qt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9FE2D21175;
	Fri, 22 Nov 2024 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732285652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Itw2NfPAmMgQLy8wO04E22cHyKNZfyjmOl13CVbYTk4=;
	b=PdWzIWciyanIloa20OTAc5gRi4NA0zQkPdX6zehDKs1xXe7fiF451IkOdWHLTmfTuW2p4N
	DoPTh/jbeqkVpUfxz1obvWbl6tj+PLF0qgENAU9jQa+LMkhGWb4Y2l6RvQAz+sPTuyi7TR
	bE5KGwS1HprZNctPS4loaqIHNYdpjXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732285652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Itw2NfPAmMgQLy8wO04E22cHyKNZfyjmOl13CVbYTk4=;
	b=wyxCZ/QtPOTB2g7SrDVSybtgL7TCb6vLEsRFwjtr3NU3ADvA6LwbhBZ+k9RSpbgV7nq0nu
	KXmkOkjknLQfSiBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732285652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Itw2NfPAmMgQLy8wO04E22cHyKNZfyjmOl13CVbYTk4=;
	b=PdWzIWciyanIloa20OTAc5gRi4NA0zQkPdX6zehDKs1xXe7fiF451IkOdWHLTmfTuW2p4N
	DoPTh/jbeqkVpUfxz1obvWbl6tj+PLF0qgENAU9jQa+LMkhGWb4Y2l6RvQAz+sPTuyi7TR
	bE5KGwS1HprZNctPS4loaqIHNYdpjXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732285652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Itw2NfPAmMgQLy8wO04E22cHyKNZfyjmOl13CVbYTk4=;
	b=wyxCZ/QtPOTB2g7SrDVSybtgL7TCb6vLEsRFwjtr3NU3ADvA6LwbhBZ+k9RSpbgV7nq0nu
	KXmkOkjknLQfSiBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EBDC138A7;
	Fri, 22 Nov 2024 14:27:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j+fIIdSUQGdaaQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 22 Nov 2024 14:27:32 +0000
Message-ID: <5353841e-2b6e-4ea0-9d46-08adb8925029@suse.de>
Date: Fri, 22 Nov 2024 15:27:32 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 0/8] scsi: Multipath support for scsi disk devices.
To: himanshu.madhani@oracle.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 11/9/24 05:45, himanshu.madhani@oracle.com wrote:
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Hello Folks,
> 
> Here is a very early RFC for multipath support in the scsi layer. This patch series
> implements native multipath support for scsi disks devices.
> 
> In this series, I am providing conceptual changes which still needs work. However,
> I wanted to get this RFC out to get community feedback on the direction of changes.
> 
> This RFC follows NVMe multipath implementation closely for SCSI multipath. Currently,
> SCSI multipath only supports disk devices which advertises ALUA (Asymmetric Logical
> Unit Access) capability in the Inquiry response data.
> 
First of all, thank you for doing this.
Had been on my to-do list for a long time.

However, the one crucial thing why I kept pushing it back is:

Residuals.

NVMe native multipathing works because NVMe is a 'all-or-nothing' 
protocol, ie either the entire I/O had been completed, or nothing has 
happened.
Which means for any failure we can safely retry the entire I/O on a 
different path (that's the 'steal_bio' thingie), knowing that it's safe
to do so.

For SCSI, however, this is not the case; it's perfectly valid for a 
target to do a partial completion, and ask the initiator to retry the
remainders. And this partial completion might be at any position within
the bvec, requiring us to resend the bio from a random starting position.
Meaning we cannot do a blind 'steal_bio' thing.

So: have you evaluated you series wrt to residuals?
Have you _measured_ if residuals are happening?
Have you considered your patchset how residuals could be
treated?
(It _might_ be possible to resend the entire I/O over to another path,
even if the command had been partially completed. That's perfectly safe
for reads, but for writes you have to be extremely careful to not cause
a data corruption. We had some fun discussions here over at the NVMe 
side ...)

And: please drop the device handler thingie for this, and concentrate
on ALUA. No point in carrying legacy stuff around.
_AND_ you have to evaluate the ALUA settings anyway to get a decent
path selection.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
