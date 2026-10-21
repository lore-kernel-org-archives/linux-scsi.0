Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579556;
	b=g1G7tpCiusqSnZEQ9tvYl6Da+YPPQMT40i/A+gbIy0Dz84f/rLPoEpQizJpj9iG0v9no
	 E8D1Tv+mcrukzloIkQi8AaIXb3pL8ATsU6uHDQ62CaHhqH13q8Ipa753SBHPg3gKIcB4m
	 BIj82Fud4+RoKelwA3hFPxH1r3t10GPE1vDO+02vXjto00J5/Ipr+o3r3x7OJXokUYF0+
	 HWRX+5DMPvb3u6kmCMU19FUCVcQydD/pDDALiAlIm1NDbyfgibjKoVrwue0q4N/PujkcK
	 WU3eggzfa+HRKTLc4CBT4+uXIxsMj4Xkjlc9x9cgbTOiyac9s+2G6ccP2MJ7gtRzhQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579556;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=uAZ98h49AZYOda3phJMYLD8fmiuVtjQgNPhl9/dVs1E=;
	b=D2G/G9cAFSDuiwKH1DCE4VxQ1C3/S6CRUkQcbzPSPlNzhnysTiAvNOwOHskjxZ0Hbi5m
	 dbcJOpSOQen8LPFRV004XLUtYt/mcAZaVghmvPFEfhy56IefoPYZb77vpAVrg8EiiWhj4
	 6DBXiDWN/5XT2wQxaaIdqzF6AglJ88bJP9T3yZxP4onbflqk8KzTvCnbmonWLauo2jQ+o
	 VsenfOvqCWdfg+GcbeQy/aCeeHpqq4xLSMJBn+2hJ21couji1gB4FOob75Ed5U794mR1S
	 sdDaOgQjvrrBAd6Zr4zXdAns61pO2oPolRAYYBwCu1LQ2K4RPBkWGPXs6paWsgaoVoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UOKlZfHM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9W96I1iI;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UOKlZfHM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9W96I1iI;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6130E606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6130E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UOKlZfHM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9W96I1iI;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UOKlZfHM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9W96I1iI
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D9771F46E;
	Wed, 21 Oct 2026 10:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792579553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uAZ98h49AZYOda3phJMYLD8fmiuVtjQgNPhl9/dVs1E=;
	b=UOKlZfHMExfD852o146lWc+Xxjj8fyjwXwrIWsyLlwIUpjrxMJkUp8al6cFlRZRcFD8eKo
	PYe+uIxStgdBB40FjPo12nwqhRkVZL65RsouthEEgcP3zZuZ1l4EU4ELV6Snx9xbbL+DcV
	WAjgTaiFNiGfu4cLAdYkwPCVgjGNiZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792579553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uAZ98h49AZYOda3phJMYLD8fmiuVtjQgNPhl9/dVs1E=;
	b=9W96I1iIFUQ9JnDd22lPCD+s52OL3xwl6W7yyrHhCdR1UXnsz3uoa/LNgboE0hW8FJK2Ks
	I2WzGbXcPmVi61Bg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UOKlZfHM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9W96I1iI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792579553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uAZ98h49AZYOda3phJMYLD8fmiuVtjQgNPhl9/dVs1E=;
	b=UOKlZfHMExfD852o146lWc+Xxjj8fyjwXwrIWsyLlwIUpjrxMJkUp8al6cFlRZRcFD8eKo
	PYe+uIxStgdBB40FjPo12nwqhRkVZL65RsouthEEgcP3zZuZ1l4EU4ELV6Snx9xbbL+DcV
	WAjgTaiFNiGfu4cLAdYkwPCVgjGNiZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792579553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uAZ98h49AZYOda3phJMYLD8fmiuVtjQgNPhl9/dVs1E=;
	b=9W96I1iIFUQ9JnDd22lPCD+s52OL3xwl6W7yyrHhCdR1UXnsz3uoa/LNgboE0hW8FJK2Ks
	I2WzGbXcPmVi61Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4F57134A5;
	Wed, 21 Oct 2026 10:45:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jX1+LuCX2Gr0ZQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 10:45:52 +0000
