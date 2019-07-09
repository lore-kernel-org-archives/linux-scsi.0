From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Allow resetting the UFS device
Date: Mon, 8 Jul 2019 19:48:32 -0600
Message-ID: <20190709014832.GA14402@bogus>
References: <20190606010249.3538-1-bjorn.andersson@linaro.org>
 <20190606010249.3538-3-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190606010249.3538-3-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Evan Green <evgreen@chromium.org>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 05, 2019 at 06:02:48PM -0700, Bjorn Andersson wrote:
> Acquire the device-reset GPIO and toggle this to reset the UFS device
> during initialization and host reset.
> 
> Based on downstream support implemented by Subhash Jadavani
> <subhashj@codeaurora.org>.
> 
> Tested-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> Changes since v1:
> - Added gpio to DT binding document
> - Fixed spelling of UFS
> 
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |  2 +
>  drivers/scsi/ufs/ufshcd.c                     | 44 +++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h                     |  4 ++
>  3 files changed, 50 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index a74720486ee2..d562d8b4919c 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -54,6 +54,8 @@ Optional properties:
>  			  PHY reset from the UFS controller.
>  - resets            : reset node register
>  - reset-names       : describe reset node register, the "rst" corresponds to reset the whole UFS IP.
> +- device-reset-gpios	: A phandle and gpio specifier denoting the GPIO connected
> +			  to the RESET pin of the UFS memory device.

A sign we should have a child node for the device...

Doesn't using 'reset-gpios' work as I doubt one would have a GPIO reset 
for the host controller.

Rob
