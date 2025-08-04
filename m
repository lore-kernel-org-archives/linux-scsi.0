Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFDE272E51;
	Mon,  4 Aug 2025 15:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754322649; cv=none; b=YGV/Q0lOKfknEigK4V8wyT68aIbLiQ1rB5ClnloIEBvLdjZzcUwq9u23tgJdpb1NPo8+VcRjLMT2kgsCbSuz2NqflW+JYlZWk2lU+nEcV7Rt2Wewdv5uyBUH60oolbtCxGPkTlJpPHQqDQ+vHnz8Dsxq/BouL9O99sblplBdsqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754322649; c=relaxed/simple;
	bh=OXb4kAhtQWP6JExhGvhynrJSzXGqr/WFFL7vd70xgRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TUdDhygrxkrZ80TAWK5sTTgwlULVcN8iIb4iyeSfY4EdRCQOe2H8Di4bTJe7HeUDJZ3vP4Hc1VcKWz+M3fGYSQvXZ0e6vvWWUdbMpZw3RdsNUkHiY3AfY6G7cM2bpAoQglKZp8jwIW3Yi9F109nnOohVi6VZSoZFmnfS95YlYuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y0gj3Bce; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y0gj3Bce"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bwgxz213DzlgqW0;
	Mon,  4 Aug 2025 15:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1754322644; x=1756914645; bh=iQeGcdNTmDV9u8BQri6krA1j
	KTYUzUD2thgbYEL0q7M=; b=Y0gj3Bcew/lQ2lir013/f+R2LHWbbQgrQ4eskQzS
	y1ydylcDBFAsHKgm97W/jVWzQl4D89dpptf3QsUAxN0kjYzeopkiOj1MFMMylb2e
	TJHn9Di0+i75rVZ+t1omrbHx6xGgbzqm13r1VyjdpC362y3e5v7UF3IKdePyS74T
	4AfDDwkc5dZ2Mlormj8lpRTIp1HmB7sGrIs71jkJ9gTNahfeHj7R4biBYIqmJaUH
	3pYhNwih45WI76KIojW2P+uYPrN+sUOIaa3g+r0EjRAXDhVYiaVO2+7P7Rtz0YgD
	toUN/xKdRmI0t8NiibnrtYrqFYQefoEd1D617OQf5+ptFg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id M4mmXZ0FCTup; Mon,  4 Aug 2025 15:50:44 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bwgxr3FvWzlgqV9;
	Mon,  4 Aug 2025 15:50:38 +0000 (UTC)
Message-ID: <ff3455b4-b0f2-4931-95e1-da08f54dac70@acm.org>
Date: Mon, 4 Aug 2025 08:50:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Use vmalloc_array and vcalloc to simplify code
To: Qianfeng Rong <rongqianfeng@vivo.com>, Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250804063652.104424-1-rongqianfeng@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250804063652.104424-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/3/25 11:36 PM, Qianfeng Rong wrote:
>   drivers/scsi/ipr.c        | 8 ++++----
>   drivers/scsi/scsi_debug.c | 6 ++----
>   2 files changed, 6 insertions(+), 8 deletions(-)

This patch modifies two independent drivers. One patch per driver
please.

Thanks,

Bart.
