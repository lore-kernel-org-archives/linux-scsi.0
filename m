Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF26439F17C;
	Thu,  5 Mar 2026 13:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772718808; cv=none; b=hiwvsslzXUMcZ+shwStx1qzafJoVPGcolrvSLh8V6+jioQf5AF4jkxz8254Du5IxgLaaq6SozKm5BvFsSPa303qggkyviVHSEbFR/OkacOyAEXuZdtY1EllJ+JodDzp9XxLSrG54KYpTBwc1R0Jim/2yA3QL/YJq76pyURcZcD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772718808; c=relaxed/simple;
	bh=l4mnk7JRJnH1eIXJtGFypS8eyK95ypn2RyU1FkY/pwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I66A82pEAvyxrOpA/siLXon3b1YFwezXbtZLvxY/M4SakyeMUCP7Kam2zqvyg/PTMSnX23tiFwc8sYQZlgcFbYHRtEYQkh+gSQQQWnDirxLN7XEL5CGxTNPPNzUQ47NeQQR72fgP9RDZWXKyU34KsG831wI/8EBlrrmsWkxN/dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=olw44j3B; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="olw44j3B"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRWGG2fmtz1XM0pg;
	Thu,  5 Mar 2026 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772718803; x=1775310804; bh=l4mnk7JRJnH1eIXJtGFypS8e
	yK95ypn2RyU1FkY/pwc=; b=olw44j3BBGk3sY2d8AjfOQmI6HfUf/GG1bSNGwWh
	xx41O/ufHoGsOXC4rrQa/VU+Xm4psJKS7zUCE1+FaITD9R3k3GvgyqDJqCcETf6/
	VN4Hd49cPWXw50seHvBLp3D8Tv98kg3WuyLyag8vhHxDKGrlIBkn5s2PpvrSxAR3
	rtOcd+gd+CEorDn+potL4/EBYDp+nyZZgiiQGb3gqTFKcYVQyAYBUKlylbc7FMGf
	NHBPk7/gZudrE+WXmuywjAjiONMAvhp4c9C45HdESqUwRiX/D6PL2gF8Ndn6/iNV
	aYywhdANVAb1l39gL09/+oVeNwXKgmBZWYKjKAbXrhQECQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id M7R5GB0v-hUK; Thu,  5 Mar 2026 13:53:23 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRWG765Mxz1XM5kD;
	Thu,  5 Mar 2026 13:53:19 +0000 (UTC)
Message-ID: <5a047d62-5e45-485f-a44a-dc3c011e9a76@acm.org>
Date: Thu, 5 Mar 2026 07:53:17 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] scsi: ufs: core: Add UFS_HS_G6 and
 UFS_HS_GEAR_MAX to enum ufs_hs_gear_tag
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-4-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260304135313.413688-4-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 7:53 AM, Can Guo wrote:
> Add UFS_HS_G6 to enum ufs_hs_gear_tag. In addition, add UFS_HS_GEAR_MAX to
> enum ufs_hs_gear_tag to facilitate iteration over valid High Speed Gears.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

