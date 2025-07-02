Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354991F03D7
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jul 2025 06:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751436632; cv=none; b=R19ud8/HOO1qFRlulD8THFhcIs53+imDDB+JIfMOdpRi+LG1hM6c//WqdljoJ/aenV68hsl7fSTemV/EDXsjJIg15wEGLzRxK6dutn1scsNzNURKDIoXeRFrJVxCBMVybk7cmVgLBpZjEHsPDTym1BM6MpgP6qDsc9MvO+F/Xeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751436632; c=relaxed/simple;
	bh=M+RiMhsbFKCenRJrYuxL1NAXDC9Xh9KyvQ+u0k1T7jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=exsHszXYfovaYLg3aB71uDxjPuY+6EO6ECJ68pdybJ6EmH33pdM7JGAfEknDiZK2wkqkVtQofUMmCaHzrv+rEVaz5l71xxeu2sPklkJiS2qJRQHr1fnkYdabeN1Vs56RXNLBwA5T7O0VJKKcGzu0ys3B623SBAsgy7JTgD3pjP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=N50sR1SZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LKbe5G41; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=N50sR1SZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LKbe5G41; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="N50sR1SZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LKbe5G41";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="N50sR1SZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LKbe5G41"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 913FD21170;
	Wed,  2 Jul 2025 06:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751436621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvXNgKIH4c0Oy8VN73pE/BszpayY8H0xsqbH138onlU=;
	b=N50sR1SZ37HvI6DvqEEfqOLbku8CWvqCc5oryUKPu4JxSYif93FV1UCFXLGcH9xk+3da0X
	KwfL7tYYkYXP1PXmi4d5oGqV0ipBIjzcNKaKbH9kd24vO6Sux0HmYDCXplkjN0jl99npBY
	TbxsWR5f6JmpXfSw9nLCWNDKUFd9jY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751436621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvXNgKIH4c0Oy8VN73pE/BszpayY8H0xsqbH138onlU=;
	b=LKbe5G41lTjPFoDK7EHdJJlooDYR0pubIZdOVNnK/RH5/bdH26rPD5JkuPOetYyFXPSQP4
	TxuLGcS3WtHOfpBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=N50sR1SZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LKbe5G41
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751436621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvXNgKIH4c0Oy8VN73pE/BszpayY8H0xsqbH138onlU=;
	b=N50sR1SZ37HvI6DvqEEfqOLbku8CWvqCc5oryUKPu4JxSYif93FV1UCFXLGcH9xk+3da0X
	KwfL7tYYkYXP1PXmi4d5oGqV0ipBIjzcNKaKbH9kd24vO6Sux0HmYDCXplkjN0jl99npBY
	TbxsWR5f6JmpXfSw9nLCWNDKUFd9jY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751436621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvXNgKIH4c0Oy8VN73pE/BszpayY8H0xsqbH138onlU=;
	b=LKbe5G41lTjPFoDK7EHdJJlooDYR0pubIZdOVNnK/RH5/bdH26rPD5JkuPOetYyFXPSQP4
	TxuLGcS3WtHOfpBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A13113A24;
	Wed,  2 Jul 2025 06:10:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vZu2BE3NZGjtJQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 02 Jul 2025 06:10:21 +0000
Message-ID: <19484829-0a7b-42ce-99fe-e74ccda67dce@suse.de>
Date: Wed, 2 Jul 2025 08:10:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] nvme-fc: FPIN link integrity handling
To: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, jmeneghi@redhat.com
References: <20250624202020.42612-1-bgurney@redhat.com>
 <CAHhmqcTO_Q59aDr3DywC-tPF=9pe3gxbyn6J4ycdf+eYEOayHQ@mail.gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAHhmqcTO_Q59aDr3DywC-tPF=9pe3gxbyn6J4ycdf+eYEOayHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 913FD21170
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51
X-Spam-Level: 

