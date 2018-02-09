From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] scsi: ufs-qcom: add number of lanes per direction
Date: Thu, 8 Feb 2018 20:29:15 -0600
Message-ID: <20180209022915.2kki7avsia2k7tjp@rob-hp-laptop>
References: <20180205121021.11012-1-cang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:40610 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbeBIC3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2018 21:29:17 -0500
Content-Disposition: inline
In-Reply-To: <20180205121021.11012-1-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Can Guo <cang@codeaurora.org>
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Noa Rubens <noag@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Maya Erez <merez@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Mon, Feb 05, 2018 at 08:02:07PM +0800, Can Guo wrote:
> From: Gilad Broner <gbroner@codeaurora.org>
> 
> Different platforms may have different number of lanes for the UFS link.
> Add parameter to device tree specifying how many lanes should be
> configured for the UFS link. And don't print err message for clocks
> that are optional, this leads to unnecessary confusion about failure.
> 
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index 5357919..4cee3f9 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -31,6 +31,9 @@ Optional properties:
>  			  defined or a value in the array is "0" then it is assumed
>  			  that the frequency is set by the parent clock or a
>  			  fixed rate clock source.
> +- lanes-per-direction:	number of lanes available per direction - either 1 or 2.
> +			Note that it is assume same number of lanes is used both directions at once.

Seems reasonable until someone does not make things symmetrical. We 
should design for that case.

> +			If not specified, default is 2 lanes per direction.
>  
>  Note: If above properties are not defined it can be assumed that the supply
>  regulators or clocks are always on.
