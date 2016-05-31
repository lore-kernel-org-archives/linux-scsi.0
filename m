From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] bnx2fc: replace printk() with BNX2FC_IO_DBG()
Date: Tue, 31 May 2016 13:17:52 +0000
Message-ID: <D37306D9.2921A%chad.dupuis@qlogic.com>
References: <1464597661-6192-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0136.outbound.protection.outlook.com ([65.55.169.136]:63964
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752884AbcEaNvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2016 09:51:44 -0400
In-Reply-To: <1464597661-6192-1-git-send-email-mlombard@redhat.com>
Content-Language: en-US
Content-ID: <0AFBF688DA2631458131A636B01FCCE8@namprd11.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>

> The "fcp_rsp_code = %d" message isn't an error, it's meant to
> be informative only.
> This patch prevents a flood of such messages in some situations.
>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
> drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
>b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 026f394..8f24d60 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1758,7 +1758,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd
>*io_req,
 > 		if ((fcp_rsp_len == 4) || (fcp_rsp_len == 8)) {
 > 			/* Only for task management function */
 > 			io_req->fcp_rsp_code = rq_data[3];
> -			printk(KERN_ERR PFX "fcp_rsp_code = %d\n",
> +			BNX2FC_IO_DBG(io_req, "fcp_rsp_code = %d\n",
 > 				io_req->fcp_rsp_code);
 > 		}
 
> -- 
> Maurizio Lombardi

Make sense to move this to a debug level.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>


