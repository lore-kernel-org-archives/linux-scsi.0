Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC71264FB5
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760975550; cv=none; b=V2Cx/OCifGzIGYiuRFzCKOnesFF8/PoM2rixANQHkYvP4XFn4DtQ2kqRzmOC7YbE6oPt/rk1ym37IQ5sbWu2cMn8ExgswPljUl/qb4x5e+eHCZBiZpXsL55j4URBEj1t4ta0zl5aNzaoOvd0EyRnRoKgCOthPQjY2ashn0VIZS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760975550; c=relaxed/simple;
	bh=9tOsvzONexz1bBZPPwc3QBBeuANYYFma0u1mm/w13r4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p8+JGKivKwXwSs9qLVrU0F14dhIhsmVlHByXEN6kXRCAJh8EmhqVUM/f0WrP/Ay0/UDusD0aVrekKKQ0/RYCNI2GDUg+bvzTCI58xI3IZtj4+bgRjZm4pP6Q9VfzLPzCkCztJ/TnIH8BtlV2787VPtJb27BgHiNznY8/OKfKB0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IWU/5s+N; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IWU/5s+N"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cr0LF4Bdlzm0yV4;
	Mon, 20 Oct 2025 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760975539; x=1763567540; bh=9tOsvzONexz1bBZPPwc3QBBe
	uANYYFma0u1mm/w13r4=; b=IWU/5s+NfF8pfpOidLijkOiEp6cmWFmWb23vI+Vv
	eo0HnwRxUEloUy5g43zhHtnYJoGZe3OEUG/78NgeUbPjUEoynsW2Bqf9yk1dQZV2
	qvZKLDL57ytjoNfpDjCd/c7UmEdhhlUnq26NEFnT/pR41gxNuful8LCAQwUPv1cn
	bV5iV6wzZnBCU0O/+XKRUrvi8MJtuycUPUBUb3LKwXTQZ6WDOlbVWlABSqsugH9N
	n8jWowx5K8PzJ2AOOjc+3Wt7WFbBmto6xrUMfAHjxp49yeOhJNjVdPLzCJ3IyFXY
	Z/aE4CNPuZWAQJIgEF9Ikw0ZN116zuEmBI5LCW0KirOuWg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2QnmB303rYKP; Mon, 20 Oct 2025 15:52:19 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cr0L65DpHzm0yVF;
	Mon, 20 Oct 2025 15:52:12 +0000 (UTC)
Message-ID: <80ab997f-35f1-4386-a449-41b36f0b91b3@acm.org>
Date: Mon, 20 Oct 2025 08:52:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] aacraid: Fail commands that are not submitted
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Gilbert Wu <gilbert.wu@microchip.com>,
 Sagar Biradar <Sagar.Biradar@microchip.com>,
 Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014220323.3689699-1-bvanassche@acm.org>
 <c3703b46-fbe8-415c-85d9-1e035d2ac467@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c3703b46-fbe8-415c-85d9-1e035d2ac467@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/20/25 4:26 AM, John Garry wrote:
> Doesn't scsi_dispatch_cmd() translate anything non-zero and not=20
> SCSI_MLQUEUE_DEVICE_BUSY or SCSI_MLQUEUE_TARGET_BUSY to=20
> SCSI_MLQUEUE_HOST_BUSY?

Yes.

> There are many dev->in_reset checks which return -1=C2=A0 and then FAIL=
ED is=20
> passed to scsi midlayer. Hence previously we would get=20
> SCSI_MLQUEUE_HOST_BUSY - are you sure that you still don't want this?

Probably. I plan to post a second version of this patch that doesn't
modify the behavior of the aacraid driver.

Thanks,

Bart.
