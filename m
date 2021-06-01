Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F789C47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DFE613C5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhFANQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 09:16:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42172 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhFANQN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 09:16:13 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4D31C2192B;
        Tue,  1 Jun 2021 13:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622553271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrCohk9IuvQ3JmTJZm0uFZpv0Xz7YNE2vNyumXaK4cw=;
        b=q0B+S9zVDD4eq2DH9wKxyp2IgDzTR2MjE/IgZjFCRDxBT3CBj6l6e/dD3O0CYIrNJCz3P7
        6msaD5n1nPmk4Sm4dgqC7sMntbhTxd+e7BvbAuPY6gLzW3V14KIUaVtHuB2G+ceyy807tV
        E6eidFTk/LwZwtS43EN8L985B/0dWwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622553271;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrCohk9IuvQ3JmTJZm0uFZpv0Xz7YNE2vNyumXaK4cw=;
        b=xRgwoVjTfUVmBV7vvBIke3QQzmw8i+XXc9ferSMLPlXShhFmtXXMsmMS6Y+ZI++X9nkEdJ
        g7AwzW4pdHCErdDQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 1E530118DD;
        Tue,  1 Jun 2021 13:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622553271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrCohk9IuvQ3JmTJZm0uFZpv0Xz7YNE2vNyumXaK4cw=;
        b=q0B+S9zVDD4eq2DH9wKxyp2IgDzTR2MjE/IgZjFCRDxBT3CBj6l6e/dD3O0CYIrNJCz3P7
        6msaD5n1nPmk4Sm4dgqC7sMntbhTxd+e7BvbAuPY6gLzW3V14KIUaVtHuB2G+ceyy807tV
        E6eidFTk/LwZwtS43EN8L985B/0dWwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622553271;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrCohk9IuvQ3JmTJZm0uFZpv0Xz7YNE2vNyumXaK4cw=;
        b=xRgwoVjTfUVmBV7vvBIke3QQzmw8i+XXc9ferSMLPlXShhFmtXXMsmMS6Y+ZI++X9nkEdJ
        g7AwzW4pdHCErdDQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id KMu6BrcytmCMfQAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 01 Jun 2021 13:14:31 +0000
