From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 1/1] SCSI: lpfc, restore MSI-X/MSI support
Date: Thu, 14 Jan 2010 12:03:17 -0500
Message-ID: <4B4F4E55.4030206@emulex.com>
References: <87r5pta66n.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:6758 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757102Ab0ANRDl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 12:03:41 -0500
In-Reply-To: <87r5pta66n.fsf@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: George Kadianakis <desnacked@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


The short response:
Acked-by: James Smart  <james.smart@emulex.com>


Background:
Nothing Broke. This was intended.

We had originally enabled MSI-X by default, but in qualification within the 
last 12 months, we encountered a major catch-22:

There were at least 4 platforms, from 2 major OEMs, that :
- Say they support MSI-X - platform routines work and act as if they do.
- We enable it, generate a test interrupt to check they really do deliver it, 
and it works.
- But shortly after attachment, the system hangs or loses interrupts, 
resulting in a bad system behavior.

Given the distro's picking up the 2.6.32 kernel, we had to stick with a 
default of MSI-X off, with user-enabled MSI-X as these platforms couldn't get 
fixed.

However, we're also now encountering platforms that require MSI-X and never 
INTx, so we must change. It's desired also for also for performance reasons.

So - now (2.6.33) is the right time to re-enable MSI-X by default.


-- james s



George Kadianakis wrote:
> From: George Kadianakis <desnacked {bomb} gmail {point} com>
> 
> A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx interrupts.
> This patch restores lpfc's ability to support MSI-X/MSI interrupts that the 
> "Addition of SLI4 Interface - Base Support" patch [2] broke.
> It reestablishes MSI-X as the default interrupt method and in case MSI-X is not 
> supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.
> 
> [1]: http://bugs.gentoo.org/show_bug.cgi?id=296319
> [2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d
> 
> Signed-off-by:  George Kadianakis <desnacked {cat} gmail {dog} com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index e1a30a1..936ecaf 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
>  /*
>  # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
>  # 				 support this feature
> -#       0  = MSI disabled (default)
> +#       0  = MSI disabled
>  #       1  = MSI enabled
> -#       2  = MSI-X enabled
> +#       2  = MSI-X enabled (default)
>  # Value range is [0,2]. Default value is 0.
>  */
> -LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
> +LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
>  					      "MSI-X (2), if possible");
>  
>  /*
> 
