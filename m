Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E3C1C84CE
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741796250; cv=none; b=MdF6LfMwIsUbWZdsYUhhhjaMskG+ST/15FmVsf6LBtq2Zt/XxcU8L1Ungm7Ga7sjqPdUek7ksPkepYHVdiJjMNaVYqB9iddvaEo3a4erloOmufRRoZQa4OIX/S3TILe6gA0mumrctSyrtKi1NVSYmBovVFCJzPGkP7PGw3mAneQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741796250; c=relaxed/simple;
	bh=dmiP2rAilSbTNwe68LXM67XERG8A5OqoRovQ2XAicwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r2N0qBg/QgrktTIP3wKsKAqXu0qMYb+2/iiBwLoFl/y01RbmWkONVqiloLWk0SwwouPRijlaj9QSPbHKQTTUPXCwiQ4fmtAXViKXrOgZwpzrx/kWRqR44mqZ7vTuGUSbxTNxv1oIlrJ8QeZzk4fZLk545e/cvaTN5mQIuXwhG1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jGOrRnsq; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jGOrRnsq"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZCbPg5Jj6zm1Hbc;
	Wed, 12 Mar 2025 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741796245; x=1744388246; bh=dmiP2rAilSbTNwe68LXM67XE
	RG8A5OqoRovQ2XAicwc=; b=jGOrRnsqNQvq8PM9apNFWKF3JABiB4K8MvzZn82k
	5dhS8s1AuTGPFmy/o+vWwYmt59F/bHf32bReOvNuaWOhmrpmzexGYMc+YVkHzHYe
	0/+cmOwaAtHzWn2Mf8TAeHpfH7Du4J5fvmyEaesoLsbEiOwG7pb2WP7xhkeYbMT/
	IUwq13ZbLXDrhhUlB9VOcsyj4pkv/WM1g3iDBCm+61SBzGOwB67RjGFq1R5+VWpn
	XhmvZaezqbmQfgmmA5KcJllqdBnjutc5l498kb2s2xdMMrkVuJu+anR/qNJw9adI
	oIak9oC4yS/eLpjzeEqRNM67Ug9bYVZ6DIcICqIOtRbAMw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id j30dirGpofba; Wed, 12 Mar 2025 16:17:25 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZCbPV4gP2zm0XC2;
	Wed, 12 Mar 2025 16:17:17 +0000 (UTC)
Message-ID: <1a320729-bca0-44e2-9061-c4c9b9b5e57f@acm.org>
Date: Wed, 12 Mar 2025 09:17:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
To: Avri Altman <Avri.Altman@sandisk.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
 Can Guo <quic_cang@quicinc.com>, Santosh Y <santoshsy@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20250311195340.2358368-1-bvanassche@acm.org>
 <PH7PR16MB6196B6AD43F68C7BE8128332E5D02@PH7PR16MB6196.namprd16.prod.outlook.com>
 <088fdfb9-00c7-43a9-acb9-e5300923d129@acm.org>
 <PH7PR16MB6196CC179C5F5E0F69F2FA77E5D02@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB6196CC179C5F5E0F69F2FA77E5D02@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/25 7:25 AM, Avri Altman wrote:
> I was hoping for a root-cause analysis explaining why hba-
> >dev_cmd.complete is sometimes set and sometimes NULL.

Hi Avri,

Hasn't that already been explained in the patch description?
It's not clear what additional information you need other than
what has already been mentioned in the patch description.

Thanks,

Bart.
