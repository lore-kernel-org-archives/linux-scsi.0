Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04C83AE702
	for <linux-scsi@vger.kernel.org>; Wed,  4 Mar 2026 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772635426; cv=none; b=d2iVFrXpP1gKiiHQv8boU4XpsntuIEr7Hk7xFDSq7gFgM1ajTL9P8qn1cx4FGpY0980yCJcBZEcHZH9YDgtIlbzqr9fHsnlAob7xjvkVg8F0BeELeK56ZIFFamvyiYEpCW5nf2tPJKQF4vn4vdUzF1u0honqjnPBegF33EVLyDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772635426; c=relaxed/simple;
	bh=xvSeYwvnuK2yOnn+j2vRgJRxBnSIUqMPQi+va4FgXEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4Ms1UfVUf03IHHOSOMD+h9Z6r28bqBBEpNKg+2PV4ZTJVG0tF4iBfFuWLuwc13/Te1A4S/TTmydOXWnDSBCwtrNP66lNYOD+zPX/6Ls/mcGS+dEhmlAmFz88z7u3TSm0fQjr+JaU4k+ZI2aO3aXNw9EUmk/TSl63zdkqpEjIsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i8RxD4DE; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i8RxD4DE"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fQwQk6lqJzlh1T1;
	Wed,  4 Mar 2026 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772635417; x=1775227418; bh=xvSeYwvnuK2yOnn+j2vRgJRx
	BnSIUqMPQi+va4FgXEg=; b=i8RxD4DEwBTTe7Kn0ZvmN47xkLDi9ETlv58zbtJT
	TMyhk2KK1PBcPUNs/is2c96wWwHCYaRuKL9NaXHd+wrSnliJ99fll/dK9kuTrysF
	RL15/osNMEtbbfjFrRxerz/CsA24+OqwtpsN5+qkT8lxT9MuoCUciOR0sHBXlFLs
	CShj4fYtXXzIuWKz5uqmZ6N5TRVjh+GAigt1GBhGnVKVsH9N1SUPCiq76HEg2OVK
	YpODqmOw0DqrENabf2BpDxP15IIQvPpg2Svmw2YhwfyWPoQF6IdTDnvoAUCKsQoB
	LmgWSSeT9Ie2gGM41T2lN8uHmcnG95Hp5C9qXnPhdOeR5w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9wVX-3bOPgFa; Wed,  4 Mar 2026 14:43:37 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fQwQX2HyNzlfpMC;
	Wed,  4 Mar 2026 14:43:32 +0000 (UTC)
Message-ID: <ab2de228-47f0-40b0-b586-c970a9c0652a@acm.org>
Date: Wed, 4 Mar 2026 08:43:30 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@sandisk.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20260304071346.1391315-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260304071346.1391315-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 1:12 AM, peter.wang@mediatek.com wrote:
> Only return IRQ_WAKE_THREAD when MCQ and ESI are not enabled
> and no UIC command is active. Since the default UIC command
> timeout is 500ms, handling IRQs in a thread during an active UIC
> command can easily lead to timeouts due to delayed processing.

A context switch takes somewhere between 1 and 10 microseconds.
That is several orders of magnitude below the UIC command timeout.
Something else must be causing the observed UIC timeouts.

Thanks,

Bart.
