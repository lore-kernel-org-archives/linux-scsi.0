Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F986FA9
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470118; cv=none; b=kuAcEkJQamCdPCKnwh70Li/DOUtwK84gOImC7y05vt1j45gfBz/iPT0gNLZ8gr6MrnUczg59fTRjwvSGR2SNFU8VbeVyMtgMtfmjsQB8FcFG0SfUkyjP6gbDXk1ZA+wM8hJABEWvVohpHnqntYdHY9D6BC2S4I0opj5CAOdbzRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470118; c=relaxed/simple;
	bh=r11WZH6w4GPOB7n7Txq+1E2DOP+p83yTCZ4m0P7zAFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LGZlxJUaWN6uEwGEyvwaegJ5mPMeapHjwDVd6cGGOC/MbLW7M8lpzqqcx3MArjFF2inGPEdiQat8cEWAKRfgh72LEGFFBUwCi1JP6M8FOJIXBo8GzTi3ujJucB9e/Qfkm+3QeZPWTEAPvW5/GlPEtv3Fm2LzA+bSpM0vvL+l3Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pjncP0/7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pjncP0/7"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4TwpHy0LX5z6Cnk9M;
	Fri, 15 Mar 2024 02:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710470104; x=1713062105; bh=rshhIT88lYCQaT2AaqxMgxvu
	c8UtBhvJ7c1YhTWtuqQ=; b=pjncP0/7dJ+yqcHs/T7XzvyEOiUmR+SCCpLIlBdm
	ZChZgR887gJLLEXA1QPR8G2lkIyXEZbkOqcyZixfr7Xobjdj7BdIK8l+QhMU4uvT
	z/uHV4EC3Jhfs3Ru6ixV5LRw40z6m2PVf9NnFq2spHUeHg1zjf0ucSWNs6YFmvIM
	GD3lLj+g303WMqqqLVc/bYNbnfZgPvWMYJU9kmjz9Mc2SKhuevOh2SpCiU/aeJAk
	R+Vr8Va0qflnFWZlCoJ/T368EzhQpCej+Mw49NApBJuXCNEzAXuYMYN3v2/3yaO4
	wCoFp3wOzU9xf/58BzY+KGzBDRB1RDZ72nYawt6BBz0aNQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4k8wI546dGYX; Fri, 15 Mar 2024 02:35:04 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4TwpHk4hG5z6Cnk9J;
	Fri, 15 Mar 2024 02:34:58 +0000 (UTC)
Message-ID: <abe611aa-0732-442d-ba36-9540fd7c1396@acm.org>
Date: Thu, 14 Mar 2024 19:34:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/7] ufs: host: mediatek: tx skew fix
Content-Language: en-US
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240308070241.9163-1-peter.wang@mediatek.com>
 <20240308070241.9163-3-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240308070241.9163-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/24 23:02, peter.wang@mediatek.com wrote:
> +static bool ufs_mtk_is_tx_skew_fix(struct ufs_hba *hba)
> +{
> +	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
> +
> +	return !!(host->caps & UFS_MTK_CAP_TX_SKEW_FIX);
> +}

Same comment here - please leave out the !!

Thanks,

Bart.

