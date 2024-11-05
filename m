Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF291D27B1
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730820164; cv=none; b=lVhoQOpG/AjRYDeIKWDHV3li22gR4LbSbKFw10zyo4pq6cl3MeRNpqAnYkFx0B421rxu1D69huxHXUi25X8VDpAnfr2JcD7Wa1wXAyFGfbOxXFjIcu34WmFPdkvod99F9pV1aWrvRGRYpe0MKAPT/QFbY30pp9Qdm3qtfkCSTVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730820164; c=relaxed/simple;
	bh=xIN550VZFDoOd7an5IU+LPHG2K4ZBppK9zqwhpvsPN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wm81vBOEowOVM9uXdaIFItoGOqi+2KdZLtR++5Ee0tEoiKbfxvvbxFKFbWJdinO6IdAJCL5qqy6cv+XLyMVywCz7QSJGL43q2CX8gRGLiPepgn9wlKTfw/h7FkFtMS4L0I4gpfJtKn2tsBSNeR0PUWBPu1o3I/hLYdG6ACTp4yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TiODbT5l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BHiRiHKx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TiODbT5l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BHiRiHKx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TiODbT5l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BHiRiHKx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TiODbT5l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BHiRiHKx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 15D6621CAD;
	Tue,  5 Nov 2024 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730820161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2H93xeK3yThppBZ+qhHCxKo3hAW41rht2Xy2gj6Zb0=;
	b=TiODbT5l+cDOk9riTHf61N06h/PUxJm+b+SOsoDUJTtzZchveU6CXpVVTmpxoerYdJ6eI9
	4KeOwWL9Hd2RPYaBlyDZNYsu3mTWvd/qT1MpnmUzKPXwFIqBf4PIm9jqyAeBpsDs6XfW0k
	VTmQlXnqDkipJ9Zq+kdxBpRI85/QZjg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730820161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2H93xeK3yThppBZ+qhHCxKo3hAW41rht2Xy2gj6Zb0=;
	b=BHiRiHKxvO8zfWAaMLd3dnXF/9ZwPPd+Vdp17jPtj/xEVoDEHTzdBSQAClBWMo0k0h239k
	oNXc+S3kR2uUZGBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TiODbT5l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BHiRiHKx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730820161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2H93xeK3yThppBZ+qhHCxKo3hAW41rht2Xy2gj6Zb0=;
	b=TiODbT5l+cDOk9riTHf61N06h/PUxJm+b+SOsoDUJTtzZchveU6CXpVVTmpxoerYdJ6eI9
	4KeOwWL9Hd2RPYaBlyDZNYsu3mTWvd/qT1MpnmUzKPXwFIqBf4PIm9jqyAeBpsDs6XfW0k
	VTmQlXnqDkipJ9Zq+kdxBpRI85/QZjg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730820161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2H93xeK3yThppBZ+qhHCxKo3hAW41rht2Xy2gj6Zb0=;
	b=BHiRiHKxvO8zfWAaMLd3dnXF/9ZwPPd+Vdp17jPtj/xEVoDEHTzdBSQAClBWMo0k0h239k
	oNXc+S3kR2uUZGBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D768E1394A;
	Tue,  5 Nov 2024 15:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u7PTMEA4KmfzMgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 05 Nov 2024 15:22:40 +0000
Message-ID: <a6cc3085-fa5e-4b23-8847-3e238143e191@suse.de>
Date: Tue, 5 Nov 2024 16:22:40 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 00/10] scsi: EH rework, main part
To: Niklas Cassel <cassel@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>,
 James Bottomley <james.bottomley@hansenpartnership.com>,
 linux-scsi@vger.kernel.org, Wenchao Hao <haowenchao2@huawei.com>,
 Xingui Yang <yangxingui@huawei.com>
References: <20231023092837.33786-1-hare@suse.de> <Zyng-RIx0XkeFLr-@ryzen>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <Zyng-RIx0XkeFLr-@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 15D6621CAD
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 11/5/24 10:10, Niklas Cassel wrote:
> Hello Hannes,
> 
> On Mon, Oct 23, 2023 at 11:28:27AM +0200, Hannes Reinecke wrote:
>> Hi all,
>>
>> (taking up an old thread:)
>> here's now the main part of my EH rework.
>> It modifies the reset callbacks for SCSI EH such that
>> each callback (eh_host_reset_handler, eh_bus_reset_handler,
>> eh_target_reset_handler, eh_device_reset_handler) only
>> references the actual entity it needs to work on
>> (ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
>> and the 'struct scsi_cmnd' is dropped from the argument list.
>> This simplifies the handler themselves as they don't need to
>> exclude some 'magic' command, and we don't need to allocate
>> a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.
>>
>> The entire patchset can be found at:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
>> branch eh-rework.v8
>>
>> As usual, comments and reviews are welcome.
> 
> This seems to be the latest version of your EH rework.
> 
> Do you have any plans to send a v9?
> 
Weelll ... I didn't really proceed with that, as that requires
for some LLDDs to set a side a command tag for TMF.

It was relatively easy pre-multiqueue times (where you could just
reduce max_commands by 1), but for blk-mq that now longer works.

We need to do some really cumbersome things (just look at fnic ...)
and I hoped I could get the 'reserved commands for TMF' patchset
in first, so then this one would be easy.

Alas, this hasn't happened, and so I didn't continue on that work.
But I'll see if I can resurrect it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
