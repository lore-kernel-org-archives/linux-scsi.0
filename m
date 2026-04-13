Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8E33B583D
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776095220; cv=none; b=qUzmXJiQBowpemQVrb9YYqKjkY66DdSdXHD+Zpt8IKrwCskNivQHf/cQ7HgExBhpFASMEto/qmIjrp/rmGzv9j+RHXhFwo73d0TB9gixWufyE5IaNGIp1NVRa5sc7Vh4By8mQs8TymAtqygxU5ZybuOL9os2bVoPD8LumKKiPIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776095220; c=relaxed/simple;
	bh=rsCxL7yRVqP2FuNFsr2/XPc+gRnMTfSNdCuc8z+XT88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XPbqDbsyFgtrJEadAlzVgJvaVUdyCQWejZBAJxlKO9i8snxFU381/d9VLlKOellBy/henSrPqTUNEoNLprHgu3fIqLCrBnU7s/4U7quegaozP8rR9V1K1RANvsm3bfpOV4vSn6q2DooGNpLtUsIm3OA58zz16j9Vc+qwPDtwGVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wdO2Lcrn; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wdO2Lcrn"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fvWxG5T5rzlqh2M;
	Mon, 13 Apr 2026 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776095214; x=1778687215; bh=jdY8zLhWNmAqd+lva4ILf8IU
	PX4x1tWaILsmNPQCEMM=; b=wdO2LcrnQFFyEZFmFPB9t8uG5bEhgAAzaKbbSmRV
	IaKq2QQUrK2Fl95uumNTENr5uf5Vm/DEyyY5rw0Ea2xZ6AOouxgCecB9ZzD1bD2S
	N0mg6/9TcQGWZmhom6dpswgein5ij65Hb7g1ArOAZogJZvbwr9d1/yyrsvLfeMWv
	QivD6FmROdGNvUYXPB/qq5avoEUNL5Y95v7rIv0vQIU9mnOxbMFgz8diGznCQ226
	zAEN+iKqNQbE691JsrRsdJWcKpnDIjeEA43SmNyZkT6QACVddH8CXR6iBug8vs9q
	gzi6RjKjqxvOnLh9moxfKQCHU+zZOwxTiZ+p13+Cd35ncA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s8kJhf6cdSMk; Mon, 13 Apr 2026 15:46:54 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fvWx51vGLzlqg86;
	Mon, 13 Apr 2026 15:46:48 +0000 (UTC)
Message-ID: <b8f882ae-ddce-4ab5-8c8a-28efdc31bee5@acm.org>
Date: Mon, 13 Apr 2026 08:46:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS
 mode
To: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-scsi@vger.kernel.org, wanghui33@xiaomi.com
References: <20260413091126.1219552-1-wangshuaiwei1@xiaomi.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260413091126.1219552-1-wangshuaiwei1@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/13/26 2:11 AM, Wang Shuaiwei wrote:
> +	if ((SLOW_MODE == rx_mode || SLOWAUTO_MODE == rx_mode) &&
> +	    (SLOW_MODE == tx_mode || SLOWAUTO_MODE == tx_mode))
> +		return LS_MODE;

A stylistic comment: please follow the coding style that is used
elsewhere in the Linux kernel. In this case, that means no Yoda
conditions. As an example, "SLOW_MODE == rx_mode" should be changed into
"rx_mode == SLOW_MODE".

Thanks,

Bart.
