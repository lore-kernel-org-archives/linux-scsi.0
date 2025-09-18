Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DAB26B76A
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 19:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758224982; cv=none; b=fzD52XlhdiJcwS29byBgDIEFpZrN3T6+UhjtZxgNudX7RaGwJ385K8lNEhfLKlhCByRjrdVLt1zu/ukFEj2zSOPeAIq096uPyxwO0qo8GM3IHpkpryzC3lWAjfxD7DNGQJf10MOETEPYFTsAB9kxObUcliM7gxQlyUbxN6Lx/2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758224982; c=relaxed/simple;
	bh=Q4O/zomWpCJiftu8/CiLmHfkekoI9/OjAvD3qJc44rM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iw4LfuVYsbsPOEM0lW/sJFDX+LZrrOrDx6HwfeIrpUbGl10QSwjER5OuPtkrXdVGwGf4Sll6wC/MjEKtTlvCONLBLWhS/OaaXzY7UMD+C/rkZ/IMk44DkxHkOpoYzBia43mRyYE7zcq/d4EN8xEGHBOODl8hUKbGaLW1EIqGSJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bO9hdemg; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bO9hdemg"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cSR6q446Jzm1743;
	Thu, 18 Sep 2025 19:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758224978; x=1760816979; bh=DQKgHy35E8PZSKdW3AlsTwvK
	wRgGk78f+mbYBNhNMwE=; b=bO9hdemgYB51W7xq7TpCHhCFTnDYjRxyr8S8VXad
	40aBQPh4PBPFA5NyN0QiI7bW6yE+q1GGQPROGisJsC8gROkrAmbfUnzuIFocIZec
	4bmlw8acFvMAEIiaB64YGRYig14agWdqS+dI8Y7F0N3HQtzha2ySCiAlaQCGkHDw
	ymyhIzSoOasQNkgiGMC4ByKUKJueD7gvZ1l6qVDC/yxZmaE3i1Wv4BE1wTt5DMcF
	3/EWmu6JtHBki/1IuNb9FJ+GDFEvnULToVeAHDsR9UDooxq61mND1oMe+b5moRtX
	Az2mxMsgfqRdiVycaWuFWDyZLo+R4jTHTJfNeb+C0dwuJQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BvKSCBNqWV_m; Thu, 18 Sep 2025 19:49:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cSR6k3jdRzm0yVQ;
	Thu, 18 Sep 2025 19:49:33 +0000 (UTC)
Message-ID: <7a884834-7fb3-4666-9252-a4f76b7a673a@acm.org>
Date: Thu, 18 Sep 2025 12:49:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
 <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
 <2c10d952-8b21-4432-9a87-a4c82745f2d7@acm.org>
 <871a7b50-8920-4808-8537-e188e5ad91ab@oracle.com>
 <d175ed35-874f-40f7-bd34-15dc13d58b5b@acm.org>
 <e7ebba4d-d09b-4823-8830-6aeb6286bcb5@acm.org>
 <331639f8-e162-47fd-aa7c-070bf36d1dc0@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <331639f8-e162-47fd-aa7c-070bf36d1dc0@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 1:01 AM, John Garry wrote:
> On 18/09/2025 00:42, Bart Van Assche wrote:
>> There is another concern: passing the scsi_exec_args pointer via the
>> scsi_execute_cmd() @buffer argument makes it impossible to pass both a
>> scsi_exec_args pointer and a data buffer to scsi_execute_cmd().
> 
> I would not suggest to put any pointers in the data buffer - just copy 
> in or out the data which you require, like the example which I had for 
> scsi_debug.

Hi John,

In patch 29/29 of this series several pointers are present in the data
structures in which struct scsi_exec_args is embedded.

It seems like the scsi_execute_cmd() changes in this patch series are
controversial. How about dropping these changes from this patch series
and restoring the approach of v3 of this patch series? That means
calling blk_execute_rq() instead of scsi_execute_cmd().

Thanks,

Bart.
