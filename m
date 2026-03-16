Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E80B347501;
	Mon, 16 Mar 2026 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773684486; cv=none; b=SZdVvEvJ0KuIEfobB/ryopyrUUv/I9PJhV64irS9CM0b+7ccu1HRcErlGEYUlTmuLkqvcyEUyDJu1XyrGkuiyJM1X/czWT0Hu51skJJNm8u0XwV9eglYgTPT4BK+YSwxJjhEEuNsk9VeiPXkpOo/rkkezegxyJwju/KsmiJ/Ws8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773684486; c=relaxed/simple;
	bh=FHx/pTJ0uZ8eA7b22tyVMk4YNOFSqUR1wciILwwYLdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QITZ7hRBoQedhMyOfux8aRtDw+dwnlarwoWFpU+oElO/+yF+GuKJMUGnH3EsmFkWRg5hnzlO4B9DbA/RtofPSv6AoCGXtQ6b88j5vazle8TiN2s3noDfZE002z7YYAD2geYhQqj9MxzRrHKvGDJV2icfz0mtZZD3HfcqrXFNc/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ktcavcWi; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ktcavcWi"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fZNNz2PGdzlh1Sv;
	Mon, 16 Mar 2026 18:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773684478; x=1776276479; bh=FHx/pTJ0uZ8eA7b22tyVMk4Y
	NOFSqUR1wciILwwYLdM=; b=ktcavcWix7eOKfulPp3xgQRNiS1vxYX11TB1i6ST
	FY2HEq0VNfqCn2RCrAPTWC52ZPCtN8Q08vWuBbdVahyhJNi4UBLAgS+mCc1/Xs8P
	Zx+Br5eOKS6vq+QT96hYvBSbPKwJ6hxkuY4eCSM8wNfc95n8VoQuUeLY6kwSpv4D
	z7hAUA2o+/5L/NsKLCg+umROoPKzr3cNPGaD79n4PbxirsxQssjRw+0XzDoZbnnp
	QowuIFc3qIQnzpYvRB1wwoOC/LAgMLxbJmASygwyf5X4VTTuh9sfPWhU7MSGTwyf
	+b9lATJZ9eZ/J+BLRQ9ikmQ2Owu4AzIOWdF9wm+KCeOU+g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zNsgaYfdscws; Mon, 16 Mar 2026 18:07:58 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fZNNr0KHRzlh1St;
	Mon, 16 Mar 2026 18:07:55 +0000 (UTC)
Message-ID: <5e2115dd-a0c5-4e5f-9993-02f9a7a5341e@acm.org>
Date: Mon, 16 Mar 2026 11:07:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/12] scsi: ufs: core: Add helpers to pause and resume
 command processing
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-7-can.guo@oss.qualcomm.com>
 <edaac4ff-4d8d-498e-a38d-6474b9d39743@acm.org>
 <8c992c0c-6694-4b30-8e57-3bf12323dd77@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8c992c0c-6694-4b30-8e57-3bf12323dd77@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 3:38 AM, Can Guo wrote:
> I also checked the history of changes to
> ufshcd_clock_scaling_prepare() and ufshcd_clock_scaling_unprepare(),
> I can see multiple issues, e.g., deadlock, were reported and fixed.
This deadlock fix: ba81043753ff ("scsi: ufs: core: Fix devfreq
deadlocks")? My understanding is that the deadlock was related to
calling ufshcd_wb_toggle() synchronously from ufshcd_devfreq_scale().
Such deadlocks can be avoided by converting a synchronous call into
an asynchronous call (queuing a work item). However, I'm not sure that's
an option in the context of clock scaling?

Thanks,

Bart.
