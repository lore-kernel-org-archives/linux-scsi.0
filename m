From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 07/18] qla2xxx: Fix to include FCE data as part of dump.
Date: Wed, 14 Dec 2011 16:03:16 +0400
Message-ID: <1323864196.3063.55.camel@dabdike>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
	 <1321635802-16491-8-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44036 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328Ab1LNMDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2011 07:03:21 -0500
In-Reply-To: <1321635802-16491-8-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Fri, 2011-11-18 at 09:03 -0800, Chad Dupuis wrote:
> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index 58e0bfb..8607ab7 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -369,7 +369,7 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
>  
>  	memcpy(iter_reg, ha->fce, ntohl(fcec->size));
>  
> -	return iter_reg;
> +	return (void *)iter_reg + ntohl(fcec->size);

That should be (char *).  (void *) is a pointer to an incomplete type
and as such pointer arithmetic on it is technically illegal.  gcc treats
it as char * for this purpose, so the expression works, but other
compilers (or some future version of gcc) might not be so lenient.

James


