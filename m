Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6539D23373F;
	Wed, 16 Apr 2025 09:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796454; cv=none; b=JDUcuWj+XKBsZWztwVKOnFN9Lar/qp+U8InrTqNq/2h+dJpbe0m/Vw9q0cW5ert3naO+vsi4JcTfN205LQQqHYpxDjKltgO5UyTxVVIcRFdvS+Z/rqoorAkvbk4kVFSN0T2yszqJfFuPXblrVgIwNWzXTq2xpiSC6LD7VqopC1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796454; c=relaxed/simple;
	bh=XssAWd1p2jGH6ND1NzDeR51uRYgzHIAYS0HObScU5/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaTAxbOQwJf91dLVDAG9yBfU+N8oMG33HCUQRVPbPERnn5fr0Apx+fw/nEtxz7JqrZ5AYHOGxE02GivJxfJcgUaxDN8LAgLAfd2M9r0BLVIfI+BVrqfZSfpGjCUTqgW4osiKTYlcYjsjNSBB+M27QD5my0ZeR+z3gRPUXJU5MTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jsTt/31S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jsTt/31S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81C2C4CEE9;
	Wed, 16 Apr 2025 09:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744796453;
	bh=XssAWd1p2jGH6ND1NzDeR51uRYgzHIAYS0HObScU5/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jsTt/31S6X9d+y11dOc5Ls9dFzDXetnlVoABriO8b5eItuwINu1xSoeXsFifjFfTq
	 LrhAoUKbNru160qdmOX2RYKhxnu9+b4kez4xrGB0ChUKQpLE6YhAF5cG9I6Ec+2fh5
	 8RBdmiuj/YwjWLYBZarHjYoR82LbHhSlVXdTSJj3q8/v2ZXGUOHpCExm8MRmKTegTi
	 y3PsOajsn57pGRcnZlXZPb3rSG/1c84VRGQ0jaP+kgtHgDVLmh/zZoDPjdTfe7oaaj
	 DOoYga6bfF8Xg9bRil/r7qo7MTEe/maNKA/k85SHHtAniwaXc3KbahVYwplJ9LtAMK
	 T/p0IdDquSljA==
Date: Wed, 16 Apr 2025 11:40:50 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] ata: libata-scsi: Fix
 ata_msense_control_ata_feature()
Message-ID: <Z_97IlX5SkcC-quG@ryzen>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416084238.258169-2-dlemoal@kernel.org>

On Wed, Apr 16, 2025 at 05:42:36PM +0900, Damien Le Moal wrote:
> For the ATA features subpage of the control mode page, the T10 SAT-6
> specifications state that:
> 
> For a MODE SENSE command, the SATL shall return the CDL_CTRL field value
> that was last set by an application client.
> 
> However, the function ata_msense_control_ata_feature() always sets the
> CDL_CTRL field to the 0x02 value to indicate support for the CDL T2A and
> T2B pages. This is thus incorrect and the value 0x02 must be reported
> only after the user enables the CDL feature, which is indicated with the
> ATA_DFLAG_CDL_ENABLED device flag. When this flag is not set, the
> CDL_CTRL field of the ATA feature subpage of the control mode page must
> report a value of 0x00.
> 
> Fix ata_msense_control_ata_feature() to report the correct values for
> the CDL_CTRL field, according to the enable/disable state of the device
> CDL feature.
> 
> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
