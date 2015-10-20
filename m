From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 6/7] bnx2fc: Add HZ to task management timeout.
Date: Tue, 20 Oct 2015 13:47:10 +0200
Message-ID: <562629BE.4020904@redhat.com>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
 <1445283641-7358-7-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbbJTLrM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Oct 2015 07:47:12 -0400
In-Reply-To: <1445283641-7358-7-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 19.10.2015 21:40, Chad Dupuis wrote:
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
> index d46267d..d05866d 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc.h
> +++ b/drivers/scsi/bnx2fc/bnx2fc.h
> @@ -129,7 +129,7 @@
>  #define BNX2FC_MAX_FCP_TGT		256
>  #define BNX2FC_MAX_CMD_LEN		16
>  
> -#define BNX2FC_TM_TIMEOUT		60	/* secs */
> +#define BNX2FC_TM_TIMEOUT		(60 * HZ) /* seconds */

Hi Chad,
when you add HZ here it should be removed from bnx2fc_initiate_tmf :
        rc = wait_for_completion_timeout(&io_req->tm_done,
                                         BNX2FC_TM_TIMEOUT * HZ);
Cheers,
Tomas

>  #define BNX2FC_IO_TIMEOUT		20000UL	/* msecs */
>  
>  #define BNX2FC_WAIT_CNT			1200

