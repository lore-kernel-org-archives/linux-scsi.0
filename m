From: Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH] scsi/mpt2sas: remove unnecesscary preempt requirement
 for MSIX
Date: Tue, 01 May 2012 11:36:27 +0800
Message-ID: <4F9F5A3B.3090905@intel.com>
References: <1335594453-30679-1-git-send-email-alex.shi@intel.com> <A6888A6805518E4EA4AF7072A28264A6067E92EA43@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:57305 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab2EADgf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2012 23:36:35 -0400
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6067E92EA43@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 04/30/2012 01:29 PM, Nandigama, Nagalakshmi wrote:

> Alex, 
> I submitted this patch already. 


Ok. that's fine.

> 
> James, request you to pick up the patch that I previously submitted for fixing this issue. Attaching the patch that I submitted previously.
> 
> 
> Regards,
> Nagalakshmi
> 
> 
> -----Original Message-----
> From: Alex Shi [mailto:alex.shi@intel.com] 
> Sent: Saturday, April 28, 2012 11:58 AM
> To: JBottomley@parallels.com; Nandigama, Nagalakshmi
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; alex.shi@intel.com
> Subject: [PATCH] scsi/mpt2sas: remove unnecesscary preempt requirement for MSIX
> 
> smp_processor_id() need used in preempt safe ENV. Otherwise, the
> cpu may be preempted and run on other cpus. But here, we don't care much
> the specific CPU which handler the MSI, so just replace it by
> raw_smp_processor_id() to avoid preempt debug warning.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 8a59a77..3f518ba 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1785,7 +1785,7 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
>  static inline u8
>  _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
>  {
> -	return ioc->cpu_msix_table[smp_processor_id()];
> +	return ioc->cpu_msix_table[raw_smp_processor_id()];
>  }
>  
>  /**


