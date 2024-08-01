Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9393A1B373D;
	Thu,  1 Aug 2024 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722528447; cv=none; b=dl3kzZ2ZzYgCBr66zUqeC63kRQa17jq2oCsmL8i94aQwOieFl/yi+MG7IELB/C/flQucT27Xv4A/iYHUxiTx60AgaW6JbCgO1TCLxibDwAiHfjWRDBcDFeusshAzP5KOh/tPMyg/p7b2V9STNxLmiJU/JSYtIFWvr/rLlRSk6GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722528447; c=relaxed/simple;
	bh=Ig+sePwA4HNpClM/4Mds6iz7krUTEzr1zJnYIhjyemU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ESkwUPw+bNEYDNus0vHk48n5anq0+AiGt70HvrgXQbzg15ls5TDnio2f/WNgY4KOWMtBiGvgPuqHkl9iCA5N8x2PB+sBTfgoXI8s+FjP53KuDRGwRKS+uY4JmJpTqmcfX8UC5tSEQh76RJze3b7ur8ROaSBqeIHRvnMBhkNJBy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eKnlPG2A; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eKnlPG2A"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WZYl0081HzlgMVR;
	Thu,  1 Aug 2024 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722528441; x=1725120442; bh=Ig+sePwA4HNpClM/4Mds6iz7
	krUTEzr1zJnYIhjyemU=; b=eKnlPG2AwH+4teL9gptPTV04JbqGFIOSgtJvILs8
	n3amG5pyVZflPQb4aPVaUuMrRA5uJ2Lw6NZBM2Gm8UaygG+HnjVXC1sC3YZy+IF2
	4t4ljpEzm9yVu+yMVZIfXOtuBW8PPtgHFOYPRQ9DtVS8FX2HIp/LK3QWGa5WVcGW
	bZDw6jXXwmpV8SEr2HafqkMV4/J5SbEJv63dFDTyXWK4gRE+N5GRWafARXVPiChn
	ufmO/GSYV6x1guYscPbjkJjD83dQmSb/YfqNYGVVfzJ+nu/v5+koWLAcdrKwULMZ
	kv711mSebHAubLCVNH3ggLuCz3dphfIF0Vdi5zBNScVW7Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9-dOXuroW9Lu; Thu,  1 Aug 2024 16:07:21 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:b0e8:3901:a8d2:924f] (unknown [104.135.204.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WZYkw6WzNzlgVnN;
	Thu,  1 Aug 2024 16:07:20 +0000 (UTC)
Message-ID: <e6641f7b-7353-4cd5-95a4-14c794a495c5@acm.org>
Date: Thu, 1 Aug 2024 09:07:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Move sd_read_cpr() out of the q->limits_lock
 region
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Coelho@web.codeaurora.org,
 Luciano <luciano.coelho@intel.com>, Saarinen@web.codeaurora.org,
 Jani <jani.saarinen@intel.com>
References: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 10:42 PM, Shin'ichiro Kawasaki wrote:
> To avoid the WARN, move the sd_read_cpr() call in sd_revalidate_disk()
> after the queue_limits_commit_update() call. In other words, move the
> sd_read_cpr() call out of the q->limits_lock region.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
