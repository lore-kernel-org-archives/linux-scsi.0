From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/10] mpt3sas: Fix for incorrect numbers for MSIX vectors
 enabled when non RDPQ card is enumerated first.
Date: Mon, 24 Oct 2016 16:44:20 +0200
Message-ID: <7156d6bd-0fab-9dc0-9782-11a1c96aa999@suse.de>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757503AbcJXOoX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 10:44:23 -0400
In-Reply-To: <1476966018-10457-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

On 10/20/2016 02:20 PM, Suganath Prabu S wrote:
> No. of MSIX vectors supported = min (Total no. of CPU cores,
> MSIX vectors supported by card)
>
> when RDPQ is disabled "max_msix_vectors" module parameter which was
> declared as global was set to '8' and hence if there are more than one card
> in system among which if RDPQ disabled card is enumerated first then only 8
> MSIX vectors was getting enabled for all the cards(including RDPQ enabled
> card,which can support more than 8 MSIX vectors).
>
> Used local variable instead of global variable ,if RDPQ is disabled this
> local variable is set to '8' else it is set to "max_msix_vectors" (by
> default this is set to -1, whose value can be set by user during driver
> load time).So now regardless of whether RDPQ disabled card is enumerated
> first or RDPQ enabled card is enumerated first , MSIX vectors enabled
> depends on the cards capability.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index a1a5ceb..4ea81e1 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1959,7 +1959,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>  {
>  	struct msix_entry *entries, *a;
>  	int r;
> -	int i;
> +	int i, local_max_msix_vectors;
>  	u8 try_msix = 0;
>
>  	if (msix_disable == -1 || msix_disable == 0)
> @@ -1979,13 +1979,15 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>  	  ioc->cpu_count, max_msix_vectors);
>
>  	if (!ioc->rdpq_array_enable && max_msix_vectors == -1)
> -		max_msix_vectors = 8;
> +		local_max_msix_vectors = 8;
> +	else
> +		local_max_msix_vectors = max_msix_vectors;
>
> -	if (max_msix_vectors > 0) {
> -		ioc->reply_queue_count = min_t(int, max_msix_vectors,
> +	if (local_max_msix_vectors > 0) {
> +		ioc->reply_queue_count = min_t(int, local_max_msix_vectors,
>  			ioc->reply_queue_count);
>  		ioc->msix_vector_count = ioc->reply_queue_count;
> -	} else if (max_msix_vectors == 0)
> +	} else if (local_max_msix_vectors == 0)
>  		goto try_ioapic;
>
>  	if (ioc->msix_vector_count < ioc->cpu_count)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
