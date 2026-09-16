Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C524F4AF9EE
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598257; cv=none; b=XtHPzYlqorttYvrjffvHJFAD5Ji8vT9JXZ4k1XYJMo4/Get99Uce62UqUuNiK+Q89s1ZH76Uj8jhXGF3MDHbXwFMpnduQIYrNXhFOlc1lhzsuybLqYR4cdPObcA45mMYClKXbrlJtwqNabZQ11vQo9XwkaKuFvHmPXkqwbqqXr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598257; c=relaxed/simple;
	bh=MfFwZ6PT7eYrulhoKX9cWdFeHt2F4Hum6aRgcNDhRIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ngESOMHolGKJGHTAeoe7HwUN+4/pZYpf6z90vN7FnK3FGnea9T7p4O5KzinqelJcW4C+uNbU9bwbn35zqmKPHFP4SHiprbtmFgAh9yRAHGieXarFi/igq2m8rg+699TCMtq/XFkkcmOStEaBOO+bKViDvhi2Ovy467AyL7tLayo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xioCFcyD; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xioCFcyD"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hlYfr6JFrz1XM6J6;
	Wed, 16 Sep 2026 22:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789598240; x=1792190241; bh=MfFwZ6PT7eYrulhoKX9cWdFe
	Ht2F4Hum6aRgcNDhRIM=; b=xioCFcyDh3R3mE2+5L+nmAju97mhPLIdYnyah6Ra
	3tGmGc7khd/nIfcT1QorhdaXiOuA74tOTmqKx0kOy49ZxghuulsCRzkHlldOO5Hb
	OgUm4mEEtx+fAPem3ld3adVuCwldPGyehIcRTxJ71i0lVrH0jC/Gv+RA9PqtwtqJ
	4apXJvmJzz2jt+NImYe3vUwNdarb6sEJD/XRIIuGG3mtj7OMjAWMzLtnbpYzApjy
	mjKHEiGAeRWYREf5ueR9HXU2giHHm4Dx8luhMt4VfwjSHe1QR/xRsZiLFqB+oZ+Q
	c+eNxGB26D4JtIgIEufevzrjzK4ULPdIMk9ktjYZLPxMdA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oCPytKRQOtMp; Wed, 16 Sep 2026 22:37:20 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hlYfk1X72z1XM4Sx;
	Wed, 16 Sep 2026 22:37:17 +0000 (UTC)
Message-ID: <75a22dc3-4b97-4b32-b4a7-45ea91a4933d@acm.org>
Date: Wed, 16 Sep 2026 15:37:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Avoid holding limits_lock across
 hostt->sdev_configure()
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Hannes Reinecke <hare@suse.de>
References: <afc0626fa47b78d3ccc2d233aa03c8965a74efe8.1789595486.git.bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <afc0626fa47b78d3ccc2d233aa03c8965a74efe8.1789595486.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

(replying to my own email)

Please ignore this patch. Although the code changes are fine, the
description is not. The circular locking reported in the patch
description was the result of a local change in the loop driver and
was fixed before I posted my loop driver patches earlier today on the
linux-block mailing list.

Bart.
