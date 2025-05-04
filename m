Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57D9219E0
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2025 03:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746328402; cv=none; b=mN6YpjKnx+gGvx5XwVA/R5X/T4CIc1FplyBqqJry//Rew2hmKNlFmVD0Jv2Pug4b/4rGFC+T6yyWTmEgz5YaP4VabKI0128zmkNyeUf4Hv7VQaPIXkLpmxtsObTwsTCK9DGAYa+8vtn1d7jYPd0KVpOtZDRkzG0pqHFVzFQa3/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746328402; c=relaxed/simple;
	bh=RrcqRJGufs2ydR7KM07QOCFo+ICCo/ra2SZXwCiaWFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=awajRPRpQxMgAsHr40IAuz9+dlLf16MLm25lbqe/IWJK3aNjEk5pbf9DsZl4SzYmK/ShhgO3EvOcDCd7El2uvpm8XRkWjYPhNLxyRyjnwaKiC7iCBMfYsJwAnIKbyigfujYBuw5kDwYuSFTU4lrGtT0n3Di5Xq796pbUSR8UQ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aGFLr2Py; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aGFLr2Py"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZqqVQ5ycFzlgqxm;
	Sun,  4 May 2025 03:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746328397; x=1748920398; bh=RrcqRJGufs2ydR7KM07QOCFo
	+ICCo/ra2SZXwCiaWFc=; b=aGFLr2PyTGq2k4fNyERG531gqOwR8hUCWTfKTtrA
	IaCNnxhPtpmDQKsZbcNu9KNFBpZIi+TonJh7VW/T69eAlyzbBLP6ns/r5Mi+rP7I
	WsINzmPTKvU8xP8c8ueURoJ7InSMSok4ZKpNInAp81DhJo473D1C0UeS++GFoO43
	hMfpDKymidDMX23CPeCunML/nSjOf80/PTh8tLZJLcsl+VIml+wM48nwzZWcDB6B
	4AKVwc6F3mpff1TGe1IMyjUBxdPt6Jwvg7Q7q+CyZLtieyBpZT+Tuutg1Rp1zheP
	WfGz0OUtIhT4rqOK/yYo5v9d8KLf9anPu7fSRF/Ymd/9Fg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kbmywtjkzieS; Sun,  4 May 2025 03:13:17 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZqqVL3YBGzlgqxh;
	Sun,  4 May 2025 03:13:13 +0000 (UTC)
Message-ID: <0ede0a81-d0d2-4425-88c3-2e2e6f741427@acm.org>
Date: Sat, 3 May 2025 20:13:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: Reduce DEF_ATOMIC_WR_MAX_LENGTH
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20250501100241.930071-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250501100241.930071-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 3:02 AM, John Garry wrote:
> -#define DEF_ATOMIC_WR_MAX_LENGTH 8192
> +#define DEF_ATOMIC_WR_MAX_LENGTH 128

Shouldn't a comment be added next to this constant that mentions the
unit of this constant?

Bart.
