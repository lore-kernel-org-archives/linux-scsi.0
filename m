From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm_fc: Fix ft_send_tm bug and drop
	ft_lookup_cmd_lun usage
Date: Fri, 27 May 2011 14:50:42 -0700
Message-ID: <1306533042.23461.179.camel@haakon2.linux-iscsi.org>
References: <1306532463-28193-1-git-send-email-nab@linux-iscsi.org>
	 <1306532463-28193-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39291 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1E0V7D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 17:59:03 -0400
In-Reply-To: <1306532463-28193-4-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Kiran Patil <kiran.patil@intel.com>, Open-FCoE devel <devel@open-fcoe.org>

Please disregard this patch, as it uses LIO v4.1
transport_lookup_*_lun() naming change instead of what's current in
mainline..

On Fri, 2011-05-27 at 14:41 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch fixes a bug in ft_send_tm() that was incorrectly calling
> ft_lookup_cmd_lun() -> transport_lookup_cmd_lun(), instead of using
> transport_lookup_tmr_lun() for the proper struct se_lun lookup.
> 
> It also drops the now unnecessary ft_lookup_cmd_lun() code, and uses
> scsilun_to_int() directly ahead of direct transport_lookup_cmd_lun()
> and transport_lookup_tmr_lun() usage.
> 

Please disregard this patch and use PATCH-v2, as the rev below uses the
target core v4.1 transport_lookup_*_lun() naming changes instead of
what's currently in mainline target core.

Thanks,

--nab

> Reported-by: Patil, Kiran <kiran.patil@intel.com>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/tcm_fc/tcm_fc.h  |    2 +-
>  drivers/target/tcm_fc/tfc_cmd.c |   29 ++++-------------------------
>  2 files changed, 5 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
> index defff32..a0b4d5c 100644
> --- a/drivers/target/tcm_fc/tcm_fc.h
> +++ b/drivers/target/tcm_fc/tcm_fc.h
> @@ -144,7 +144,7 @@ enum ft_cmd_state {
>   */
>  struct ft_cmd {
>  	enum ft_cmd_state state;
> -	u16 lun;			/* LUN from request */
> +	u32 lun;			/* LUN from request */
>  	struct ft_sess *sess;		/* session held for cmd */
>  	struct fc_seq *seq;		/* sequence in exchange mgr */
>  	struct se_cmd se_cmd;		/* Local TCM I/O descriptor */
> diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
> index b8345cc..09204f7 100644
> --- a/drivers/target/tcm_fc/tfc_cmd.c
> +++ b/drivers/target/tcm_fc/tfc_cmd.c
> @@ -94,29 +94,6 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
>  		16, 4, cmd->cdb, MAX_COMMAND_SIZE, 0);
>  }
>  
> -/*
> - * Get LUN from CDB.
> - */
> -static int ft_get_lun_for_cmd(struct ft_cmd *cmd, u8 *lunp)
> -{
> -	u64 lun;
> -
> -	lun = lunp[1];
> -	switch (lunp[0] >> 6) {
> -	case 0:
> -		break;
> -	case 1:
> -		lun |= (lunp[0] & 0x3f) << 8;
> -		break;
> -	default:
> -		return -1;
> -	}
> -	if (lun >= TRANSPORT_MAX_LUNS_PER_TPG)
> -		return -1;
> -	cmd->lun = lun;
> -	return transport_get_lun_for_cmd(&cmd->se_cmd, NULL, lun);
> -}
> -
>  static void ft_queue_cmd(struct ft_sess *sess, struct ft_cmd *cmd)
>  {
>  	struct ft_tpg *tpg = sess->tport->tpg;
> @@ -427,7 +404,8 @@ static void ft_send_tm(struct ft_cmd *cmd)
>  	switch (fcp->fc_tm_flags) {
>  	case FCP_TMF_LUN_RESET:
>  		tm_func = TMR_LUN_RESET;
> -		if (ft_get_lun_for_cmd(cmd, fcp->fc_lun) < 0) {
> +		cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
> +		if (transport_lookup_tmr_lun(&cmd->se_cmd, cmd->lun) < 0) {
>  			ft_dump_cmd(cmd, __func__);
>  			transport_send_check_condition_and_sense(&cmd->se_cmd,
>  				cmd->se_cmd.scsi_sense_reason, 0);
> @@ -637,7 +615,8 @@ static void ft_send_cmd(struct ft_cmd *cmd)
>  
>  	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
>  
> -	ret = ft_get_lun_for_cmd(cmd, fcp->fc_lun);
> +	cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
> +	ret = transport_lookup_cmd_lun(&cmd->se_cmd, cmd->lun);
>  	if (ret < 0) {
>  		ft_dump_cmd(cmd, __func__);
>  		transport_send_check_condition_and_sense(&cmd->se_cmd,

