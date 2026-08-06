Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9E43264D5
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030710; cv=none; b=kMD6A/THxtrR65FmaDaajW3qWzHQWDgrbH06VbRtil2ND5x3AMVdfz9TIIO5vtWTdh2v+D6HLGSWh/Srlyt6oTkNBLwSyvAxsqLTBFz5C9kjRv8Qv1xLSOBn8GYDtL6+bTsWPo5isv9UXGoy18VDKWHyZ3AhfiZdIZrJBq3lyn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030710; c=relaxed/simple;
	bh=DrExcZL+ttFdxJC4LxV1pvEeQ0TuVdivmYbWHTfGtpE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ALYLJVItpqvbwN+laeZZUeqdb5ZonDkXPxz3xOoq8UWAIphCEJXD9PZfkcMqHVQ83YbSB0Uwp5sWR6V7DWnUIo/4eFk4pDOdgGuzwUMmtSvoc0zUfs/CTyU4H+rsSoSyX9/CgVAaG1GtSW9ca4e6QvnREosoftAT0OoLwBuaqFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXdEU8RA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXdEU8RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B281B1F000E9;
	Thu,  6 Aug 2026 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786030708;
	bh=XSFVzE1lOJ6xFOAjxndSuUcOyRhuRtekTkujuuHRFfY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HXdEU8RAZY/JZp1DxkcZPYextlooK/w7GKAQNsoc10gePW29s7XVBocFKHWha5/VF
	 5MAChYkdBoBSvdIw6H7wc6jT3T3OclfYAQD9nSGiH4nd8hchQQMK+0PdF7bXYuonoI
	 naa138euq1A58QwgjBZ5H4T96OsVxQKjgylsYRRiOUZEDuWEkTOqDVdzAzRySAf9hK
	 NqzqmoJ9QcloXU12bLv5SDz2brUTJgIb496LX6Iqs93MfP2DEjLm4+yyU0hlt9eFPc
	 Zn2hzabS35oU+j1JlGaAz+byNA7cFO0d5YtmU6YbwjAXKDUCqt68/RTOg+i3IB/mou
	 DNanWstUJ9MrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/7] scsi: ibmvfc: allocate asynchronous sub-queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806-ibmvfc-fpin-support-v5-4-13fd6f8a8f8b@linux.ibm.com>
References: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
 <20260806-ibmvfc-fpin-support-v5-4-13fd6f8a8f8b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 15:38:28 +0000
Message-Id: <20260806153828.B281B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing Setup and Registration (Dead Code / Incomplete Implementat=
ion)
- [High] Erroneous Per-Protocol Allocation of Asynchronous Sub-Queue
- [Medium] Inefficient Resource Allocation for Async Sub-Queue
--

--- Patch [4]: [PATCH v5 4/7] scsi: ibmvfc: allocate asynchronous sub-queue=
 ---
commit 7efcd61f3c0261f3a8cbf890ed40ef64412880a3
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: allocate asynchronous sub-queue

This patch allocates and initializes the asynchronous sub-queue required for
receiving full and extended FPIN events from VIOS.

> Update ibmvfc_channel_setup() to pass async_subq_handle to VIOS during
> channel setup, and ibmvfc_channel_setup_done() to store the VIOS cookie
> for the async sub-queue.

The commit message states that ibmvfc_channel_setup() and
ibmvfc_channel_setup_done() are updated, but those modifications are missing
from the actual patch code.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6796,6 +6796,17 @@ static int ibmvfc_alloc_channels(struct ibmvfc_hos=
t *vhost,
>  	if (!channels->scrqs)
>  		return -ENOMEM;
> =20
> +	channels->async_scrq =3D kzalloc_obj(*channels->async_scrq, GFP_KERNEL);

[Severity: High]
Is async_scrq placed in the correct structure?

It appears async_scrq is added to struct ibmvfc_channels, which exists
per protocol (vhost->scsi_scrqs and vhost->nvme_scrqs). Because this alloca=
tion
path is executed once per protocol, does this result in allocating an async
queue for each protocol instead of a single async queue per host, which the
VIOS channel setup expects?

> +	if (!channels->async_scrq) {
> +		rc =3D -ENOMEM;
> +		goto free_scrqs;
> +	}
> +
> +	rc =3D ibmvfc_alloc_queue(vhost, channels->async_scrq,
> +				IBMVFC_SUB_CRQ_FMT);

[Severity: High]
Are we missing the hypervisor registration and setup steps for this queue?

Without the updates to ibmvfc_channel_setup() and ibmvfc_channel_setup_done=
()
mentioned in the commit message, the async queue is allocated but never
registered with the hypervisor via h_reg_sub_crq() or communicated to the V=
IOS,
leaving it non-functional.

[Severity: Medium]
Does this queue need a full event pool allocation?

Calling ibmvfc_alloc_queue() with IBMVFC_SUB_CRQ_FMT sets queue->total_depth
to a non-zero value, which allocates a large command event pool and associa=
ted
DMA memory. Since this async queue is intended solely for receiving unsolic=
ited
events, could we avoid allocating an unused outbound event pool?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-ibmvfc-fpi=
n-support-v5-0-13fd6f8a8f8b@linux.ibm.com?part=3D4
