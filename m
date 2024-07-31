Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917A116938C;
	Wed, 31 Jul 2024 21:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722460032; cv=none; b=FPVhY6gKvzIDK8VqWqwWXmIDISGQ1Qs7UErDFuArElP7sNCf+kWDK8soxBhjGjsEUdRr+bcw881jnle34srPo4CnxJuNIGuyxDa47rEXXsqagLHnUHtQoyS8lHBaiDg4LtzqQSB1uianhwgIpte3kH7Kg/7rKPIK6enauPS92KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722460032; c=relaxed/simple;
	bh=Nuv4sBOX8QX/kuf/UOMjHUkwtkNsXqv7VRApoE5TCAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FB07evo54kXUrFMLuTzJWmKnp8SLce2ugS/jLxr8CKdArOFD45H4jO2Nnum1iS9NWjCfMII+nJ8MvhhZZ3kAf0SUjh+RvUJ4P0Y93qY6Z2jAdkJt6RmKAkAIOcnITQa6q1KXR41uEzjHBqdNuZz2YYVdU+MCiS+5XAjwUnrWyio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JiiBhr8K; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JiiBhr8K"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WZ4RD3htCz6CmLxY;
	Wed, 31 Jul 2024 21:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722460022; x=1725052023; bh=q5mHEl9jVG35BDg0jyUuqFoE
	Q1mIYQkC2zHgq41ZW1U=; b=JiiBhr8KWIED+2CPKEsns3eiT71I0wLd4LZyqVKz
	1UxrLbN3x4mKI0O8HIchXfGcOa94XI71X5BetaL6GXmDDkmFd8AwZaAiFix9+z1W
	o4fLqRIp9trfH00Cynn5uYnXu01cWT25C5xlea9jGflvMXT1huh489cHI63e6wt2
	uGQwcR+syO/z2bY2GJYWviNOBz0gm16wa+ImwymenGOVZrh85nzmrQo+aSHu7eRs
	MUvGr8abDpwC4LqTffYl0VaN3s/u61KyOQAAIDEij4VgR1GkCW2Ni+fqVWkryRuA
	hwbmFPHKEm7CcvRrjYPe0AQ65xZlIl/LCD8xIk9+YecQdQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5cl9QFdfbwUI; Wed, 31 Jul 2024 21:07:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WZ4R91pDvz6CmLxT;
	Wed, 31 Jul 2024 21:07:00 +0000 (UTC)
Message-ID: <c27e1eb8-e5e5-4b3c-a792-c447023709bf@acm.org>
Date: Wed, 31 Jul 2024 14:06:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: ufshcd: Use of_property_count_u32_elems() to get
 property length
To: "Rob Herring (Arm)" <robh@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240731201407.1838385-9-robh@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240731201407.1838385-9-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 1:14 PM, Rob Herring (Arm) wrote:
> Replace of_get_property() with the type specific
> of_property_count_u32_elems() to get the property length.
> 
> This is part of a larger effort to remove callers of of_get_property()
> and similar functions. of_get_property() leaks the DT property data
> pointer which is a problem for dynamically allocated nodes which may
> be freed.

The "ufshcd:" qualifier in the patch subject is confusing. Please change
this into something that unambiguously refers to the platform driver.

Thanks,

Bart.

