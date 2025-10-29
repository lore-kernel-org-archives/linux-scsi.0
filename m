Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECA728688C
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761753039; cv=none; b=ZQT/1ylqM2NhNgrlkZPxEruf47x4zvspgePVeD+OhRkmuX+v8a++o3T0lfRbyB7wkYIUY2v3qZpPHgPW2Yci+bkxRQ7Ew91pGMjG/7rLMfEe2RCRaSdOJjxEGFp/1K5mFRYFb2ak4+647S+OZxhorgqiRdnlUG/l6ElNVVmcqJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761753039; c=relaxed/simple;
	bh=mkxGi0nj7sNcrFGlZu5g40N8Ns6cQpIsu0cQNFykQb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cmCfawIBeUKbPVSTEIsIwWUKfBU+CGCBPwotXUs6tMGD2tGPzgJANfy5028wUbnEobkHc6C5tp3hQ3lXoVwCJgGy20Om8Yj0elzGVblb+5sNAAPZJON91wIxhdT0ZSbCRwBdzvYlu5PkJsh6KZl7rli24rkgLGuB+h48GXl5+XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RVYc+rnN; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RVYc+rnN"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cxWt462ybzm0GSq;
	Wed, 29 Oct 2025 15:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761753031; x=1764345032; bh=mkxGi0nj7sNcrFGlZu5g40N8
	Ns6cQpIsu0cQNFykQb0=; b=RVYc+rnNjavOWFTG6t1mfw5lDgOT1tn7VtTl37Gj
	pIynjzlwOW7nJsr73T8xqK06ySChWimhWhAxF01XD3i/c1u7ZwjpzxYyyJPunjBB
	GN2RYUPscUoqx3Gnu8xsGg1ibtF1s8QQfNxtUmzHnwx9s2zCV7jpDiT7044t/BPH
	hzyl6i5RMwa/+pPiHYCGQrX+GTMBkEBh7DjWGRM9UBeCS7k9X/yNCgH6KIxgq1SW
	ItA9r7omj4iuY0EMsGW9PQSwipTpemtqFZOqte7nUMOglyhXetbu23eXYtXcmV+T
	n915wW4PEhtNEafaZYmrLQ2QZhW7onhZ8HjT/nzqhg2DqA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kmBye2MuQ9EC; Wed, 29 Oct 2025 15:50:31 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cxWsr0rHGzlvm7r;
	Wed, 29 Oct 2025 15:50:23 +0000 (UTC)
Message-ID: <1674d018-9243-4fd5-83d1-26783165e3e6@acm.org>
Date: Wed, 29 Oct 2025 08:50:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "ping.gao@samsung.com" <ping.gao@samsung.com>,
 "mani@kernel.org" <mani@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20251027154437.2394817-1-bvanassche@acm.org>
 <dae8ac46abd89f4d48e649cee0a6b301504bcdac.camel@mediatek.com>
 <37a7d14c-5e6f-4fb4-a850-af3ca322ae99@acm.org>
 <7d955a693d11424d527fcdaf4f05ffd792e1edfa.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7d955a693d11424d527fcdaf4f05ffd792e1edfa.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/29/25 12:18 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> The probability is indeed quite low, but it can still happen,
> especially when the timeout is set low. For example, the dev
> command only has 1.5 seconds. Some device dev commands may be
> delayed by normal read/write commands and eventually reach
> this timeout.

As mentioned before, whether or not a command completion is still in
the completion queue and has not yet reached the host falls outside the
scope of ufshcd_mcq_sqe_search(). That function should search one
specific submission queue and should not search the completion queues.

> By the way,
> ufshcd_mcq_sqe_search will return true if UFSHCD_QUIRK_MCQ_BROKEN_RTC.
> Therefore, this code:
>=20
> +if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
> +return ufshcd_mcq_sqe_search(hba, hwq, task_tag) ? -
> ETIMEDOUT :
> +0;
> +
>=20
> should be equivalent to:
>=20
> -if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
> -return -ETIMEDOUT;
> -
>=20
> am I right?

No. ufshcd_mcq_sqe_search() is typically called after a timeout has
occurred. After a timeout has occurred it is very likely that a command
is no longer present in the submission queue it was submitted to. Hence,
the typical case is that ufshcd_mcq_sqe_search() will not find the
command and hence that my patch will change the return value from
-ETIMEDOUT into 0.

Thanks,

Bart.
