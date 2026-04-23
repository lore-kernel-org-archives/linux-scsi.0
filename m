Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEB1311C2A;
	Thu, 23 Apr 2026 08:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776931936; cv=none; b=j5nkGHgeeSM2SPYfXm0rZ6fJddZK5Gi2cz2X5GfDWlva9reZmAjrQp8Hd+Fd89irhveVXlujwuBrJJwV05G4MQuHYw0mM1TBrFGIOnkQXl7/pYsoNuv/i8kVAGKWZrZ6FsWvY3jq1/yvl9g+Uu2cQ/ZUk/2NQCqPE+NxBpSFP5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776931936; c=relaxed/simple;
	bh=nKQU54g931q8pOJIugciQZ77/INbwVM7ELiBJomhXac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HmTFHaK+RXR0hXXtvbGhxxZHgtsIZBWRooEKFgEwjSLHWy9lbARlV0o62tVpky2J12MbUKBp1vvCgYNE7spJK67NZYqFGpkDHkYKB0NTqs/d7zcGErCtMXW1ecTv+9mGxNDaCp+N4UnRoxGWgQnnmE7jKJOU73DUPaGG9OlqSU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from [10.88.129.61] (obninsk.basealt.ru [217.15.195.17])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 76F862339B;
	Thu, 23 Apr 2026 11:12:04 +0300 (MSK)
Message-ID: <9ffc6bb5-927c-2729-71f1-10180e826ccc@basealt.ru>
Date: Thu, 23 Apr 2026 11:12:04 +0300
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10.y] scsi: ufs: core: Improve SCSI abort handling
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
 Bean Huo <beanhuo@micron.com>, Stanley Chu <stanley.chu@mediatek.com>,
 lvc-project@linuxtesting.org, Fedor Pchelkin <pchelkin@ispras.ru>
References: <20260421131941.38176-1-kovalev@altlinux.org>
Content-Language: en-US
From: Vasiliy Kovalev <kovalev@altlinux.org>
In-Reply-To: <20260421131941.38176-1-kovalev@altlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Sasha,

On 4/21/26 16:19, Vasiliy Kovalev wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> commit 3ff1f6b6ba6f97f50862aa50e79959cc8ddc2566 upstream.
> 
> The following has been observed on a test setup:
> 
> WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737 ufshcd_queuecommand+0x468/0x65c
> Call trace:
>   ufshcd_queuecommand+0x468/0x65c
>   scsi_send_eh_cmnd+0x224/0x6a0
>   scsi_eh_test_devices+0x248/0x418
>   scsi_eh_ready_devs+0xc34/0xe58
>   scsi_error_handler+0x204/0x80c
>   kthread+0x150/0x1b4
>   ret_from_fork+0x10/0x30
> 
> That warning is triggered by the following statement:
> 
> 	WARN_ON(lrbp->cmd);
> 
> Fix this warning by clearing lrbp->cmd from the abort handler.
> 
> Link: https://lore.kernel.org/r/20211104181059.4129537-1-bvanassche@acm.org
> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> [ kovalev: bp to fix CVE-2021-47188; adapted placement of
>    lrbp->cmd = NULL for 5.10 function structure ]

Please drop this backport from the 5.10 queue — it is not needed.

After review feedback from Fedor Pchelkin, we verified that 5.10 is not
affected by this bug. The upstream commit 3ff1f6b6ba6f carries an
incorrect Fixes tag:

Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")

The actual regression was introduced by:

64180742605f ("scsi: ufs: Fix the SCSI abort handler")   [v5.15-rc1]

which restructured ufshcd_abort() and removed the 
__ufshcd_transfer_req_compl()
call from the successful abort path. Before that commit — and in 5.10 to
this day — __ufshcd_transfer_req_compl() is always called on the successful
path via the cleanup: label, and it clears lrbp->cmd. So the 
WARN_ON(lrbp->cmd)
in ufshcd_queuecommand() cannot trigger on 5.10, and the lrbp->cmd = NULL;
added by this patch would be dead code there.

64180742605f is not present in 5.10.y, therefore CVE-2021-47188 does not 
apply to 5.10.y.

Sorry for the noise.

> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c7bf0e6bc303..1b8072f47e7e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6788,6 +6788,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   		__ufshcd_transfer_req_compl(hba, (1UL << tag));
>   		spin_unlock_irqrestore(host->host_lock, flags);
>   out:
> +		lrbp->cmd = NULL;
>   		err = SUCCESS;
>   	} else {
>   		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);

-- 
Thanks,
Vasiliy
