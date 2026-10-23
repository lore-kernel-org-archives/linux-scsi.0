Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738755;
	b=IObEMN54ZqbAnIXNo2cxQnPNNXbqDvBlWM56cJO5IfTyadyREqImlna4vdOIOmlPkORI
	 eLDE9MfDoKBW8s0VRI9Hrju6CfNKoPi78kBwdvTYjScoeTOE7HPbXN5gayQRIVN5boUhO
	 ioSvos1dee6xBLH9zpqexW+wH6csUlu0nyIhgi9CqTgRDMU++CpM04cRwvWFMRHu4l6D+
	 xtU2XUhvMQMoU3VysisuI7dHGbbH0rBIAPyCA9lYAKiNVBLz6lxwQBmZkalOFDcG/GQku
	 VxC3OgMjZnh1QZH/xNt2ayLojQ6ThLroffOKf76AeyEDf1YI9ifgsLDasCtVJj1NSEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738755;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=nKhygDh8t1/tr9ZvswO65u9S1HHlDbaiv8u+NeY+j2U=;
	b=qldVcf7ibif6EkoYgwOQh13hNX9ocmDSMdRoNUhtvAcVprbPhXxsxbt0aaVAXq5ANRDw
	 9qw8tvjbezGXAmh2FcA7UeTtGOnVckv/9Y5AdS5B3J+GZGq7VgG2mpL/eopgq31ZcRyfS
	 J1hn7M/L92E8Uz3XC1lwky4r8gMo9DIQaCbNN/lq46WWaAmg8PZJH2M4kH5Vuf4KVMjLh
	 UoK/uvpqjtbP2g8fApGAuythdggNg9JGs7RKf3xF1scK1SMIPgzHrUsLUOBqY6rB2KPH/
	 aUdD5JpHSEwC8W1m+1gtN9bXOW5MPl7TOXEzODa/er+ih696S6s2s9TO/dCB0bOG92A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JsS4LXTm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=F5SqNr6m;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JsS4LXTm;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=F5SqNr6m;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CE9606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 06:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84CE9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JsS4LXTm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=F5SqNr6m;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JsS4LXTm;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=F5SqNr6m
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E8D91F829;
	Fri, 23 Oct 2026 06:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792738752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKhygDh8t1/tr9ZvswO65u9S1HHlDbaiv8u+NeY+j2U=;
	b=JsS4LXTmEGePY7UDPvkCTgIWQG/8BnFeby0Nh/yY5KkphnurFTy6ScpqBdI5Fipyv1I08i
	++fVXqmBfJCoHJAfleVJfmgLocRro5H2ZLl3+tnSnndhbZ9i93ezbQ0kyeyiVvZTXYo1es
	0aRUSR+A+e5PwuHgpFFr9E+6wPjMVdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792738752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKhygDh8t1/tr9ZvswO65u9S1HHlDbaiv8u+NeY+j2U=;
	b=F5SqNr6mVo6jRp3wovWjEzkP2EdFp7Ac8JnGl0MgdvlsVHCHD8vesHUt59Bhio1eo7BIq2
	wRMX3vyCBO3fLjAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792738752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKhygDh8t1/tr9ZvswO65u9S1HHlDbaiv8u+NeY+j2U=;
	b=JsS4LXTmEGePY7UDPvkCTgIWQG/8BnFeby0Nh/yY5KkphnurFTy6ScpqBdI5Fipyv1I08i
	++fVXqmBfJCoHJAfleVJfmgLocRro5H2ZLl3+tnSnndhbZ9i93ezbQ0kyeyiVvZTXYo1es
	0aRUSR+A+e5PwuHgpFFr9E+6wPjMVdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792738752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKhygDh8t1/tr9ZvswO65u9S1HHlDbaiv8u+NeY+j2U=;
	b=F5SqNr6mVo6jRp3wovWjEzkP2EdFp7Ac8JnGl0MgdvlsVHCHD8vesHUt59Bhio1eo7BIq2
	wRMX3vyCBO3fLjAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 303DA133F3;
	Fri, 23 Oct 2026 06:59:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hW+UAcAF22rnJgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 23 Oct 2026 06:59:12 +0000
Message-ID: <f342c6a8-635f-47ac-8541-bec410764bd0@suse.de>
Date: Fri, 23 Oct 2026 08:59:11 +0200
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
References: <524b50e3-cdcf-4cf3-861f-a647a07ae6e8@suse.de>
 <20261022180448.35270-1-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261022180448.35270-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.998];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29

