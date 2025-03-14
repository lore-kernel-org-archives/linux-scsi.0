Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1410738FAD
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741962970; cv=none; b=C/axV1+EB1mmeueUSl+oSXhq/B847/lupfywK8ummsuqhdqshEhChRdmCz16Ygo7v7ng4IF814wNXa84SHkSq4dgzfnLlooEdxjVYorpbGW8Dvw+HoDXqcKICDv3AEleEhiFLN5BMAFYj0+GGxe7720zex4u/DD3iPp1xfCKXXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741962970; c=relaxed/simple;
	bh=sXJIwmtqKblQwAxEVSBc5SM5lawWIjzWjwB9MkHBmxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IFMcgbvlQzwaSgfBbKeTXUnv0o3qATm1rLj3nXF1SAEHJ8UP7lq7QACdrDxPLM90UZuLpXZYBZ6+Hqfwus4BnMPBz5Q7wOdJF1yDaJPbwWZrW5e0jNEqnunhZhQAzFqiIbuxJtxnzUJRpv6wLnL99m0PMbp5tSjrsBuKRKaDmnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GCSlYeVZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Iz6sUYG7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GCSlYeVZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Iz6sUYG7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GCSlYeVZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Iz6sUYG7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GCSlYeVZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Iz6sUYG7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19A8D2116E;
	Fri, 14 Mar 2025 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741962966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=yJQBM744V04GnWdghZG8u/KPXr0FZd2K8k+6MRVa1B4=;
	b=GCSlYeVZ69fUVRBktpgzFvWelXVANuNCsBB8PrYJHLKZ7AIvQzTQTcgTRD2G/lcQoIjP9d
	EGe3CBt4wV1SKJgs8QyGRcsmivuRML6SqYiva6OHZUCQ5SzozIMdU7gkPeu176oInlF7ft
	1FrCss0knC6ggJr1Nv7QECZNZ94kOMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741962966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=yJQBM744V04GnWdghZG8u/KPXr0FZd2K8k+6MRVa1B4=;
	b=Iz6sUYG7gZw+OCoa2Q3gjLBdUpMt+m6jyPzT8RAqb3CSK/C2wy8390F/o817+LIB9QOoRl
	3foQzYK5NfhIviAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741962966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=yJQBM744V04GnWdghZG8u/KPXr0FZd2K8k+6MRVa1B4=;
	b=GCSlYeVZ69fUVRBktpgzFvWelXVANuNCsBB8PrYJHLKZ7AIvQzTQTcgTRD2G/lcQoIjP9d
	EGe3CBt4wV1SKJgs8QyGRcsmivuRML6SqYiva6OHZUCQ5SzozIMdU7gkPeu176oInlF7ft
	1FrCss0knC6ggJr1Nv7QECZNZ94kOMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741962966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=yJQBM744V04GnWdghZG8u/KPXr0FZd2K8k+6MRVa1B4=;
	b=Iz6sUYG7gZw+OCoa2Q3gjLBdUpMt+m6jyPzT8RAqb3CSK/C2wy8390F/o817+LIB9QOoRl
	3foQzYK5NfhIviAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED64213A31;
	Fri, 14 Mar 2025 14:36:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I/6pONU+1GdCOAAAD6G6ig
	(envelope-from <trenn@suse.de>); Fri, 14 Mar 2025 14:36:05 +0000
From: Thomas Renninger <trenn@suse.de>
To: megaraidlinux.pdl@broadcom.com
Cc: shivasharan.srikanteshwara@broadcom.com, linux-scsi@vger.kernel.org,
 nhorman@tuxdriver.com
Subject:
 Blacklist megaraid_sas driver driven irqs in irqbalance - Longterm kernel
 solution thought about?
Date: Fri, 14 Mar 2025 15:36:05 +0100
Message-ID: <2724461.lGaqSPkdTl@laptop.fritzbox>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2538252.XAFRqVoOGU";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Level: 
X-Spamd-Result: default: False [-5.40 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SIGNED_PGP(-2.00)[];
	SUBJECT_ENDS_QUESTION(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	MISSING_XM_UA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -5.40
X-Spam-Flag: NO

--nextPart2538252.XAFRqVoOGU
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Thomas Renninger <trenn@suse.de>
To: megaraidlinux.pdl@broadcom.com
Date: Fri, 14 Mar 2025 15:36:05 +0100
Message-ID: <2724461.lGaqSPkdTl@laptop.fritzbox>
MIME-Version: 1.0

Hi,

I have a request to blacklist megaraid_sas driver in irqbalance.

According to some developers it's known that megaraid (sas?) does have issues 
with migrating IRQs at runtime which could lead to Null pointer dereferences 
when handling IRQs (an example backtrace pasted at the end).

I understand the problem like:
- These cards can initialize on any (or at least on affinity hint pointing) irqs 
without problems. The issue/freeze rises when those IRQs are migrated while 
the card is operating.
- If smp_affinity_enable=0 is passed the PCI/platform irq affinity hints will/
might be ignore which could lead to a dramatically performance regression
- A longterm mainline solution might be to split smp_affinity (hint) 
initialization feature and IRQ migration feature for PCI drivers and disable 
the latter by default for affected cards.

Does that make sense?

A confirmation from developers working on these drivers/HW would be very much 
appreciated. I'd like to submit the blacklisting to mainline irqbalance 
project as well if it makes sense if it cannot be handled in the kernel yet.

Thanks,

             Thomas


Call Trace:
 <IRQ>
 megasas_isr_fusion+0x84/0x90 [megaraid_sas 
d7ec7902299b887bdbcf4651784a30e2e26d5c22]
 __handle_irq_event_percpu+0x36/0x1a0
 handle_irq_event_percpu+0x30/0x70
 handle_irq_event+0x34/0x60
 handle_edge_irq+0x7e/0x1a0
 __common_interrupt+0x3b/0xb0
 common_interrupt+0x58/0xa0
 </IRQ>
--nextPart2538252.XAFRqVoOGU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEo0EXulPW3gW/5bAoTxjWwdl3vVUFAmfUPtUACgkQTxjWwdl3
vVXWLQgAlalAB2WcQVfTBgogj7s6VcIbZaDoBUAfHr0RyfeiTxfbe/33UCxAAR66
xIUTb/t5YtrcN0AyfMwAT3SIrhgScyN2K7TeJmUn/44wdzytYv/Nh9xO090LqPNw
SQdOp+knUDqSYDyfXQXMTug7AchP3XC7teAaUbrMEg16GHYqg/+FofeFvFQbnFbA
p0FRvhj0H+wV3szGd4fRTLH4VOS8mEIxF9G7JMtjGwJYKXEe+yL19lBNeIWpWdEY
Wp6bDsKCFflHycEi8eqwsQtv1Jt05xdVRUzWNc0jvZuuiwntc8Dzhqklla3GmGUZ
/FrCfrPwQ6yRJgfI8SoWnVtr9qbxCw==
=KuH/
-----END PGP SIGNATURE-----

--nextPart2538252.XAFRqVoOGU--



