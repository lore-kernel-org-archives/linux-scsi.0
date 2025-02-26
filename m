Received: from mail-m1973183.qiye.163.com (mail-m1973183.qiye.163.com [220.197.31.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E643325D537;
	Wed, 26 Feb 2025 07:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740553505; cv=none; b=fXGwLIYkzlqw0BnliZyL8bL70j2rCK1ghPcr6CFDaQjjlhJXr/dZezVU7I/e/N+rQv9UtlvIRj8uxAsz4He9aetMRaH7Kss0CsY/h2GnHRFMWvtIrbrk5AW1MXhdDip4UchFbDiQitkC9fMcW136iUctamSqkepvgviNqxXKKk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740553505; c=relaxed/simple;
	bh=WLYZ9EBuwNXnwCUWsdQ1Ij0Qo8E9Crm4xrtth2ViDFE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i+9cqqGB9QEp3z5AoKNABJeNwUelt2y5teLyRpmmdOSYltVqiNkUFGlcWCv2mAga4On/Zrj9jIWSU9v/6Th28MERZ1tzoziFMivMRO52cF9av+1+K2KYwRU1rGFsXagOAHfqPDK6+uJGF5LkXE8Z4rC4aMLkKrZv68ENUyxJ75g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=GDaQiCWD; arc=none smtp.client-ip=220.197.31.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="GDaQiCWD"
Received: from [172.16.12.45] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id c3c47c7b;
	Wed, 26 Feb 2025 14:49:41 +0800 (GMT+08:00)
Message-ID: <a18fb035-3e7f-443a-8b24-9a51cba5604a@rock-chips.com>
Date: Wed, 26 Feb 2025 14:49:42 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com, martin.petersen@oracle.com, heiko@sntech.de,
 linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
 Abaci Robot <abaci@linux.alibaba.com>, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH -next] scsi: ufs: rockchip: Simplify bool conversion
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
References: <20250226021157.77934-1-jiapeng.chong@linux.alibaba.com>
Content-Language: en-GB
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <20250226021157.77934-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQ0NNT1ZKH0hOS0NKHx8ZHkhWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpOTE
	5VSktLVUpCS0tZBg++
X-HM-Tid: 0a954104b35509cckunmc3c47c7b
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kz46Fjo*GDIKMwsDTh4qMxwW
	VktPCRxVSlVKTE9LTk5JTkNISEtJVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUpKSU03Bg++
DKIM-Signature:a=rsa-sha256;
	b=GDaQiCWDoYocllNU6WqKHl5m9xRxpcznUkUedTxHBomfvOO/UfsHDYxKuNmU/5Vl7SAtbkmy79QcfIew8C3GU5v5i1+sB1KHMHcsG7KO2GgLXUbCoUht9ILjVM/mZW3hwIRmTlkOljc6BudXvicBkuIWTqQ54c2maLyOufFlvqQ=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=cvkxqloIlTXo9JLh9EsUKKF24vwSjOiMeRjag/XPRuc=;
	h=date:mime-version:subject:message-id:from;

在 2025/2/26 10:11, Jiapeng Chong 写道:
> ./drivers/ufs/host/ufs-rockchip.c:268:70-75: WARNING: conversion to bool not needed here.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=19055
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Shawn Lin <shawn.lin@rock-chips.com>

Thanks Jiapeng.


> ---
>   drivers/ufs/host/ufs-rockchip.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
> index 5b0ea9820767..350cb0f8d0c2 100644
> --- a/drivers/ufs/host/ufs-rockchip.c
> +++ b/drivers/ufs/host/ufs-rockchip.c
> @@ -265,7 +265,7 @@ static int ufs_rockchip_runtime_suspend(struct device *dev)
>   	clk_disable_unprepare(host->ref_out_clk);
>   
>   	/* Do not power down the genpd if rpm_lvl is less than level 5 */
> -	dev_pm_genpd_rpm_always_on(dev, hba->rpm_lvl < UFS_PM_LVL_5 ? true : false);
> +	dev_pm_genpd_rpm_always_on(dev, hba->rpm_lvl < UFS_PM_LVL_5);
>   
>   	return ufshcd_runtime_suspend(dev);
>   }

