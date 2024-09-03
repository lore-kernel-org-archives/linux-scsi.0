Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D8A1DC73A
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2024 20:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725394600; cv=none; b=FFRRoLZdXxuRb20rPY9mqBGfssnJhj4ARwgRePLHbel6Arez3DzFh3l25y187NRQ0TjCM7Zq+1OD8LdFdrIa/d90SU7WNzxeaE7ejy5ZqPZnWrygU1AAuuprlSxQcf+PPt7/L0js/mFRVHazxQ9EL3TmQ3W+QqkBiGk4vHPoUdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725394600; c=relaxed/simple;
	bh=0ko0EyhiJwPB4nc+KXPWZO1o2AFefE2qhzAikGgCDtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhvkcd8CYlzROO4V1wpyR6LX7OsvRt676WRN1rlVQXEMu9YIMrBVmBY4pm1ZBruVwvlozhscP15fo6JKfEcpw6mqbyHyJv2Tj62yRxzS5ck3yxWC/AEOzTPhxmWASXMz7xsTUxEzHlv48nX5ho7gh12mgtHPf8m4Vp6fiNsq5jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M2i9v6Q/; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M2i9v6Q/"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WyxjL1NXWzlgTWR;
	Tue,  3 Sep 2024 20:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725394595; x=1727986596; bh=0ko0EyhiJwPB4nc+KXPWZO1o
	2AFefE2qhzAikGgCDtI=; b=M2i9v6Q/Mra4s3oIl8BsBwjzf5DPsw17U85XNIOq
	7oMHqwo0jZDJvX7FP8mmSlcDrVvAzRIlAwoxGVtc0I2XBQuBwzJo1iH4G2k97R/t
	+WVKFx8x3GqXnKn0a6E8PtHcq7BsyH/pNvR7mb6qJNuWgmndIhXIcg/7YlnPHLJE
	NM8ifiM2bdXTYloICY3D0sKIXCp/Ln/VaqItxilGaf0aYHVq7oehj3QJ3ec/klsg
	bLiTFlDgD49LREOBsU0+b5PUvFhgWNHeMHZJ4SJDQ5bWh21GMDVRiuSf8QjYJ90P
	1VAVxduacCCIBscYId9SX+u8ticCdwPBgC72kzF7JhGFbA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ya4B4m5Q-jHR; Tue,  3 Sep 2024 20:16:35 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WyxjG55zLzlgTWP;
	Tue,  3 Sep 2024 20:16:34 +0000 (UTC)
Message-ID: <ebee86a1-8023-4f34-ac00-f2f7e21e56b8@acm.org>
Date: Tue, 3 Sep 2024 13:16:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] ufs: core: Call ufshcd_add_scsi_host() later
To: Bean Huo <huobean@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Bean Huo <beanhuo@micron.com>, Andrew Halaney <ahalaney@redhat.com>
References: <20240828174435.2469498-1-bvanassche@acm.org>
 <20240828174435.2469498-5-bvanassche@acm.org>
 <071d970ec412f311ba1b1a2c0ffdad040ee503b7.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <071d970ec412f311ba1b1a2c0ffdad040ee503b7.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/24 6:37 AM, Bean Huo wrote:
> I don't understand why the first 3 patches can't be combined into this
> one for easier review.
Combining patches is easy but I'd like to keep the first four patches
separate. I'm following this guidance from
Documentation/process/submitting-patches.rst: "Solve only one problem
per patch." I don't think that it is possible to follow this rule if I
combine any of the first four patches?

Thanks,

Bart.
