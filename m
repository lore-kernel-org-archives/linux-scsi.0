Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E6963510
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 11:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aySOCqou";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MQP9W2jB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aySOCqou";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MQP9W2jB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A8DBA21EF4;
	Fri, 12 Jan 2024 11:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705057978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TTpJjorB4b6gHKCeNXuIcUy3Sc2YybmxotAJ2MoGtrY=;
	b=aySOCqou7xPU5CPM+rLio0XeEzhuyOkLJEjJEy0AtC21MlTgjEd36h1GYYDlcG12ZQginN
	pysw5EwATA7Kj8asrABG2ses2vVibFTRJTccZ6xdj7qAPZ4amI9XRR0TtRd3Sy1qAo7Edh
	x4b4ShG4kiM9gsbiU6ewCauSwPIMv/M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705057978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TTpJjorB4b6gHKCeNXuIcUy3Sc2YybmxotAJ2MoGtrY=;
	b=MQP9W2jBHZEK8CfkjJ9yhK6hfVCa/WWYeSpKpFZewznkshGPkSSg0oGKOQmKiTlswP3LtT
	QbuYmNeTOzDCvsBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705057978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TTpJjorB4b6gHKCeNXuIcUy3Sc2YybmxotAJ2MoGtrY=;
	b=aySOCqou7xPU5CPM+rLio0XeEzhuyOkLJEjJEy0AtC21MlTgjEd36h1GYYDlcG12ZQginN
	pysw5EwATA7Kj8asrABG2ses2vVibFTRJTccZ6xdj7qAPZ4amI9XRR0TtRd3Sy1qAo7Edh
	x4b4ShG4kiM9gsbiU6ewCauSwPIMv/M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705057978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TTpJjorB4b6gHKCeNXuIcUy3Sc2YybmxotAJ2MoGtrY=;
	b=MQP9W2jBHZEK8CfkjJ9yhK6hfVCa/WWYeSpKpFZewznkshGPkSSg0oGKOQmKiTlswP3LtT
	QbuYmNeTOzDCvsBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E5FE136A4;
	Fri, 12 Jan 2024 11:12:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sXpgGLoeoWXXUAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 12 Jan 2024 11:12:58 +0000
Message-ID: <ccbc1e9b-ca63-415c-9b83-225d4108021a@suse.de>
Date: Fri, 12 Jan 2024 12:12:57 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock for
 waking up EH handler
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: Ewan Milne <emilne@redhat.com>
References: <20240112070000.4161982-1-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240112070000.4161982-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-0.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BAYES_HAM(-0.01)[49.71%];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -0.10

On 1/12/24 08:00, Ming Lei wrote:
> Inside scsi_eh_wakeup(), scsi_host_busy() is called & checked with host lock
> every time for deciding if error handler kthread needs to be waken up.
> 
> This way can be too heavy in case of recovery, such as:
> 
> - N hardware queues
> - queue depth is M for each hardware queue
> - each scsi_host_busy() iterates over (N * M) tag/requests
> 
> If recovery is triggered in case that all requests are in-flight, each
> scsi_eh_wakeup() is strictly serialized, when scsi_eh_wakeup() is called
> for the last in-flight request, scsi_host_busy() has been run for (N * M - 1)
> times, and request has been iterated for (N*M - 1) * (N * M) times.
> 
> If both N and M are big enough, hard lockup can be triggered on acquiring
> host lock, and it is observed on mpi3mr(128 hw queues, queue depth 8169).
> 
> Fix the issue by calling scsi_host_busy() outside host lock, and we
> don't need host lock for getting busy count because host lock never
> covers that.
> 
Can you share details for the hard lockup?
I do agree that scsi_host_busy() is an expensive operation, so it
might not be ideal to call it under a spin lock.
But I wonder where the lockup comes in here.
Care to explain?

And if it leads to a lockup, aren't other instances calling 
scsi_host_busy() under a spinlock affected, as well?

Cheers,

Hannes

