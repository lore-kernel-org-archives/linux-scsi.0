Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E144217167F
	for <linux-scsi@vger.kernel.org>; Fri,  5 Apr 2024 19:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712346636; cv=none; b=F+i88/PAM53Xfry77SY8ENegOjMY5tE8NwF8V0gsZUnmmXqt8p6Rz/Ilib8DWhLVEOWTyFX3a9UuEZGBM9iKa5SeGit3MrlFEjNuGpfh99kyNREvgj8Wmcd00fnSeCIWePGsBJtRoipQ1u2SkeTPoAirObVn2Tn2OUXl/XmYiVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712346636; c=relaxed/simple;
	bh=Ocy1ZLDA04edLlLdd46LgfXCCSbjzqlIJ4zZ75n3FvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pv2szhiwkguK8eKMpd/Yj6F0AVdd7HBFKVwSNk2xshRSwnL/azzhSVzQsJfVeUbXSaRuhXnpWRyz3/QD0ngiMpRsA8i762w19RaUZRnHA7NMcbcfqwzFMfIGmTMg2+me9TiB96+gr470LX3XTvr/Sw3r4E/v0D6mqReLyL2rS0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rSGS7JQD; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rSGS7JQD"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VB8Gy2F61zll9bZ;
	Fri,  5 Apr 2024 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712346632; x=1714938633; bh=Ocy1ZLDA04edLlLdd46LgfXC
	CSbjzqlIJ4zZ75n3FvU=; b=rSGS7JQDqq2jpudtFOWH4cwCRRshEkT7RZzMUWXr
	luaEHDIGzmHimlkTx82z7ao8ZZQyjddIzG2bCERRhRmKpfS6JwuEPWG3oAaDXzK/
	d9gdHz9iaQUiXu1NGWmB4xHAf/zMKp6vq2yo1yXCDNHt9ocabz/WRYSqAVuYVUrR
	Goz4N1sB8yjnjA+zQfJxZ6EPdHHa0koJMfeoSbKVUbaFpiD92M8u6dxuGPzjgZAd
	IvDezlKSf7WEdJSn2c3bJ3N/gSK+NnIsJstXfYg4Z2jwt3iyd/tfVH1FxMvrrUFL
	qyoyPFPng1k0H2COPB3s2SopxJBa/EdN9GYbycjvBLX0LQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hGYQ2bTnB5Sk; Fri,  5 Apr 2024 19:50:32 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VB8Gv6hrdzll9bQ;
	Fri,  5 Apr 2024 19:50:31 +0000 (UTC)
Message-ID: <89c4585a-cdd4-4a7e-80ef-fc25a1fe970f@acm.org>
Date: Fri, 5 Apr 2024 12:50:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Reduce stack usage
Content-Language: en-US
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240325224435.1477229-1-bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325224435.1477229-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/24 15:44, Bart Van Assche wrote:
> Fix the following build error: [ ... ]

Please help with reviewing this patch.

Thanks,

Bart.

