Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069E2223328
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009887; cv=none; b=gBJhKhN3u1szhroJha+OwfgWR75oWNw1jggQlG9rTdUFZ8J36/PcGb7c3tYNP4w/Au93bJo527HDUBTwW4ZlTRJnuLdKgS1cfqGAiP5wSK+P78oOnmouVRSperi0MeA1wyuyqeHG1L53lxBdr3zRr/ls5fHYOj0gdXB5JvD2vpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009887; c=relaxed/simple;
	bh=6hVK3eD1/bP1T8tIySgw5xLfCRyJLAFWVpLDpmHPJfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1oDSsJFeP5LYzO4gpaWAbB6o9d45Gxr8HsYA8+4p7c2lusO5RbNMq0DbjTTfVGMoONniAERQUPTGjtoT5ZnwyQ16+J5j+5oCqPJyD1h1Hj2XoPemo8Wzxf047LYJ93zA02oHE1sKklMET3h1ZyGIdaEgtwznrf8gGB2lwasIYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pseUpq7k; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pseUpq7k"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cHnld0PfzzlgqVj;
	Thu,  4 Sep 2025 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757009881; x=1759601882; bh=UUMamEfhS4ZdxLbgh0v5GToI
	fTqMm4GAROAXHYyTNyA=; b=pseUpq7k3v4xg1zzKk977iiDum8roh2fwhYt7i6e
	zBru47+Ah/2c7baHqpz6vhsJGHbUcDh6bV+VLMXDeRsCqgA/g/xhh8BApBgqg/V8
	SMMeVgJ+0qyp69zkPCsngMqNE8TTSmTmsPjlQUiZl9wjfz+bVpt7LIZHKRTU0PO8
	ANLafO69gF/KcLrlDmyGSs/etuy4P5FJ8DiJbM4+D7NsBcG8OWU+FAC+jxeZ/pAS
	OPyOijTtFB7eIAsfzDeXtZ/VoRHUZpIp3IFJjU27jdYG0/dP87xbzfDVza9Chf8Y
	O4K2GXq2BRoUy0jEwHZQsJCdqk6YvMTAwQuc722jgx1V5A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Emt2T2G4FOD2; Thu,  4 Sep 2025 18:18:01 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cHnlT1Wj9zltJQL;
	Thu,  4 Sep 2025 18:17:56 +0000 (UTC)
Message-ID: <719e714a-6f15-46b9-b4f1-b697ea00ef66@acm.org>
Date: Thu, 4 Sep 2025 11:17:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/26] scsi: core: Do not allocate a budget token for
 reserved commands
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-4-bvanassche@acm.org>
 <7341ada1-05c4-4a70-94e3-cd208d47231d@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7341ada1-05c4-4a70-94e3-cd208d47231d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/4/25 2:41 AM, John Garry wrote:
> On 27/08/2025 01:06, Bart Van Assche wrote:
>> +=C2=A0=C2=A0=C2=A0 if (scsi_device_is_pseudo_dev(sdev))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return INT_MAX;
>=20
> It's not ideal to have this extra check in the fast path always.

Can you provide more detail about your concern? This is a simple integer
check and hence the time this check takes is negligible compared to the
atomic instructions required to update the budget map. BTW, if no budget
map is allocated for pseudo SCSI devices, the above check can be changed
into this:

	if (!sdev->budget_map)
		return INT_MAX;

The performance impact of this test should be even smaller than the
above test since the budget_map pointer is already used by
scsi_dev_queue_ready().

> My original problem in this area was that we were trying to send=20
> reserved commands for real sdevs and those sdevs may have run out of=20
> budget. So I was suggesting to not get budget for reserved commands. Bu=
t=20
> would it really be possible to run our of budget for the shost psuedo=20
> sdev?

Yes. The UFS error handler may be invoked if the SCSI budget has been=20
exhausted and may have to allocate a reserved command to recover from
the encountered error. The UFS error handler may e.g. submit a START
STOP UNIT command if the UFS device is in the suspended state to bring
it back to a fully powered state. See also the ufshcd_rpm_get_sync(hba)
call in ufshcd_err_handling_prepare().

> BTW, you are only sending reserved commands to shost pseudo sdev in thi=
s=20
> series, right? I mean, I think that you don't send them to real sdevs.

In this patch series all reserved commands are allocated from the pseudo
SCSI device. From a later patch:

	return scsi_get_internal_cmd_hctx(
		hba->host->pseudo_sdev, DMA_TO_DEVICE,
		BLK_MQ_REQ_RESERVED | BLK_MQ_REQ_NOWAIT, 0);

Thanks,

Bart.
