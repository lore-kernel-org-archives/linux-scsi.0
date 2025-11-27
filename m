Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15133313529
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227277; cv=none; b=KDALXBmfAykyvBTXRrr9oJWB+W4eBY1o7ScbhS4fcsqO2B1C8a9ry8XoGDNt07NP6rdVg+B9thV0BZ4/AG/KO21TgY9StWyz3QVhxpbb0TKTeboMhTEop+3W8Jmm9eEWqaN9xpBQzD1PFCGZKFaLh0PX24W4Mq+oiVvFqmw4mrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227277; c=relaxed/simple;
	bh=gnT74m22lzfBx6uRJGriIbQr4/cmzQTeuv/tw5r84Qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4NDokqpnV6CBGAsHAg4KIPMIoiOs2dVU3KFJydN2p2KuNWskXtsumEkBpQH9rzjkj7yzJyauzWM7XdvejTyJm7Jdd63aRhXqP81wbsmoi/V59uIG71qX7rqurTIHonK7isZy+o0n0OeBRJgRKkUli26D/3WIPK47V9lA5YxiGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P+Gaf5wc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TTYm7y4G; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P+Gaf5wc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TTYm7y4G; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P+Gaf5wc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TTYm7y4G";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P+Gaf5wc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TTYm7y4G"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 247735BCC4;
	Thu, 27 Nov 2025 07:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764227274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxH/K4xBnPW3Iqo9dVisbX3HnJSJaYk0+vOsyJRDm54=;
	b=P+Gaf5wcjYAsVrFWf/W+zBNHIGQrKRDpztAkgHv1Kok+RNLSFqQTsBzRrdvE/hwct9pg/b
	2u2GmhTMG9MI9XWcdhwZtup6mZ+kOmWUEnOXpCoqf2eFMajgWW3+Z4U/MWEIqHN72TlHlm
	64IGHdGEDvx3Bh8husmKUNVEMieRVXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764227274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxH/K4xBnPW3Iqo9dVisbX3HnJSJaYk0+vOsyJRDm54=;
	b=TTYm7y4GhTBLXldK7PxlSrKL9IjT2R8fUwB13oCOrkEWk/tzqoXWjC+K+ggrBjl8vfvKQQ
	pxMLQaI4W0GfOnDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P+Gaf5wc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TTYm7y4G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764227274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxH/K4xBnPW3Iqo9dVisbX3HnJSJaYk0+vOsyJRDm54=;
	b=P+Gaf5wcjYAsVrFWf/W+zBNHIGQrKRDpztAkgHv1Kok+RNLSFqQTsBzRrdvE/hwct9pg/b
	2u2GmhTMG9MI9XWcdhwZtup6mZ+kOmWUEnOXpCoqf2eFMajgWW3+Z4U/MWEIqHN72TlHlm
	64IGHdGEDvx3Bh8husmKUNVEMieRVXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764227274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxH/K4xBnPW3Iqo9dVisbX3HnJSJaYk0+vOsyJRDm54=;
	b=TTYm7y4GhTBLXldK7PxlSrKL9IjT2R8fUwB13oCOrkEWk/tzqoXWjC+K+ggrBjl8vfvKQQ
	pxMLQaI4W0GfOnDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A36823EA63;
	Thu, 27 Nov 2025 07:07:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NpkXJsn4J2mkWwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Nov 2025 07:07:53 +0000
Message-ID: <1379c3f9-cdde-4733-b1e9-7e761628d0d3@suse.de>
Date: Thu, 27 Nov 2025 08:07:53 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] block: add IOC_PR_READ_RESERVATION ioctl
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Mike Christie <michael.christie@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251126163600.583036-1-stefanha@redhat.com>
 <20251126163600.583036-5-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251126163600.583036-5-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Score: -4.51
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 247735BCC4
X-Rspamd-Action: no action
X-Spam-Flag: NO

On 11/26/25 17:36, Stefan Hajnoczi wrote:
> Add a Persistent Reservations ioctl to read the current reservation.
> This calls the pr_ops->read_reservation() function that was previously
> added in commit c787f1baa503 ("block: Add PR callouts for read keys and
> reservation") but was only used by the in-kernel SCSI target so far.
> 
> The IOC_PR_READ_RESERVATION ioctl is necessary so that userspace
> applications that rely on Persistent Reservations ioctls have a way of
> inspecting the current state. Cluster managers and validation tests need
> this functionality.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   include/uapi/linux/pr.h |  7 +++++++
>   block/ioctl.c           | 28 ++++++++++++++++++++++++++++
>   2 files changed, 35 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
