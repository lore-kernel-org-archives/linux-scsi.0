Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D4E329518
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 23:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758152583; cv=none; b=PaIbYdhPWcAz6B9HYq96pxKK7so/vc1n6T/pv+0jghroEE5kPLr/P03tPC+eCSMQAkPqWj0jGZRDO5PZxxIGzltkODrK0K429QUJEY95BDqOsYkMx+v46UNYCNcmtknSNAXmgg6UlAyfloAYd/9ynTYPx/nnGKZYgZ31iYpv9Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758152583; c=relaxed/simple;
	bh=d50mRwsZ/48ujNope5EW/WjYNTWcbiYasq72G43xOzA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=nbH/0X45BhGM5NXvuDlpRKOU4ByNHcaopCmByoWsqOzvOndNGYfmzT5uoEyi0YVjzc9Rm5eQrVGgME2OisGeceODNWZrvgHn5q1j8IpOKcbRJ35CtnoiwpCH7u+63LuSOcanoSrHR0p/0inE3UCJDRDweE6v2NtFJBxxyf0VoS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kT7MZN7B; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kT7MZN7B"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cRwLQ3qsTzlfnBh;
	Wed, 17 Sep 2025 23:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758152573; x=1760744574; bh=ilvKdHpodW9m8FyyjFc9HO4Y
	XHxqPB1H34e82b1g6xM=; b=kT7MZN7Bs4I0pc1aIULf2y+caG0nrmbzDd216Hwx
	DPFd2aVD/DBo8wldmws4fx/ccMHThzUmRdQcztfwXBKusJNcijvFsUKBVMuucYgd
	+dtEwykFHHwMDVrljVm7o0Y3rLXZOMyAwXavtXdyyyROQ/DCU+r1twKETdwWVDg/
	lsGCnaQK29ONIGxC/GKWnPQTt4h2umtzNSZLbq/+qDzmmo6apnoEmxHtV/ociGoI
	NkWRpEF2ikovGXNPN7hKyS3VyHoMS9bV/372uoMCIpR6qltrDchIK7nPRxYljAUJ
	kAt0FWVpSVyMgW1yxzoNVr6YP9QThgH07JSzZoAl4vTIgQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id krd79wVMlVLg; Wed, 17 Sep 2025 23:42:53 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cRwLH09fyzlmm8L;
	Wed, 17 Sep 2025 23:42:46 +0000 (UTC)
Message-ID: <e7ebba4d-d09b-4823-8830-6aeb6286bcb5@acm.org>
Date: Wed, 17 Sep 2025 16:42:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
From: Bart Van Assche <bvanassche@acm.org>
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
 <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
 <2c10d952-8b21-4432-9a87-a4c82745f2d7@acm.org>
 <871a7b50-8920-4808-8537-e188e5ad91ab@oracle.com>
 <d175ed35-874f-40f7-bd34-15dc13d58b5b@acm.org>
Content-Language: en-US
In-Reply-To: <d175ed35-874f-40f7-bd34-15dc13d58b5b@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/17/25 11:21 AM, Bart Van Assche wrote:
> On 9/17/25 6:08 AM, John Garry wrote:
>> I know that it is not ideal, but could we use scsi_execute_cmd()=20
>> @buffer arg for both in and out data?
>=20
> The scsi_execute_cmd() buffer and bufflen arguments are passed to
> blk_rq_map_kern(). blk_rq_map_kern() shouldn't be called in this case
> because:
> - Calling blk_rq_map_kern() is only necessary for data that will be
>  =C2=A0 transferred with DMA. The 'args' data won't be transferred by D=
MA.
> - The 'args' data structure is typically allocated on the stack.
>  =C2=A0 blk_rq_map_kern() copies data that has been allocated on the st=
ack.

There is another concern: passing the scsi_exec_args pointer via the
scsi_execute_cmd() @buffer argument makes it impossible to pass both a
scsi_exec_args pointer and a data buffer to scsi_execute_cmd(). This
functionality is not required by this patch series but may be required
by other drivers than the UFS driver.

Thanks,

Bart.
