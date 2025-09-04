Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5734215DBC1
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 19:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757013935; cv=none; b=ZV8OoBGyhNb6TVnd7yH/+YzaMD/DWnHeTS6Kl22QMnSgom5hgd8m9oHuaKudiimcTCAXyQqq6uCbJMZmV3f3tBkHI+OK2G8ow5aXs/fa3IfTUmExBrLONO14EfCltfKBPui7Ci8/QKyRxt4+DJAF1gEIssRWwYHcVN8s3mHlRX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757013935; c=relaxed/simple;
	bh=UFCR1Mcto6jEewKwUt7I3C917kzOzULOWzsP0uOMMp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V72PhaSQzKsbxhaYh1dbj7csEBTHY4RPGH7YCKpUEnAvleuyGt3p+wpmc2w59HTt2WJLf/8XGEztDiMNAc39/psMXXZlhfN2/JKNNlyvn9SLlJSCqx63mT2FEothMe7laeTk01v9olE80GeQWlrZf0LjEpTwByFK9knGJ1/d3Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pzLIdeVT; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pzLIdeVT"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cHqFK0s51zm174F;
	Thu,  4 Sep 2025 19:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757013921; x=1759605922; bh=UFCR1Mcto6jEewKwUt7I3C91
	7kzOzULOWzsP0uOMMp0=; b=pzLIdeVTOQhQOZuF5xv5XxGFkrMcknJXMMyl3ncg
	LiBjkp+yDSsjRj7YOL9/lnHZxZ+g3e2VsSIPL7Nwm6T62JNHrUBlj1fKoB4spdT+
	eOsAByXLTwId/KYmdlmlR8czSn8GJZXF0+82MsqTKx/UnyOg/8V47Gw2fkzXbW56
	UQN81o9D83NqKXoMVfyHFT+WWsdZJSTysRde0OBPo42ktDivQ6gSv6LaWM7GRjH9
	76nrNeO0wYnrlvvyweM3DqtnXSF5ehScGMkQZYKl127ILtm+RpcdTxPBEGLOJiZQ
	ysaXMpiW6X3WmPf72XNtnkqf4AYutY2tzopOQbrQPy4f7g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZJwRsxhvjjQL; Thu,  4 Sep 2025 19:25:21 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cHqFB5Nshzm174T;
	Thu,  4 Sep 2025 19:25:17 +0000 (UTC)
Message-ID: <883d6a67-40f8-4a13-a433-d452d0c75571@acm.org>
Date: Thu, 4 Sep 2025 12:25:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/26] scsi: core: Bypass the queue limit checks for
 reserved commands
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-5-bvanassche@acm.org>
 <e555a601-2b87-4139-ace7-0e6158cc93af@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e555a601-2b87-4139-ace7-0e6158cc93af@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/4/25 2:49 AM, John Garry wrote:
> On 27/08/2025 01:06, Bart Van Assche wrote:
>> [ bvanassche: modified patch title and patch description.=20
>=20
> it's an odd name now... I don't know which queue limits we are bypassin=
g

I can change "queue" into "SCSI host" in the patch title.

>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1539,6 +1539,14 @@ static void scsi_complete(struct request *rq)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_cmnd *cmd =3D blk_mq_rq_to_=
pdu(rq);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum scsi_disposition disposition;
>> +=C2=A0=C2=A0=C2=A0 if (blk_mq_is_reserved_rq(rq)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Only pass-through reque=
sts are supported in this code=20
>> path. */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON_ONCE(!blk_rq_is_pa=
ssthrough(scsi_cmd_to_rq(cmd)));
>=20
> eh, do we really have passthough reserved command?

All reserved commands that end up in scsi_complete() should be
pass-through commands (REQ_OP_DRV_IN / REQ_OP_DRV_OUT), isn't it?
I don't think that we should allow other request types for reserved
commands.
>> -=C2=A0=C2=A0=C2=A0 if (unlikely(sdev->sdev_state !=3D SDEV_RUNNING)) =
{
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D scsi_device_state_=
check(sdev, req);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret !=3D BLK_STS_OK)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to out_put_budget;
>> -=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 if (!blk_mq_is_reserved_rq(req)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If the device is n=
ot in running state we will reject some or
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * all commands.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(sdev->sdev_st=
ate !=3D SDEV_RUNNING)) {
>=20
> I am curious about this. I mentioned previously if we only send reserve=
d=20
> commands to the psuedo sdev (in this seris). If so, would the psuedo=20
> sdev not always be running state?

Has the above code change perhaps been misread? The above change causes
the sdev->sdev_state check to be skipped for pseudo SCSI devices.

Thanks,

Bart.
