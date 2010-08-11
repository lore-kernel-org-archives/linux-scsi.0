From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] libcxgbi: common library for cxgb3i and cxgb4i
Date: Wed, 11 Aug 2010 13:28:29 -0500
Message-ID: <4C62EBCD.7000301@cs.wisc.edu>
References: <201008091753.o79HrTqQ020147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35456 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0HKSYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2010 14:24:14 -0400
In-Reply-To: <201008091753.o79HrTqQ020147@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rranjan@chelsio.com, James.Bottomley@HansenPartnership.com

On 08/09/2010 12:53 PM, kxie@chelsio.com wrote:
> +void cxgbi_fill_iscsi_transport(struct iscsi_transport *itp)
> +{
> +	/* owner and name should be set already */
> +	itp->caps		= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
> +				| CAP_DATADGST | CAP_DIGEST_OFFLOAD |
> +				CAP_PADDING_OFFLOAD;
> +	itp->param_mask		= ISCSI_MAX_RECV_DLENGTH |
> +				ISCSI_MAX_XMIT_DLENGTH |
> +				ISCSI_HDRDGST_EN |
> +				ISCSI_DATADGST_EN |
> +				ISCSI_INITIAL_R2T_EN |
> +				ISCSI_MAX_R2T |
> +				ISCSI_IMM_DATA_EN |
> +				ISCSI_FIRST_BURST |
> +				ISCSI_MAX_BURST |
> +				ISCSI_PDU_INORDER_EN |
> +				ISCSI_DATASEQ_INORDER_EN |
> +				ISCSI_ERL |
> +				ISCSI_CONN_PORT |
> +				ISCSI_CONN_ADDRESS |
> +				ISCSI_EXP_STATSN |
> +				ISCSI_PERSISTENT_PORT |
> +				ISCSI_PERSISTENT_ADDRESS |
> +				ISCSI_TARGET_NAME | ISCSI_TPGT |
> +				ISCSI_USERNAME | ISCSI_PASSWORD |
> +				ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
> +				ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
> +				ISCSI_LU_RESET_TMO | ISCSI_TGT_RESET_TMO |
> +				ISCSI_PING_TMO | ISCSI_RECV_TMO |
> +				ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME;
> +	itp->host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
> +				ISCSI_HOST_INITIATOR_NAME |
> +				ISCSI_HOST_NETDEV_NAME;
> +	itp->get_host_param	= cxgbi_get_host_param;
> +	itp->set_host_param	= cxgbi_set_host_param;
> +	/* session management */
> +	itp->create_session	= cxgbi_create_session;
> +	itp->destroy_session	= cxgbi_destroy_session;
> +	itp->get_session_param	= iscsi_session_get_param;
> +	/* connection management */
> +	itp->create_conn	= cxgbi_create_conn;
> +	itp->bind_conn		= cxgbi_bind_conn;
> +	itp->destroy_conn	= iscsi_tcp_conn_teardown;
> +	itp->start_conn		= iscsi_conn_start;
> +	itp->stop_conn		= iscsi_conn_stop;
> +	itp->get_conn_param	= cxgbi_get_conn_param;
> +	itp->set_param		= cxgbi_set_conn_param;
> +	itp->get_stats		= cxgbi_get_conn_stats;
> +	/* pdu xmit reqitp->  from user space */
> +	itp->send_pdu		= iscsi_conn_send_pdu;
> +	/* task */
> +	itp->init_task		= iscsi_tcp_task_init;
> +	itp->xmit_task		= iscsi_tcp_task_xmit;
> +	itp->cleanup_task	= cxgbi_cleanup_task;
> +
> +	/* pdu */
> +	itp->alloc_pdu		= cxgbi_conn_alloc_pdu;
> +	itp->init_pdu		= cxgbi_conn_init_pdu;
> +	itp->xmit_pdu		= cxgbi_conn_xmit_pdu;
> +	itp->parse_pdu_itt	= cxgbi_parse_pdu_itt;
> +
> +	/* TCP connect/disconnect */
> +	itp->ep_connect		= cxgbi_ep_connect;
> +	itp->ep_poll		= cxgbi_ep_poll;
> +	itp->ep_disconnect	= cxgbi_ep_disconnect;
> +	/* Error recovery timeout call */
> +	itp->session_recovery_timedout = iscsi_session_recovery_timedout;
> +}
> +EXPORT_SYMBOL_GPL(cxgbi_fill_iscsi_transport);
> +
> +void cxgbi_fill_scsi_host_template(struct scsi_host_template *sht)
> +{
> +	/*
> +	 * the following fields should be set already:
> +	 * module; name, proc_name, can_queue
> +	 */
> +	sht->queuecommand	= iscsi_queuecommand;
> +	sht->change_queue_depth	= iscsi_change_queue_depth;
> +	sht->sg_tablesize	= SG_ALL;
> +	sht->max_sectors	= 0xFFFF;
> +	sht->cmd_per_lun	= ISCSI_DEF_CMD_PER_LUN;
> +	sht->eh_abort_handler	= iscsi_eh_abort;
> +	sht->eh_device_reset_handler = iscsi_eh_device_reset;
> +	sht->eh_target_reset_handler = iscsi_eh_recover_target;
> +	sht->target_alloc	= iscsi_target_alloc;
> +	sht->use_clustering	= DISABLE_CLUSTERING;
> +	sht->this_id		= -1;
> +}
> +EXPORT_SYMBOL_GPL(cxgbi_fill_scsi_host_template);
> +

Can each module just set these callouts in the low level module?
static struct scsi_host_template cxgb3i_host_template = {
         .module         = THIS_MODULE,
         .name           = DRV_MODULE_NAME,
         .proc_name      = DRV_MODULE_NAME,
         .can_queue      = CXGB3I_SCSI_HOST_QDEPTH,
	.queuecommand	= iscsi_queuecommand;
	.change_queue_depth	= iscsi_change_queue_depth;

etc...

Can you just do that for the iscsi_transport callouts too? I think it is 
more standard way of doing it in scsi drivers when there is no need to 
dynamically do it.


If you build both drivers in the kernel instead of modules you get this 
error message:

drivers/scsi/cxgbi/cxgb3i/built-in.o:(.bss+0x0): multiple definition of 
`dbg_level'
drivers/scsi/cxgbi/libcxgbi.o:(.bss+0x0): first defined here
drivers/scsi/cxgbi/cxgb4i/built-in.o:(.bss+0x0): multiple definition of 
`dbg_level'
drivers/scsi/cxgbi/libcxgbi.o:(.bss+0x0): first defined here
make[3]: *** [drivers/scsi/cxgbi/built-in.o] Error 1
make[2]: *** [drivers/scsi/cxgbi] Error 2
