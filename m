Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C5417BB0C
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 22:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511499; cv=none; b=K4ZJ9YP7qaaV56rMAz0IFzWD3cCHX1LG+RPtLdYGljHn1Okfz4rzZCO1AnPNrVvervfxz+kG5oP5OwcquXPvRQgR/P1ZLr8uON84f3+r7S1tg1ASb6pA/+GwoP/pgQDUs9pMhnrnQFt8fE5ChvR6Vm1KTIAhAoCSxJ//WYPXQjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511499; c=relaxed/simple;
	bh=nh5XKz/qeTisrTzJiE4BDLkLOMn3WETwS/gzTd65zDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrT7EOsj1TGx4ywbjHTwFzvOiwXHbAvAnJjHpnIdJRPblkiGlKtqC0n+T9vKyKcIuEktBHUAJEL54+pkP8+ASbpl4MutWmm0R3fUXzJuQbhSUrBWZrUjEh/9zLcIh9Dr0ZGrsGQdpvH4cp1VycLGMPiCOIYi9mo2dF78qIj/1RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QpfyxOF4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QpfyxOF4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XP6Pj0JpJz6ClSqw;
	Wed,  9 Oct 2024 22:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728511493; x=1731103494; bh=nh5XKz/qeTisrTzJiE4BDLkL
	OMn3WETwS/gzTd65zDE=; b=QpfyxOF4P8dVsdvigeplOgir3t1KKcrNAlClAymQ
	skXA6pyMY+uWDKAnO1p8H3gGF5pZzgucEHSFzNBJk6zcm6IWVvXOsYUzUI6DaTi+
	4ENCaDOZrEa2Gk9LdUNWmM+ITP+7icDJphboQsSxirOJLWFySaXJjeerReJTz5E7
	aJwXaYTyGUTPZbiC3jEJxalruKfAkVosnyQXUeBBvxOMY6CTE2NtF/G3Q0u/CjVZ
	8Qo39SK0XVoRF96o98hfs8YTeYwQZgriXrDoD45RfQFduQ9NTL7rFNhoVGAJjp/d
	ocXnxK0YhMrPNdBvi/xDokw0LJ7enBwuhjvSz1+wXAlVtw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k8XE0UyQy8Kc; Wed,  9 Oct 2024 22:04:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XP6Pb6spcz6ClY9y;
	Wed,  9 Oct 2024 22:04:51 +0000 (UTC)
Message-ID: <df70ca7d-b836-4f3d-98ac-24f665fb8616@acm.org>
Date: Wed, 9 Oct 2024 15:04:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/10] scsi: ufs: core: Expand the
 ufshcd_device_init(hba, true) call
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
References: <20240910215139.3352387-1-bvanassche@acm.org>
 <20240910215139.3352387-8-bvanassche@acm.org>
 <bc1155d5-2d25-6573-e99c-341677879a9d@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bc1155d5-2d25-6573-e99c-341677879a9d@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/12/24 10:47 PM, Bao D. Nguyen wrote:
> On 9/10/2024 2:50 PM, Bart Van Assche wrote:
>> +=C2=A0=C2=A0=C2=A0 ufshcd_process_device_init_result(hba, hba->device=
_init_start, err);
>=20
> I have similar comment as in previous patch #6. This patch probably=20
> changed the print. In the original code, it prints the time spent in=20
> probe_hba(), but here it prints some part of the time spent in=20
> ufshcd_init(). There will be some trace prints during init, but the dat=
a=20
> it prints would have inconsistent meaning.

I will see what I can do about this.

Thanks,

Bart.

