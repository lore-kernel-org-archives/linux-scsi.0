Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A2A21D3E8
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2025 06:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752129381; cv=none; b=opD8JunRVCGhfYWtBDqIsFv8UFTjeq7wGfKJjgyO4VtqXEs4ocrhZzAGYidghocO479KnkVTCZWj4PJDcpr8QrZgpug2SoY0K/T1g79jlRt08GDBua0y2epq4kpyuqLAYiA47xtVifemHFFnpgvmyN3TvZ1HRec1HSdhR5ndZxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752129381; c=relaxed/simple;
	bh=pAolbAVS5ex1GYzY65PkjEdbxoOfKRXEL4ZwyEcBlHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bB2fUnTOTJPQ2iCOP6CLNcguSZnzqXepsLUwsjWzNVBn4M+JoU02Qlu5qMjnADxudBUCC/O6ympeUeMFiH64wihkYnMpnb8Z3iToVp5X0AXIZfzDK8PQSOxE8o5K3fTU63YoJbBl5vWPdsO6lueMcx2ShMYRsmKLEQnIjmwrkuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u/0DTwPm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9p6YPHnM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zfShDxLz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4X/xWS7M; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="u/0DTwPm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9p6YPHnM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zfShDxLz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4X/xWS7M"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D4C2A1F385;
	Thu, 10 Jul 2025 06:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752129374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WzB9T/HEA3zl1fSfSp4StlUkmpKLI9rc2lrqum55+I=;
	b=u/0DTwPmycwVQbP0oEdFapFe6BJx6KtLrGQwbBmlIeyOlgISfJKgncy0eRbkxp07nyhDSV
	GhjsHmWZxH2GTWa235EPq3BtG+m3mMPl+jpTlNIAhoNROst9QM67CULTortlLKhypDvzkz
	LY62HIWDbQJ7WB61c4vXIh3EqPGU+dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752129374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WzB9T/HEA3zl1fSfSp4StlUkmpKLI9rc2lrqum55+I=;
	b=9p6YPHnMD3A8ejIPXxj5WwnNJZpsBhBDAvWecoeo+YdimRaa2CrB6uVneDXOrENgIzDOD8
	nb9vdAzs2DZEdNAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752129373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WzB9T/HEA3zl1fSfSp4StlUkmpKLI9rc2lrqum55+I=;
	b=zfShDxLz1asSYa4ymdhFfOQJKtVnajWpgHhLZwBv+tdBmu0m59YQYPtCYyIft+MaSa/5PI
	RZOFdmW5WCUg+Z/+7M35KOGzxCqo/TnKh/OxxajVcgYGOqdxjEWHPkqMfeJNk4dmZV4rPe
	hOLmJTihI9ePj/sQcAX5k+i4wVUJbqo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752129373;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WzB9T/HEA3zl1fSfSp4StlUkmpKLI9rc2lrqum55+I=;
	b=4X/xWS7MzzmrvipbT++QlFIoCCe0JHh07Kirjbj9pFTeDYsLMQAOTsdtKDwe1VYC3x6jtF
	IZIGllbK0oClfGCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66819136CB;
	Thu, 10 Jul 2025 06:36:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FJCdFl1fb2hnEgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 10 Jul 2025 06:36:13 +0000
Message-ID: <782942d7-41fe-41e2-9913-54108d44bcd3@suse.de>
Date: Thu, 10 Jul 2025 08:36:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/8] nvme-multipath: queue-depth support for marginal
 paths
To: John Meneghini <jmeneghi@redhat.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, axboe@kernel.dk, sagi@grimberg.me, hch@lst.de,
 kbusch@kernel.org, linux-nvme@lists.infradead.org,
 Bryan Gurney <bgurney@redhat.com>
References: <20250709212652.49471-1-bgurney@redhat.com>
 <66a05f2e-f3fd-4347-9c7f-f8fbb715890d@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <66a05f2e-f3fd-4347-9c7f-f8fbb715890d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 7/10/25 00:03, John Meneghini wrote:
> Hannes, this patch fixes the queue-depth scheduler.  Please take a look.
> 
> On 7/9/25 5:26 PM, Bryan Gurney wrote:
>> From: John Meneghini <jmeneghi@redhat.com>
>>
>> Exclude marginal paths from queue-depth io policy. In the case where all
>> paths are marginal and no optimized or non-optimized path is found, we
>> fall back to __nvme_find_path which selects the best marginal path.
>>
>> Tested-by: Bryan Gurney <bgurney@redhat.com>
>> Signed-off-by: John Meneghini <jmeneghi@redhat.com>
>> ---
>>   drivers/nvme/host/multipath.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/ 
>> multipath.c
>> index 8d4e54bb4261..767583e8454b 100644
>> --- a/drivers/nvme/host/multipath.c
>> +++ b/drivers/nvme/host/multipath.c
>> @@ -420,6 +420,9 @@ static struct nvme_ns 
>> *nvme_queue_depth_path(struct nvme_ns_head *head)
>>           if (nvme_path_is_disabled(ns))
>>               continue;
>> +        if (nvme_ctrl_is_marginal(ns->ctrl))
>> +            continue;
>> +
>>           depth = atomic_read(&ns->ctrl->nr_active);
>>           switch (ns->ana_state) {
>> @@ -443,7 +446,9 @@ static struct nvme_ns 
>> *nvme_queue_depth_path(struct nvme_ns_head *head)
>>               return best_opt;
>>       }
>> -    return best_opt ? best_opt : best_nonopt;
>> +    best_opt = (best_opt) ? best_opt : best_nonopt;
>> +
>> +    return best_opt ? best_opt : __nvme_find_path(head, numa_node_id());
>>   }
>>   static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
> 

Hmm. Not convinced. I would expect a 'marginal' path to behave different
(performance-wise) than unaffected paths. And the queue-depth scheduler
should be able to handle paths with different performance
characteristics just fine.
(Is is possible that your results are test artifacts? I guess
your tool just injects FPIN messages with no performance impact,
resulting in this behaviour...)

But if you want to exclude marginal paths from queue depth:
by all means, go for it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
