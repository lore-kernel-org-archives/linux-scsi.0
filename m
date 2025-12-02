Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5592128C2DD
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 20:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764705830; cv=none; b=DtokHTQM5KHkF1pw+j6E6Wdj1Gn6BKRsI0XBAsofW08d2Lz7tIWKejUSGYw7BbpIc0Qay7MhZ4j1udMRg2NQZUlWTQLoVz81wHVaBSWPme9c3ZSRR0tkDLfakIkSDewvuFpvG2BEsvcwriCTTARO6ROcFavP3fhr8HDIuuymTSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764705830; c=relaxed/simple;
	bh=IbJ2q4fA7+ek8V3IcMVjVwWkzy6+R3HCFzC1mTSvOfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GAMZZjP5YUmD4MzEyq5a+DdlphAIrPHfr5W86gySKdU+/Sd7+phzvOIcSYF16uQOxziGLhbGqc8GRUibx8ucpy4gK523gjmE+5Q4k9uDRpdMzou0b0hYCcuobxZoNo6dCvDfa5j7N7pTRHlrxiTS88ckiV+Ds33ZgOJApe1p5f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RrnHnm4y; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RrnHnm4y"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dLWtP685CzlgyGr;
	Tue,  2 Dec 2025 20:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764705819; x=1767297820; bh=IbJ2q4fA7+ek8V3IcMVjVwWk
	zy6+R3HCFzC1mTSvOfQ=; b=RrnHnm4ypZ/X5YMgjIhAR+86qiFMyR4QGIFVqjS8
	aIrdfjdklpVABKrBcC1ogrj4xXWieSmHuDbl7h3M0x7PTsHs4qC86OgPACMCD3kS
	5Akx3RCI8hvbThlsfOAjkQPABw5e+2nJwsFeXveAW7WnRPtf971z35hsIHRMIr9n
	WZUo9hhERTJmzFkpZKGCX/1Tj2zvdL5y0Ur9KvnMy1xIWnB+G44rDtXOrAwByw3t
	hBtgeGzwycT/BztekZQsUEaFxDy6Be+4cDUjwj5/1TuMmwGcf2p5d9/ShNoH0m98
	jCd5sqQz3DvLbBn7Fz+s4rgYuGLi4WN2YQbmaWcMnQyzuA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lok3vLL7JTO2; Tue,  2 Dec 2025 20:03:39 +0000 (UTC)
Received: from [10.25.100.232] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dLWtF2bjkzlfgPr;
	Tue,  2 Dec 2025 20:03:32 +0000 (UTC)
Message-ID: <0bf075c9-d6e9-4252-b562-b0816c9e8511@acm.org>
Date: Tue, 2 Dec 2025 10:03:29 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Roger Shimizu <rosh@debian.org>, Nitin Rawat <nitin.rawat@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <jay3lhd7onhvt7ws2nuqzkuzxygnzirdtbyok4xcvbw45yamqz@54pndmmutftu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <jay3lhd7onhvt7ws2nuqzkuzxygnzirdtbyok4xcvbw45yamqz@54pndmmutftu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/25 6:32 AM, Manivannan Sadhasivam wrote:
> How can you make a 28 patch series not bisectable?
This happened by accident. This did not happen on purpose.

BTW, I noticed that both the Qualcomm RB3Gen2 board and the Rubik Pi 3
are based on the QCS6490 chipset. That chipset is unusual because it
supports some but not all UFSHCI 4.0 features (MCQ). I do not have
access to any device with that chipset so I can't bisect this issue
myself.

Bart.
