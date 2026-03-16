Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71873CFF49;
	Mon, 16 Mar 2026 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773681260; cv=none; b=pJop2n8rRrUiQwXXXlfcmDY9E1Mj38hreElwJBg4mxiZ6d59G1NkHnaYtz3pPIEnslrcgeI8MlDM4P5evlo/caPh2z8YEkTGkJoxIIQfXFu33vPVR2MKlY5x/KJRqKuaucYsg+E5X2WO7ZF4BAhrc1g9WmkLLESugzGiKTSTkMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773681260; c=relaxed/simple;
	bh=lxSUrx4d5HrlCTAt4QgxuVpUKs0EaF4mZ1einmSLifU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y6M44rSwTROmdcvD/JFea7vYvpStUGkkmQkcb2OTAe+MjGYHNpwKSiHdZcLFhRp31mI6mpb9eVcvw4lKf76Q9hA5H4+qVoOg9STRaCwu1sIZi/MnHlhgIxq1073prcHP6wEqVWxsJqOD9Fi3TYuZcH0TT9gN5t0V5NoZ/tzEwLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ceoIxCiy; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ceoIxCiy"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fZMBz24P5zlgwNG;
	Mon, 16 Mar 2026 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773681254; x=1776273255; bh=HeSBIVt0JKjBiYmKZ+iIeE1R
	jRSDML23nYGKhJ0vUWI=; b=ceoIxCiyIjArZxVa6koTLQVW0lsGRi9d5k2mKwNA
	eoegpBY6iPYJqmqQuYaOWRD0Ayx9UDhrT+h8YIVq9CQHX7a89OgmFrX5oOF/bnB2
	Ey7/nj/xxVp/xC3zjzEFZbYympicHIt9WJ+plrDOSkCJhNKiRtNMq2d7/wVtp4u9
	o3832r0c91JEHa+BlnbBhnjdNkBSn4ZUwDqR8hYNoIabV02F+KqgC4eePLXW+L+o
	GCV32pTqSBKtl9+g0qenY37gb0x7j6xQFnubPkmRWC5AlQSwXbw/8qiNvfAPdKJS
	GZVPZh5U4xtanN1/rGslFBNBsvQ/6IjwRpD7csRXiQKfZQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id phAwyv1pGLAJ; Mon, 16 Mar 2026 17:14:14 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fZMBr0P33zlgr44;
	Mon, 16 Mar 2026 17:14:11 +0000 (UTC)
Message-ID: <c9df8dcb-4711-4678-8759-c0c72b5d5f8b@acm.org>
Date: Mon, 16 Mar 2026 10:14:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/12] scsi: ufs: core: Add support to refresh TX
 Equalization via debugfs
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-8-can.guo@oss.qualcomm.com>
 <bf64badf-161b-421a-a9e6-76e6679d5c9d@acm.org>
 <d537b40f-70d4-42f3-bed6-616da2489950@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d537b40f-70d4-42f3-bed6-616da2489950@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 3:45 AM, Can Guo wrote:
> I chose 'refresh' because the code conducts more than just retraining of 
> TX EQ,
> the code also carries out a Power Mode change after that, and only by 
> doing a
> Power Mode change, the new (optimal) TX EQ settings are really used by 
> both Host
> and Device.

Thanks for the feedback. Not sure what others think but I still think
that "retrain" makes it more clear what happens than "refresh".

Bart.
