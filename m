Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D13F14B08F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712940393; cv=none; b=tz7MnVfxQkhcQSLp2T+6JJ1kyYFtgDvia+q/W2cb6JbGMjh5kQqLgEts5iLwq7RtVLfXD1BUakjlU7WgHns1VJIGKVoM9xJ0FnAAd6s6gDqpTvq/Qu03U4JzEhcGoiTiZVFaNSkZOctPXQ0s9EilmfcuBKZLoi7BnZ8QeI1nBYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712940393; c=relaxed/simple;
	bh=Pl/WJINaFA1/sRqe9DFAgJ3z04FHY1wCp6QqsuAlfOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NEMJ5+N5mwc8sdLYvK+FD9OwmAq/oxfpIfgHA1XolA4jbOBL2ZVx/ktJ8UYjnC2v4BvJsrRqcYPxLP1saGi/4xjRJT0tvSv15tZsWWWxIZD1XpxgbvW2tZcacUjThRUqpXBWyNrYSpRi+Iq7k1QblrIidwju5h7lYRzpT+3H4Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=39cAwi77; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="39cAwi77"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VGMsL6F4yz6Cnk8t;
	Fri, 12 Apr 2024 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712940385; x=1715532386; bh=Pl/WJINaFA1/sRqe9DFAgJ3z
	04FHY1wCp6QqsuAlfOk=; b=39cAwi77Nzqh4RAkSxzfJeCfPWvLLJDdCaI82VIj
	mRYmQ71UC8LMdNJv2h+MBHrILyL3W8ItD8mcPskLZHCp+xh+ViM5ShuwwjbAjQ1O
	2E1tWvVcrKnFbpqnaHZFLp9Cw0LInI2seFQ5Frz+zvEsyEFF6LjE96NUUJ6/91Ia
	CpkMF48b3z6myC8hFbFuKvo3QL3rOPWwuxbFRize2hEtS8Wo2H3wOZljOhxQK9rW
	hPxdVz+69zKLKV367uo6m2Q5qwggVJNu49ODI3DGhHhxzEz74okfYZZy8kT2DwgR
	0/R8VawxwFC/SeVOkUftOXhzhdzXP0eLZbkDt0GOREgfpg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8WzHmnjyAVXT; Fri, 12 Apr 2024 16:46:25 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VGMsC21GGz6Cnk8m;
	Fri, 12 Apr 2024 16:46:23 +0000 (UTC)
Message-ID: <52620d13-8058-4575-89e7-f7bc13183906@acm.org>
Date: Fri, 12 Apr 2024 09:46:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ufs: Make the polling code report which command
 has been completed
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "zhanghui31@xiaomi.com" <zhanghui31@xiaomi.com>,
 "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
 "keosung.park@samsung.com" <keosung.park@samsung.com>,
 "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
 "andersson@kernel.org" <andersson@kernel.org>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>
References: <20240412000246.1167600-1-bvanassche@acm.org>
 <20240412000246.1167600-4-bvanassche@acm.org>
 <a5d76eba8f40d05c47f3b1e0642f9532b058c345.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a5d76eba8f40d05c47f3b1e0642f9532b058c345.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/12/24 02:32, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Please also change ufs-medatek.c ufshcd_mcq_poll_cqe_lock usage.

Will do. Thanks for having reported this.

Bart.
