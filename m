Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB871E3762;
	Thu, 13 Mar 2025 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741888275; cv=none; b=kgxMUELDb32WhRQFOGM4DanseRiofjLRtUoHI2waGsQnKoS+UcjkI2SYuMTe5fEkuszvs0O/hxaawpDELffozY9PV4vwkytX/gFBZHG60ww1fmMTYWUNw8B/Lzpfp2Go88L/Hi4lab0if2vKSMRzZ7SBQPF2VmQDQbBFqYaDzig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741888275; c=relaxed/simple;
	bh=b1ncFgJE+Q11VK9Q5kCYHXIewMDxWiAi9A4kfUnXZxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mgi6rkNwAuAsAglGJgTQ1dAEt3cYpAU5FCPG+g1OOBIxsZ5JLvmYbCELdGx7MlnmN6yHVuuiUMCwEWc3d01HKEYlW/JuDWrgYZxgx4PLKemK2t8y77U6REHJejYT+MX75ozvC9K75KvxHgJzj34EPklz+Ct2b3S4racaU+gG7DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1GAOOj8p; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1GAOOj8p"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZDFRN29sHzm0yVD;
	Thu, 13 Mar 2025 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741888271; x=1744480272; bh=Pkp4vIP/zdg7auq8Q6zaiu6R
	2VVT1oIEMcUH/wxUMZY=; b=1GAOOj8pFD1MKpx/ewj0xP/Of0Mdrbi1nAesCzud
	J2nuMM4CCiHGqY7YvvNCTSvnzf67akJSVpdtltUY1g9mkyCLZMAGCcOt9XBoLyrY
	MrrUn6RgzOGhzNq3EG2MLuxz+WCuQKBUbnQgza855D79ZHdW0jHWoCVBkBhz1F6z
	oW83hGzGLXYqMoxR7bs6sHhWTyF8cZIq41R7bM6WrqBfETyXahjzSrYwtESF34Zg
	BEC1I1sEg/pss714ZDqZ2CQyX7gdsioFfiy9380VohxfivXXxk9AbsbjnJi+ZeUY
	UIWxUVcr5s4e5Vu1scTsv9X3S1XQni0nBdD9kzaOYgJiUg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VA7nIBrfjrQy; Thu, 13 Mar 2025 17:51:11 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZDFRJ1TMmzm2XgY;
	Thu, 13 Mar 2025 17:51:07 +0000 (UTC)
Message-ID: <729e2906-d3a7-426a-90cc-15e98657141f@acm.org>
Date: Thu, 13 Mar 2025 10:51:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] scsi: sd: Use str_on_off() helper in
 sd_read_write_protect_flag()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250313142557.36936-2-thorsten.blum@linux.dev>
 <3c32eb12-6879-48cf-9ef6-bd04e759025f@acm.org>
 <9EE4EEC5-52D9-4159-A3B4-4865DA11C6FF@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9EE4EEC5-52D9-4159-A3B4-4865DA11C6FF@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/25 10:05 AM, Thorsten Blum wrote:
>   *  3) Deduping by the linker, which results in a smaller binary file.

Hmm ... I'm not sure that using functions like str_on_off() will result
in a smaller binary file since the str_on_off() function (and other
similar helper functions) have been declared inline. Additionally, isn't
a linker supposed to deduplicate literal strings even if str_on_off()
is not used? Isn't the compiler assumed to merge identical literal
strings if -fmerge-constants has been specified? From the GCC
documentation about that option: "Enabled at levels -O1, -O2, -O3, -Os."

Bart.
