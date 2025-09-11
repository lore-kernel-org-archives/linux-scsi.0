Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5B835AABB;
	Thu, 11 Sep 2025 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606397; cv=none; b=HHOGqDpa9tgdJ5BTrEtpv4ehK/EVZTR1WCRMUKBA09+fybNREF5ARvEnUqnKV1ta7NHDoDT2GYFpWM6W+xc/9MoJ2y3nYPuw6jMNvyXQYG8/SBMrpXNAIrY27TLD1wE1ModhjsKTnq0fEkIziJNt/wclpMP/gjhBM7HWpAboaCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606397; c=relaxed/simple;
	bh=AFAyqim/NL80MAevaG1bDQCCrPph6gVXyG1kZnqfrCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RgluJ3bupRf6k4F5R4lSnUojy1Lif7YxI4BeVgID9b4zCJfC2H3TzIWoRTpQFYNigUqe3QtN5LagrNzK3RKTddR4BGX0R4gGf7xaGEHRYf9mnII9c5WHaV8NDS+zYfgZ8rRzlVyPM5farn50uuA9EQsNFsMJS09vb1nDnFBoG6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yiYwp7E5; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yiYwp7E5"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cN2Lx5yynzm0dht;
	Thu, 11 Sep 2025 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757606390; x=1760198391; bh=AFAyqim/NL80MAevaG1bDQCC
	rPph6gVXyG1kZnqfrCg=; b=yiYwp7E57z9WQI+q08zuk9ncTqDq/bg63aBIRehK
	osM9mQ0D6t/Z9/fG+O+7xSDqyjMyRIQ9wMDthwXfN6a3QFvm8r0k/ztHbutdvDdl
	6GjFhTPtDz0Y+lze7858JzeVDS2xv9cEorw4+lYZ9914a/FSvCpmkd0u8/AWxFX6
	XHuv+dwSnsyx517h2LBy+qA/gwaWXocwmFBtxoa4wVpB8AmlBcwfkPo53Y5pAkJp
	oXfjqBevwNtMx/UULvr2YJfTjyc7m/JfeKS4o3AqS7LmvVRDUWmjpZz9cZmS56J6
	1NahKMJI0v8SV3fZhY6q/ptLI3GH0bqdmK7HXl6S0sdhGg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ybPBTLNM_Rrf; Thu, 11 Sep 2025 15:59:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cN2Lm5h3Hzm1HbT;
	Thu, 11 Sep 2025 15:59:43 +0000 (UTC)
Message-ID: <56a33ff6-d57d-431e-b33a-496bd8f760ea@acm.org>
Date: Thu, 11 Sep 2025 08:59:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: core: Improve IOPS in case of host-wide tags
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250910213254.1215318-1-bvanassche@acm.org>
 <20250910213254.1215318-4-bvanassche@acm.org>
 <a28d07ef-34a9-41ed-bd4b-ddcbf3de13f4@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a28d07ef-34a9-41ed-bd4b-ddcbf3de13f4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/11/25 1:15 AM, John Garry wrote:
> On 10/09/2025 22:32, Bart Van Assche wrote:
>> -=C2=A0=C2=A0=C2=A0 sbitmap_resize(&sdev->budget_map, sdev->queue_dept=
h);
>> +=C2=A0=C2=A0=C2=A0 if (shost->host_tagset && depth >=3D shost->can_qu=
eue)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sbitmap_free(&sdev->budget=
_map);
>=20
> eh, what happens if we call this twice?

I have checked that calling sbitmap_free() twice is safe.

>> +=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sbitmap_resize(&sdev->budg=
et_map, sdev->queue_depth);
>=20
> what if we set queue_depth =3D shost->can_queue (and free the budget ma=
p)=20
> and then later set lower than shost->can_queue (and try to reference th=
e=20
> budget map)?

I will modify scsi_change_queue_depth() such that it allocates a budget
map if sdev->budget_map.map =3D=3D NULL.

>> +static bool scsi_device_check_in_flight(struct request *rq, void *dat=
a)
>=20
> so this does not check the cmd state (like scsi_host_check_in_flight()=20
> does), but it uses the same naming (scsi_xxx_check_in_flight)

I will rename this function.

>> @@ -1358,11 +1400,13 @@ scsi_device_state_check(struct scsi_device=20
>> *sdev, struct request *req)
>> =C2=A0 static inline int scsi_dev_queue_ready(struct request_queue *q,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_device *sdev)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 int token;
>> +=C2=A0=C2=A0=C2=A0 int token =3D INT_MAX;
>> -=C2=A0=C2=A0=C2=A0 token =3D sbitmap_get(&sdev->budget_map);
>> -=C2=A0=C2=A0=C2=A0 if (token < 0)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>> +=C2=A0=C2=A0=C2=A0 if (sdev->budget_map.map) {
>=20
> this can race with a call to scsi_change_queue_depth() (which may free=20
> sdev->budget_map.map), right?
>=20
> scsi_change_queue_depth() does not seem to do any queue freezing.

Agreed, and I think that's a longstanding bug in the upstream kernel.
scsi_change_queue_depth() should freeze the request queue before it
modifies the budget map.

Thanks,

Bart.
