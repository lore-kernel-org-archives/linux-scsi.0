Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009DF33BBBA
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 21:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782511030; cv=none; b=SHRfkwla/Dac+xE7sVq4SB8/heolUh4Ymr72r8XZbxzytRJlqimWwFvimEyxnpb2cMEWJr+Tt7TEU8Do2ixUohM4hDbYJZxtqEgSe/mt6LTvGD0oTYvWtpIR5u6wMfVRcQueawQC7qWXMC1lZBwmm0DQcyrEiiiqU+nUMfi1OcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782511030; c=relaxed/simple;
	bh=/r7fk9ade2lA1/AEyyxGFUoub79drY3ZZc1x2mRoqKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oHijBE2PhuDl4jxwI4sCQBVIYWoBmuQi2JxnsypGDGaLo4gIcHaG+ePQQnuoEQrydA+9tP4wP+GgguxS0Ds0IczTMMzBNNH/43SNGbZrlY2vNlhI6NmpsTXmDmSRRMDddAdNFzKwg77fw7PGSOvCYWQd34+rLAODFSI80ScE1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTq4AeQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTq4AeQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A6A1F000E9;
	Fri, 26 Jun 2026 21:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782511029;
	bh=j+0AwWNxSVHWsd/75D2iFe53ShMCUu1QE+uXSIYMGeI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iTq4AeQ4qPrOY82G2sUOm+e73/cGhKI71pZnWIvpG8FstjT+Pz7fJxgEbSXb8yM6I
	 4YMlqic79h95R4niDu1krdkFL52He4vh+yJ2ON7mqsAc+F9XAwDdFvxp744SoEmVAL
	 su0llMQFLjrbT0nKnIl4vIIQmKZrqMSixK+QoZlMNtQ/1vhZhHwTLOtmIUuiQaVqKi
	 Suk9SGsPL9z/jJ+XW01gqctk7zrVQP4ppCGNP0WqN0+kwTqkD+epPNAjgDC2PTJNgQ
	 WfDnEYzN8bwVwl8JCwTBCiOpyYc3gZoXTpVXJesPZxp+wRWf/tTbRoVXvUbtqfPf6U
	 VG63rzQM33lIA==
Message-ID: <c3c093ab-88c9-4a71-89dd-33ee69db1823@kernel.org>
Date: Sat, 27 Jun 2026 06:57:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] scsi: sd: fix special_vec mempool leak when
 scsi_alloc_sgtables() fails
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: hare@suse.de, tom.leiming@gmail.com, p.raghav@samsung.com,
 sw.prabhu6@gmail.com, linux-scsi@vger.kernel.org
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
 <20260623100159.4018066-4-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260623100159.4018066-4-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/23/26 19:01, Yang Xiuwei wrote:
> sd_set_special_bvec() allocates a special payload page for UNMAP and
> WRITE SAME commands.  If scsi_alloc_sgtables() fails afterward in
> sd_setup_unmap_cmnd() or sd_setup_write_same{10,16}_cmnd(), the SCSI
> midlayer does not call uninit_command() because RQF_DONTPREP is not
> set yet, leaking the page.
> 
> Call sd_uninit_command() on error, and clear RQF_SPECIAL_PAYLOAD after
> freeing the page.
> 
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

This needs a Fixes tag I think.

But otherwise looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
