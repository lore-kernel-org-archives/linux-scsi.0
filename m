Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8521B84A5C
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2024 17:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713201433; cv=none; b=PFRoDHnZ/wpYdRxqoyks5Xjvfsn1jp8dmCjp8fy41/6DUp4jlOFFh8H7bRNhDRBPmJAjDkA9/o/Rt8/u4ColjHUGJt5xW+gnvOk7mORYu52wyJMmIKnox7U/6/GBuKxX9yCvw08aVRb6jXK72+QWqs8WL6tHsiA67jgUfYhWSwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713201433; c=relaxed/simple;
	bh=U6QS15fOD+cL0Px0YyBzYPtMHFROtnH9oXR22aKF+Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lo1mlp2Jl9UKDq5oVFeWlpXLDMTm/qjBrOSNsGw5Gt/K85TGDr98LPvqzqdseHt2bW71Xz5VnEYKr7O0q0afawbXn0S7y1z7Sb1XJ8RDNEMtgL1WOki/lxXaWu1hV+ZRBHSeT0LGRCBMSNMzfF19oR6DHOjIvCUAv66ht5md2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uOgs1j/O; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uOgs1j/O"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VJDPF6XDQz6Cnk8t;
	Mon, 15 Apr 2024 17:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1713201419; x=1715793420; bh=UIzBHXUtHYC6PFCpbeFor5Y1
	D/yYU1J90L+1KbYS52o=; b=uOgs1j/OtqXjtN8jYys0Q9A/tTXFU4zjtKhRuYD/
	RPFkqcY7l0pX+BEJlLkdL9VLeNaNbHhaWA8CpUQo4362p+cLtWp2gm1D1cUMsKy4
	qK3G8MTagaUBHhs0My+LxBEGgg5GHLaxbBzjbEXi5lOmZg8KWsN0Ho4xAFQZObxt
	Gk2QFXFZDmajcx5re9oEyNMK+7YxEzTV888VzjQ7tk6sH4W92OLyhbWeg7EKRyo5
	xowVsdeSaEQR018UXQMAergRbsARlrvNJmyU+qu4RLcjg7KOYfeazfj7LNDnPpGK
	dnW52wLsIHhlisckAHZI99UniTGQsEx0jOAb5RgZOFZk5g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2cnZbko1DR-F; Mon, 15 Apr 2024 17:16:59 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VJDP20Wplz6Cnk8m;
	Mon, 15 Apr 2024 17:16:53 +0000 (UTC)
Message-ID: <a2631fa2-ef13-44b4-be04-967eb3c2a9c5@acm.org>
Date: Mon, 15 Apr 2024 10:16:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Remove .get_hba_mac()
To: Bjorn Andersson <andersson@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Konrad Dybcio <konrad.dybcio@linaro.org>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Po-Wen Kao <powen.kao@mediatek.com>, ChanWoo Lee <cw9316.lee@samsung.com>,
 Yang Li <yang.lee@linux.alibaba.com>,
 Keoseong Park <keosung.park@samsung.com>, zhanghui <zhanghui31@xiaomi.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Akinobu Mita <akinobu.mita@gmail.com>, Avri Altman <avri.altman@wdc.com>
References: <20240412174158.3050361-1-bvanassche@acm.org>
 <ozm4y6q7r7ikwrtffgslxvw45ok625r5gjvdbgiyegrzavd2xe@45jyef4lfp4b>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ozm4y6q7r7ikwrtffgslxvw45ok625r5gjvdbgiyegrzavd2xe@45jyef4lfp4b>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/24 18:33, Bjorn Andersson wrote:
> On Fri, Apr 12, 2024 at 10:41:29AM -0700, Bart Van Assche wrote:
>> Simplify the UFSHCI core and also the UFSHCI host drivers by removing
>> the .get_hba_mac() callback and by reading the NUTRS register field
>> instead.
> 
> This quite clearly states that the change is merely a cleanup. Can you
> confirm that (capabilities & 0xff) + 1 read back as 64 on both Mediatek
> and Qualcomm platforms? Such that this indeed is merely a cleanup...

I'm waiting for feedback from MediaTek and Qualcomm to learn whether or
not their controllers comply with this aspect of the UFSHCI 4.0
standard.

Thanks,

Bart.
