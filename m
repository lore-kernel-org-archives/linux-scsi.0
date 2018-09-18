From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH V13 1/2] scsi: ufs: set the device reference clock setting
Date: Tue, 18 Sep 2018 13:57:09 -0700
Message-ID: <CAE=gft7UFMSyJrZ36iNay-nt6jywzucd4MOeAcErEJg9vpRhwQ@mail.gmail.com>
References: <1536918159-311-1-git-send-email-sayalil@codeaurora.org> <1536918159-311-2-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536918159-311-2-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayali <sayalil@codeaurora.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, stummala@codeaurora.org, adrian.hunter@intel.com, Joel Becker <jlbec@evilplan.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 14, 2018 at 2:43 AM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>
> From: Subhash Jadavani <subhashj@codeaurora.org>
>
> UFS host supplies the reference clock to UFS device and UFS device
> specification allows host to provide one of the 4 frequencies (19.2 MHz,
> 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the
> device reference clock frequency setting in the device based on what
> frequency it is supplying to UFS device.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h           | 14 +++++++
>  drivers/scsi/ufs/ufshcd-pltfrm.c |  2 +
>  drivers/scsi/ufs/ufshcd.c        | 90 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h        |  2 +
>  4 files changed, 108 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 14e5bf7..a2e76b1 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -378,6 +378,20 @@ enum query_opcode {
>         UPIU_QUERY_OPCODE_TOGGLE_FLAG   = 0x8,
>  };
>
> +/* bRefClkFreq attribute values */
> +enum ufs_ref_clk_freq {
> +       REF_CLK_FREQ_19_2_MHZ   = 0,
> +       REF_CLK_FREQ_26_MHZ     = 1,
> +       REF_CLK_FREQ_38_4_MHZ   = 2,
> +       REF_CLK_FREQ_52_MHZ     = 3,
> +       REF_CLK_FREQ_INVAL      = -1,
> +};
> +
> +struct ufs_ref_clk {
> +       u32 freq_hz;
> +       enum ufs_ref_clk_freq val;
> +};
> +
>  /* Query response result code */
>  enum {
>         QUERY_RESULT_SUCCESS                    = 0x00,
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index e82bde0..0953563 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -343,6 +343,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>         pm_runtime_set_active(&pdev->dev);
>         pm_runtime_enable(&pdev->dev);
>
> +       ufshcd_parse_dev_ref_clk_freq(hba);
> +
>         ufshcd_init_lanes_per_dir(hba);
>
>         err = ufshcd_init(hba, mmio_base, irq);
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c5b1bf1..e01cdc0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6296,6 +6296,89 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
>         hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
>  }
>
> +static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
> +       {19200000, REF_CLK_FREQ_19_2_MHZ},
> +       {26000000, REF_CLK_FREQ_26_MHZ},
> +       {38400000, REF_CLK_FREQ_38_4_MHZ},
> +       {52000000, REF_CLK_FREQ_52_MHZ},
> +       {0, REF_CLK_FREQ_INVAL},
> +};
> +
> +static inline enum ufs_ref_clk_freq
> +ufs_get_bref_clk_from_hz(u32 freq)
> +{
> +       int i = 0;
> +
> +       while (ufs_ref_clk_freqs[i].freq_hz != freq) {
> +               if (!ufs_ref_clk_freqs[i].freq_hz)
> +                       return REF_CLK_FREQ_INVAL;
> +               i++;
> +       }
> +
> +       return ufs_ref_clk_freqs[i].val;
> +}
> +
> +void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba)
> +{
> +       struct device *dev = hba->dev;
> +       struct device_node *np = dev->of_node;
> +       struct clk *refclk = NULL;
> +       u32 freq = 0;
> +
> +       if (!np)
> +               return;
> +
> +       refclk = of_clk_get_by_name(np, "ref_clk");
> +       if (!refclk)
> +               return;
> +
> +       freq = clk_get_rate(refclk);
> +
> +       hba->dev_ref_clk_freq =
> +               ufs_get_bref_clk_from_hz(freq);
> +
> +       if (hba->dev_ref_clk_freq == REF_CLK_FREQ_INVAL)
> +               dev_err(hba->dev,
> +               "%s: invalid ref_clk setting = %d\n",
> +               __func__, freq);
> +}
> +
> +static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
> +{
> +       int err, ref_clk = -1;
> +       u32 freq = hba->dev_ref_clk_freq;
> +
> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +                       QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
> +
> +       if (err) {
> +               dev_err(hba->dev, "%s: failed reading bRefClkFreq. err = %d\n",
> +                        __func__, err);
> +               goto out;
> +       }
> +
> +       if (ref_clk == hba->dev_ref_clk_freq)
> +               goto out; /* nothing to update */
> +
> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +                       QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &freq);
> +
> +       if (err) {
> +               dev_err(hba->dev, "%s: bRefClkFreq setting to %u Hz failed\n",
> +               __func__, ufs_ref_clk_freqs[freq].freq_hz);
> +               goto out;
> +       }
> +       /*
> +        * It is good to print this out here to debug any later failures
> +        * related to gear switch.
> +        */
> +       dev_dbg(hba->dev, "%s: bRefClkFreq setting to %u Hz succeeded\n",
> +               __func__, ufs_ref_clk_freqs[freq].freq_hz);
> +

The comment above doesn't add any value in my opinion. Other than that:

Reviewed-by: Evan Green <evgreen@chromium.org>
