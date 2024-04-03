Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371AA54909;
	Wed,  3 Apr 2024 07:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712128553; cv=none; b=VhD3VYZaEV+YbJxskKx1bTK/BAiK55fpPYHnmKBZwgvNsD8A0hqJiRUMRJCV8jRaDQVXDsJijlF9ZXfHMqpFbxxaU2Q7i+zAJ9mmyJ8DlmS69SHrZ2g+WDQpOLAx3G82PUK3LqqP2Et/SWY8rDDDrQrJwxqBknPN+0uyMBTjEKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712128553; c=relaxed/simple;
	bh=BoX9XlWlZv50+uvWcTmG1nN0H65K+vRwBCArwDNz0eE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ko+gIjbIMIfkRXcTAUu5IWRGPVCCp3i46KVlZKCGyD6Q3EjhurAufX0DNslowbQZWmTi70USr/qniH6mckzekz7EGCceEQLtoE7/BVeMFqM+s4XkLL7m5mYW6Xbq/qZjDi7emvCRShR0pVUgcQBMMPwXRSooKjR6bRt7ynKscIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MZv11LCH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hOYZOJL+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MZv11LCH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hOYZOJL+"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 535B55C91A;
	Wed,  3 Apr 2024 07:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712128550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ITTnavAHwcb0N8wOvNww3FtAjutukzUmB4ZDFwHe3E=;
	b=MZv11LCHzjqoe6X3W5ENMv9xy65Opx4Cm5vlg91OUlu1EGSZcL2xUDPN+GwbeNu3HN/kMs
	wfmrFg52qehlqnrwjy6x03TH4DjPh2munA0ji5NJK7oS7nkTHDNFY1xqYjDC4h45PJLlKE
	baU0duebw4NTiDLnHkQoym4PITPWpzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712128550;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ITTnavAHwcb0N8wOvNww3FtAjutukzUmB4ZDFwHe3E=;
	b=hOYZOJL+QGzEuktK3NiwnuMVrjLjiPbBIQSeZQPoH/fKpil8QvmdglcWP4yYe7IRlnp9U6
	WsVrmGM3XhC8zrCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 0EF4913357;
	Wed,  3 Apr 2024 07:15:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id QBFTOCICDWYlEQAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 07:15:46 +0000
Message-ID: <cd7399e3-75ab-49b5-a5ad-1e7e7df649ea@suse.de>
Date: Wed, 3 Apr 2024 09:15:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/23] libata: switch to using ->device_configure
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
 <20240402130645.653507-21-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402130645.653507-21-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: 2.14
X-Spam-Flag: NO
X-Spamd-Bar: ++
X-Spamd-Result: default: False [2.14 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	 MIME_GOOD(-0.10)[text/plain];
	 BAYES_HAM(-0.29)[74.52%];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_TWELVE(0.00)[42];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,lst.de:email];
	 NEURAL_SPAM_LONG(0.53)[0.151];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:98:from]
X-Spam-Level: **
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 535B55C91A

On 4/2/24 15:06, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Acked-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/ahci.h                     |  2 +-
>   drivers/ata/libata-sata.c              | 11 +++++++----
>   drivers/ata/libata-scsi.c              | 19 +++++++++++--------
>   drivers/ata/libata.h                   |  3 ++-
>   drivers/ata/pata_macio.c               |  2 +-
>   drivers/ata/sata_mv.c                  |  2 +-
>   drivers/ata/sata_nv.c                  |  4 ++--
>   drivers/ata/sata_sil24.c               |  2 +-
>   drivers/scsi/aic94xx/aic94xx_init.c    |  2 +-
>   drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++-
>   drivers/scsi/hisi_sas/hisi_sas_main.c  |  7 ++++---
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  2 +-
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  7 ++++---
>   drivers/scsi/isci/init.c               |  2 +-
>   drivers/scsi/libsas/sas_scsi_host.c    |  7 ++++---
>   drivers/scsi/mvsas/mv_init.c           |  2 +-
>   drivers/scsi/pm8001/pm8001_init.c      |  2 +-
>   include/linux/libata.h                 | 10 ++++++----
>   include/scsi/libsas.h                  |  3 ++-
>   20 files changed, 54 insertions(+), 40 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

