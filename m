Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D20204036
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729281007; cv=none; b=A7DIpsT9mHBoxBp0hMJvbisu4D4TyooRuwurOKHkN/NVA70GIN+lDdOnsOP+DneRpFSecoa99T9oPB6KcrV5qkJ89DH1WGRkOBfYcl5BQXb88K/4Sp9r3jwurV87AkLGnR6WSpmgtWZAprF+S+qIq/InERRjd/ulmLWV4il7rlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729281007; c=relaxed/simple;
	bh=6nq9XSOWGqUFtrtpci2rWhWWbJPxQ8e5xl9GseHQnkQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dcnVaLNUnuGPBKQqAVrZD9akJ7zfuZQ1Q5QSMpPe/8ZUIXSIbR+zCeeFeerOmyruh6Qe4meRT+EdWEz8d6icmsaXEDSs9jW1dP/6OT8IWaUKCYAxgGysZajtoVFBdj2AOgxLQpuAKNQBQKe4BVAQSmwHIk2litpwsnVHX4KxmFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LqPdoBfh; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LqPdoBfh"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XVZzx13vLz6ClSqS;
	Fri, 18 Oct 2024 19:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729281003; x=1731873004; bh=Bw8856x3KWDTHcPUbz3p9krM
	CewItf4zbyxMYEutwkE=; b=LqPdoBfhm6rwo/vN5ryApNWParY8UdEJJYDOrzpt
	Mz9M5tdqxqfrCakIX/bnbVpluVIFXCulA8HvA3yeiC4MQB05u6M3834rphl3fl87
	k02j5VY00FkkxIdz+/42a3/qJ5f7bhwcyBlaZ7wp4MuG2PDvu3vt31QtlPS7mZne
	CTwJgpQTAVwztdyFydcSfe9csiVVF1qDVhYj5ydVcwwIyVvBlDtQFteZrNO8/fAz
	3eJYtoa1pfvEl5Hsd/Aob3bXb9ZJYlG3UtlO0fTm8LkZCmLLCO7n0TvmRVuYZCZT
	b/EUM21dSzztItGwtxTjFf0CGZTF6lVi4r2fgFAB/pk6og==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rd2z0VHKGzvT; Fri, 18 Oct 2024 19:50:03 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XVZzt4tLGz6ClSqP;
	Fri, 18 Oct 2024 19:50:02 +0000 (UTC)
Message-ID: <63de2104-0489-4e3d-87cc-78146ae55dd7@acm.org>
Date: Fri, 18 Oct 2024 12:50:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>
References: <20241018194753.775074-1-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241018194753.775074-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/24 12:47 PM, Bart Van Assche wrote:
> Replace UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS with
> ufs_hba_variant_ops::set_dma_mask. Update the Renesas driver accordingly.
> This patch enables supporting other configurations than 32-bit or 64-bit
> DMA addresses, e.g. 36-bit DMA addresses.

There is only one change in this patch compared to v1: the "hba->quirks 
|= UFSHCD_QUIRK_HIBERN_FASTAUTO;" statement has been restored.

Thanks,

Bart.

