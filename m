Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665171DFD8B
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760975049; cv=none; b=PrhDZUnz+A2XiJMw15b9d3Mln9ctK5zqx0lFhWwD5z1Bjy6Vvs7MqyNhMzRyevXJB19c98B076guIgocrbr7Vqf3AHOIWSaxuS+hip5mwIblrnFL826AwGW1b1Xsq6z3qqHbg6PCiJF8wF6zWuVwO8YVCug47JH7DBGFnaDyvxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760975049; c=relaxed/simple;
	bh=h8hxWxxmUE72fWhgX8Vsb3xFxSnu6zClqOfifB8Rm3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnPxIbWnCtQ68Z7BTdLRH/mx3EUZ/5fJCbjerZmn/csy0gMXMm35Wj9baQrnD6qqZgk9GeLwM+51b2uGXdNWv8ghbwFUI5KXrWLSsra0ECD2SaQdSzFjdVi2JgAcM5VznnNHHpUve2HM7J4mvfu+1JgeZFTqElS8fv2Illp3+P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0ZIwlhTG; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0ZIwlhTG"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cr08k36rdzlgqVm;
	Mon, 20 Oct 2025 15:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760975045; x=1763567046; bh=h8hxWxxmUE72fWhgX8Vsb3xF
	xSnu6zClqOfifB8Rm3k=; b=0ZIwlhTGUtiDY0KQuaTdZlWTgneKE+5fQ0DhavI2
	CebARQcPkZ74gPZgB8XHORGJfcCrM5GmrkDeeDsSCQuntwzDxJbrtQjjhIdLbT7H
	UVMmVqhIZOgeC+qOqINnxCtfC+eWPmxDN4Wg12/nQugOxqKdkXQ3p7/0l5iYuhsH
	U6G4pz62S6rMNbeAEFmTsY4Ghsh6sdNNhngVe3opwCLWA9EFJjqV0tDKACg2eCL4
	rdTbfRnksJxeHUaiejE4FLVPiTHYd/RE+1XyaQwDnPnGTSe8BdyYptHyauXTcOos
	FeR/35LfqXpvw5/QLIa0ypo49BUW6yvbJqid86vwSxlotg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b3Ng9_e63hdo; Mon, 20 Oct 2025 15:44:05 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cr08f0bpXzlmm7q;
	Mon, 20 Oct 2025 15:44:01 +0000 (UTC)
Message-ID: <8e5889ed-279f-4973-9abe-7fd786ba2a42@acm.org>
Date: Mon, 20 Oct 2025 08:44:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Do not declare scsi_cmnd pointers const
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014220426.3690007-1-bvanassche@acm.org>
 <0b3e9efd-9ced-46c8-8758-76a1ebbe9ecf@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0b3e9efd-9ced-46c8-8758-76a1ebbe9ecf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/20/25 4:39 AM, John Garry wrote:
> On 14/10/2025 23:04, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
>> index b02af340c2d3..3cd0d3074085 100644
>> --- a/drivers/scsi/scsi_logging.c
>> +++ b/drivers/scsi/scsi_logging.c
>> @@ -26,9 +26,9 @@ static void scsi_log_release_buffer(char *bufptr)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(bufptr);
>> =C2=A0 }
>> -static inline const char *scmd_name(const struct scsi_cmnd *scmd)
>> +static inline const char *scmd_name(struct scsi_cmnd *scmd)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 struct request *rq =3D scsi_cmd_to_rq((struct scsi=
_cmnd *)scmd);
>> +=C2=A0=C2=A0=C2=A0 const struct request *rq =3D scsi_cmd_to_rq(scmd);
>=20
> do you really need to declare this a pointer to const? Or just a good=20
> practice?

It's a matter of code style. In some code bases the memory a pointer
points at is always declared const if the pointer is not used to modify
that memory. In other code bases, e.g. the Linux kernel, the "const
type *" pattern is not that common.

Thanks,

Bart.


