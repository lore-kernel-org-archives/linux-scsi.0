Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFF6274670
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 21:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792358558; cv=none; b=GOhVtBsBEE3dBxnzOlgmLqK9cOS7T0omEC2B7z8tekJy9RE0jicHnHCZBfCaiTZ/XXZyqeJ1XHBUe9FMoaaSympcoO6KcR410yJ8oZMeFNqfyi3EUeTBWpm6JRsVKQd73rcbXG2Vrsv6Q6rPeI4YTiydiHEnV0io+nxIUuZIgyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792358558; c=relaxed/simple;
	bh=203nEX9q03IATly5lqnbkHoUmoAeWt7CKG+7sa9fink=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=on2/dI9JGEJL/PYPdBdUkuxcNLCFrIqnRo82yVtL9iO89gfQAu2/LPlqO8gTE8mHwFarQFxWPjbPhcB2phsMLm1547H3h55VeHLxLTfJ7cOGFirNpr4j6RLTetGJyHpVT0zB+uCI1g1cALAHsXf5l/gvBXDitxU8v+pDj+UBvKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CN3iX7sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CN3iX7sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7191F000C4;
	Sun, 18 Oct 2026 21:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792358556;
	bh=GeNOw4DnFvGY6WUMf07v9EY5fb9thQ4uVdhqf4N8UL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CN3iX7skZV6kVz6Ol4GKg3Y5iznJU1UKuf/x0nhSLM1FaEoAD3fVTz+MIS7leQ+En
	 U+JL2eMJmHaPnPQV0BlC9v5NPEDWtXJWz5xLULZ16MzkqyEy89rulriBUqRoKSx4Qs
	 qy8di+oeWredBUG7Qxd44DeooI7rIne1eMh6tIcTATQVMexhbaINM2OPBOMtL2OsU/
	 kf9XC9Ik0i/H+M2VnWE8tUYuA6o2VFyrYYNktNMGsjF12cEB/hGhK2lE1scuFWTO/7
	 e8m5o7+NPS/Df6PPXIy9vfNZGraByvl6FvW7fQSgyzVaiYOTiM0EhdsNtKV5MMxofV
	 XN1czUIMqU6Sg==
Date: Sun, 18 Oct 2026 14:22:32 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH] scsi: fnic: Annotate fnic_nvme functions with
 __must_hold()
Message-ID: <20261018212232.GA4068315@ax162>
References: <3c41b84d7d832dd767b30bc04cf875f800ce748d.1792283587.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c41b84d7d832dd767b30bc04cf875f800ce748d.1792283587.git.bvanassche@acm.org>

On Sat, Oct 17, 2026 at 05:40:51PM -0700, Bart Van Assche wrote:
> Add __must_hold() annotations for fnic_lock to
> nvfnic_process_ls_abts_rsp(), nvfnic_ls_rsp_recv(),
> nvfnic_delete_tport(), and nvfnic_add_tport() in
> drivers/scsi/fnic/fnic_nvme.c.
> 
> Document that callers must hold fnic_lock on entry and exit because
> these functions temporarily release and reacquire fnic_lock, and
> suppress context imbalance warnings reported by lock context analysis
> and sparse.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Closes: https://lore.kernel.org/all/20261016023120.GA2863622@ax162/
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Tested-by: Nathan Chancellor <nathan@kernel.org> # build

> ---
>  drivers/scsi/fnic/fnic_nvme.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 00d9d5d439a3..d1b327c5c5e0 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
> @@ -1284,6 +1284,7 @@ void nvfnic_fcpio_cmpl(struct fnic_io_req *io_req)
>  
>  void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
>  		struct fc_frame_header *fchdr)
> +	__must_hold(&iport->fnic->fnic_lock)
>  {
>  	uint32_t tport_fcid;
>  	struct fnic_tport_s *tport;
> @@ -1348,6 +1349,7 @@ void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
>   */
>  void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
>  		struct fc_frame_header *fchdr, int len)
> +	__must_hold(&iport->fnic->fnic_lock)
>  {
>  	uint8_t *fcid;
>  	uint32_t tport_fcid;
> @@ -2086,6 +2088,7 @@ void nvfnic_exch_reset(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
>  void nvfnic_delete_tport(struct fnic_iport_s *iport,
>  						struct fnic_tport_s *tport,
>  						unsigned long flags)
> +	__must_hold(&iport->fnic->fnic_lock)
>  {
>  	struct fnic *fnic = iport->fnic;
>  	int ret;
> @@ -2179,6 +2182,7 @@ void nvfnic_delete_tport(struct fnic_iport_s *iport,
>  
>  int nvfnic_add_tport(struct fnic *fnic, struct fnic_tport_s *tport,
>  		     unsigned long flags)
> +	__must_hold(&fnic->fnic_lock)
>  {
>  	struct fnic_iport_s *iport = &fnic->iport;
>  	struct nvme_fc_port_info pinfo;

-- 
Cheers,
Nathan
