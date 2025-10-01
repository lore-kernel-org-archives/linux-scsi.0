Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF527146B;
	Wed,  1 Oct 2025 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759348300; cv=none; b=CdAQIbGnDFxXU3Yaeo2VICyoQ5/WjORJhop/gjuWmL0aw61oGVZbHy6bc0uPwyBbgbxSOtShBV/54t3/+17/tXfLl1B7nei49oCT3QLQ8uTLljqdumsD/s12/PjoJ7qMP9B7/uOhD/RKs3YW8Ww1tyu9a9o1dikuuwjRttV++7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759348300; c=relaxed/simple;
	bh=l/V1BG3SYPao0jaZRXdERBN3QtYFVC4Ify8emeKlLYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUygzO0qMkK08PgawqaBh3K27Gji7uyZFwnTgNuPx8rNPsOIVj0OjVoo1LUc6CJVMebwh59PZ7mDLBXjxwAmjpSUMvUCTVyO46qufyRzmHKy3YVANy9hr3WhGsA2la90hvDTT8Uvj54NWuwUmhYVW5GbdqsBTCcmIH6vVFO1/U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eppzni5F; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eppzni5F"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ccQY420zjzm0yTq;
	Wed,  1 Oct 2025 19:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759348294; x=1761940295; bh=l/V1BG3SYPao0jaZRXdERBN3
	QtYFVC4Ify8emeKlLYs=; b=eppzni5F2zgGpl+n6NfLTUUcvzIaza+6LCWIH9H7
	I0UjIi29C5QSJixWH4h6DiDfIS/XLcRlx/pVLl2z0gj9AdayWOeB45eMAGwCnTYj
	9UXKZ9vl2Nd0bpfNxRryBPLGxYNpHvPgn73sl7bMZJ468BtIvk5v/0B7yGMN1D05
	5xol7n4tRexliF2ZyXtxdBUgTn1TwHDVpAiPka9290DAB4Axdur1JIM61PA8Wxsr
	1x5ZruIFgElxy0tVF+ly+IbaYZ+njxrOuwBsqpDM/AIWFQbZ8fqy9AInuAiMiUAo
	qTr7gmfUH6zNNl/eu5yhXBevE6japrL2fN75MpyO3M1zJg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7uk_2xPl0GLM; Wed,  1 Oct 2025 19:51:34 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ccQXr3vrpzm16ls;
	Wed,  1 Oct 2025 19:51:23 +0000 (UTC)
Message-ID: <00a30e2e-a137-4365-9478-91ecbabf07e7@acm.org>
Date: Wed, 1 Oct 2025 12:51:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com,
 jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251001060805.26462-1-beanhuo@iokpp.de>
 <20251001060805.26462-4-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251001060805.26462-4-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 11:08 PM, Bean Huo wrote:
> +MODULE_DESCRIPTION("OP-TEE RPMB subsystem based UFS RPMB driver");

Hmm ... "OP-TEE UFS RPMB driver" is probably more clear and still
unambiguous. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
