From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Fix lpfc oops when parsing dodgy VPD
Date: Thu, 22 Mar 2007 13:13:29 -0400
Message-ID: <4602B939.3050509@emulex.com>
References: <20070321134147.GA7119@kryten>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63514 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140AbXCVRNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2007 13:13:54 -0400
In-Reply-To: <20070321134147.GA7119@kryten>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org

ACK.

To my knowledge bad VPD data had only been found on early prototypes, as they
avoided the typical "manufacturing process".  Regardless, we do try to be
preventative about this type of thing, just in case.

Thanks

-- james s


Anton Blanchard wrote:
> We have seen two cases where VPD on an emulex card has been incorrect
> and we end up walking off the end of memory. It looks like someone made
> an update (increased the length of a string) without increasing the
> Length field. Then we do:
> 
> 	Length -= (3+i);
> 
> And since Length is unsigned it becomes very large and we loop forever
> in the encapsulating:
> 
> 	while (Length > 0) {
> 
> If we make Length signed then we fall out of the loop and proceed on.
> 
> Its important to note we have only seen this in the lab and it may be
> the only two cases of this in existence, but since the rest of the code
> has been written to be resilient against bad VPD we may as well fix this
> too.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: kernel/drivers/scsi/lpfc/lpfc_init.c
> ===================================================================
> --- kernel.orig/drivers/scsi/lpfc/lpfc_init.c	2007-02-07 17:02:43.000000000 -0600
> +++ kernel/drivers/scsi/lpfc/lpfc_init.c	2007-02-07 17:23:31.000000000 -0600
> @@ -662,7 +662,7 @@
>  lpfc_parse_vpd(struct lpfc_hba * phba, uint8_t * vpd, int len)
>  {
>  	uint8_t lenlo, lenhi;
> -	uint32_t Length;
> +	int Length;
>  	int i, j;
>  	int finished = 0;
>  	int index = 0;
> 
