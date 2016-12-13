From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v1 07/12] scsi: ufs: add option to change default UFS
 power management level
Date: Tue, 13 Dec 2016 14:04:27 -0600
Message-ID: <20161213200427.vzdwyzajcftvvcgu@rob-hp-laptop>
References: <1481590462-9981-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481590462-9981-1-git-send-email-subhashj@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Hannes Reinecke <hare@suse.com>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 12, 2016 at 04:54:20PM -0800, Subhash Jadavani wrote:
> UFS device and link can be put in multiple different low power modes hence
> UFS driver supports multiple different low power modes. By default UFS
> driver selects the default (optimal) low power mode (which gives moderate
> power savings and have relatively less enter and exit latencies) but
> we might have to tune this default power mode for different chipset
> platforms to meet the low power requirements/goals. Hence this patch
> adds option to change default UFS low power mode (level).
> 
> Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> ---
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      | 10 ++++++
>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 14 ++++++++
>  drivers/scsi/ufs/ufshcd.c                          | 39 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h                          |  4 +--
>  4 files changed, 65 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index a99ed55..c3836c5 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -41,6 +41,14 @@ Optional properties:
>  -lanes-per-direction	: number of lanes available per direction - either 1 or 2.
>  			  Note that it is assume same number of lanes is used both
>  			  directions at once. If not specified, default is 2 lanes per direction.
> +- rpm-level		: UFS Runtime power management level. Following PM levels are supported:
> +			  0 - Both UFS device and Link in active state (Highest power consumption)
> +			  1 - UFS device in active state but Link in Hibern8 state
> +			  2 - UFS device in Sleep state but Link in active state
> +			  3 - UFS device in Sleep state and Link in hibern8 state (default PM level)
> +			  4 - UFS device in Power-down state and Link in Hibern8 state
> +			  5 - UFS device in Power-down state and Link in OFF state (Lowest power consumption)
> +- spm-level		: UFS System power management level. Allowed PM levels are same as rpm-level.

This looks like you are putting policy for Linux into DT.

What I would expect to see here is disabling of states that don't work 
due to some h/w limitation. Otherwise, it is a user decision for what 
modes to go into. Also, I think link and device states should be 
separate.

Rob
