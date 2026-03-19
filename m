Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12423FAE09
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 20:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773952236; cv=none; b=GhigNYiRBtwQzdHklfvOkNB0k0MVpQHPHsFqnY19A+WNtkbwjRhts59E7JUrsL9k3GoZVLCmqNyxbXoVHHKmL9dlx6VNKTtSr3QMrSHsmjx1Q4uj8k0kbBdJFpMwD+VL+rbcwwSA+zg65HaJdVBb4kibMUKvhHZpRRv1s78sCh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773952236; c=relaxed/simple;
	bh=E0n37I9/BlW1ksEzYF9EQGUofaXVKRUIH1X8u68CQi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kaj7XYdThHOlmhTigenk0VSBNzo8+XIZbuInu75WjFe4f9tBffYGpYRsc7uxHkmekGRHttLKm6yHI7n6Ey9jzJ6k73UZ0vGuJeQflk6h/vXy7+9Gv+ADuW5dYiPYHxuKE2ROwOkCFfwWQ+HjDPCn/90eWVTfGS7A+QzqMqKXUCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WzDxsxVQ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WzDxsxVQ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fcHPv1XGzzlfl5h;
	Thu, 19 Mar 2026 20:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773952218; x=1776544219; bh=E0n37I9/BlW1ksEzYF9EQGUo
	faXVKRUIH1X8u68CQi4=; b=WzDxsxVQEnICSGMOMDUD7pbxVFOQ455ZgeHMkhJk
	Nc4CPhAyMRQOa5IUL1Ywbw4dlp34d7BZatlM4F7Q9JQePrSCYOtQ2UC+sBpHwNYU
	4mqon4emKcOF/rocrIqv5dceFrx0UToQGH0GC5AaNvru93O7DxjHJxUZz18c0DsH
	jrI+So1SBkXL5AAmaobFT9NF1J6HxFEqDMvVNQeQlSdO76z8hylIUZRD+lAe0Hxp
	itCPyeYqHoMkvTzysWj/qD473YNKD25gUiDtA9r6kg+O/TAxrYN7q8AxqidgJShO
	vDGE6WFfEn0f3NTL8mlwgNlDeW/kjmC6iD69XHDHrwq+jQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id F9x-mJ0BPZNE; Thu, 19 Mar 2026 20:30:18 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fcHPW4Pgczlh1Mw;
	Thu, 19 Mar 2026 20:30:06 +0000 (UTC)
Message-ID: <e26d9c27-a2f0-4b61-8cac-56b404b884b3@acm.org>
Date: Thu, 19 Mar 2026 13:30:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
 <Chun-hung.Wu@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
 <CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>
 <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
 <a341a70943ffb8b8c5bbc9b4e19c017fe664fdf1.camel@mediatek.com>
 <473ecf74-1907-42a2-a785-6164720cb641@samsung.com>
 <273fe7ab805f050ca185aaa9c48da7995f7558ee.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <273fe7ab805f050ca185aaa9c48da7995f7558ee.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/19/26 5:39 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> So I suspect that lockdep might be misjudging with "PREEMPT"
> setting.

If this issue would be caused by a bug in lockdep, which I doubt,
there should be other reports of this lockdep bug, isn't it? Even if
this would be a lockdep bug, this should be fixed because lockdep is
an essential debugging tool.

I propose to revert patch "ufs: core: Avoid IRQ thread wakeup during
active UIC command" if the root cause of this issue is not found in the
next few days.

Thanks,

Bart.
