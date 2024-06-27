Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D7519754D
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719506040; cv=none; b=uT54UOcnrHokFJoV1iRWya+b75wy0kV1aUXul4tdPgeKGNa9H7SIMzRZn0JH8xsuYHsXn6haRxQvnOt6zmtF2hW0AizybxiT/qPzgzLm37ZvJ0r2uB0Y1XQ4ozB/L6xzJUMeOLlp7ZQ3/jgWjbPzu465eExsFR6a5qXQvtb3iYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719506040; c=relaxed/simple;
	bh=GyHFowmgGlhc7QWcvXK+NGV27EOMLlX50iBAG1bpQgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGyb7S9qFRRMUyhZqVst/InyBbAEZxWlOuO2NvnAOeL9lSsIBdvmQZXGrxQFP6YdFfrvMFtS9IBxlT66HQiNHvsPwkcrjiOgbPfOoEb2W23o79S98T7iU1a4e4mqdpvL0beAYTSrvPw5loO6TTQgSgn99PMimNS141yJiqcmDFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n9XaBqBd; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n9XaBqBd"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W93zh5cmFzlgMVf;
	Thu, 27 Jun 2024 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719506030; x=1722098031; bh=GyHFowmgGlhc7QWcvXK+NGV2
	7EOMLlX50iBAG1bpQgk=; b=n9XaBqBdL6RZtyiMRT4R+qlrg4wATD6leCY9/T+A
	GTm9XUIzWqyuSPChDSSbGUin8GFEYn2kVScahUATsxfd/UOFrf1O0/FWejhnzbi/
	1lmQ0+9y/azBHQqN9zo4GYWAD3c+kypRjM68cUoaFoAyg5EcRgpF0E9Dn5/YE02a
	BVwzgSMoHACCgB3OEXPvx51JQQ35daWuc8veHzFdIbvzuXkIH7O/rHuKnjcwgnt1
	qWdMv5Dahdfv94kn3a8mAo9ww/fHXTpUvm4797YZpUNBOPquAbr+3ikPnd3N/jQq
	B5pLwv8jaq6hXgdep7uFaO6rv9AXA3ZwOeOiaGm5cAZXXA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 334YhmbxV_qx; Thu, 27 Jun 2024 16:33:50 +0000 (UTC)
Received: from [100.125.79.228] (unknown [104.132.1.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W93zd5JsszlgMW9;
	Thu, 27 Jun 2024 16:33:49 +0000 (UTC)
Message-ID: <6564ce4b-4340-4287-9358-662cfc698aeb@acm.org>
Date: Thu, 27 Jun 2024 09:33:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-9-bvanassche@acm.org>
 <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
 <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
 <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
 <671bb45f-22a1-4f81-ae93-65bd5a86f374@acm.org>
 <167b737c45ff3c9b9422933d45b807929d0b83de.camel@mediatek.com>
 <b302c1ae-2cbb-4906-81f2-285c2b913109@acm.org>
 <5bcf25bb6f0d3338febf350716df8590a41af852.camel@mediatek.com>
 <edd84a4b-839f-44a6-b7fb-9e875a2598f9@acm.org>
 <c8d6926ce0db4889238b18c573fb967574956361.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c8d6926ce0db4889238b18c573fb967574956361.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/27/24 3:56 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> This is really weird.
> Perphas it is dram corrupt issue?
> And is unrelated to the ufshcd_abort racing I think.

We have seen this crash five times with kernel 5.15. I think that
the number of occurrences is too high to be caused by DRAM corruption.
Anyway, I will leave out patches 7/8 and 8/8 from this patch series.
We can revisit these patches if the issue would be observed again with
a later kernel.

Bart.

