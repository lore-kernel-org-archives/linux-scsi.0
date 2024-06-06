Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06592535C8
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 23:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717715326; cv=none; b=lwaxK+o+ROT4cvYKSrgrtqyBtLNN1O+0hQlq1EftahIkeNcdEeLoyv5EaiT4HWLR7JivI6f+N/wqJNxUyuqbV9Hqbf+2WI8pqRaySO/tiFKwxFYVvF+mx5Zc9g3BxV5ZdDfNC9F/+qow9GBsGFINTbZzZ6df2QzgsC3KxYQdwxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717715326; c=relaxed/simple;
	bh=ivHRm8Gc/TIPEtghMOHVC9hUSg8uXYUJQq6cqKdRRG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNDGir++jh296iTe0lqFmA1KZ1Yr//awRSQ5NmdhNYFbWsw+PN7kWo2+U8KWRWRBu3Ra2HVtHuxxGZ3dPu63AqBKdbgA5vhZQsx5VB6gkN780Xbs6EGYKSEEPFIJGF5nG/eHnePqxNvynQRDevNVTlCOXO5DXZ9DbjZnOpypRQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNcEs2PL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNcEs2PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4DDC2BD10;
	Thu,  6 Jun 2024 23:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717715325;
	bh=ivHRm8Gc/TIPEtghMOHVC9hUSg8uXYUJQq6cqKdRRG4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bNcEs2PLB+CcrUbVUtMKnvgMD6Ox3GRmW2V9oarfBqYixCiQduX7/N1rqBZcpmEhs
	 ToivSK8yJ2aQbn793s3qcKSnxM4mtT7Hr0ItDrHVbQoODGO1/LcErCmEGLqnAhaVV9
	 sMQiuRECsqWQrTscMQVq8z0SVtW/p30+nL+yhHcTs73ZCnbNJ28DNW23UklKI6uoF/
	 Me/Syo2SjZyoaFuW4mEKfutMkbmqOm2w9JNl8eX757w0MPUtJz1z4wSFqtO8K5BQWQ
	 kQhDjRsPDN7TfP/tUg9B9hcA+rCiraotPewb2tV4w8Jjhhsu4fv2BmxGxrVCeZtYww
	 B6sICjLtiupFw==
Message-ID: <7e27dc26-ab23-465f-8cd2-97e635fc37b3@kernel.org>
Date: Fri, 7 Jun 2024 08:08:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Disabe CDL by default
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: Niklas Cassel <cassel@kernel.org>
References: <20240606054606.55624-1-dlemoal@kernel.org>
 <03766042-bfa8-44bf-9684-44a912ad2c73@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <03766042-bfa8-44bf-9684-44a912ad2c73@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/7/24 00:48, Bart Van Assche wrote:
> On 6/5/24 23:46, Damien Le Moal wrote:
>> For scsi devices supporting the Command Duration Limits feature set, the
>> user can enable/disable this feature use through the sysfs device
>> attribute cdl_enable. This attribute modification triggers a call to
>> scsi_cdl_enable() to enable and disable the feature for ATA devices and
>> set the scsi device cdl_enable to the user provided bool value.
> 
> Do we really need to disable CDL by default? Has it been considered to
> enable CDL by default if the Command Duration Limit mode pages that have
> been defined in SPC-5 are supported?

We cannot do that as that would potentially break users of ATA NCQ priority. The
reason is that for ATA drives that support both NCQ priority and CDL, if CDL is
enabled, NCQ priority cannot be used. If we were to change CDL to be enabled by
default, NCQ priority users would need to disable it before enabling NCQ
priority. That can break existing setups.

And this has been like this since kernel 6.5, so I am not going to change this now.

-- 
Damien Le Moal
Western Digital Research

