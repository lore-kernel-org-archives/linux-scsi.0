Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1B23D965
	for <linux-scsi@vger.kernel.org>; Wed, 20 Dec 2023 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0H6pHmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DCCC433C7;
	Wed, 20 Dec 2023 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703083708;
	bh=I/6jP1vaGvijlwf4V6lFrk7+x1qlA1aIzuH5r372J/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C0H6pHmSVUuK8ZM22pzH3IOiL6shkSG7ET7Cr02H+6aS/Uj9VYLnMpTWoaIrrhR83
	 5VjzO4l3KOGqfxGutOeZ7a+fUs/rorfQe1PBYOJx9Qt4Iax5mfuXbjd9EU/iWk2ubp
	 8bUJ1W5HPT92+1uw3Gvsxwv7IMTAg81MRIVptE/rDzYkvlUA1IpPgW9rzUQoBI+2eb
	 ShptuuKAyQ06vgeD1ac/EVIQgONgR0In5DBbGBXJ4XPEow3igmB3BFYR/QIjGrjr/j
	 z38UxnYyA46V4JR8WHCQBcWZHRO8kCZR7HJUSDbRXK7kDETl74mJm6hCZ6ofugurzy
	 KKDcvSukt7g3g==
Date: Wed, 20 Dec 2023 20:18:13 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Avri Altman <avri.altman@wdc.com>, Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Remove the ufshcd_hba_exit() call from
 ufshcd_async_scan()
Message-ID: <20231220144813.GH3544@thinkpad>
References: <20231218225229.2542156-1-bvanassche@acm.org>
 <20231218225229.2542156-3-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231218225229.2542156-3-bvanassche@acm.org>

On Mon, Dec 18, 2023 at 02:52:15PM -0800, Bart Van Assche wrote:
> Calling ufshcd_hba_exit() from a function that is called asynchronously
> from ufshcd_init() is wrong because this triggers multiple race
> conditions. Instead of calling ufshcd_hba_exit(), log an error message.
> 

This also means that during failure, resources will not be powered OFF. IMO, a
justification is needed why it is OK to left them powered ON.

> Reported-by: Daniel Mentz <danielmentz@google.com>
> Fixes: 1d337ec2f35e ("ufs: improve init sequence")

No need to backport this patch?

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0ad8bde39cd1..7c59d7a02243 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8982,12 +8982,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  
>  out:
>  	pm_runtime_put_sync(hba->dev);
> -	/*
> -	 * If we failed to initialize the device or the device is not
> -	 * present, turn off the power/clocks etc.
> -	 */
> +
>  	if (ret)
> -		ufshcd_hba_exit(hba);
> +		dev_err(hba->dev, "%s failed: %d\n", __func__, ret);
>  }
>  
>  static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)

-- 
மணிவண்ணன் சதாசிவம்
