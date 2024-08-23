Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE1C189539
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724429253; cv=none; b=pnCMB2FSdwYiKYfj2/NMSLLuqmWVceLRL1FoVX6pvx6OH1SCN1YsV4fa06Nd0E6ehtNHjLp8LlABVLyv+smc5jVqqeYamYrbsfR+QLOSeybFPACTjXtQb/xpKA5nbGeQqusPozsh1UssHAlkAePjPlrBjScA8ShO0Z5q9Jdl2Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724429253; c=relaxed/simple;
	bh=NalStFmwN5fGwKcWlo4Md56DXunY+lL/lwpG2hXuEmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lbxl3CPsUVKn9ZcztDTKQl/0Y/kaWxCroT1S7wkt2BWcPVOO9zQcbvt3Yj+Bo814pw2GT4kJAQiSPnWPM7E1LSeA1ryDokFfU0c8aVYcvvAxoWwqx7r/7tzBI1yJyWOXE0Y2kYSgcOvEv10oK3W8fRgt93ghCGe4fMz5c+Pu1Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vyhxUk0G; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vyhxUk0G"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wr4hy0xHMzlgVnK;
	Fri, 23 Aug 2024 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724429246; x=1727021247; bh=NalStFmwN5fGwKcWlo4Md56D
	XunY+lL/lwpG2hXuEmk=; b=vyhxUk0GpgtyOwWhCDMmkiIEwdVO8F1MdR9lKiS7
	f1sjVDfTIHz0UxXQQ7ZSQQBGed1lzeoIpKc/9YARSCBpb0+m6pI/cWUlN+4wtL3b
	ByG96gYp51X90X9YcXegbIsI/erFB/gCAgd22LB0NFxv9R3rfqDirIkR/h6Qnvw/
	0I1caqidMef1luMP8tkZizzwWqpRWRzKx1HbZ7/xwzfKrnVvlqHMuJgeVblsIEhC
	UvaPRsOqGJHpn1F1b11ATst9Nd2OVri/3XDDWWmgTGdt6h0lyDdUlPPauIBsCuo2
	o4PEaclp+HaFUV7Np7qtOMTpYPWKrzjGlU4wkjJjBV2Exw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4LpR99OLTTs5; Fri, 23 Aug 2024 16:07:26 +0000 (UTC)
Received: from [172.20.20.20] (unknown [98.51.0.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wr4hq0NqNzlgVnF;
	Fri, 23 Aug 2024 16:07:22 +0000 (UTC)
Message-ID: <c5699d57-cd51-4bff-95f4-372a00b2a3dd@acm.org>
Date: Fri, 23 Aug 2024 09:07:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
 <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
 <20240823145817.e24ka7mmbkn5purd@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240823145817.e24ka7mmbkn5purd@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 7:58 AM, Manivannan Sadhasivam wrote:
> Then why can't you send the change at that time?

We use the Android GKI kernel and any patches must be sent upstream
first before these can be considered for inclusion in the GKI kernel.

Thanks,

Bart.

