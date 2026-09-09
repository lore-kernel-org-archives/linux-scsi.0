Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC206279DB6
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 16:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788971843; cv=none; b=TELjaoWRPT6HdFFxRNrUXmAeb/l7sOmKHF7V8Z2bfpNNYgPgXFutNKfSA3/hZJPkceOSO72g7kyY2LcjAfeWTRylr/4v+yYa7Z/WT0KJuPy5jCfXS522VRw2YQbJw9HIjlWXcFif45IRZFbqxvrxYQ4ctfoFeD++LpO3d9DgrR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788971843; c=relaxed/simple;
	bh=j0BLNqJhSvqD55pZ39t0gOv1WMjl/vPiz48CdOVrj2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tTGdJXO+f6FopU9cRpRllJLhIf+FMYnoIcgZQ1NRESI4hvNqcX/dhxA+QIMBKVQMYPAB+iiWbjAwYO8NoEw5/oThgubxKtcKUSY6WFjIOPuL5vCX8/cjSWrFvwTYJJWHeP3lAt+Zc8mu8P3Klpj9cOVjeMySt/e+Iv5O7Cd/9TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g8c6jWwg; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g8c6jWwg"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hg60d3XMfzlfvpK;
	Wed,  9 Sep 2026 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788971838; x=1791563839; bh=5kqfwlkjvtGqrzlV8/TbG1Me
	9U9MllUPrfY6mpLx6i4=; b=g8c6jWwgSg4JdO2L+jFdoxGIZZqS/wMMlSP2oIsw
	f+E8xUsTCMO7mIeo+BwdjDtNDlcbAyp4WyIMTP3dlFrYCOQINIwxWxCnEZHA+P4M
	uQqe6WCqQCVBC2uYPpU3Cr+FeQ9XDSSV8vkQvNkGQPCxgL8OvgA3o31YwlG/LOfb
	qp6YxKbU5Rf4zjzocWcS+rXRZK1wRaLhJsJhQzuJpdHGSJAiXvhzB4+RZH3JGg2B
	wyGRL1RcFlv0x/1cnhpTpfXXzpL2oa/7lFpORgoJjHjg+a6tlFF9avcV1Yt9KsMr
	QC5YDFDWf0ncCA43NtnoF+jTAqWSVIbDt7lNcM4eUy/0ew==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kdWnS8Xr9XOO; Wed,  9 Sep 2026 16:37:18 +0000 (UTC)
Received: from [100.86.178.220] (unknown [104.133.214.192])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hg60Y0YrWzlfvpG;
	Wed,  9 Sep 2026 16:37:16 +0000 (UTC)
Message-ID: <10c53a10-e553-4aef-8438-2ad1dbfc8993@acm.org>
Date: Wed, 9 Sep 2026 09:37:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: core: Eliminate
 scsi_log_{reserve,release}_buffer()
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1788198780.git.bvanassche@acm.org>
 <c575754856db35fe70aa7a09f1c75b7efdf118fd.1788198780.git.bvanassche@acm.org>
 <f53edf7b-fc80-4815-a884-f03a25ab0527@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f53edf7b-fc80-4815-a884-f03a25ab0527@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 7:44 AM, Hannes Reinecke wrote:
> But that would completely revert the idea of this patch; 'dev_printk' 
> will always insert a newline after the string argument, and the whole 
> point of this patch was that do _not_ want to have a newline here as we
> want to print out several things before terminating the log message.

KERN_CONT should be avoided whenever possible because it causes log
lines to be mixed up if a context switch happens in the middle of
multiple printk() statements that use KERN_CONT. Do you perhaps want me
to include patches that eliminate the use of KERN_CONT from SCSI code
(NCR5380, aic7xxx, ch, mac53c94, megaraid, qla1280 and sd)?

Thanks,

Bart.
