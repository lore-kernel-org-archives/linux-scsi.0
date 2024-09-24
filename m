Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD3111CA0;
	Tue, 24 Sep 2024 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727202306; cv=none; b=AMi8LKluqaaY0x+4Rz47guW+yf7feGcpxcMtJaLkzOkhuIvI4KxSFS+bb+bAizkrecSgMcjpBmdOoBu2xHu7OYSZDo4i3diw4yDnLA+JNbVrnbabv+IwLZSxz2Z8MRD1uuWtN5s0lteaBc1mCWT/e1awxeRzCaFeCqTE6pn0LVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727202306; c=relaxed/simple;
	bh=rgLearlYjzMnQfkJz/s3WeZnp9Ywf6QnlUcddXy54bE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6Ym6a4idUYPzLVqDI/UnQqYC7gY7ThuWEKgduKlwr9kgZbtXc53qtRQ23Ht34wTijIoCOQr6IgMlvhuWx+uQVzHhn4I+0UX3QEZHrxgg0Sm+8K9rekKGF2wCouLZz/kBzkkaNvr5EXr+KQuVwgicYQn151WVc4dKiu320uybds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xIjA5nAE; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xIjA5nAE"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XCpDp2nrmz6ClY9X;
	Tue, 24 Sep 2024 18:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727202293; x=1729794294; bh=ka1L/rTl/2S2yfrGC6e0Apm9
	4DZy23YfTKQUPFek9FQ=; b=xIjA5nAEchXHvqDuOAhcmxGDXr2wBmjI+90m8hbL
	ac678sRb1E5freXs3xcnYO6+5z9n2e9PKH1imyuMy1mvr7G28w4vMv6QjlYfUoHV
	GV68dTiOG9okWzwD8/dmWXgRub2SRdZdFjdgduGVkChMTebJwggY5Oxul3ZpeIpo
	uqacwWeG0g7ngfJX6/diyLAJPw03gPDEOTyapxOuxfNVwA0aNLrpAjYli1lSmqiY
	pmgWSYQGnOkKAUG2clTtdBF3mxQAZGIpMBwY88zCCQFtsf0I3gFmZvy5Kvz1r4ky
	WfQgi8bKiNUxp8dWGEs2VFFTyuVy5RS5rQxvhUIjDDLKRg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lHziY71Vt7vE; Tue, 24 Sep 2024 18:24:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XCpDg5X6zz6ClY9W;
	Tue, 24 Sep 2024 18:24:51 +0000 (UTC)
Message-ID: <1845f326-e9eb-4351-9ed1-fce373c82cb0@acm.org>
Date: Tue, 24 Sep 2024 11:24:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
To: Seunghwan Baek <sh8267.baek@samsung.com>, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, avri.altman@wdc.com,
 alim.akhtar@samsung.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
 dh0421.hwang@samsung.com, jangsub.yi@samsung.com, sh043.lee@samsung.com,
 cw9316.lee@samsung.com, wkon.kim@samsung.com, stable@vger.kernel.org
References: <20240829093913.6282-1-sh8267.baek@samsung.com>
 <CGME20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64@epcas1p3.samsung.com>
 <20240829093913.6282-2-sh8267.baek@samsung.com>
 <fa8a4c1a-e583-496b-a0a2-bd86f86af508@acm.org>
 <003201db0e27$df93f250$9ebbd6f0$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <003201db0e27$df93f250$9ebbd6f0$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/23/24 7:17 PM, Seunghwan Baek wrote:> That's because SSU (Start 
Stop Unit) command must be sent during
> shutdown process. If SDEV_OFFLINE is set for wlun, SSU command cannot
> be sent because it is rejected by the scsi layer. Therefore, we
> consider to set SDEV_QUIESCE for wlun, and set SDEV_OFFLINE for other
> lus.
Right. Since ufshcd_wl_shutdown() is expected to stop all DMA related to
the UFS host, shouldn't there be a scsi_device_quiesce(sdev) call after
the __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) call?

Thanks,

Bart.
