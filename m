Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A781BC40;
	Wed, 31 Jul 2024 21:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722459926; cv=none; b=KEW0Z0d1e0S28Mf/2uwK5ShoQAGxvkNUvXGlgLaZ3OtqpDCRzKO5XwKOuLZhgWzDbtAyMqx2eLGTqzF3xA4usva+aMM57a/vukGikw6tTrv38n0Q4K1QKR13b32aY3QB7SympQDF5ugqxJ+EaXXaIJqZItBxAXSJMd+tMVgAaNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722459926; c=relaxed/simple;
	bh=GwkVecP6q2Vmd9oETxOoHf+AY2APEHTdGEDimR+ES/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRNrK30/pxG7Hfbd2u4ZNbkpp+aW1q+Yiudng/g8kPtzJwsDOe5TVK2ctdxh3/fShfEMrVxKep0SKcajrdcuYC59Q+vQiSJTtI5l9o45l7KOWIEcFxJKua+lgcJ/OQ3RPhAnrcAqWFrcXYIBuup9PWtTOWdgNNBWWB3yyPVaHYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aLUXxsBS; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aLUXxsBS"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WZ4P95fvxzlgVnY;
	Wed, 31 Jul 2024 21:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722459916; x=1725051917; bh=GwkVecP6q2Vmd9oETxOoHf+A
	Y2APEHTdGEDimR+ES/g=; b=aLUXxsBSYLkj9BkVc9IRWnvORvNQPIUvo2kGfVVc
	3a2WJ6wjvGDKpXbwG4saDaeKHzXtqBg1DSZL4xiC32QML+l0RFfje0LlCSVRBpk2
	28nI/Wiu/aOIJ6kU+X2FejNvl02ndtTxO7yYSMwcYXW3zYFAgpTFCpnWa8FmgQLk
	Tg+oZSHSI0SSW28qguYAC3k8ReuY8parqewtQEnDqsvf00LuIX2cgu7HR0yVQClC
	BOQB0cW3KWvDyeM2RuygCrS0l55oCAEIe+QUmB7GRrSPF1B1Xi3FJ0wRYH1Ieqta
	d7MiCMAJku5c9sLsYG0UVGyyO+7BJ8wdCiYN1xgBZvx0sA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dM1DZlz7Qw7Y; Wed, 31 Jul 2024 21:05:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WZ4P66cqmzlgVnN;
	Wed, 31 Jul 2024 21:05:14 +0000 (UTC)
Message-ID: <c22a8f6b-7004-4fa2-a812-70acb6c047d5@acm.org>
Date: Wed, 31 Jul 2024 14:05:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: Use of_property_present()
To: "Rob Herring (Arm)" <robh@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240731191312.1710417-8-robh@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240731191312.1710417-8-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 12:12 PM, Rob Herring (Arm) wrote:
> Use of_property_present() to test for property presence rather than
> of_find_property(). This is part of a larger effort to remove callers
> of of_find_property() and similar functions. of_find_property() leaks
> the DT struct property and data pointers which is a problem for
> dynamically allocated nodes which may be freed.

Please add a qualifier past the prefix "ufs:" in the patch subject to make
it clear that this patch only modifies the UFS platform driver. Otherwise
this patch looks good to me.

Thanks,

Bart.

