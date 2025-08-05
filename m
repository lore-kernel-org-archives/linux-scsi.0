Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35542A80;
	Tue,  5 Aug 2025 12:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754397137; cv=none; b=sY3k4mjgRxxNuJv/MkJve6KpsNhKHh2CPph34RziyzR4Aln5P3yJVnLUYguIJdSWLDqlyIbSe47cRdRqtZJbMnPyOIOpic8KPEvxgBzSwZhfNaVH0goFb4lVUNmGFVm8+p9guCHWIeh/kq8WYRK6MKff+vzERnMjL3jIufbABtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754397137; c=relaxed/simple;
	bh=LCcUsHDyEylOJxo60d6aDYDkO3n3zWE4kkDtNdzkZNo=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=D09R3NFr90ZtMEEnkEU8ThrOa1nak7J8X1MOhzUFJVQX5ZL8seITQHVUAG8F6a11sdeIbDfL8rNTW37qOtZW6DUOq8BsYKHm+uhpfpQBpMdtQTJxbCuVjzYdHFO9th1JkoXZu3AhSfGMOMxIXHnxVxlkx/LB881s6xTO8SLubpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=mqvJ9cNr; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="mqvJ9cNr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1754397128; x=1755001928; i=markus.elfring@web.de;
	bh=7l1mlVBcTICQ2rfvOFneQ/QK4V53LeUCp6av5LwzJ5U=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mqvJ9cNr0kBfXDO26Eu0ZSPMBVaVNssbAYb5G4xOsG23pZgdoI0tbcBPTHdJshtN
	 JatTH3lPyPep+FQXYKxk05n9u6Vh2H8pF1pmaAQjZUEuJmLDgfqR49FKiWHbQTI+L
	 1SIcYKuQrKoZwM4kZ1hMK8I19hh+YWaA+D4+WQ7JMvtvJrY5fJ60rBQ7cu3sLZocu
	 izOL2mW859EOnDzcrVKf6+o1NKMqbZFaGZ8Ljl8OYfMAFSB+/9FyAfs6fQm1F4uX6
	 jjrQmpmTlvBJ9iL1ATlo5DcfGaJVpvdlw12x5wXZmCd85IeOVfVEMFF/jM3MrAfgH
	 S/7YcvEwnnGLANmlow==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.245]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N7QQB-1uYpfh0jkb-00y6zc; Tue, 05
 Aug 2025 14:32:08 +0200
Message-ID: <d4064644-63ed-4d4a-9382-34d3d12e0094@web.de>
Date: Tue, 5 Aug 2025 14:32:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Qianfeng Rong <rongqianfeng@vivo.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Bart Van Assche
 <bvanassche@acm.org>, Brian King <brking@us.ibm.com>,
 "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250805022637.329212-2-rongqianfeng@vivo.com>
Subject: Re: [PATCH v2 1/2] scsi: ipr: Use vmalloc_array to simplify code
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250805022637.329212-2-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:2AYA8p8ULxcRy4Wzy0BxHX46btMjyeXbO+sJZFfN0WbcErSBCzR
 fKIu8RtWXoil61DWOaz5sqqyXXEe/WMsW6auiSt1OvJB7R9n64XNddIocaC2ux3Auyzh8Dm
 2EiDIMzSGwgx6joNsdx8ozsXkqUX3Sh9oUdnO+Luadzv6dAtsyCYn7YMOBET2rVcdX/OHdo
 zB3uB8QNYWif1/nTeCJSw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:iXpnhVFsdEk=;qNPw0GnW9+/Q6aWNLnqCTjZwWWt
 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
 UB0fFUMDUu2DbK/HWoTdzeTkt/SZDTjM=

> Use vmalloc_array() instead of vmalloc() to simplify the functions

                                                       this function implementation?

Regards,
Markus
