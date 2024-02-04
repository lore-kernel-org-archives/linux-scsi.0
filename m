Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F550225B2;
	Sun,  4 Feb 2024 11:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707047873; cv=none; b=Ci2ca4cjC0jWwncUialQ2XgnXeskDeCiZH7ttveoaCYd4xxQhxmzQnIXuxGnWeNvN2bQ4o7e7mhOv/FTWfYY63wf4bmvAVSXRCYQJj6cxX/c7Iyw7m8FHSt6Kh62wUQt+ooltIjcNhqIUUIPOwwPdWX/yUWZTHF5CZIW3Ymhyck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707047873; c=relaxed/simple;
	bh=S1+CvuA1uYK9dbIOwU1n5gpMpUrbbvrEYlTTmjzdHK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D33USae8OAtIHF3FZXTjE3Tt/5Yq0vU+xm1FL6f+RNUtRf8Ien8Vke1CwZu1izxfGYqe3Jcr53kEZqOJrXjymcAZB+Z7LFyUygqmDVVBA3BI/nV4bW0qKWu1q3Z01l2Jz8J2I/h/Q1jQGkInCVYwtvJaH1NjxnGUifgUC8gKxMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FZPFpe5o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xrZY9GC1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FZPFpe5o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xrZY9GC1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FZPFpe5o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xrZY9GC1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FZPFpe5o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xrZY9GC1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E2642223D;
	Sun,  4 Feb 2024 11:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707047870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=veRTSJm61Gn94wWiJxfcCP6FVuIu4bpD0HmlQ/LELq8=;
	b=FZPFpe5oxQDuWeDrgxjBzfiGiHmX7O/mClqtUH/Gj/zrLT3Apa1nb1ra4F4f3zbl337bLk
	gmYJdvNbdhOB0foyORLJpwZGAJ21f+pTcpnZNnUgkKrMIHz+v8J2R41f0SHhNnBg8etF02
	J6pJzwKDkTZCTzaMpwtECPey3ykVj0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707047870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=veRTSJm61Gn94wWiJxfcCP6FVuIu4bpD0HmlQ/LELq8=;
	b=xrZY9GC1ezOh/yIApgLCxeuI+WsMp6RIjIfgY0cGDRW0RK+x4x2z6JL/CLsn+/JDPqy9fk
	GBbFk+5Gz9RMYQBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707047870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=veRTSJm61Gn94wWiJxfcCP6FVuIu4bpD0HmlQ/LELq8=;
	b=FZPFpe5oxQDuWeDrgxjBzfiGiHmX7O/mClqtUH/Gj/zrLT3Apa1nb1ra4F4f3zbl337bLk
	gmYJdvNbdhOB0foyORLJpwZGAJ21f+pTcpnZNnUgkKrMIHz+v8J2R41f0SHhNnBg8etF02
	J6pJzwKDkTZCTzaMpwtECPey3ykVj0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707047870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=veRTSJm61Gn94wWiJxfcCP6FVuIu4bpD0HmlQ/LELq8=;
	b=xrZY9GC1ezOh/yIApgLCxeuI+WsMp6RIjIfgY0cGDRW0RK+x4x2z6JL/CLsn+/JDPqy9fk
	GBbFk+5Gz9RMYQBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 477281338E;
	Sun,  4 Feb 2024 11:57:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id omLRNLp7v2WjIAAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 11:57:46 +0000
Message-ID: <0e2d63e8-fe12-46b6-91fa-46f1bae77752@suse.de>
Date: Sun, 4 Feb 2024 19:57:44 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/26] block: Remove req_bio_endio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-3-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-1.21 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-1.12)[88.36%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.21

On 2/2/24 15:30, Damien Le Moal wrote:
> Moving req_bio_endio() code into its only caller, blk_update_request(),
> allows reducing accesses to and tests of bio and request fields. Also,
> given that partial completions of zone append operations is not
> possible and that zone append operations cannot be merged, the update
> of the BIO sector using the request sector for these operations can be
> moved directly before the call to bio_endio().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq.c | 66 ++++++++++++++++++++++++--------------------------
>   1 file changed, 31 insertions(+), 35 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