Subject: Re: [PATCH v2 09/10] qla2xxx: Add encryption to IO path
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-10-njavali@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <7c46b8d6-4961-adfb-68c2-7208ae3d85d9@suse.de>
Date:   Tue, 1 Jun 2021 15:14:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210531070545.32072-10-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/21 9:05 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Latest FC adapter from Marvell has the ability to encrypt
> data in flight (EDIF) feature. This feature require an
> application (ex: ipsec, etc) to act as an authenticator.
> 
> After the completion of PLOGI, both sides have authenticated
> and PRLI completion, encrypted IOs are allow to proceed. This patch
> adds the follow:
> - use new FW api to encrypt traffic on the wire.
> - add driver parameter to enable|disable EDIF feature.
> 
> modprobe qla2xxx ql2xsecenable=1
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_edif.c   | 341 ++++++++++++++++++++++++++----
>  drivers/scsi/qla2xxx/qla_fw.h     |   3 +
>  drivers/scsi/qla2xxx/qla_gbl.h    |   4 +
>  drivers/scsi/qla2xxx/qla_gs.c     |   2 +-
>  drivers/scsi/qla2xxx/qla_init.c   |  25 +--
>  drivers/scsi/qla2xxx/qla_iocb.c   |   5 +-
>  drivers/scsi/qla2xxx/qla_mbx.c    |  28 ++-
>  drivers/scsi/qla2xxx/qla_nvme.c   |   4 +
>  drivers/scsi/qla2xxx/qla_os.c     |   9 +-
>  drivers/scsi/qla2xxx/qla_target.c |  41 +++-
>  drivers/scsi/qla2xxx/qla_target.h |  16 +-
>  11 files changed, 407 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 721898afb064..9f66ac6d1c77 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -556,41 +556,30 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>  	}
>  
>  	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> -		if ((fcport->flags & FCF_FCSP_DEVICE)) {
> -			ql_dbg(ql_dbg_edif, vha, 0xf084,
> -			    "%s: sess %p %8phC lid %#04x s_id %06x logout %d\n",
> -			    __func__, fcport, fcport->port_name,
> -			    fcport->loop_id, fcport->d_id.b24,
> -			    fcport->logout_on_delete);
> -
> -			ql_dbg(ql_dbg_edif, vha, 0xf084,
> -			    "keep %d els_logo %d disc state %d auth state %d stop state %d\n",
> -			    fcport->keep_nport_handle,
> -			    fcport->send_els_logo, fcport->disc_state,
> -			    fcport->edif.auth_state, fcport->edif.app_stop);
> -
> -			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
> -				break;
> +		ql_dbg(ql_dbg_edif, vha, 0xf084,
> +		    "%s: sess %p %8phC lid %#04x s_id %06x logout %d\n",
> +		    __func__, fcport, fcport->port_name,
> +		    fcport->loop_id, fcport->d_id.b24,
> +		    fcport->logout_on_delete);
> +
> +		ql_dbg(ql_dbg_edif, vha, 0xf084,
> +		    "keep %d els_logo %d disc state %d auth state %d stop state %d\n",
> +		    fcport->keep_nport_handle,
> +		    fcport->send_els_logo, fcport->disc_state,
> +		    fcport->edif.auth_state, fcport->edif.app_stop);
> +
> +		if (atomic_read(&vha->loop_state) == LOOP_DOWN)
> +			break;
>  
> -			if (!fcport->edif.secured_login)
> -				continue;
> +		fcport->edif.app_started = 1;
> +		fcport->edif.app_stop = 0;
>  
> -			fcport->edif.app_started = 1;
> -			if (fcport->edif.app_stop ||
> -			    (fcport->disc_state != DSC_LOGIN_COMPLETE &&
> -			     fcport->disc_state != DSC_LOGIN_PEND &&
> -			     fcport->disc_state != DSC_DELETED)) {
> -				/* no activity */
> -				fcport->edif.app_stop = 0;
> -
> -				ql_dbg(ql_dbg_edif, vha, 0x911e,
> -				    "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
> -				    __func__, fcport->port_name);
> -				fcport->edif.app_sess_online = 1;
> -				qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
> -			}
> -			qla_edif_sa_ctl_init(vha, fcport);
> -		}
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
> +		    __func__, fcport->port_name);
> +		fcport->edif.app_sess_online = 1;
> +		qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
> +		qla_edif_sa_ctl_init(vha, fcport);
>  	}
>  
>  	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
> @@ -720,10 +709,7 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>  	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
>  	fc_port_t		*fcport = NULL;
>  	port_id_t		portid = {0};
> -	/* port_id_t		portid = {0x10100}; */
> -	/* int i; */
>  
> -	/* ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app auth ok\n", __func__); */
>  
>  	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
>  	    bsg_job->request_payload.sg_cnt, &appplogiok,
> @@ -938,6 +924,9 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>  			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
>  				continue;
>  
> +			app_reply->ports[pcnt].rekey_count =
> +				fcport->edif.rekey_cnt;
> +
>  			app_reply->ports[pcnt].remote_type =
>  				VND_CMD_RTYPE_UNKNOWN;
>  			if (fcport->port_type & (FCT_NVME_TARGET | FCT_TARGET))
> @@ -1089,8 +1078,8 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
>  	if (!vha->hw->flags.edif_enabled ||
>  		test_bit(VPORT_DELETE, &vha->dpc_flags)) {
>  		ql_dbg(ql_dbg_edif, vha, 0x911d,
> -		    "%s edif not enabled or vp delete. bsg ptr done %p\n",
> -		    __func__, bsg_job);
> +		    "%s edif not enabled or vp delete. bsg ptr done %p. dpc_flags %lx\n",
> +		    __func__, bsg_job, vha->dpc_flags);
>  
>  		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
>  		goto done;
> @@ -2270,16 +2259,10 @@ void qla24xx_sa_update_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb)
>  		sa_update_iocb->sa_control |= SA_CNTL_KEY256;
>  		for (itr = 0; itr < 32; itr++)
>  			sa_update_iocb->sa_key[itr] = sa_frame->sa_key[itr];
> -
> -		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x921f, "%s 256 sa key=%32phN\n",
> -		    __func__, sa_update_iocb->sa_key);
>  	} else {
>  		sa_update_iocb->sa_control |= SA_CNTL_KEY128;
>  		for (itr = 0; itr < 16; itr++)
>  			sa_update_iocb->sa_key[itr] = sa_frame->sa_key[itr];
> -
> -		ql_dbg(ql_dbg_edif +  ql_dbg_verbose, vha, 0x921f, "%s 128 sa key=%16phN\n",
> -		    __func__, sa_update_iocb->sa_key);
>  	}
>  
>  	ql_dbg(ql_dbg_edif, vha, 0x921d,
> @@ -2745,6 +2728,276 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
>  	sp->done(sp, 0);
>  }
>  
> +/*
> + * qla28xx_start_scsi_edif() - Send a SCSI type 6 command ot the ISP
> + * @sp: command to send to the ISP
> + * req/rsp queue to use for this request
> + * lock to protect submission
> + *
> + * Returns non-zero if a failure occurred, else zero.
> + */
> +int
> +qla28xx_start_scsi_edif(srb_t *sp)
> +{
> +	int             nseg;
> +	unsigned long   flags;
> +	struct scsi_cmnd *cmd;
> +	uint32_t        *clr_ptr;
> +	uint32_t        index, i;
> +	uint32_t        handle;
> +	uint16_t        cnt;
> +	int16_t        req_cnt;
> +	uint16_t        tot_dsds;
> +	__be32 *fcp_dl;
> +	uint8_t additional_cdb_len;
> +	struct ct6_dsd *ctx;
> +	struct scsi_qla_host *vha = sp->vha;
> +	struct qla_hw_data *ha = vha->hw;
> +	struct cmd_type_6 *cmd_pkt;
> +	struct dsd64	*cur_dsd;
> +	uint8_t		avail_dsds = 0;
> +	struct scatterlist *sg;
> +	struct req_que *req = sp->qpair->req;
> +	spinlock_t *lock = sp->qpair->qp_lock_ptr;
> +
> +	/* Setup device pointers. */
> +	cmd = GET_CMD_SP(sp);
> +
> +	/* So we know we haven't pci_map'ed anything yet */
> +	tot_dsds = 0;
> +
> +	/* Send marker if required */
> +	if (vha->marker_needed != 0) {
> +		if (qla2x00_marker(vha, sp->qpair, 0, 0, MK_SYNC_ALL) !=
> +			QLA_SUCCESS) {
> +			ql_log(ql_log_warn, vha, 0x300c,
> +			    "qla2x00_marker failed for cmd=%p.\n", cmd);
> +			return QLA_FUNCTION_FAILED;
> +		}
> +		vha->marker_needed = 0;
> +	}
> +
> +	/* Acquire ring specific lock */
> +	spin_lock_irqsave(lock, flags);
> +
> +	/* Check for room in outstanding command list. */
> +	handle = req->current_outstanding_cmd;
> +	for (index = 1; index < req->num_outstanding_cmds; index++) {
> +		handle++;
> +		if (handle == req->num_outstanding_cmds)
> +			handle = 1;
> +		if (!req->outstanding_cmds[handle])
> +			break;
> +	}
> +	if (index == req->num_outstanding_cmds)
> +		goto queuing_error;
> +
> +	/* Map the sg table so we have an accurate count of sg entries needed */
> +	if (scsi_sg_count(cmd)) {
> +		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
> +		    scsi_sg_count(cmd), cmd->sc_data_direction);
> +		if (unlikely(!nseg))
> +			goto queuing_error;
> +	} else {
> +		nseg = 0;
> +	}
> +
> +	tot_dsds = nseg;
> +	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
> +	if (req->cnt < (req_cnt + 2)) {
> +		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> +		    rd_reg_dword(req->req_q_out);
> +		if (req->ring_index < cnt)
> +			req->cnt = cnt - req->ring_index;
> +		else
> +			req->cnt = req->length -
> +			    (req->ring_index - cnt);
> +		if (req->cnt < (req_cnt + 2))
> +			goto queuing_error;
> +	}
> +
> +	ctx = sp->u.scmd.ct6_ctx =
> +	    mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
> +	if (!ctx) {
> +		ql_log(ql_log_fatal, vha, 0x3010,
> +		    "Failed to allocate ctx for cmd=%p.\n", cmd);
> +		goto queuing_error;
> +	}
> +
> +	memset(ctx, 0, sizeof(struct ct6_dsd));
> +	ctx->fcp_cmnd = dma_pool_zalloc(ha->fcp_cmnd_dma_pool,
> +	    GFP_ATOMIC, &ctx->fcp_cmnd_dma);
> +	if (!ctx->fcp_cmnd) {
> +		ql_log(ql_log_fatal, vha, 0x3011,
> +		    "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
> +		goto queuing_error;
> +	}
> +
> +	/* Initialize the DSD list and dma handle */
> +	INIT_LIST_HEAD(&ctx->dsd_list);
> +	ctx->dsd_use_cnt = 0;
> +
> +	if (cmd->cmd_len > 16) {
> +		additional_cdb_len = cmd->cmd_len - 16;
> +		if ((cmd->cmd_len % 4) != 0) {
> +			/*
> +			 * SCSI command bigger than 16 bytes must be
> +			 * multiple of 4
> +			 */
> +			ql_log(ql_log_warn, vha, 0x3012,
> +			    "scsi cmd len %d not multiple of 4 for cmd=%p.\n",
> +			    cmd->cmd_len, cmd);
> +			goto queuing_error_fcp_cmnd;
> +		}
> +		ctx->fcp_cmnd_len = 12 + cmd->cmd_len + 4;
> +	} else {
> +		additional_cdb_len = 0;
> +		ctx->fcp_cmnd_len = 12 + 16 + 4;
> +	}
> +
> +	cmd_pkt = (struct cmd_type_6 *)req->ring_ptr;
> +	cmd_pkt->handle = make_handle(req->id, handle);
> +
> +	/*
> +	 * Zero out remaining portion of packet.
> +	 * tagged queuing modifier -- default is TSK_SIMPLE (0).
> +	 */
> +	clr_ptr = (uint32_t *)cmd_pkt + 2;
> +	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
> +	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
> +
> +	/* No data transfer */
> +	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
> +		cmd_pkt->byte_count = cpu_to_le32(0);
> +		goto no_dsds;
> +	}
> +
> +	/* Set transfer direction */
> +	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
> +		cmd_pkt->control_flags = cpu_to_le16(CF_WRITE_DATA);
> +		vha->qla_stats.output_bytes += scsi_bufflen(cmd);
> +		vha->qla_stats.output_requests++;
> +		sp->fcport->edif.tx_bytes += scsi_bufflen(cmd);
> +	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
> +		cmd_pkt->control_flags = cpu_to_le16(CF_READ_DATA);
> +		vha->qla_stats.input_bytes += scsi_bufflen(cmd);
> +		vha->qla_stats.input_requests++;
> +		sp->fcport->edif.rx_bytes += scsi_bufflen(cmd);
> +	}
> +
> +	cmd_pkt->control_flags |= cpu_to_le16(CF_EN_EDIF);
> +	cmd_pkt->control_flags &= ~(cpu_to_le16(CF_NEW_SA));
> +
> +	/* One DSD is available in the Command Type 6 IOCB */
> +	avail_dsds = 1;
> +	cur_dsd = &cmd_pkt->fcp_dsd;
> +
> +	/* Load data segments */
> +	scsi_for_each_sg(cmd, sg, tot_dsds, i) {
> +		dma_addr_t      sle_dma;
> +		cont_a64_entry_t *cont_pkt;
> +
> +		/* Allocate additional continuation packets? */
> +		if (avail_dsds == 0) {
> +			/*
> +			 * Five DSDs are available in the Continuation
> +			 * Type 1 IOCB.
> +			 */
> +			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, req);
> +			cur_dsd = cont_pkt->dsd;
> +			avail_dsds = 5;
> +		}
> +
> +		sle_dma = sg_dma_address(sg);
> +		put_unaligned_le64(sle_dma, &cur_dsd->address);
> +		cur_dsd->length = cpu_to_le32(sg_dma_len(sg));
> +		cur_dsd++;
> +		avail_dsds--;
> +	}
> +
> +no_dsds:
> +	/* Set NPORT-ID and LUN number*/
> +	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
> +	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
> +	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
> +	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
> +	cmd_pkt->vp_index = sp->vha->vp_idx;
> +
> +	cmd_pkt->entry_type = COMMAND_TYPE_6;
> +
> +	/* Set total data segment count. */
> +	cmd_pkt->entry_count = (uint8_t)req_cnt;
> +
> +	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
> +	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
> +
> +	/* build FCP_CMND IU */
> +	int_to_scsilun(cmd->device->lun, &ctx->fcp_cmnd->lun);
> +	ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
> +
> +	if (cmd->sc_data_direction == DMA_TO_DEVICE)
> +		ctx->fcp_cmnd->additional_cdb_len |= 1;
> +	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
> +		ctx->fcp_cmnd->additional_cdb_len |= 2;
> +
> +	/* Populate the FCP_PRIO. */
> +	if (ha->flags.fcp_prio_enabled)
> +		ctx->fcp_cmnd->task_attribute |=
> +		    sp->fcport->fcp_prio << 3;
> +
> +	memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
> +
> +	fcp_dl = (__be32 *)(ctx->fcp_cmnd->cdb + 16 +
> +	    additional_cdb_len);
> +	*fcp_dl = htonl((uint32_t)scsi_bufflen(cmd));
> +
> +	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(ctx->fcp_cmnd_len);
> +	put_unaligned_le64(ctx->fcp_cmnd_dma, &cmd_pkt->fcp_cmnd_dseg_address);
> +
> +	sp->flags |= SRB_FCP_CMND_DMA_VALID;
> +	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
> +	/* Set total data segment count. */
> +	cmd_pkt->entry_count = (uint8_t)req_cnt;
> +	cmd_pkt->entry_status = 0;
> +
> +	/* Build command packet. */
> +	req->current_outstanding_cmd = handle;
> +	req->outstanding_cmds[handle] = sp;
> +	sp->handle = handle;
> +	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
> +	req->cnt -= req_cnt;
> +
> +	/* Adjust ring index. */
> +	wmb();
> +	req->ring_index++;
> +	if (req->ring_index == req->length) {
> +		req->ring_index = 0;
> +		req->ring_ptr = req->ring;
> +	} else {
> +		req->ring_ptr++;
> +	}
> +
> +	/* Set chip new ring index. */
> +	wrt_reg_dword(req->req_q_in, req->ring_index);
> +
> +	spin_unlock_irqrestore(lock, flags);
> +	return QLA_SUCCESS;
> +
> +queuing_error_fcp_cmnd:
> +	dma_pool_free(ha->fcp_cmnd_dma_pool, ctx->fcp_cmnd, ctx->fcp_cmnd_dma);
> +queuing_error:
> +	if (tot_dsds)
> +		scsi_dma_unmap(cmd);
> +
> +	if (sp->u.scmd.ct6_ctx) {
> +		mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
> +		sp->u.scmd.ct6_ctx = NULL;
> +	}
> +	spin_unlock_irqrestore(lock, flags);
> +
> +	return QLA_FUNCTION_FAILED;
> +}
> +
>  /**********************************************
>   * edif update/delete sa_index list functions *
>   **********************************************/
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index 4934b08a8990..c257af8d87fd 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -490,6 +490,9 @@ struct cmd_type_6 {
>  	struct scsi_lun lun;		/* FCP LUN (BE). */
>  
>  	__le16	control_flags;		/* Control flags. */
> +#define CF_NEW_SA			BIT_12
> +#define CF_EN_EDIF			BIT_9
> +#define CF_ADDITIONAL_PARAM_BLK		BIT_8
>  #define CF_DIF_SEG_DESCR_ENABLE		BIT_3
>  #define CF_DATA_SEG_DESCR_ENABLE	BIT_2
>  #define CF_READ_DATA			BIT_1
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index cc78339b47ac..be94b335f211 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -189,6 +189,7 @@ extern int qla2xuseresexchforels;
>  extern int ql2xexlogins;
>  extern int ql2xdifbundlinginternalbuffers;
>  extern int ql2xfulldump_on_mpifail;
> +extern int ql2xsecenable;
>  extern int ql2xenforce_iocb_limit;
>  extern int ql2xabts_wait_nvme;
>  
> @@ -299,6 +300,8 @@ extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
>   */
>  void qla_els_pt_iocb(struct scsi_qla_host *vha,
>  	struct els_entry_24xx *pkt, struct qla_els_pt_arg *a);
> +cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha,
> +		struct req_que *que);
>  extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
>  extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
>  extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
> @@ -990,6 +993,7 @@ void qla_enode_init(scsi_qla_host_t *vha);
>  void qla_enode_stop(scsi_qla_host_t *vha);
>  void qla_edif_flush_sa_ctl_lists(fc_port_t *fcport);
>  void qla_edb_init(scsi_qla_host_t *vha);
> +int qla28xx_start_scsi_edif(srb_t *sp);
>  void qla24xx_sa_update_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb);
>  void qla24xx_sa_replace_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb);
>  void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp);
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index 99fb330053ae..b16b7d16be12 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -632,7 +632,7 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
>  	ct_req->req.rft_id.port_id = port_id_to_be_id(vha->d_id);
>  	ct_req->req.rft_id.fc4_types[2] = 0x01;		/* FCP-3 */
>  
> -	if (vha->flags.nvme_enabled)
> +	if (vha->flags.nvme_enabled && qla_ini_mode_enabled(vha))
>  		ct_req->req.rft_id.fc4_types[6] = 1;    /* NVMe type 28h */
>  
>  	sp->u.iocb_cmd.u.ctarg.req_size = RFT_ID_REQ_SIZE;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index bef9bf59bc50..f6ea51143651 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -345,16 +345,15 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
>  	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport)) {
>  		lio->u.logio.flags |= SRB_LOGIN_PRLI_ONLY;
>  	} else {
> -		if (vha->hw->flags.edif_enabled) {
> -			if (fcport->edif.non_secured_login == 0) {
> -				lio->u.logio.flags |=
> -					(SRB_LOGIN_FCSP | SRB_LOGIN_SKIP_PRLI);
> -				ql_dbg(ql_dbg_disc, vha, 0x2072,
> +		if (vha->hw->flags.edif_enabled &&
> +		    vha->e_dbell.db_flags & EDB_ACTIVE) {
> +			lio->u.logio.flags |=
> +				(SRB_LOGIN_FCSP | SRB_LOGIN_SKIP_PRLI);
> +			ql_dbg(ql_dbg_disc, vha, 0x2072,
>  	"Async-login: w/ FCSP %8phC hdl=%x, loopid=%x portid=%06x\n",
> -				    fcport->port_name, sp->handle,
> -				    fcport->loop_id,
> -				    fcport->d_id.b24);
> -			}
> +			       fcport->port_name, sp->handle,
> +			       fcport->loop_id,
> +			       fcport->d_id.b24);
>  		} else {
>  			lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
>  		}
> @@ -3965,7 +3964,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
>  		}
>  
>  		/* Enable PUREX PASSTHRU */
> -		if (ql2xrdpenable || ha->flags.scm_supported_f)
> +		if (ql2xrdpenable || ha->flags.scm_supported_f ||
> +		    ha->flags.edif_enabled)
>  			qla25xx_set_els_cmds_supported(vha);
>  	} else
>  		goto failed;
> @@ -4150,7 +4150,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
>  	}
>  
>  	/* Move PUREX, ABTS RX & RIDA to ATIOQ */
> -	if (ql2xmvasynctoatio &&
> +	if (ql2xmvasynctoatio && !ha->flags.edif_enabled &&
>  	    (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))) {
>  		if (qla_tgt_mode_enabled(vha) ||
>  		    qla_dual_mode_enabled(vha))
> @@ -4178,7 +4178,8 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
>  			ha->fw_options[2] &= ~BIT_8;
>  	}
>  
> -	if (ql2xrdpenable || ha->flags.scm_supported_f)
> +	if (ql2xrdpenable || ha->flags.scm_supported_f ||
> +	    ha->flags.edif_enabled)
>  		ha->fw_options[1] |= ADD_FO1_ENABLE_PUREX_IOCB;
>  
>  	/* Enable Async 8130/8131 events -- transceiver insertion/removal */
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index ba36084d17a9..67c28a2baeee 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -118,7 +118,7 @@ qla2x00_prep_cont_type0_iocb(struct scsi_qla_host *vha)
>   *
>   * Returns a pointer to the continuation type 1 IOCB packet.
>   */
> -static inline cont_a64_entry_t *
> +cont_a64_entry_t *
>  qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha, struct req_que *req)
>  {
>  	cont_a64_entry_t *cont_pkt;
> @@ -1961,6 +1961,9 @@ qla2xxx_start_scsi_mq(srb_t *sp)
>  	struct qla_hw_data *ha = vha->hw;
>  	struct qla_qpair *qpair = sp->qpair;
>  
> +	if (sp->fcport->edif.enable)
> +		return qla28xx_start_scsi_edif(sp);
> +
>  	/* Acquire qpair specific lock */
>  	spin_lock_irqsave(&qpair->qp_lock, flags);
>  
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index f4b9fa9d8078..f8a060862512 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -61,6 +61,7 @@ static struct rom_cmd {
>  	{ MBC_SET_RNID_PARAMS },
>  	{ MBC_GET_RNID_PARAMS },
>  	{ MBC_GET_SET_ZIO_THRESHOLD },
> +	{ MBC_GET_RNID_PARAMS },
>  };
>  
>  static int is_rom_cmd(uint16_t cmd)
> @@ -739,7 +740,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
>  			mcp->mb[11] |= EXE_FW_FORCE_SEMAPHORE;
>  
>  		mcp->out_mb |= MBX_4 | MBX_3 | MBX_2 | MBX_1 | MBX_11;
> -		mcp->in_mb |= MBX_3 | MBX_2 | MBX_1;
> +		mcp->in_mb |= MBX_5|MBX_3|MBX_2|MBX_1;

Please keep the spacing.

>  	} else {
>  		mcp->mb[1] = LSW(risc_addr);
>  		mcp->out_mb |= MBX_1;
> @@ -795,6 +796,12 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
>  		}
>  	}
>  
> +	if (IS_QLA28XX(ha) && (mcp->mb[5] & BIT_10) && ql2xsecenable) {
> +		ha->flags.edif_enabled = 1;
> +		ql_log(ql_log_info, vha, 0xffff,
> +		    "%s: edif is enabled\n", __func__);
> +	}
> +
>  done:
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1028,
>  	    "Done %s.\n", __func__);
> @@ -4946,7 +4953,7 @@ qla24xx_get_port_login_templ(scsi_qla_host_t *vha, dma_addr_t buf_dma,
>  	return rval;
>  }
>  
> -#define PUREX_CMD_COUNT	2
> +#define PUREX_CMD_COUNT	4
>  int
>  qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
>  {
> @@ -4954,6 +4961,7 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
>  	mbx_cmd_t mc;
>  	mbx_cmd_t *mcp = &mc;
>  	uint8_t *els_cmd_map;
> +	uint8_t active_cnt = 0;
>  	dma_addr_t els_cmd_map_dma;
>  	uint8_t cmd_opcode[PUREX_CMD_COUNT];
>  	uint8_t i, index, purex_bit;
> @@ -4975,10 +4983,20 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
>  	}
>  
>  	/* List of Purex ELS */
> -	cmd_opcode[0] = ELS_FPIN;
> -	cmd_opcode[1] = ELS_RDP;
> +	if (ql2xrdpenable) {
> +		cmd_opcode[active_cnt] = ELS_RDP;
> +		active_cnt++;
> +	}
> +	if (ha->flags.scm_supported_f) {
> +		cmd_opcode[active_cnt] = ELS_FPIN;
> +		active_cnt++;
> +	}
> +	if (ha->flags.edif_enabled) {
> +		cmd_opcode[active_cnt] = ELS_AUTH_ELS;
> +		active_cnt++;
> +	}
>  
> -	for (i = 0; i < PUREX_CMD_COUNT; i++) {
> +	for (i = 0; i < active_cnt; i++) {
>  		index = cmd_opcode[i] / 8;
>  		purex_bit = cmd_opcode[i] % 8;
>  		els_cmd_map[index] |= 1 << purex_bit;
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 0cacb667a88b..3f2585798a44 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -463,6 +463,10 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
>  	} else if (fd->io_dir == 0) {
>  		cmd_pkt->control_flags = 0;
>  	}
> +
> +	if (sp->fcport->edif.enable && fd->io_dir != 0)
> +		cmd_pkt->control_flags |= cpu_to_le16(CF_EN_EDIF);
> +
>  	/* Set BIT_13 of control flags for Async event */
>  	if (vha->flags.nvme2_enabled &&
>  	    cmd->sqe.common.opcode == nvme_admin_async_event) {
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index efc21ef80142..ffc7367fc98e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -53,6 +53,11 @@ static struct kmem_cache *ctx_cachep;
>   */
>  uint ql_errlev = 0x8001;
>  
> +int ql2xsecenable;
> +module_param(ql2xsecenable, int, S_IRUGO);
> +MODULE_PARM_DESC(ql2xsecenable,
> +	"Enable/disable security. 0(Default) - Security disabled. 1 - Security enabled.");
> +
>  static int ql2xenableclass2;
>  module_param(ql2xenableclass2, int, S_IRUGO|S_IRUSR);
>  MODULE_PARM_DESC(ql2xenableclass2,
> @@ -4032,7 +4037,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
>  	if (!ha->srb_mempool)
>  		goto fail_free_gid_list;
>  
> -	if (IS_P3P_TYPE(ha)) {
> +	if (IS_P3P_TYPE(ha) || IS_QLA27XX(ha) || (ql2xsecenable && IS_QLA28XX(ha))) {
>  		/* Allocate cache for CT6 Ctx. */
>  		if (!ctx_cachep) {
>  			ctx_cachep = kmem_cache_create("qla2xxx_ctx",
> @@ -4066,7 +4071,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
>  	    "init_cb=%p gid_list=%p, srb_mempool=%p s_dma_pool=%p.\n",
>  	    ha->init_cb, ha->gid_list, ha->srb_mempool, ha->s_dma_pool);
>  
> -	if (IS_P3P_TYPE(ha) || ql2xenabledif) {
> +	if (IS_P3P_TYPE(ha) || ql2xenabledif || (IS_QLA28XX(ha) && ql2xsecenable)) {
>  		ha->dl_dma_pool = dma_pool_create(name, &ha->pdev->dev,
>  			DSD_LIST_DMA_POOL_SIZE, 8, 0);
>  		if (!ha->dl_dma_pool) {
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 5d9fafa0c5d9..6a89ea47d90e 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1313,8 +1313,8 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
>  	qla24xx_chk_fcp_state(sess);
>  
>  	ql_dbg(ql_log_warn, sess->vha, 0xe001,
> -	    "Scheduling sess %p for deletion %8phC\n",
> -	    sess, sess->port_name);
> +	    "Scheduling sess %p for deletion %8phC fc4_type %x\n",
> +	    sess, sess->port_name, sess->fc4_type);
>  
>  	WARN_ON(!queue_work(sess->vha->hw->wq, &sess->del_work));
>  }
> @@ -2610,6 +2610,7 @@ static int qlt_24xx_build_ctio_pkt(struct qla_qpair *qpair,
>  	struct ctio7_to_24xx *pkt;
>  	struct atio_from_isp *atio = &prm->cmd->atio;
>  	uint16_t temp;
> +	struct qla_tgt_cmd      *cmd = prm->cmd;
>  
>  	pkt = (struct ctio7_to_24xx *)qpair->req->ring_ptr;
>  	prm->pkt = pkt;
> @@ -2642,6 +2643,15 @@ static int qlt_24xx_build_ctio_pkt(struct qla_qpair *qpair,
>  	pkt->u.status0.ox_id = cpu_to_le16(temp);
>  	pkt->u.status0.relative_offset = cpu_to_le32(prm->cmd->offset);
>  
> +	if (cmd->edif) {
> +		if (cmd->dma_data_direction == DMA_TO_DEVICE)
> +			prm->cmd->sess->edif.rx_bytes += cmd->bufflen;
> +		if (cmd->dma_data_direction == DMA_FROM_DEVICE)
> +			prm->cmd->sess->edif.tx_bytes += cmd->bufflen;
> +
> +		pkt->u.status0.edif_flags |= EF_EN_EDIF;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -3332,8 +3342,10 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
>  			if (xmit_type & QLA_TGT_XMIT_STATUS) {
>  				pkt->u.status0.scsi_status =
>  				    cpu_to_le16(prm.rq_result);
> -				pkt->u.status0.residual =
> -				    cpu_to_le32(prm.residual);
> +				if (!cmd->edif)
> +					pkt->u.status0.residual =
> +						cpu_to_le32(prm.residual);
> +
>  				pkt->u.status0.flags |= cpu_to_le16(
>  				    CTIO7_FLAGS_SEND_STATUS);
>  				if (qlt_need_explicit_conf(cmd, 0)) {
> @@ -3980,6 +3992,12 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
>  	if (cmd == NULL)
>  		return;
>  
> +	if ((le16_to_cpu(((struct ctio7_from_24xx *)ctio)->flags) & CTIO7_FLAGS_DATA_OUT) &&
> +	    cmd->sess) {
> +		qlt_chk_edif_rx_sa_delete_pending(vha, cmd->sess,
> +		    (struct ctio7_from_24xx *)ctio);
> +	}
> +
>  	se_cmd = &cmd->se_cmd;
>  	cmd->cmd_sent_to_fw = 0;
>  
> @@ -4050,6 +4068,16 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
>  			qlt_handle_dif_error(qpair, cmd, ctio);
>  			return;
>  		}
> +
> +		case CTIO_FAST_AUTH_ERR:
> +		case CTIO_FAST_INCOMP_PAD_LEN:
> +		case CTIO_FAST_INVALID_REQ:
> +		case CTIO_FAST_SPI_ERR:
> +			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
> +	"qla_target(%d): CTIO with EDIF error status 0x%x received (state %x, se_cmd %p\n",
> +			    vha->vp_idx, status, cmd->state, se_cmd);
> +			break;
> +
>  		default:
>  			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
>  			    "qla_target(%d): CTIO with error status 0x%x received (state %x, se_cmd %p\n",
> @@ -4351,6 +4379,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
>  	qlt_assign_qpair(vha, cmd);
>  	cmd->reset_count = vha->hw->base_qpair->chip_reset;
>  	cmd->vp_idx = vha->vp_idx;
> +	cmd->edif = sess->edif.enable;
>  
>  	return cmd;
>  }
> @@ -4767,7 +4796,9 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
>  	}
>  
>  	if (vha->hw->flags.edif_enabled &&
> -	    vha->e_dbell.db_flags != EDB_ACTIVE) {
> +	    !(vha->e_dbell.db_flags & EDB_ACTIVE) &&
> +	    iocb->u.isp24.status_subcode == ELS_PLOGI &&
> +	    !(le16_to_cpu(iocb->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP)) {
>  		ql_dbg(ql_dbg_disc, vha, 0xffff,
>  			"%s %d Term INOT due to app not available lid=%d, NportID %06X ",
>  			__func__, __LINE__, loop_id, port_id.b24);
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index b910f8f09353..156b950ca7e7 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -239,6 +239,10 @@ struct ctio_to_2xxx {
>  #define CTIO_PORT_LOGGED_OUT		0x29
>  #define CTIO_PORT_CONF_CHANGED		0x2A
>  #define CTIO_SRR_RECEIVED		0x45
> +#define CTIO_FAST_AUTH_ERR		0x63
> +#define CTIO_FAST_INCOMP_PAD_LEN	0x65
> +#define CTIO_FAST_INVALID_REQ		0x66
> +#define CTIO_FAST_SPI_ERR		0x67
>  #endif
>  
>  #ifndef CTIO_RET_TYPE
> @@ -409,7 +413,16 @@ struct ctio7_to_24xx {
>  		struct {
>  			__le16	reserved1;
>  			__le16 flags;
> -			__le32	residual;
> +			union {
> +				__le32	residual;
> +				struct {
> +					uint8_t rsvd1;
> +					uint8_t edif_flags;
> +#define EF_EN_EDIF	BIT_0
> +#define EF_NEW_SA	BIT_1
> +					uint16_t rsvd2;
> +				};
> +			};
>  			__le16 ox_id;
>  			__le16	scsi_status;
>  			__le32	relative_offset;
> @@ -876,6 +889,7 @@ struct qla_tgt_cmd {
>  	unsigned int term_exchg:1;
>  	unsigned int cmd_sent_to_fw:1;
>  	unsigned int cmd_in_wq:1;
> +	unsigned int edif:1;
>  
>  	/*
>  	 * This variable may be set from outside the LIO and I/O completion
> 
Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
