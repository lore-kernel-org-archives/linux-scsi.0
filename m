Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323B676410;
	Fri, 16 May 2025 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747405131; cv=none; b=du2QnG7rV4bFzR+X4+U9JaYc9NKC0PcxwNZQP66gIovxlh5SUj5GgJZ0ZFGbxHce1dwrMwz0zRXlC3SUmI28v3THOmpZLcoRuSJ9tKANyMpTcNJhVF2ZyByzwKphCtX2rt4BqE7MpS4za02mfj1iAOtBpqYZyGCOYLyD6CLg0yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747405131; c=relaxed/simple;
	bh=Ibiq5vywsLVTHhNY4g9MBbPn3teE5YJJw1Xxj2f+BA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QuUd4CSNsTixExQCkIyTMLtd5YcE5hJGin++0cdbmmrr4/YiVrH1IhA4739UVREE9YsLcXJSDrGKWNKeC/VfB2crEezoq8480LxfwdIekgTYELbqTpgdF3ee5VWb1PNA5FV/7Z6AVO5AJGWrR6AoYbJIu2MJGZa2SN1RPYsCwY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VbS9prBQ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VbS9prBQ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZzThf1LpCzltNQ5;
	Fri, 16 May 2025 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747405119; x=1749997120; bh=uTy2Ns3D7T0t6OmoA1ZQh4tj
	VkxjjMFC2vhAtN8QcwU=; b=VbS9prBQT3VpJ5fDhtR2eThY/3IFckHYrDixYzWw
	3GPP9BFpE1OulTlLedUKQGZWqw28rkQ1B+l9KZfcW75RO+y95TRtFOAPlVFMy+Ab
	OEmmZr1F6mS0OhY5UpxlBq0Eu9+/SsHghWONiB2V8tH1oyPcbcg2lg+PXSfhzrqb
	vT/n56y59bj2veKyR7E1l/s0mTTJ20gC8wlalNcg03xHB83+3UUpxWbeNZ4EwCmc
	Mb0f7daw1EaBFfcXsPzq2Kfts+hJc/BlstkYlwKO5ZIbAXs8NG9yjcBQgFJ52E/a
	/uwUbiuBB1BJh5UTP6v7IFeicaiBg07AcJQLK4jaZAEFUQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a2LzUo3fKmFs; Fri, 16 May 2025 14:18:39 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZzThM57h4zlvfmv;
	Fri, 16 May 2025 14:18:26 +0000 (UTC)
Message-ID: <432a58c0-8b1c-4585-b299-f35286ee4b62@acm.org>
Date: Fri, 16 May 2025 07:18:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
To: "ping.gao" <ping.gao@samsung.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, minwoo.im@samsung.com,
 manivannan.sadhasivam@linaro.org, chenyuan0y@gmail.com,
 cw9316.lee@samsung.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20250516083723epcas5p216a21ffb81631d35f0a12f7a583ea248@epcas5p2.samsung.com>
 <20250516083812.3894396-1-ping.gao@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250516083812.3894396-1-ping.gao@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/25 1:38 AM, ping.gao wrote:
> after ufs UFS_ABORT_TASK process successfully , host will generate
> mcq irq for abort tag with response OCS_ABORTED
> ufshcd_compl_one_cqe ->
>      ufshcd_release_scsi_cmd
> 
> But in ufshcd_mcq_abort already do ufshcd_release_scsi_cmd, this means
>   __ufshcd_release will be done twice.
> 
> This means hba->clk_gating.active_reqs also will be decrease twice, it
> will be negtive, so delete ufshcd_release_scsi_cmd in ufshcd_mcq_abort
> function.
> 
> static void __ufshcd_release(struct ufs_hba *hba)
> {
>      if (!ufshcd_is_clkgating_allowed(hba))
>          return;
> 
>      hba->clk_gating.active_reqs--;
> 
>      if (hba->clk_gating.active_reqs < 0) {
>          panic("ufs abnormal active_reqs!!!!!!");
>      }
> 
>      ...
> }
> Signed-off-by: ping.gao <ping.gao@samsung.com>
A blank line is required between a patch description and a Signed-off-by 
tag. Additionally, please add a Fixes: tag to the patch description.

Thanks,

Bart.
