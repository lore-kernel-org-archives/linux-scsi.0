Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC3D1F582A
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783826; cv=none; b=nhMtq7QrS9eQU4yQsnr5ig6QIPZsxK0jz6VKFJNeIWtvJDn3onjEBRsULxpmyk7gVMqgsIoswYoULBFURM0wphdStFeXoTl6hIiRcMRFzhO6msiTxgC+bKCO1RLzPc55TtDMNVodLUO+BApPCsbWzuL8wC5QXqlr9GtBc9Id61s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783826; c=relaxed/simple;
	bh=fSwEKfhNgRUAKhWPFp/4IGUBFReLrPqyIu3HGZNoco0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jcgkbBZjFmEahd5nwzvi3dO8HjtcRR5V0UTMDN7alxoUv2la/0fQAtbKJF856s7pnpBOW65UqQclkAk4SD3BTvX/qXbEHFzIKOkAYWeTxjMW3vKM0S3EQZj1VXqmCzxV4Mt+MzMV55ottMX5s2WglQ2pfbjkrWhxqHP3utbgffI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dxQn2bZ9; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dxQn2bZ9"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTkSG3gqrzlmk8S;
	Fri,  4 Apr 2025 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743783821; x=1746375822; bh=a9YL2jW+Pi16H8scQmo6gxDs
	MWhuRW4SgE4rf1Lqb1k=; b=dxQn2bZ9Jei6nBMkJtfV/I0mm2RFcOC7O/8PxBRa
	ov69qMKHXQ+Y2Wq4fPvs97e92My62YQ9+gdqWjyhNMAYH5gQWh+Fi4LESNSWao9j
	5gXmZTlLlfHdzvEWxBPbRUQalIepaENAknlldlfdLRWMx3mWfI8wCGC3pifOwBvA
	aIT52noQp56X9lhWMsTJdCjEGIHUme5o7KI4EoT5ApniYX3l24y52e2hWQFcj3LY
	cZDrioGA+blXn+LRaApTaqY22yuaI+iSqxOEFHvpo2wXZYZRCJGtKYC3goHBzXf6
	6BMaIuPJmExhl0erk6zmT4zJ7cliefoNo8/Vi4AZ6XGMSw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZttrQO2l14Sq; Fri,  4 Apr 2025 16:23:41 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTkS943tkzm0pKF;
	Fri,  4 Apr 2025 16:23:36 +0000 (UTC)
Message-ID: <8caa0037-96fc-43f6-8258-48d6dee5fa47@acm.org>
Date: Fri, 4 Apr 2025 09:23:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/24] scsi: core: Make scsi_cmd_to_rq() accept const
 arguments
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-2-bvanassche@acm.org>
 <bc9d94bf-a1e4-42f2-94f8-1e3ab93d7e05@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bc9d94bf-a1e4-42f2-94f8-1e3ab93d7e05@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/4/25 3:39 AM, John Garry wrote:
> On 03/04/2025 22:17, Bart Van Assche wrote:
>> =C2=A0 /* Variant of blk_mq_rq_from_pdu() that verifies the type of it=
s=20
>> argument. */
>> -static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
>> -{
>> -=C2=A0=C2=A0=C2=A0 return blk_mq_rq_from_pdu(scmd);
>> -}
>> +#define scsi_cmd_to_rq(scmd)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>> +=C2=A0=C2=A0=C2=A0 _Generic(scmd,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 \
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct scsi_cmnd *: =
(const struct request *) \
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bl=
k_mq_rq_from_pdu((void *)scmd),=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 \
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_cmnd *: blk_mq=
_rq_from_pdu((void *)scmd))
>> =C2=A0 /*
>=20
> Out of curiosity, how this that better than this:
>=20
> static inline struct request *scsi_cmd_to_rq(const struct scsi_cmnd *sc=
md)
> {
>  =C2=A0=C2=A0=C2=A0=C2=A0return blk_mq_rq_from_pdu((void *)scmd);
> }

Yikes. With the inline function variant constness can be removed
silently as follows:

     const struct scsi_cmnd *scmd;
     struct request *rq =3D scsi_cmd_to_rq(scmd);

With patch 01/24, the compiler will issue a warning for the above code.

Bart.
