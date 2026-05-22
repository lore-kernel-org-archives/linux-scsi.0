Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A85351C1E;
	Fri, 22 May 2026 16:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779466933; cv=none; b=BJ97az4N6gBbiBwL/9W1X8BhNnbsdNd4Kgd+irWqDxoOZ3hyqwmemtX3GZad46kwtaNF2WBzj7hQOt3cjG+tpUqZ8ZFwHAd6i4+tuTE9IBWtre2cruMvp5inwhbgf9UIqtSLKz26r1MQDQr7QotMoyySYRnXc4nc35Kg/pGAMZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779466933; c=relaxed/simple;
	bh=ixDAUJI33JXZuBrwo87v7U2zTNiFJdB1pzf6JQr6GQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NmKyKTBuCN3yPDw+MgzQWn0l7KP6HQj17KWxejDdd9+plP74JxICylFtvZMOeMd6Ve+A6T2K2aGC3Xj9UH2bQZcr4mpm6X6ldEQnFRb13U67Dl5zxhg16aNagb3cEV8eGrEZhxvhPhXBNnwGKGm/mioeodHdeRfehzMUvnwOMGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hr8mpagw; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hr8mpagw"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gMVsv2sf2z1XM6Jb;
	Fri, 22 May 2026 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779466927; x=1782058928; bh=qnnkAknxkW4BAZjGZmW//V0u
	yb+y/XGEO6fXvzEO+aA=; b=hr8mpagw99tZzxCQtfK+mglOj7MjsOdD8z7EVN/n
	38qTXRso80Dn6oS1f5ALm8M1EWp9ZgM8pAfkLfYtcJr0n/KecSmiHO3o+LJDjeIK
	Y47OB4vlf/oW2cG0HMyTD6ioclyUST0oPDK5O21mz2UyWBAGlfXFSd0fUoo8I55/
	uwr4Xc0Sq3OizSuB9GsCiSJr0NLZFyukIdIJ4VBW7p0q3f0Dtp52C3BdI8dvMF6A
	ifaH35ODopU7qEQRZW6tD6ropvxfCIzVgGwb4GesVuLbdSC9SFDSO4/53Am4JHxC
	r3iCTRdXgF4UXeWBAsV9ysjhwx4dV1IOpeYkZoC3foR7XA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mS_-y8NxLE1w; Fri, 22 May 2026 16:22:07 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gMVsp1Rgkz1XM6Jk;
	Fri, 22 May 2026 16:22:05 +0000 (UTC)
Message-ID: <e838f00a-03d8-4a62-bb64-5c6be8561303@acm.org>
Date: Fri, 22 May 2026 09:22:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] Block storage copy offloading
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
 Christoph Hellwig <hch@lst.de>, Nitesh Shetty <nj.shetty@samsung.com>
References: <20260424224201.1949243-1-bvanassche@acm.org>
 <ahBD9fRrPDuoB2cj@shinmob>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ahBD9fRrPDuoB2cj@shinmob>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/26 5:00 AM, Shin'ichiro Kawasaki wrote:
> FYI, blktests CI trial run detected that this patch series triggers nvme/018
> failure. I manually applied this series on top of the v7.1-rc4 kernel and
> observed the failure is recreated in stable manner.
> 
> nvme/018 (tr=loop) (unit test NVMe-oF out of range access on a file backend) [failed]
>      runtime  1.208s  ...  1.189s
>      --- tests/nvme/018.out      2025-04-22 13:13:27.738873155 +0900
>      +++ /home/shin/Blktests/blktests/results/nodev_tr_loop/nvme/018.out.bad     2026-05-22 20:57:31.060000000 +0900
>      @@ -1,3 +1,4 @@
>       Running nvme/018
>      +ERROR: nvme read for out of range LBA was not rejected
>       disconnected 1 controller(s)
>       Test complete

Thanks Shin'ichiro for having reported this. I plan to include a fix
when I publish v2 of this patch series.

Bart.
