Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85F8335563;
	Wed, 12 Nov 2025 16:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762966493; cv=none; b=fdxOAD4FBmVHpJ2E3erZgjcTRbcWtq8zkg4NRvSJEz+1QPnWpU4Yacdp47e/E23LmvHd4Aj59MXu9MgqXWp31TBiqIGby5bgXd65Ytxt8gYsJS0EwzavoBhUhWLica8SideyznQvWfeplfS4+VwEp0XyxLkLhtcOsXNyLePVpMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762966493; c=relaxed/simple;
	bh=VD8a4SS0yMO53+ZVV1cx5tlNfRvslXgHHNGKFKMUuYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=acwNI6BchfoEGToIU1XD9tVyBqtZiS1pqGrfPcuxe3Zz/XV27jf535celGnv3wbaAnnGmiAokIwAID9qI/gFBa5JAJbihfpNOIddu2VrXyI7GaZMArjz/hnOib3vclmcbVwhPO/xIcPYm+FaLs2ZBtT077plD/OsypyH8g5eIas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=z4xQD0O3; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="z4xQD0O3"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d68Ym0zQkzm0yQW;
	Wed, 12 Nov 2025 16:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1762966282; x=1765558283; bh=VD8a4SS0yMO53+ZVV1cx5tlN
	fRvslXgHHNGKFKMUuYY=; b=z4xQD0O3nCJBMEpVijbOigC1jYOrKfDT7TZfyFTM
	HJeTrRpdDiuKh7RyvI5J0osFC8eL6P0eaCYWgdVAm1VTYBPf30t5kReE2TtAOdUe
	mvCSXJTkYWBfD6dRRDiTteaIQ1/71sJqUG/5sQFKSeFC2vOAZ5s7OE3s/Z1DPfb7
	UPkmH3OfzEG05CKo2p10OGqZ9nXrBrUqOL6E1pQhyw8cMxN2UZLMKETKmBA1Xo/s
	RG1Aer/CpbKrOk9ZITR5GssteDdAPabel266+cNMxl5cU0Hi+289CAtGBTP3AxUw
	wR7i1oGoTqKl3xVSNj0UVs9sQaST/AbTrdanQ2dYuhia0Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hzMhZbm0qqQ4; Wed, 12 Nov 2025 16:51:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d68Yb5grLzm0yQB;
	Wed, 12 Nov 2025 16:51:15 +0000 (UTC)
Message-ID: <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
Date: Wed, 12 Nov 2025 08:51:13 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "sh043.lee@samsung.com" <sh043.lee@samsung.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "storage.sec@samsung.com" <storage.sec@samsung.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
 <20251106012654.4094-1-sh043.lee@samsung.com>
 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 11/11/25 6:58 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Using a module parameter is a flexible method if the customer
> is using a device that may require an extended timeout value.

Introducing a new kernel module parameter for a timeout that depends on
the UFS device model doesn't sound ideal to me.

Can't we increase the default timeout (TM_CMD_TIMEOUT)? Increasing the=20
default timeout shouldn't affect any configuration negatively, isn't it?

Thanks,

Bart.
