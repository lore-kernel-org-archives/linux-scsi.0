From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] scsi: ufs: Consider device limitations for dma_mask
Date: Fri, 11 Jan 2019 15:33:44 -0800
Message-ID: <CAD=FV=WdCVENn8-5qBUPmiWm5z95_+pxuKv=075e6n1tcaS97w@mail.gmail.com>
References: <20190111225402.6133-1-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111225402.6133-1-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Fri, Jan 11, 2019 at 2:54 PM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Qualcomm SDM845 the capabilities of the UFS MEM controller states
> that it's capable of dealing with 64 bit addresses, but DMA addresses
> are truncated causing IOMMU faults when trying to issue operations.
>
> Limit the DMA mask to that of the device, so that DMA allocations
> is limited to the range supported by the bus and device and not just
> following what the controller's capabilities states.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9ba7671b84f8..dc0eb59dd46f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8151,11 +8151,14 @@ EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
>   */
>  static int ufshcd_set_dma_mask(struct ufs_hba *hba)
>  {
> -       if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
> -               if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
> -                       return 0;
> -       }
> -       return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
> +       u64 dma_mask = dma_get_mask(hba->dev);
> +
> +       if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT)
> +               dma_mask &= DMA_BIT_MASK(64);
> +       else
> +               dma_mask &= DMA_BIT_MASK(32);

Just because I'm annoying like that, I'll point out  that the above is
a bit on the silly side.  Instead I'd do:

if (!(hba->capabilities & MASK_64_ADDRESSING_SUPPORT))
    dma_mask &= DMA_BIT_MASK(32);

AKA: your code is masking a 64-bit variable with a value that is known
to be 0xffffffffffffffff, which is kinda a no-op.


...other than the nit, this seems sane to me.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
