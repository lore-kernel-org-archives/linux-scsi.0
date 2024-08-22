Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B349F1CFEC1
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 18:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724350435; cv=none; b=Jc4WBQtutBHvHeO2KIf04pXStK+OxsB7vR3TffXWWRS7UwxhGS4R/JqlN5Ky8crxC2ptiWqcPkqlfyXg2XIhYZehjFx3SgKwu9Y6uTBbRW3O20XWjPqO9GH7mR8Yk2/5N+rHrEjRQjNS19WnmJNrBBk4iLWm4zlOF6y31o07f/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724350435; c=relaxed/simple;
	bh=1SYoHDeVydOspYhNlylT3qcIX+QdmzlwF8VV+pMjaHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D4fHUYx+gXKOYQRP9dNtekplf4+gHFincZLAIEnUo+u8DYnPeysm3s/N9pPjpO5qSWnV1qG0xGyoioqjhyVf0LejBiAJi77PweU2iYzvjwPzm7pR6J6J90JXfg8ENAW2gbRkE8wkgIPpXRQboI2z+YCepDigETHtGCHjzAipZuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qJwbkpQ2; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qJwbkpQ2"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqWYF0L2Dz6ClY9J;
	Thu, 22 Aug 2024 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724350428; x=1726942429; bh=+WlUdXiSB8OXpwpRTqKbO2A3
	g6yx99SuCK1dmZEPpH0=; b=qJwbkpQ2opoPdxlbhfV9vPPPbQ49iDyTot+ItR0Q
	Bgm65aD4Py9XzYSg6ER9Vm5Hj8swoAL0TYuEuy+FimhPM0EMf/WOYOoGoQedKmb8
	N9FSFfHeNvC0RN8xqGuNR1JzkFKsgSuWAtxYGnjcGqAHC3FM5eEwPc6dzdcuWvrT
	XhooRX0vrGbNZofBmFIC9a+KDTelcmA+DNP1YBRi7ApLr/CfFiv9uzoPO12E1Ke/
	zsCJXtCmHiaaYBHkEYCiBn8uFL5oV7S55hXniaGHu108oRxIiS5/zwRCXT2naCd8
	+kgjnMfFMx+K3gUFtp0C35bY5riZD6BtFCPnLwAQN8WUqQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5qAgiLESgt6U; Thu, 22 Aug 2024 18:13:48 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqWY66llFz6ClY9F;
	Thu, 22 Aug 2024 18:13:46 +0000 (UTC)
Message-ID: <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
Date: Thu, 22 Aug 2024 11:13:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/24 6:05 PM, Bao D. Nguyen wrote:
> If I understand correctly, the link is hibernated because we had a 
> successful ufshcd_uic_hibern8_enter() earlier. Then the 
> ufshcd_uic_pwr_ctrl() is invoked probably from a power mode change 
> command? (a callstack would be helpful in this case).

Hi Bao,

ufshcd_uic_hibern8_enter() calls ufshcd_uic_pwr_ctrl() directly. The
former function causes the latter to send the UIC_CMD_DME_HIBER_ENTER
command. Although UIC_CMD_DME_HIBER_ENTER causes the link to enter the
hibernation state, the code in ufshcd_uic_pwr_ctrl() for re-enabling
interrupts causes the UFS host controller that I'm testing to exit the
hibernation state.

> Anyway, accessing the UFSHCI host controller registers space somehow 
> affected the M-PHY link state? If my understanding is correct, it seems 
> like a hardware issue that we are trying to work around?

Yes, this is a workaround particular behavior of a particular UFS
controller.

Thanks,

Bart.

