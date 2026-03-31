Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926523A5E8D
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 19:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774985511; cv=none; b=XgUy+wH2zUVGYDhzDVTeO1kLasty4Wpn8X5vOb69bT5z9t701qicHYpNFJPH1jZtqceGbgxHSO5yrFWIRatRVIfvqPZYZxyRGzWGKYFyCi/xeVVZjTF+bZXDn113sceR4+GN+qvrjC37lSReYrtJlYm6X136bHCgWMq5ZsalijM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774985511; c=relaxed/simple;
	bh=tHJkdCtGMw3ntucPCSxvgWrtkmSMKN584nCs7mR5tmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YO5FONKi5nwZuNknIBX8vIlCCLTB+NSXPwQy+DV873yXwqKfO12xBbBHRtJx3iFzp+7OKfQRGUgxfZSC7TfS1Bo0Zjj/oshQaTvWb+Dt7zbLuWQhfEdgConZK6IjaBL9XOIgpIp29ngsqw519FEri/p99MMhiAX1pJ/vPjewjXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N5c5G7LX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N5c5G7LX"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fldXc1KbmzlfwHS;
	Tue, 31 Mar 2026 19:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1774985499; x=1777577500; bh=tHJkdCtGMw3ntucPCSxvgWrt
	kmSMKN584nCs7mR5tmM=; b=N5c5G7LX5/56oydK3ndAvl94mLd8ubYSPPUPnacw
	go3FE4+mrTWXur2RAmNY6qre77Uwfchq0BPyxe7fNOtguo90oljUE0VkyD8ZP6NO
	yQzy5MWn4iGqo8v1pEoIZiKNbe+UIrl9CpLA/yHnfSDQFeXeBiEntbxNfEHMPvL4
	pxnF03W8aAWDIJIGw5akvAAkZp5yH5qgBKPrajyvIctxJ1tw5y0CHhnmebcGPlNV
	wSryA5Q/7DA3SxFkuF7IcHV78Erbarhn0LJo1A/CyGqWY2eoarosRuALUH3QwaXG
	00oPq7jyAJGX83ttbrlwnJ9QZHILjvBO7eERr5CRCcJi2A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FP5amDT456mD; Tue, 31 Mar 2026 19:31:39 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fldXT3fv6zlfwHM;
	Tue, 31 Mar 2026 19:31:37 +0000 (UTC)
Message-ID: <a043946b-14e7-43da-8b68-dc47a08c12ff@acm.org>
Date: Tue, 31 Mar 2026 12:31:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ufs: core: Introduce ufshcd_mcq_poll_cqe_lock_n()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "vamshigajjela@google.com" <vamshigajjela@google.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
 "ping.gao@samsung.com" <ping.gao@samsung.com>,
 "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <20260330183311.1941942-3-bvanassche@acm.org>
 <b76180520d10f2811c072f0944a0864e779e3868.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b76180520d10f2811c072f0944a0864e779e3868.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/31/26 2:43 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2026-03-30 at 11:33 -0700, Bart Van Assche wrote:
>> Introduce a new function for processing completions and that accepts
>> an
>> upper limit for the number of completions to poll. Tell
>> ufshcd_mcq_poll_cqe_lock() to poll at most hwq->max_entries. This is
>> sufficient to poll all pending completions since there are never more
>> than hwq->max_entries - 1 completions on a completion queue. This
>> patch
>> prepares for reducing the interrupt latency.
>=20
> Could it be more than (hwq->max_entries - 1) if the host keeps
> sending requests to the same hardware queue from different CPU cores?

No, because the completion queue head is read before processing
completion queue entries starts. No matter how many completions are
pushed onto the completion queue while ufshcd_mcq_poll_cqe_lock() is
in progress, it won't process more than (hwq->max_entries - 1) because
that's the maximum difference between the tail and the head pointers.

Thanks,

Bart.
