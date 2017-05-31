From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/1] scsi: scsi_debug: Avoid PI being disabled when
 TGPS is enabled
Date: Wed, 31 May 2017 11:21:44 -0400
Message-ID: <1496244104.4753.104.camel@localhost.localdomain>
References: <20170526165935.19543-1-martin.petersen@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbdEaPVp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 11:21:45 -0400
In-Reply-To: <20170526165935.19543-1-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2017-05-26 at 12:59 -0400, Martin K. Petersen wrote:
> It was not possible to enable both T10 PI and TGPS because they share
> the same byte in the INQUIRY response. Logically OR the TPGS value
> instead of using assignment.
> 
> Reported-by: Ritika Srivastava <ritika.srivastava@oracle.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/scsi_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 17249c3650fe..b945d187873f 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1404,7 +1404,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
>  	arr[5] = (int)have_dif_prot;	/* PROTECT bit */
>  	if (sdebug_vpd_use_hostno == 0)
> -		arr[5] = 0x10; /* claim: implicit TGPS */
> +		arr[5] |= 0x10; /* claim: implicit TGPS */
>  	arr[6] = 0x10; /* claim: MultiP */
>  	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
>  	arr[7] = 0xa; /* claim: LINKED + CMDQUE */

Code is correct.

s/TGPS/TPGS in the subject line and in one place in the patch description.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
