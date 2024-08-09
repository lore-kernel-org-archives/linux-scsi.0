Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7C2321A3;
	Fri,  9 Aug 2024 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723227955; cv=none; b=hisPXYl4+xZwTLaSR87kQYNxEkjAtZ2a63wul6mAE2XOutXTMU2arRmP5mFg8gtHPhjtQl/Z0gJdOgpn5xkLhr/pwDknFfTvqLwEdsnvmvIDdbi7yXlnaOgGTrfI+zdOKWw++wMhQf62WGRWuQnd03ygQXgJbySM5BPNbTxGjLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723227955; c=relaxed/simple;
	bh=5waMife8S208FkJXojTgCAgx+7XhehE+qfODF5UA/LY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SE+CFuKi/OXvS3zIeRtp70mprhbUj9MobfUnMvjs1MnrNjeHh+3VLyEiOctmSWxULFL8F+hO0W+wuY6+PeApMfAioHOZPLEkoWzniG3+Fbw1RJBK2F4d8usA9Wc/lTbNwVp7Hv1En1tlhJYIsTKquz9ukwYowekHRL5/jJpVoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xj8hKmwW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xj8hKmwW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WgXR54zgNz6ClY8p;
	Fri,  9 Aug 2024 18:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723227951; x=1725819952; bh=5waMife8S208FkJXojTgCAgx
	+7XhehE+qfODF5UA/LY=; b=xj8hKmwWjb/n3OXVlmWCp6w8EfsOuMr+mn4HJMsj
	jfaGPb+I9Ysss7zf4oSjH+Z2krLgwh64U5lhloVm1tpjgNHP2oy7p0+nyqHF2nkp
	RxK2X921uwJiuXmkv2ig0QPR0+tSlg0TSalSmUQG5Een1jx6nCjWm1oJjKUNRZHi
	mtWWK/P+2kIMRcjm0mA+RwhczxX7UZy4d5iJIlU6Arg2CpOOdxzQwb6j2LAy6boB
	feMS7yaPzCYyntn4McatNNgpHlMltdhVRELDVrutNUcAdAi5Lky3EcL+XDnOlSsR
	kjvyLkk4Ah0VtfQCeIkbv3wbimY7YbeA1Z6WfyQpOBcAag==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 83y-bc4tIiCA; Fri,  9 Aug 2024 18:25:51 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WgXR16Hjlz6ClbFS;
	Fri,  9 Aug 2024 18:25:49 +0000 (UTC)
Message-ID: <54be2399-fe9e-4179-9cbe-3c7daf6251c1@acm.org>
Date: Fri, 9 Aug 2024 11:25:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Have scsi-ml retry START_STOP errors
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 prime.zeng@huawei.com, linuxarm@huawei.com
References: <20240808034619.768289-1-liyihang9@huawei.com>
 <17c0a914-9bd7-43ef-b739-d2105ec46567@acm.org>
 <35f5f7d3-3cbf-b45a-8a3b-eb1a3f34ddec@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <35f5f7d3-3cbf-b45a-8a3b-eb1a3f34ddec@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 1:28 AM, Yihang Li wrote:
> If the user triggers the PCI FLR through the sysfs interface or
> the host is reset due to an error, the START STOP UNIT command
> (other commands are the same) is interrupted. So I think the command
> needs to be retried.
Hmm ... aren't operations that bypass the SCSI core considered out of
scope for SCSI core fixes?

Thanks,

Bart.
