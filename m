Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC01F6690;
	Tue, 15 Oct 2024 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729014034; cv=none; b=SOdipmdLLxTpKGWwJUoJKnA4mnxaoKuWcYayE1IdAQooI7kOFU79tpwlHBJP2yaTlC0ZzyI61yKW45/xPRy72X81/hx2cUOx6WOMFSh+mSESFFwILFH3PzuHyuXZQDP3v9dhHy3E8lBl6D/TNamVyVDYmUGOhusdBwSs4JDiCOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729014034; c=relaxed/simple;
	bh=MHvPlcz5YqNRrAbith9dTdFU2xPMCmADsPrY2LV6BAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KwZr9VcBrLdlNFZ0flxSYjUkbX+Dm5/4aXetPwh/6a3g9EH9yZsxdMFGqr3G6am8src6oHWFvtxb0hMwOvOicDQnQ1oj0qPODhr/ccriF97WllflzNNljW2fCf/MMGPUK0sMLhzaByrzYkgk/1RYY67szjfAIgN+xvCeR6WUOp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iXdlvoSn; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iXdlvoSn"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XShFj2kPVz6ClPR7;
	Tue, 15 Oct 2024 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729014021; x=1731606022; bh=74WZZsZopHSTbp9X+PrKeK/K
	wyyZ+BgSxXQ+iN684SA=; b=iXdlvoSnevGx1RdsxnJvmRUdxMRpGb/DtU81pIsc
	I1wWYaIK9T91e7I2ECkD2M+HimwWNb10I3TNpTeQGz4uWcj2lrSblZrhBnLpsFP8
	6Ri7p+53EFwhXeKutrEJw4YU4VwlHhPZp2ZPyaJFB53pDm8KN5kcIlRYjJd7gXyl
	yWGvHe88Z5HMzcmZz0vIdvJERegMfyOLVmYTZwUt6X04nMUgiYMaX/G2fjcHwB+I
	fmDsxG3a8gEWV8rG38ALUW40PI11+wFSM3TKdYKXdEgfbQjRDI/FmMXcLMDJx8To
	HRdRsGVyHiRzR8P5YtBJ1yQFN5KKSAt04jNfwSS/CfZlDQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IgEtxsNTMSnv; Tue, 15 Oct 2024 17:40:21 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XShFc3zNRz6ClPR5;
	Tue, 15 Oct 2024 17:40:20 +0000 (UTC)
Message-ID: <4a54b449-802b-4d76-9551-038a0b05cc51@acm.org>
Date: Tue, 15 Oct 2024 10:40:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Use wait-for-reg in HCE init
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241015045711.394434-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241015045711.394434-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/24 9:57 PM, Avri Altman wrote:
> Instead of open-coding it.  Code simplification - no functional change.

Please use full sentences in the patch description.

> +	while (retry) {

Please change this loop from a while-loop into a for-loop.

> +		if (!ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE, CONTROLLER_ENABLE,
> +					      CONTROLLER_ENABLE, 1000, 50)) {
> +			break;
>   		} else {

"else" is not needed after a "break" statement, isn't it?

> +			dev_err(hba->dev, "Controller enable failed\n");

Please fix the grammar of this message, e.g. by changing this message
into "Enabling controller failed" or "Enabling the controller failed".

Thanks,

Bart.
