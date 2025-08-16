Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8723BC133
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 00:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755304672; cv=none; b=JzUjPCQDe/I72zHuozeYCjQndC5NF7ZMJ26u70bw7mLt5yDzd5vxyfeLL9BHbyaZusIip/RhE9fLQQH0QMIexYSIIzp0BRgPXZgy9TS+0b7Jurkuk7pFB0RKCtWeEnC9Ne72h5SmNso1tTHZL8qoCqBVbiJuvp3i3P8r6rRWvgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755304672; c=relaxed/simple;
	bh=RTvYUx4rV6XB/IKy13QH35rXdpkZCLNUGimUny/waKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3zXJ5S3ilHRwkIFJLMHLqFQ0wwEFzbPJTIL2Zy6VeeWgreYlrTaNpHHasZMzWYQR4IkfKuHisQ5vcaIsXq4DjD7cw4EJmEdW69OrXO4bmIgesQ8v5F//WqCy8403CcXHAqC6nE7e8cqQDITjRqQN5Bg7ELUKmEyzEMKaRJj2rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgWNbyuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgWNbyuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D02C4CEEB;
	Sat, 16 Aug 2025 00:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755304672;
	bh=RTvYUx4rV6XB/IKy13QH35rXdpkZCLNUGimUny/waKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JgWNbyujq5XX06Ga1RgayyRPDWhXF7AHnj7h6j7yFiSZSupt64HHeg6MWxChTg18Z
	 aPTPufhYuJb6eRH+cN+NNii8UgiyPSNw6fn1JaXQenCGGk30/XnRdb0U3ULhiEPcIQ
	 lpX3sFCtGiiYPNEomXa42DzuCIY5ZBcmRcEYEAi4gOsgvtX/yPpibJGTDeiBbxdkAE
	 AtNoCqzdsdQI+Dp9ukuKKRTPg2JFkQN/6zaSZsz2Zx2djpgB9MLFHkxbSKlJAR4gHX
	 v1cvJGPv3eWyVkNxS0phtnQLfqcTm9+7R7zc/tW+n3xzc2SvolrM9TmuajlRjSOarm
	 UhgUczdEsx+qg==
Message-ID: <2eb5d892-e75c-41a5-95ec-9cec01d9634e@kernel.org>
Date: Sat, 16 Aug 2025 09:37:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] scsi: sd: Explicitly specify .ascq =
 SCMD_FAILURE_ASCQ_ANY for ASC 0x3a
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-3-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250815211525.1524254-3-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 06:15, Ewan D. Milne wrote:
> This makes the handling in read_capacity_10() consistent with other
> cases, e.g. sd_spinup_disk().  Omitting .ascq in scsi_failure did not
> result in wildcard matching, it only handled ASCQ 0x00.  This patch
> changes the retry behavior, we no longer retry 3 times on ASC 0x3a
> if a nonzero ASCQ is ever returned.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
