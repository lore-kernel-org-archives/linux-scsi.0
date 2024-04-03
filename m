Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1438F535DB;
	Wed,  3 Apr 2024 06:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712127375; cv=none; b=S3fSYQMdsg9N0VrLTJp+Arz3dmG8qkQGf8bJ6wcozrX4KeiO4y5b5TOoFVOW2pQY+Ae6HKsaxSe7VzvpszQCANLuViEpLbLNie1JevagAOCjzSj8BnWoLAs9NGjxshG1a6Oya1yFOngnur/ZiXbYSD7uuI2kSN4Bh4YR7XQsu+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712127375; c=relaxed/simple;
	bh=yL3q+xzhsCyPFdZwLBK8YolBvlQOKdjfkBfDmnWRsF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkEoIlkYpos89LN6eUQbzMQbZ7VO1Gb5USus1cXeNbB1yk+RwPmyUBXOPhG/0jPBThXvyfkItN68ZQRDRBnl12Ranqo3wNwN1yfZ8qzNnhnvoCFsGBrIWj6ZPIgcBlZNji2lJ7eEKfT9YdSjUv6jwivkGzhjx3m1QJr1unZ8Ddc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JUOWiYhh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kTNESN5D; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JUOWiYhh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kTNESN5D"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 44B4A35018;
	Wed,  3 Apr 2024 06:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712127370; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2JPKnv8ufKXjiY3Ji98K500DideLp43dhs8OiEWxtFk=;
	b=JUOWiYhhVJOEd8gsLYvTm/4SrGbNcmm8mmLlvKv59m7oQFYvQanUMB/yKlJRZeaMZtNdyM
	usZ3VOhy6bKhWLNnepuLK1XTK4GojkAD0l6aFAqdPEjI5KyroRyOgCK0dhxgr0egi9PbpS
	1F4Frp0YcGLndRxfdk9hiomNsRqVVK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712127370;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2JPKnv8ufKXjiY3Ji98K500DideLp43dhs8OiEWxtFk=;
	b=kTNESN5DjDwDAYejbs3jVAmTaKkBjkRDt4yCITrJQkxaEDcMud4dTMujQ9ojPk57dB53zK
	ehNLP5S93MoVXOAw==
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 87AA013357;
	Wed,  3 Apr 2024 06:56:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id +EznHof9DGbeDAAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 06:56:07 +0000
Message-ID: <c5e9ce6e-5137-4579-8895-256c85f7ac4b@suse.de>
Date: Wed, 3 Apr 2024 08:56:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/23] ufs-exynos: move setting the the dma alignment to
 the init method
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20240402130645.653507-1-hch@lst.de>
 <20240402130645.653507-9-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402130645.653507-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.48
X-Spamd-Result: default: False [-3.48 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-2.19)[96.12%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-0.999];
	 RCPT_COUNT_TWELVE(0.00)[42];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,suse.de:email,acm.org:email,samsung.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On 4/2/24 15:06, Christoph Hellwig wrote:
> Use the SCSI host's dma_alignment field and set it in ->init and remove
> the now unused config_scsi_dev method.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ufs/core/ufshcd.c     | 3 ---
>   drivers/ufs/host/ufs-exynos.c | 8 ++------
>   include/ufs/ufshcd.h          | 1 -
>   3 files changed, 2 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

