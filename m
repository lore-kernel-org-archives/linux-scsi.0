Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9BF26E165
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768582381; cv=none; b=jr5H4/SIUdT0eeG6CIpY6JixGjm+HSRhdOT5dUjFfE4aZx7rxhxoQwGfik4VWkscWkEQh8Mmp5ztqEMdZPCBA695DTTxyPRiI4avt0ORLlj3bfC0IDet+6RnJd1uqMUwltX+3I0wiC9mDEox08zK0FETZOu7vSMJax+hK4CVz74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768582381; c=relaxed/simple;
	bh=55viOttWmOK4Nl8bK7PFOz7+xuusCZc0GivuTaojjIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfTlV/b+yQkwrZ20qJIXlOCY3eC5aCF/thEaf/XxWXzYnp5j40RhWE2rHvalra9NODxh3M6oSCGI+UQIx3LtSkr6HF0yOIlYWtZ4xfD+sqPztRgzUCP3vjvDfMK4sw9K/Z7ARIKvJEhmDZF5uJVzAsLtEQx3qDi6c7BJalkSQWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=21wS6+Zn; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="21wS6+Zn"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dt5Wb1JD2z1XMG4p;
	Fri, 16 Jan 2026 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768582377; x=1771174378; bh=55viOttWmOK4Nl8bK7PFOz7+
	xuusCZc0GivuTaojjIA=; b=21wS6+ZnEHMxizVa1Wq5ViLCzFpC+vgJFbEIDCTH
	ZLh1sa5dVKSei2s7lDrDG+/YSb3hEqzDB6rd/QZvAeIibDJgwZiL6eN/PPyW/bbb
	aNHKkfV9uMjlqEAtQCJ5eOx7MV+bDHMinggLA7tN4dR+RY/1UGCZK/gzo8Bp035R
	iDbf0UeWrFcb6Bh26W60z8oovTjIvMSEOb8L3ZOjXNg7NvzaMtIdP7tz5g2QUtsM
	p2vulrDjHReP7dq4RJkYolavsurmRXL/uz2UhVoBAPobnvfl3kddTPxPXazFzdMY
	mMGonwA3q+wbamK1fbwJ4+fcC++XuqFgyFip3eF4ITlxjw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OfPhbOtMvMsO; Fri, 16 Jan 2026 16:52:57 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dt5WW3PyPz1XMG4m;
	Fri, 16 Jan 2026 16:52:55 +0000 (UTC)
Message-ID: <b4d3246f-0c48-43cc-9897-804da65ea546@acm.org>
Date: Fri, 16 Jan 2026 08:52:54 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] scsi: megaraid: Return SCSI_MLQUEUE_HOST_BUSY
 instead of 1
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 megaraidlinux.pdl@broadcom.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260115210357.2501991-1-bvanassche@acm.org>
 <20260115210357.2501991-3-bvanassche@acm.org>
 <4247de59-248f-4e77-b3cb-7bb0ee712761@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4247de59-248f-4e77-b3cb-7bb0ee712761@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 1/16/26 4:39 AM, John Garry wrote:
> On 15/01/2026 21:03, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
>> index a00622c0c526..54ed0ba3f48a 100644
>> --- a/drivers/scsi/megaraid.c
>> +++ b/drivers/scsi/megaraid.c
>> @@ -640,7 +640,7 @@ mega_build_cmd(adapter_t *adapter, struct=20
>> scsi_cmnd *cmd, int *busy)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if(!(scb =3D mega_allocate_scb(adapter, cmd))) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *busy =3D 1;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *busy =3D SCSI_MLQUEUE_HOST_BUSY;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 }
>> @@ -688,7 +688,7 @@ mega_build_cmd(adapter_t *adapter, struct=20
>> scsi_cmnd *cmd, int *busy)
>=20
> should @busy still be a pointer to an int?

The next patch changes it into a pointer to 'enum scsi_qc_status`. Do
you perhaps want me to move that change into this patch?

Thanks,

Bart.
