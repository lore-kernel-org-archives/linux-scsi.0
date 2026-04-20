Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF7C3A9D8E
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776708178; cv=none; b=fZm4Em4MtO0BXb9sNLOv7nt8EvScxK7755b7IKHhNnfdAoJCoj6KuiuEAIcitWUwFpY4fOje0u/F3Jz1BGZuYGt87BfbgQuyxhwXOKE4q/mqY74wylSnz+x9eqtMfwbVyP1K5I5uTjuo1Nv48Fnb2tyQ0i59M4q23JsvP7X1WNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776708178; c=relaxed/simple;
	bh=5oJWDqDdZn6vkit7ylZETr0lJ9pcxl8JtZ0G9Ta8yPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q2BW1xNYvvR6deUwDBbxNOPXMr8mvHewl/NRrUJKxmxhsi7aBEiYYs2q/pkxl5/iW6/wWCE0xBkqR+smJ5LtMJmrK42kmdccrG5yJeHf2onwLSeDw/H+Uumvv3CRV4XLA5Qu2Rv3x1y9ZTCVqXfcSIjsR4p3dB5Jyw3HxdJOk0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WWKhjsoE; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WWKhjsoE"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fztcv6T8xz1XM6JX;
	Mon, 20 Apr 2026 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776708168; x=1779300169; bh=5oJWDqDdZn6vkit7ylZETr0l
	J9pcxl8JtZ0G9Ta8yPc=; b=WWKhjsoEUY1tUkljxNr3cmhPl9vFFPbbVt0RXhpB
	RPI01gGBfmprSduJgUl/KcVbvQvS61gEq2Mm6Awqd8IJxUX0Plh7//pxcvJ60XX4
	fL1U1JtA586EvujpFS/K+lTgXAyaIZ5HdInuXftWDZMI8JaILhzxKq1wp/78UygQ
	LEt9tbZIgEj8L+fGWOFrs1qOa5pVQlHg5MJAz7X9TmTPiHL3mZn30FLLowsXFNiR
	sLntOXmR/xXTOTWC8kNZUNgdLg3clBV9zMuctV8xQ4Zg2e0gZsuq/CohDsO9TmkV
	9jqVYwSTu/aUIXrBjKB2hom1Ua/0XyDw3oPm9EcduDSPzQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IzDzOvtuNMUb; Mon, 20 Apr 2026 18:02:48 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fztch72Gxz1XM6JR;
	Mon, 20 Apr 2026 18:02:44 +0000 (UTC)
Message-ID: <b59beef1-ed3a-4eb4-a1bf-c45e5be2764b@acm.org>
Date: Mon, 20 Apr 2026 11:02:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: qedi: Fix command overqueueing
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
 stefanha@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-3-michael.christie@oracle.com>
 <197fd58e-2cc7-4ed8-a662-52120f39c5e2@acm.org>
 <b3234b38-7eba-4628-a7df-24cd7460df14@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b3234b38-7eba-4628-a7df-24cd7460df14@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/20/26 10:47 AM, Mike Christie wrote:
> On 4/20/26 11:45 AM, Bart Van Assche wrote:
>> On 4/17/26 3:57 PM, Mike Christie wrote:
>>> qedi supports a total of can_queue commands over all queues so set
>>> host_tagset when multiple queues are used.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>> =C2=A0 drivers/scsi/qedi/qedi_main.c | 2 ++
>>> =C2=A0 1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/=20
>>> qedi_main.c
>>> index 227ff7bd1bdc..0be0a9f30ee2 100644
>>> --- a/drivers/scsi/qedi/qedi_main.c
>>> +++ b/drivers/scsi/qedi/qedi_main.c
>>> @@ -657,6 +657,8 @@ static struct qedi_ctx *qedi_host_alloc(struct=20
>>> pci_dev *pdev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qedi->max_sqes =3D QEDI_SQ_SIZE;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shost->nr_hw_queues =3D MIN_NUM_CPUS_M=
SIX(qedi);
>>> +=C2=A0=C2=A0=C2=A0 if (shost->nr_hw_queues > 1)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shost->host_tagset =3D 1;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci_set_drvdata(pdev, qedi);
>>
>> Why "if (shost->nr_hw_queues > 1)"? It is safe to set host_tagset even
>> if shost->nr_hw_queues =3D=3D 1. See e.g. "[PATCH] ufs: core: Use a ho=
st-
>> wide tagset in SDB mode" (https://lore.kernel.org/linux-=20
>> scsi/20260116180800.3085233-1-bvanassche@acm.org/).
>>
> But you can't do batching with host_tagset right?

Batching? Does this refer to struct io_comp_batch or perhaps to another
batching feature?

Thanks,

Bart.
