Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12BF7261C;
	Tue,  2 Dec 2025 00:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764636832; cv=none; b=th6mUEloJ245bD3zAUhAy36yjDIaqbsPnKU6aqiPViy6FJrYA2eaK2xg0f9+OvX96wksWMxkhTr1ILsJNIgp1gZIgZ5M7Ob1DSNr5MWyptTwSTi2WSQySzEqs49Sss9lRX6xDlby82wx7b7Q46nYmF14XFs0for9Fw1R19xLLZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764636832; c=relaxed/simple;
	bh=GwL9PTm1UfeWRz8QWdstyIHoUnnjatdx2KKy6uQwyEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZO5jG9s+OgtgiJ+FdZ3qpt/ICKHGEn5myNvHTqf9vBU1ANMgjSB7sGd2Zh1vlrl6Kw/+edYYM+8G0vdMb6gBdGLfEO/TPpTeVdTK2Znjdd/ruDxUXEZeIUKijAaLVr1HWpcZbcevD6GfGkGrHMQq97D4aDGD8u01JfDR9cLe22A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4V/qnH+E; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4V/qnH+E"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dL2Md26hQzlfgQK;
	Tue,  2 Dec 2025 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764636827; x=1767228828; bh=KqNLPPobjR29ZW7h5eD+cq+D
	Usmg30En60oi6F/HeaM=; b=4V/qnH+Eik1XtH6lMDnrwHSAU7l9Ea4OoQK/lB6R
	cl8HxU02bMRsZmfrJHaNZhD/vH1hVYgd8TImEBrYGYNQmDcDQaXifwAEP/vcEkaA
	vQDDEWWVJlTFaX2NmDUtuZrlBazenxwaMiRiO0nNZcu951FKPSPaS3DGNyZxagQI
	rdcdwHHE9fgjep/atpCx6xfHxs+qGJ5B2XsPrlLmDRBEcWmcnDHAOSnMjDk30OIf
	oRiOpF59aQxdsC/dXFVdZ6BdH+8Z8ENzdGvPH4GKWKCq6T3e62FzzL3QopTkxNtw
	cv7KifY+YgArZbXsKhNQibFJQPQBjHHyfkd0C+w+9w7rXQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1LUTIJ__bKxO; Tue,  2 Dec 2025 00:53:47 +0000 (UTC)
Received: from [100.68.218.127] (syn-076-081-111-208.biz.spectrum.com [76.81.111.208])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dL2MW3hZczlgyZS;
	Tue,  2 Dec 2025 00:53:43 +0000 (UTC)
Message-ID: <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
Date: Mon, 1 Dec 2025 16:53:42 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
To: Bean Huo <beanhuo@iokpp.de>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 can.guo@oss.qualcomm.com, beanhuo@micron.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
 <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/1/25 2:42 PM, Bean Huo wrote:
> On Mon, 2025-12-01 at 12:25 -0500, Martin K. Petersen wrote:
>>> When CONFIG_SCSI_UFSHCD=3Dy and CONFIG_RPMB=3Dm, the kernel fails to =
link
>>> with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove():
>>>
>>>  =C2=A0 ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to
>>> `ufs_rpmb_probe'
>>>  =C2=A0 ld: drivers/ufs/core/ufshcd.c:10505: undefined reference to
>>> `ufs_rpmb_remove'
>>>
>>> The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates to true
>>> when CONFIG_RPMB=3Dm, causing the header to declare the real function
>>> prototypes.
>>
>> This now breaks the modular build for me.
>=20
> I tested both IS_BUILTIN and IS_REACHABLE for the RPMB dependencies bot=
h work
> correctly in my configuration.
>=20
> IS_REACHABLE would provide more flexibility for module configurations, =
but in
> practice, I don't have experience with UFS being used as a module.
>=20
> Would you prefer IS_REACHABLE for theoretical flexibility, or is IS_BUI=
LTIN
> acceptable given the typical UFS built-in configuration?

Hi Martin and Bean,

Unless someone comes up with a better solution, I propose to apply this
patch before sending a pull request to Linus and look into making RPMB
tristate again at a later time:

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 9d1de68dee27..e0b7f8fb6ecb 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -105,7 +105,7 @@ config PHANTOM
  	  say N here.

  config RPMB
-	tristate "RPMB partition interface"
+	bool "RPMB partition interface"
  	depends on MMC || SCSI_UFSHCD
  	help
  	  Unified RPMB unit interface for RPMB capable devices such as eMMC an=
d

Thanks,

Bart.
