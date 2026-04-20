Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F81346781;
	Mon, 20 Apr 2026 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776702532; cv=none; b=Ua7FB66KT/RlHNcv0urHfvGz1Hwikp36SL8PEsBnO+FugzXgAUFjFvR87voP7voZWl69Ky/w7ObPwgAqhs7h8lkmHcUPNZpoSNd/dLso2xe5SYCVoEGYRuOCfEIYrJUarSV+9ZoxuupBFZEj9aGspZcmScCdwCipLGizJ2f7QVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776702532; c=relaxed/simple;
	bh=YgAbrnhhyZNC1luZxB4qTinf6K/WmfIlre0+zAVlc7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z8WLAApDomGjaUeDxcUVVZigW41UMcSM2X0/PIprxHT3Icw9SJsWhoSSMZYXwsOBREg7YMQbJ/2fKhvmrik7Kjw3BGhI5F12WCtXa79ruycfnNj4zedwmvr2MuTT5GKwkTdvQa9UiDicq0rdI28Lsbl06JzBHKpLuw+ocMyFpGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DpUucv3d; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DpUucv3d"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fzrXC6yQHz1XM6Jf;
	Mon, 20 Apr 2026 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776702518; x=1779294519; bh=2T0uJWBhHvc94svZR7t7VdBM
	ONxXDYz+1Vb2sMxl7+Y=; b=DpUucv3dTwgsCeo/nSdIorC/+aGtifSng5gN31vY
	dlSZAAFWeV3VcweROI6Qlzt+ONzvUnCU49nRVHSplHXfFRmSjBZCsqI2et2/aMa/
	Y9+5bxa3XlQNcabOZA3d3Ro1DoLLVrAF4Ku+UlMY5P/PO69jS5oEatNX9yE3G8Fo
	Lm7/AyGZ7Z5VgJXVlSBaNo5b3BXwy9Ao/TxUlq4zN4RN0rTaQAZfI6+araWEbcor
	ne//9au7O91OONZ16T0tX+2GfTGJeE5lyoAt1Wn9zirMyiehr6YBQMx4H9rM5JmJ
	OGEs1WLg3DZHNEEOK2f3Y3ms2QPwhxhNVQp1X9cLzL7Zxw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Pph_DlCBnkac; Mon, 20 Apr 2026 16:28:38 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fzrX22D2Tz1XM6JR;
	Mon, 20 Apr 2026 16:28:33 +0000 (UTC)
Message-ID: <90c86ccf-5820-4937-b595-a8b47cac9ae9@acm.org>
Date: Mon, 20 Apr 2026 09:28:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support to retrieve and store TX
 Equalization settings
To: Can Guo <can.guo@oss.qualcomm.com>,
 =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
 <mani@kernel.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "vamshigajjela@google.com" <vamshigajjela@google.com>,
 "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
 <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
 <343283a8281e2fb0ee83622a15028d12e44bd964.camel@mediatek.com>
 <a4792823-5c9c-4a4f-89f2-fde117455506@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a4792823-5c9c-4a4f-89f2-fde117455506@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 6:23 AM, Can Guo wrote:
> The usage of the two Selectors is not limited to above examples. Yet it 
> is hard to get
> aligned on how to use the two Selectors across different companies. 
> Hence I am adding
> a module parameter.

These kernel module parameters can be converted into sysfs attributes,
isn't it? Converting these kernel module parameters into sysfs
attributes has the advantage that different values can be configured per
host controller in systems with multiple UFS host controllers.

Thanks,

Bart.
