Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A5248BD52
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779123266; cv=none; b=eUMpMk7ZLcEVPAUCVMjsR2mK2MnqAHvNeyISj6mtW51F2PRbZIgdZ0e+alUGKqlJDiOV4xy0qSdFoxizsFU7P1Z1CddlvbQK+hdYrnKozXBLuImSO2LwG0z+2A3nic4x/WektV1XqTk987ijBe7yyZ4iwQk8WUuEH42OMVm0eD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779123266; c=relaxed/simple;
	bh=kKSWWmiFMOGK7g4Y5dkmbJF+YVc/HIhgy0St/ZUI0zo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BNSY2qJNqY1SLTREqTdA0N295VrpnMPjECRpujEIBN7263bqDyiAYpIZfn/WCKA/qKGx+VyPNkvPn6KebVJ2OPsdV1zhSj7EACasRA1CZSpyP9O9jur73FPAONmwqg0jCyLe7kzXv7x9DBr9TcczabTG2IhtZIjcOESZSGgk/Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=m5kuR4oK; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="m5kuR4oK"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gK3mp01W0zlfl8H;
	Mon, 18 May 2026 16:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779123255; x=1781715256; bh=kKSWWmiFMOGK7g4Y5dkmbJF+
	YVc/HIhgy0St/ZUI0zo=; b=m5kuR4oKWmOAi2xYjFSsWGR0hMoWDQCEk4zuhlaz
	R6dp2ryoY+etm0N4lGDFHhTt5lqIv9wlq5ZHw1SZkjOs29S8ofDW+6CdU001w9C8
	lekUOywyVHr/21IY4+R/vSfjlf/fHHV0v2rwOL0sZeptgr1zUKG9SNFYTCf4g56o
	ax7qqjjb8AtEkY/dHc3grmYxeAf+Uw5sG2qoy+pxmodfR5+kfoFezavKuAHIIWay
	C1dubgjpDGidk53kwWUrd4nJv1Pfd6NJ+ObiwSppZ2+kWVOnhhsKVJiXYIPMZqVe
	bJtstZVRQUpNE20FFmc10EMnU9rt8zkmL/e0NZppBXXn2Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pJORPpQ2_nGC; Mon, 18 May 2026 16:54:15 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gK3mk3zNxzlh1VG;
	Mon, 18 May 2026 16:54:14 +0000 (UTC)
Message-ID: <e182c2c5-30db-4bdb-a784-19dd9d0a89f7@acm.org>
Date: Mon, 18 May 2026 09:54:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "quic_asutoshd@guicinc.com" <quic_asutoshd@guicinc.com>
References: <20260514082906.58593-1-peter.wang@mediatek.com>
 <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
 <3d359319927f808dffa0aef52b03c437f803335e.camel@mediatek.com>
 <2ed721de-0410-413a-bda1-99b5313b072d@acm.org>
 <bcbfd7a71f698f6a3dcf627d3ea76c79b9897ccf.camel@mediatek.com>
 <064b4c51-c3e8-4380-b1a2-ce996078efe8@acm.org>
 <e02140af260edd8f0391889f7c925378dc79bf10.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e02140af260edd8f0391889f7c925378dc79bf10.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/18/26 2:26 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Since MediaTek does
> not use the polling queue, CQEs are only processed in the ISR.
> So, if I just check that it=E2=80=99s not a polling queue, using it
> this way should avoid the overwrite issue, correct?
If ufshcd_mcq_poll_cqe_lock() is only called from interrupt context then
there can't be any contention on hwq->cq_lock and the patch at the start
of this thread is not necessary, isn't it?

> Yes, I also plan to move the ISR to a threaded ISR.

Moving the ufshcd_mcq_poll_cqe_lock() call from interrupt context to a=20
kernel thread will negatively affect UFS command completion latency for
both reads and writes. Are you sure that the higher latency for reads is
acceptable?

> May I ask if there is a planned schedule for applying this
> patch after further fine-tuning?

There is no schedule yet. The discussion about this patch with the F2FS
maintainers has just started. Anyway, because of the upstream-first
policy for the Android kernel, any F2FS patch will be posted on the
F2FS development mailing list before it gets integrated in the upstream
kernel and in the Android kernel.

Thanks,

Bart.
