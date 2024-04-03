Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4013458AA9;
	Wed,  3 Apr 2024 07:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712128615; cv=none; b=MNWVu3u5WV0dHu3KCnlIzYVU+vl9GdjckCoHevoQO+hhtm4u7KBtQyw7e9r7P982H1/eU7Wnuvr/Z6DQHCgS1qyDQG0q0se+VeCmwIQT7EVphzzSQPlWKC0KaMWsvo/TQRkCEaduvTyVUm+KrysCX0IUsHzw8pYSojxgDk8mlUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712128615; c=relaxed/simple;
	bh=uDj8PyknbiZhf4bntIj7ISGizbWHLbeevoXPxlhVPYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=inmVXi4MEAxCMa+8ck+ZwojktKOSCjQ++8hKlrlO2/LJPnGFbP752O3g03PqI5+8yDOaIo8JNp0S9FRGrYCyvbIBnzymzWy1SDuAr/YacBuo968Ao7Vd6r6yWGgZFq2qqV9h72exyk7e/FgmaV8v310Q7pCIrxPbqp8MsfnyJ5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zxrELxz6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AWXESfy4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zxrELxz6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AWXESfy4"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 67FBB5C91A;
	Wed,  3 Apr 2024 07:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712128612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulqqzBR3KTWHCAy89sef5Vdx76a8DXmRGqKzCwup11A=;
	b=zxrELxz6GRhBI60XC3lA/MJZlgf0VW0gPZR/mHHEGl1Ac/6Qndre9JWqgPUBXykCkkZvE+
	s083xi7wj90PmUlsBoqzHFdionz8ZR1y7OfJXrrzcp+JUBQ+U6tjMv7aYBF+lAHPx6o8Dn
	h6KQrdUR9PAALMcSRdk+19e6hWEiFSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712128612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulqqzBR3KTWHCAy89sef5Vdx76a8DXmRGqKzCwup11A=;
	b=AWXESfy4j2EQuU4QjyA5o8JuPWlCd1MlrgFy+zYcqw9pOFcTijNNdpjYtCRAUdQld0C0JZ
	LE5D3MIrfBGDBZCw==
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id E320513357;
	Wed,  3 Apr 2024 07:16:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id MOZTMWACDWYlEQAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 07:16:48 +0000
Message-ID: <0b648ab8-d5e6-4332-876f-05b97cf7c232@suse.de>
Date: Wed, 3 Apr 2024 09:16:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/23] mpi3mr: switch to using ->device_configure
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
 <20240402130645.653507-22-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402130645.653507-22-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.62 / 50.00];
	BAYES_HAM(-0.33)[75.80%];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[42];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap2.dmz-prg2.suse.org:rdns,imap2.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -0.62
X-Spam-Level: 
X-Spam-Flag: NO

On 4/2/24 15:06, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Note that mpi3mr also updates the limits from an event handler that
> iterates all SCSI devices.  This is also updated to use the
> queue_limits, but the complete locking of this path probably means
> it already is completely broken and needs a proper audit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h    |  1 -
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 76 ++++++++++++++-------------------
>   2 files changed, 31 insertions(+), 46 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

