Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E638E1C6F7B;
	Tue,  1 Oct 2024 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727803162; cv=none; b=qnJ2xigDRqU8/9e5hcGFi+6WCixVCnnYa5xwgrcqyJTujfnNG8a9+Dz1i9O1EAcVfwe9L3S3/5fuWR8Zv8DFD966gOFdSYa4SRB9R+U3DlkKyvARZxrUPO0uoYLLiGE2I9seI0CqHB0u1GRZE+MrayU7RT9YcS19qq5psNhEiOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727803162; c=relaxed/simple;
	bh=ZkqGZjNn/wyZDqawXjQr4BTFgfOkjt3VeMzvFMkzKuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R17ubs3N+M+HjFs/8Z+W7Gx+bD1KhuHGpH0bMI7lVwpFY8EGwqTxAtG/yBkRG5YisETAo5nqcev5Pkh2exHUJ4aceMC48FAcc+HSO34BHxKUlHmACcaZAzI4fMFKmTylb7oWwdQWrdI/oadBDS4ruYiKqCCy4jh6PHl3yuMlER4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=auyWU9pr; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="auyWU9pr"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJ4Rr2nWWzlgMVs;
	Tue,  1 Oct 2024 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727803158; x=1730395159; bh=ZkqGZjNn/wyZDqawXjQr4BTF
	gfOkjt3VeMzvFMkzKuM=; b=auyWU9prhlCx9AKvaI2saE8g+bdxaVSgKPrr9o5f
	GUeNsRPKt4Gu+YsHIDPBFsyUItuFfWS2Eu1EPdZjPFziTAYSC0AldK8T+OXNrYhs
	DwSXFxnvUP62CpG9FvIEJxHqxnvJP2bdTAPozuJ/bb+UUH6MZGz/GY/J60Envfsy
	Zd83ZUFLGcKd4aEuJN8Hyw1Vla+yFW9WyBaHBFIwkT/M5wDy4CUJJqw1aUsGDUNq
	JTfsb8mayETZ2aBqbM+guJVgzSM8sjwGJVPzIH3FW30hq277f6cZ12NGyQEDfLES
	VxwZQ+WmnfCcnVPxX/0ojxCjOp3q5qw+sun3NNXp1mcQZw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9hfjVHXhMxB0; Tue,  1 Oct 2024 17:19:18 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJ4Rm3HLXzlgMVr;
	Tue,  1 Oct 2024 17:19:16 +0000 (UTC)
Message-ID: <2291e38f-1482-47f2-9c23-dfd259f53824@acm.org>
Date: Tue, 1 Oct 2024 10:19:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Daejun Park <daejun7.park@samsung.com>
References: <20240910044543.3812642-1-avri.altman@wdc.com>
 <5c15b6c8-b47b-40fc-ba05-e71ef6681ad2@acm.org>
 <DM6PR04MB657594C85E06F458EEEDB7C0FC6D2@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB6575B4ADD2F9E4A9DC80C81EFC772@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575B4ADD2F9E4A9DC80C81EFC772@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/24 12:19 AM, Avri Altman wrote:
> Bart - How do you want to proceed with this fix?

Since this patch affects the Exynos UFSHCI, I think we need feedback
from the maintainers of the Exynos UFSHCI code.

Personally I'm hesitant to proceed with this patch. As you may know the
android-mainline kernel tracks the upstream kernel very closely.
Currently that kernel branch is only one week behind Linus' master
branch. The android-mainline kernel boots fine on Pixel 6 devices. These
devices have an Exynos UFS host controller. Since this patch modifies
the behavior for the Exynos UFS host controller there is a potential
that it will break the support for that controller.

Thanks,

Bart.

