Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A38183CD9
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 21:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728510629; cv=none; b=NXe9vuckBEekClV/hJsP8ClufI9Fsr4qCfcykl39UYg/cQ6/CvVa6L1QHaoPaZ0KCey1FkbOZL3l7E4EhsYk75CmSWv9/DFeqcjC1FsGAKF65wH6xRDeDIk8m8VbrUeMBE43NmUe7DtBudWg/vvzgR89m4geRFOCEvwOj5SrcLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728510629; c=relaxed/simple;
	bh=YmEJLKuUYkqoz8zBQjc7jwo8NfRlggzGq8zw/9Qq+3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sl3J/3/+5HM4RTSWU+aMfrQE+YNm1IIQhRwT4uOU96Ix5XQkshaKJyaKSrUlnikcxiWLBePbOfgaTqvoIVLJnSUJ3G/p+5oj65eoA4F0o8a8nv2GBNjJyvADI3CgOdKDkRMOY+MorSIl2oXx9afCo8pNo4ttzRPl6SNlX1N4VjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VeITjESP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VeITjESP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XP64y5tGqzlgTWK;
	Wed,  9 Oct 2024 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728510624; x=1731102625; bh=AtjkjHxzl6+1/EsSacaG0r7c
	JCGghhmwtIWSIqK3YV4=; b=VeITjESPyFcxCW+eEGNhacLXiTljhKo3VP0wX6TM
	clKy299fi7TGKHSTgboWsoUkwkUkEZu7/NE+Mh79Vz9Hq+3spyI7kmSunLuRZlDq
	YuezACsDMPOEr04hTg+uUQUbkxqeXuDA8Fhw82T8vvYNl6IFYKkkXaft0tSWgUW/
	lOytKKz3XBdCvkMkn7bSZbIGNa8f7hG3cC/K1Wt7E7UbPA7QgGBeZ9UQ3uCIQ3X6
	lDbfWRpuo6PiGEnn3LdThuv+Ey5gVqNuwC/I6GjFlOvG7VCoEZaGBxh6cf5abGYp
	mYaDam2Omb4XXvekOJQ6c80iUus1i5cq6k5ElpOK/ApCtA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id T23z17kmSTXh; Wed,  9 Oct 2024 21:50:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XP64t22YwzlgTWG;
	Wed,  9 Oct 2024 21:50:21 +0000 (UTC)
Message-ID: <f8ba6516-9462-47e1-8680-7ea0f353a956@acm.org>
Date: Wed, 9 Oct 2024 14:50:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/10] scsi: ufs: core: Move the ufshcd_device_init()
 call
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
References: <20240910215139.3352387-1-bvanassche@acm.org>
 <20240910215139.3352387-6-bvanassche@acm.org>
 <63cd4607-b65b-57ce-493e-ae5da8c54ff9@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <63cd4607-b65b-57ce-493e-ae5da8c54ff9@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 9:38 PM, Bao D. Nguyen wrote:
> Hi Bart, IMO the function name ufshcd_process_device_init_result() is 
> not correctly describing the original code. As you can see, the "ret" 
> passed into the function here is from the result of the 
> ufshcd_probe_hba(), not the result of the ufshcd_device_init().

I will rename that function into ufshcd_process_probe_result().

Thanks,

Bart.

