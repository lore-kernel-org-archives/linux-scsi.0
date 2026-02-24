Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578733A9002
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951743; cv=none; b=fwSaJYidhZxD+97wMBShKI6HprsuBWPYgYEZTFw8x/9lUX02LEAVpaTLynuR6eDsyMUMuc7+37JxEKQBS1bhBIXNs5rS7UVVZSk+fJBma3GpsIeAXYDVHcaKIwK1ieW7xm/y7GPqzO9OI+kRNov2T1q8XpLTBrTn72ChbJ2HIog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951743; c=relaxed/simple;
	bh=EExyUxWYg07VD+FMtbZqoIMHqeeFR0efaC4++c5uyMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r3FZW1X1F6sQvkSFeSNWluR4A1WttqzCDmKUiSl5DBFgk0TXAS4pXcm03AU7Y6Okihbse2rMTsf3cTOOVGcaM21LFy/tRzJ5NNzaeq2Pc2pQj/2VNbS8tLLJ7x0nPfit29bVfiTyxTbm79wDF73XnXdBmi1D+BdUaKE1DjNmlbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qBxE8ENT; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qBxE8ENT"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fL3b16G4sz1XM6JH;
	Tue, 24 Feb 2026 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771951740; x=1774543741; bh=XalST2aF8KFTi0PVkHHN8BFR
	Ii0fE5s/1PbfuL/uOZY=; b=qBxE8ENTIOpj/w4jV//jJhXpbdxJx0rJD44PgWzK
	TH0+veOghWtUkKHbe2ZuvTAN/5eJ1Ouwt/ep/hOoHHxLyVo9eVVVZg8PHIkvyNmW
	/fG4x0WxUBtREo4ki3yl5rjrrlXH5ISFcipWseCYlvNOr5GxUHiJYU6Le2CNBbqH
	LF6gJfqEutGtaP05d8wAX8S5zuRTnePJAdXowr4FHvzjRWec2QzYYPGqOjyvIZAW
	SLgK0fs2hwRz7Fx7n/vw8Dqfvw8viepiX5cdqQMjAlw42e9wRgyUgZG63ADqsEqs
	XsK22yCNPZGgVErTefzCIclHy9EpNq4SdolKTiMjyvkd6Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nWkhkSnBG_o3; Tue, 24 Feb 2026 16:49:00 +0000 (UTC)
Received: from [172.20.150.38] (unknown [4.28.11.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fL3Zz1FXGz1XM6J7;
	Tue, 24 Feb 2026 16:48:58 +0000 (UTC)
Message-ID: <72757f9f-20de-4fb8-b5eb-507dbcdbe22a@acm.org>
Date: Tue, 24 Feb 2026 08:48:58 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Fix possible NULL pointer dereference in
 ufshcd_add_command_trace()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
References: <20260223065657.2432447-1-peter.wang@mediatek.com>
 <5017b907-16de-4d7f-a7c6-dbc504ffd1eb@acm.org>
 <399765bade9b7adcca89a94313e71635d1336172.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <399765bade9b7adcca89a94313e71635d1336172.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2/23/26 9:29 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Therefore, there is no need to assign hwq_id separately.

Hi Peter,

That's not what I proposed. When ignoring the NULL test, this is what
the current ufshcd_add_command_trace() implementation does:

	hwq_id =3D hba->uhq[READ_ONCE(req->mq_hctx)->queue_num].id;

That's more complicated than necessary. This should be sufficient
(again ignoring the NULL test):

	hwq_id =3D READ_ONCE(req->mq_hctx)->queue_num;

Anyway, since the proposed change probably only results in a small
performance improvement, let's proceed with the current patch.

Bart.
