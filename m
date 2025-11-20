Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3117A36CDF7;
	Thu, 20 Nov 2025 16:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763656343; cv=none; b=DBFJCoYYbzXEBS/EpvMe8BXoDuxfeYykCjWvb32/CsJ3Q7sGqTT7fMGqWjWOTpme3oRJ/k9hDtzVBvp6ovmNEinhxUCEXFiSElNgufn4CUAadrTGdtU7SUzgpjqojjWWZuwLhCn6qyj6psDHO5hsimrl9jghDEj0XFlSW0S/oVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763656343; c=relaxed/simple;
	bh=Gl6tyqsygPk8mFrEtYi8RIfFThSKrBdzAmaMkXxN2tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S845Ifs9wwQGCd9rqIcMt9RjaHztCkbjwNkKJn6p5jd077FDb1B35cy/Ai1DrlBWEN2F0aui9zebFRnmyUJBv//u7fTHdytyYrLGmsc0vEiXsM1Lqd5ztPvpyOFrx6zVSxrvVKPbZE63XqVmfovHpF4uKp0VeiY/6Dhl5jtntyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xEcND/wY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xEcND/wY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4dC3m36FvRzlyqms;
	Thu, 20 Nov 2025 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763656337; x=1766248338; bh=ozUGvVtX3ccSFpnIdrMm2ZBC
	JzFWnl8IOjNcqtgYWO4=; b=xEcND/wYPNw8/l5L0lgHquK8940cumsq7vt1wd1N
	YfRqOZuiUXE6RH2l8gQUPq2b3ckLf4K+9bw/SOJzsBG7s6p/zQHa6tlpwkeB6uAs
	V4QNqQnJQCTSh4Kholk46/Q3DSFa7Gf504z0m4uaY/RZEt8LAoLNwK5lZMd8qmjd
	RBecijeA9tApxRCHSr6A3t+hVCjuuIAIsUKfRH4K50alzdoyu9MvJDJskvDjePfp
	6w/EhedD+Pi+5S7r+A6kqEy113L5iyStz5w6VkJGVEcjhyNfwHwH4lZrP4rm7dlY
	kPrlrgZBbTf1QoOuLs5+b1ZXMTSGKkUhDH+Jwh2m6ayYPA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wdSU-7OMEbhN; Thu, 20 Nov 2025 16:32:17 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4dC3ls6W2Zzm0fMF;
	Thu, 20 Nov 2025 16:32:09 +0000 (UTC)
Message-ID: <8cc2cf81-c1c8-4d00-a0d1-39b047b91280@acm.org>
Date: Thu, 20 Nov 2025 08:32:08 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
To: Po-Wen Kao <powenkao@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20251112063214.1195761-1-powenkao@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251112063214.1195761-1-powenkao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/25 10:32 PM, Po-Wen Kao wrote:
> When a W-LUN resume fails, its parent devices in the SCSI hierarchy,
> including the scsi_target, may be runtime suspended. Subsequently, the
> error handler in ufshcd_recover_pm_error() fails to set the W-LUN
> device back to active because the parent target is not active.
> This results in the following errors:
> 
>    google-ufshcd 3c2d0000.ufs: ufshcd_err_handler started; HBA state eh_fatal; ...
>    ufs_device_wlun 0:0:0:49488: START_STOP failed for power mode: 1, result 40000
>    ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume failed: -5
>    ...
>    ufs_device_wlun 0:0:0:49488: runtime PM trying to activate child device 0:0:0:49488 but parent (target0:0:0) is not active
> 
> This patch addresses this by:
> 
> 1.  Ensuring the W-LUN's parent scsi_target is runtime resumed before
> attempting to set the W-LUN to active within ufshcd_recover_pm_error().
> 2.  Explicitly checking for power.runtime_error on the HBA and W-LUN
> devices before calling pm_runtime_set_active() to clear the error state.
> 3.  Adding pm_runtime_get_sync(hba->dev) in
> ufshcd_err_handling_prepare() to ensure the HBA itself
> is active during error recovery, even if a child device resume failed.
> 
> These changes ensure the device power states are managed correctly
> during error recovery.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
