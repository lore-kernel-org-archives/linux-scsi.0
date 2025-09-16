Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3452905
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758037559; cv=none; b=LDUVc7EoKwfRV0FXWvld7ASquXz4S7jnsWeWaoD1n6rprNPlUNIQ1Ng5B5uh5Kcjc86mqsoECMMqipMTH/N51+Y+CnZKo5YgzB+36X0yCJQozexMTL3Bo2vLPt+lXR1siMZGwQCkF33c5A0k/4FuzoqZ660rfMdM2FJ03gKcrz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758037559; c=relaxed/simple;
	bh=bPMnMc7YifPOkXqo0nudnrU/XFRuNkQNmnk8FH9ddEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uloMYA8GR+byV+nRgJWeY26SfthQzRNm70FGR1jH5CKhQ54I5Zd8BXqQWy4rS64riKKRs7xAuicbho3rKlT4ZRz3/f83+rtCbi/ZJ5Khbv/bFaDmKMk8Xg7uRdijIlwg4T1IvryTvNsOR2uSm4m3WU/zbFFb7INFRiJh6w1U9SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lsAYRfte; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lsAYRfte"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cR5pQ629Zzm1742;
	Tue, 16 Sep 2025 15:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758037549; x=1760629550; bh=bPMnMc7YifPOkXqo0nudnrU/
	XFRuNkQNmnk8FH9ddEg=; b=lsAYRftetGnxbh4v4T6esO/2mMZOzCVsymv27N/8
	Jijxe52ZAI7Xnq0AeXaURmX/tydbYP+4oJBMCADkls07TBFtwRMJgQG+ZDWDSQc/
	EOzAb0D1wIM5M4JjZJw30LzwsX3IieQJ3eiv0NzJhAN+YL1R6e5MNacIEpofv9d8
	tA+q917BGb+xLZKs3hIuTvupLV60wwIswL4Q4TAdoFSUu4uAVXQHPUFWf0MFT/OS
	/NcSSmwOJtoJ2KxUR3haZXK0wdl1R1EdjGeX5PSOVDLPHaBjOlGy/Qd6FEz3foz3
	E2YTv5nCmFKGHyWBjJ4C+ndMKDy78jz5VV7WlkvnlyEwWw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OjUaYL9-12Le; Tue, 16 Sep 2025 15:45:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cR5pK10Cvzm0yVT;
	Tue, 16 Sep 2025 15:45:44 +0000 (UTC)
Message-ID: <aa051278-caae-41bc-980e-77f589d5eb51@acm.org>
Date: Tue, 16 Sep 2025 08:45:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/29] scsi: core: Make the budget map optional
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-4-bvanassche@acm.org>
 <aabc487c-ced6-499a-8231-6fc4866c12f9@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aabc487c-ced6-499a-8231-6fc4866c12f9@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/16/25 1:34 AM, Hannes Reinecke wrote:
> On 9/12/25 20:21, Bart Van Assche wrote:
>> +=C2=A0=C2=A0=C2=A0 if (!sdev->budget_map.map)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return INT_MAX;
>=20
> Strictly speaking it's not related to reserved commands, but rather to=20
> cmd_per_lun. Wouldn't it be better to introduce a way to disable=20
> cmd_per_lun (eg by setting it to INT_MAX or somesuch), and then disable
> the budget map when cmd_per_lun is disabled?

I will look into this.

Thanks,

Bart.
