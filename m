Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3593D646E
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786141633; cv=none; b=ZQp4Qo/r0ebvHMGDnA6aRHeoUJRYWaS+eD+OFFVBO2Ogmsg7MnrNXbOzQxb9g15XuRya5x6elFfESH4TqxLPyrz3h/JZKHAIob0cHfTyhE0Bq0tvRN3B46gnVWQSgZHz8khJlfndG1FvkiJzXW7Iglp4amYImi6aBntlxIuAvyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786141633; c=relaxed/simple;
	bh=iVXAfp5eHGcKxCHL1xIwI1+0DPkDzuWRIXEprN+hPn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NA7ezZ4NsvUfZ8oGLopySCEyGU5NewrPSjZ0OtB/dX12myb6Hz87qm5mpDD2uQyOHvxsxcLH+YachXviDuMwruoaj6LcREvxEfWzYgPF5OvfEkKrrqXoh+/W8sLnBnpNkzQ9ua9ZREb4yCOOjwuv6QBy48iu5ITN0zyygAb0pQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Vv5ktyKw; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Vv5ktyKw"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGzKW0wThzlfvq0;
	Fri,  7 Aug 2026 22:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786141623; x=1788733624; bh=iVXAfp5eHGcKxCHL1xIwI1+0
	DPkDzuWRIXEprN+hPn8=; b=Vv5ktyKwuorKIxDRqQ6umDsMXTt9CIYHcWDYPduy
	KoBqAHyIFOWFgEo948d3/jkG/Fs1VDuYBQeysFzMjwXIImP62oiktPJLtP19Ej6T
	scEhd1CT1b+yVPttKbLKY3Y3w1oSoGer6Rovl53M6SDMQzoXnvQ4foASecnh8NRY
	YOI0l94H54D4W9lv42f+RTP8IFgez3HIirpTy3NENvwSAp89ZP2zbQC7b/cbk+s1
	SEWTugXmQMOr/CycqcCu9eSx1vXIpoSt0YVijMe4ZKzLsTqPqdnTPUUKgk1YQ4k9
	8pfzgMkugo468n9UFZ1jZkd/wtvYOHJIxfCerqXfrGy71Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PG65A5Z_FTj8; Fri,  7 Aug 2026 22:27:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzKH15wlzlfvpN;
	Fri,  7 Aug 2026 22:26:58 +0000 (UTC)
Message-ID: <a1cf63ca-4f75-4dc8-8e8a-58033a0cd63f@acm.org>
Date: Fri, 7 Aug 2026 15:26:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] scsi: core: Protect host state changes with the
 host lock
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
 Jianzhou Zhao <luckd0g@163.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>, Nilesh Javali
 <njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com
References: <cover.1785965531.git.bvanassche@acm.org>
 <d5b40794ca80ed83888a83847c293349e7f1de43.1785965531.git.bvanassche@acm.org>
 <6d4a31c0-308d-4f4e-9708-11a559137ee3@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6d4a31c0-308d-4f4e-9708-11a559137ee3@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/6/26 2:13 AM, John Garry wrote:
> On 05/08/2026 22:36, Bart Van Assche wrote:
>> +static inline enum scsi_host_state scsi_get_host_state(struct=20
>> Scsi_Host *shost)
>> +{
>> +=C2=A0=C2=A0=C2=A0 return context_unsafe(READ_ONCE(shost->shost_state=
));
>=20
> I am wondering if it may be better to protect reading this with the=20
> spinlock as well. We could lose the READ_ONCE and WRITE_ONCE. And we=20
> would be more symmetrical with the set function.
>=20
> I really don't feel strongly about this, though.

I prefer lockless access from scsi_get_host_state() because this
function is called from the hot path. Using locking inside this
function would cause lock contention on the host lock in the hot path.

Thanks,

Bart.
