Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B61A3033FE;
	Mon,  6 Jul 2026 14:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346978; cv=none; b=SjfyuHSOQd3quV/L/+uzDfCpwOzqH9Om/p54N9T/CsSELpZGepQZWvay+WqO4XFRezjMcEYT97vdMl7esTKINS9MIRe1MXXiPcZKm2CH5FU3YUuAC0TrVk/ptTosolSTMtE8Qyl0NVEyhRrNhDi6U/MuznO+otQumMjs09t9ms0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346978; c=relaxed/simple;
	bh=fORrgYJcdMt6YHSQVp52pxoC8QRrluzTBxLl3mgBRYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akrQzscdUvKsSjCCTGJTVrwiY3miGL0buK6MwgoTxRta9u/9e3nEC5z8Lpnl1+4sk9fn1RMzCtAwaJlVC9g9NgSs3cDSfEjDXVjCnr807Io65bfocqhXL2ofFMdoyrGC3PMU2YcWurJ05YGPS6b7e+Nhl3oyBBgoqUSilcIoPjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=poBUJIX/; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="poBUJIX/"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gv5p82k1wzlfpM9;
	Mon,  6 Jul 2026 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783346972; x=1785938973; bh=GOtiP6aXMAFZ+DX1DhbAK0nV
	UYui2Tbs+3cObDVGKyg=; b=poBUJIX/Ci8mMHKsdIxs1DldDedq7gg0epac+I4k
	7fJh/4XyAEbWivS+8smZ3ZWDC49+nW17IoTiTb2pZS4eirjUUNtmL49/F0ZzibVF
	NDnQafSErw3MvVfxMtiTQW0ncbWKNg2nHUs7S2IgBYkDb1Mna6oZALYf/DRfdPkR
	sc7sF/wlgLXhDu8+5rwNQKAJjvLBFfOYJ3POixmP6JK973J42fFdcGj6DY1eUHiw
	Tq/98o1T79iaUYyqnE7hndrEyzlsnKLez8nN8ar8IPJTwZLnSvQ17KXCRN2ArVwf
	kicmIWhQGuNNdnw2ZUHOBT4cVxcaUC+tcUhlpmEHS5arLg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id D178-Q_ekgGt; Mon,  6 Jul 2026 14:09:32 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gv5ny3gPszlfl5k;
	Mon,  6 Jul 2026 14:09:26 +0000 (UTC)
Message-ID: <2613be2a-5a0c-4f32-84af-c894cff4cb23@acm.org>
Date: Mon, 6 Jul 2026 07:09:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim
 deadlock in TX EQTR context
To: Can Guo <can.guo@oss.qualcomm.com>, beanhuo@micron.com,
 peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/26 7:09 AM, Can Guo wrote:
> @@ -1244,6 +1256,9 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
>   	if (ret)
>   		ufshcd_tx_eqtr_unprepare(hba, &old_pwr_info);
>   
> +out_noio_restore:
> +	memalloc_noio_restore(noio_flag);
> +
>   	return ret;
>   }
>   

This patch adds a new label "out_noio_restore" next to the existing
label "out". Shouldn't the existing "out" label be renamed? Otherwise
this patch looks good to me.

Thanks,

Bart.
