Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40DF3A1E93
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765893693; cv=none; b=TI8vE+/jOAQRvjDQgpVEieWSNKdco8gE4cnCWUe7IUEkQrMGHx5IqwuBrU+abPNqYtbUp9oybLQkDz47RHAtWV/DhFlGQzxfvL8Sc0mWvOxoZXkb2CIUSWLyBQ4mTh9V+yFt+EmbWSCEej5MS6cdevaUdMMxn7nCsqoJXvgFeRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765893693; c=relaxed/simple;
	bh=oLMLPDSmKX95fmwzZCocvRKr/igwreujBG+9lsM7xls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDUlSE6NFNI2PeIdaYMnExczgy1XKP+hL9mz+sorGH7J14PHe1H0yIYiZTXkbP+pYumWhJbtaFaAT5cOBUhuxvqR1ZZ36UFCX09835Lox9PrhMuhJwXURvSIfbHd6QzcpDo0tWTeT5Bq59uX4cYzBY9NhfBFaOvHjHQc8ZVyR5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esMNM1Ed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esMNM1Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4346C4CEF1;
	Tue, 16 Dec 2025 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765893693;
	bh=oLMLPDSmKX95fmwzZCocvRKr/igwreujBG+9lsM7xls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=esMNM1Edv2W5d+zy8dg3chiZZQoFctEoA6M5nJrDkDBAGPFHg/7OHwzHnQ0QX56C6
	 ngjWEBRaKjW/s6rt0PpeO7SR5vtTsQpuUQexYrWnCu4uLrQqs/wFTZTsfD9tgF144Z
	 IRwEdL/ZDSu+hfQTvhcNJxUTDCVZ1yFUS+4rrgtSr+mS1dUZ750ntVy1oZKQtmXw5e
	 NaaQ/j6tAObiT6H5MyCk3Rb/49NB9QV5ZQ11m+hZYL0TUf7LhieF0tp5tZlMoNU9dM
	 t/6R+cq7zqT+ung+Del/OdUf9cHU62+scy7s1jkkM8/2ScM9wuJXKkL9w14uZi9jQ4
	 AGGlb8DohJGKA==
Date: Tue, 16 Dec 2025 06:09:33 -0800
From: Bjorn Andersson <andersson@kernel.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Avri Altman <Avri.Altman@sandisk.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: core: Remove the alignment check in
 ufshcd_memory_alloc()
Message-ID: <7msbtd5kidtokhnjmoaxdc645nhrb6tjwr4ard3u2snidnzghw@jbthlapcjth2>
References: <1764122900-30868-1-git-send-email-shawn.lin@rock-chips.com>
 <DS1PR16MB675374C98979E25FF23177E9E5DEA@DS1PR16MB6753.namprd16.prod.outlook.com>
 <91ef4f89-8f8e-4d55-a2bf-bf3e381f63c2@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91ef4f89-8f8e-4d55-a2bf-bf3e381f63c2@rock-chips.com>

On Wed, Nov 26, 2025 at 03:51:06PM +0800, Shawn Lin wrote:
> 在 2025/11/26 星期三 14:05, Avri Altman 写道:
> > > The dmam_alloc_coherent() function guarantees page-aligned memory on
> > > successful allocation. The current alignment checks using WARN_ON() for buffers
> > > smaller than PAGE_SIZE are therefore redundant and can be safely removed to
> > > simplify the code.
> > The commit that introduced those checks (339aa1221872) for sizes != PAGE_SIZE explained:
> > "...
> >      In the case where these allocations are serviced by e.g. the Arm SMMU, the
> >      size and alignment will be determined by its supported page sizes. In most
> >      cases SZ_4K and a few larger sizes are available.
> > 
> >      In the typical configuration this does not cause problems, but in the event
> >      that the system PAGE_SIZE is increased beyond 4k, it's no longer reasonable
> >      to expect that the allocation will be PAGE_SIZE aligned.
> > ..."
> > 
> 
> Thanks for pointing this out. But I'm thinking the commit message might not
> be correct.
> 

