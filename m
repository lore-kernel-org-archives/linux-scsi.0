Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F1C1F1302
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 21:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207229; cv=none; b=eolyQn5UPs56uP9VS9ZJPqWmXyLNnjyM9Qyq0Ibs4XbexYEPjDigrnnvIeD4kDtu3HESlkLtM8XNIRFZxk3mF4cuj1bAYgx7ZploKCF4rwwMuVa0ZkqvsZ0QzulByIo23V04NFUDGg0J8sxOv4l4nSLzEY0a1paPKwbgxEXU7OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207229; c=relaxed/simple;
	bh=/oG+9iGmNygAy72pLXyDXLzsOIYV1doMpwRf0bP2HP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jiAlAh0WsDZU+NumOmGM/Bw5yOvM2ujCKG1Ph0JNQHR7E5q3maL3qR9zRIBzCqKKd1+21DDuEOIQd851E57AlEtixIsx4VmXBM1n3MOUlKyJwboyMywo6fXgeiHLbGmEuG3llF86Tz1GFSxZ6SC1RsSf3Qr0VRyy8LpOFDL6Fys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S2mK7wjz; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S2mK7wjz"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c2z501PvXzlgqVL;
	Thu, 14 Aug 2025 21:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755207219; x=1757799220; bh=OY3d0gwMmOfWYNrYgdxCHVC7
	udaTgZjTAbWlW329Q1Q=; b=S2mK7wjz0Ss/19KK5OLMe2GHhfgN5R42F0vaI9rg
	r46MIAOo240vW3VEi8DwbV6QhcEGKENKXCfRzdQqWPeC2QjQLjAomxusZA2F1Cdl
	FINy/1OZaAt/ip/ntr66+n2duqsqcaVZtTlLu88F8tBge05vEwBuEUnRIAESRac/
	yAmQNUKwpe6srOVkBMfzZy1aCgEhtijn83jP501t58O2WGIMvDvR94oyAMkNnq6w
	mcXtt6cVFTP4pIoKCDczeXQ09Rmj6oSuUcCLuQU/MJ29B9R5i2zFSrTZD8jCr2db
	PxdcG/CAl2q8tUypkcNxAuaip0FAAsa9gd7ZyU2pQLx2jg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7WlbyzqT5DF7; Thu, 14 Aug 2025 21:33:39 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c2z4w0SFLzlgqyd;
	Thu, 14 Aug 2025 21:33:35 +0000 (UTC)
Message-ID: <9521453a-a6a8-447a-a8a1-90d41560ef2f@acm.org>
Date: Thu, 14 Aug 2025 14:33:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-5-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250814182907.1501213-5-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> +	memset(buffer, 0, buflen);

Also here, why to clear the entire buffer instead of only the bytes that
will be read by sd.c?

Otherwise this patch looks good to me.

Thanks,

Bart.
