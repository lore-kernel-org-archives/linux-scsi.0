From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 02/17] scsi: ufs: add option to change default UFS
 power management level
Date: Thu, 12 Nov 2015 11:39:42 -0600
Message-ID: <20151112173942.GA1369@rob-hp-laptop>
References: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
 <1445874072-25909-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445874072-25909-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 26, 2015 at 05:40:57PM +0200, Yaniv Gardi wrote:
> UFS device and link can be put in multiple different low power modes
> hence UFS driver supports multiple different low power modes.
> By default UFS driver selects the default (optimal) low power mode
> (which gives moderate power savings and have relatively less enter
> and exit latencies) but we might have to tune this default power
> mode for different chipset platforms to meet the low power
> requirements/goals. Hence this patch adds option to change default
> UFS low power mode (level).
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> 
> ---
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  8 +++++
>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 17 +++++++++-
>  drivers/scsi/ufs/ufshcd.c                          | 39 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h                          |  4 +--
>  4 files changed, 65 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index 9fea0de..b7db1c9 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -38,6 +38,14 @@ Optional properties:
>  			  defined or a value in the array is "0" then it is assumed
>  			  that the frequency is set by the parent clock or a
>  			  fixed rate clock source.
> +- rpm-level		: UFS Runtime power management level. Following PM levels are supported:
> +			  0 - Both UFS device and Link in active state (Highest power consumption)
> +			  1 - UFS device in active state but Link in Hibern8 state
> +			  2 - UFS device in Sleep state but Link in active state
> +			  3 - UFS device in Sleep state and Link in hibern8 state (default PM level)
> +			  4 - UFS device in Power-down state and Link in Hibern8 state
> +			  5 - UFS device in Power-down state and Link in OFF state (Lowest power consumption)
> +- spm-level		: UFS System power management level. Allowed PM levels are same as rpm-level.

These seem too Linux specific. What would make them different for 
runtime-PM vs. system suspend? Power mgmt capabilities in the kernel 
change over time (and vary by OS), so you don't want to encode them into 
DT. I would probably define separately what modes the phy supports and 
the device supports. 

Isn't hibern8 required by the MPHY or UniPro spec? If so, that should be 
assumed to be supported and then have a quirk property to flag it as 
broken.

Rob
