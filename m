From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] be2iscsi: Fix some error messages
Date: Fri, 12 Aug 2016 12:30:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1608121229310.2983@hadrien>
References: <1470996165-31131-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-436407596-1470997824=:2983"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:30495 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbcHLKai (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 06:30:38 -0400
In-Reply-To: <1470996165-31131-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: jayamohan.kallickal@avagotech.com, jejb@linux.vnet.ibm.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-436407596-1470997824=:2983
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 12 Aug 2016, Christophe JAILLET wrote:

> This fixes:
>    - missing spaces in string split on several lines
>    - extra spaces after ':'
>    - missing '\n' at the end of some messages
>    - too long lines

I think that the strings should be concatenated, even if they go past 80
chars.  I'm surprised checkpatch didn't complain.

julia

>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 83 +++++++++++++++++++++--------------------
>  1 file changed, 43 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 89ae6390b697..415c21ec6a13 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -268,7 +268,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>  				&nonemb_cmd.dma);
>  	if (nonemb_cmd.va == NULL) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
> -			    "BM_%d : Failed to allocate memory for"
> +			    "BM_%d : Failed to allocate memory for "
>  			    "mgmt_invalidate_icds\n");
>  		return FAILED;
>  	}
> @@ -278,7 +278,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>  				   cid, &nonemb_cmd);
>  	if (!tag) {
>  		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
> -			    "BM_%d : mgmt_invalidate_icds could not be"
> +			    "BM_%d : mgmt_invalidate_icds could not be "
>  			    "submitted\n");
>  		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
>  				    nonemb_cmd.va, nonemb_cmd.dma);
> @@ -350,7 +350,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
>  				&nonemb_cmd.dma);
>  	if (nonemb_cmd.va == NULL) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
> -			    "BM_%d : Failed to allocate memory for"
> +			    "BM_%d : Failed to allocate memory for "
>  			    "mgmt_invalidate_icds\n");
>  		return FAILED;
>  	}
> @@ -1010,7 +1010,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>  					  &phwi_context->be_eq[i]);
>  			if (ret) {
>  				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -					    "BM_%d : beiscsi_init_irqs-Failed to"
> +					    "BM_%d : beiscsi_init_irqs-Failed to "
>  					    "register msix for i = %d\n",
>  					    i);
>  				kfree(phba->msi_name[i]);
> @@ -1168,7 +1168,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
>  		 * failed in xmit_task or alloc_pdu.
>  		 */
>  		 beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
> -			     "BM_%d : Double Free in IO SGL io_sgl_free_index=%d,"
> +			     "BM_%d : Double Free in IO SGL io_sgl_free_index=%d, "
>  			     "value there=%p\n", phba->io_sgl_free_index,
>  			     phba->io_sgl_hndl_base
>  			     [phba->io_sgl_free_index]);
> @@ -1256,7 +1256,7 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
>  			       phba->params.wrbs_per_cxn);
>  	beiscsi_log(phba, KERN_INFO,
>  		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
> -		    "BM_%d : FREE WRB: pwrb_handle=%p free_index=0x%x"
> +		    "BM_%d : FREE WRB: pwrb_handle=%p free_index=0x%x "
>  		    "wrb_handles_available=%d\n",
>  		    pwrb_handle, pwrb_context->free_index,
>  		    pwrb_context->wrb_handles_available);
> @@ -1293,7 +1293,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
>  {
>  	spin_lock_bh(&phba->mgmt_sgl_lock);
>  	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
> -		    "BM_%d : In  free_mgmt_sgl_handle,"
> +		    "BM_%d : In  free_mgmt_sgl_handle, "
>  		    "eh_sgl_free_index=%d\n",
>  		    phba->eh_sgl_free_index);
>
> @@ -1303,7 +1303,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
>  		 * failed in xmit_task or alloc_pdu.
>  		 */
>  		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
> -			    "BM_%d : Double Free in eh SGL ,"
> +			    "BM_%d : Double Free in eh SGL, "
>  			    "eh_sgl_free_index=%d\n",
>  			    phba->eh_sgl_free_index);
>  		spin_unlock_bh(&phba->mgmt_sgl_lock);
> @@ -1604,7 +1604,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
>  	default:
>  		beiscsi_log(phba, KERN_WARNING,
>  			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
> -			    "BM_%d : In hwi_complete_cmd, unknown type = %d"
> +			    "BM_%d : In hwi_complete_cmd, unknown type = %d "
>  			    "wrb_index 0x%x CID 0x%x\n", type,
>  			    csol_cqe.wrb_index,
>  			    csol_cqe.cid);
> @@ -2210,7 +2210,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
>  		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
>  			beiscsi_log(phba, KERN_ERR,
>  				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
> -				    "BM_%d :  Dropping %s[%d] on DPDU ring on CID : %d\n",
> +				    "BM_%d : Dropping %s[%d] on DPDU ring on CID : %d\n",
>  				    cqe_desc[code], code, cid);
>  			spin_lock_bh(&phba->async_pdu_lock);
>  			hwi_flush_default_pdu_buffer(phba, beiscsi_conn,
> @@ -2243,7 +2243,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
>  		default:
>  			beiscsi_log(phba, KERN_ERR,
>  				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
> -				    "BM_%d : Invalid CQE Event Received Code : %d"
> +				    "BM_%d : Invalid CQE Event Received Code : %d "
>  				    "CID 0x%x...\n",
>  				    code, cid);
>  			break;
> @@ -3305,7 +3305,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
>  					    phwi_context->cur_eqd);
>  		if (ret) {
>  			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -				    "BM_%d : beiscsi_cmd_eq_create"
> +				    "BM_%d : beiscsi_cmd_eq_create "
>  				    "Failed for EQ\n");
>  			goto create_eq_error;
>  		}
> @@ -3315,6 +3315,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
>  			    phwi_context->be_eq[i].q.id);
>  	}
>  	return 0;
> +
>  create_eq_error:
>  	for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
>  		eq = &phwi_context->be_eq[i].q;
> @@ -3370,7 +3371,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
>  					    false, 0);
>  		if (ret) {
>  			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -				    "BM_%d : beiscsi_cmd_eq_create"
> +				    "BM_%d : beiscsi_cmd_eq_create "
>  				    "Failed for ISCSI CQ\n");
>  			goto create_cq_error;
>  		}
> @@ -3432,7 +3433,8 @@ beiscsi_create_def_hdr(struct beiscsi_hba *phba,
>  					      BEISCSI_DEFQ_HDR, ulp_num);
>  	if (ret) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -			    "BM_%d : be_cmd_create_default_pdu_queue Failed DEFHDR on ULP : %d\n",
> +			    "BM_%d : be_cmd_create_default_pdu_queue Failed "
> +			    "DEFHDR on ULP : %d\n",
>  			    ulp_num);
>
>  		return ret;
> @@ -3499,7 +3501,7 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
>
>  	hwi_post_async_buffers(phba, BEISCSI_DEFQ_DATA, ulp_num);
>  	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> -		    "BM_%d : DEFAULT PDU DATA RING CREATED"
> +		    "BM_%d : DEFAULT PDU DATA RING CREATED "
>  		    "on ULP : %d\n", ulp_num);
>
>  	return 0;
> @@ -3527,13 +3529,13 @@ beiscsi_post_template_hdr(struct beiscsi_hba *phba)
>
>  			if (status != 0) {
>  				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -					    "BM_%d : Post Template HDR Failed for"
> +					    "BM_%d : Post Template HDR Failed for "
>  					    "ULP_%d\n", ulp_num);
>  				return status;
>  			}
>
>  			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> -				    "BM_%d : Template HDR Pages Posted for"
> +				    "BM_%d : Template HDR Pages Posted for "
>  				    "ULP_%d\n", ulp_num);
>  		}
>  	}
> @@ -3694,7 +3696,7 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
>  					    ulp_base_num);
>  		if (status != 0) {
>  			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -				    "BM_%d : wrbq create failed.");
> +				    "BM_%d : wrbq create failed.\n");
>  			kfree(pwrb_arr);
>  			return status;
>  		}
> @@ -3999,7 +4001,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
>
>  error:
>  	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -		    "BM_%d : hwi_init_port failed");
> +		    "BM_%d : hwi_init_port failed\n");
>  	hwi_cleanup(phba);
>  	return status;
>  }
> @@ -4013,7 +4015,7 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
>  		phwi_ctrlr->phwi_ctxt = (struct hwi_context_memory *)phba->
>  		    init_mem[HWI_MEM_ADDN_CONTEXT].mem_array[0].virtual_address;
>  		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> -			    "BM_%d :  phwi_ctrlr->phwi_ctxt=%p\n",
> +			    "BM_%d : phwi_ctrlr->phwi_ctxt=%p\n",
>  			    phwi_ctrlr->phwi_ctxt);
>  	} else {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> @@ -4082,7 +4084,7 @@ static int beiscsi_init_controller(struct beiscsi_hba *phba)
>  	if (ret)
>  		goto free_init;
>  	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> -		    "BM_%d : Return success from beiscsi_init_controller");
> +		    "BM_%d : Return success from beiscsi_init_controller\n");
>
>  	return 0;
>
> @@ -4125,7 +4127,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
>  		}
>  	} else {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -			    "BM_%d : HWI_MEM_SGLH is more than one element."
> +			    "BM_%d : HWI_MEM_SGLH is more than one element. "
>  			    "Failing to load\n");
>  		return -ENOMEM;
>  	}
> @@ -4153,7 +4155,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
>  		idx++;
>  	}
>  	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> -		    "BM_%d : phba->io_sgl_hndl_avbl=%d"
> +		    "BM_%d : phba->io_sgl_hndl_avbl=%d "
>  		    "phba->eh_sgl_hndl_avbl=%d\n",
>  		    phba->io_sgl_hndl_avbl,
>  		    phba->eh_sgl_hndl_avbl);
> @@ -4212,7 +4214,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
>
>  			if (!ptr_cid_info) {
>  				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -					    "BM_%d : Failed to allocate memory"
> +					    "BM_%d : Failed to allocate memory "
>  					    "for ULP_CID_INFO for ULP : %d\n",
>  					    ulp_num);
>  				ret = -ENOMEM;
> @@ -4226,7 +4228,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
>  						  ulp_num), GFP_KERNEL);
>  			if (!ptr_cid_info->cid_array) {
>  				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -					    "BM_%d : Failed to allocate memory"
> +					    "BM_%d : Failed to allocate memory "
>  					    "for CID_ARRAY for ULP : %d\n",
>  					    ulp_num);
>  				kfree(ptr_cid_info);
> @@ -4257,7 +4259,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
>  				   phba->params.cxns_per_ctrl, GFP_KERNEL);
>  	if (!phba->conn_table) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -			    "BM_%d : Failed to allocate memory in"
> +			    "BM_%d : Failed to allocate memory in "
>  			    "hba_setup_cid_tbls\n");
>
>  		kfree(phba->ep_array);
> @@ -4397,7 +4399,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
>  	if (nonemb_cmd.va == NULL) {
>  		beiscsi_log(phba, KERN_ERR,
>  			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> -			    "BM_%d : Failed to allocate memory for"
> +			    "BM_%d : Failed to allocate memory for "
>  			    "beiscsi_get_session_info\n");
>
>  		return -ENOMEM;
> @@ -4418,7 +4420,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
>  	if (ret) {
>  		beiscsi_log(phba, KERN_ERR,
>  			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> -			    "BM_%d : beiscsi_get_session_info Failed");
> +			    "BM_%d : beiscsi_get_session_info Failed\n");
>
>  		if (ret != -EBUSY)
>  			goto boot_freemem;
> @@ -4509,14 +4511,14 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
>  	ret = beiscsi_init_controller(phba);
>  	if (ret < 0) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -			    "BM_%d : beiscsi_dev_probe - Failed in"
> +			    "BM_%d : beiscsi_dev_probe - Failed in "
>  			    "beiscsi_init_controller\n");
>  		return ret;
>  	}
>  	ret = beiscsi_init_sgl_handle(phba);
>  	if (ret < 0) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -			    "BM_%d : beiscsi_dev_probe - Failed in"
> +			    "BM_%d : beiscsi_dev_probe - Failed in "
>  			    "beiscsi_init_sgl_handle\n");
>  		goto do_cleanup_ctrlr;
>  	}
> @@ -4752,7 +4754,8 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
>  			       phba->params.wrbs_per_cxn);
>  	beiscsi_log(phba, KERN_INFO,
>  		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
> -		    "BM_%d : put CONTEXT_UPDATE pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
> +		    "BM_%d : put CONTEXT_UPDATE pwrb_handle=%p "
> +		    "free_index=0x%x wrb_handles_available=%d\n",
>  		    pwrb_handle, pwrb_context->free_index,
>  		    pwrb_context->wrb_handles_available);
>  }
> @@ -4806,7 +4809,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  		if (!io_task->psgl_handle) {
>  			beiscsi_log(phba, KERN_ERR,
>  				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
> -				    "BM_%d : Alloc of IO_SGL_ICD Failed"
> +				    "BM_%d : Alloc of IO_SGL_ICD Failed "
>  				    "for the CID : %d\n",
>  				    beiscsi_conn->beiscsi_conn_cid);
>  			goto free_hndls;
> @@ -4817,7 +4820,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  		if (!io_task->pwrb_handle) {
>  			beiscsi_log(phba, KERN_ERR,
>  				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
> -				    "BM_%d : Alloc of WRB_HANDLE Failed"
> +				    "BM_%d : Alloc of WRB_HANDLE Failed "
>  				    "for the CID : %d\n",
>  				    beiscsi_conn->beiscsi_conn_cid);
>  			goto free_io_hndls;
> @@ -4833,7 +4836,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  					beiscsi_log(phba, KERN_ERR,
>  						    BEISCSI_LOG_IO |
>  						    BEISCSI_LOG_CONFIG,
> -						    "BM_%d : Alloc of MGMT_SGL_ICD Failed"
> +						    "BM_%d : Alloc of MGMT_SGL_ICD Failed "
>  						    "for the CID : %d\n",
>  						    beiscsi_conn->
>  						    beiscsi_conn_cid);
> @@ -4851,7 +4854,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  					beiscsi_log(phba, KERN_ERR,
>  						    BEISCSI_LOG_IO |
>  						    BEISCSI_LOG_CONFIG,
> -						    "BM_%d : Alloc of WRB_HANDLE Failed"
> +						    "BM_%d : Alloc of WRB_HANDLE Failed "
>  						    "for the CID : %d\n",
>  						    beiscsi_conn->
>  						    beiscsi_conn_cid);
> @@ -4872,7 +4875,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  				beiscsi_log(phba, KERN_ERR,
>  					    BEISCSI_LOG_IO |
>  					    BEISCSI_LOG_CONFIG,
> -					    "BM_%d : Alloc of MGMT_SGL_ICD Failed"
> +					    "BM_%d : Alloc of MGMT_SGL_ICD Failed "
>  					    "for the CID : %d\n",
>  					    beiscsi_conn->
>  					    beiscsi_conn_cid);
> @@ -4885,7 +4888,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  			if (!io_task->pwrb_handle) {
>  				beiscsi_log(phba, KERN_ERR,
>  					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
> -					    "BM_%d : Alloc of WRB_HANDLE Failed"
> +					    "BM_%d : Alloc of WRB_HANDLE Failed "
>  					    "for the CID : %d\n",
>  					    beiscsi_conn->beiscsi_conn_cid);
>  				goto free_mgmt_hndls;
> @@ -5484,7 +5487,7 @@ static pci_ers_result_t beiscsi_eeh_err_detected(struct pci_dev *pdev,
>
>  	if (state == pci_channel_io_perm_failure) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -			    "BM_%d : EEH : State PERM Failure");
> +			    "BM_%d : EEH : State PERM Failure\n");
>  		return PCI_ERS_RESULT_DISCONNECT;
>  	}
>
> @@ -5577,8 +5580,8 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
>  	ret = hwi_init_controller(phba);
>  	if (ret) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -			    "BM_%d : beiscsi_eeh_resume -"
> -			     "Failed to initialize beiscsi_hba.\n");
> +			    "BM_%d : beiscsi_eeh_resume - "
> +			    "Failed to initialize beiscsi_hba.\n");
>  		goto ret_err;
>  	}
>
> --
> 2.7.4
>
>
> ---
> L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
> https://www.avast.com/antivirus
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--8323329-436407596-1470997824=:2983--
