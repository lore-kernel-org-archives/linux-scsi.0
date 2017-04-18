From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: lpfc: fix potential buffer overflow.
Date: Tue, 18 Apr 2017 11:07:13 -0400
Message-ID: <1492528033.27344.167.camel@localhost.localdomain>
References: <1492509351-25441-1-git-send-email-mlombard@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753767AbdDRPHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 11:07:15 -0400
In-Reply-To: <1492509351-25441-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

On Tue, 2017-04-18 at 11:55 +0200, Maurizio Lombardi wrote:
> This patch fixes a potential buffer overflow in lpfc_nvme_info_show().
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 22819af..1ce252f 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -181,7 +181,7 @@
>  				wwn_to_u64(vport->fc_nodename.u.wwn),
>  				phba->targetport->port_id);
>  
> -		len += snprintf(buf + len, PAGE_SIZE,
> +		len += snprintf(buf + len, PAGE_SIZE - len,
>  				"\nNVME Target: Statistics\n");
>  		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
>  		len += snprintf(buf+len, PAGE_SIZE-len,
> @@ -326,7 +326,7 @@
>  	}
>  	spin_unlock_irq(shost->host_lock);
>  
> -	len += snprintf(buf + len, PAGE_SIZE, "\nNVME Statistics\n");
> +	len += snprintf(buf + len, PAGE_SIZE - len, "\nNVME Statistics\n");
>  	len += snprintf(buf+len, PAGE_SIZE-len,
>  			"LS: Xmt %016llx Cmpl %016llx\n",
>  			phba->fc4NvmeLsRequests,

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