Message-ID: <b4ea3aa9-7db5-4af9-a893-ae2af3c05eed@suse.de>
Date: Wed, 21 Oct 2026 12:45:52 +0200
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
To: Brian Bunker <brian@purestorage.com>, Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James.Bottomley@HansenPartnership.com, krishna.kant@purestorage.com
References: <120fc95e-432a-4f05-aa87-54873363ed9f@acm.org>
 <20261020171748.7207-1-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261020171748.7207-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D9771F46E
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 10/20/26 7:17 PM, Brian Bunker wrote:
> On 10/19/26 3:41 PM, Bart Van Assche wrote:
>> Some feedback from an experimental LLM can be found below. Please take a
>> look.
> 
> Hi Bart,
> 
> Thanks for the detailed review. Before I post v9, I want to answer the
> design question so that v9 isn't heading in a direction you and Martin
> don't want.
> 
>> The open question: a target can now remove a disk that is bound and in
>> use. [...] My suggestion is to only reprobe when no driver is bound
>> (PQ 1 -> 0), but the author should say which direction the ALUA case
>> actually needs.
> 
> Both directions. Let me describe the setup that motivates this, because
> it isn't a short interruption.
> 
> Pure ActiveCluster is two separate arrays that present the same volume.
> The volume is synchronously replicated between them, and each array
> exposes it through its own front-end ports, which are in their own
> target port groups. A host sees paths to both arrays as one multipath
> device.
> 
> When the replication link between the arrays breaks, one array keeps
> serving the volume and the other must stop, because it can no longer
> mirror writes or persistent reservation changes to its peer. Its
> front-end ports stay up, but its paths must not serve I/O. The array
> reports those target port groups as unavailable. Unavailable is the
> state we can use here, because its required command set is one we can
> fully support without the link: we don't have to accept reservations
> we cannot mirror. This lasts as long as the link is down, which can be
> much longer than a microcode download.
> 
>> - Cite the SPC text that requires a PQ change across the ALUA
>> unavailable state.
> 
> You're right that the citation in 4/5 is wrong; it should be SPC-4
> 5.15.2.4.5, not 5.15.2.4.4. That section says that while in the
> unavailable state the device server shall support:
> 
>    a) INQUIRY (the peripheral qualifier (see 6.6.2) shall be set to
>       001b);
> 
> So the PQ change isn't something we chose: once the array uses
> unavailable, the standard requires PQ = 001b. We set it to 1 on
> entering unavailable and back to 0 when we leave it.
> 
Aw. The mysteries of SPC. Can't you simply use 'Standby' state?
That would not require all this weird rescanning.

> Why I think Linux should honor it in both directions: today the
> outcome depends on when the host looked, not on what the target
> reports.
> 
>    - A host that scans while the link is down sees PQ = 1 on those
>      paths. scsi_bus_match() doesn't bind sd, so they are not disks.
>      When the link comes back and PQ returns to 0, nothing binds sd, and
>      those paths stay unusable until someone deletes and rescans the
>      device. That is the bug this series started from.
> 
Weelll ... an 'unavailable' device _never_ comes back.
The only chance it had to 'come back' would be to set a UNIT ATTENTION.
But that we will only ever see if we send commands to that device,
which we don't as it's unavailable ...

Unless the 'active' path is allowed to set a unit attention on behalf
of the unavailable paths, but I don't think that's possible.

Also we have to worry about the implications for multipathing:
If the device is set to 'unavailable' we'll be disconnecting it
from multipathing as the 'sd' driver will be detached.
So we'll need a full rescan (and a multipath rebuild) to get it
back.

