Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE9014AB4;
	Wed, 15 May 2024 13:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715778506; cv=none; b=f/ZhnRvw+F8GJFu6sUDHBnIwJ0a0/g1K696OUeiNO32SdfV9TK7GPOPJW0jB62o00eqA3fdAAPHHf7oR4Sm+C1/cguoMPVTSw+D82U6Z9Q9cNR0RSqXL8OxStOdI/LkDb2vx789K7z2bQ11M5dy5SkjTfl3gt3gln9wgtO/kUm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715778506; c=relaxed/simple;
	bh=I0n01cmqHj4vxl3kRXmOT5oIJDHDJavp9ZenunGlYFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DXHUJ9f9TI77na7cLt/oBp/G5t6sdXjWHTRjx9bHAYgCw4qvoMl1iyyyDKyddVh4v98gg3KhLHq8kN69Aseg3FoYCm+51UBuQb2eVnEl36oV/jnNBlSzL/UtiuZDo0wN2yFISMLgXgV4vW1IbMZm0NxW9mUUMJBZPyZJHSscVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=r9xkmKo2; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="r9xkmKo2"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VfYSN6DK0zlgMVL;
	Wed, 15 May 2024 13:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715778498; x=1718370499; bh=fYt3SvPcQaTvgsIZh5G4Krtr
	8T/GhxaoFdfUvaQrbq4=; b=r9xkmKo2vP4y1j+vNzR7CNN/feAlifW4p0zTQlN1
	GJk9gEFXnlDfaALy1FQUZJoi07C9M000O9z+zsQkXRt8pu+YZgwiC1krnzJNmwuH
	Q8+1q9G5eoJk7s7ytZll1yAGm4l0EVrTZWr2rwZ2cmimIRLib8L1OCilf0ev3Y6/
	RbUv9QLrl0drFUQ/A5GKHifolfYElPce9wABhSe7LGNeaN+xivCF49zejfmo4NPb
	NaSD11+MDRdBQR72sbcNxLixg21rMpn2ZOWWkp5D4K0HGAIiCL+bOcxsrcC12rFi
	FC0C4SDJHaUxl4UuSLj/N0E0cy5l31P84D0SLCo1Zul2TA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id J4ymcboyPHLy; Wed, 15 May 2024 13:08:18 +0000 (UTC)
Received: from [172.20.0.79] (unknown [8.9.45.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VfYSK4d3TzlgT1M;
	Wed, 15 May 2024 13:08:17 +0000 (UTC)
Message-ID: <982ae15e-d3f2-4d0e-983d-fc2c55e6411b@acm.org>
Date: Wed, 15 May 2024 07:08:16 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: Allow RTT negotiation
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240514050823.735-1-avri.altman@wdc.com>
 <34c50f23-82dc-4b53-b8cb-e5c07c6e0106@acm.org>
 <DM6PR04MB6575CE65772D92073360FE64FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
 <0300cd4e-46d6-499a-98d5-72360c94ae49@acm.org>
 <DM6PR04MB65759D4064B9FBF13BBFCF72FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
 <de19c4be-ef6d-4b1a-be26-fb697ac29026@acm.org>
 <DM6PR04MB657562B04C1394FF8FC1D9A3FCEC2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657562B04C1394FF8FC1D9A3FCEC2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 22:56, Avri Altman wrote:
> Via ufs-utils - https://github.com/westerndigitalcorporation/ufs-utils
> You may remember - this is why we needed the ufs-bsg interface we added few years ago.
> Ufs-utils is the industry standard with respect of configuring and provisioning ufs devices,
> And currently is being used by the vast majority of ufs stake-holders:
> device manufacturers, platform manufacturers, mobile vendors, etc.

Given the importance of the RTT parameter, please provide a sysfs 
attribute for reading and configuring this parameter. UFS users should
not be encouraged to change UFS device parameters without the UFSHCI
driver being aware of these changes.

Thanks,

Bart.

