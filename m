From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up uninitialized
 variables
Date: Thu, 26 Jun 2014 10:02:41 +0200
Message-ID: <53ABD3A1.10400@gmail.com>
References: <1401628410-17824-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401628410-17824-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks good, thanks Rickard.
Acked-by: Jack Wang <xjtuwjp@gmail.com>
On 06/01/2014 03:13 PM, Rickard Strandqvist wrote:
> There is a risk that the variable will be used without being initialized.
> 
> This was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index d70587f..add019b 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -948,7 +948,7 @@ static int
>  pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
>  {
>  	u32 scratch3_value;
> -	int ret;
> +	int ret = -1;
>  
>  	/* Read encryption status from SCRATCH PAD 3 */
>  	scratch3_value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
> @@ -982,7 +982,7 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
>  		pm8001_ha->encrypt_info.status = 0xFFFFFFFF;
>  		pm8001_ha->encrypt_info.cipher_mode = 0;
>  		pm8001_ha->encrypt_info.sec_mode = 0;
> -		return 0;
> +		ret = 0;
>  	} else if ((scratch3_value & SCRATCH_PAD3_ENC_MASK) ==
>  				SCRATCH_PAD3_ENC_DIS_ERR) {
>  		pm8001_ha->encrypt_info.status =
> @@ -1004,7 +1004,6 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
>  			scratch3_value, pm8001_ha->encrypt_info.cipher_mode,
>  			pm8001_ha->encrypt_info.sec_mode,
>  			pm8001_ha->encrypt_info.status));
> -		ret = -1;
>  	} else if ((scratch3_value & SCRATCH_PAD3_ENC_MASK) ==
>  				 SCRATCH_PAD3_ENC_ENA_ERR) {
>  
> @@ -1028,7 +1027,6 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
>  			scratch3_value, pm8001_ha->encrypt_info.cipher_mode,
>  			pm8001_ha->encrypt_info.sec_mode,
>  			pm8001_ha->encrypt_info.status));
> -		ret = -1;
>  	}
>  	return ret;
>  }
> 
