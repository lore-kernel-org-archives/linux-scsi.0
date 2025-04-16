Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F362356A5;
	Wed, 16 Apr 2025 09:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796463; cv=none; b=Mp28Akpe4SrCEg8zmHmQqOAO6rvCXQ5ser4dnkp55QCr9kqRIMwC8pm8fb7Y3k8IteBzIiFiMb12fcpC2VUPYEqIf42a5H1/T/wAk4h7J/m/PyaCcBFpf+MfeeRX4UJrUrwc28XYRCN150vZ1osxObrH2YIqKLlfahazPhBSiV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796463; c=relaxed/simple;
	bh=U+esKU2nW1MaW4zLyj1uKtbjlMljgTyTdw/Q2b8FLjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNFW+/e/0/FkPoGPVpNjv37h3uqIA+iuPBd+KuzyTNN4xpBl4W/rZ8Bs5Ofz1L3hOtr8lgi9fCeYgeim7w0IN7SQ8l3yuyOKor7ej/tzS59cLDBK8scJu8A9uOIJJFRMix2rXFwXrAAADM3g66bSpMKUUugoCGdrWJjOJq5x/hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWMmKqdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWMmKqdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563F3C4CEE2;
	Wed, 16 Apr 2025 09:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744796463;
	bh=U+esKU2nW1MaW4zLyj1uKtbjlMljgTyTdw/Q2b8FLjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rWMmKqdCBj4Y+AJ8QwNZ+t+0BtdCi0BU+7+t7HY+rRaUL4KBhGS1ujucdQbrVtDVh
	 h6B7jdyBmUk1fQNHph5Vo4/VcApZLEgvZUoajf1ltC9aghL3e+eUAetlu8myx4jgBg
	 2oxrwsePqAWcZCuKfrpv05Sz/01X9g6a7so9YMI1gC8vPsrV8wn0rL/XropWw/h8Gs
	 BE/0oKIEzjHqq8JDWvN84fAZQZWvrMCHcaKW15lcTVRvUcfFGoERzmWFIOyPtgliY/
	 qn0yygH8+Vw9bTxqm0hVAgDaCZx3aFXe8XUzvL4DpwNbtbDcDJkW0EXxiRURqpt8Ui
	 D3FkJyVZRGqnQ==
Date: Wed, 16 Apr 2025 11:40:59 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] ata: libata-scsi: Improve CDL control
Message-ID: <Z_97K-6EZBnyE5QW@ryzen>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416084238.258169-3-dlemoal@kernel.org>

On Wed, Apr 16, 2025 at 05:42:37PM +0900, Damien Le Moal wrote:
> With ATA devices supporting the CDL feature, using CDL requires that the
> feature be enabled with a SET FEATURES command. This command is issued
> as the translated command for the MODE SELECT command issued by
> scsi_cdl_enable() when the user enables CDL through the device
> cdl_enable sysfs attribute.
> 
> Currently, ata_mselect_control_ata_feature() always translates a MODE
> SELECT command for the ATA features subpage of the control mode page to
> a SET FEATURES command to enable or disable CDL based on the cdl_ctrl
> field. However, there is no need to issue the SET FEATURES command if:
> 1) The MODE SELECT command requests disabling CDL and CDL is already
>    disabled.
> 2) The MODE SELECT command requests enabling CDL and CDL is already
>    enabled.
> 
> Fix ata_mselect_control_ata_feature() to issue the SET FEATURES command
> only when necessary. Since enabling CDL also implies a reset of the CDL
> statistics log page, avoiding useless CDL enable operations also avoids
> clearing the CDL statistics log.
> 
> Also add debug messages to clearly signal when CDL is being enabled or
> disabled using a SET FEATURES command.
> 
> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
