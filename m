Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D777483BF9
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787843520; cv=none; b=gB8xs+OrjbxKBJFnA/Bn5YTqvPU85r0jZB0lrBNFDuKIIbAQWgxVoMizk8kABYX6pJwVrrA2RyGehxAEn5bssYyV760XEy+5/mQ75n1JE7vFIcWqBPLnS3JGgCSE4xvGARvyxlvjnPV5m1BvGsqpVd4MRmEY+ceiT9DaiZXlI40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787843520; c=relaxed/simple;
	bh=JhZvP2FJGXSKKRS5Huu2ctPL+qN8l5jQDeyIEKH15N8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VM8e9NS7z6gfn7ZrDK+Zz8n15+SAmSzTBMK3lKopenq9Qf1AAskvIoBwR1PIrM8T35ivoW/8JpZ2b2Lo9lg9ZrambPAUcUYmfk0hfZGiaAW8Msvv3KF2Bath9BrbDfntYsnqKh9Sd6LlyAwFk3XgYMjYeCRy9TSIS4T0kFgEEdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lj7KSvod; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lj7KSvod"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hW4k56h8vz1XM0p7;
	Thu, 27 Aug 2026 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787843513; x=1790435514; bh=E/dcvS1PV2ymrV0fgwp9oSdY
	hyFeVNJNpUq8bGgTrwc=; b=lj7KSvodAJtEZAfAMycz0NKNHJH7honw3793EFHY
	ff+Uym0DJFp6AZ5mJbrzjWAHdEq+SWI5i/uH25W2ngF1gIAPtHMfMCTw6sQhJ/FM
	owTTxe13DuRQtz+t2ChbchnwrSua5w0mK6QpAX4UcoHUElPtMgRXFlENM0X+NQJA
	kKfPNeuNkohJEi5zeEQqzrSxL212Llnp/atZZT0m7TrGVXKJOHdGbqShW7DIpz+0
	Ff1FZc+Q4GX9BSkr5GRoSu8wVYBQbdLjVIn18GL5hHJWyGpCM2ajqoXFy3LWVQQw
	9y6LFtSSP1LQ7jMuTWD0gHq+aBNGnUvs6AAx3Pho2dUgyw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QhQPaf27E6RB; Thu, 27 Aug 2026 15:11:53 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:e339:4c36:2f7a:7a6d] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hW4jz5Nhlz1XM0p2;
	Thu, 27 Aug 2026 15:11:51 +0000 (UTC)
Message-ID: <2d3cf1bd-104c-4c86-9211-e874d9bbabd6@acm.org>
Date: Thu, 27 Aug 2026 08:11:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] ufs: unipro: Move Tx/Rx FSM state definitions to
 unipro.h
To: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>,
 Frank Li <Frank.li@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Frank Li <Frank.Li@nxp.com>,
 linux-scsi@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-2-larisa.grigore@oss.nxp.com>
 <ao8AtFsYdr26rHVc@SMW015318>
 <d52642ef-40b3-4c13-8335-aa6e74739f50@oss.nxp.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d52642ef-40b3-4c13-8335-aa6e74739f50@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/26 6:59 AM, Larisa Ileana Grigore wrote:
> The reason the two enums currently look duplicated is that they 
> represent the encodings of two distinct MIPI M-PHY attributes, 
> RX_FSM_STATE and TX_FSM_STATE. The specification defines identical state 
> encodings for both RX and TX FSMs, which is why the values are the same.
> 
> My intention was to preserve the original approach and minimize the 
> scope of the changes in this patch. Since the existing code already 
> treats the RX and TX FSM states separately, I kept that structure when 
> moving the definitions to the common header.
> 
> I will clarify in the commit message that these encodings come from the 
> MIPI M-PHY specification and are not DesignWare-specific.

I'm fine with keeping these two enums separate.

Please add a comment above each enum with a reference to the section of
the M-PHY spec these enums come from.

Thanks,

Bart.
