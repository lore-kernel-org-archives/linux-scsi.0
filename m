From: "sayali" <sayalil@codeaurora.org>
Subject: RE: [PATCH V1 1/3] scsi: ufs: set the device reference clock setting
Date: Tue, 5 Jun 2018 16:18:46 +0530
Message-ID: <000801d3fcba$cafa3c30$60eeb490$@codeaurora.org>
References: <1527849774-7623-1-git-send-email-sayalil@codeaurora.org> <1527849774-7623-2-git-send-email-sayalil@codeaurora.org> <CAP2JTQJAyPAJ-uJM3REb02fBLUKkhf28OacEnzNHGidWfu3+YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAP2JTQJAyPAJ-uJM3REb02fBLUKkhf28OacEnzNHGidWfu3+YA@mail.gmail.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Kyuho Choi' <chlrbgh0@gmail.com>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, linux-scsi@vger.kernel.org, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


-----Original Message-----
From: Kyuho Choi [mailto:chlrbgh0@gmail.com]=20
Sent: Saturday, June 02, 2018 11:04 AM
To: Sayali Lokhande <sayalil@codeaurora.org>
Cc: subhashj@codeaurora.org; cang@codeaurora.org; =
vivek.gautam@codeaurora.org; rnayak@codeaurora.org; =
vinholikatti@gmail.com; jejb@linux.vnet.ibm.com; =
martin.petersen@oracle.com; asutoshd@codeaurora.org; =
evgreen@chromium.org; linux-scsi@vger.kernel.org; open list =
<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 1/3] scsi: ufs: set the device reference clock =
setting

Hi Sayali,

On 6/1/18, Sayali Lokhande <sayalil@codeaurora.org> wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
>
> UFS host supplies the reference clock to UFS device and UFS device=20
> specification allows host to provide one of the 4 frequencies (19.2=20
> MHz,
> 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the=20
> device reference clock frequency setting in the device based on what=20
> frequency it is supplying to UFS device.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> [cang@codeaurora.org: Resolved trivial merge conflicts]
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h    |  9 +++++++
>  drivers/scsi/ufs/ufshcd.c | 62
> +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |  1 +
>  3 files changed, 72 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index=20
> 14e5bf7..e15deb0 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -378,6 +378,15 @@ enum query_opcode {
>  	UPIU_QUERY_OPCODE_TOGGLE_FLAG	=3D 0x8,
>  };
>
> +/* bRefClkFreq attribute values */
> +enum ref_clk_freq {
> +	REF_CLK_FREQ_19_2_MHZ	=3D 0x0,
> +	REF_CLK_FREQ_26_MHZ	=3D 0x1,
> +	REF_CLK_FREQ_38_4_MHZ	=3D 0x2,
> +	REF_CLK_FREQ_52_MHZ	=3D 0x3,
> +	REF_CLK_FREQ_MAX	=3D REF_CLK_FREQ_52_MHZ,
> +};
> +
>  /* Query response result code */
>  enum {
>  	QUERY_RESULT_SUCCESS                    =3D 0x00,
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c=20
> index c5b1bf1..3669bc4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6297,6 +6297,63 @@ static void ufshcd_def_desc_sizes(struct=20
> ufs_hba
> *hba)
>  }
>
>  /**
> + * ufshcd_set_dev_ref_clk - set the device bRefClkFreq
> + * @hba: per-adapter instance
> + * @ref_clk_freq: refrerence clock frequency to be set
> + *
> + * Read the current value of the bRefClkFreq attribute from device=20
> + and
> update it
> + * if host is supplying different reference clock frequency than one
> mentioned
> + * in bRefClkFreq attribute.
> + *
> + * Returns zero on success, non-zero error value on failure.
> + */
> +static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba, u32=20
> +ref_clk_freq) {
> +	int err =3D 0;
> +	int ref_clk =3D -1;
> +	static const char * const ref_clk_freqs[] =3D {"19.2 MHz", "26 MHz",
> +						     "38.4 MHz", "52 MHz"};
> +
> +	hba->dev_ref_clk_freq =3D ref_clk_freq;
> +	err =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
> +
> +	if (err) {
> +		dev_err(hba->dev, "%s: failed reading bRefClkFreq. err =3D %d\n",
> +			 __func__, err);
> +		goto out;
> +	}
> +
> +	if ((ref_clk < 0) || (ref_clk > REF_CLK_FREQ_52_MHZ)) {
> +		dev_err(hba->dev, "%s: invalid ref_clk setting =3D %d\n",
> +			 __func__, ref_clk);
> +		err =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	if (ref_clk =3D=3D hba->dev_ref_clk_freq)
> +		goto out; /* nothing to update */
> +
> +	err =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0,
> +			&hba->dev_ref_clk_freq);
> +
> +	if (err)
> +		dev_err(hba->dev, "%s: bRefClkFreq setting to %s failed\n",
> +			__func__, ref_clk_freqs[hba->dev_ref_clk_freq]);
> +	else
> +		/*
> +		 * It is good to print this out here to debug any later failures
> +		 * related to gear switch.
> +		 */
> +		dev_info(hba->dev, "%s: bRefClkFreq setting to %s succeeded\n",
> +			__func__, ref_clk_freqs[hba->dev_ref_clk_freq]);
> +
> +out:
> +	return err;
> +}
> +
> +/**
>   * ufshcd_probe_hba - probe hba to detect device and initialize
>   * @hba: per-adapter instance
>   *
> @@ -6361,6 +6418,11 @@ static int ufshcd_probe_hba(struct ufs_hba =
*hba)
>  			"%s: Failed getting max supported power mode\n",
>  			__func__);
>  	} else {
> +		/*
> +		 * Set the right value to bRefClkFreq before attempting to
> +		 * switch to HS gears.
> +		 */
> +		ufshcd_set_dev_ref_clk(hba, REF_CLK_FREQ_19_2_MHZ);

How it works in 26MHz refclk support host like exynos series?. As I =
understood, there default refclk value are 26MHz for host and device.
In that case, your code maybe set device's refclk to 19.2MHz. It would =
be need to set same refclk value both host and device for switch to HS.
[Sayali] : As per HPG, we set ref_clk to 19.2 Mhz (for host and device). =
But as it can vary for others (like exynos as you pointed), I think its =
better to parse ref_clk frequency from device tree instead of passing =
hardcoded value. DT approach was present in my previous patchset, I will =
update/add it again in my next patch set.

>  		ret =3D ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
>  		if (ret) {
>  			dev_err(hba->dev, "%s: Failed setting power mode, err =3D %d\n",=20
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h=20
> index 8110dcd..b026ad8 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -548,6 +548,7 @@ struct ufs_hba {
>  	void *priv;
>  	unsigned int irq;
>  	bool is_irq_enabled;
> +	u32 dev_ref_clk_freq;
>
>  	/* Interrupt aggregation support is broken */
>  	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			0x1
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora=20
> Forum, a Linux Foundation Collaborative Project
>
>

BR,
Kyuho Choi
