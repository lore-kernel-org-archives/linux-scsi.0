Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AC530ACE3
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 19:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781120850; cv=none; b=UzAaWd36IZ1vlCyXZOr5lgT9EFt/LMPHbtqMCmLzBCH5YFSv0ZS552evSFirsU+aS4pJVzy7WGsne5nCwD9bqE60AlHbkvNc3YtXkyUzDFHNehmZNQ9iSZJYKnpLEt+6De2Ztn10fyUS4Uf/2PwezNZBoz/XrQyj65/jKytTS0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781120850; c=relaxed/simple;
	bh=E7CuLlKDZQznwpaWJphoeGTh2ZPlfY1z5LRT1Dzsgs8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=poCS46rv3Xp/ssDtvTPz0M0OGdcid5BzmTIxAv5r2H7N9yOQUWpzE9N1cFNdQ+xVcS/AioATfRp7NfuzSIoP/Dfl3JG2efzCkGYgSYJtiwxjKojIL4+o17s+5KooS5hdlOfOSSmF9t4skOwpzWXMsYg+I4in6tF94wCrkwGhOgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZEgvhFh3; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZEgvhFh3"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gbGX05D3nz1XLyhV;
	Wed, 10 Jun 2026 19:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781120842; x=1783712843; bh=E7CuLlKDZQznwpaWJphoeGTh
	2ZPlfY1z5LRT1Dzsgs8=; b=ZEgvhFh3aWTwzPvm/qnW0WCvohpmGvo+U1XLlAs3
	GjdJrtY6HX+CODsE9bCHSxywwBNqilyNA280kb0REZemR5DTwz3jW1AYTtOkV+QU
	IcCAcZCN9uC+YwtF3AvGmf1qvV+Ftsvnjx4nNg3fdFhO8M9xPgJBncASch0/b+2A
	XkwJxx4ilpgKHyAgc+Vq1JiO7PwJX+BPVmZFoA0V/0W8SfUIK4XaI9b+6OfYAkRF
	purUxEZshqtEnBnFzQUtXBRDLxheQrNqqk3DWZjKawpxqovbiCB6Ic4DmVhT9rtp
	i4AYjzQYGybZAXPLO/U7GQQGnPRyDe/lfcqhlmLkXAAgAw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aY3bP3U30VI7; Wed, 10 Jun 2026 19:47:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gbGWp0ZLdz1XLyhT;
	Wed, 10 Jun 2026 19:47:17 +0000 (UTC)
Message-ID: <42164c06-3c54-4d66-a29c-1e0d46210472@acm.org>
Date: Wed, 10 Jun 2026 12:47:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for
 clock scaling
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20260604133503.2049288-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260604133503.2049288-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/26 6:33 AM, peter.wang@mediatek.com wrote:
> Hence, it is not necessary to stop I/O during a power mode change,
> and this step can be removed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