On 7/1/25 22:32, Bryan Gurney wrote:
> On Tue, Jun 24, 2025 at 4:20 PM Bryan Gurney <bgurney@redhat.com> wrote:
>>
>> FPIN LI (link integrity) messages are received when the attached
>> fabric detects hardware errors. In response to these messages I/O
>> should be directed away from the affected ports, and only used
>> if the 'optimized' paths are unavailable.
>> Upon port reset the paths should be put back in service as the
>> affected hardware might have been replaced.
>> This patch adds a new controller flag 'NVME_CTRL_MARGINAL'
>> which will be checked during multipath path selection, causing the
>> path to be skipped when checking for 'optimized' paths. If no
>> optimized paths are available the 'marginal' paths are considered
>> for path selection alongside the 'non-optimized' paths.
>> It also introduces a new nvme-fc callback 'nvme_fc_fpin_rcv()' to
>> evaluate the FPIN LI TLV payload and set the 'marginal' state on
>> all affected rports.
>>
>> The testing for this patch set was performed by Bryan Gurney, using the
>> process outlined by John Meneghini's presentation at LSFMM 2024, where
>> the fibre channel switch sends an FPIN notification on a specific switch
>> port, and the following is checked on the initiator:
>>
>> 1. The controllers corresponding to the paths on the port that has
>> received the notification are showing a set NVME_CTRL_MARGINAL flag.
>>
>>     \
>>      +- nvme4 fc traddr=c,host_traddr=e live optimized
>>      +- nvme5 fc traddr=8,host_traddr=e live non-optimized
>>      +- nvme8 fc traddr=e,host_traddr=f marginal optimized
>>      +- nvme9 fc traddr=a,host_traddr=f marginal non-optimized
>>
>> 2. The I/O statistics of the test namespace show no I/O activity on the
>> controllers with NVME_CTRL_MARGINAL set.
>>
>>     Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
>>     nvme4c4n1         0.00         0.00         0.00         0.00
>>     nvme4c5n1     25001.00         0.00        97.66         0.00
>>     nvme4c9n1     25000.00         0.00        97.66         0.00
>>     nvme4n1       50011.00         0.00       195.36         0.00
>>
>>
>>     Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
>>     nvme4c4n1         0.00         0.00         0.00         0.00
>>     nvme4c5n1     48360.00         0.00       188.91         0.00
>>     nvme4c9n1      1642.00         0.00         6.41         0.00
>>     nvme4n1       49981.00         0.00       195.24         0.00
>>
>>
>>     Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
>>     nvme4c4n1         0.00         0.00         0.00         0.00
>>     nvme4c5n1     50001.00         0.00       195.32         0.00
>>     nvme4c9n1         0.00         0.00         0.00         0.00
>>     nvme4n1       50016.00         0.00       195.38         0.00
>>
>> Link: https://people.redhat.com/jmeneghi/LSFMM_2024/LSFMM_2024_NVMe_Cancel_and_FPIN.pdf
>>
>> More rigorous testing was also performed to ensure proper path migration
>> on each of the eight different FPIN link integrity events, particularly
>> during a scenario where there are only non-optimized paths available, in
>> a state where all paths are marginal.  On a configuration with a
>> round-robin iopolicy, when all paths on the host show as marginal, I/O
>> continues on the optimized path that was most recently non-marginal.
>>  From this point, of both of the optimized paths are down, I/O properly
>> continues on the remaining paths.
>>
>> Changes to the original submission:
>> - Changed flag name to 'marginal'
>> - Do not block marginal path; influence path selection instead
>>    to de-prioritize marginal paths
>>
>> Changes to v2:
>> - Split off driver-specific modifications
>> - Introduce 'union fc_tlv_desc' to avoid casts
>>
>> Changes to v3:
>> - Include reviews from Justin Tee
>> - Split marginal path handling patch
>>
>> Changes to v4:
>> - Change 'u8' to '__u8' on fc_tlv_desc to fix a failure to build
>> - Print 'marginal' instead of 'live' in the state of controllers
>>    when they are marginal
>>
>> Changes to v5:
>> - Minor spelling corrections to patch descriptions
>>
>> Changes to v6:
>> - No code changes; added note about additional testing
>>
>> Hannes Reinecke (5):
>>    fc_els: use 'union fc_tlv_desc'
>>    nvme-fc: marginal path handling
>>    nvme-fc: nvme_fc_fpin_rcv() callback
>>    lpfc: enable FPIN notification for NVMe
>>    qla2xxx: enable FPIN notification for NVMe
>>
>> Bryan Gurney (1):
>>    nvme: sysfs: emit the marginal path state in show_state()
>>
>>   drivers/nvme/host/core.c         |   1 +
>>   drivers/nvme/host/fc.c           |  99 +++++++++++++++++++
>>   drivers/nvme/host/multipath.c    |  17 ++--
>>   drivers/nvme/host/nvme.h         |   6 ++
>>   drivers/nvme/host/sysfs.c        |   4 +-
>>   drivers/scsi/lpfc/lpfc_els.c     |  84 ++++++++--------
>>   drivers/scsi/qla2xxx/qla_isr.c   |   3 +
>>   drivers/scsi/scsi_transport_fc.c |  27 +++--
>>   include/linux/nvme-fc-driver.h   |   3 +
>>   include/uapi/scsi/fc/fc_els.h    | 165 +++++++++++++++++--------------
>>   10 files changed, 269 insertions(+), 140 deletions(-)
>>
>> --
>> 2.49.0
>>
> 
> 
> We're going to be working on follow-up patches to address some things
> that I found in additional testing:
> 
> During path fail testing on the numa iopolicy, I found that I/O moves
> off of the marginal path after a first link integrity event is
> received, but if the non-marginal path the I/O is on is disconnected,
> the I/O is transferred onto a marginal path (in testing, sometimes
> I've seen it go to a "marginal optimized" path, and sometimes
> "marginal non-optimized").
> 
That is by design.
'marginal' paths are only evaluated for the 'optimized' path selection,
where it's obvious that 'marginal' paths should not be selected as
'optimized'.
For 'non-optimized' the situation is less clear; is the 'non-optimized'
path preferrable to 'marginal'? Or the other way round?
So once the 'optimized' path selection returns no paths, _any_ of the
remaining paths are eligible.

> The queue-depth iopolicy doesn't change its path selection based on
> the marginal flag, but looking at nvme_queue_depth_path(), I can see
> that there's currently no logic to handle marginal paths.  We're
> developing a patch to address that issue in queue-depth, but we need
> to do more testing.
> 
Again, by design.
The whole point of the marginal path patchset is that I/O should
be steered away from the marginal path, but the path itself should
not completely shut off (otherwise we just could have declared the
path as 'faulty' and be done with).
Any I/O on 'marginal' paths should have higher latencies, and higher
latencies should result in higher queue depths on these paths. So
the queue-depth based IO scheduler should to the right thing
automatically.
Always assuming that marginal paths should have higher latencies.
If they haven't then they will be happily selection for I/O.
But then again, if the marginal path does _not_ have higher
latencies why shouldn't we select it for I/O?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
