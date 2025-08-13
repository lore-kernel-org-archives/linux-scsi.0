Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAA272632
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 00:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755044562; cv=none; b=Q+wxBlqBuEEsUE+7XVn1j1WqKvXZRfhoyXuSzQvzDbdRKawbsvyinvVlQd9ORBm+S9tYMuyXnBYAr3Osc0kbZ1t/m+X9V7NaemLia/cuyyNmkI3QUAlFmu58pyTMx6JMTbKKGlSWNyB6Ta7kgKhjTIiswfsi5a9GolPWRAze+Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755044562; c=relaxed/simple;
	bh=gFquGyl+k5Yd3XiLJSstTNZ323n+UunyAJM9MM5tH1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WMTcRf2eflZwvbB5EuikP4c7/AOa6MhQMr5mx5ZOyFNXCk9+kWXGB7cbGhPGIykU4X6bMKU4GVu7fwXLReruTcE4FKoH/GNuEt3j9cR5XNJhSnCTfKhuOZffuxzO0bL0R26dH00jbjvlT3WUHUs2+aIdC154EFaKP/b5D36DwB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ep0IFGvF; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ep0IFGvF"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c1pwt1yRKzlgqVc;
	Wed, 13 Aug 2025 00:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755044555; x=1757636556; bh=rqTFKiGNMyNcVB61vAj1CKsm
	iqNYzecFW+FL7ChoicY=; b=Ep0IFGvFMClHsL8l0CX9kXXz475K0h7JZoTjo3JN
	c4ROd1OVLiBLZIyRWriSSX7cZ2xNsugo5Of2nBjEa/Sj4T+3dnD/e9erZqP5l/kT
	bWF4fFefK8LA66KQKPf46e1j3Z9A1KDnReC2qdLZT56ein5cZWRVCk+iU/km7wku
	46lhredW7Map7TQRBqzKI5ORn/ty14QUI/TwsS6GvQkWKY77LtpG9tzWGyScBHyZ
	59TI/lhBxSRJjirrYSyynYOmETq64lk9JWMWpW14xf7I0U8FVpnd9Pe0wJ8bFWW8
	NOlgweYneqtsKCeVTgRBkz5LoDGb61MMPN17JXiu4nHb5A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CShDvj__o50x; Wed, 13 Aug 2025 00:22:35 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c1pwm55FGzlgqVj;
	Wed, 13 Aug 2025 00:22:31 +0000 (UTC)
Message-ID: <754714a8-0d6a-477f-8715-6c431ef5bf2a@acm.org>
Date: Tue, 12 Aug 2025 17:22:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] scsi: sd: Have scsi-ml retry read_capacity_16 errors
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250716184833.67055-1-emilne@redhat.com>
 <20250716184833.67055-2-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716184833.67055-2-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/25 11:48 AM, Ewan D. Milne wrote:
> This has read_capacity_16 have scsi-ml retry errors instead of driving
> them itself.
> 
> There are 2 behavior changes with this patch:
> 1. There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs since the block layer waits/retries for us. For possible
> memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
> retrying will probably not help.
> 2. For the specific UAs we checked for and retried, we would get
> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
> from the main loop's retries. Each UA now gets
> READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
> retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
> is already 10 and is not based on anything specific like a spec or
> device, so the extra 3 we got from the main loop was probably just an
> accident and is not going to help.

Is this the same patch as 
https://lore.kernel.org/linux-scsi/89938a66-7203-4809-8d45-c820b5a21d4c@oracle.com/? 
If so, does
John Garry's Reviewed-by still apply?

Thanks,

Bart.
