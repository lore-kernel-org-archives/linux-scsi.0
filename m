Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561A4439356;
	Wed,  8 Jul 2026 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783527053; cv=none; b=fawFaZKrn04O9bW5VRBtPWopTS0Ul+a1a3jdk3AN5ceiJ3WyB8LfdJ8QRXHmMy/I4NpwTKe9eXpohYV3smxEoECAyAXQ4bkQANM0D3iRzAOv19z/7IQLGLPp0ioAJ7EaRzyGrw7o03X3SnpRGDrYkOBo0gsbIP/bcZGqK/iawdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783527053; c=relaxed/simple;
	bh=C1TIejWUdfPVvpwpCNZ0XphflYzn5B4iuY9k3oAqZEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kggfP/KZisPU9YWLcoTyIGgk7qFPdesJZ//QZR4bwCxxa7tsZokzaHS2Tksxik1ulKe2/Xl4DRi/urxDxvXnM+ZlQyiHIAwk0KHJgpCj3viOFMHCjVmxUMu2StgdgXom6B0550sd6Oq4iwsWg9eWzM9CugP+rGqBxVxIvGxoxvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NM/zBaFn; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NM/zBaFn"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gwNP761lgz1XM31H;
	Wed,  8 Jul 2026 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783527048; x=1786119049; bh=C1TIejWUdfPVvpwpCNZ0Xphf
	lYzn5B4iuY9k3oAqZEI=; b=NM/zBaFny7NgN6J4FwgcP5jOMq48N8AnYHn7bKqW
	tYRr5dHA8Ru+cXtG+WTOf1QOAoXc3+r5qzRd1rQ4+Uo6U6h1Vm3WCrXG7nNreKaH
	U7q4N9lWVuSbGBW4Kl/kRw4igZ5swJPRy+ZcguNyO4Aa4z6Uzl8+75at7mUeYVmI
	AQBFdSIuWK5cHNQrmRsp9JR1Fqg7/ARLa00A+b0JLoJiqZsBuTIb7oTCcL8Gushf
	Ds2iYiYq/cnsPLjJWIdQz+/UcwQbNs9T73ERel8NYPomJ3SaJKmFAV1l+N5OTNl0
	NvkmJB/YUbMFZlwZHQs05etaOrJbMuTfMp8Q2+i8YGBGqw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tYrmmjVEYAwV; Wed,  8 Jul 2026 16:10:48 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gwNP15YYQz1XM5kW;
	Wed,  8 Jul 2026 16:10:45 +0000 (UTC)
Message-ID: <a5fa376d-90d6-4767-a994-2b91fb9cb951@acm.org>
Date: Wed, 8 Jul 2026 09:10:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: validate and round up scatter_elem_sz module
 parameter
To: Yang Erkun <yangerkun@huawei.com>, dgilbert@interlog.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 yukuai@kernel.org, hch@lst.de, axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20260708063045.2008478-1-yangerkun@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260708063045.2008478-1-yangerkun@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/7/26 11:30 PM, Yang Erkun wrote:
> Additionally, the code handling scatter_elem_sz is refactored for
> clarity: [ ... ]
One change per patch please. The code refactoring and the bug fix should
be separate patches.

Thanks,

Bart.
