Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1CD2C237C;
	Fri,  6 Mar 2026 02:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772763408; cv=none; b=F2v0CLcKwQZVRlanEBj3KSKlV0YVKm0gk+DQpHPzf4ynIP/9yDgK9zTbJ2oi0xM2du1ucGvcR8nxgL6dxvRKlLYUOCeGJ0fNfWqRgQkYcsbmLzgytoEifxZgzdFGJaqynp6FZusb0BfhrUXBCzoPw8OFyjFiDNwYzH5xIgPluEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772763408; c=relaxed/simple;
	bh=TgGMYh2DP+ijYv+4mXIdHZZry/vv5D3g9hz3pz4gUUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nbnf4v4liHXeq3QfnAHs+GbGsMIGGXAtHhH8op1UqlZXMrG+pQALBpyJJ5QVJAO5KLtmelOPzi06wXLH1k999hiqG9sgw/YcIP8PvUQ7muR0UiHojMPlTHDukCotxFKGIrjTyA+A52f35i+rS9yiSN45M8SaeQYiMZFMH0qwCy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Fmb6MmUO; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Fmb6MmUO"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fRqlz0NRJzlh1TC;
	Fri,  6 Mar 2026 02:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772763403; x=1775355404; bh=TgGMYh2DP+ijYv+4mXIdHZZr
	y/vv5D3g9hz3pz4gUUg=; b=Fmb6MmUO9RTAb/zAArlRKoTXh9EVLjQQzSsAWOQX
	hslDxghfplk0YRi2ns3vbTRjmbfnlpQ0LTJ4v6vGFvOy4/3BTRybHKm6AKIOqltW
	RtXPOJIerQqy0HkY4hdpNGvXK1c41t20+3Hc9HHM1EA03h1Xgya7FPx9+qAY5Krb
	Ux/78eLp4OSGk14UMrsd3p8Y+VEY/NPhnJ8RQa9c/XmvXE2gcFBrXRTDwRQ+Hbh/
	xzqDxnhzm3ixaVNOJ/sTzdMbTudP9sd/takMpHJRuXozGZiOdW+W4bcLykgRFMIE
	KirPeiOul0KqYwrY3r6+YlIcGWyony6nwL7/+qKDvOWN/g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OMO8-5YPHm93; Fri,  6 Mar 2026 02:16:43 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fRqlr0VCrzlh1TF;
	Fri,  6 Mar 2026 02:16:39 +0000 (UTC)
Message-ID: <fee27e1f-ce3f-4a32-9eb1-4b97f6cde0fc@acm.org>
Date: Thu, 5 Mar 2026 20:16:38 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ufs: core: Add quriks for VCC ramp-up delay
To: ed.tsai@mediatek.com, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20260305083610.2672344-1-ed.tsai@mediatek.com>
 <20260305083610.2672344-2-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305083610.2672344-2-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/26 2:29 AM, ed.tsai@mediatek.com wrote:
> On some platforms, the VCC regulator has a slow ramp-up time. Add a
> delay after enabling VCC to ensure voltage has fully stabilized before
> we enable the clocks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

