Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28382EC084
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 08:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758011353; cv=none; b=Qk2ER6VaLnHHW77In+4JZcJI0syI/6TgMgkABwC9hDCZy8ihwQicTPyH9+kDi9TgtbJtWoJnKpgVfTnn1fzIB7hw4GG/iyR35XQL6zZ5gJaWh46CS9Y7fjXXtR2q4iNjY9YNM92+8qOD4kw3168c0tmeGrBfFriiQ8ys/e58+J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758011353; c=relaxed/simple;
	bh=WECWLQq1CclnnQyAInRTTIgZVeHJXWKe3tHKlWXoLEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c0S6M4RqJCNB66AiMKNxdvfqKG/b+RDCoK2j2BFwFvhmKcN0FBMtkPr9PpbU7MrCKFAjhuEnFMQmz2e2ZOvitdwq0lbwzZA2/V9KU44VM4RltTZHeylV2iaAw7cmVoP1ohtJYpvis5zKNoUjifBjb3czAXqDxFSfTyUG7f/mxFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Vibg32mF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KNeTC0Dx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ybnFKpe3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BlARIKl6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Vibg32mF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KNeTC0Dx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ybnFKpe3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BlARIKl6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3B67D1F8BA;
	Tue, 16 Sep 2025 08:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758011343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eO9FQdvHlabRz5q2huemXXwNLjUiBxcmw8NR/mV+DIw=;
	b=Vibg32mFBrQcl4REGXitDuUhH9PJbk+z3NxxyPF7b4uyBZStMUdsllMJ9Vn7YwEVb4CGuy
	A4Aq7rUAmFHVquOU+26/Ygs1MwO2uPREt2FX9KIKggH8jJ+oXo/1WZQIWJfU+Tj9wFTNqr
	Dp53GA1bk5kHmT63Xhz3XdUGcl63vdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758011343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eO9FQdvHlabRz5q2huemXXwNLjUiBxcmw8NR/mV+DIw=;
	b=KNeTC0Dx1YZ/t1gg8PNil9bgsCuWFVjrAiWVcc4/0RQe+5KBoB+kfD3sSW8JBnBwE/qqDf
	J2xcSZtCAKTODkAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758011342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eO9FQdvHlabRz5q2huemXXwNLjUiBxcmw8NR/mV+DIw=;
	b=ybnFKpe3B6m80yFt4TOclOPV8HtDVaNHMXCsPGcfqvZx1YoF9dLGwCwi/X6BjwsYofkAZc
	sNqvNS8K54vaha3D7A1ef+jXCofHz1XwXIOsYvCel1yU5ESNmpuoGU6gOo98z2WG65qVSj
	byLlWHlYySp9DliR9EldEEt6zuLyZs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758011342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eO9FQdvHlabRz5q2huemXXwNLjUiBxcmw8NR/mV+DIw=;
	b=BlARIKl69eYQzpyw6kTateXi63T5dOuYhg08TmpVr986E0yybCN3SrXc/TKJOCj3ZA+Elz
	9ODgVs3bn3aILEDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 290A513A63;
	Tue, 16 Sep 2025 08:29:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NK1uCc4fyWj1HwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 16 Sep 2025 08:29:02 +0000
Message-ID: <5f3fa272-b438-4261-8ae7-52fa8e0cc438@suse.de>
Date: Tue, 16 Sep 2025 10:28:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/29] scsi: core: Move two statements
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-3-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250912182340.3487688-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 9/12/25 20:21, Bart Van Assche wrote:
> Move two statements that will be needed for pseudo SCSI devices in front
> of code that won't be needed for pseudo SCSI devices. No functionality
> has been changed.
> 
> CC: John Garry <john.g.garry@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_scan.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
