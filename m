From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 09/12] tcm_fc: Fix ft_send_tm-bug and drop
	ft_get_lun_for_cmd usage
Date: Wed, 22 Jun 2011 11:37:52 -0700
Message-ID: <1308767872.19756.225.camel@haakon2.linux-iscsi.org>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
	 <20110620235936.1777.869.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43050 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758720Ab1FVSqs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2011 14:46:48 -0400
In-Reply-To: <20110620235936.1777.869.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Kiran Patil <kiran.patil@intel.com>, target-devel <target-devel@vger.kernel.org>

On Mon, 2011-06-20 at 16:59 -0700, Robert Love wrote:
> From: Kiran Patil <kiran.patil@intel.com>
> 
> This patch fixes a bug in ft_send_tm() that was incorrectly calling
> ft_get_lun_for_cmd() -> transport_get_lun_for_cmd(), instead of using
> transport_get_lun_for_tmr() for the proper struct se_lun lookup.
> 
> It also drops the now unnecessary ft_get_lun_for_cmd() code, and uses
> scsilun_to_int() directly ahead of direct transport_get_lun_for_cmd()
> and transport_get_lun_for_tmr usage().
> 
> Patch was reworked due to NULL pointer access in function transport_get_lun_for_tmr(),
> (NOTE: transport_get_lun_for_tmr access tmr_req pointer which caused
> panic due to NULL pointer access) This patch fixes the issue by re-arranging
> the codepath where function "transport_get_lun_for_tmr" is called
> after tmr request is allocated and made it available as part of se_cmd.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Robert Love <robert.w.love@intel.com>

Hi Robert,

Thanks for the follow up on this.  One comment below..

> ---
>  drivers/target/tcm_fc/tcm_fc.h  |    2 +
>  drivers/target/tcm_fc/tfc_cmd.c |   62 ++++++++++++++++++++-------------------
>  2 files changed, 32 insertions(+), 32 deletions(-)
> 

<SNIP>

>  static void ft_queue_cmd(struct ft_sess *sess, struct ft_cmd *cmd)
>  {
>  	struct se_queue_obj *qobj;
> @@ -426,13 +403,6 @@ static void ft_send_tm(struct ft_cmd *cmd)
>  	switch (fcp->fc_tm_flags) {
>  	case FCP_TMF_LUN_RESET:
>  		tm_func = TMR_LUN_RESET;
> -		if (ft_get_lun_for_cmd(cmd, fcp->fc_lun) < 0) {
> -			ft_dump_cmd(cmd, __func__);
> -			transport_send_check_condition_and_sense(&cmd->se_cmd,
> -				cmd->se_cmd.scsi_sense_reason, 0);
> -			ft_sess_put(cmd->sess);
> -			return;
> -		}
>  		break;
>  	case FCP_TMF_TGT_RESET:
>  		tm_func = TMR_TARGET_WARM_RESET;
> @@ -464,6 +434,35 @@ static void ft_send_tm(struct ft_cmd *cmd)
>  		return;
>  	}
>  	cmd->se_cmd.se_tmr_req = tmr;
> +
> +	switch (fcp->fc_tm_flags) {
> +	case FCP_TMF_LUN_RESET:
> +		cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
> +		if (transport_get_lun_for_tmr(&cmd->se_cmd, cmd->lun) < 0) {
> +			/*
> +			 * Make sure to clean up newly allocated TMR request
> +			 * since "unable to  handle TMR request because failed
> +			 * to get to LUN"
> +			 */
> +			FT_TM_DBG("Failed to get LUN for TMR func %d, "
> +				  "se_cmd %p, unpacked_lun %d\n",
> +				  tm_func, &cmd->se_cmd, cmd->lun);
> +			transport_generic_free_cmd(&cmd->se_cmd, 0, 1, 0);
> +			ft_dump_cmd(cmd, __func__);
> +			transport_send_check_condition_and_sense(&cmd->se_cmd,
> +				cmd->se_cmd.scsi_sense_reason, 0);
> +			ft_sess_put(cmd->sess);
> +			return;

This appears to be incorrect as transport_generic_free_cmd() will
release cmd->se_cmd before transport_send_check_condition_and_sense() is
called.  I think they need to be reversed along the lines of how
ft_send_cmd() failure cases for -ENOMEM and -EINVAL are handled.

Here is a patch for lio-core-2.6.git with TCM v4.1 code to address the
issue, please review and I will plan to respin against mainline and send
off to Linus for -rc5.

Thanks!

--nab

------------------------------------------------------------------------------

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 6333170..1f2e9f5 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -390,6 +390,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 {
        struct se_tmr_req *tmr;
        struct fcp_cmnd *fcp;
+       struct ft_sess *sess;
        u8 tm_func;
 
        fcp = fc_frame_payload_get(cmd->req_frame, sizeof(*fcp));
@@ -399,10 +400,20 @@ static void ft_send_tm(struct ft_cmd *cmd)
                tm_func = TMR_LUN_RESET;
                cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
                if (transport_lookup_tmr_lun(&cmd->se_cmd, cmd->lun) < 0) {
+                       /*
+                        * Make sure to clean up newly allocated TMR request
+                        * since "unable to  handle TMR request because failed
+                        * to get to LUN"
+                        */
+                       FT_TM_DBG("Failed to get LUN for TMR func %d, "
+                               "se_cmd %p, unpacked_lun %d\n",
+                               tm_func, &cmd->se_cmd, cmd->lun);
                        ft_dump_cmd(cmd, __func__);
+                       sess = cmd->sess;
                        transport_send_check_condition_and_sense(&cmd->se_cmd,
                                cmd->se_cmd.scsi_sense_reason, 0);
-                       ft_sess_put(cmd->sess);
+                       transport_generic_free_cmd(&cmd->se_cmd, 0, 0);
+                       ft_sess_put(sess);
                        return;
                }
                break;


