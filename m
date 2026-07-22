Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AD84399F8
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784743900; cv=none; b=QrTM+ZO6iWBp0QOBdjbaC5cM7a5fI3MdaNF1E1mV2nVbnIJ7yCKHDwifiSn4ccqf64g8ZYS/mCVuOVrTuxPG7yHwsM+m5vlvWlaJ5j/F4UF0JA7ZLR3AIJx2Mhq2DD1wkjYAv8ClL7DrVYqTIlFVZ6flVy24y/UsN3AGLprZfP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784743900; c=relaxed/simple;
	bh=CZ3mhSNbhPJTaIg+96CBboRMTCFwJzSgzF4jC28ivb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFyhdzRAadWHpwVo0EMEmowbs5INBLWCyxfY226GohNUfCwTtIZGqqQ5WCDb7wgfIzdtXUp8dJS6FhQqN6GboMmd7k4+vZtPl9Jzf1aHc7BjwFtWRvtjZZj6U9RoGrR97JoSFL5Np0B6QqvnqzZMdc9KWdHH48TTxUlzbDG3ZJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3n/CjG8e; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3n/CjG8e"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h52Q05SlmzlfwgD;
	Wed, 22 Jul 2026 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784743894; x=1787335895; bh=CZ3mhSNbhPJTaIg+96CBboRM
	TCFwJzSgzF4jC28ivb4=; b=3n/CjG8edu6B9M6ern3V9+tEOG6qJxjrdl0N3eO+
	8vNo29VtLTJrCYbEh/bwCRj/BFMtm5PpO+xnlPvYq2yn/Pzku+jaPiP/clNDoDgB
	qSYIT2W6cQ2J568h8PPGFpIdvVaj2PC/HOQ92GaldJkUkQB2h2VnOQNtez6ZPGuN
	dctoDlWGgytFKmyt0HJjWUxtF8NvlsyN93Vxq3+ew9wuQsfqh47OsiqvvTxXOl9V
	K+07py3oUI5V+pxHNk1OhrpGYDIPSXOSDcMvRT1gJA8di6POQGbipoyqJTCZJ+C4
	Esp8k0IEKKGl81bMRJl+x4MendcVw1kgthh3jUKMeWPaYA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JVgLVzC_Bzg5; Wed, 22 Jul 2026 18:11:34 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h52Pw5RNBzlfwgC;
	Wed, 22 Jul 2026 18:11:32 +0000 (UTC)
Message-ID: <b3ce0a36-5da9-4c29-977a-53fb0fcd6051@acm.org>
Date: Wed, 22 Jul 2026 11:11:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufshcd.h: fix all kernel-doc warnings
To: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
References: <20260720013759.2979593-1-rdunlap@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260720013759.2979593-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/26 6:37 PM, Randy Dunlap wrote:
> - use the correct name for a struct in kernel-doc
> - add kernel-doc for missing struct members or correct the name

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
