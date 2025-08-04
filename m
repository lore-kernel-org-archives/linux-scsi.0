Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2679327464F;
	Mon,  4 Aug 2025 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754322441; cv=none; b=EpYZP7waknsa77Bd1oKbyUpVpYJPcVryuToYjtXRsHY4XJCxZjMu/FQMbce0ArmQZS3KB0f/xRh8HGYJ1+t6luGsj+XEwGSYSLTx5SHlnU6+8Izov/Af03vkondfrebTMRnNuQFlUrbRTg8AZCRzSon0PvVko650/bVnJCqElBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754322441; c=relaxed/simple;
	bh=7ITKNxyhyM+XiYJjTDaSLuVW+z1B1zw/mgNG+UlmUm0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AoF7XzWBmGat9QKroVtXnZ7DkGAONsE1F0QXCNTaJnjWB3pvdj3SVaHHio14kPPBik3xDEgambOPewLyc/TK6XDf+6csmZdAl6o7TYNdjURfRGZoSrcNxCqNQVVzNGEqb3FerTPU39pozsbuGI660vzratA5Mim58r9G5UzZ91w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BrJZy/f2; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BrJZy/f2"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bwgsr6XPCzlgqyC;
	Mon,  4 Aug 2025 15:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1754322430; x=1756914431; bh=8h6LkW+9Y/F+yA58YI9n4Cyy
	7CwoIORIsoVtJY8sZck=; b=BrJZy/f2W9S26puuWGJtOc0S4JT7gYpTpbz6LQFw
	EzsuBjc1Ad1y8wJ9+m2q9kRhY15Wpu54KFhO7zDm0s8Jc/HZMmvw3MYIRdq4QEED
	hHCQkCJPVlrJPgCukoqbkJ8c5J2KUAIoQQ4e+Y2QAPjOKWo+1zGq1dHBiMd2vBQI
	SAZg+JqslaJn9aQaXLF49D66+S3pveubkxVF7/cAlkYNAHHilqHtYIy+6gCTgN/J
	tfDMw9mCGnQ1R33LS+DCmYagtNsb7rsWUhWaqYmFZNgES/Aye3nzUdyhCFlr05k1
	JCerje6hTVyhU0d5ZtKzz5F38HwRFRZGA5/zno+vAFsc+g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DstBBlAYGuUv; Mon,  4 Aug 2025 15:47:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bwgsd3GVpzlgqy6;
	Mon,  4 Aug 2025 15:46:59 +0000 (UTC)
Message-ID: <c9cd3d39-37ec-42cf-9458-e3242fe1f302@acm.org>
Date: Mon, 4 Aug 2025 08:46:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device
 in reset on suspend
To: Bharat Uppal <bharat.uppal@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
 linux-samsung-soc@vger.kernel.org
Cc: pankaj.dubey@samsung.com, aswani.reddy@samsung.com,
 Nimesh Sati <nimesh.sati@samsung.com>
References: <CGME20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23@epcas5p1.samsung.com>
 <20250804113643.75140-1-bharat.uppal@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250804113643.75140-1-bharat.uppal@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/25 4:36 AM, Bharat Uppal wrote:
> +static int fsd_ufs_suspend(struct exynos_ufs *ufs)
> +{
> +	exynos_ufs_gate_clks(ufs);
> +	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
> +	return 0;
> +}

Why '0 << 0' instead of just '0'? Isn't the latter easier to read?

Thanks,

Bart.
