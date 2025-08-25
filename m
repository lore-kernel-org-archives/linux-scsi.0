Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65E4307AE8;
	Mon, 25 Aug 2025 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756138381; cv=none; b=AKNoD7AJBXajaoCUQ7LkwRXisWci2SsYViapQ4cTd2R+aa+mQh3+Oya2rmRy3MwKRLDJmC/2GjDTxXBSpf/sflQJcvIfnxFB84kKTT7w73h0FmDAt3cBLeYPl1VCMDuJxzPiMs64TMoBcxZ5LBY/QtIQ4hJ0bb0x2QGLJIZL8xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756138381; c=relaxed/simple;
	bh=pGkm7OhmtNbkCBk9L4tSQLqIytaFxn8UnKRuhrHCpAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WbFiTV/fG4zgTmqMmHr5aPAtDtrcyYcYwojPD31tlUeP8yt0jKOEYRILUpqDCQTlbUVKb47XJPxyrVSID44cR9nnBPE9F9BW525KaYqJBZUGOcylTU1uf/YIFeqfstJyM04TELTWVkfinCX+8TgEsij48BeEn2lmBrxqUdRylJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pNuHSf5i; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pNuHSf5i"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c9bRt6PxNzm10gS;
	Mon, 25 Aug 2025 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756138377; x=1758730378; bh=pGkm7OhmtNbkCBk9L4tSQLqI
	ytaFxn8UnKRuhrHCpAk=; b=pNuHSf5i1IF6EHxe8OAr/M0Ng/sraAfC2bAwiOVu
	flNnMWwFaSC1vzPAGTigXLBzYTYXJ3Pyqd3c75ku0fbH641WAOZp4i1UqnTTKFiM
	4sq13YEgHOgwwmP5II6EgSAzVTFy1/feko/jDJqKb6OwNW65F4ceOsXRoUD+eopf
	CdadMIcR83Qf49khlGEOfu/PW1kMV7ulbhq1mROxYFcIG6A+NnRvaG9LQDOy0Ea9
	kazBi3AExOYWHsAlLUs9DUNZDdWntLbXE2dm2svOKtsO5ZXsuei6ONUgn8cUoCEr
	cko5yqZStdPxie4Z88Ynesi+pHqYFrKa8QUDlkarGJoJlw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ockC9C-8sxkn; Mon, 25 Aug 2025 16:12:57 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c9bRk6CKKzm174G;
	Mon, 25 Aug 2025 16:12:49 +0000 (UTC)
Message-ID: <62a58038-75da-4976-aec7-016491437735@acm.org>
Date: Mon, 25 Aug 2025 09:12:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded
 irq handling
To: Yihang Li <liyihang9@h-partners.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liuyonglong@huawei.com, prime.zeng@hisilicon.com
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
 <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
 <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/24/25 6:42 PM, Yihang Li wrote:
> Thanks you for your reply. I will consider some other solution.
> Additionally, do you have any good suggestions?

Other drivers process a small number of completions in interrupt context
before switching to the threaded interrupt context. Has this approach
been considered for the hisi_sas kernel driver?

Thanks,

Bart.
