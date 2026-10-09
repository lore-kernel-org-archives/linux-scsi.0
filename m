Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E749F4F0524;
	Fri,  9 Oct 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563222; cv=none; b=RxdCFhsHvBOr5C/P7J26B6N8gmD8N+nnMWgIbBBY+jaZmPRiSbtgGXD6ENiLAgoNpgf2SSmfnAZhM58o9hlqJEtxXaydBZqXI4ml+YXn4XZZ5f6FfZOE3HsgRXT1mY4giYw0368rcCPSb+RdnLp54h/KeCv47CpjzGXKzTF3SHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563222; c=relaxed/simple;
	bh=MRnU/xTcjboCDm9sNZdcHYDC6NE2Fhx9ngKJZx4NwVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T6dJ6RffkFfEpPme8xh+HdDx8Y1xIJl4c0/3Fm1C5xRBJrEe4vwTJhjfKkQzS1ImWagMO266hIMcZG+MWNS50FyP2hXcbwg7SfOWWUUvhxyJ9D3yKUHUoNfOU/bK+B8OQCUaZ1ni/LCUog0p/TNkItg2N0rq278mb5HEG7AN0/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=Ztg7eYwq; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="Ztg7eYwq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563209;
	bh=MRnU/xTcjboCDm9sNZdcHYDC6NE2Fhx9ngKJZx4NwVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ztg7eYwqADDDzl/37IhxpoPTmXq7hK/fCK0MCJlhe08jQf7KUBs1+9c0UAc6+yjt9
	 3kpuWpgmfo5edqt5pIXZH6wQyxQhl4GdkiwGoD2n8ntpRCKQP/9+0HsGPienFSHBuU
	 6E4+ulNf5UQ0sIjSD2EV8aFtcP35ApteD2BemkjA=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 066FCBD196;
	Fri,  9 Oct 2026 16:26:49 +0000 (UTC)
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 666E85FADC;
	Fri,  9 Oct 2026 17:26:48 +0100 (BST)
Message-ID: <2fdc4bfd-0ab4-49fb-a046-4b9351654a5e@philpem.me.uk>
Date: Fri, 9 Oct 2026 17:26:48 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/6] libata-scsi: multi-LUN ATAPI device support
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
 <apVF22SjDzqkzEkm@ryzen> <0a7bba64-c0fb-43c7-bcaa-d806f2377afd@philpem.me.uk>
 <askAE1FcZJ3jFiWl@ryzen>
Content-Language: en-GB
From: Phil Pemberton <philpem@philpem.me.uk>
In-Reply-To: <askAE1FcZJ3jFiWl@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/10/2026 15:54, Niklas Cassel wrote:
> Simply sending a new series is fine, like you already did.
> 
> It will unfortunately most likely miss 7.4, since we will need acks
> from the SCSI maintainers on the SCSI parts, and I saw that you got
> some additional (non-preexisting issue) from Sashiko.
> 
> But my recommendation is still to respin sooner rather than later,
> such that we can get it merged any not miss (another) release cycle.
> 
> 
> Kind regards,
> Niklas

I'm not in a rush to get it in, given how much it touches I'd rather it 
be right than rushed. I have a netboot Debian with a custom kernel if I 
need to recover any more PD disks.

I'm about to send V10, which fixes the issues Sashiko raised.

Thanks,
-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk/
