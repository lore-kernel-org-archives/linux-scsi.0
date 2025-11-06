Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D0A2D2388
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 17:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448463; cv=none; b=FUfgTu9gziYARW0XvzVyNVoP8ap2CQWF4hql08UyCaeZgs46XIarDhw1xdKRkv2KwiMwQOFdZn7JxvNerrbaklrzZiQ/I0uUbNRt6tFDWmfyGfIqPuVEZG0i206JIO0IKG9C2JMcBWIIjhoqInONSjjJDSiX1ISATrcYcE+1dK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448463; c=relaxed/simple;
	bh=6nKItJBsYs9cgoDkJ5ejJJDXn+om+lPo5MPR4YeC8Lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QOGLi6dE6k9QtEBymMwSxQ7kpEZfUhLVspkYnUYdvGi9X/kgt8CDN0wTnN0VPNzhhdu9Y6VxL+tMZj4wif0r7wjDxk24Sa8xXtAE3BLbMmqRy+40uI5tunTGIFGJ6bwoksJSfOXXOeV9sRbxI2RExbnIkSbDpFMgbj7ZKbSjJ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i9lLNEO2; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i9lLNEO2"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d2T3b1W3pzltKWC;
	Thu,  6 Nov 2025 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1762448458; x=1765040459; bh=nG72JU40ov18fL3J68vOuwFg
	xKrbryqpLj31KVJyd9I=; b=i9lLNEO2qoKdKHd4857inyiqvGK+D22MrfeT7mtN
	wwVKat/yl1D5CqHLiJR+1sov9H9pU/rkfe4YP/LQQiRLNXVRV//fk8/Z1wdnQE+s
	QS5rnBHeBN3XofC2TQh68DKmy/LlAdKfibCgPjn03ZvlBR+mSwP3vsP7/gTQAPQa
	QsS99ferEFrkcWAx81FVAgeiTchKLj3PMymiLuLZcHitqs7aomvL/3my3TwpHMlg
	g3wotU7MomJnLg3rGd4FPaZeV+eOy5meu6p7tugRTmfpnm/EX1Wrp89PvmwyeygE
	qqXsvWpLBVUVjgx8YB5XYx6tGWG9ptLFwaGyPmMiyFJvTw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W-vx5_pI-zVh; Thu,  6 Nov 2025 17:00:58 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d2T3X51dSzlssyQ;
	Thu,  6 Nov 2025 17:00:55 +0000 (UTC)
Message-ID: <4bb9995f-0b53-4a17-af0e-bb9649e71029@acm.org>
Date: Thu, 6 Nov 2025 09:00:54 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/28] Optimize the hot path in the UFS driver
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20251031204029.2883185-1-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/25 1:39 PM, Bart Van Assche wrote:
> This patch series optimizes the hot path of the UFS driver by making
> struct scsi_cmnd and struct ufshcd_lrb adjacent. Making these two data
> structures adjacent is realized as follows: [ ... ]

(replying to my own email)

Hi Martin,

The first version of this patch series was posted seven months ago (see
also 
https://lore.kernel.org/linux-scsi/20250403211937.2225615-1-bvanassche@acm.org/).
Is there agreement that everyone who wanted to comment has had the
chance to comment on this patch series and also that this patch series
is ready to be merged?

Thank you,

Bart.
