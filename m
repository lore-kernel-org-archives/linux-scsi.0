Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865184C10C2
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 20:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790800984; cv=none; b=NCABzgi7ZiuMpfDMHfDY1I/Ocuan/5MEKoKi2ulP3GI5+sX+VMaB9AFogKYoiET2UGihrrGOUhKdm6FMh2UD6d94Lbdbhflxf+G2ReRncBFwEdQuf8SWrTFMiB55GBO0hiDHqCs6UXoWIWfnHLVoQCsO1dgYpdrAPQjsdUIUtPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790800984; c=relaxed/simple;
	bh=tcns0GktuBweH2ysbWg49ANQUJpuXowDhwNTUTVd7ws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E+gQbyCDGPIoREIjjM3ofr9rsihuvetTUl5vh0kHcLvYFvJkzgbSdJNa7fo2o3xVl+vkQu7+dPCUMjSPTYOTOSBkkfy62Ix3Vrvb6kVn9RwCshhWyvUhfL3I+4nleadKZgXITHUVXCOXBF2HY6sd5z5qCJ+u2eYA67JVQCZywJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KFRgn2x8; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KFRgn2x8"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hw6SP6RKBz1XM6Hv;
	Wed, 30 Sep 2026 20:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790800978; x=1793392979; bh=MyP0ICdPJ9BMPmoS8S2f08XT
	3V1b67VA62u9GQh/MVM=; b=KFRgn2x8oU6TIuzz7lXctX05TJwjPejIiOouKMH9
	ddumtsA6/gAcI1gnUn4jVBE06MlPkJZqw5ftaVxOXRjDzQmway2dTJSWmsaMgC9s
	vopKAJ4TQQC5i1UUX8tYBWxx3ddntnC+RhhvfbIcub0sJSif23Jw8/h1lE2N85vw
	5Halu+Q/BPr7PyUkhyMp3KlWJ8fakTRI9loewFsYaXtuYDBI2WqOaQ4/lSoYUGk/
	Y9AbVBQXl5cYaBXitj15hUTIA/bUsmvTTe8TViZ1rxwTFj/FCJKwLLEG/Wn3UNb+
	3P3g9OHm7Lqr+iZM5gduMDKfjmrcAjLlSYW3WQEOpIE+uQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KyEU_um4GoYe; Wed, 30 Sep 2026 20:42:58 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hw6SK1fw2z1XM6J2;
	Wed, 30 Sep 2026 20:42:56 +0000 (UTC)
Message-ID: <24dee94e-1f71-4bc5-a628-b5c95ef22a72@acm.org>
Date: Wed, 30 Sep 2026 13:42:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly
 to several functions
To: Khalid Aziz <khalid@gonehiking.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
 <argk3DLMl_YSDOsV@gonehiking.org>
 <97ab2119-2067-4c6c-9edf-286666f94e40@acm.org>
 <arq4GHK0OLyusPBh@gonehiking.org>
 <f0c2d0ab-659c-42c4-a8cb-4978dddc29e5@acm.org>
 <ar1tfqjrKkyTxUid@gonehiking.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ar1tfqjrKkyTxUid@gonehiking.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 1:13 PM, Khalid Aziz wrote:
> I am currently traveling without my laptop and it is hard for me to do proper
> code review. I will get back to this in about 2 weeks.
Hi Khalid,

Thanks for having responded anyway while traveling without laptop. I
agree that this makes it hard to review code properly.

There are several options to proceed:
- Leave out the BusLogic driver from this patch series and revisit this
   driver at a later time.
- Modify DEF_SCSI_QCMD() by making it pass the 'host' argument directly
   to all SCSI drivers that use this macro.
- The approach of the current patch series: open-code DEF_SCSI_QCMD() in
   the BusLogic driver only.

Please let me know what you prefer.

Thanks,

Bart.

