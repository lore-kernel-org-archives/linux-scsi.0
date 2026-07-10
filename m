Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737B5430CC5;
	Fri, 10 Jul 2026 14:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694836; cv=none; b=Bpf5GUmqXmw+RMwxhMWnFODlSxj6SvbBaJLuie8UiSXTNHo/sQFSlTsaR+XpyQFERbjYE6bRizJlKIGV7mDYdD8gEHJdPAjA3KhMZnW6k1gUsmD1n4Kq2B8Kk4apBgenkEs9WtUSgnuh/7zmAkRh8u5lATCG2GRxi5msiwjwdAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694836; c=relaxed/simple;
	bh=POqwcdHcpscz1y3DezXHaVnEUYftR7WIU2tXLiLnDeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fdrxBaQzvoUoRHWvOm6qj1STW1kpF/Zz6uyAU+/ZsH9ap5z8UDwA941czIRkJv8Faa2WUXECBP1ip4lAmoxE+zHta6p5940J+Icr2F/Lg3dlPZOQFws7HfQUEdhcxxNXQadN+opo7iLeYp9JKmys22xzgcIaUP+mncl/LQgCbQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J2Pala4i; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J2Pala4i"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gxZRd146Mzlh304;
	Fri, 10 Jul 2026 14:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783694823; x=1786286824; bh=bdAKnK8os679pGOewYuuhBSP
	yqHJgd6ADT1TQgqo0o8=; b=J2Pala4ijASB/8Q9sh3FiBns86l5UrxT4SjzeKEA
	puCJ9Glv5OrGMhQQVm3HWJZC4HgyEaNPa9X71QfHpSLDBFRRR5o/vu4c8sZ6BYYC
	4a/XhVu5AO4GP1fZcHdVALI7yPA0eTmRk8+/aFMAAhEzA6Vr3E/Fd5ZhNx7rGbM6
	GWLb8F+tkuJ78ApME0I6/f6BzI9XsrSJv8+BI7Fg/UDfomN1AneACa34CjdKbs5B
	LQjAkuH8GU2WhBiki0/Y3FQZSNWApc0wtkwk8+8JpRMvBUUmR4/XxEZjobN8Hizz
	WdC4Ic2yllcCVC5kpd3RrAkn4a+zkAGM8k5E/uyI2V0mww==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id v2fkS2rGdq4e; Fri, 10 Jul 2026 14:47:03 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gxZRP16drzlh2fy;
	Fri, 10 Jul 2026 14:46:56 +0000 (UTC)
Message-ID: <6d087f28-5795-4929-b5d3-3f78d9b9bc60@acm.org>
Date: Fri, 10 Jul 2026 07:46:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Add support for the aggregated read query
 opcode
To: hyenc.jeong@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: ALIM AKHTAR <alim.akhtar@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jinyoung Choi <j-young.choi@samsung.com>,
 Dukhyun Kwon <d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>,
 Keoseong Park <keosung.park@samsung.com>,
 Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon Seol
 <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>,
 Yunjae Jo <yunjae00.jo@samsung.com>
References: <CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p6>
 <20260710054556epcms2p68986e2af26f42e63c87ab8fde034e450@epcms2p6>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260710054556epcms2p68986e2af26f42e63c87ab8fde034e450@epcms2p6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 7/9/26 10:45 PM, Hyeoncheol Jeong wrote:
> struct utp_transfer_cmd_desc {
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 command_upiu[ALIGNED_UPIU_SIZE];
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 response_upiu[ALIGNED_UPIU_SIZE];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 response_upiu[ALIGNED_RSP_UPIU_SIZE];
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 prd_table[];
> };

This change increases the size of every CQ entry and also of every LRB
entry by about 4 KiB. This is not acceptable.

Bart.
