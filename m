From: James Smart <james.smart@emulex.com>
Subject: Re: [RFC PATCH] lpfc: additional lpfc_printf_log() to PLOGI and other
 failure cases.
Date: Fri, 12 Feb 2010 10:32:40 -0500
Message-ID: <4B757498.7090509@emulex.com>
References: <4B75196E.9040204@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:44171 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756933Ab0BLPdI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 10:33:08 -0500
In-Reply-To: <4B75196E.9040204@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Kei,

Sounds very reasonable.  Let me pull this into our team. We have a process of 
assigning unique log message numbers, which gets tied to documentation, and 
field support guides.  We'll include an updated version of this patch in a 
future patch set.  Please note though, we're in the final throes of distro 
submissions, so it may be a little delayed.

-- james s


Kei Tokunaga wrote:
> Hi James (Smart),
> 
> This is a RFC for additional logging points to lpfc driver.  lpfc has a logging
> system with lpfc_printf_v/log() functions and it gives us valid messages for
> problem analysis, debugging, etc.  I'd like to suggest some additional logging
> points to it.  Some time ago, we have experienced this issue that took us a
> relatively long time to find out the root cause because we didn't get helpful
> messages we needed to identify the root cause.  From that experience, I think
> adding these would be helpful to prevent the same situation in the future,
> 
> Brief descriptions of the issue:  One customer noticed, from the boot log, one
> of their servers didn't detect a tape library at boot time.  The root cause was
> a hardware failure on the tape library and that caused PLOGI to fail.  However,
> lpfc output no messages indicating the PLOGI failure, and thus that did not give
> us a quick idea of narrowing down to the focus to a hardware failure.
> Fortunately, the customer let us make a debug lpfc driver with some additional
> logging points, and finally we found the cause, but it's not always the case.
> 
> Since each message of lpfc has a four digit ID, in the proposal patch, I just
> put 'xxxx' for now.  This applies to 2.6.33-rc7.
> 
> It'd be really great if something like this patch would be included.
> 
> Thanks,
> Kei
> 
> Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> 
> 
> ---
> 
>  linux-2.6.33-rc7-log-kei/drivers/scsi/lpfc/lpfc_els.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/lpfc/lpfc_els.c~lpfc_printf_log_additions drivers/scsi/lpfc/lpfc_els.c
> --- linux-2.6.33-rc7-log/drivers/scsi/lpfc/lpfc_els.c~lpfc_printf_log_additions	2010-02-12 11:21:49.000000000 +0900
> +++ linux-2.6.33-rc7-log-kei/drivers/scsi/lpfc/lpfc_els.c	2010-02-12 15:11:31.000000000 +0900
> @@ -797,7 +797,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
>  		}
>  
>  		/* FLOGI failure */
> -		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
>  				 "0100 FLOGI failure Data: x%x x%x "
>  				 "x%x\n",
>  				 irsp->ulpStatus, irsp->un.ulpWord[4],
> @@ -1397,6 +1397,9 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
>  			goto out;
>  		}
>  		/* PLOGI failed */
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +			 "xxxx PLOGI failure Data: x%x x%x x%x\n",
> +			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4]);
>  		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
>  		if (lpfc_error_lost_link(irsp))
>  			rc = NLP_STE_FREED_NODE;
> @@ -1565,6 +1568,9 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba
>  			goto out;
>  		}
>  		/* PRLI failed */
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +			 "xxxx PRLI failure Data: x%x x%x x%x\n",
> +			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4]);
>  		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
>  		if (lpfc_error_lost_link(irsp))
>  			goto out;
> @@ -1848,6 +1854,9 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phb
>  			goto out;
>  		}
>  		/* ADISC failed */
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +			 "xxxx ADISC failure Data: x%x x%x x%x\n",
> +			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4]);
>  		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
>  		if (!lpfc_error_lost_link(irsp))
>  			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
> @@ -1997,6 +2006,9 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba
>  			/* ELS command is being retried */
>  			goto out;
>  		/* LOGO failed */
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +			 "xxxx LOGO failure Data: x%x x%x x%x\n",
> +			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4]);
>  		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
>  		if (lpfc_error_lost_link(irsp))
>  			goto out;
> diff -puN drivers/scsi/lpfc/lpfc_scsi.c~lpfc_printf_log_additions drivers/scsi/lpfc/lpfc_scsi.c
> diff -puN drivers/scsi/lpfc/lpfc_sli.c~lpfc_printf_log_additions drivers/scsi/lpfc/lpfc_sli.c
> 
> _
> 
> 
> 
> 
