Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21491AF4D5
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2025 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757611042; cv=none; b=tVTjIwEUVPGOGu/Zd3j4JgDrSQbBUXNj5rzkcwTZCewu/gx5f76OFm3oo3c0OJxQB7gnev8XygcaOqAq0CX2kZ+Kly0e257U4IcXwXucs9OejdOMOcMS7YeDObnY627KtMhdHYV2CRLXOzsA5siCDjuFHOUy6VLDbRbkLvN7hHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757611042; c=relaxed/simple;
	bh=DnnmUS/+70UrIWcSO7CIHZCbAgnAodbeYznCyk7E8Mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3wqDQR0zXKQXq0CdPN/8mpzCTtwAJUJqL3qWdAUjt3uHzS0Bgsx2Uzs16RR0TfXJ8WFBgkkWmD487ScA//bHqTZEVpDVqXLs8QeYSZTezPA/uZ7gnx+WRhoqh344Lr2VnmETcZ7vdOrgJsEdPYIgzpuumcZYwz2wtsJKNxAdE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7Qxe47V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7Qxe47V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6F9C4CEF5;
	Thu, 11 Sep 2025 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757611042;
	bh=DnnmUS/+70UrIWcSO7CIHZCbAgnAodbeYznCyk7E8Mk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b7Qxe47VWpRjdtgvlTfUaWD0Ote8aQ1XUdHJda34Q9+DhnXaypPqVHNoXC0AX7w6Z
	 TXO0n6VM6CCsUrOvumjIUZ6yvuV0ejg/SB0nuq54DiB8ihb8rMB3gqloxJ4/KwVbZt
	 fnVxI89nEWHwj7BCWWgrVK7CaHSZ2KhA02gHP4D+o7uBMsEXE4n3IROQaAdQCaFMGY
	 TJ5Ab+GGQ/bYfBs4eKS9yVxhPAVq5CKBKwVA1N5BPgHhk+gQyeYoq6SSMrffkSWNns
	 kPSQRKCpQWAwZVUscXhu8/lES+NncaCHBjP/dcca6Jg6K5yJp2D/tD/evULt+WDHC8
	 BFTrcdeUlEpAw==
Date: Thu, 11 Sep 2025 22:47:13 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Manish Pandey <quic_mapa@quicinc.com>
Subject: Re: [PATCH] ufs: core: Disable timestamp functionality if not
 supported
Message-ID: <r7bsoux2ghp66tujipckfffiupbbphg7gyzgeruwmtby5wxtan@aszoz45kzpbw>
References: <20250909190614.3531435-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250909190614.3531435-1-bvanassche@acm.org>

On Tue, Sep 09, 2025 at 12:06:07PM GMT, Bart Van Assche wrote:
> Some Kioxia UFS 4 devices do not support the qTimestamp attribute.
> Set the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices such
> that no error messages appear in the kernel log about failures to set
> the qTimestamp attribute.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

One comment below.

> ---
>  drivers/ufs/core/ufshcd.c | 6 +++++-
>  include/ufs/ufs_quirks.h  | 3 +++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ca6a0f8ccbea..5d0793d8b0e9 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -316,6 +316,9 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
>  	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
>  	  .model = "THGLF2G9D8KBADG",
>  	  .quirk = UFS_DEVICE_QUIRK_PA_TACTIVATE },
> +	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,

Should we UFS_VENDOR_KIOXIA since the product itself is marketed as a KIOXIA UFS
device?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
