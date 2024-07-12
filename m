Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F2F43AA9
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2024 17:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720806195; cv=none; b=cKMpJYSl0HUmnFbY6zXnNZbHi9Q3jrKLhSEc2sdSj3rf2buLG+EaE2AyRKjAC7yYgEvbp3R957TIXXi1qfsbvt0DNWsQBr3A2VAK90gIcXEBS7RIRhQoSZEralXAFD+WMQuMUwbPF/e4SDDySvE8rfNFr5z8/YYBh64mA8eW0aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720806195; c=relaxed/simple;
	bh=hxNZGyOZRostHrNqtJBGwypYIErFbOvNA9+4kd+g8OQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CpHfoR+FkXkBnmZK4zShsMWXKAecKrFkBDoHB376u/0imiELzitv22jJHwijXWirIK/bEGdt2DJlL9ho+PXm4Q9fQ3z8RQIeGfYxB2L1lJbXUH/4bbR/qXJSh4Yx0Joinxtu3eFMQdW2PO/fVdNaY20rXybP8gE1BD3iz2NrQ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LpmycdkE; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LpmycdkE"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WLJpn18lmzllBcv;
	Fri, 12 Jul 2024 17:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720806188; x=1723398189; bh=hxNZGyOZRostHrNqtJBGwypY
	IErFbOvNA9+4kd+g8OQ=; b=LpmycdkEMZHtCXMaHclqeMbL/XwwxD1HBqaYiDsp
	dvyBCb2YWe2wAi3E1tuThHAlUUQLB8R0GjjOUWc04P6zdrGp/EVWwnkEoujOMfP5
	wRRS+Ng8zmTK/b21yesy2Z04AX1B2iXssutEwAQzmiKzey1wPgNp4xRVak0a9dlL
	sU/5Ji1zRcwOXt1e0yc1Yeum9CgMozqHqd/nH+4hd4oS/BN0P31rZ9xk50QassrF
	p0J53G9cuK1X6aBnG4MX+AsJ12AvdOise6Rx/BNEMTlYvibqk59qFRqevKPmfUFY
	I3tT2Rqknb2dyo9e4Up8L6QXhMQMuLGaP6shO4cYIMmXVg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Q_y74j0HpsJj; Fri, 12 Jul 2024 17:43:08 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WLJpZ5Rd6zll9b3;
	Fri, 12 Jul 2024 17:43:02 +0000 (UTC)
Message-ID: <3ce9d99e-bf29-4454-9681-1464a23dd909@acm.org>
Date: Fri, 12 Jul 2024 10:43:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: bypass quick recovery if need force reset
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240712094506.11284-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240712094506.11284-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/24 2:45 AM, peter.wang@mediatek.com wrote:
> If force_reset is true, bypass quick recovery.
> This will shorten error recovery time.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
