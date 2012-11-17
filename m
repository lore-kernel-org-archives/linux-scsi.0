From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: [PATCH 2/4] qla2xxx: Look up LUN for abort requests
Date: Sat, 17 Nov 2012 13:52:24 -0800
Message-ID: <1353189144.21033.89.camel@haakon2.linux-iscsi.org>
References: <1353081979-29474-1-git-send-email-roland@kernel.org>
	 <1353081979-29474-3-git-send-email-roland@kernel.org>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38297 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2KQVw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Nov 2012 16:52:29 -0500
In-Reply-To: <1353081979-29474-3-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Steve Hodgson <steve@purestorage.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Fri, 2012-11-16 at 08:06 -0800, Roland Dreier wrote:
> From: Steve Hodgson <steve@purestorage.com>
> 
> Search through the list of pending commands on the session list to find
> the command the initiator is actually aborting, so that we can pass the
> correct LUN to the core TMR handling code.
> 
> Signed-off-by: Steve Hodgson <steve@purestorage.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 62aa558..79fbdd7 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1264,9 +1264,26 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
>  	struct abts_recv_from_24xx *abts, struct qla_tgt_sess *sess)
>  {
>  	struct qla_hw_data *ha = vha->hw;
> +	struct se_session *se_sess = sess->se_sess;
>  	struct qla_tgt_mgmt_cmd *mcmd;
> +	struct se_cmd *se_cmd;
> +	u32 lun = 0;
>  	int rc;
>  
> +	spin_lock(&se_sess->sess_cmd_lock);
> +	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> +		struct qla_tgt_cmd *cmd =
> +			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
> +		if (cmd->tag == abts->exchange_addr_to_abort) {
> +			lun = cmd->unpacked_lun;
> +			break;
> +		}
> +	}
> +	spin_unlock(&se_sess->sess_cmd_lock);
> +
> +	if (!lun)
> +		return -ENOENT;
> +

So I'm sure this patch works fine against a private target tree that
uses a hack to always use virtual LUN=0 for management purposes, but
that's not what mainline target does now, does it..?

Fixing this up now with the following patch + squashing into the
original.  Also, please CC' the Qlogic folks in the future for these
types of patches.

Thanks,

--nab

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 79fbdd7..661d33e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1269,6 +1269,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
        struct se_cmd *se_cmd;
        u32 lun = 0;
        int rc;
+       bool found_lun = false;
 
        spin_lock(&se_sess->sess_cmd_lock);
        list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
@@ -1276,12 +1277,13 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
                        container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
                if (cmd->tag == abts->exchange_addr_to_abort) {
                        lun = cmd->unpacked_lun;
+                       found_lun = true;
                        break;
                }
        }
        spin_unlock(&se_sess->sess_cmd_lock);
 
-       if (!lun)
+       if (!found_lun)
                return -ENOENT;
 
        ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,


