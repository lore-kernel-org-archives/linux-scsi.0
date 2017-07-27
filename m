From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: fix "integer constant too large" error on 32bit archs
Date: Thu, 27 Jul 2017 08:57:19 -0400
Message-ID: <yq1eft2vxzk.fsf@oracle.com>
References: <1501158782-29604-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45361 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdG0M53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2017 08:57:29 -0400
In-Reply-To: <1501158782-29604-1-git-send-email-mlombard@redhat.com> (Maurizio
        Lombardi's message of "Thu, 27 Jul 2017 14:33:02 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Maurizio,

> cc1: warnings being treated as errors
> drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_get_wwpn':
> drivers/scsi/lpfc/lpfc_init.c:3253: error: integer constant is too large for 'long' type
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 491aa95..e992dc1 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3710,8 +3710,8 @@
>  	if (phba->sli_rev == LPFC_SLI_REV4)
>  		return be64_to_cpu(wwn);
>  	else
> -		return (((wwn & 0xffffffff00000000) >> 32) |
> -			((wwn & 0x00000000ffffffff) << 32));
> +		return (((wwn & 0xffffffff00000000ULL) >> 32) |
> +			((wwn & 0x00000000ffffffffULL) << 32));

rol64()?

-- 
Martin K. Petersen	Oracle Linux Engineering
