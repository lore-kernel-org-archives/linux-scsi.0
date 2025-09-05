Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6A92FB0A2
	for <linux-scsi@vger.kernel.org>; Fri,  5 Sep 2025 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757090260; cv=none; b=KoI9z9Q5tifI60FeC1fKOdFRIgdENFD4AITR0va2hJzDGth97VwAgBDxyEyK4ys2iUWCrOCe3hID62U+Lt8YXKNWglV2OKHL8XFpoav+0mF6KlihefY/MV17BfXXV2MV0bL2nnla1JorhPJsy7BfQDntgLc/tXn/Lu/QaFunfp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757090260; c=relaxed/simple;
	bh=S9GncR3I4W6rISy3QD2r0MaumcJ3EtP4E/hVSlu6z3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NJAHK6H9OZ20cdw1ZmPMcm8TVdwXint+3zch5JCfqh/NN/8d3tZgcF/FKxnX5NoyIYDDNOOYZiZlPKQGwBzOKmYeF8POvlpPQ2Zlx/e0Yg/koGGvwgLYD4StLUbX9LIiFMRmtiPGVrwUkRazMIOgI1QG12XmpGhczjvIRlxWOw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aerN5T0w; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aerN5T0w"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cJMTF2gstzljMjl;
	Fri,  5 Sep 2025 16:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757090254; x=1759682255; bh=BBXIb4srfEIXKLYu8Mb3wQVp
	XyzCKMxvjSpHU/243us=; b=aerN5T0wWHFVBi5HuyZgo2vANeJwyTh2PqZ4zkjB
	bJwC2Q+lP75bJKLvthMMY0d7JaVuZeJaQrsr6OuPw7Znu38CT9KpZhqsbHJcqjS6
	GF7fL5F38kVJXaCQMECZV8BbN9JU0vSFlmNph12Q/1X2XQ9iVRCqHRbSdrqwStgX
	/KUcCop0BzYkfTk7I8NWLJ7fQeBRFIe6NI/wPhqoW0ywpN5Sd3fk61GnV7yJvccC
	HM5RKYLaATqtLI+i8AFuwkUCz55xFaloSCW7zr580N1AB6I/Hy44FMuV8FS+lRiF
	ew6pFnj0PFAVgsW6VdWpkY5+4TaBESK76VfY/mLPBTKaig==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jHgopUx_Q6PX; Fri,  5 Sep 2025 16:37:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cJMT72F4YzlgqVc;
	Fri,  5 Sep 2025 16:37:30 +0000 (UTC)
Message-ID: <6f411f84-ac29-41ab-a363-b0b8cba31e25@acm.org>
Date: Fri, 5 Sep 2025 09:37:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/26] scsi: core: Add scsi_{get,put}_internal_cmd()
 helpers
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-6-bvanassche@acm.org>
 <b9ebed12-0e89-495d-8aa2-a615603cec4f@oracle.com>
 <ccf0f76f-1e9f-487d-9844-b8847565532d@acm.org>
 <bdb2ac55-15f1-4b1d-b0d6-d34e432e8c2f@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bdb2ac55-15f1-4b1d-b0d6-d34e432e8c2f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/5/25 8:05 AM, John Garry wrote:
> I think that it's a more a case of we would rather not send half- 
> initialized requests or scsi commands though the block layer and scsi- 
> midlayer. scsi_execute_cmd() looks to set all fields up appropriately, 
> and not just the ones which we are interested in.

I will look into reusing scsi_execute_cmd().

Thanks,

Bart.
