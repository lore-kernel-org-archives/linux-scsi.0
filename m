Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3DB31813A
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785951623; cv=none; b=FhsSeBESaV1ZxwRnTWc9e/RKkb0n9fxamJlrYFLOHfW55VbqxDbzXVYodED1QdjC0c0mh9shd4mrrfYyzxmMXwD9MPT2A3r2Tt0Se3bzVPS95TJxC5x9oYytcopK5pA5rd6iVVGrQdq2np2zDd5W8/onzIaKXEfr35WxUV19dFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785951623; c=relaxed/simple;
	bh=w8MyboxfOv2+Sz8Efy7kgS7WENRxNi3/cpW72DRk99I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U3gz6BxRyWsv5+Q0JkO/ZquzhN8AA6t6yTAq9Cvpa5KdxzpZfpx5o8TWUMATysHbwaFh76BA2d5NdOzVuYF428fMsfaYNvFm9HO/fPHUiBfZ62NbWnXhUOuRKSyBffIC1mb0n0b2v4lyw1pXa2mwdR/MU+nAVrVlUEVelhsLk/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4cn5XRw5; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4cn5XRw5"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hFd3T3lGcz1XM5kW;
	Wed,  5 Aug 2026 17:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785951618; x=1788543619; bh=w8MyboxfOv2+Sz8Efy7kgS7W
	ENRxNi3/cpW72DRk99I=; b=4cn5XRw5rhp74mjFTCmL6nExEgoIY9Gnc4sb3phm
	jWowtyV9/zGa5NQpJaI+dijA/FBGhTpK1qfWCvsw///ShOvWVswFtOu5+gx5f342
	/6E1K0vesAAMkYXKqXoeM/d0+OZ8F7Kva3Y3Dbr8fzcfBnX3JviBURmc2yYJoSVU
	EsAit02cvAax9EgbLAwu3qaMA7I5NhNVLo3TUAyfnCUYAfAqDm2wpq0OJ31sfs0F
	b9Im796p/koeext8xsdgvdWJoYm4JqIAr0fNMEoDtkWdelAcDlrCQxK6HHSFB+0d
	NDrHcyeJ7/0piqzWG2dy9xk/5ivuXxSXo68HD6sKVg+uHA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bcpHjHv9Sq15; Wed,  5 Aug 2026 17:40:18 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hFd3N51CBz1XM4TB;
	Wed,  5 Aug 2026 17:40:16 +0000 (UTC)
Message-ID: <d11fe81e-425d-4ad9-b17a-72015cf12faf@acm.org>
Date: Wed, 5 Aug 2026 10:40:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: alua: Use access state macros
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, hare@suse.com,
 John Garry <john.garry@linux.dev>
References: <20260805145906.2825553-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260805145906.2825553-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/5/26 7:59 AM, John Garry wrote:
> Use the SCSI access state macros in alua_rtpg(), which is better than
> hardcoding.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
