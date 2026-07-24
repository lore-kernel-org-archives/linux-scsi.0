Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B37D46A5EA;
	Fri, 24 Jul 2026 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784922402; cv=none; b=d4aQxgDC3VZOKWrj9ueIGLjOUQ+Cek9v3h7+nldrrJ1z1D07lTzkrIrHSUbDjLYMK7Mkt+N4sm9sTRh9mRaSB3p1cZ97/LqFz4czweAG25lje00BuVaRESpWQX9oJ9IfS7b0dZQ11OuyKhJsXsZXAvUvJ4keMJruHDK9epqyv/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784922402; c=relaxed/simple;
	bh=BFdSH3s1t8uZ6xhMta33aA/KiiMRPkz7QCfcsBYuXdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ug1RDNjYLdotfJYWoJWBF6YjevHm/HyiRKudrPDNDSLn0MdR/qOMytXWmnVjmzjU/AZe/CIABSziduUl1Db1Ga4Y4nJQS1izFUEousK9imkEjo3rqd0NwCX6dbxmGzEYYJLp8JfHGfyNRtQMpogvmRC0POkYL8pxeHVw6+8y5UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aTK73WXa; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aTK73WXa"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h6JQk5Gztz1XM5jn;
	Fri, 24 Jul 2026 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784922392; x=1787514393; bh=4cgioiwiUZmwMBkcWmXYW/RN
	JFX4p5zXM2J1r9P94Vs=; b=aTK73WXai4f657foe4V/Q56b2GLjIFnbmz1pajPP
	6O9KeID7hJidDgByklZ5Gvz5pYzaxrmZAkpyJDZbArR+1MS1oDsOyApNV7s520Fs
	C6vdr9d+ERbR5NDvEmZpcUMyXmVWma8MUZR+w8WArZP/4zu7hf2GIR/NjZ7hV7zR
	9dezT+TZUFq3+Vbq5Dzi8maPmtQEL3LHzHLGYY/unh4nOwguR6EoRdRrRuDefHT6
	zU/3a/FglM4f7YtcAf9O3OpP29wu1LRk1wvfJEm+9rub/Qc3lkKWT9tQffDHG1Bd
	/SYwNLCuudsf6+TkuwCBu9fZH+qzYpapPn355p6GA2Dz+Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k0qWezoHjp_G; Fri, 24 Jul 2026 19:46:32 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h6JQY0XFhz1XM4Tn;
	Fri, 24 Jul 2026 19:46:28 +0000 (UTC)
Message-ID: <6f3b6b56-f3c2-467a-9094-5be3adde8edf@acm.org>
Date: Fri, 24 Jul 2026 12:46:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] scsi: ufs: Use unsigned types for the BSG query
To: hyenc.jeong@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: ALIM AKHTAR <alim.akhtar@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jinyoung Choi <j-young.choi@samsung.com>,
 Dukhyun Kwon <d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>,
 Keoseong Park <keosung.park@samsung.com>,
 Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon Seol
 <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>,
 Yunjae Jo <yunjae00.jo@samsung.com>
References: <20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>
 <CGME20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p1>
 <20260724031034epcms2p14226b8d04342b36525abd33aa33d3815@epcms2p1>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260724031034epcms2p14226b8d04342b36525abd33aa33d3815@epcms2p1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 8:10 PM, Hyeoncheol Jeong wrote:
> +	*desc_len = min(*desc_len, (u16)QUERY_DESC_MAX_SIZE);

Please remove the u16 cast. Modern versions of min() can handle
arguments with different widths. See also commit d03eba99f5bf ("minmax:
allow min()/max()/clamp() if the arguments have the same signedness.").

Thanks,

Bart.
