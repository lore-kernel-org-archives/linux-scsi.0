Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1FA3B47D6;
	Thu, 16 Apr 2026 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776352063; cv=none; b=FsMyj7Ncz+aTHrXGWk4aLtdaaaaAAlsCVOyMnTUv7fwtkdThONWq18tn0b45M2yNjSyK5vcuEexh7KImmjNzkSk6G6Pm7O7pBK5LKnquNJwf59dR89zcrWmcCzPtjrWeji6Wiogj7X4XA3DUIGgCDIgPcgeIExTWnAAUzCAyUi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776352063; c=relaxed/simple;
	bh=idDNp5Qk//bqpen7ksF+PPotml69v8gaaokmKaqUUpk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tia0N8zHv7INny5PMzUXaghvrlVSPg7GSWMG0UigqxqbCvxY+pnjZ5fBrwx8vV4KfMZ/FC2IwJxtUUas203zVf0ipEL0olZ4xBj9yQAzLkFC/+yobQpagfldc/sO8LDLUkwHsbiEkSDNapz72csoRxtr4gAT+QLICBLPs+Io5W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nYAHP31d; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nYAHP31d"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fxLwY6hjNz1XM6Jn;
	Thu, 16 Apr 2026 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776352057; x=1778944058; bh=idDNp5Qk//bqpen7ksF+PPot
	ml69v8gaaokmKaqUUpk=; b=nYAHP31dBTHEN7L8esKhlv9BK/DuZ5gATnT4jOXq
	KEtlrYnU3JokRsj7fX+aSUhgpitDoYF+bTwtuG5RxVbbl8tkMVlJ8m0Z1hAjYJcA
	GLXFgL3cF2pJtZglcqfrfBt/DmTocPJ9duohULGlq1Qh5i+9OccdQeKfkKP9tRqj
	pw7xyg4l/AbKB50jmE2WBGBbbknRmDl9OfcDn/+r2M6NWJiTrJIG/oqddJ8FvNUt
	Jy27OQWlbKgJtCmccRXPhU5r4519aehQPbLKYPEhMMN545CWSxRBNP0lS+w/t2a8
	O2+ZprsHIU+oJ9U4jm7XlOBB4qv2XUmKmZTQzrCrgoiVrQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p4uxBBYKedHB; Thu, 16 Apr 2026 15:07:37 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fxLwQ1fGDz1XM6JN;
	Thu, 16 Apr 2026 15:07:33 +0000 (UTC)
Message-ID: <e605fcb1-6f0d-488a-9826-0e612bf3e912@acm.org>
Date: Thu, 16 Apr 2026 08:07:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] block: only restrict bio allocation gfp mask asked to
 block
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Doug Gilbert <dgilbert@interlog.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260415060813.807659-1-hch@lst.de>
 <20260415060813.807659-3-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260415060813.807659-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/26 11:08 PM, Christoph Hellwig wrote:
> If the caller is asking for a non-blocking allocation, we should not
> further restrict the gfp mask, which just increases the likelihood
> of failures.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

