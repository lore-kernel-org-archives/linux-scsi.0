Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DAB21CC59;
	Mon, 27 Apr 2026 15:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305492; cv=none; b=t8u01wbYnFiGq+glHM06pH5/0muBXm5eUPyuNnTucJ5JB3Er91PPk/kOdl2I/0E8x4loBvCbApEnDabXS4JhCKx6/oA3J5wKY6mvHoNoi0x8eqtgQOhA49UPxA48yM52lgZ/+dlvWl72XkwSLZuMT6lk06bc7dZkFtf4Oa9Es9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305492; c=relaxed/simple;
	bh=TF11j4CvUj8BTSEcQmRALUhmKdMCA04UOoGdGpIQa8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o7drHcPX8it1uz2VEHr/Aq1sPZhknc75GtqUVUsty8ASjrVxoXc11JXVU/s47nmMwpbDE4QeldjDrPvDCXMgYNIqmuemGdOeqn5MFD5wSmCWaEK1XMWjFi9qTqDNrZvA7qepO09F31BicnkfuGlG/y29BWPQpSKdsbkNLqcxa1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tiOg3ecp; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tiOg3ecp"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g47Wd0ZsJz1XLyYZ;
	Mon, 27 Apr 2026 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777305480; x=1779897481; bh=rjXgKqdqQ8sY81zFeoaYcrRe
	gheJCN+9CyVz0rbXQH8=; b=tiOg3ecpb2tSZPSwTpc1m3MiPAfs8b3eF/y0Ybd5
	5x1b/FxLOvQCRIylv15ShfysD7EVptODc/igIurTtXhCJ2BbKkGzx9na6tME+0Y3
	SJSCCFEgXJGr2BrO+PG71dzC+HHQcfA89EA7t6zF9JrXwfJuTnedFKc1O/MKX8UB
	yoqDF3a2REsMepdu4rlMs/AyvHdjQBuPkmC7GL9jPaN8+9J99qZfdyVyDBYfy0cg
	H6T5Qy8X+eNYIjmODyUsMneCUgLFNFwcw6hkudfZAV1rETbIG4FrgtuWrzt1azdD
	A/IzJmhlw9FwmQVqwSfbvn2Ldn63AaRg8eBYPhc6ugA2Iw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Quj1atqgB4xW; Mon, 27 Apr 2026 15:58:00 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g47WS2gjVz1XM6JY;
	Mon, 27 Apr 2026 15:57:55 +0000 (UTC)
Message-ID: <20f52429-10e2-4407-b2ab-63bb92b85d6e@acm.org>
Date: Mon, 27 Apr 2026 08:57:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 2/2] ufs: ufs-qcom: Enable Auto Hibern8 clock request
 support
To: palash.kambar@oss.qualcomm.com, mani@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, shawn.lin@rock-chips.com,
 nitin.rawat@oss.qualcomm.com
References: <20260423102023.3779489-1-palash.kambar@oss.qualcomm.com>
 <20260423102023.3779489-3-palash.kambar@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260423102023.3779489-3-palash.kambar@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/26 3:20 AM, palash.kambar@oss.qualcomm.com wrote:
> On platforms that support Auto Hibern8 (AH8), the UFS controller can
> autonomously de-assert clk_req signals to the Global Clock Controller
> when entering the Hibern8 state. This allows Global Clock Controller
> (GCC) to gate unused clocks, improving power efficiency.
> 
> Enable the Clock Request feature by setting the UFS_HW_CLK_CTRL_EN
> bit in the UFS_AH8_CFG register, as recommended in the Hardware
> Programming Guidelines.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
