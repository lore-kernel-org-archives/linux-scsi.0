Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE182BF019
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 09:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751965393; cv=none; b=MqjTFJTr1JDKYlSvL/i4I7Ci8Rr+gS7waloHbgdOeiYyVO/KwPGNwZIw3CUo7GZhA8/bUdX9us9uad8SbTYr4K3AOZj/7evI1V42XT8PO+BpHaMWdGZUBKagNhtD7OrMq7flS91mw5N8Qh3NBdHF//LwVhnjG0CRuvb465Q/9Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751965393; c=relaxed/simple;
	bh=4b+ZShGglIvw85XLnJQ79ec6jYuRVqoURM67v/XIrxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qAic3qv1/DNvMt0MyD/UkiHwJUpDd/OCslHIIZWY/E6LXu92DsUk07qNNj+xbKjlfVY9Z7BDCG6hU6PRhLz7lSIjJbn1J+wsmGw/1VQ9w4w8n/H5Z9US9gqKbzELHJ69p9LJ1gnhikUlUcrwuJ1DKV+zvMcmbFW1/FfAGCuRDEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CpsOn8Ep; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+URHbj4J; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CpsOn8Ep; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+URHbj4J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CpsOn8Ep";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+URHbj4J";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CpsOn8Ep";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+URHbj4J"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D6B51F798;
	Tue,  8 Jul 2025 09:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751965384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LoIjE0YohSQS/m/DeEM40Wt2aoGgwC03+iN87AqEfw=;
	b=CpsOn8EpvXt8WGkCazO8YmhFZ1u3xu7iDCctROs0+56nkbv1EomzjHgFXfUDG5JohO19Zr
	e3CIZTZi3h0gP6EDmkEZ5lBNw84dky4ULgBfdLLUC7UgujlA7fqFuFjuaETV+89UdwHH8s
	W82l5X+5zMgZXUQ3HQPms54HdwMKYdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751965384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LoIjE0YohSQS/m/DeEM40Wt2aoGgwC03+iN87AqEfw=;
	b=+URHbj4JwqjW6/77p+LOglr50mzgUSGFjeekE19Tp+A1BjqD3aQurnTwmoCMe77I5fTMb2
	BCnuCkieJIojPVDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751965384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LoIjE0YohSQS/m/DeEM40Wt2aoGgwC03+iN87AqEfw=;
	b=CpsOn8EpvXt8WGkCazO8YmhFZ1u3xu7iDCctROs0+56nkbv1EomzjHgFXfUDG5JohO19Zr
	e3CIZTZi3h0gP6EDmkEZ5lBNw84dky4ULgBfdLLUC7UgujlA7fqFuFjuaETV+89UdwHH8s
	W82l5X+5zMgZXUQ3HQPms54HdwMKYdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751965384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LoIjE0YohSQS/m/DeEM40Wt2aoGgwC03+iN87AqEfw=;
	b=+URHbj4JwqjW6/77p+LOglr50mzgUSGFjeekE19Tp+A1BjqD3aQurnTwmoCMe77I5fTMb2
	BCnuCkieJIojPVDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0998113A70;
	Tue,  8 Jul 2025 09:03:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3tL4AMjebGjmYQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 09:03:04 +0000
Message-ID: <f4ec4c04-6f41-4886-a7c0-da8334bd4745@suse.de>
Date: Tue, 8 Jul 2025 11:03:03 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when
 FDMI times out
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, jmeneghi@redhat.com, revers@redhat.com,
 dan.carpenter@linaro.org, stable@vger.kernel.org
References: <20250612002212.4144-1-kartilak@cisco.com>
 <20250612002212.4144-2-kartilak@cisco.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250612002212.4144-2-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email,cisco.com:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 6/12/25 02:22, Karan Tilak Kumar wrote:
> When both the RHBA and RPA FDMI requests time out, fnic reuses a frame
> to send ABTS for each of them. On send completion, this causes an
> attempt to free the same frame twice that leads to a crash.
> 
> Fix crash by allocating separate frames for RHBA and RPA,
> and modify ABTS logic accordingly.
> 
> Tested by checking MDS for FDMI information.
> Tested by using instrumented driver to:
> Drop PLOGI response
> Drop RHBA response
> Drop RPA response
> Drop RHBA and RPA response
> Drop PLOGI response + ABTS response
> Drop RHBA response + ABTS response
> Drop RPA response + ABTS response
> Drop RHBA and RPA response + ABTS response for both of them
> 
> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Tested-by: Arun Easi <aeasi@cisco.com>
> Co-developed-by: Arun Easi <aeasi@cisco.com>
> Signed-off-by: Arun Easi <aeasi@cisco.com>
> Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fdls_disc.c | 113 +++++++++++++++++++++++++---------
>   drivers/scsi/fnic/fnic_fdls.h |   1 +
>   2 files changed, 86 insertions(+), 28 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
