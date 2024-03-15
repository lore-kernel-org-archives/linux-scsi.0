Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC996944F
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470010; cv=none; b=tS+xeZpd856hDLFL3b918B3/tLmRF/v2K8MQQQmzyv2dytOrr5OZ5rRCNCBVwO6xrOadjMfTgFb4wwO9D0zUCGAPdEoaXzvj50EpUDs658rhCSV9yLajKcWcX8l753dXMyxPUIZpJuBC3qGgCYtYap5w3m1iiSPQJ1xn3YzvkN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470010; c=relaxed/simple;
	bh=NH1RKsLrAgv7fdQyIDtVaW7Ta9vukIIbKLgRp55IIhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t5vuKzr7GqLnQrfXazrGO+Cg623zU+fdL3BXDQydcDE39a9dcZOnARRgzLRSg1/bE5Y/UT/jg4QNo3YmXZ1b5YsS61OhPZ0y318O4eiBOplxLGHR/hYSOikqMDTEZ1m809YTGhzuZHEV6mgpiIXSxlcbLYZ/shtUXxHBGbePEic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ii6gBBV9; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ii6gBBV9"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4TwpG008MpzlgVnf;
	Fri, 15 Mar 2024 02:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710470003; x=1713062004; bh=H14rF6WiBeCLtB+EEpKUHBEs
	k2vsPMjama1QW0UoN6I=; b=ii6gBBV9wRUL2bJ2GfKziGD9SrDjKuuWbPGRnC61
	UlJfzmjUbLSad9mFsLNRMkmBlbHLaU2umg7MuCViRDa7x8vndZI42lP2RJch51h0
	rbVwkZL7BXI268RGJ2Qtgd8u3YvV7TKHg6Rcx1o6p5pyL6rWgH4/CiVxKK0XzuMQ
	MqWJ/OnyMTmJ3um0v8UFiRB73uxHiF1jqCGp8xcbmjVtleQ1GK0pqgnIUVclOcSJ
	9t6/VzngdJlmoqUbnCoQpUdRgMqlkAc8HBb6psYZhZ1UKoPBueQ3iMU2EywT89IA
	VvW7MX5I4KaFo8lk22P3BGUr1z+oJouQdA+jzG5eXpxNUg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YiomIDwf3-8k; Fri, 15 Mar 2024 02:33:23 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4TwpFp0RRfzlgVnW;
	Fri, 15 Mar 2024 02:33:17 +0000 (UTC)
Message-ID: <e84ddf57-566b-4f1f-9357-07b983ba28e6@acm.org>
Date: Thu, 14 Mar 2024 19:33:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/7] ufs: host: mediatek: fix vsx/vccqx control logic
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
 <20240308070241.9163-2-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240308070241.9163-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/24 23:02, peter.wang@mediatek.com wrote:
> +static bool ufs_mtk_is_allow_vccqx_lpm(struct ufs_hba *hba)
> +{
> +	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
> +
> +	return !!(host->caps & UFS_MTK_CAP_ALLOW_VCCQX_LPM);
> +}

Please leave out the !!. The compiler does this for you when implicitly 
converting an int into a bool.

Thanks,

Bart.

