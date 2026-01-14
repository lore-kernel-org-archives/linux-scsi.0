Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF1A30FC06
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768412698; cv=none; b=EjWYRiVn7pQpc+fkZsd3MeI+LXjfBeddDhweovixGevGAF9EV9Mt8XxP2egIZkJ5Pd8ZVrZ3GhpWSwiIyeGn2fOcfxgQDkTJDIy+l3CRAudHaFlG8fc67zdmUutETQGoj5OeVFq1Wz6Z0jyLBj9/bjOUfjV+/KjsZAGMgtKd2Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768412698; c=relaxed/simple;
	bh=mtZ4sY/TBnlS7HF1i69UpstYI+RqgWybkUP5dp4huzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=plpJw21oHd0lFYCXV0LD46PJ0qGLGKN9h7wrvoqs+LIo7oOxBuPJzhjuvBkzPcxjps5zegBnviDpqsrW4oiZNp57xfQtx0+tjC7TkgPi+6RTrRR1mDrEGBLT4Fgm37LfshkIGb2ZcrAPt05gbj1MuSJYErJMHsZMDbmOz5XmY/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ka6CnzOl; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ka6CnzOl"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4drtmL4j6Pz1XM0pk;
	Wed, 14 Jan 2026 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768412689; x=1771004690; bh=r4ICRg+izaLiRuspg/vYJ8jW
	ieQY/5CFhcYZ/2ejfF8=; b=Ka6CnzOlsl2eeotR2MY5MrPO/NMSVt6ecEFwkQyH
	e01JaTCVUE2czRdRMnibbBM+btePCVAT3OB0rx+nrK7xULasUqVRac9elO27AnNk
	s5mxm2bTvHyK6Xmg7mbxZ9hwG05OTWiog3Sq8BkbyX+d02y89BWWBHO7pjzRs2mX
	tZFKHexgExr4KW3SktoLejkXJu9PmxmGQMYJ+cOa8n6ENDwg1h73KwodY5nhrdFv
	Yk1chp4BIJnE1cfbwTDrFUyln3n/m2nsyNtoENGZaUQhwc3nsT6C18+QOZT6jyrl
	klVpZjJcJ6LYo8Ot/tzhfvWVeTsncwLmwpjaQcLEIFDqBA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YqWXODzLSamj; Wed, 14 Jan 2026 17:44:49 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4drtmJ46s6z1XM0p5;
	Wed, 14 Jan 2026 17:44:48 +0000 (UTC)
Message-ID: <7bfc9707-0057-405f-8f11-17bd932713bc@acm.org>
Date: Wed, 14 Jan 2026 09:44:47 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Wake up the error handler when final completions
 race against each other
To: David Jeffery <djeffery@redhat.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260113161036.6730-1-djeffery@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260113161036.6730-1-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 9:08 AM, David Jeffery wrote:
> The fragile ordering between marking commands completed or failed so that
> the error handler only wakes when the last running command completes or
> times out has race conditions. These race conditions can cause the scsi
> layer to fail to wake the error handler, leaving I/O through the scsi host
> stuck as the error state cannot advance.
> 
> First, there is an memory ordering issue within scsi_dec_host_busy. The
> write which clears SCMD_STATE_INFLIGHT may be reordered with reads counting
> in scsi_host_busy. While the local CPU will see its own write, reordering
> can allow other CPUs in scsi_dec_host_busy or scsi_eh_inc_host_failed to
> see a raised busy count, causing no CPU to see a host busy equal to the
> host_failed count.
> 
> This race condition can be prevented with a memory barrier on the error
> path to force the write to be visible before counting host busy commands.
> 
> Second, there is a general ordering issue with scsi_eh_inc_host_failed. By
> counting busy commands before incrementing host_failed, it can race with a
> final command in scsi_dec_host_busy, such that scsi_dec_host_busy does not
> see host_failed incremented but scsi_eh_inc_host_failed counts busy
> commands before SCMD_STATE_INFLIGHT is cleared by scsi_dec_host_busy,
> resulting in neither waking the error handler task.
> 
> This needs the call to scsi_host_busy to be moved after host_failed is
> incremented to close the race condition.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
