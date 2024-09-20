Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3598B14F98
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2024 19:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726860985; cv=none; b=uzWxTDHPgAgChZ0yK1XJMrLQdqWVnfXhtRVrBJnIOhlI8ALStI3ei2bcJngH7KOYQvxZXR+lyeqpk2vjQQsd03H7rhsj0fWW6pjqYEErv6qA+Epk8gGfnCj0ujWCQ9ZN6MiUXLNDHb+gHoNMy7Aft7VYXT8rB4tGSZW/mDanB3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726860985; c=relaxed/simple;
	bh=XZwVm99MSCwmVgD4E2ynjUWi7Gy55GJB+9Ody+tF8LI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rTDCJv2USYwCfBKc5CCe2SeTlNiBl1PVFohvb3dFYoHR32C1T6/5N3X/uUw4Jhi4qIZr7wUSMPx5gr8R5ixUNYOoVN13PEnncVyBdFcitjUNyAs5XkeHASDB9vxasP7gytb9X2tp+4ux9S1AJDtyIPzt72j/+AMXkK0U/vONHb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gad6P7dN; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gad6P7dN"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X9N0x4Qc6zlgMVY;
	Fri, 20 Sep 2024 19:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726860971; x=1729452972; bh=XZwVm99MSCwmVgD4E2ynjUWi
	7Gy55GJB+9Ody+tF8LI=; b=gad6P7dNn6ZwAjkUXpMJ1u91O59k6secRyO4QmhI
	oPZhL4IoNKQUiwuaFk4tx+fLIfWKJPHoLb7gc9SbfLP1+llxoJK0Zc4PMmLomAHb
	f+9pD5oINTpMnHutL2rGbMXrj3Y2uI8il5AMGL2F9QjCr0xuEh11H7jbdN4lZ+Rr
	n9k5ICzWvhqrxufDKR3ctEPiiMw0+QAp3fWEtL5NGKfTWrNQot8FiKqbTtYcurVy
	WlvFtqUTNeA3GQrx9mRvZ+drfPirq1Ps0rWupWnTiNYhuURF+Qc0jscf7ur0UpxM
	qSnbesEKsVOBWkwhJXRrTart78b46Tj6KRRJT23LjdTf4g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tL4M3iYk6R_w; Fri, 20 Sep 2024 19:36:11 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X9N0n5DNTzlgMVV;
	Fri, 20 Sep 2024 19:36:09 +0000 (UTC)
Message-ID: <56d48010-13d8-4bfe-8b71-85699c1b45ef@acm.org>
Date: Fri, 20 Sep 2024 12:36:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] fix abort defect
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com
References: <20240920090643.3566-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240920090643.3566-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/24 2:06 AM, peter.wang@mediatek.com wrote:
> This series fixes MCQ and SDB abort defect.

Hi Peter,

Patches 2, 3 and 4 in this series introduce a significant amount of
complexity. Additionally, code paths are introduced that can only be
triggered by UFS controllers that (incorrectly) generate a completion
interrupt for aborted commands. I'm concerned that these patches will
make the UFS host controller driver harder to maintain than necessary.
Please take another look at the approach I proposed, namely making
ufshcd_compl_one_cqe() ignore commands with completion status
OCS_ABORTED. I think this approach will result in a simpler
implementation, does not require a new quirk and minimizes the code
paths that are only triggered by UFS host controllers that trigger a
completion interrupt for aborted commands.

Thanks,

Bart.
