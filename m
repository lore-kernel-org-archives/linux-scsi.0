Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5936A3E3160;
	Fri, 10 Apr 2026 16:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775839908; cv=none; b=hw6r2ePL08hgpuMdEAJmoDq/PbeLmRkZ6BcxtgGMBlBQeIf9ChaAI6dFeCrb9Dl//EvLQqeLMW/K1oYMYnqMGQQv/YRudVXJ2cAdBnejKonorSF/D0FWqww6ZN5LEE9Cl6UCAG4v5fhSnCmEewPXaytcrp74ZzozR/rZUtLOYSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775839908; c=relaxed/simple;
	bh=NQfGQ1DrLGSYbEP7ZD609eRpMsqCIGzMff2uyo3WNVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHtnx17x6oALA/+hDOB9ZdtllZOl3riGp9cwIsjyQd14QhtIYYg78rPiDdb3+iR8+KuiVcxJ34n8RIEW0P1Au74WLbWkKu2CeQc02X22XoTX3U3WrsCYknXpx5JegZ/wJCk0aenPYEdz6DBdHeEk1JSGp/DSpYnEXONWG7gS08c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+A3PRtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+A3PRtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C52C19421;
	Fri, 10 Apr 2026 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775839907;
	bh=NQfGQ1DrLGSYbEP7ZD609eRpMsqCIGzMff2uyo3WNVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o+A3PRtUgea3IQiAC27/t8SEo6+EkHm3jAffV6MNTmZI+rFHVKnUVNAttnK6S+GV5
	 mav0o7GUg3Y8mgKmWnmxTOLU09kBRtNWZdDnPHb5r0m9aG1cODLRVT2E7/agJYhijs
	 jOsiKnc+XRRbBHOv587KtIL6tAAn6ybohfTZWoJ1jd6Ru1Hmf/OZeaDkr39eF75ftD
	 Ul16rJkDp0IBT5MwZIP/EIJlmnEQ/RCcsHhGLoacDhJa7sYGnM1/xP/zYpavAX2swV
	 wR/uoEaB6aGpzXI33upO6wUnHYPXRz3Lfb5N9nnZnrnaVllQiLxuWzEMSfQNM/lnCi
	 n9mrojpQpICXQ==
Date: Fri, 10 Apr 2026 10:51:45 -0600
From: Keith Busch <kbusch@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com, stable@vger.kernel.org,
	Mira Limbeck <m.limbeck@proxmox.com>
Subject: Re: [PATCH v1] mpt3sas: Limit NVMe request size to 2 MiB
Message-ID: <adkqob9VZ-G6mrsW@kbusch-mbp>
References: <20260409184217.32992-1-ranjan.kumar@broadcom.com>
 <eec3bbd3-5503-423b-bb3e-22657026d573@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eec3bbd3-5503-423b-bb3e-22657026d573@kernel.org>

On Fri, Apr 10, 2026 at 06:11:22AM +0200, Damien Le Moal wrote:
> On 2026/04/09 20:42, Ranjan Kumar wrote:
> 
> >  		if (pcie_device->nvme_mdts)
> > -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
> > +			lim->max_hw_sectors = min_t(u32,
> > +					pcie_device->nvme_mdts / 512,
> > +					(SZ_2M / 512) - 8);
> > +		else
> > +			lim->max_hw_sectors = (SZ_2M / 512) - 8;
> 
> I am very confused here: SZ_2MB assumes that you have an SSD with a minimum page
> size of 4K, which can fit 4K / 8 = 512 PRP entries, each referencing 4K (one
> page), so a maximum of 2MiB. However, if I am not mistaken, there is nothing in
> nvme specs that forces the MPS field to be 0 (which leads to a page size of 4K).
>
> So this seems incorrect to me, even though that will probably work for the vast
> majority of SSDs out there, some exotic ones will not be correctly supported.
> 
> Keith ? Am I missing something here ?
> 
> Or do we simply do not care about SSDs with a minimum page size > 4K having
> their maximum command size truncated ?

Spec doesn't require it, but industry converged on that as always being
the minimum supported page size. The nvme driver rejects any device that
doesn't support 4k pages because they can't be reliably supported on a
lot of archs, even ones with larger page sizes. So it should be a safe
assumption that everyone supports 4k since no on is complaining. :)

On the patch, I initially left the "- 8" in the calculation to account
for page offsets. But it's not necessary because that gets absorbed in
PRP1 within the command, so we'd have at most 512 entries in the PRP
list for a 2M transfer.
