Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850572907;
	Mon, 23 Sep 2024 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727113307; cv=none; b=YAsSGjOBxRi3qVMMElov52Oi1ue8CCEJ0MhHE4SihHDZbKEFh4T0Wo/5VV8QTNszN/drUKfeh5gp0ndumnODEYVAWCr2+lgPyP/XY2anhcf7MME9NtqPgRqKTPrMBM6gLJGKChaykdSTO3Tgfl0JU+sD9YuxoecdltXtH2kgYSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727113307; c=relaxed/simple;
	bh=zsLQDuXO9h+lUZGA2Y/gZsaNyvuuunXi6nnTY1IlqYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XtKa1Mvgyksg1eP5Pue1gK5I/K141LCKqiF1xVm6BFu5nFo4i/vYF6VxBjBtYC3NAUPSLLrNKZlfh/s1m5NaGboodvjfNBDe6AyJAKyDvw2piGwGlrikzfGRRB6wEcLP0uVaUhMXxpyp58ZC2U7J282DGLvm/fJMTQqzPc2AfyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PMDKWNu5; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PMDKWNu5"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XC9KH6C3PzlgVnN;
	Mon, 23 Sep 2024 17:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727113294; x=1729705295; bh=hCfyiYRkz3qnlnF9157O5c+j
	5eJUigXGJaHinzu20CQ=; b=PMDKWNu5Ek2TVszod9Xhk7B02hYbkWNhsLzz8RNe
	q3HS+8DKS5rga7vERezrzbn9ynzaMIBUsml/sLqnw1wiphXqIIibRF9rPshgOS8y
	aFSVZWRQ7hageaiVCgxDUN0jZMd9dqc8MfMKcYzXp4lD6UGYsOExfakWcfrOe+yf
	MmDQdXJEVmPljlse238jBVj+TeQefEwWYrfBQ2tyNZxOQKWPDrBdVUi/8h8JiPTu
	xJ8uU3qLwRNoDJyFf4RLVs7Gj43D5Aq/Drd3jAdo+X1dgvIaBl1enqYb9KAE0oBO
	1geQnIPLdHwW8qCN2Piq+GREaDBG16CBxJ+BpznGPj0xyA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QeQFpulL2OoT; Mon, 23 Sep 2024 17:41:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XC9K64CmXzlgVnF;
	Mon, 23 Sep 2024 17:41:30 +0000 (UTC)
Message-ID: <fa8a4c1a-e583-496b-a0a2-bd86f86af508@acm.org>
Date: Mon, 23 Sep 2024 10:41:28 -0700
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240829093913.6282-2-sh8267.baek@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 2:39 AM, Seunghwan Baek wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index a6f818cdef0e..4ac1492787c2 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10215,7 +10215,9 @@ static void ufshcd_wl_shutdown(struct device *dev)
>   	shost_for_each_device(sdev, hba->host) {
>   		if (sdev == hba->ufs_device_wlun)
>   			continue;
> -		scsi_device_quiesce(sdev);
> +		mutex_lock(&sdev->state_mutex);
> +		scsi_device_set_state(sdev, SDEV_OFFLINE);
> +		mutex_unlock(&sdev->state_mutex);
>   	}
>   	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);

Why to keep one scsi_device_quiesce() call and convert the other call?
Please consider something like this change:

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e808350c6774..914770dff18f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10134,11 +10134,10 @@ static void ufshcd_wl_shutdown(struct device *dev)

  	/* Turn on everything while shutting down */
  	ufshcd_rpm_get_sync(hba);
-	scsi_device_quiesce(sdev);
  	shost_for_each_device(sdev, hba->host) {
-		if (sdev == hba->ufs_device_wlun)
-			continue;
-		scsi_device_quiesce(sdev);
+		mutex_lock(&sdev->state_mutex);
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+		mutex_unlock(&sdev->state_mutex);
  	}
  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);

Thanks,

Bart.
