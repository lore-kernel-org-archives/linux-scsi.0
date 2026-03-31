Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88769364051
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 19:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774985390; cv=none; b=FDMscapINOyxqFVFnfWxCTiB3JqhCKlcnqKCz54r9PV4K1rF1M/x6lEKRVZdpDQOfFjoCWZXPV2w4Rzr+n6mZsZslry+lQF5PACUJBJZ9ZPWZ1coTZv/Zxoqz7clBXtGh7Jdqmn6VxkBKvR67x0nMHzKrr6bCGEPdI0zby9Lq10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774985390; c=relaxed/simple;
	bh=pyn6xRHb0Aw63OAbtkwmgw/gM54dhyKRqqFye3UmyPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OIyFGNTMNt+u9zzJWpruoargGT+JF862OZ0mPTO5VLSmIehZhi+YqwIIe/4reixq2bMrGa4gcKq+64vAMTxhSxSHTo8VESlvK+SoXNYvRUifEgqWCERDd4pZZMwJHWvJAB1ufo+N9RlNkKF84hy09x/tyIK9kXjqCt+CXvrKBjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3pGc4yBX; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3pGc4yBX"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fldVN5WWGz1XM6JJ;
	Tue, 31 Mar 2026 19:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1774985381; x=1777577382; bh=pyn6xRHb0Aw63OAbtkwmgw/g
	M54dhyKRqqFye3UmyPI=; b=3pGc4yBX5BKl03qpnvTQHHV60FEcPHjxRX8V8atj
	WTJ6oYMj2X+9xPyk0ZZgCcaOJ+OzIVXmXPRA2geGrom6y8kEli28giQ9lEW8WlyZ
	uUc11EjmH+Nnwfl0EK7pf/qIwNYEhcUUxwmzu4Z7C+Rw9vZgpjZCFXw++PzVoacU
	GfqabKfLPVaAHZyq+lBmIEOZyfxsj031/PpEdul4bQ0FGp2TaO5P/Q+cHLqNzYhY
	RoVc9CsVBYiQ5L26Qootc5pLxYMK1bkgFTzN6TTjsYarMiCctc6j8UA2kFR7D+wq
	S8eHuh7fJlNnrg9WSQnm1FJW76QuoK7htnIO6/3FJSW4ng==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q4wGiNrHRjuu; Tue, 31 Mar 2026 19:29:41 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fldV92YH5z1XM5jn;
	Tue, 31 Mar 2026 19:29:37 +0000 (UTC)
Message-ID: <6f4d9e81-b300-4603-9032-e2604c0b099f@acm.org>
Date: Tue, 31 Mar 2026 12:29:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>,
 "vamshigajjela@google.com" <vamshigajjela@google.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "ping.gao@samsung.com" <ping.gao@samsung.com>,
 "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <20260330183311.1941942-2-bvanassche@acm.org>
 <4685d17dbf09397aef70c2e2b84ee13f1c48d4cd.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4685d17dbf09397aef70c2e2b84ee13f1c48d4cd.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/31/26 2:41 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Does ufshcd_mcq_compl_all_cqes_lock not check whether the CQ
> is empty because there could be cases where the CQ is empty
> but there are still ongoing requests?

Hi Peter,

ufshcd_mcq_compl_all_cqes_lock() doesn't read the CQ head pointer.
Processing completion queue elements without reading the CQ head pointer
first is not safe.

> Since ufshcd_mcq_force_compl_one and ufshcd_mcq_compl_one
> are very similar, would it be possible to merge them into
> one function, with a parameter to handle the force completion
> case?

I think addressing that question falls outside the scope of this patch
series.

Thanks,

Bart.
