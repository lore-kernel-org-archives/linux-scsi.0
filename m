From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH 2/2] qla2xxx: Code changes for qla data structure refactoring
Date: Thu, 22 Jan 2009 02:50:16 -0800
Message-ID: <20090122105016.GA100061@sgi.com>
References: <alpine.OSX.1.00.0811061031030.605@ac-mac.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.171.31]:40400 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752318AbZAVKuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 05:50:19 -0500
Content-Disposition: inline
In-Reply-To: <alpine.OSX.1.00.0811061031030.605@ac-mac.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org, linux-driver@qlogic.com, mdr@sgi.com

On Thu, Nov 06, 2008 at 10:40:51AM -0800, Anirban Chakraborty wrote:
> Following changes have been made:
> 1. Outstanding commands are based on a request queue, scsi_qla_host does not 
> maintain it anymore.
> 2. start_scsi is accessed via isp_ops struct instead of direct invocation. 
> 3. Interrupt registrations are done using response queue instead of device id.
>
> Thanks,
> Anirban
> 
> Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Hello Anirban,

We found a problem in this patch.
The problem is that in the function qla2x00_probe_one() in qla_os.c,
you should be calling qla2x00_config_dma_addressing() before calling
qla2x00_mem_alloc(), so that the DMA mask can be set properly.

Now I notice that qla2x00_config_dma_addressing() uses the virtual
SCSI host, while qla2x00_mem_alloc() uses the physical host adapter
structure.  I don't see why qla2x00_config_dma_addressing() couldn't
be rewritten to use the physical host adapter structure.  But if not,
then it may need to be split into two parts -- one to set the
consistent dma mask and another to set the streaming dma mask.

I'll trim to the relevant single patch.

