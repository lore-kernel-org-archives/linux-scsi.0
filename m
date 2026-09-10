Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919D544A3FD
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 10:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037144; cv=none; b=Zbhf+JuIhVxPOzDAbQpPYLW+NbrerE6mx8WVe+x5y3rHnFuvXv+09VRjvCeaYK7f4sWIXBYaSA/GoRV0yFCDDfGseCd5d5+O1jMvmAxRNj1UZMUGcKO4icsCAU5EVlupPzzCRnoFX/2HLeVe/NqH73VWyZh00MzqGmciJz/6Q3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037144; c=relaxed/simple;
	bh=HaXrO1T3sd3m4w0+pqC0cAS5mzK3GsPip60DTouanuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kkv5kGUWSdXXWl2t5+3P7f3oMWVMDOr1qcfEVRaQQokDCzto+xHdBYdFIDAlAcCEUkECWA8rA0Kx3CHXDe7LCyw6S7GLHLzHKK2rYwB3/a7ZVdj/F1xR9zVG+60R1yn9F8mswLbN8odjsVJ3iCwO8pdS4WvbOm1yf9PdSOM6tg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=stVw4f4z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iWmvjxTg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OJp6eD8a; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YUmFBfd8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="stVw4f4z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iWmvjxTg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OJp6eD8a";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YUmFBfd8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 650B71FDA0;
	Thu, 10 Sep 2026 10:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789037134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrbVxqtdjvsQuC1hZbI+vQsh6SnjYRVCyka+v1PNKIY=;
	b=stVw4f4zR/FNj+9WIapIZNHGLXDrTCo55C9vE9DCYoXVNbmKDDf5goVJe6VBelvjARmxfb
	H18W8u7R+Fu7nZh9ewZHQA89x6a4jN4EKEWw7qceLb7jivWtNvRS2MVjGpV10Zlr0MPDAZ
	xoNaFFMrrWcn02acYRIi1tVemKGl4wM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789037134;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrbVxqtdjvsQuC1hZbI+vQsh6SnjYRVCyka+v1PNKIY=;
	b=iWmvjxTgHvw1msiDNGmS6zyxABgsbS95svNsa/QbDAcLYmCH7do7GdT4jeSgn8blb/wFSY
	86SWIKiWpuAipaCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789037130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrbVxqtdjvsQuC1hZbI+vQsh6SnjYRVCyka+v1PNKIY=;
	b=OJp6eD8aWghql/o5kHuTnFL6F4hnMLFGpgGspetI1APpnDA++ho+fVH+Vx16zTcyC3smTY
	1Kq82VJexQC52a9BwGdGrzTJvd5VAMbxMQ66qrD6z+CBywtRXOyclz/IO0Ly6TicXNYSgJ
	NSn8WvnZd3Btf0qm+d17HbYp7M2AJeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789037130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrbVxqtdjvsQuC1hZbI+vQsh6SnjYRVCyka+v1PNKIY=;
	b=YUmFBfd8Z1MJsrp9XDZiK4Qa9cwXYn7CY+VS5+JJYmDY7S8Nut6U++fBUvHUr35Ose8Dxs
	hGsUd78WrmazMQAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15E4413180;
	Thu, 10 Sep 2026 10:45:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZngPA0qKompoYAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 10 Sep 2026 10:45:30 +0000
Message-ID: <97644265-c807-412f-92a8-7866f5ae9b50@suse.de>
Date: Thu, 10 Sep 2026 12:45:29 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: core: Eliminate
 scsi_log_{reserve,release}_buffer()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1788198780.git.bvanassche@acm.org>
 <c575754856db35fe70aa7a09f1c75b7efdf118fd.1788198780.git.bvanassche@acm.org>
 <f53edf7b-fc80-4815-a884-f03a25ab0527@suse.de>
 <10c53a10-e553-4aef-8438-2ad1dbfc8993@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <10c53a10-e553-4aef-8438-2ad1dbfc8993@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 9/9/26 6:37 PM, Bart Van Assche wrote:
> On 9/7/26 7:44 AM, Hannes Reinecke wrote:
>> But that would completely revert the idea of this patch; 'dev_printk' 
>> will always insert a newline after the string argument, and the whole 
>> point of this patch was that do _not_ want to have a newline here as we
>> want to print out several things before terminating the log message.
> 
> KERN_CONT should be avoided whenever possible because it causes log
> lines to be mixed up if a context switch happens in the middle of
> multiple printk() statements that use KERN_CONT. Do you perhaps want me
> to include patches that eliminate the use of KERN_CONT from SCSI code
> (NCR5380, aic7xxx, ch, mac53c94, megaraid, qla1280 and sd)?
> 
I _know_ about KERN_CONT.
And the patchset introducing the scsi_log was _precisely_ to avoid
having to use KERN_CONT.
But in removing scsi_log we're back to square one, namely that we
cannot assemble a single line of logging with several calls
(eg as required when dumping a hex buffer or a SCSI command).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
