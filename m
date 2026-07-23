Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3348032B114;
	Thu, 23 Jul 2026 19:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784834843; cv=none; b=iJmJfArjJtfcG9C4kcBs2vzDeHSfRo4EHTgIhlyQSPg60F76kZKI7F/jZRbo1208pnj+gjUvhvTG4dJKPval3f20jMIdp1ilmlyZ0w52SweBTcNXRmYR/cx+er8VPCYrGJUlbbGZODwpcvsIwcnzMhVlXNaHyNvjzOOjm4L76O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784834843; c=relaxed/simple;
	bh=Czd3KB20o8b349SMjsuPB/hzQTlenqgYieeRC2ZMWlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aufwnPIlNK57hPhO2zHC01IT3g27soEqVR7In5slhJNocgAD0A/H5647RHr3qZtlWmQodY19zimwuMG1cyMIpQ0wvPGoDnxkpdn7MMlzCvqHNqaWyeqBq5C4oAtmvyB+3EK8BX2R78VibVIUgNc0a4GeUpTLWiufxPaGGr2USus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NNS12GEi; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NNS12GEi"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h5h2x4JBvzlfq9R;
	Thu, 23 Jul 2026 19:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784834833; x=1787426834; bh=y5hytA27eNZqmqRFGoFdCBVz
	ws7RiZDNECrLG+llKcc=; b=NNS12GEi5ZWdm/ixUXvLwDE/BnW1YIXCdiPA30Hh
	cjTBpeuao1RPpnM1inV5iKliZZFBe8AIEx96D2MpTETPtz2G55JbBJ8ptfG7SI4N
	xNWMDS1TlEFldbvCN8IxeQ8cmYIiEU8qRA8R7s6k52g0S+9by3XpCUamEwwuit9f
	hvsvDp90vSm7ZHQhu3y9hpZsc/+iZld/bM5DdOEtB0pE9j31d5dsBqeP4bgmP8NC
	T2ZQUpgWNop0Ri8TbZlZvHaDQeT98mG0bkOQKNRAS+s1Alr9E32v/heuqBRFeT7s
	MVJImYden6nFlQlubl78qv8sa7JyQeUtzXgtZkLf0k31LQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3uVa6vLtG3BV; Thu, 23 Jul 2026 19:27:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h5h2k1yF0zlfvqQ;
	Thu, 23 Jul 2026 19:27:09 +0000 (UTC)
Message-ID: <94ebf206-5d9b-4ab3-a9ec-af80de45f3c2@acm.org>
Date: Thu, 23 Jul 2026 12:27:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Add support for the aggregated read query
 opcode
To: hyenc.jeong@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: ALIM AKHTAR <alim.akhtar@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jinyoung Choi <j-young.choi@samsung.com>,
 Dukhyun Kwon <d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>,
 Keoseong Park <keosung.park@samsung.com>,
 Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon Seol
 <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>,
 Yunjae Jo <yunjae00.jo@samsung.com>
References: <13d80afa-3d5c-405f-8845-6dccb048bd97@acm.org>
 <20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4>
 <CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p1>
 <20260723074724epcms2p16cc926dd07e3f932db8efb71d1e1268c@epcms2p1>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260723074724epcms2p16cc926dd07e3f932db8efb71d1e1268c@epcms2p1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 12:47 AM, Hyeoncheol Jeong wrote:
> Thanks a lot for the detailed review. I've addressed the comments and
> will send a v3. Replies inline below.

Please post v3 as a new email thread instead of a reply to this thread.
Replies are overlooked more easily than a new thread.

> On 7/23/26 2:09 AM, Bart Van Assche wrote:

>>> +static inline size_t ufshcd_get_devman_ucd_size(const struct ufs_hba *hba)
>>> +{
>>> +    return sizeof(struct utp_devman_cmd_desc) + SG_ALL * ufshcd_sg_entry_size(hba);
>>> +}
>>
>> Why SG_ALL? The data buffer for device management commands is allocated
>> with kmalloc() and hence is contiguous so a single segment descriptor
>> should be sufficient.
> 
> This is the one comment I haven't applied yet, and I'd like to
> double-check with you before doing so.
> 
> The aggregated read path indeed does not use the PRDT at all. But
> the reserved tag is also used by advanced RPMB. I understood that path
> builds a PRDT via ufshcd_sgl_to_prdt() from the BSG payload, whose sg_cnt
> can exceed one when the user buffer spans multiple segments. Keeping
> SG_ALL preserves the existing RPMB behaviour; I thought shrinking to a
> single segment could truncate multi-segment transfers.
> 
> Did I miss something about how RPMB maps its payload here?

BSG uses struct sg_io_v4 and that data structure supports I/O vectors.
How about changing SG_ALL into 2, which should be sufficient for 4096
bytes spread over two discontiguous physical pages? I think it's fine
not to support the I/O vectors that can be generated by user space code
like this program:
https://github.com/linux-blktests/blktests/blob/master/src/discontiguous-io.cpp

Thanks,

Bart.
