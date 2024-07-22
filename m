Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BA16EBE2;
	Mon, 22 Jul 2024 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721671065; cv=none; b=j/fHbm+lBOmpWrRsoD2P6KERtVzwdBnc3kmGayDz1N350UP9/muGjWV3nL5VAiEI+lGyrVvLK2RBS0e3yUIe73guFx0dH1ifH8+hL0c9Li6R8j/DbcgGtC5MH1g79AuYJMu2vUv9wRFVlbgLjUDVo6sY64G/TsynJHtQNOMmXXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721671065; c=relaxed/simple;
	bh=DqiL8Zutkh0p7AU8coJxeF0866xwrUrObs4iZYz2/NQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UnnifttGvdTeQxVSJaxAmYCrsRIShy9Hl+wuDcDzslpfyCOtYYcxgyu10gYI4arpAw4btSzC8eSAh0i+c1duRVN/2wopSkOgNl6h4GxoapvitejlAQhaaB6R5SSSBSV6vwQNZmxKC7P7zMj0b3FvgUdjICxHi0TI/PzDHKkLFiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LAMa6fgA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LAMa6fgA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WSSfn69F1z6CmM6V;
	Mon, 22 Jul 2024 17:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1721671054; x=1724263055; bh=hVqNIFOIvHQiFHB/q5ZBJ2N2
	RU0nj1/rFF4DiHBHLVs=; b=LAMa6fgA0LxhIcwdDMWzLfgVPLp84TGA9edgkfjv
	VERaRkWgFkLdIZL8prPZKIzJGwTaDiscwj2CnG59TEb8uu6hxiV4Vk4VSy7I0cVT
	DgOdxXCL4sYC35q5KFiuD9Cxu43bY13Kf5DOiXKH4sKqaVqE9APua6+YhOi9bmbr
	pz7JCig+Kk8sKFxT3cawfbSc9xIKJehjOE9MxqmL8MTx3nAP4vSudfp0b/yx6uSs
	72ZMU5ke4aezUG1uR8QJn56x0aLFSCnsR/0h2N6/qlImgVRj6wsWH6luWC0nu+I5
	/hso2fqTvPrmIfr3wu6rUuWUh89oMm3gZKZ0hV6WhYge4A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x_FUwR2hlpu2; Mon, 22 Jul 2024 17:57:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WSSfh45nHz6CmM6Q;
	Mon, 22 Jul 2024 17:57:32 +0000 (UTC)
Message-ID: <54704229-221f-4724-b386-48c39ee1290c@acm.org>
Date: Mon, 22 Jul 2024 10:57:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Do not set link to OFF state while
 waking up from hibernation
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Anjana Hari <quic_ahari@quicinc.com>,
 stable@vger.kernel.org
References: <20240718170659.201647-1-manivannan.sadhasivam@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240718170659.201647-1-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/24 10:06 AM, Manivannan Sadhasivam wrote:
> UFS link is just put into hibern8 state during the 'freeze' process of the
> hibernation. Afterwards, the system may get powered down. But that doesn't
> matter during wakeup. Because during wakeup from hibernation, UFS link is
> again put into hibern8 state by the restore kernel and then the control is
> handed over to the to image kernel.
> 
> So in both the places, UFS link is never turned OFF. But
> ufshcd_system_restore() just assumes that the link will be in OFF state and
> sets the link state accordingly. And this breaks hibernation wakeup:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
