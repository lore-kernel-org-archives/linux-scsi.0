Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E281F19A;
	Thu,  8 Aug 2024 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136935; cv=none; b=PipeG3BmR0IEx3ZoR9vLPINzd/ABjZCBltOFpESmQJ1iRgxcJph8sfhqk5IGTKO/vjtVGOgYjQy3eYh8bNh9uBws+g+Gh2+xq1E3ukCX5Sf8qmLGJm9k53ITMryGUWL3KkunZyPzoKyJVmX3gKkHlPni7IfBDAVki2bHBexkvS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136935; c=relaxed/simple;
	bh=Dv6UFge+r3fUMfdEDSKZLszG+D/NEMRn3J01gHnBmgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RPWBK54hEXe/VQ/R78y4SC6HkiOrX4t0o/flfyb0Pit1c9/zw3VbDiCXGulcNUpIH5z42ky4oNSfy85ubicj4SZo8/MgGT/a+Hl20c5T1Nz2H0t/6NQwBaXGZhA8pleprgXIMRr3CLnWY3ajCxVTVcpVGn0hWFTwqOGMk9uL6PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y7lx6KNz; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y7lx6KNz"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wftmb19R9zlgT1M;
	Thu,  8 Aug 2024 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723136926; x=1725728927; bh=Dv6UFge+r3fUMfdEDSKZLszG
	+D/NEMRn3J01gHnBmgY=; b=y7lx6KNzqb0NfcC1pIjtbmKtoufjJc9g9U3fNnD1
	yrOpg2Hp7Y18rFnhK+hHvGvZnWh3GBKMSpm/rYszrCl9yChbXU7V63LxQFk//Rxk
	tp7QV1IerkS81TXNWWtgS8CeHi4eFlZieQW3sPQoKjoSzZzyeP/JlAXwaqN9HcVH
	/yupARRe+dyaZ6EBWTgniL8XZ19cVVG9kJWILSFLcmDiEayORER7QdKljdymf5KT
	tZDK71Uc+C0/9azBgnUHCeBDWmIREhLutvn4Ogx1VvFHB6Rn4XH52qgb09yLOJyq
	c9j8rAd477HNX7fvbQ6hPce/fA1VYstuzZj+W0dg55E8hQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id md2vhGJoIZiq; Thu,  8 Aug 2024 17:08:46 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WftmX6z5zzlgTGW;
	Thu,  8 Aug 2024 17:08:44 +0000 (UTC)
Message-ID: <c5715a05-c6da-4e7d-abb7-87db0756dc10@acm.org>
Date: Thu, 8 Aug 2024 10:08:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: Add HCI capabilities sysfs group
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240804072109.2330880-1-avri.altman@wdc.com>
 <20240804072109.2330880-3-avri.altman@wdc.com>
 <28624a6d-fdc7-4458-8e8f-f8d764cd4b5b@acm.org>
 <DM6PR04MB657591C5FD3C16AB0864FA6EFCB92@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657591C5FD3C16AB0864FA6EFCB92@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/24 4:32 AM, Avri Altman wrote:
> So I am wondering if having something like the below is acceptable?
> /sys/devices/platform/<platform-specific-path>/ufshci_capabilities

This is also fine with me:

/sys/devices/platform/.../ufshci_capabilities

Thanks,

Bart.
