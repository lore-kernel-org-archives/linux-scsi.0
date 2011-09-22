From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] [SCSI] qla2xxx: Fix crash in qla2x00_abort_all_cmds()
 on unload
Date: Thu, 22 Sep 2011 17:38:22 -0400
Message-ID: <alpine.WNT.2.00.1109221737060.7992@N5102REMCQXM4BS.qlogic.org>
References: <1316675165-6207-1-git-send-email-roland@purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:33086
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939Ab1IVVia convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 17:38:30 -0400
In-Reply-To: <1316675165-6207-1-git-send-email-roland@purestorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>

This looks good Roland, thanks.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Thu, 22 Sep 2011, Roland Dreier wrote:

> I hit a crash in qla2x00_abort_all_cmds() if the qla2xxx module is
> unloaded right after it is loaded.  I debugged this down to the abort
> handling improperly treating a command of type SRB_ADISC_CMD as if it
> had a bsg_job to complete when that command actually uses the iocb_cmd
> part of the union.  (I guess to hit this one has to unload the module
> while the async FC initialization is still in progress)
>
> It seems we should only look for a bsg_job if type is SRB_ELS_CMD_RPT,
> SRB_ELS_CMD_HST or SRB_CT_CMD, so switch the test to make that explicit.
>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
> I don't know the code well enough to be sure this is the right fix,
> but there's definitely a crash here :)
>
> drivers/scsi/qla2xxx/qla_os.c |    9 +++++----
> 1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 4cace3f..1e69527 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1328,10 +1328,9 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
>                                       qla2x00_sp_compl(ha, sp);
>                               } else {
>                                       ctx = sp->ctx;
> -                                     if (ctx->type == SRB_LOGIN_CMD ||
> -                                         ctx->type == SRB_LOGOUT_CMD) {
> -                                             ctx->u.iocb_cmd->free(sp);
> -                                     } else {
> +                                     if (ctx->type == SRB_ELS_CMD_RPT ||
> +                                         ctx->type == SRB_ELS_CMD_HST ||
> +                                         ctx->type == SRB_CT_CMD) {
>                                               struct fc_bsg_job *bsg_job =
>                                                   ctx->u.bsg_job;
>                                               if (bsg_job->request->msgcode
> @@ -1343,6 +1342,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
>                                               kfree(sp->ctx);
>                                               mempool_free(sp,
>                                                       ha->srb_mempool);
> +                                     } else {
> +                                             ctx->u.iocb_cmd->free(sp);
>                                       }
>                               }
>                       }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

