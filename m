Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD21346E47;
	Wed, 22 Jul 2026 13:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784728471; cv=none; b=VtZP89+EUPIfcjSnk9m0IlB8ljPDW07ekhoHttxoooehihW4bvdDrTUQfeC0CdOmCYg6BtLt+RQ+03LL2ms8zi+lhor68oC2P4A/DMNFx7JFheV7qMV31bbT5AcvRLGC+cf89XiYTSM11DATOBN7I968nmp4NvDwjFnKAoOyiAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784728471; c=relaxed/simple;
	bh=ZiOmcQUNLPFwJOQnLV1BfQbFd3dyE/X9/hJs+4JSaiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f8wDesrX4u1OxadapX8pLYE3RD70LKTnHCccgPOhzpVNcWvOdtamhOQuH4bRtdZXEvUMIlrdig1jbqXh8fmHZixh2WtW3Mn1HXJR2RO3ULKEDh4TstDD/HP4zfLJkL4oTGNOzaV5YO+o9oZElvBT3rc3A17eemyen+JaT84ntKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AAlzHy5A; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AAlzHy5A"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h4wjK1qQMz1XM6JT;
	Wed, 22 Jul 2026 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784728464; x=1787320465; bh=ZiOmcQUNLPFwJOQnLV1BfQbF
	d3dyE/X9/hJs+4JSaiE=; b=AAlzHy5AqHXtQV74UYFU1StFncwdIXNbU72XLuDa
	Exu5aW/95rjA38PLNuDPdOBmGkp2vLnXa+5IOqNGWa+U4HIHe6+N5++std1FiQFF
	4ZQziMgl8jBTyn9wDBnDIy6dVKib2nBhxNJ+nx2Xdoba0pRHy1p1m5qrSOnznHpl
	YeAsL63+tXc+RUWkrXin5/44Szvokb1gxNyXpxextcUfaojtf+GkErNnqfrcmSts
	sOuY/QRrWfq98v5jS+L1omoi5cZt6gd8TrB24/DEHfgSIoD10hAF0ugJ3RtoT9Ko
	hrq1VyZOYZ14TvShZFrCoVITOS6Ad16s7RD7wHU9b3WyXw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k9oQ5PmkpjNw; Wed, 22 Jul 2026 13:54:24 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h4wj66JY4z1XM5kD;
	Wed, 22 Jul 2026 13:54:18 +0000 (UTC)
Message-ID: <a74b5d01-feaf-47a1-ae40-09f737ad3a6a@acm.org>
Date: Wed, 22 Jul 2026 06:54:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] scsi: ufs: rpmb: Use unaligned accessors for RPMB
 frames
To: Bean Huo <beanhuo@iokpp.de>, Li Qiang <liqiang01@kylinos.cn>,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
 <20260717153914.26321-6-liqiang01@kylinos.cn>
 <fd02332e6bd8630c8b3d7dd89e9f7502bb9d1166.camel@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fd02332e6bd8630c8b3d7dd89e9f7502bb9d1166.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 5:33 AM, Bean Huo wrote:
> consider Sashiko's suggestion, it's better to add __packed on struct rpmb_frame
> {}?

Do not add __packed to an entire data structure. Only use it on
data structure members that need it.

Thanks,

Bart.