The referred to commit (339aa1221872) adjusted the pre-existing
WARN_ON()s to match the actual described requirements, rather than the
"arbitrary" PAGE_SIZE check.

> Without IOMMU/SMMU support, the allocation must be PAGE_SIZE aligned.
> With IOMMU/SMMU support, the returned address is IOVA, it should be
> the MMU page size aligned. Isn't it always be at least 1K aligned?
> 
> So, what does "the system PAGE_SIZE is increased beyond 4k...." mean
> regarding to this? The only possble way I see here is the MMU used
> with a e.g, 512B page size, so the returned adress could be 512B

"increased beyond 4K" does not include 512B.


The problem resolved by 339aa1221872 was that with 16KB PAGE_SIZE the
check would determine that the 4K-aligned IOVA wasn't PAGE_SIZE
aligned and consider the allocation a failure.

The check in question was introduced in 7a3e97b0dc4b ("[SCSI] ufshcd:
UFS Host controller driver").

> aligned, which couldn't fit for UTRDL. But is that possible? I doubt, or
> maybe I am missing something, please correct me.
> 

So, I merely adjusted the checks to document the alignment requirements.
I do agree that this might be considered a case of defensive
programming, and don't have any strong opinions about dropping these
checks.

So, if we want it this way instead, you have my:

Reviewed-by: Bjorn Andersson <andersson@kernel.org>

Regards,
Bjorn

> 
> > Thanks,
> > Avri
> > > 
> > > Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> > > ---
> > >   drivers/ufs/core/ufshcd.c | 18 +++++++-----------
> > >   1 file changed, 7 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> > > 8f68e305e83c..89737f0c299c 100644
> > > --- a/drivers/ufs/core/ufshcd.c
> > > +++ b/drivers/ufs/core/ufshcd.c
> > > @@ -3916,18 +3916,16 @@ static int ufshcd_memory_alloc(struct ufs_hba
> > > *hba)  {
> > >          size_t utmrdl_size, utrdl_size, ucdl_size;
> > > 
> > > -       /* Allocate memory for UTP command descriptors */
> > > +       /*
> > > +        * Allocate memory for UTP command descriptors
> > > +        * UFSHCI requires 128 byte alignment of UCDL
> > > +        */
> > >          ucdl_size = ufshcd_get_ucd_size(hba) * hba->nutrs;
> > >          hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
> > >                                                    ucdl_size,
> > >                                                    &hba->ucdl_dma_addr,
> > >                                                    GFP_KERNEL);
> > > -
> > > -       /*
> > > -        * UFSHCI requires UTP command descriptor to be 128 byte aligned.
> > > -        */
> > > -       if (!hba->ucdl_base_addr ||
> > > -           WARN_ON(hba->ucdl_dma_addr & (128 - 1))) {
> > > +       if (!hba->ucdl_base_addr) {
> > >                  dev_err(hba->dev,
> > >                          "Command Descriptor Memory allocation failed\n");
> > >                  goto out;
> > > @@ -3942,8 +3940,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
> > >                                                     utrdl_size,
> > >                                                     &hba->utrdl_dma_addr,
> > >                                                     GFP_KERNEL);
> > > -       if (!hba->utrdl_base_addr ||
> > > -           WARN_ON(hba->utrdl_dma_addr & (SZ_1K - 1))) {
> > > +       if (!hba->utrdl_base_addr) {
> > >                  dev_err(hba->dev,
> > >                          "Transfer Descriptor Memory allocation failed\n");
> > >                  goto out;
> > > @@ -3966,8 +3963,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
> > >                                                      utmrdl_size,
> > >                                                      &hba->utmrdl_dma_addr,
> > >                                                      GFP_KERNEL);
> > > -       if (!hba->utmrdl_base_addr ||
> > > -           WARN_ON(hba->utmrdl_dma_addr & (SZ_1K - 1))) {
> > > +       if (!hba->utmrdl_base_addr) {
> > >                  dev_err(hba->dev,
> > >                  "Task Management Descriptor Memory allocation failed\n");
> > >                  goto out;
> > > --
> > > 2.43.0
> > > 
> > 
> > 
> 
