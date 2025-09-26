Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF35155C97
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 20:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758917168; cv=none; b=l7rv3nZE5pJ93F3Y55Zpfx8TqYkOg4y2GA6heZYaYRiGENHn77roqvaHjVTjr+hXAeLtHEmXkyhQ+WUvn1qezjuslo+sLJPgMg1WNGbqTkb+bwpfLVX+BFMJHVK97rSGfgB8g0e9QLx8kRsZeBIbsa4MJ/HiNBAurORS+1UtIsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758917168; c=relaxed/simple;
	bh=hWt+K6HkGkoKEsppQ/MKtEplRcLdJUW67pu5IhmnBOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kPnzT99i+EnDQS0b7F7rYvNyZ6razaPrG1t8l2v5Q+SSZYo4LHHMWFrG7Bmx0NDnMtpL8fwZqqoKZZoYxPjoC22umgUQYDI5f8t6NhdEm7NSN7WDp5RvkeRkadJD4DfA5SNSt1sZEoF7sbFsFLOxzNjQHxkNyBML/HSP6voMs8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fXdE8hdX; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fXdE8hdX"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cYM630qh5zm0jvL;
	Fri, 26 Sep 2025 20:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758917161; x=1761509162; bh=1Q14wUwbIiak6/gM8cqRuNqz
	VvhRcnwb4/oMUZWx2+o=; b=fXdE8hdXyh/D1JpoiMYkkfvmoTTRDq8jyMwYk5Uc
	kk5e+i0lB3BA1obY6kP0b96XDJQqYAtqhmstvrJFQrZEzf1COVR+ZBtQvEgUQh34
	lFhLJwMfu8TZN71bcRx89xYZA6gqoO5U43qw3PWLOEjrOQylW0T4yCR43lR/+fzF
	/PlLAha+1eHtazNaFtaEx6h3TRDRxm9YXIUbgIT56hy8R3uBq2oXO/S9znbgKfjT
	veHpOLReboIXgFga7tva10B0KpcfCfFlda7utDEVlLu0yUfsUakBu6XqHetVDjqF
	S5QZCvKwMg5FxO6L8J6XbPI9XcD35jnh1hfS1/EhlGOoZw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CD9kVTUPbQ3H; Fri, 26 Sep 2025 20:06:01 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cYM5z0CNwzm0pKV;
	Fri, 26 Sep 2025 20:05:58 +0000 (UTC)
Message-ID: <e9b9eccb-e059-4268-96ed-29f4fcff6614@acm.org>
Date: Fri, 26 Sep 2025 13:05:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/28] scsi: core: Introduce .queue_reserved_command()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-6-bvanassche@acm.org>
 <0b41e75c-daac-4f3b-ad90-bfb1f42d81bc@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0b41e75c-daac-4f3b-ad90-bfb1f42d81bc@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/26/25 12:24 AM, John Garry wrote:
> On 24/09/2025 21:30, Bart Van Assche wrote:
>> @@ -307,7 +313,7 @@ int scsi_add_host_with_dma(struct Scsi_Host=20
>> *shost, struct device *dev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (error)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_del_de=
v;
>> -=C2=A0=C2=A0=C2=A0 if (sht->nr_reserved_cmds) {
>> +=C2=A0=C2=A0=C2=A0 if (sht->nr_reserved_cmds || sht->queue_reserved_c=
ommand) {
>=20
> But this really should not change, as we cannot have sht-=20
>  >nr_reserved_cmds && !sht->queue_reserved_command (from above)

I will drop the above change.

Thanks,

Bart.
