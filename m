Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0ED289811
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 07:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771400127; cv=none; b=u+ylA2wV1KKPQTPktm9T6qHTa5S+xU4o9lPgkWlh0Qjoj+vO41CBexFDluG9BpW+9NueBfX/ur+tJU+Vd6QI4h7X9RHJplvJtRkEy7hIPWmrhKqqyDvUzpSYqyydCf8gjjcYoPe1Aivf88Xnh3a+049Lf1rJehD438LUpbY2H+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771400127; c=relaxed/simple;
	bh=2sMHEIy77t83b9Wdod8KjQGkFcb7iXMRxVCMBMRQ2Is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XbuOKJgzzwE5jB0BK/2KxJ83hIeC8X6OH3P9lLR4wrJTWRe+zm0fE1jBvFqwYQzWfMUkByXtlnkCpKhyggbF0Odz0iH/nPIioGqq5YN9u8m3k6MC59MPgJ/8IpnsoqElof45Jv30k0xkylrjoQjmAgYLhfHs+QFxowrUuE5FzHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uzxkKbB2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q9cTEWAT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uzxkKbB2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q9cTEWAT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uzxkKbB2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q9cTEWAT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uzxkKbB2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q9cTEWAT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D9DA5BCD4;
	Wed, 18 Feb 2026 07:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771400124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykSHjiemRbT1if77r09t0W8Nd+/mBTPm+gvjlcPzmO8=;
	b=uzxkKbB28emIcSbarrabqTPprY+oaGHZ4vJ6zOp5J1Aw/JoAK2bS5HetVpTRqFjqeoUyON
	WEljlAlvxoXFqpPqu5UgO8LUGeYg+RNypUlg75QhNaKCj++dXRFFeXQcgiS+BXPSQamDol
	F48AYJ0Af7QgrsnA8N+bAnccY3Y3QI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771400124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykSHjiemRbT1if77r09t0W8Nd+/mBTPm+gvjlcPzmO8=;
	b=q9cTEWAT8pbRdRlxv2kmy2mprkdTp7vAcK96o0M0hk4UIX7Hw6E3xuGYCM9uzN0OPhjsD7
	lYth8a9ynmV+3CCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771400124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykSHjiemRbT1if77r09t0W8Nd+/mBTPm+gvjlcPzmO8=;
	b=uzxkKbB28emIcSbarrabqTPprY+oaGHZ4vJ6zOp5J1Aw/JoAK2bS5HetVpTRqFjqeoUyON
	WEljlAlvxoXFqpPqu5UgO8LUGeYg+RNypUlg75QhNaKCj++dXRFFeXQcgiS+BXPSQamDol
	F48AYJ0Af7QgrsnA8N+bAnccY3Y3QI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771400124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykSHjiemRbT1if77r09t0W8Nd+/mBTPm+gvjlcPzmO8=;
	b=q9cTEWAT8pbRdRlxv2kmy2mprkdTp7vAcK96o0M0hk4UIX7Hw6E3xuGYCM9uzN0OPhjsD7
	lYth8a9ynmV+3CCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 133AD3EA65;
	Wed, 18 Feb 2026 07:35:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GfJ4A7xrlWkcawAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Feb 2026 07:35:24 +0000
Message-ID: <f658021c-471a-4f30-bd76-1d5c7b7d79de@suse.de>
Date: Wed, 18 Feb 2026 08:35:23 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Keith Busch via Lsf-pc <lsf-pc@lists.linux-foundation.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Keith Busch <kbusch@kernel.org>,
 John Garry <john.g.garry@oracle.com>, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <049a177d-85d6-4c9d-9a9a-f07391046101@acm.org> <aZTL8srSowTU81Rz@kbusch-mbp>
 <yq1seaydbee.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <yq1seaydbee.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-8.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -8.30
X-Spam-Level: 

On 2/18/26 03:39, Martin K. Petersen wrote:
> 
> Keith,
> 
>> For nvme, we can detect if a device is multipath capable.
> 
> Yep. Same with SCSI...
> 
And that's how we handle things currently. We've learned from long and 
painful experiences that there is _NO_ way to automatically figure out
if a device is multipathed. That will always be an admin decision, so
there needs to be an opt-in mechanism.
And that needs to be set _prior_ to probing.
And you need a driver-specific opt-out, to disable all devices from
this driver for multipathing (UFS, USB, ATA, you name it).

Once you have that you can declare all ALUA capable devices with
a VPD page 83 device identifier as multipathed. Irrespective of
how many paths will show up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
