Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF5026AABC;
	Fri, 18 Apr 2025 08:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744964070; cv=none; b=nDsxjDawHTgNEGJyBjNm6qzvi7fb9D7byEZulrD/1ZIF3YJiBYuUCd7M+lH85Na9W3HiFyOjXhAPywImsh5rQsnyQOGSLEXX9x6wXJrT8cXHqhuvgpgidRv1yP8XidDLQASpMje4toScfndABM6FAlQYZAEJKWv7K/YKX1/IFfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744964070; c=relaxed/simple;
	bh=usgwz36iqw3Ng/Ki2l9PhPFoekZl8bhrUuoEP6qcS64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFmGTWXbyrKjIlzkE86z4IXsxd441AmTSXP2oVuhdWbQ8evKFd3ufcYgzE2neeJtMQTlaBukxk/AzC0f8VhkUOgMyLHceUKl8IcPbjnFd1KhQ0e+xSHFyTPW99FG8UAU5OM7a1H4tWWHAgxSVOpNeZZrNKKXraOlPSL/JEkI/FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TwWdEpyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwWdEpyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3A1C4CEE2;
	Fri, 18 Apr 2025 08:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744964069;
	bh=usgwz36iqw3Ng/Ki2l9PhPFoekZl8bhrUuoEP6qcS64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TwWdEpylVtuiVtslm7f0MhT/sE/BEzJX82MxyLmUKyYhC9JjMBQ50SiotMU9q3ZWb
	 A5jtzygpmpNz90PFW8nvZoWyFGbpxi2wOYjQf8eU/r+J3UeG6VxMqq+v+JT9IrL2Ox
	 Kj5MDNNJQl0BJN5SzjTt02ErDmJbEi3D4J8IebGNkA4hhjnxnN0rCauaBZfpJi1sZw
	 iQ+jhNbkov+NaZq2uWU2itrnY5seK3ZdVT3ncEFX5Xd90uB60CrVpMfPF512pu5oZO
	 B4JcKskttNa7p3d8a2nE4/efPgMD1XuCuS3yJ1rlQBjJw9um4elBYk14P7RrKKPn9n
	 /Rfz1UJUtlZow==
Date: Fri, 18 Apr 2025 10:14:25 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/5] ata: libata-scsi: Fix
 ata_mselect_control_ata_feature() return type
Message-ID: <aAIJ4Za6kKCnY8ik@ryzen>
References: <20250418075517.369098-1-dlemoal@kernel.org>
 <20250418075517.369098-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418075517.369098-2-dlemoal@kernel.org>

On Fri, Apr 18, 2025 at 04:55:13PM +0900, Damien Le Moal wrote:
> The function ata_mselect_control_ata_feature() has a return type defined
> as unsigned int but this function may return negative error codes, which
> are correctly propagated up the call chain as integers.
> 
> Fix ata_mselect_control_ata_feature() to have the correct int return
> type.
> 
> While at it, also fix a typo in this function description comment.
> 
> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
