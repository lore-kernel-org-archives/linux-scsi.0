Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E701130FF29
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755518980; cv=none; b=r9pro31OKVqDRSmo0y1kPC/CQ9Xx5rf3W5o5tOTf5AG6lqT8ToNdCwMs81UHs2SsgfKEYgdA/g1L1tstE8+8yFst2iJ+4uuq/8lC3/60YX1zuTl5xsAqEzDuHez+tG/bqtCjbhhQNVP3tCvdK50kPbHTDl3WHndxC1E3mearwPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755518980; c=relaxed/simple;
	bh=9qWx7BkyfLYOLEY6sDlKN1+mpMEbaTvKAYeANxKLZU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vARXOR/JVM8u9/ckzmnLLnsLsynMn6lQvaTBgRYf8Kgo+wyEpyZj0drHzLD2EbMq51+N3shqGjR7RgIQQWfRXs3ACFShyBxQFh54+cI5QEm5XXB4lIl2VBBcCDuoJHaBrzxhsMyGhwEBWPZbKKEE1TrZf3AT4kDBzvsZmDlr4UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YUbXf7UY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I8DoeFmY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YUbXf7UY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I8DoeFmY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YUbXf7UY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I8DoeFmY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YUbXf7UY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I8DoeFmY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 036A32124D;
	Mon, 18 Aug 2025 12:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TDja4sBe4l2ODJgwXxS+SB6K8YOu/fJ10g9nuTc0y4=;
	b=YUbXf7UY5Uk7xB1RgeRtjEKRIQqrkP6Xd5D8TS4CDWQ4ywOIEvhF33jt+d19bBXmIfxWtV
	uVzxZASiDAC9qCpym7owltpw8Iq8gkdiW4yNWVjnjMga+pa3ZRq6fZ6QccFiYimyRxUBnB
	MxlH9gDr7WWHYdi6bYJBcTjqk3SQ+yI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TDja4sBe4l2ODJgwXxS+SB6K8YOu/fJ10g9nuTc0y4=;
	b=I8DoeFmY/uzvcxF9WKpFlU8MARQ8RzRFO0Y4xMka6TPUtlTfPsiguv/B/uRq5YWMjcvw3f
	qE1Vq4hgGjw+lRBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TDja4sBe4l2ODJgwXxS+SB6K8YOu/fJ10g9nuTc0y4=;
	b=YUbXf7UY5Uk7xB1RgeRtjEKRIQqrkP6Xd5D8TS4CDWQ4ywOIEvhF33jt+d19bBXmIfxWtV
	uVzxZASiDAC9qCpym7owltpw8Iq8gkdiW4yNWVjnjMga+pa3ZRq6fZ6QccFiYimyRxUBnB
	MxlH9gDr7WWHYdi6bYJBcTjqk3SQ+yI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TDja4sBe4l2ODJgwXxS+SB6K8YOu/fJ10g9nuTc0y4=;
	b=I8DoeFmY/uzvcxF9WKpFlU8MARQ8RzRFO0Y4xMka6TPUtlTfPsiguv/B/uRq5YWMjcvw3f
	qE1Vq4hgGjw+lRBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E308213686;
	Mon, 18 Aug 2025 12:09:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2zedM/8Xo2hUbgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 12:09:35 +0000
Message-ID: <851fd010-60c5-42a5-8cda-3863b55e8d59@suse.de>
Date: Mon, 18 Aug 2025 14:09:35 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 9/9] scsi: qla2xxx: Fix memcpy field-spanning write
 issue
To: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
 kees@kernel.org, gustavoars@kernel.org, jmeneghi@redhat.com,
 emilne@redhat.com
References: <20250813200744.17975-1-bgurney@redhat.com>
 <20250813200744.17975-10-bgurney@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250813200744.17975-10-bgurney@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/13/25 22:07, Bryan Gurney wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> 
> purex_item.iocb is defined as a 64-element u8 array, but 64 is the
> minimum size and it can be allocated larger. This makes it a standard
> empty flex array.
> 
> This was motivated by field-spanning write warnings during FPIN testing.
> https://lore.kernel.org/linux-nvme/20250709211919.49100-1-bgurney@redhat.com/
> 
>    >  kernel: memcpy: detected field-spanning write (size 60) of single field
>    >  "((uint8_t *)fpin_pkt + buffer_copy_offset)"
>    >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)
> 
> I removed the outer wrapper from the iocb flex array, so that it can be
> linked to `purex_item.size` with `__counted_by`.
> 
> These changes remove the default minimum 64-byte allocation, requiring
> further changes.
> 
>    In `struct scsi_qla_host` the embedded `default_item` is now followed
>    by `__default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE]` to reserve space
>    that will be used as `default_item.iocb`. This is wrapped using the
>    `TRAILING_OVERLAP()` macro helper, which effectively creates a union
>    between flexible-array member `default_item.iocb` and `__default_item_iocb`.
> 
>    Since `struct pure_item` now contains a flexible-array member, the
>    helper must be placed at the end of `struct scsi_qla_host` to prevent
>    a `-Wflex-array-member-not-at-end` warning.
> 
>    `qla24xx_alloc_purex_item()` is adjusted to no longer expect the
>    default minimum size to be part of `sizeof(struct purex_item)`,
>    the entire flexible array size is added to the structure size for
>    allocation.
> 
> This also slightly changes the layout of the purex_item struct, as
> 2-bytes of padding are added between `size` and `iocb`. The resulting
> size is the same, but iocb is shifted 2-bytes (the original `purex_item`
> structure was padded at the end, after the 64-byte defined array size).
> I don't think this is a problem.
> 
> Tested-by: Bryan Gurney <bgurney@redhat.com>
> Co-developed-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  | 10 ++++++----
>   drivers/scsi/qla2xxx/qla_isr.c  | 17 ++++++++---------
>   drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
>   drivers/scsi/qla2xxx/qla_os.c   |  5 +++--
>   4 files changed, 18 insertions(+), 16 deletions(-)
> 
Not sure if this shouldn't be a stand-alone patch, but anyway:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
