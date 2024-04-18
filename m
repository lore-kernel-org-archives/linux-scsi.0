Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D2111BB
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 07:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713426130; cv=none; b=tNOPt48zXaIwxbRML/CgyVJGHD7HlZgxZA5X4I5OOlpd7yarF6Wz3zCcEuq/5eV5Vqukm4AcqZV7xFXpsrww3Klv5b3g53NJaT8BhMGa6CGK/Mtmt8YEMNwLsk3YqMIurgs6x+HTxGzWwp81UU0Z2BxXUgLgYs4B3j5AsrB6itE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713426130; c=relaxed/simple;
	bh=4QCi0wl+0WF7uops40+SQvjD4cx7bL2G4r06Djcfg3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ji1OApHgRlcRyXy5hlHqZ3y/ptJikf7rx1US1dTK6VfMWHK7C5FV3Ws78lGpl640lO9azmDhi+h4a0k3EMYQoSrRQ5+A8vqaF83A27k7HClVozjRAwz8T+uS6Voc5Rp98iVS0BMeCxfXGiX/lD1hfgmnTPkLzV8BpYKLoGA1bKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hwftvyrr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7hfDzh0U; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hwftvyrr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7hfDzh0U; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hwftvyrr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7hfDzh0U";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hwftvyrr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7hfDzh0U"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4C11E34B07;
	Thu, 18 Apr 2024 07:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713426127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBXzFLqH+BScYVzI+i3BEyl+pvpw1rH77mGnKGZ4rO0=;
	b=hwftvyrrzJNi3TCPsg0VFBgKc0NjEfJfVcZWlGNGfSu1kswwZhuxZfxIAHsyFCkx2Bd5ZI
	gFUHxyWwujnMKpB6fyPFKDDWmTJPYdTUttdmsD34Oz9sZJuhJ8l2N3opTwc4bpWZ/MUCtz
	riQYR6VbkTF+GBv1eX9YbT0bZuZrtrE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713426127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBXzFLqH+BScYVzI+i3BEyl+pvpw1rH77mGnKGZ4rO0=;
	b=7hfDzh0UfB/rWipCHXrQfaD+kI7UGkU+RoSmoVlEGPCIWjyDA8yTQS18pUM2bP0ofQsJX1
	T5z0loCMcBQ9z8AA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hwftvyrr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7hfDzh0U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713426127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBXzFLqH+BScYVzI+i3BEyl+pvpw1rH77mGnKGZ4rO0=;
	b=hwftvyrrzJNi3TCPsg0VFBgKc0NjEfJfVcZWlGNGfSu1kswwZhuxZfxIAHsyFCkx2Bd5ZI
	gFUHxyWwujnMKpB6fyPFKDDWmTJPYdTUttdmsD34Oz9sZJuhJ8l2N3opTwc4bpWZ/MUCtz
	riQYR6VbkTF+GBv1eX9YbT0bZuZrtrE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713426127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBXzFLqH+BScYVzI+i3BEyl+pvpw1rH77mGnKGZ4rO0=;
	b=7hfDzh0UfB/rWipCHXrQfaD+kI7UGkU+RoSmoVlEGPCIWjyDA8yTQS18pUM2bP0ofQsJX1
	T5z0loCMcBQ9z8AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B7181384C;
	Thu, 18 Apr 2024 07:42:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4IIGAs/OIGZNDwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 18 Apr 2024 07:42:07 +0000
Message-ID: <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de>
Date: Thu, 18 Apr 2024 09:42:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 James Bottomley <james.bottomley@hansenpartnership.com>,
 linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>
References: <20240418070015.27781-1-hare@kernel.org>
 <20240418070304.GA26607@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240418070304.GA26607@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.48
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4C11E34B07
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.48 / 50.00];
	BAYES_HAM(-2.98)[99.91%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]

On 4/18/24 09:03, Christoph Hellwig wrote:
> On Thu, Apr 18, 2024 at 09:00:15AM +0200, Hannes Reinecke wrote:
>> max_sectors can be modified via sysfs, but only in kb units.
> 
> Yes.
> 
>> Which leads to a misalignment on stacked devices if the original
>> max_sector size is an odd number.
> 
> How?
> 

That's an issue we've been seeing during testing:
https://lore.kernel.org/dm-devel/7742003e19b5a49398067dc0c59dfa8ddeffc3d7.camel@suse.com/

While this can be fixed in userspace (Martin Wilck provided a patchset
to multipath-tools), what I find irritating is that we will always
display the max_sectors setting in kb, even if the actual value is not
kb aligned.
_And_ we allow to modify that value (again in kb units). Which means 
that we _never_ are able to reset it to its original value.

I would vastly prefer to have the actual values displayed in sysfs,
ie either have a max_sectors_kb value for the block limits or have an
max_sectors setting in sysfs, but we really should avoid this 'shift by 
1' when displaying the value.

> Note that we really should not stack max_sectors anyway, as it's only
> used for splitting in the lower device to start with.

If that's the case, why don't we inhibit the modification for 
max_sectors on the lower devices?

Cheers,

Hannes

