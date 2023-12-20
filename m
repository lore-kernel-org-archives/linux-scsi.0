Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364F03B1BB;
	Wed, 20 Dec 2023 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecDhaeOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEC1C433C9;
	Wed, 20 Dec 2023 14:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703083375;
	bh=iQr3A3idlvsBQRAD/6AlJxk9PKUXNWI6mN+6Ps3D9sI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ecDhaeOUI7xet5HrGaaO7WZWWA5fud6rmc/07FIW0iVPMjfvC6es7liINO//zx9v0
	 +w5ghfRrSSzc30vC4gNAcixBE3pCiIPBAyqhV0yThPqiJVcpBPZ6klaN4MSE5M0XMs
	 w0qN3eYh6qJs8RUMFaSWrlRCBVH6gAStdRYfDtC/OF++VJxgiPRC6DTsafKbEnjvc1
	 P5PuzEJPXGIeNftrLHLzs6SukrObZyBuwcPi05Dw4N1hn07eOXSBGkx52QqsmIzEcv
	 iKzXZN4rzZr1Lv8ElJXNZGKbqTLBKb75xs8yR2a7zbidWhM55pe5+8/3XNRmBxB55Z
	 +99xCKV6KR16A==
Date: Wed, 20 Dec 2023 20:12:41 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, stable@vger.kernel.org,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: Re: [PATCH 1/2] scsi: ufs: Simplify power management during async
 scan
Message-ID: <20231220144241.GG3544@thinkpad>
References: <20231218225229.2542156-1-bvanassche@acm.org>
 <20231218225229.2542156-2-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231218225229.2542156-2-bvanassche@acm.org>

On Mon, Dec 18, 2023 at 02:52:14PM -0800, Bart Van Assche wrote:
> ufshcd_init() calls pm_runtime_get_sync() before it calls
> async_schedule(). ufshcd_async_scan() calls pm_runtime_put_sync()
> directly or indirectly from ufshcd_add_lus(). Simplify
> ufshcd_async_scan() by always calling pm_runtime_put_sync() from
> ufshcd_async_scan().
> 
> Cc: stable@vger.kernel.org

No fixes tag?

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d6ae5d17892c..0ad8bde39cd1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8711,7 +8711,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>  
>  	ufs_bsg_probe(hba);
>  	scsi_scan_host(hba->host);
> -	pm_runtime_put_sync(hba->dev);
>  
>  out:
>  	return ret;
> @@ -8980,15 +8979,15 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  
>  	/* Probe and add UFS logical units  */
>  	ret = ufshcd_add_lus(hba);
> +
>  out:
> +	pm_runtime_put_sync(hba->dev);
>  	/*
>  	 * If we failed to initialize the device or the device is not
>  	 * present, turn off the power/clocks etc.
>  	 */
> -	if (ret) {
> -		pm_runtime_put_sync(hba->dev);
> +	if (ret)
>  		ufshcd_hba_exit(hba);
> -	}
>  }
>  
>  static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)

-- 
மணிவண்ணன் சதாசிவம்
