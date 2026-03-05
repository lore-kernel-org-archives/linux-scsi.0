Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6BE14AD0D;
	Thu,  5 Mar 2026 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772723687; cv=none; b=LAe2/GX5ObrYu2+yZXGleHmJl5nvdAoAxtezhsDmVGdF/+Vpfpg/mIVlzRXQH7LMMuMfndoqv/3palFT85Sq+zK9M88t9LmJN5Bl7tod1g3V81E/m53a86CVU6Pkfg3L90Qh6uOM4u6jPSJKAG8ipUCzLQqhjXfZq1H2RRpQJws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772723687; c=relaxed/simple;
	bh=v5fiTusf3SUlj7LOoi4Pz7OFV4Mk6FNs2lzMlu4WqS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UCCU3ekL/rdhXk6jo8pZS13I9b6CA3+nvQVkPnexEdupkPM77epyocTIY5V6DSLuG76SP+eLoBu2hwtgKhw2LmHM0jc6FSfNFpIPlFHrCEf46SpCn/QDiDBpSLQVFRzmffMgsUvZVkrxr8JqGysAizoZtf0uEoDCMtBinO+WLIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=D0+H2Rvh; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="D0+H2Rvh"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fRY4346lGzlfpMC;
	Thu,  5 Mar 2026 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772723680; x=1775315681; bh=DPzbLDDszlsvDWq7bdJvBb0y
	IsKHzHmnlDoCo3RxSow=; b=D0+H2Rvhgnq5+NATqnNgCPMvz5aVPvWzp9QI0kBv
	JFmSQqc5B+NNhir80iG4jQjj58IkuXmOLo6Q+qTbnNEhIiFs9rsxYVLtyGyG2cW8
	dHG6ZFpKMGf10kwA2d85nqWkbhKGyMBjAl5CgBOilK18u3gXusbXMFQVnl3DyA+0
	hZG8NrX8efSvVipuDTM33qZROysgzu/Caerduu7j0dSCyUj2wrG2xcmcqRlezDZY
	hpm3ikkXq5/pKaE5ovxbMtdSrNoBOn6XyI/mIIvUxh1bC4YGRuIfUSwfSGg/4EtP
	LefWQMBF1wVSEPfMcx5XybzaGSW39+KLd3mq9w+Thbi1Cg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id grZY08_P8WkM; Thu,  5 Mar 2026 15:14:40 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fRY3w738fzlfpM6;
	Thu,  5 Mar 2026 15:14:36 +0000 (UTC)
Message-ID: <7ca36cbb-c9d9-47b8-be1b-b51ab8da16c0@acm.org>
Date: Thu, 5 Mar 2026 09:14:34 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] bsg: add bsg_uring_cmd uapi structure
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, fujita.tomonori@lab.ntt.co.jp,
 axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-2-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305012857.2136525-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 7:28 PM, Yang Xiuwei wrote:
> +	__u32 flags;		/* [i] bit mask */

Please document what flags are supported and what their meaning is.

Thanks,

Bart.
