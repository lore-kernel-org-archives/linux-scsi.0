Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF513A6F11;
	Thu, 16 Apr 2026 11:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776338022; cv=none; b=RTyPqqcHlxoB+I7rhk5MNHpa5TNYowYO6NHb+mFiMBY662IQmwE2XoPPe5ORT79/fbPBy/TEVydXZJ1REbz039X9KSg6AbBxFW8H+t4HXJ8nsBulDqSWLhUj1eQ8ATEm78lDZptrsIhoKDiFFgzJc86Cmls5Z5Mwt9BT4qm7wZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776338022; c=relaxed/simple;
	bh=IoURMyV74JZ7vHH2VL6tm5dN0q7cZ2av2ER2EyJOI+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSwmvDtX2A6T+ZO9Hn6UEa2aUi4xhbQ2E48pxaZ+4xHxSno2UsF5l2ZpNsqbdtrNZHx8vA/K0WP2v3+lipHaakRoYika9XK+ZJaX+742yu4QMh+rXM/B3hHYW5Eovt5NwJe3anfkIqgbhlFTCmxc+jy613mnb7NdS7xg5WXTTos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fS52uAbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fS52uAbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD26FC2BCB3;
	Thu, 16 Apr 2026 11:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776338021;
	bh=IoURMyV74JZ7vHH2VL6tm5dN0q7cZ2av2ER2EyJOI+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fS52uAbeeXXK8DVZHpgYklq5Q5jriqm0JS6Ef8yK1xarjRwiJjpl50ioJ2dIFWG01
	 P5jwAnID71elRciKGS3og5gJVLNhrZERTJd7hfsoJzGmf03G4PApBtxWYNWgwkyFfS
	 sY1kJOsNiHh0P32wPtG5xMAtZ8Qr7o/rGWGKSKZR1X3Ffblglcqk8cAZJk0Hzk1u8K
	 G0G2V0dPeoFXz64TFcGoWRwd/rqkO/Ounv4XsIe8HjrAn5K5DWtgDKbq/Ayy5qsAna
	 fQl8vSoB22sg9aG8gtPW/FD9T4cvm4RCSVE0sJayCqqZhXv7gAGEbTfJYnml1Myoah
	 JTu4vCDK5aq4w==
Date: Thu, 16 Apr 2026 16:43:34 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: palash.kambar@oss.qualcomm.com
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	bvanassche@acm.org, shawn.lin@rock-chips.com, linux-arm-msm@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH V3 2/2] ufs: ufs-qcom: Enable Auto Hibern8 clock request
 support
Message-ID: <y7424xu5q73pueb55ylsfh3dxxbpsrgo77txtdinuw73wwviz7@sildaawtoq47>
References: <20260414093135.660725-1-palash.kambar@oss.qualcomm.com>
 <20260414093135.660725-3-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260414093135.660725-3-palash.kambar@oss.qualcomm.com>

On Tue, Apr 14, 2026 at 03:01:35PM +0530, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> On platforms that support Auto Hibern8 (AH8), the UFS controller can
> autonomously de-assert clk_req signals to the Global Clock Controller
> when entering the Hibern8 state. This allows Global Clock Controller
> (GCC) to gate unused clocks, improving power efficiency.
> 
> Enable the Clock Request feature by setting the UFS_HW_CLK_CTRL_EN
> bit in the UFS_AH8_CFG register, as recommended in the Hardware
> Programming Guidelines.
> 
> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
>  drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 8ebee0cc5313..ed4c531e1fb2 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -683,6 +683,13 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, bool is_pre_scale_up, unsign
>  	return 0;
>  }
>  
> +static void ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
> +{
> +	if (ufshcd_is_auto_hibern8_supported(hba))
> +		ufshcd_rmwl(hba, UFS_HW_CLK_CTRL_EN, UFS_HW_CLK_CTRL_EN,
> +			    UFS_AH8_CFG);
> +}
> +
>  static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
>  					enum ufs_notify_change_status status)
>  {
> @@ -708,6 +715,9 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
>  		 */
>  		err = ufshcd_disable_host_tx_lcc(hba);
>  
> +		break;
> +	case POST_CHANGE:
> +		ufs_qcom_link_startup_post_change(hba);
>  		break;
>  	default:
>  		break;
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index 380d02333d38..f19def37c86f 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -228,6 +228,17 @@ enum {
>   */
>  #define NUM_TX_R1W1 13
>  
> +/* bit definitions for UFS_AH8_CFG register */
> +#define CC_UFS_SYS_CLK_REQ_EN          BIT(2)
> +#define CC_UFS_ICE_CORE_CLK_REQ_EN     BIT(3)
> +#define CC_UFS_UNIPRO_CORE_CLK_REQ_EN  BIT(4)
> +#define CC_UFS_AUXCLK_REQ_EN           BIT(5)
> +
> +#define UFS_HW_CLK_CTRL_EN	(CC_UFS_SYS_CLK_REQ_EN |\
> +				CC_UFS_ICE_CORE_CLK_REQ_EN |\
> +				CC_UFS_UNIPRO_CORE_CLK_REQ_EN |\
> +				CC_UFS_AUXCLK_REQ_EN)
> +
>  static inline void
>  ufs_qcom_get_controller_revision(struct ufs_hba *hba,
>  				 u8 *major, u16 *minor, u16 *step)
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
