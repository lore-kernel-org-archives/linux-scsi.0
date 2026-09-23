Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878FC387375;
	Wed, 23 Sep 2026 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182278; cv=none; b=UVfZ6Slbhj54xWQg0pr4jWMPw64oHsa8775Pwdxf4Xh0IfeEXeurxevQGj8wAYVpYW/qzxpfhkdvVRPRuseEN+rNpVxj8COgd8MCrj9SSwE+fS9K9jMi/nzwig13mPl+JPVwm1yhL6JDmO4kerCV1U64gfi7zE9NvNcJAz33KUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182278; c=relaxed/simple;
	bh=yHcSAKYnyFanmMA9+XOMg2xoOgSVx86kSYFB+wuWVYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bGupv0I4Z51r1sf+iTjZLVrRFN7BsohUYPQfC/zwkS/+PeoviFhJ/G7mZSKufGnJ7gsiJ969iX9oemnGRRit9XVCRWlppYyPQK0CVgkjNkJazJN4lWnH6t0ibO71pHDBLJNwFydb47sCRMYuPGAKokXa7uP83spsRXQ6h1NO1pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jYKywdZH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jYKywdZH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hqjf64Xctz1XM5kW;
	Wed, 23 Sep 2026 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790182262; x=1792774263; bh=q3dYgVcqByXC1PtTXHSMRdvS
	TIQ5xlCtyu1cQTeyv64=; b=jYKywdZH3L+dM3USoss/JWzSBoyZY7/QQRCLi/2X
	QdLhrzksP6xCNokDerzk3w4ZLRaXTjPoRcsceeB741aJ4Z5JZgFCJk8VR4zIsJrn
	XSQhDM5oXAfmWSBJPhW7VMRb8K9o+mN58ROGPH8yGzHIXzVQ+HHUIvhPJqp82T3u
	YgREy1qal11nEpRgg5Tyn/vtHBkcmvlOPi7okGMLb4ulOMrt/kLuMA0zwoysvyfF
	vmo2pXJLkb6e3isa9TRJNDGnDJ4nVPhzqMyxulPKBMtPVq1r6GwgyyO/Xtkymcyx
	CKwSmPCUSQL3qr4pYzqEQnv6d6w7coTT3A+42T6gPKEHbg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H_Yz6FrMipm4; Wed, 23 Sep 2026 16:51:02 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hqjdv0Vp7z1XM4Sx;
	Wed, 23 Sep 2026 16:50:58 +0000 (UTC)
Message-ID: <edb755c1-5d45-4b38-abc6-02450b53a242@acm.org>
Date: Wed, 23 Sep 2026 09:50:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
To: Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
 linux-kernel@vger.kernel.org
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
 <20260918143809.3034592-1-stanleyjhu@google.com>
 <20260918143809.3034592-3-stanleyjhu@google.com>
 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
 <20260920135014.3528082-1-stanleyjhu@google.com>
 <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
 <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
 <df31eb82-7211-415a-9ec1-53ecbc3e39b0@acm.org>
 <f116f82d28f7af4cfca76adf5cff6093fdf393a2.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f116f82d28f7af4cfca76adf5cff6093fdf393a2.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/26 11:09 PM, Peter Wang wrote:
> But whether the subsequent re-queue (DID_REQUEUE) violates, I
> haven't seen any prohibition?
While this is not written down explicitly anywhere as far as I
know, requeuing from inside the host error handler is not allowed
at all.
> Because currently the UFS error handler (ufshcd_err_handler)
> directly re-queues (By set DID_REQUEUE) the unfinish command,
> and err handler might be triggered in many places, for example,
> like UIC errors, directly resetting and re-queueing should be
> reasonable and can be handled quickly.

Have you noticed the following code in drivers/scsi/scsi_error.c?

	scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);

> If it cannot directly re-queue, then ufshcd_eh_host_reset_handler
> would need another similar function that does not handle re-queueing.
> But this looks unnecessary, direct re-queuing seems safe?

Requeuing from the .eh_host_reset_handler() is not safe at all. It may
trigger list corruption as follows:
1. The .eh_host_reset_handler() callback sets scmd->result to
    DID_REQUEUE << 16 and calls scsi_done(scmd). This causes
    blk_mq_requeue_request() to insert the SCSI command into
    &q->requeue_list. The SCSI command stays there because the request
    queue is not run immediately because the SCSI host is in the state
    SHOST_RECOVERY.
2. The .eh_host_reset_handler() callback finishes and returns SUCCESS.
3. The SCSI EH thread in scsi_eh_host_reset() sees that the reset
    succeeded and moves cmd to done_q.
4. The SCSI EH thread executes scsi_eh_flush_done_q(done_q).
5. scsi_eh_flush_done_q() invokes
    scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY) for the same scmd
    that is already present on the request queue requeue list.
6. scsi_queue_insert() calls __scsi_queue_insert(), which invokes
    blk_mq_requeue_request() a second time. This causes list corruption.
    Code that examines the corrupted requeue list will either crash or
    trigger an infinite loop.

Bart.