> @@ -1604,105 +1615,128 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	ha->prev_topology = 0;
>  	ha->init_cb_size = sizeof(init_cb_t);
> -	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER + ha->vp_idx;
>  	ha->link_data_rate = PORT_SPEED_UNKNOWN;
>  	ha->optrom_size = OPTROM_SIZE_2300;
>  
> -	ha->max_q_depth = MAX_Q_DEPTH;
> -	if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
> -		ha->max_q_depth = ql2xmaxqdepth;
> -
>  	/* Assign ISP specific operations. */
> +	max_id = MAX_TARGETS_2200;
>  	if (IS_QLA2100(ha)) {
> -		host->max_id = MAX_TARGETS_2100;
> +		max_id = MAX_TARGETS_2100;
>  		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
> -		ha->request_q_length = REQUEST_ENTRY_CNT_2100;
> -		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
> -		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
> -		host->sg_tablesize = 32;
> +		req_length = REQUEST_ENTRY_CNT_2100;
> +		rsp_length = RESPONSE_ENTRY_CNT_2100;
> +		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
>  		ha->gid_list_info_size = 4;
>  		ha->isp_ops = &qla2100_isp_ops;
>  	} else if (IS_QLA2200(ha)) {
> -		host->max_id = MAX_TARGETS_2200;
>  		ha->mbx_count = MAILBOX_REGISTER_COUNT;
> -		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
> -		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
> -		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
> +		req_length = REQUEST_ENTRY_CNT_2200;
> +		rsp_length = RESPONSE_ENTRY_CNT_2100;
> +		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
>  		ha->gid_list_info_size = 4;
>  		ha->isp_ops = &qla2100_isp_ops;
>  	} else if (IS_QLA23XX(ha)) {
> -		host->max_id = MAX_TARGETS_2200;
>  		ha->mbx_count = MAILBOX_REGISTER_COUNT;
> -		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
> -		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
> -		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
> +		req_length = REQUEST_ENTRY_CNT_2200;
> +		rsp_length = RESPONSE_ENTRY_CNT_2300;
> +		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
>  		ha->gid_list_info_size = 6;
>  		if (IS_QLA2322(ha) || IS_QLA6322(ha))
>  			ha->optrom_size = OPTROM_SIZE_2322;
>  		ha->isp_ops = &qla2300_isp_ops;
>  	} else if (IS_QLA24XX_TYPE(ha)) {
> -		host->max_id = MAX_TARGETS_2200;
>  		ha->mbx_count = MAILBOX_REGISTER_COUNT;
> -		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
> -		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
> -		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
> +		req_length = REQUEST_ENTRY_CNT_24XX;
> +		rsp_length = RESPONSE_ENTRY_CNT_2300;
> +		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
>  		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
> -		ha->mgmt_svr_loop_id = 10 + ha->vp_idx;
>  		ha->gid_list_info_size = 8;
>  		ha->optrom_size = OPTROM_SIZE_24XX;
>  		ha->isp_ops = &qla24xx_isp_ops;
>  	} else if (IS_QLA25XX(ha)) {
> -		host->max_id = MAX_TARGETS_2200;
>  		ha->mbx_count = MAILBOX_REGISTER_COUNT;
> -		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
> -		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
> -		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
> +		req_length = REQUEST_ENTRY_CNT_24XX;
> +		rsp_length = RESPONSE_ENTRY_CNT_2300;
> +		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
>  		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
> -		ha->mgmt_svr_loop_id = 10 + ha->vp_idx;
>  		ha->gid_list_info_size = 8;
>  		ha->optrom_size = OPTROM_SIZE_25XX;
>  		ha->isp_ops = &qla25xx_isp_ops;
>  	}
> -	host->can_queue = ha->request_q_length + 128;
>  
>  	mutex_init(&ha->vport_lock);
>  	init_completion(&ha->mbx_cmd_comp);
>  	complete(&ha->mbx_cmd_comp);
>  	init_completion(&ha->mbx_intr_comp);
>  
> -	INIT_LIST_HEAD(&ha->list);
> -	INIT_LIST_HEAD(&ha->fcports);
> -	INIT_LIST_HEAD(&ha->vp_list);
> -	INIT_LIST_HEAD(&ha->work_list);
> -
>  	set_bit(0, (unsigned long *) ha->vp_idx_map);
>  
> -	qla2x00_config_dma_addressing(ha);
> -	if (qla2x00_mem_alloc(ha)) {
> +	ret = qla2x00_mem_alloc(ha, req_length, rsp_length);
> +	if (!ret) {
>  		qla_printk(KERN_WARNING, ha,
>  		    "[ERROR] Failed to allocate memory for adapter\n");
>  
> +		goto probe_hw_failed;
> +	}
> +
> +	ha->req->max_q_depth = MAX_Q_DEPTH;
> +	if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
> +		ha->req->max_q_depth = ql2xmaxqdepth;
> +
> +	base_vha = qla2x00_create_host(sht, ha);
> +	if (!base_vha) {
> +		qla_printk(KERN_WARNING, ha,
> +		    "[ERROR] Failed to allocate memory for scsi_host\n");
> +
>  		ret = -ENOMEM;
> -		goto probe_failed;
> +		goto probe_hw_failed;
>  	}
>  
> -	if (qla2x00_initialize_adapter(ha)) {
> +	pci_set_drvdata(pdev, base_vha);
> +
> +	qla2x00_config_dma_addressing(base_vha);
> +
> +	host = base_vha->host;
> +	host->can_queue = ha->req->length + 128;
> +	if (IS_QLA2XXX_MIDTYPE(ha)) {
> +		base_vha->mgmt_svr_loop_id = 10 + base_vha->vp_idx;
> +	} else {
> +		base_vha->mgmt_svr_loop_id = MANAGEMENT_SERVER +
> +						base_vha->vp_idx;
> +	}
> +	if (IS_QLA2100(ha))
> +		host->sg_tablesize = 32;
> +	host->max_id = max_id;
> +	host->this_id = 255;
> +	host->cmd_per_lun = 3;
> +	host->unique_id = host->host_no;
> +	host->max_cmd_len = MAX_CMDSZ;
> +	host->max_channel = MAX_BUSES - 1;
> +	host->max_lun = MAX_LUNS;
> +	host->transportt = qla2xxx_transport_template;
> +
> +	if (qla2x00_initialize_adapter(base_vha)) {
>  		qla_printk(KERN_WARNING, ha,
>  		    "Failed to initialize adapter\n");
>  
>  		DEBUG2(printk("scsi(%ld): Failed to initialize adapter - "
>  		    "Adapter flags %x.\n",
> -		    ha->host_no, ha->device_flags));
> +		    base_vha->host_no, base_vha->device_flags));
>  
>  		ret = -ENODEV;
>  		goto probe_failed;
>  	}
>  
> +	/* Set up the irqs */
> +	ret = qla2x00_request_irqs(ha);
> +	if (ret)
> +		goto probe_failed;
> +
>  	/*
>  	 * Startup the kernel thread for this host adapter
>  	 */
>  	ha->dpc_thread = kthread_create(qla2x00_do_dpc, ha,
> -			"%s_dpc", ha->host_str);
> +			"%s_dpc", base_vha->host_str);
>  	if (IS_ERR(ha->dpc_thread)) {
>  		qla_printk(KERN_WARNING, ha,
>  		    "Unable to start DPC thread!\n");
