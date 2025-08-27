Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7322D5C6A
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 06:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756276158; cv=none; b=PGyIRDiSMER2FJAeMaezhSGMq45PEhY4Mf9otXWXk2C2KMBx4qnC4qIp0b4mPq1bsinIVLR5YzDTy+JFhiftic6tIfQGLgZfRSm4+xvFQaFrN4K8qSoOHmpo5wRG0e/oTGQuYBOep58CcCJYKGHmZt4kkdKchRpwevwYCvozpfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756276158; c=relaxed/simple;
	bh=rARVGU5C8wUHMe1KNFks5vW2LN9nMDzV86X7axvS1G8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MRZ5cL0htCd/tJgoUNZiGZVTuYhE07remF8ijnVQ9HdxGgQ3zHlz2bt2pp7A9RbN2RMoIf7ZmAx9qm5Y6eBkqKP/q9z4YfTlEt3X21xGMZ+r9npqADxoYB4PmThOuuPtl46BqRfBw1dp/rfKuGhDEQC/LiQG8Wka3ckf2wD+2wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fWGSSyvU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WyTUHBvZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fWGSSyvU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WyTUHBvZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fWGSSyvU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WyTUHBvZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fWGSSyvU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WyTUHBvZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4E50021BCD;
	Wed, 27 Aug 2025 06:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756276154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIR0tY1TkF8j1XVrNWr3yQ1OdVrmGrEjXuja9vf++n4=;
	b=fWGSSyvUbb9OZ9/2LdtbKoUz9sZMxIJ9ttgZQr1lnIX7EMQMgMnc4N8SFXQBuCRg77f4Hx
	JF8Ma+daffJ5EudsX2MK+9h24c5Oy0U14Fqf4kyc/63/he2g5bDVzmRx4oFuFY+vf9lj/l
	+IBbYj/By6sn21+Bk0obW4s/n9U56Cw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756276154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIR0tY1TkF8j1XVrNWr3yQ1OdVrmGrEjXuja9vf++n4=;
	b=WyTUHBvZqZ/NXvjNw56HZ8Tg/LRdD+6KHnGr9WX2ZP/IkV2VPbfA9zQne5QO6NmGqinAXC
	JO7xBRKA75uldWDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756276154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIR0tY1TkF8j1XVrNWr3yQ1OdVrmGrEjXuja9vf++n4=;
	b=fWGSSyvUbb9OZ9/2LdtbKoUz9sZMxIJ9ttgZQr1lnIX7EMQMgMnc4N8SFXQBuCRg77f4Hx
	JF8Ma+daffJ5EudsX2MK+9h24c5Oy0U14Fqf4kyc/63/he2g5bDVzmRx4oFuFY+vf9lj/l
	+IBbYj/By6sn21+Bk0obW4s/n9U56Cw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756276154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIR0tY1TkF8j1XVrNWr3yQ1OdVrmGrEjXuja9vf++n4=;
	b=WyTUHBvZqZ/NXvjNw56HZ8Tg/LRdD+6KHnGr9WX2ZP/IkV2VPbfA9zQne5QO6NmGqinAXC
	JO7xBRKA75uldWDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F139B13310;
	Wed, 27 Aug 2025 06:29:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XiXVOLmlrmgBWQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Aug 2025 06:29:13 +0000
Message-ID: <020f8c5c-c9e4-4ad0-8052-a0b182ded92c@suse.de>
Date: Wed, 27 Aug 2025 08:29:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: fc: Avoid -Wflex-array-member-not-at-end
 warnings
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Justin Tee <justin.tee@broadcom.com>, James Smart
 <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aK6hbQLyQlvlySf8@kspp>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aK6hbQLyQlvlySf8@kspp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/27/25 08:10, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end has been introduced in GCC-14, and we
> are getting ready to enable it, globally.
> 
> So, in order to avoid ending up with a flexible-array member in the
> middle of multiple other structs, we use the `__struct_group()`
> helper to create a new tagged `struct fc_df_desc_fpin_reg_hdr`.
> This structure groups together all the members of the flexible
> `struct fc_df_desc_fpin_reg` except the flexible array.
> 
> As a result, the array is effectively separated from the rest of the
> members without modifying the memory layout of the flexible structure.
> We then change the type of the middle struct members currently causing
> trouble from `struct fc_df_desc_fpin_reg` to `struct
> fc_df_desc_fpin_reg_hdr`.
> 
> We also want to ensure that in case new members need to be added to the
> flexible structure, they are always included within the newly created
> tagged struct. For this, we use `_Static_assert()`. This ensures that
> the memory layout for both the flexible structure and the new tagged
> struct is the same after any changes.
> 
> This approach avoids having to implement `struct fc_df_desc_fpin_reg_hdr`
> as a completely separate structure, thus preventing having to maintain
> two independent but basically identical structures, closing the door
> to potential bugs in the future.
> 
> The above is also done for flexible structures `struct fc_els_rdf` and
> `struct fc_els_rdf_resp`
> 
> So, with these changes, fix the following warnings:
> drivers/scsi/lpfc/lpfc_hw4.h:4936:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> drivers/scsi/lpfc/lpfc_hw4.h:4942:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> drivers/scsi/lpfc/lpfc_hw4.h:4947:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v2:
>   - Implement the same changes for `struct fc_els_rdf_resp`
>   - Fix size calculation in lpfc_issue_els_rdf(). (Justin Tee)
> 
> v1:
>   - Link: https://lore.kernel.org/linux-hardening/aJtMETERd-geyP1q@kspp/
> 
>   include/uapi/scsi/fc/fc_els.h | 58 +++++++++++++++++++++++------------
>   drivers/scsi/lpfc/lpfc_els.c  |  2 +-
>   drivers/scsi/lpfc/lpfc_hw4.h  |  6 ++--
>   3 files changed, 43 insertions(+), 23 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
