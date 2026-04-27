Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3DF3396F4
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305826; cv=none; b=Hd0kDMoXc26GmZ4QWTGKq0pVaZ4VJqzv9YMvrbWEva/DJIl0Kh99RrH0Uv5x0bOgn1JgX10vzcDF5S5xOWIp2fR5gPvvzk1OB9bb9itil3ILr/kk+SOzkFU0+T16PgJQ71xiiz1jXF/ggv1fae24iWSnNUA9nD/jhVLl76va4cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305826; c=relaxed/simple;
	bh=bOGduK6c/6mjk7tJ13Gicub/B2aqmzaprRPKYshjtCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FIDLc5mj6INmTDGct4l9RidZXsByhDkjz/aVyUQ6pohCApgsDggprpE3b4MpcMFyOZBP2gkUUDxk234HeRinvjRK8gKgQ7fjuP0GEXtdSgZrlr/kQz/KDxDzlFAa5I/Y7PP1hk+Ard4fNoQz0kqEEvka83AjuJL6XyKzFVTIcRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XGcttCPc; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XGcttCPc"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g47f920ZWz1XLyYZ;
	Mon, 27 Apr 2026 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777305820; x=1779897821; bh=bOGduK6c/6mjk7tJ13Gicub/
	B2aqmzaprRPKYshjtCY=; b=XGcttCPchvJrlarZdItOKbEr6X+wXpRyp5VLHbaM
	d/jN4r/h5k1ypMMDeTGOIDUucb6UjwaGjI8fjb8IUgSVEFbSC+xxx/tP3XMZxVzC
	d6F4xjeMKSPgegksCqqJbl8CcCz+ZaeDqnOsg2Bk0aL27eV8EH0aspQqaTcb4r5x
	NLVTmVDuiR9aQib9YJL8Cca02LbH6MrldMncjqcTBLtP14rEXwC5jGCfS7pKsTas
	PMP8uUiq8SjkG2TFYpkGqJFLj/L9j7hB6afHlmUsTB7lPnWcZ611rme9OOiWSStG
	cRFoBpzyDmQeqPncWXl/LdzRqcfgZLOaXAXzjos+b9Xy1g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 40t0iP2ksM6E; Mon, 27 Apr 2026 16:03:40 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g47f15Sbmz1XM6JY;
	Mon, 27 Apr 2026 16:03:37 +0000 (UTC)
Message-ID: <6170955b-b34b-4ec5-a440-bb41940b89e0@acm.org>
Date: Mon, 27 Apr 2026 09:03:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] scsi: ufs: Add persistent TX Equalization settings
 support
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org
Cc: linux-scsi@vger.kernel.org
References: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 8:14 AM, Can Guo wrote:
> v1 -> v2:
> 1. Incorporated comments from Peter, Bart and Bean.
> 2. Fixed typos and minor coding style issues.
> 3. Converted macros to inline functions.

For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
