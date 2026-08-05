Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289343515CC
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 04:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785905958; cv=none; b=MGoBVlarDzeFx/txDEBRwbBm1JN3B+S4HvhifAWHTMc3CMI7TnwVe2a6wlKp8vw//lRRToXzjaGMpbOEuGKQ88K4mKZqzsb/Mr4MZy0OGv7HjOZmOA9dJ1dyPXNOGSS2s0zSB/fLzsruS9fBE37IuR/XHJSDaVEV1AN1VDQAPKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785905958; c=relaxed/simple;
	bh=RSSaxR0U1DbBhcKAPlJVmFk1KBTwEnZbZsF1y6yaZk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jtWwgAnFtLY2fh1eF5WinmsrY5R1/Vm5ueNEYTdtws1DPesKK5BwpOxdQlyzUxoUyX9esgFq7+5QK4JUTWoz7AT2+q0KQJYDMIs4oUGwskjLsyfpoNLPn2OmQPfi0l7V5NGPyY26xtsf8TBYb2m1lZv74wBnCPjpPiXS942Du2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HD3wQhpI; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HD3wQhpI"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hFJ9J3JR8z1XM30j;
	Wed,  5 Aug 2026 04:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785905954; x=1788497955; bh=RSSaxR0U1DbBhcKAPlJVmFk1
	KBTwEnZbZsF1y6yaZk8=; b=HD3wQhpI4SIOX93v4+Ke+opnLhQehEt1L1pPStAv
	J5aHeiuW2CufeMkjDPKs2H49zBoJVlCz/BBlsZ5jKpy9BoSxbuXIFg7eVGb18hB7
	p+DZEi7cys4ZhoMnhX5zs1dC89Ov7O5ft7VmO6dXcXKDjSNeFyuolkYHtroHP7qu
	2/PWpJVf6zQlXyplofa5UhgJKfRcU7WCaOaIT07tTOyGCvn2AdYZ0XxXzruULxR1
	QjHx9OVdOIT3YoK49aX7XxZ2gYMuxc5I/ZNLl4IJhifHdaZeievRHI1TlSWI7RsG
	AmIS3Lga2fN7EedgGj35eW0PYt/yHxumoOM6bKWowGRqJw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fFdNrh7jB9WD; Wed,  5 Aug 2026 04:59:14 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hFJ9F3gbrz1XM4Tl;
	Wed,  5 Aug 2026 04:59:13 +0000 (UTC)
Message-ID: <25919cf5-2e3a-4baf-a362-748d40f956a7@acm.org>
Date: Tue, 4 Aug 2026 21:59:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] scsi: ufs: Fix descriptor parsing and invalid
 input handling
To: martin.petersen@oracle.com
Cc: Li Qiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260717153914.26321-1-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 8:39 AM, Li Qiang wrote:
> The first patch validates string descriptor payload sizes and avoids raw
> descriptor overreads. The remaining patches protect invalid completion
> diagnostics, validate connected lane counts, validate RPMB frame sizes,
> use unaligned RPMB frame accesses, and retain a NUL terminator for
> debugfs input.

Hi Martin,

Can you please take a look at this patch series? Patch 1/6 has already
been backported to an internal Android kernel 6.18 development branch
because it fixes a buffer overflow we ran into on an emulator
environment.

Thank you,

Bart.
