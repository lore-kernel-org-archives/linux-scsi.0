From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
Date: Tue, 08 Apr 2014 17:04:26 -0700
Message-ID: <1397001866.14321.13.camel@joe-AO722>
References: <1396989746-29647-1-git-send-email-eu@opreamatei.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:56630 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756179AbaDIAE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 20:04:29 -0400
In-Reply-To: <1396989746-29647-1-git-send-email-eu@opreamatei.ro>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matei Oprea <eu@opreamatei.ro>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ROSEdu Kernel Community <firefly@lists.rosedu.org>

On Tue, 2014-04-08 at 23:42 +0300, Matei Oprea wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.
[]
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
[]
> @@ -4742,12 +4742,14 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
[]
> -	if (!phba->sli.ring)
[]
> +	if (unlikely(!phba->sli.ring)) {

Why add the unlikely?

Glancing at the code it seems more like that this
should be likely than unlikely.

> +		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
> +				sizeof(struct lpfc_sli_ring),
> +				GFP_KERNEL);

It'd be nicer looking if aligned better

		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
					 sizeof(struct lpfc_sli_ring),
					 GFP_KERNEL);