On 10/22/26 8:04 PM, Brian Bunker wrote:
> On 10/22/26 1:56 PM, Hannes Reinecke wrote:
>> But if you want to have this behaviour it would make sense to modify
>> scsi_bus_match() to extend to pqual 01b, too; then 'sd' would stay
>> bound to the scsi device even after rescan, and we wouldn't need
>> to worry about driver detaching and multipathd becoming inoperational.
> [...]
>> But still it might be worthwhile exploring the idea of extending
>> scsi_bus_match(), as that will solve any ambiguity with 'sd' attaching
>> to the device.
> 
> I agree, and I'd much rather do that than the reprobe. It was my first
> idea in "The PQ=1 saga" thread in 2023, but matching PQ = 1 on its own
> isn't safe, and I think I now understand why Martin pushed back then.
> 
> PQ = 001b has two meanings. One is the ALUA unavailable state, which
> SPC-4 5.15.2.4.5 a) requires. The other is a LUN that isn't mapped to
> the initiator at all. SPC-4 6.6.1 says:
> 
>    In response to an INQUIRY command received by an incorrect logical
>    unit, the SCSI target device shall return the INQUIRY data with the
>    peripheral qualifier set to the value defined in 6.6.2. The device
>    server shall terminate an INQUIRY command with CHECK CONDITION
>    status only if the device server is unable to return the requested
>    INQUIRY data.
> 
> So the INQUIRY succeeds, and 6.6.2 decides the qualifier. An array
> can map a volume at any of its LUNs, so 011b ("The device server is
> not capable of supporting a peripheral device on this logical unit")
> would be wrong. 001b is the correct answer for a LUN that could hold a
> volume but currently doesn't:
> 
>    001b  A peripheral device having the indicated peripheral device type
>          is not connected to this logical unit. However, the device
>          server is capable of supporting the indicated peripheral device
>          type on this logical unit.
> 
> An array that returns PQ = 1 for an unmapped LUN is therefore doing
> exactly what the standard says. The trap is set elsewhere, by REPORT
> LUNS. Some arrays, at least in the past, returned a full LUN list
> (0 to 255) in REPORT LUNS and left it to the initiator to work out
> which LUNs were really there. Linux then sends INQUIRY to every one of
> them and, correctly, gets PQ = 1 back from all the unmapped ones. Binding sd at
> PQ = 1 would turn each of those into a disk with nothing behind it: no
> READ CAPACITY, no logical block size. I suspect that is the experience
> behind Martin's "there are also storage arrays out there that rely on
> PQ=1 to inhibit devices being claimed", and the IBM 2145 case in
> 948e922fc446 (PQ = 1, PDT 0 for a LUN that isn't mapped) looks like
> the same thing.
> 

I actually had similar experiences but dared not to raise them to
not derail the discussion :-)

> Checking TPGS doesn't help, because the TPGS bits come from the same
> INQUIRY response. The array fills in the standard INQUIRY data for an
> unmapped LUN the same way it does for a mapped one.
> 
> A command other than INQUIRY does tell the two apart. A LUN that isn't
> mapped rejects REPORT TARGET PORT GROUPS with LOGICAL UNIT NOT
> SUPPORTED, while a LU in the unavailable state must accept it
> (5.15.2.4.5 c)) and reports its target port group as unavailable.
> 
> The ALUA handler is already in the right place to send it.
> scsi_sysfs_add_sdev() calls scsi_dh_add_device() before device_add(),
> so scsi_dh_alua has attached before scsi_bus_match() runs. The only
> thing missing is the RTPG result: alua_check_vpd() queues the first
> RTPG with alua_rtpg_queue(), so it normally completes after the device
> has been matched.
> 
> So my proposal is:
> 
>    - In scsi_dh_alua, for a device that reported PQ = 1, send the first
>      RTPG synchronously at attach time and set sdev->access_state from
>      that device's own response. An unmapped LUN fails the RTPG and
>      stays as it is today. The queued RTPG and the shared port group
>      handling stay as they are, so an unmapped LUN can't pick up
>      another LU's state from the port group.
> 
>    - In scsi_bus_match(), match PQ = 0 as today, and also PQ = 1 when
>      access_state says unavailable.
> 
> sd then binds to an unavailable path whether the host was running when
> the path became unavailable or scanned while it was. The path stays in
> the multipath map as a failed path, multipathd keeps polling it, and
> the existing UNIT ATTENTION handling brings it back, as you described.
> This relies on scsi_dh_alua being attached at scan time (built in, or
> loaded before the scan), which I think is how it should work anyway.
> 
> It would replace the v8 reprobe completely: no INQUIRY refresh, no
> reprobe, and no change to the scan path.
> 
> Would you take a synchronous first RTPG in alua_check_vpd() for PQ = 1
> devices? If you'd rather keep the handler as it is, the alternative is
> for the SCSI core to send a TEST UNIT READY to PQ = 1 LUNs during the
> scan and look for LOGICAL UNIT NOT ACCESSIBLE, TARGET PORT IN
> UNAVAILABLE STATE, but I think the handler is the better place for it.
> 
Actually my proposal would even go a bit further: move the ALUA probing
out of the alua handler and into the SCSI core. ALUA is a standard SCSI
feature, and really is unrelated to multipathing. An admin might decide
to not use multipathing, but that doesn't change the fact that the
device supports ALUA.

So yes, that is a direction which I wanted to go anyway.
We could move 'submit_rtpg' into the SCSI core, and execute it
directly during scsi_add_lun(). Calling into the device handler
will be too much overhead as we don't need all this elaborate
'pg' parsing; all we're interested in here is to get the ALUA
state. That should be relatively straightforward.
And then we can evaluate the ALUA state during bus_probe and
we should be able to achieve what we wanted.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
