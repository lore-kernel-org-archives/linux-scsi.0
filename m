Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488132BD5B0
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225344; cv=none; b=T1P1pW0lvgM8EMWKSRR6POOM74GqpRyHE08oDYCggMp4CuKWQg2Mg4Isf46cCxP9hJzfmbILx7gYfMNm8hJY0anuAK6IM5osIT/W25ycInNn88ovyOwydSobBHtWARexVjJlj7jLmL37SUItYJrLXhxXf9SvAx9wc4WMvNTm33o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225344; c=relaxed/simple;
	bh=0p6P3PBslob6EzwXcRJWLR5IhTEd24w4CkL7p2kbeI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OPB9TM7zBzJWb3WNcDooCdTwNGtYElyiTLQPlCXaJ7A3CN0cRAO+Xo8Ce5UHbna/ApzsKHylthIbpvcmwi2CD14k8OhRTg7WNtbZeibbW0LDovoE+lr15+6OFjtsKWv+N4Fu4f4zsA5KN77gHyknAWW3BpUkhreiDZPcgP0swCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CehzYmRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CehzYmRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9594C4CEED;
	Fri, 15 Aug 2025 02:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225343;
	bh=0p6P3PBslob6EzwXcRJWLR5IhTEd24w4CkL7p2kbeI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CehzYmRltN8rpcDdK9dcXpgGM9Ve6qM+RkJnOoJvoNeDLdeyCGTwYp4xt2OyxlZVR
	 5pj+jK4iYc4Uz1UlmqUCXd0Fv3yDz16oEz9QJvO1cd5Km4l93UGLWS+lf3dIMCOxiO
	 Cr/bh8V0I0RzNNsaJiUN7gGf4TLFtM5dxNleUUKB3Wl/wv5kyAgVCBC1b7XzyKfBge
	 RrAx+p8pHeJL9NR1hw6ZRZrLuZadqkxKHTaOouMHuhElFZOFubx0hcaczsf5KiujHj
	 vA1XyJiU9mKtgR0YjC5t1dgHMe9EwwHjiIrKyI4X5+Pkonis5AYD7y9uZmeTXZwmeJ
	 k3cFWRGAV6b8g==
Message-ID: <996a714f-04a0-4d94-9d15-b25ba7e675d2@kernel.org>
Date: Fri, 15 Aug 2025 11:35:41 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/10] scsi: pm80xx: Fix pm8001_abort_task() for
 chip_8006 when using an expander
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Deepak Ukey <deepak.ukey@microsemi.com>, Viswas G <Viswas.G@microsemi.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
 Jack Wang <jinpu.wang@profitbricks.com>, linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-21-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-21-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> For a direct attached device, attached_phy contains the local phy id.
> For a device behind an expander, attached_phy contains the remote phy id,
> not the local phy id.
> 
> The pm8001_ha->phy array only contains the phys of the HBA.
> It does not contain the phys of the expander.
> 
> Thus, you cannot use attached_phy to index the pm8001_ha->phy array,
> without first verifying that the device is directly attached.
> 
> Use the pm80xx_get_local_phy_id() helper to make sure that we use the
> local phy id to index the array, regardless if the device is directly
> attached or not.
> 
> Fixes: 869ddbdcae3b ("scsi: pm80xx: corrected SATA abort handling sequence.")
> Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
