Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D66221D88
	for <linux-scsi@vger.kernel.org>; Thu,  8 May 2025 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746717670; cv=none; b=e16qlDiE9Vi4QvzjE0hw1pKlwHI0Ielus8VAI0IjfIuw+BSoa+B5hTfGCXRPI0bacm/E5I810h6dwjEn0tAt//JD4wyNK1d1W/f0T0x6fHY8ax0QyMnrKIY5EbFtj0mSCaKwIA5UIG7o4NnhlyTeNlD7gpDOFurhG40MXKHKkwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746717670; c=relaxed/simple;
	bh=5wgP8cTHyuHKbaDzZp/SsUfPN8fvBz396Y+2B7V1loY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+QcTOaQUXbqYjxVo8zDS7Up+UvhxWpi+KHg9BCSThIMUzJ4j400niUyjhZxU+6UZPh2kzoPqBpyXIgmDsI98gFumeK2GSaz4a1IGGNHElK8DgKeha+y8vq/fp2LNX4GdO26+3l303GXvT5ZitY3n6UMsiL+F+ZQrelvQvqcgco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2vqXOL7v; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2vqXOL7v"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZtbSK4pT3zltPsg;
	Thu,  8 May 2025 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746717662; x=1749309663; bh=5wgP8cTHyuHKbaDzZp/SsUfP
	N8fvBz396Y+2B7V1loY=; b=2vqXOL7vn7+uWd0H5sy1bgtiCGZR9tZTgF2q29GU
	gjaNKeNOaM2o/mC5nw0t0rM/XTHLAmKRJaM2Ahh+CaRNZ5lYaUYPO0w+FU/hBVXU
	eCeuLuxwQU5hcfzM/x9gmyigRx3PRt9ZW76x2CyMdtce6oSGSiMfow7Los+hEKuf
	cjCk/yBqs6IH4xOEHvJAefILXumYpb/0QPlNH8CJfRtMl1URezOca1iOiaBB1EUb
	n/Xep/IuCmRZTwImGa75IrksaHz7P8dxKyWhGfZFQEhMHI3t1iizzghgWN0nfNGD
	jlpbZpsY0AZT6I4JkegMX95YbLkNscqGGt5MklITuMq3zg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IMnYJcsWsBHj; Thu,  8 May 2025 15:21:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZtbRv1bRbzlvkT8;
	Thu,  8 May 2025 15:20:42 +0000 (UTC)
Message-ID: <b3fb4302-462d-4b92-a6cb-784000cd796c@acm.org>
Date: Thu, 8 May 2025 08:20:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: behavior change of hwq_id type and value
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com, quic_ziqichen@quicinc.com
References: <20250508091914.307944-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250508091914.307944-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 2:18 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>

Patch descriptions, including the subject, should use the imperative
mood. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