If, say, the device would report 'standby' than it would appear
like 'just' another active-passive array, multipath maps would
be left intact, multipath would do the polling, and the device
will be reinstated once the internal link is back up.

We'll be missing all of these things when you set the device
to 'unavailable'.
What it the proposed strategy to get it back?

Note: this is completely orthogonal to this patchset.
It's just me wondering how this setup is supposed to work.

>    - A host that was already running keeps sd bound on the same paths
>      for as long as the link is down.
> 
> Reprobing on a PQ change in either direction makes the binding follow
> the PQ the target reports, which is the rule the scan path already
> applies. With dm-multipath, the unavailable paths leave the map while
> the link is down and come back as new paths afterwards, while the
> other array's paths keep serving I/O. Without multipath, a disk whose
> only path is unavailable cannot do I/O anyway, and it reappears when
> PQ returns to 0.
> 
> If you or Martin would still rather not unbind a bound disk by
> default, please say so now and I'll rework v9 around that.
> 
>> Offlining can't be undone: [...] I'd drop the offline step.
> 
> Agreed. Hannes, you asked in the v4 review for more than a warning when
> device_reprobe() fails, which is where the SDEV_OFFLINE step came from.
> But Bart is right: scsi_rescan_device() only acts on SDEV_RUNNING
> devices, so an offlined device never comes back through a later
> rescan, and failing to bind a ULD is not an I/O error. For v9 I plan to
> just log a real reprobe failure and not treat -EPROBE_DEFER as one.
> Please shout if you see that differently.
> 
Yes, but that was the point.
If reprobe fails, what are you going to do?
You cannot 'magically' get it back, as _normally_ you would do a reprobe
to get it back. But that failed. So you _really_ need to delete that
device and restart from scratch.

>> 5/5 widens rescan behaviour a lot.
> 
> 5/5 is needed for FC, but you're right that it does far too much. The
> two directions reach the host differently:
> 
>    - Entering unavailable, the array reports INQUIRY DATA HAS CHANGED
>      (along with the ALUA state change). sd is bound and I/O is flowing,
>      so the host sees the UNIT ATTENTION on its next command, and
>      scsi_evt_thread() -> scsi_rescan_device() handles it. That is 4/5.
> 
>    - Leaving unavailable, a UNIT ATTENTION alone doesn't work. With
>      PQ = 1 nothing is bound to the LUN and no commands reach it, so
>      nothing ever sees the UNIT ATTENTION. So the array also makes the
>      host rescan, the same way it does when the first volume is mapped
>      to a host.
> 
>      On iSCSI it sends an asynchronous SCSI event with REPORTED LUNS
>      DATA HAS CHANGED. iscsid writes to the sysfs rescan attribute of
>      every existing device on the session, which is scsi_rescan_device()
>      and therefore 4/5, and then scans the host for new LUNs.
> 
>      On FC there is no equivalent, so it logs out the host's initiators.
>      After the re-login, fc_scsi_scan_rport() calls
>      scsi_scan_target(..., SCSI_SCAN_RESCAN), and that scan finds the
>      existing scsi_device. Without 5/5 it does nothing with it, PQ = 0
>      is never seen, and sd never binds.
> 
When do you do the LOGO? When entering the unavaiblable state?
Or when resetting it back to normal?

> So the scan path only has to handle LUNs that can't receive a UNIT
> ATTENTION, which are the ones with no driver bound. For v9 I plan to
> limit 5/5 to existing devices that are registered and have no driver
> bound. A bound LUN learns about INQUIRY changes through UNIT ATTENTIONs
> on its own I/O, so the scan path leaves it alone. On a normal host that
> skips nearly every LUN, which removes the per-scan cost and the
> scan_mutex hold time you described. It also avoids the double LUN 0
> rescan, except in the rare case where LUN 0 itself has no driver bound.
> 
See above.

The whole thing would be _so_ much easier if your array could return
'standby' instead of 'unavailable', as then most of the issues above
wouldn't apply.
But that's not my decision to take...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
