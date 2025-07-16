Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F301325CC64
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752679213; cv=none; b=ARx1hvpTiB6uCft6I5j11RU35/FFFPcAC5KyHugcho8iy5v02/LOAvKVD5iRZ4HGF94M1L+6PSCZ2bg99KDmsPEC+S2+NA9aUejtrkpoE4fZ/xqS3ZbFqLtsY4B/KV72Qo7gsP0vrQrIKYSF1wL8YUg1QfY/1Zmasz0JPL5Zj/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752679213; c=relaxed/simple;
	bh=sX9lBraUuanxGYhCFaLBB3OCqc6O7Dm7X6jDDXnf/mI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=igGerGJIpsww3mmh9P68bwlVFn8xOCZb92Z+RIncByq1+11tAvhKvaBNxXVL6QO7B8/Jl3qJC51bsdicG8M0c5+3vokTgh1Q7mHbFM5rJCvYqm48t3zLzUBrczOp/C99GxsuNvE2LzF6FIpaLfiSIXMHs+43DouyviDnxh25cVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jCABoDDJ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jCABoDDJ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bj09P6kZlzlgqxm;
	Wed, 16 Jul 2025 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752679206; x=1755271207; bh=sX9lBraUuanxGYhCFaLBB3OC
	qc6O7Dm7X6jDDXnf/mI=; b=jCABoDDJtXskta3KMa8pDNjGowhnblnFJl+EKz3V
	CF2cI3TIWKWca84ammf0NP4oDiD/bctOe12xdq6aKZ2YwLdEiPmPPcvhRwKL4mS5
	fAu0dN9CzEBio9gtIh4n3rR8XpbxTs6UdtfS4h0wsMTZ6vCcgJSWHIKjMvftuo8q
	7F/pIyFtpZ8Np3HoAbvoIbplXBr3Af+/jyk6ht6M7eNMRIVEKhqXauZ8p1H3ko5X
	XK2P23TkDGirMLvCLGgS1KVUejpMFyVucPBoETBix8XdE6/VgJ2VS1wPf2L1sqy5
	v7lDwmeqrqsEeXk5pNfXbbFOLD5CU7b1ZHAjXA0MDGkvBw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WJhA_2P1SuSs; Wed, 16 Jul 2025 15:20:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bj0966mxpzlgqTv;
	Wed, 16 Jul 2025 15:19:53 +0000 (UTC)
Message-ID: <f3679ca4-9c77-43cb-a0eb-a4915f0f2c3d@acm.org>
Date: Wed, 16 Jul 2025 08:19:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Change return type to bool
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
 <20250716062830.3712487-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716062830.3712487-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 11:25 PM, peter.wang@mediatek.com wrote:
> This patch updates the return type to bool for consistency
> with the previous style.

What previous style?

Please follow the style that is used elsewhere in the Linux kernel and
do *not* introduce any unnecessary explicit conversions to bool.

Bart.
