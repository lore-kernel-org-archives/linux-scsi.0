Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782441A7052
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724865264; cv=none; b=UEHWTu8hy3uSNiKZmIxwR2wZseG86xK7XsBHGAb8KdlfsTGnhkMwqCkukBi721W05J+w0dKFnieYka59dArwWom2x1Ra3iONXZSAvjJ+Wmna1pj3u1DeEL3Z6wqvfTmSsKebz2rYbaI/Zdp2ioA18ukZ6/PyfVEY/J6bPpXCpPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724865264; c=relaxed/simple;
	bh=b3MV39xgHNgMP68BnN1Zb7XQlw/PLsGFPGYugu1+Cqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VAGkDwAVhIbLjuMidrNVWUT3Y7nag9oh1mAHPz02G+m4jlg3Ns1+RySqI6dkbfURCZjGWDIiuUmLn92mDk4k1Ih3QlmWgji9bfCRyyZ+BXFJCYRjyXmShKDvakpvAW/stttEc/G0q2bJImdAV5wuF3gXsmLDNb3R0Ig/SOlfPtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=L96ZEyjD; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="L96ZEyjD"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wv9xn5V2JzlgTWP;
	Wed, 28 Aug 2024 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724865259; x=1727457260; bh=cYJ+GnpX3dhdRl1mPbkO3Zvi
	Y1vhrHVh8UxFv2RI9dI=; b=L96ZEyjD6L8e9MXJ4+1kl9AdlcdCleB46FbiR/DM
	UPxvYPVVF0a1r+jk6/QbNxo7ApkkKf/nOj+ztv1CyxqoS900GfAnc+PW/werWHOX
	G6VtYv3q8j74LjfmBfKqgcf+3aG7SlRrJn7i868jaa4pLt87Xjrv/aduSdEWLZNd
	1KrL2GAxByRZjf08GLHK6cfHehvSp9z2zNTkB4CYeBHKEJgc387QAbkglWhKInaY
	czvm/MeuQgTTLePlpjNOZbjjN6++9CD5zQzyZKvgT76tlrN52KtCiPOuJ0bO11rb
	pGSooNl/qbVHYgrNp8kxQIb4oG+c/fT/G51hhxv4nngAuQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KpfwNK--I_p0; Wed, 28 Aug 2024 17:14:19 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wv9xj4D5xzlgTWM;
	Wed, 28 Aug 2024 17:14:17 +0000 (UTC)
Message-ID: <57f9eab2-d35e-4031-bb69-356bfd00781a@acm.org>
Date: Wed, 28 Aug 2024 13:14:15 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] ufs: core: Move the ufshcd_device_init() call
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Bean Huo <beanhuo@micron.com>, Andrew Halaney <ahalaney@redhat.com>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-6-bvanassche@acm.org>
 <20240825052259.2lofai4vv6wk24mq@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240825052259.2lofai4vv6wk24mq@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/24 1:22 AM, Manivannan Sadhasivam wrote:
> On Thu, Aug 22, 2024 at 02:36:06PM -0700, Bart Van Assche wrote:
>> Move the ufshcd_device_init() call to the ufshcd_probe_hba() callers and
>> remove the 'init_dev_params' argument of ufshcd_probe_hba(). This change
>> refactors the code without modifying the behavior of the UFSHCI driver.
>>
> 
> I don't see an explanation on why this refactoring is necessary though.
> Especially when you move it to callers.

Hi Mani,

I will add the following in the patch description: "This change prepares
for moving one ufshcd_device_init() call into ufshcd_init()."

Thanks,

Bart.

