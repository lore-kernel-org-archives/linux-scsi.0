From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/8] lpfc 8.2.2 : Rework the lpfc_printf_log() macro
Date: Thu, 02 Aug 2007 10:18:03 +0300
Message-ID: <46B1852B.8090106@panasas.com>
References: <1186067410.14374.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11512 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752459AbXHBHSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 03:18:14 -0400
In-Reply-To: <1186067410.14374.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> Rework the lpfc_printf_log() macro so that logging is enabled on a
>   per-vport basis. Used to be on a physical-port basis, thus logging
>   with large numbers of vports became a mess.  Required redefinition
>   of the macro, and an update of every use.
> 
> Signed-off-by: James Smart <James.Smart@emulex.com>
> 
> 
> diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> --- a/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 09:28:15.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 09:31:26.000000000 -0400
> @@ -319,9 +319,8 @@ lpfc_do_offline(struct lpfc_hba *phba, u
>  			if (cnt++ > 3000) {
>  				lpfc_printf_log(phba,
>  					KERN_WARNING, LOG_INIT,
> -					"%d:0466 Outstanding IO when "
> -					"bringing Adapter offline\n",
> -					phba->brd_no);
> +					"0466 Outstanding IO when "
> +					"bringing Adapter offline\n");
>  				break;
>  			}
>  		}
> @@ -694,9 +693,8 @@ lpfc_##attr##_init(struct lpfc_hba *phba
>  		return 0;\
>  	}\
>  	lpfc_printf_log(phba, KERN_ERR, LOG_INIT, \
> -			"%d:0449 lpfc_"#attr" attribute cannot be set to %d, "\
> -			"allowed range is ["#minval", "#maxval"]\n", \
> -			phba->brd_no, val); \
> +			"0449 lpfc_"#attr" attribute cannot be set to %d, "\
> +			"allowed range is ["#minval", "#maxval"]\n", val); \
>  	phba->cfg_##attr = default;\
>  	return -EINVAL;\
>  }
> @@ -710,9 +708,8 @@ lpfc_##attr##_set(struct lpfc_hba *phba,
>  		return 0;\
>  	}\
>  	lpfc_printf_log(phba, KERN_ERR, LOG_INIT, \
> -			"%d:0450 lpfc_"#attr" attribute cannot be set to %d, "\
> -			"allowed range is ["#minval", "#maxval"]\n", \
> -			phba->brd_no, val); \
> +			"0450 lpfc_"#attr" attribute cannot be set to %d, "\
> +			"allowed range is ["#minval", "#maxval"]\n", val); \
>  	return -EINVAL;\
>  }
>  
> @@ -764,10 +761,9 @@ lpfc_##attr##_init(struct lpfc_vport *vp
>  		vport->cfg_##attr = val;\
>  		return 0;\
>  	}\
> -	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT, \
> -			"%d:0449 lpfc_"#attr" attribute cannot be set to %d, "\
> -			"allowed range is ["#minval", "#maxval"]\n", \
> -			vport->phba->brd_no, val); \
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT, \
> +			 "0449 lpfc_"#attr" attribute cannot be set to %d, "\
> +			 "allowed range is ["#minval", "#maxval"]\n", val); \
>  	vport->cfg_##attr = default;\
>  	return -EINVAL;\
>  }
> @@ -780,10 +776,9 @@ lpfc_##attr##_set(struct lpfc_vport *vpo
>  		vport->cfg_##attr = val;\
>  		return 0;\
>  	}\
> -	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT, \
> -			"%d:0450 lpfc_"#attr" attribute cannot be set to %d, "\
> -			"allowed range is ["#minval", "#maxval"]\n", \
> -			vport->phba->brd_no, val); \
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT, \
> +			 "0450 lpfc_"#attr" attribute cannot be set to %d, "\
> +			 "allowed range is ["#minval", "#maxval"]\n", val); \
>  	return -EINVAL;\
>  }
>  
> @@ -1023,17 +1018,15 @@ lpfc_soft_wwpn_store(struct class_device
>  	stat1 = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
>  	if (stat1)
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0463 lpfc_soft_wwpn attribute set failed to reinit "
> -			"adapter - %d\n", phba->brd_no, stat1);
> -
> +				"0463 lpfc_soft_wwpn attribute set failed to "
> +				"reinit adapter - %d\n", stat1);
>  	init_completion(&online_compl);
>  	lpfc_workq_post_event(phba, &stat2, &online_compl, LPFC_EVT_ONLINE);
>  	wait_for_completion(&online_compl);
>  	if (stat2)
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0464 lpfc_soft_wwpn attribute set failed to reinit "
> -			"adapter - %d\n", phba->brd_no, stat2);
> -
> +				"0464 lpfc_soft_wwpn attribute set failed to "
> +				"reinit adapter - %d\n", stat2);
>  	return (stat1 || stat2) ? -EIO : count;
>  }
>  static CLASS_DEVICE_ATTR(lpfc_soft_wwpn, S_IRUGO | S_IWUSR,\
> @@ -1145,11 +1138,10 @@ lpfc_nodev_tmo_init(struct lpfc_vport *v
>  	if (vport->cfg_devloss_tmo != LPFC_DEF_DEVLOSS_TMO) {
>  		vport->cfg_nodev_tmo = vport->cfg_devloss_tmo;
>  		if (val != LPFC_DEF_DEVLOSS_TMO)
> -			lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
> -					"%d (%d):0402 Ignoring nodev_tmo module"
> -					" parameter because devloss_tmo is"
> -					" set.\n",
> -					vport->phba->brd_no, vport->vpi);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +					 "0402 Ignoring nodev_tmo module "
> +					 "parameter because devloss_tmo is "
> +					 "set.\n");
>  		return 0;
>  	}
>  
> @@ -1158,11 +1150,10 @@ lpfc_nodev_tmo_init(struct lpfc_vport *v
>  		vport->cfg_devloss_tmo = val;
>  		return 0;
>  	}
> -	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
> -			"%d (%d):0400 lpfc_nodev_tmo attribute cannot be set to"
> -			" %d, allowed range is [%d, %d]\n",
> -			vport->phba->brd_no, vport->vpi, val,
> -			LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +			 "0400 lpfc_nodev_tmo attribute cannot be set to"
> +			 " %d, allowed range is [%d, %d]\n",
> +			 val, LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
>  	vport->cfg_nodev_tmo = LPFC_DEF_DEVLOSS_TMO;
>  	return -EINVAL;
>  }
> @@ -1195,10 +1186,9 @@ lpfc_nodev_tmo_set(struct lpfc_vport *vp
>  {
>  	if (vport->dev_loss_tmo_changed ||
>  	    (lpfc_devloss_tmo != LPFC_DEF_DEVLOSS_TMO)) {
> -		lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
> -				"%d (%d):0401 Ignoring change to nodev_tmo "
> -				"because devloss_tmo is set.\n",
> -				vport->phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +				 "0401 Ignoring change to nodev_tmo "
> +				 "because devloss_tmo is set.\n");
>  		return 0;
>  	}
>  	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
> @@ -1207,11 +1197,10 @@ lpfc_nodev_tmo_set(struct lpfc_vport *vp
>  		lpfc_update_rport_devloss_tmo(vport);
>  		return 0;
>  	}
> -	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
> -			"%d (%d):0403 lpfc_nodev_tmo attribute cannot be set to"
> -			"%d, allowed range is [%d, %d]\n",
> -			vport->phba->brd_no, vport->vpi, val,
> -			LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +			 "0403 lpfc_nodev_tmo attribute cannot be set to"
> +			 "%d, allowed range is [%d, %d]\n",
> +			 val, LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
>  	return -EINVAL;
>  }
>  
> @@ -1243,11 +1232,10 @@ lpfc_devloss_tmo_set(struct lpfc_vport *
>  		return 0;
>  	}
>  
> -	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
> -			"%d:0404 lpfc_devloss_tmo attribute cannot be set to"
> -			" %d, allowed range is [%d, %d]\n",
> -			vport->phba->brd_no, val, LPFC_MIN_DEVLOSS_TMO,
> -			LPFC_MAX_DEVLOSS_TMO);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +			 "0404 lpfc_devloss_tmo attribute cannot be set to"
> +			 " %d, allowed range is [%d, %d]\n",
> +			 val, LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
>  	return -EINVAL;
>  }
>  
> @@ -1273,7 +1261,8 @@ static CLASS_DEVICE_ATTR(lpfc_devloss_tm
>  # LOG_LIBDFC                    0x2000     LIBDFC events
>  # LOG_ALL_MSG                   0xffff     LOG all messages
>  */
> -LPFC_ATTR_HEX_RW(log_verbose, 0x0, 0x0, 0xffff, "Verbose logging bit-mask");
> +LPFC_VPORT_ATTR_HEX_RW(log_verbose, 0x0, 0x0, 0xffff,
> +		       "Verbose logging bit-mask");
>  
>  /*
>  # lun_queue_depth:  This parameter is used to limit the number of outstanding
> @@ -1326,10 +1315,10 @@ static int
>  lpfc_restrict_login_init(struct lpfc_vport *vport, int val)
>  {
>  	if (val < 0 || val > 1) {
> -		lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
> -				"%d:0449 lpfc_restrict_login attribute cannot "
> -				"be set to %d, allowed range is [0, 1]\n",
> -				vport->phba->brd_no, val);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +				 "0449 lpfc_restrict_login attribute cannot "
> +				 "be set to %d, allowed range is [0, 1]\n",
> +				 val);
>  		vport->cfg_restrict_login = 1;
>  		return -EINVAL;
>  	}
> @@ -1345,18 +1334,17 @@ static int
>  lpfc_restrict_login_set(struct lpfc_vport *vport, int val)
>  {
>  	if (val < 0 || val > 1) {
> -		lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
> -				"%d:0450 lpfc_restrict_login attribute cannot "
> -				"be set to %d, allowed range is [0, 1]\n",
> -				vport->phba->brd_no, val);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +				 "0450 lpfc_restrict_login attribute cannot "
> +				 "be set to %d, allowed range is [0, 1]\n",
> +				 val);
>  		vport->cfg_restrict_login = 1;
>  		return -EINVAL;
>  	}
>  	if (vport->port_type == LPFC_PHYSICAL_PORT && val != 0) {
> -		lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
> -				"%d:0468 lpfc_restrict_login must be 0 for "
> -				"Physical ports.\n",
> -				vport->phba->brd_no);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +				 "0468 lpfc_restrict_login must be 0 for "
> +				 "Physical ports.\n");
>  		vport->cfg_restrict_login = 0;
>  		return 0;
>  	}
> @@ -2435,7 +2423,6 @@ struct fc_function_template lpfc_vport_t
>  void
>  lpfc_get_cfgparam(struct lpfc_hba *phba)
>  {
> -	lpfc_log_verbose_init(phba, lpfc_log_verbose);
>  	lpfc_cr_delay_init(phba, lpfc_cr_delay);
>  	lpfc_cr_count_init(phba, lpfc_cr_count);
>  	lpfc_multi_ring_support_init(phba, lpfc_multi_ring_support);
> @@ -2469,6 +2456,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
>  void
>  lpfc_get_vport_cfgparam(struct lpfc_vport *vport)
>  {
> +	lpfc_log_verbose_init(vport, lpfc_log_verbose);
>  	lpfc_lun_queue_depth_init(vport, lpfc_lun_queue_depth);
>  	lpfc_devloss_tmo_init(vport, lpfc_devloss_tmo);
>  	lpfc_nodev_tmo_init(vport, lpfc_nodev_tmo);
> diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> --- a/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 09:27:04.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 09:29:52.000000000 -0400
> @@ -341,11 +341,11 @@ lpfc_gen_req(struct lpfc_vport *vport, s
>  	}
>  
>  	/* Issue GEN REQ IOCB for NPORT <did> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0119 Issue GEN REQ IOCB to NPORT x%x "
> -			"Data: x%x x%x\n", phba->brd_no, vport->vpi,
> -			ndlp->nlp_DID, icmd->ulpIoTag,
> -			vport->port_state);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0119 Issue GEN REQ IOCB to NPORT x%x "
> +			 "Data: x%x x%x\n",
> +			 ndlp->nlp_DID, icmd->ulpIoTag,
> +			 vport->port_state);
>  	geniocb->iocb_cmpl = cmpl;
>  	geniocb->drvrTimeout = icmd->ulpTimeout + LPFC_DRVR_TIMEOUT;
>  	geniocb->vport = vport;
> @@ -464,14 +464,13 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
>  						Did, ndlp->nlp_flag,
>  						vport->fc_flag);
>  
> -						lpfc_printf_log(phba, KERN_INFO,
> +						lpfc_printf_vlog(vport,
> +							KERN_INFO,
>  							LOG_DISCOVERY,
> -							"%d (%d):0238 Process "
> +							"0238 Process "
>  							"x%x NameServer Rsp"
>  							"Data: x%x x%x x%x\n",
> -							phba->brd_no,
> -							vport->vpi, Did,
> -							ndlp->nlp_flag,
> +							Did, ndlp->nlp_flag,
>  							vport->fc_flag,
>  							vport->fc_rscn_id_cnt);
>  					} else {
> @@ -482,14 +481,13 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
>  						Did, vport->fc_flag,
>  						vport->fc_rscn_id_cnt);
>  
> -						lpfc_printf_log(phba, KERN_INFO,
> +						lpfc_printf_vlog(vport,
> +							KERN_INFO,
>  							LOG_DISCOVERY,
> -							"%d (%d):0239 Skip x%x "
> +							"0239 Skip x%x "
>  							"NameServer Rsp Data: "
>  							"x%x x%x\n",
> -							phba->brd_no,
> -							vport->vpi, Did,
> -							vport->fc_flag,
> +							Did, vport->fc_flag,
>  							vport->fc_rscn_id_cnt);
>  					}
>  
> @@ -516,14 +514,13 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
>  						Did, vport->fc_flag,
>  						vport->fc_rscn_id_cnt);
>  
> -						lpfc_printf_log(phba, KERN_INFO,
> +						lpfc_printf_vlog(vport,
> +							KERN_INFO,
>  							LOG_DISCOVERY,
> -							"%d (%d):0245 Skip x%x "
> +							"0245 Skip x%x "
>  							"NameServer Rsp Data: "
>  							"x%x x%x\n",
> -							phba->brd_no,
> -							vport->vpi, Did,
> -							vport->fc_flag,
> +							Did, vport->fc_flag,
>  							vport->fc_rscn_id_cnt);
>  					}
>  				}
> @@ -570,9 +567,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
>  
> 
>  	if (lpfc_els_chk_latt(vport) || lpfc_error_lost_link(irsp)) {
> -		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -				"%d (%d):0216 Link event during NS query\n",
> -				phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +				 "0216 Link event during NS query\n");
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
>  		goto out;
>  	}
> @@ -590,20 +586,17 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
>  				goto out;
>  		}
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0257 GID_FT Query error: 0x%x 0x%x\n",
> -			phba->brd_no, vport->vpi, irsp->ulpStatus,
> -			vport->fc_ns_retry);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0257 GID_FT Query error: 0x%x 0x%x\n",
> +				 irsp->ulpStatus, vport->fc_ns_retry);
>  	} else {
>  		/* Good status, continue checking */
>  		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
>  		if (CTrsp->CommandResponse.bits.CmdRsp ==
>  		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC)) {
> -			lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -					"%d (%d):0208 NameServer Rsp "
> -					"Data: x%x\n",
> -					phba->brd_no, vport->vpi,
> -					vport->fc_flag);
> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +					 "0208 NameServer Rsp Data: x%x\n",
> +					 vport->fc_flag);
>  			lpfc_ns_rsp(vport, outp,
>  				    (uint32_t) (irsp->un.genreq64.bdl.bdeSize));
>  		} else if (CTrsp->CommandResponse.bits.CmdRsp ==
> @@ -611,10 +604,10 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
>  			/* NameServer Rsp Error */
>  			if ((CTrsp->ReasonCode == SLI_CT_UNABLE_TO_PERFORM_REQ)
>  			    && (CTrsp->Explanation == SLI_CT_NO_FC4_TYPES)) {
> -				lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -					"%d (%d):0269 No NameServer Entries "
> +				lpfc_printf_vlog(vport, KERN_INFO,
> +					LOG_DISCOVERY,
> +					"0269 No NameServer Entries "
>  					"Data: x%x x%x x%x x%x\n",
> -					phba->brd_no, vport->vpi,
>  					CTrsp->CommandResponse.bits.CmdRsp,
>  					(uint32_t) CTrsp->ReasonCode,
>  					(uint32_t) CTrsp->Explanation,
> @@ -625,12 +618,11 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
>  				(uint32_t)CTrsp->CommandResponse.bits.CmdRsp,
>  				(uint32_t) CTrsp->ReasonCode,
>  				(uint32_t) CTrsp->Explanation);
> -			}
> -			else {
> -				lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -					"%d (%d):0240 NameServer Rsp Error "
> +			} else {
> +				lpfc_printf_vlog(vport, KERN_INFO,
> +					LOG_DISCOVERY,
> +					"0240 NameServer Rsp Error "
>  					"Data: x%x x%x x%x x%x\n",
> -					phba->brd_no, vport->vpi,
>  					CTrsp->CommandResponse.bits.CmdRsp,
>  					(uint32_t) CTrsp->ReasonCode,
>  					(uint32_t) CTrsp->Explanation,
> @@ -646,10 +638,9 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
>  
>  		} else {
>  			/* NameServer Rsp Error */
> -			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -					"%d (%d):0241 NameServer Rsp Error "
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +					"0241 NameServer Rsp Error "
>  					"Data: x%x x%x x%x x%x\n",
> -					phba->brd_no, vport->vpi,
>  					CTrsp->CommandResponse.bits.CmdRsp,
>  					(uint32_t) CTrsp->ReasonCode,
>  					(uint32_t) CTrsp->Explanation,
> @@ -717,40 +708,37 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba 
>  		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC)) {
>  			if ((fbits & FC4_FEATURE_INIT) &&
>  			    !(fbits & FC4_FEATURE_TARGET)) {
> -				lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -						"%d (%d):0270 Skip x%x GFF "
> -						"NameServer Rsp Data: (init) "
> -						"x%x x%x\n", phba->brd_no,
> -						vport->vpi, did, fbits,
> -						vport->fc_rscn_id_cnt);
> +				lpfc_printf_vlog(vport, KERN_INFO,
> +						 LOG_DISCOVERY,
> +						 "0270 Skip x%x GFF "
> +						 "NameServer Rsp Data: (init) "
> +						 "x%x x%x\n", did, fbits,
> +						 vport->fc_rscn_id_cnt);
>  				goto out;
>  			}
>  		}
>  	}
>  	else {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0267 NameServer GFF Rsp"
> -				" x%x Error (%d %d) Data: x%x x%x\n",
> -				phba->brd_no, vport->vpi, did,
> -				irsp->ulpStatus, irsp->un.ulpWord[4],
> -				vport->fc_flag, vport->fc_rscn_id_cnt)
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0267 NameServer GFF Rsp "
> +				 "x%x Error (%d %d) Data: x%x x%x\n",
> +				 did, irsp->ulpStatus, irsp->un.ulpWord[4],
> +				 vport->fc_flag, vport->fc_rscn_id_cnt)
>  	}
>  
>  	/* This is a target port, unregistered port, or the GFF_ID failed */
>  	ndlp = lpfc_setup_disc_node(vport, did);
>  	if (ndlp) {
> -		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -				"%d (%d):0242 Process x%x GFF "
> -				"NameServer Rsp Data: x%x x%x x%x\n",
> -				phba->brd_no, vport->vpi,
> -				did, ndlp->nlp_flag, vport->fc_flag,
> -				vport->fc_rscn_id_cnt);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +				 "0242 Process x%x GFF "
> +				 "NameServer Rsp Data: x%x x%x x%x\n",
> +				 did, ndlp->nlp_flag, vport->fc_flag,
> +				 vport->fc_rscn_id_cnt);
>  	} else {
> -		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -				"%d (%d):0243 Skip x%x GFF "
> -				"NameServer Rsp Data: x%x x%x\n",
> -				phba->brd_no, vport->vpi, did,
> -				vport->fc_flag,	vport->fc_rscn_id_cnt);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +				 "0243 Skip x%x GFF "
> +				 "NameServer Rsp Data: x%x x%x\n", did,
> +				 vport->fc_flag, vport->fc_rscn_id_cnt);
>  	}
>  out:
>  	/* Link up / RSCN discovery */
> @@ -806,22 +794,21 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba 
>  	latt = lpfc_els_chk_latt(vport);
>  
>  	/* RFT request completes status <ulpStatus> CmdRsp <CmdRsp> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0209 RFT request completes, latt %d, "
> -			"ulpStatus x%x CmdRsp x%x, Context x%x, Tag x%x\n",
> -			phba->brd_no, vport->vpi, latt, irsp->ulpStatus,
> -			CTrsp->CommandResponse.bits.CmdRsp,
> -			cmdiocb->iocb.ulpContext, cmdiocb->iocb.ulpIoTag);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0209 RFT request completes, latt %d, "
> +			 "ulpStatus x%x CmdRsp x%x, Context x%x, Tag x%x\n",
> +			 latt, irsp->ulpStatus,
> +			 CTrsp->CommandResponse.bits.CmdRsp,
> +			 cmdiocb->iocb.ulpContext, cmdiocb->iocb.ulpIoTag);
>  
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
>  		"CT cmd cmpl:     status:x%x/x%x cmd:x%x",
>  		irsp->ulpStatus, irsp->un.ulpWord[4], cmdcode);
>  
>  	if (irsp->ulpStatus) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -			"%d (%d):0268 NS cmd %x Error (%d %d)\n",
> -			phba->brd_no, vport->vpi, cmdcode,
> -			irsp->ulpStatus, irsp->un.ulpWord[4]);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0268 NS cmd %x Error (%d %d)\n",
> +				 cmdcode, irsp->ulpStatus, irsp->un.ulpWord[4]);
>  
>  		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
>  			((irsp->un.ulpWord[4] == IOERR_SLI_DOWN) ||
> @@ -833,9 +820,8 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba 
>  			goto out;
>  
>  		retry++;
> -		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -				"%d (%d):0216 Retrying NS cmd %x\n",
> -				phba->brd_no, vport->vpi, cmdcode);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +				 "0216 Retrying NS cmd %x\n", cmdcode);
>  		rc = lpfc_ns_cmd(vport, cmdcode, retry, 0);
>  		if (rc == 0)
>  			goto out;
> @@ -979,10 +965,9 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
>  	}
>  
>  	/* NameServer Req */
> -	lpfc_printf_log(phba, KERN_INFO ,LOG_DISCOVERY,
> -			"%d (%d):0236 NameServer Req Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, cmdcode, vport->fc_flag,
> -			vport->fc_rscn_id_cnt);
> +	lpfc_printf_vlog(vport, KERN_INFO ,LOG_DISCOVERY,
> +			 "0236 NameServer Req Data: x%x x%x x%x\n",
> +			 cmdcode, vport->fc_flag, vport->fc_rscn_id_cnt);
>  
>  	bpl = (struct ulp_bde64 *) bmp->virt;
>  	memset(bpl, 0, sizeof(struct ulp_bde64));
> @@ -1099,10 +1084,9 @@ ns_cmd_free_mpvirt:
>  ns_cmd_free_mp:
>  	kfree(mp);
>  ns_cmd_exit:
> -	lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -		"%d (%d):0266 Issue NameServer Req x%x err %d Data: x%x x%x\n",
> -			phba->brd_no, vport->vpi, cmdcode, rc, vport->fc_flag,
> -			vport->fc_rscn_id_cnt);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +			 "0266 Issue NameServer Req x%x err %d Data: x%x x%x\n",
> +			 cmdcode, rc, vport->fc_flag, vport->fc_rscn_id_cnt);
>  	return 1;
>  }
>  
> @@ -1128,12 +1112,11 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba *p
>  		irsp->ulpStatus, irsp->un.ulpWord[4], latt);
>  
>  	if (latt || irsp->ulpStatus) {
> -		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			        "%d (%d):0229 FDMI cmd %04x failed, latt = %d "
> -				"ulpStatus: x%x, rid x%x\n",
> -			        phba->brd_no, vport->vpi,
> -				be16_to_cpu(fdmi_cmd), latt, irsp->ulpStatus,
> -				irsp->un.ulpWord[4]);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +				 "0229 FDMI cmd %04x failed, latt = %d "
> +				 "ulpStatus: x%x, rid x%x\n",
> +				 be16_to_cpu(fdmi_cmd), latt, irsp->ulpStatus,
> +				 irsp->un.ulpWord[4]);
>  		lpfc_ct_free_iocb(phba, cmdiocb);
>  		return;
>  	}
> @@ -1141,10 +1124,9 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba *p
>  	ndlp = lpfc_findnode_did(vport, FDMI_DID);
>  	if (fdmi_rsp == be16_to_cpu(SLI_CT_RESPONSE_FS_RJT)) {
>  		/* FDMI rsp failed */
> -		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			        "%d (%d):0220 FDMI rsp failed Data: x%x\n",
> -			        phba->brd_no, vport->vpi,
> -				be16_to_cpu(fdmi_cmd));
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +				 "0220 FDMI rsp failed Data: x%x\n",
> +				 be16_to_cpu(fdmi_cmd));
>  	}
>  
>  	switch (be16_to_cpu(fdmi_cmd)) {
> @@ -1207,11 +1189,9 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, 
>  	INIT_LIST_HEAD(&bmp->list);
>  
>  	/* FDMI request */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0218 FDMI Request Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, vport->fc_flag,
> -			vport->port_state, cmdcode);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0218 FDMI Request Data: x%x x%x x%x\n",
> +			 vport->fc_flag, vport->port_state, cmdcode);
>  	CtReq = (struct lpfc_sli_ct_request *) mp->virt;
>  
>  	memset(CtReq, 0, sizeof(struct lpfc_sli_ct_request));
> @@ -1534,9 +1514,9 @@ fdmi_cmd_free_mp:
>  	kfree(mp);
>  fdmi_cmd_exit:
>  	/* Issue FDMI request failed */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -		        "%d (%d):0244 Issue FDMI request failed Data: x%x\n",
> -		        phba->brd_no, vport->vpi, cmdcode);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0244 Issue FDMI request failed Data: x%x\n",
> +			 cmdcode);
>  	return 1;
>  }
>  
> diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 09:26:42.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 09:29:52.000000000 -0400
> @@ -642,13 +642,11 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  		lpfc_debugfs_root = debugfs_create_dir("lpfc", NULL);
>  		atomic_set(&lpfc_debugfs_hba_count, 0);
>  		if (!lpfc_debugfs_root) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0409 Cannot create debugfs root (lpfc)",
> -				phba->brd_no);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +					 "0409 Cannot create debugfs root\n");
>  			goto debug_failed;
>  		}
>  	}
> -
>  	if (!lpfc_debugfs_start_time)
>  		lpfc_debugfs_start_time = jiffies;
>  
> @@ -658,9 +656,8 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  		phba->hba_debugfs_root =
>  			debugfs_create_dir(name, lpfc_debugfs_root);
>  		if (!phba->hba_debugfs_root) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0409 Cannot create debugfs hba (lpfc%d)",
> -				phba->brd_no, phba->brd_no);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +					 "0409 Cannot create debugfs hba\n");
>  			goto debug_failed;
>  		}
>  		atomic_inc(&lpfc_debugfs_hba_count);
> @@ -673,9 +670,8 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  				 phba->hba_debugfs_root,
>  				 phba, &lpfc_debugfs_op_dumpslim);
>  		if (!phba->debug_dumpslim) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0409 Cannot create debugfs dumpslim (lpfc%d)",
> -				phba->brd_no, phba->brd_no);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +				"0409 Cannot create debugfs dumpslim\n");
>  			goto debug_failed;
>  		}
>  
> @@ -692,8 +688,8 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  				}
>  				lpfc_debugfs_max_slow_ring_trc = (1 << i);
>  				printk(KERN_ERR
> -				"lpfc_debugfs_max_slow_ring_trc change to %d\n",
> -					lpfc_debugfs_max_slow_ring_trc);
> +				       "lpfc_debugfs_max_disc_trc changed to "
> +				       "%d\n", lpfc_debugfs_max_disc_trc);
>  			}
>  		}
>  
> @@ -704,10 +700,9 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  				 phba->hba_debugfs_root,
>  				 phba, &lpfc_debugfs_op_slow_ring_trc);
>  		if (!phba->debug_slow_ring_trc) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0409 Cannot create debugfs "
> -				"slow_ring_trace (lpfc%d)",
> -				phba->brd_no, phba->brd_no);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +					 "0409 Cannot create debugfs "
> +					 "slow_ring_trace\n");
>  			goto debug_failed;
>  		}
>  		if (!phba->slow_ring_trc) {
> @@ -716,10 +711,9 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  				lpfc_debugfs_max_slow_ring_trc),
>  				GFP_KERNEL);
>  			if (!phba->slow_ring_trc) {
> -				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0409 Cannot create debugfs "
> -				"slow_ring buffer (lpfc%d)",
> -				phba->brd_no, phba->brd_no);
> +				lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +						 "0409 Cannot create debugfs "
> +						 "slow_ring buffer\n");
>  				goto debug_failed;
>  			}
>  			atomic_set(&phba->slow_ring_trc_cnt, 0);
> @@ -734,9 +728,8 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  		vport->vport_debugfs_root =
>  			debugfs_create_dir(name, phba->hba_debugfs_root);
>  		if (!vport->vport_debugfs_root) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0409 Cant create debugfs vport%d (lpfc%d)",
> -				phba->brd_no, vport->vpi, phba->brd_no);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +					 "0409 Cant create debugfs");
>  			goto debug_failed;
>  		}
>  		atomic_inc(&phba->debugfs_vport_count);
> @@ -754,8 +747,8 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  			}
>  			lpfc_debugfs_max_disc_trc = (1 << i);
>  			printk(KERN_ERR
> -				"lpfc_debugfs_max_disc_trc changed to %d\n",
> -				lpfc_debugfs_max_disc_trc);
> +			       "lpfc_debugfs_max_disc_trc changed to %d\n",
> +			       lpfc_debugfs_max_disc_trc);
>  		}
>  	}
>  
> @@ -764,10 +757,9 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  		GFP_KERNEL);
>  
>  	if (!vport->disc_trc) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0409 Cannot create debugfs "
> -			"vport%d disc trace buffer (lpfc%d)",
> -			phba->brd_no, vport->vpi, phba->brd_no);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +				 "0409 Cannot create debugfs disc trace "
> +				 "buffer\n");
>  		goto debug_failed;
>  	}
>  	atomic_set(&vport->disc_trc_cnt, 0);
> @@ -780,10 +772,9 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  				 vport->vport_debugfs_root,
>  				 vport, &lpfc_debugfs_op_disc_trc);
>  	if (!vport->debug_disc_trc) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0409 Cannot create debugfs "
> -			"vport%d discovery_trace (lpfc%d)",
> -			phba->brd_no, vport->vpi, phba->brd_no);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +				 "0409 Cannot create debugfs "
> +				 "discovery_trace\n");
>  		goto debug_failed;
>  	}
>  	snprintf(name, sizeof(name), "nodelist");
> @@ -792,9 +783,8 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  				 vport->vport_debugfs_root,
>  				 vport, &lpfc_debugfs_op_nodelist);
>  	if (!vport->debug_nodelist) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0409 Cant create debugfs vport%d nodelist (lpfc%d)",
> -			phba->brd_no, vport->vpi, phba->brd_no);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
> +				 "0409 Cant create debugfs nodelist");
>  		goto debug_failed;
>  	}
>  debug_failed:
> diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> --- a/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 09:27:04.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 09:29:52.000000000 -0400
> @@ -63,10 +63,10 @@ lpfc_els_chk_latt(struct lpfc_vport *vpo
>  		return 0;
>  
>  	/* Pending Link Event during Discovery */
> -	lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -			"%d (%d):0237 Pending Link Event during "
> -			"Discovery: State x%x\n",
> -			phba->brd_no, vport->vpi,  phba->pport->port_state);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +			 "0237 Pending Link Event during "
> +			 "Discovery: State x%x\n",
> +			 phba->pport->port_state);
>  
>  	/* CLEAR_LA should re-enable link attention events and
>  	 * we should then imediately take a LATT event. The
> @@ -208,23 +208,21 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
>  	if (prsp) {
>  		list_add(&prsp->list, &pcmd->list);
>  	}
> -
>  	if (expectRsp) {
>  		/* Xmit ELS command <elsCmd> to remote NPORT <did> */
> -		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -				"%d (%d):0116 Xmit ELS command x%x to remote "
> -				"NPORT x%x I/O tag: x%x, port state: x%x\n",
> -				phba->brd_no, vport->vpi,  elscmd, did,
> -				elsiocb->iotag, vport->port_state);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +				 "0116 Xmit ELS command x%x to remote "
> +				 "NPORT x%x I/O tag: x%x, port state: x%x\n",
> +				 elscmd, did, elsiocb->iotag,
> +				 vport->port_state);
>  	} else {
>  		/* Xmit ELS response <elsCmd> to remote NPORT <did> */
> -		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -				"%d (%d):0117 Xmit ELS response x%x to remote "
> -				"NPORT x%x I/O tag: x%x, size: x%x\n",
> -				phba->brd_no, vport->vpi, elscmd,
> -				ndlp->nlp_DID, elsiocb->iotag, cmdSize);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +				 "0117 Xmit ELS response x%x to remote "
> +				 "NPORT x%x I/O tag: x%x, size: x%x\n",
> +				 elscmd, ndlp->nlp_DID, elsiocb->iotag,
> +				 cmdSize);
>  	}
> -
>  	return elsiocb;
>  }
>  
> @@ -285,9 +283,8 @@ fail_free_mbox:
>  
>  fail:
>  	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -	lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -		"%d (%d):0249 Cannot issue Register Fabric login\n",
> -		phba->brd_no, vport->vpi);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +		"0249 Cannot issue Register Fabric login\n");
>  	return -ENXIO;
>  }
>  
> @@ -340,20 +337,19 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
>  
>  	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
>  		if (sp->cmn.response_multiple_NPort) {
> -			lpfc_printf_log(phba, KERN_WARNING, LOG_ELS | LOG_VPORT,
> -					"%d:1816 FLOGI NPIV supported, "
> -					"response data 0x%x\n",
> -					phba->brd_no,
> -					sp->cmn.response_multiple_NPort);
> +			lpfc_printf_vlog(vport, KERN_WARNING,
> +					 LOG_ELS | LOG_VPORT,
> +					 "1816 FLOGI NPIV supported, "
> +					 "response data 0x%x\n",
> +					 sp->cmn.response_multiple_NPort);
>  			phba->link_flag |= LS_NPIV_FAB_SUPPORTED;
> -
>  		} else {
>  			/* Because we asked f/w for NPIV it still expects us
> -			   to call reg_vnpid atleast for the physcial host */
> -			lpfc_printf_log(phba, KERN_WARNING, LOG_ELS | LOG_VPORT,
> -					"%d:1817 Fabric does not support NPIV "
> -					"- configuring single port mode.\n",
> -					phba->brd_no);
> +			to call reg_vnpid atleast for the physcial host */
> +			lpfc_printf_vlog(vport, KERN_WARNING,
> +					 LOG_ELS | LOG_VPORT,
> +					 "1817 Fabric does not support NPIV "
> +					 "- configuring single port mode.\n");
>  			phba->link_flag &= ~LS_NPIV_FAB_SUPPORTED;
>  		}
>  	}
> @@ -522,12 +518,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
>  		}
>  
>  		/* FLOGI failure */
> -		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -				"%d (%d):0100 FLOGI failure Data: x%x x%x "
> -				"x%x\n",
> -				phba->brd_no, vport->vpi,
> -				irsp->ulpStatus, irsp->un.ulpWord[4],
> -				irsp->ulpTimeout);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +				 "0100 FLOGI failure Data: x%x x%x "
> +				 "x%x\n",
> +				 irsp->ulpStatus, irsp->un.ulpWord[4],
> +				 irsp->ulpTimeout);
>  		goto flogifail;
>  	}
>  
> @@ -540,12 +535,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
>  	sp = prsp->virt + sizeof(uint32_t);
>  
>  	/* FLOGI completes successfully */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0101 FLOGI completes sucessfully "
> -			"Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi,
> -			irsp->un.ulpWord[4], sp->cmn.e_d_tov,
> -			sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0101 FLOGI completes sucessfully "
> +			 "Data: x%x x%x x%x x%x\n",
> +			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
> +			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution);
>  
>  	if (vport->port_state == LPFC_FLOGI) {
>  		/*
> @@ -662,8 +656,8 @@ lpfc_els_abort_flogi(struct lpfc_hba *ph
>  
>  	/* Abort outstanding I/O on NPort <nlp_DID> */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d:0201 Abort outstanding I/O on NPort x%x\n",
> -			phba->brd_no, Fabric_DID);
> +			"0201 Abort outstanding I/O on NPort x%x\n",
> +			Fabric_DID);
>  
>  	pring = &phba->sli.ring[LPFC_ELS_RING];
>  
> @@ -736,18 +730,16 @@ static void
>  lpfc_more_plogi(struct lpfc_vport *vport)
>  {
>  	int sentplogi;
> -	struct lpfc_hba *phba = vport->phba;
>  
>  	if (vport->num_disc_nodes)
>  		vport->num_disc_nodes--;
>  
>  	/* Continue discovery with <num_disc_nodes> PLOGIs to go */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0232 Continue discovery with %d PLOGIs to go "
> -			"Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, vport->num_disc_nodes,
> -			vport->fc_plogi_cnt, vport->fc_flag, vport->port_state);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0232 Continue discovery with %d PLOGIs to go "
> +			 "Data: x%x x%x x%x\n",
> +			 vport->num_disc_nodes, vport->fc_plogi_cnt,
> +			 vport->fc_flag, vport->port_state);
>  	/* Check to see if there are more PLOGIs to be sent */
>  	if (vport->fc_flag & FC_NLP_MORE)
>  		/* go thru NPR nodes and issue any remaining ELS PLOGIs */
> @@ -833,11 +825,12 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
>  
>  	ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
>  	if (!ndlp) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0136 PLOGI completes to NPort x%x "
> -			"with no ndlp. Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, irsp->un.elsreq64.remoteID,
> -			irsp->ulpStatus, irsp->un.ulpWord[4], irsp->ulpIoTag);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0136 PLOGI completes to NPort x%x "
> +				 "with no ndlp. Data: x%x x%x x%x\n",
> +				 irsp->un.elsreq64.remoteID,
> +				 irsp->ulpStatus, irsp->un.ulpWord[4],
> +				 irsp->ulpIoTag);
>  		goto out;
>  	}
>  
> @@ -851,13 +844,11 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
>  	rc   = 0;
>  
>  	/* PLOGI completes to NPort <nlp_DID> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0102 PLOGI completes to NPort x%x "
> -			"Data: x%x x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, ndlp->nlp_DID,
> -			irsp->ulpStatus, irsp->un.ulpWord[4],
> -			irsp->ulpTimeout, disc, vport->num_disc_nodes);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0102 PLOGI completes to NPort x%x "
> +			 "Data: x%x x%x x%x x%x x%x\n",
> +			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
> +			 irsp->ulpTimeout, disc, vport->num_disc_nodes);
>  	/* Check to see if link went down during discovery */
>  	if (lpfc_els_chk_latt(vport)) {
>  		spin_lock_irq(shost->host_lock);
> @@ -881,17 +872,14 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
>  			}
>  			goto out;
>  		}
> -
>  		/* PLOGI failed */
>  		if (ndlp->nlp_DID == NameServer_DID) {
>  			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -			lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -				"%d (%d):0250 Nameserver login error: "
> -				"0x%x / 0x%x\n",
> -				phba->brd_no, vport->vpi,
> -				irsp->ulpStatus, irsp->un.ulpWord[4]);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +					 "0250 Nameserver login error: "
> +					 "0x%x / 0x%x\n",
> +					 irsp->ulpStatus, irsp->un.ulpWord[4]);
>  		}
> -
>  		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
>  		if (lpfc_error_lost_link(irsp)) {
>  			rc = NLP_STE_FREED_NODE;
> @@ -1017,14 +1005,12 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba
>  		"PRLI cmpl:       status:x%x/x%x did:x%x",
>  		irsp->ulpStatus, irsp->un.ulpWord[4],
>  		ndlp->nlp_DID);
> -
>  	/* PRLI completes to NPort <nlp_DID> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0103 PRLI completes to NPort x%x "
> -			"Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, ndlp->nlp_DID,
> -			irsp->ulpStatus, irsp->un.ulpWord[4], irsp->ulpTimeout,
> -			vport->num_disc_nodes);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0103 PRLI completes to NPort x%x "
> +			 "Data: x%x x%x x%x x%x\n",
> +			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
> +			 irsp->ulpTimeout, vport->num_disc_nodes);
>  
>  	vport->fc_prli_sent--;
>  	/* Check to see if link went down during discovery */
> @@ -1129,18 +1115,15 @@ static void
>  lpfc_more_adisc(struct lpfc_vport *vport)
>  {
>  	int sentadisc;
> -	struct lpfc_hba *phba = vport->phba;
>  
>  	if (vport->num_disc_nodes)
>  		vport->num_disc_nodes--;
> -
>  	/* Continue discovery with <num_disc_nodes> ADISCs to go */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0210 Continue discovery with %d ADISCs to go "
> -			"Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, vport->num_disc_nodes,
> -			vport->fc_adisc_cnt, vport->fc_flag, vport->port_state);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0210 Continue discovery with %d ADISCs to go "
> +			 "Data: x%x x%x x%x\n",
> +			 vport->num_disc_nodes, vport->fc_adisc_cnt,
> +			 vport->fc_flag, vport->port_state);
>  	/* Check to see if there are more ADISCs to be sent */
>  	if (vport->fc_flag & FC_NLP_MORE) {
>  		lpfc_set_disctmo(vport);
> @@ -1206,15 +1189,12 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phb
>  	disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
>  	ndlp->nlp_flag &= ~(NLP_ADISC_SND | NLP_NPR_2B_DISC);
>  	spin_unlock_irq(shost->host_lock);
> -
>  	/* ADISC completes to NPort <nlp_DID> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0104 ADISC completes to NPort x%x "
> -			"Data: x%x x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, ndlp->nlp_DID,
> -			irsp->ulpStatus, irsp->un.ulpWord[4], irsp->ulpTimeout,
> -			disc, vport->num_disc_nodes);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0104 ADISC completes to NPort x%x "
> +			 "Data: x%x x%x x%x x%x x%x\n",
> +			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
> +			 irsp->ulpTimeout, disc, vport->num_disc_nodes);
>  	/* Check to see if link went down during discovery */
>  	if (lpfc_els_chk_latt(vport)) {
>  		spin_lock_irq(shost->host_lock);
> @@ -1374,15 +1354,12 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba
>  		"LOGO cmpl:       status:x%x/x%x did:x%x",
>  		irsp->ulpStatus, irsp->un.ulpWord[4],
>  		ndlp->nlp_DID);
> -
>  	/* LOGO completes to NPort <nlp_DID> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0105 LOGO completes to NPort x%x "
> -			"Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, ndlp->nlp_DID,
> -			irsp->ulpStatus, irsp->un.ulpWord[4], irsp->ulpTimeout,
> -			vport->num_disc_nodes);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0105 LOGO completes to NPort x%x "
> +			 "Data: x%x x%x x%x x%x\n",
> +			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
> +			 irsp->ulpTimeout, vport->num_disc_nodes);
>  	/* Check to see if link went down during discovery */
>  	if (lpfc_els_chk_latt(vport))
>  		goto out;
> @@ -1488,15 +1465,11 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba,
>  		"ELS cmd cmpl:    status:x%x/x%x did:x%x",
>  		irsp->ulpStatus, irsp->un.ulpWord[4],
>  		irsp->un.elsreq64.remoteID);
> -
>  	/* ELS cmd tag <ulpIoTag> completes */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0106 ELS cmd tag x%x completes Data: x%x x%x "
> -			"x%x\n",
> -			phba->brd_no, vport->vpi,
> -			irsp->ulpIoTag, irsp->ulpStatus,
> -			irsp->un.ulpWord[4], irsp->ulpTimeout);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0106 ELS cmd tag x%x completes Data: x%x x%x x%x\n",
> +			 irsp->ulpIoTag, irsp->ulpStatus,
> +			 irsp->un.ulpWord[4], irsp->ulpTimeout);
>  	/* Check to see if link went down during discovery */
>  	lpfc_els_chk_latt(vport);
>  	lpfc_els_free_iocb(phba, cmdiocb);
> @@ -1831,9 +1804,9 @@ lpfc_els_retry(struct lpfc_hba *phba, st
>  		case IOERR_ILLEGAL_COMMAND:
>  			if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) &&
>  			    (cmd == ELS_CMD_FDISC)) {
> -				lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -				"%d (%d):0124 FDISC failed (3/6) retrying...\n",
> -					phba->brd_no, vport->vpi);
> +				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +						 "0124 FDISC failed (3/6) "
> +						 "retrying...\n");
>  				lpfc_mbx_unreg_vpi(vport);
>  				retry = 1;
>  				/* Always retry for this case */
> @@ -1898,10 +1871,10 @@ lpfc_els_retry(struct lpfc_hba *phba, st
>  			if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
>  			  (cmd == ELS_CMD_FDISC) &&
>  			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_OUT_OF_RESOURCE)){
> -				lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -				"%d (%d):0125 FDISC Failed (x%x)."
> -				" Fabric out of resources\n",
> -				phba->brd_no, vport->vpi, stat.un.lsRjtError);
> +				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +						 "0125 FDISC Failed (x%x). "
> +						 "Fabric out of resources\n",
> +						 stat.un.lsRjtError);
>  				lpfc_vport_set_state(vport,
>  						     FC_VPORT_NO_FABRIC_RSCS);
>  			}
> @@ -1926,10 +1899,10 @@ lpfc_els_retry(struct lpfc_hba *phba, st
>  			  ((stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_PNAME) ||
>  			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_NPORT_ID))
>  			  ) {
> -				lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -				"%d (%d):0123 FDISC Failed (x%x)."
> -				" Fabric Detected Bad WWN\n",
> -				phba->brd_no, vport->vpi, stat.un.lsRjtError);
> +				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +						 "0123 FDISC Failed (x%x). "
> +						 "Fabric Detected Bad WWN\n",
> +						 stat.un.lsRjtError);
>  				lpfc_vport_set_state(vport,
>  						     FC_VPORT_FABRIC_REJ_WWN);
>  			}
> @@ -1959,11 +1932,10 @@ lpfc_els_retry(struct lpfc_hba *phba, st
>  	if (retry) {
>  
>  		/* Retry ELS command <elsCmd> to remote NPORT <did> */
> -		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -				"%d (%d):0107 Retry ELS command x%x to remote "
> -				"NPORT x%x Data: x%x x%x\n",
> -				phba->brd_no, vport->vpi,
> -				cmd, did, cmdiocb->retry, delay);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +				 "0107 Retry ELS command x%x to remote "
> +				 "NPORT x%x Data: x%x x%x\n",
> +				 cmd, did, cmdiocb->retry, delay);
>  
>  		if (((cmd == ELS_CMD_PLOGI) || (cmd == ELS_CMD_ADISC)) &&
>  			((irsp->ulpStatus != IOSTAT_LOCAL_REJECT) ||
> @@ -2031,7 +2003,6 @@ lpfc_els_retry(struct lpfc_hba *phba, st
>  			return 1;
>  		}
>  	}
> -
>  	/* No retry ELS command <elsCmd> to remote NPORT <did> */
>  	lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
>  			 "0108 No retry ELS command x%x to remote "
> @@ -2086,14 +2057,12 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
>  		"ACC LOGO cmpl:   status:x%x/x%x did:x%x",
>  		irsp->ulpStatus, irsp->un.ulpWord[4], ndlp->nlp_DID);
> -
>  	/* ACC to LOGO completes to NPort <nlp_DID> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0109 ACC to LOGO completes to NPort x%x "
> -			"Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, ndlp->nlp_DID,
> -			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0109 ACC to LOGO completes to NPort x%x "
> +			 "Data: x%x x%x x%x\n",
> +			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			 ndlp->nlp_rpi);
>  	switch (ndlp->nlp_state) {
>  	case NLP_STE_UNUSED_NODE:	/* node is just allocated */
>  		lpfc_drop_node(vport, ndlp);
> @@ -2155,17 +2124,14 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
>  		"ACC cmpl:        status:x%x/x%x did:x%x",
>  		irsp->ulpStatus, irsp->un.ulpWord[4],
>  		irsp->un.rcvels.remoteID);
> -
>  	/* ELS response tag <ulpIoTag> completes */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0110 ELS response tag x%x completes "
> -			"Data: x%x x%x x%x x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi,
> -			cmdiocb->iocb.ulpIoTag, rspiocb->iocb.ulpStatus,
> -			rspiocb->iocb.un.ulpWord[4], rspiocb->iocb.ulpTimeout,
> -			ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> -			ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0110 ELS response tag x%x completes "
> +			 "Data: x%x x%x x%x x%x x%x x%x x%x\n",
> +			 cmdiocb->iocb.ulpIoTag, rspiocb->iocb.ulpStatus,
> +			 rspiocb->iocb.un.ulpWord[4], rspiocb->iocb.ulpTimeout,
> +			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			 ndlp->nlp_rpi);
>  	if (mbox) {
>  		if ((rspiocb->iocb.ulpStatus == 0)
>  		    && (ndlp->nlp_flag & NLP_ACC_REGLOGIN)) {
> @@ -2309,15 +2275,13 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
>  		lpfc_nlp_put(ndlp);
>  		elsiocb->context1 = NULL;
>  	}
> -
>  	/* Xmit ELS ACC response tag <ulpIoTag> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0128 Xmit ELS ACC response tag x%x, XRI: x%x, "
> -			"DID: x%x, nlp_flag: x%x nlp_state: x%x RPI: x%x\n",
> -			phba->brd_no, vport->vpi, elsiocb->iotag,
> -			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
> -			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0128 Xmit ELS ACC response tag x%x, XRI: x%x, "
> +			 "DID: x%x, nlp_flag: x%x nlp_state: x%x RPI: x%x\n",
> +			 elsiocb->iotag, elsiocb->iocb.ulpContext,
> +			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			 ndlp->nlp_rpi);
>  	if (ndlp->nlp_flag & NLP_LOGO_ACC) {
>  		spin_lock_irq(shost->host_lock);
>  		ndlp->nlp_flag &= ~NLP_LOGO_ACC;
> @@ -2375,14 +2339,13 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
>  	}
>  
>  	/* Xmit ELS RJT <err> response tag <ulpIoTag> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0129 Xmit ELS RJT x%x response tag x%x "
> -			"xri x%x, did x%x, nlp_flag x%x, nlp_state x%x, "
> -			"rpi x%x\n",
> -			phba->brd_no, vport->vpi, rejectError, elsiocb->iotag,
> -			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
> -			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0129 Xmit ELS RJT x%x response tag x%x "
> +			 "xri x%x, did x%x, nlp_flag x%x, nlp_state x%x, "
> +			 "rpi x%x\n",
> +			 rejectError, elsiocb->iotag,
> +			 elsiocb->iocb.ulpContext, ndlp->nlp_DID,
> +			 ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
>  		"Issue LS_RJT:    did:x%x flg:x%x err:x%x",
>  		ndlp->nlp_DID, ndlp->nlp_flag, rejectError);
> @@ -2422,13 +2385,12 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport
>  	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
>  
>  	/* Xmit ADISC ACC response tag <ulpIoTag> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0130 Xmit ADISC ACC response iotag x%x xri: "
> -			"x%x, did x%x, nlp_flag x%x, nlp_state x%x rpi x%x\n",
> -			phba->brd_no, vport->vpi, elsiocb->iotag,
> -			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
> -			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0130 Xmit ADISC ACC response iotag x%x xri: "
> +			 "x%x, did x%x, nlp_flag x%x, nlp_state x%x rpi x%x\n",
> +			 elsiocb->iotag, elsiocb->iocb.ulpContext,
> +			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			 ndlp->nlp_rpi);
>  	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
>  
>  	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
> @@ -2482,15 +2444,13 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport 
>  	icmd = &elsiocb->iocb;
>  	oldcmd = &oldiocb->iocb;
>  	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
> -
>  	/* Xmit PRLI ACC response tag <ulpIoTag> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0131 Xmit PRLI ACC response tag x%x xri x%x, "
> -			"did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
> -			phba->brd_no, vport->vpi, elsiocb->iotag,
> -			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
> -			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0131 Xmit PRLI ACC response tag x%x xri x%x, "
> +			 "did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
> +			 elsiocb->iotag, elsiocb->iocb.ulpContext,
> +			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			 ndlp->nlp_rpi);
>  	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
>  
>  	*((uint32_t *) (pcmd)) = (ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK));
> @@ -2564,16 +2524,11 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport 
>  	icmd = &elsiocb->iocb;
>  	oldcmd = &oldiocb->iocb;
>  	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
> -
>  	/* Xmit RNID ACC response tag <ulpIoTag> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0132 Xmit RNID ACC response tag x%x "
> -			"xri x%x\n",
> -			phba->brd_no, vport->vpi, elsiocb->iotag,
> -			elsiocb->iocb.ulpContext);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0132 Xmit RNID ACC response tag x%x xri x%x\n",
> +			 elsiocb->iotag, elsiocb->iocb.ulpContext);
>  	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
> -
>  	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
>  	pcmd += sizeof(uint32_t);
>  
> @@ -2716,7 +2671,6 @@ lpfc_rscn_payload_check(struct lpfc_vpor
>  	D_ID rscn_did;
>  	uint32_t *lp;
>  	uint32_t payload_len, i;
> -	struct lpfc_hba *phba = vport->phba;
>  
>  	ns_did.un.word = did;
>  
> @@ -2751,12 +2705,10 @@ lpfc_rscn_payload_check(struct lpfc_vpor
>  				break;
>  			default:
>  				/* Unknown Identifier in RSCN node */
> -				lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -						"%d (%d):0217 Unknown "
> -						"Identifier in RSCN payload "
> -						"Data: x%x\n",
> -						phba->brd_no, vport->vpi,
> -						rscn_did.un.word);
> +				lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +						 "0217 Unknown Identifier in "
> +						 "RSCN payload Data: x%x\n",
> +						 rscn_did.un.word);
>  			case 3:	/* Whole Fabric effected */
>  				return did;
>  			}
> @@ -2813,13 +2765,10 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
>  
>  	payload_len = be32_to_cpu(*lp++ & ~ELS_CMD_MASK);
>  	payload_len -= sizeof(uint32_t);	/* take off word 0 */
> -
>  	/* RSCN received */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0214 RSCN received Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, vport->fc_flag, payload_len,
> -			*lp, rscn_cnt);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0214 RSCN received Data: x%x x%x x%x x%x\n",
> +			 vport->fc_flag, payload_len, *lp, rscn_cnt);
>  	for (i = 0; i < payload_len/sizeof(uint32_t); i++)
>  		fc_host_post_event(shost, fc_get_event_number(),
>  			FCH_EVT_RSCN, lp[i]);
> @@ -2854,11 +2803,11 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
>  		}
>  		if (rscn_id == hba_id) {
>  			/* ALL NPortIDs in RSCN are on HBA */
> -			lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			  "%d (%d):0214 Ignore RSCN Data: x%x x%x x%x x%x\n",
> -			  phba->brd_no, vport->vpi, vport->fc_flag, payload_len,
> -			  *lp, rscn_cnt);
> -
> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +					 "0214 Ignore RSCN "
> +					 "Data: x%x x%x x%x x%x\n",
> +					 vport->fc_flag, payload_len,
> +					 *lp, rscn_cnt);
>  			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
>  				"RCV RSCN vport:  did:x%x/ste:x%x flg:x%x",
>  				ndlp->nlp_DID, vport->port_state,
> @@ -2904,23 +2853,21 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
>  			}
>  
>  			/* Deferred RSCN */
> -			lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -					"%d (%d):0235 Deferred RSCN "
> -					"Data: x%x x%x x%x\n",
> -					phba->brd_no, vport->vpi,
> -					vport->fc_rscn_id_cnt, vport->fc_flag,
> -					vport->port_state);
> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +					 "0235 Deferred RSCN "
> +					 "Data: x%x x%x x%x\n",
> +					 vport->fc_rscn_id_cnt, vport->fc_flag,
> +					 vport->port_state);
>  		} else {
>  			spin_lock_irq(shost->host_lock);
>  			vport->fc_flag |= FC_RSCN_DISCOVERY;
>  			spin_unlock_irq(shost->host_lock);
>  			/* ReDiscovery RSCN */
> -			lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -					"%d (%d):0234 ReDiscovery RSCN "
> -					"Data: x%x x%x x%x\n",
> -					phba->brd_no, vport->vpi,
> -					vport->fc_rscn_id_cnt, vport->fc_flag,
> -					vport->port_state);
> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +					 "0234 ReDiscovery RSCN "
> +					 "Data: x%x x%x x%x\n",
> +					 vport->fc_rscn_id_cnt, vport->fc_flag,
> +					 vport->port_state);
>  		}
>  		/* Send back ACC */
>  		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL,
> @@ -2973,11 +2920,10 @@ lpfc_els_handle_rscn(struct lpfc_vport *
>  	lpfc_set_disctmo(vport);
>  
>  	/* RSCN processed */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0215 RSCN processed Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi,
> -			vport->fc_flag, 0, vport->fc_rscn_id_cnt,
> -			vport->port_state);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0215 RSCN processed Data: x%x x%x x%x x%x\n",
> +			 vport->fc_flag, 0, vport->fc_rscn_id_cnt,
> +			 vport->port_state);
>  
>  	/* To process RSCN, first compare RSCN data with NameServer */
>  	vport->fc_ns_retry = 0;
> @@ -3045,10 +2991,10 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
>  
>  		/* An FLOGI ELS command <elsCmd> was received from DID <did> in
>  		   Loop Mode */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -				"%d (%d):0113 An FLOGI ELS command x%x was "
> -				"received from DID x%x in Loop Mode\n",
> -				phba->brd_no, vport->vpi, cmd, did);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0113 An FLOGI ELS command x%x was "
> +				 "received from DID x%x in Loop Mode\n",
> +				 cmd, did);
>  		return 1;
>  	}
>  
> @@ -3219,16 +3165,13 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
>  	rps_rsp->primSeqErrCnt = be32_to_cpu(mb->un.varRdLnk.primSeqErrCnt);
>  	rps_rsp->invalidXmitWord = be32_to_cpu(mb->un.varRdLnk.invalidXmitWord);
>  	rps_rsp->crcCnt = be32_to_cpu(mb->un.varRdLnk.crcCnt);
> -
>  	/* Xmit ELS RPS ACC response tag <ulpIoTag> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0118 Xmit ELS RPS ACC response tag x%x "
> -			"xri x%x, did x%x, nlp_flag x%x, nlp_state x%x, "
> -			"rpi x%x\n",
> -			phba->brd_no, ndlp->vport->vpi, elsiocb->iotag,
> -			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
> -			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_ELS,
> +			 "0118 Xmit ELS RPS ACC response tag x%x xri x%x, "
> +			 "did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
> +			 elsiocb->iotag, elsiocb->iocb.ulpContext,
> +			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			 ndlp->nlp_rpi);
>  	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
>  	phba->fc_stat.elsXmitACC++;
>  	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR)
> @@ -3330,21 +3273,16 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *
>  	rpl_rsp.port_num_blk.portID = be32_to_cpu(vport->fc_myDID);
>  	memcpy(&rpl_rsp.port_num_blk.portName, &vport->fc_portname,
>  	    sizeof(struct lpfc_name));
> -
>  	memcpy(pcmd, &rpl_rsp, cmdsize - sizeof(uint32_t));
> -
> -
>  	/* Xmit ELS RPL ACC response tag <ulpIoTag> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0120 Xmit ELS RPL ACC response tag x%x "
> -			"xri x%x, did x%x, nlp_flag x%x, nlp_state x%x, "
> -			"rpi x%x\n",
> -			phba->brd_no, vport->vpi, elsiocb->iotag,
> -			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
> -			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0120 Xmit ELS RPL ACC response tag x%x "
> +			 "xri x%x, did x%x, nlp_flag x%x, nlp_state x%x, "
> +			 "rpi x%x\n",
> +			 elsiocb->iotag, elsiocb->iocb.ulpContext,
> +			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			 ndlp->nlp_rpi);
>  	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
> -
>  	phba->fc_stat.elsXmitACC++;
>  	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
>  		lpfc_els_free_iocb(phba, elsiocb);
> @@ -3397,7 +3335,6 @@ static int
>  lpfc_els_rcv_farp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>  		  struct lpfc_nodelist *ndlp)
>  {
> -	struct lpfc_hba *phba = vport->phba;
>  	struct lpfc_dmabuf *pcmd;
>  	uint32_t *lp;
>  	IOCB_t *icmd;
> @@ -3411,12 +3348,9 @@ lpfc_els_rcv_farp(struct lpfc_vport *vpo
>  
>  	cmd = *lp++;
>  	fp = (FARP *) lp;
> -
>  	/* FARP-REQ received from DID <did> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0601 FARP-REQ received from DID x%x\n",
> -			phba->brd_no, vport->vpi, did);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0601 FARP-REQ received from DID x%x\n", did);
>  	/* We will only support match on WWPN or WWNN */
>  	if (fp->Mflags & ~(FARP_MATCH_NODE | FARP_MATCH_PORT)) {
>  		return 0;
> @@ -3464,7 +3398,6 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vp
>  	uint32_t *lp;
>  	IOCB_t *icmd;
>  	uint32_t cmd, did;
> -	struct lpfc_hba *phba = vport->phba;
>  
>  	icmd = &cmdiocb->iocb;
>  	did = icmd->un.elsreq64.remoteID;
> @@ -3473,9 +3406,8 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vp
>  
>  	cmd = *lp++;
>  	/* FARP-RSP received from DID <did> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0600 FARP-RSP received from DID x%x\n",
> -			phba->brd_no, vport->vpi, did);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0600 FARP-RSP received from DID x%x\n", did);
>  	/* ACCEPT the Farp resp request */
>  	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
>  
> @@ -3495,10 +3427,8 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
>  	struct lpfc_hba *phba = vport->phba;
>  
>  	/* FAN received */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0265 FAN received\n",
> -			phba->brd_no, vport->vpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0265 FAN received\n");
>  	icmd = &cmdiocb->iocb;
>  	did = icmd->un.elsreq64.remoteID;
>  	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
> @@ -3657,13 +3587,10 @@ lpfc_els_timeout_handler(struct lpfc_vpo
>  			if (ndlp)
>  				remote_ID = ndlp->nlp_DID;
>  		}
> -
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -				"%d (%d):0127 ELS timeout Data: x%x x%x x%x "
> -				"x%x\n",
> -				phba->brd_no, vport->vpi, els_command,
> -				remote_ID, cmd->ulpCommand, cmd->ulpIoTag);
> -
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0127 ELS timeout Data: x%x x%x x%x "
> +				 "x%x\n", els_command,
> +				 remote_ID, cmd->ulpCommand, cmd->ulpIoTag);
>  		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
>  	}
>  	spin_unlock_irq(&phba->hbalock);
> @@ -3838,11 +3765,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
>  		cmd &= ELS_CMD_MASK;
>  	}
>  	/* ELS command <elsCmd> received from NPORT <did> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0112 ELS command x%x received from NPORT x%x "
> -			"Data: x%x\n", phba->brd_no, vport->vpi, cmd, did,
> -			vport->port_state);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0112 ELS command x%x received from NPORT x%x "
> +			 "Data: x%x\n", cmd, did, vport->port_state);
>  	switch (cmd) {
>  	case ELS_CMD_PLOGI:
>  		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
> @@ -4011,10 +3936,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
>  		rjt_err = LSRJT_INVALID_CMD;
>  
>  		/* Unknown ELS command <elsCmd> received from NPORT <did> */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -				"%d (%d):0115 Unknown ELS command x%x "
> -				"received from NPORT x%x\n",
> -				phba->brd_no, vport->vpi, cmd, did);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0115 Unknown ELS command x%x "
> +				 "received from NPORT x%x\n", cmd, did);
>  		if (newnode)
>  			lpfc_drop_node(vport, ndlp);
>  		break;
> @@ -4035,11 +3959,10 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
>  
>  dropit:
>  	lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0111 Dropping received ELS cmd "
> +			"(%d):0111 Dropping received ELS cmd "
>  			"Data: x%x x%x x%x\n",
> -			phba->brd_no, vport ? vport->vpi : 0xffff,
> -			icmd->ulpStatus, icmd->un.ulpWord[4],
> -			icmd->ulpTimeout);
> +			vport ? vport->vpi : 0xffff, icmd->ulpStatus,
> +			icmd->un.ulpWord[4], icmd->ulpTimeout);
>  	phba->fc_stat.elsRcvDrop++;
>  }
>  
> @@ -4151,9 +4074,8 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
>  				return;
>  			}
>  			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -			lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -				"%d (%d):0251 NameServer login: no memory\n",
> -				phba->brd_no, vport->vpi);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +					 "0251 NameServer login: no memory\n");
>  			return;
>  		}
>  		lpfc_nlp_init(vport, ndlp, NameServer_DID);
> @@ -4164,9 +4086,8 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
>  
>  	if (lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0)) {
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0252 Cannot issue NameServer login\n",
> -			phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0252 Cannot issue NameServer login\n");
>  		return;
>  	}
>  
> @@ -4197,9 +4118,9 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
>  	lpfc_nlp_put(ndlp);
>  
>  	if (mb->mbxStatus) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -				"%d (%d):0915 Register VPI failed: 0x%x\n",
> -				phba->brd_no, vport->vpi, mb->mbxStatus);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
> +				 "0915 Register VPI failed: 0x%x\n",
> +				 mb->mbxStatus);
>  
>  		switch (mb->mbxStatus) {
>  		case 0x11:	/* unsupported feature */
> @@ -4248,17 +4169,14 @@ lpfc_register_new_vport(struct lpfc_hba 
>  			vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
>  
>  			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -
> -			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -				"%d (%d):0253 Register VPI: Cannot send mbox\n",
> -				phba->brd_no, vport->vpi);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
> +				"0253 Register VPI: Can't send mbox\n");
>  		}
>  	} else {
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
>  
> -		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -			"%d (%d):0254 Register VPI: no memory\n",
> -			phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
> +				 "0254 Register VPI: no memory\n");
>  
>  		vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
>  		lpfc_nlp_put(ndlp);
> @@ -4277,11 +4195,10 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
>  	IOCB_t *irsp = &rspiocb->iocb;
>  	struct lpfc_iocbq *piocb;
>  
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -		"%d (%d):0123 FDISC completes. x%x/x%x prevDID: x%x\n",
> -		phba->brd_no, vport->vpi,
> -		irsp->ulpStatus, irsp->un.ulpWord[4], vport->fc_prevDID);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0123 FDISC completes. x%x/x%x prevDID: x%x\n",
> +			 irsp->ulpStatus, irsp->un.ulpWord[4],
> +			 vport->fc_prevDID);
>  	/* Since all FDISCs are being single threaded, we
>  	 * must reset the discovery timer for ALL vports
>  	 * waiting to send FDISC when one completes.
> @@ -4298,13 +4215,10 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
>  		/* Check for retry */
>  		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
>  			goto out;
> -
>  		/* FDISC failed */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0124 FDISC failed. (%d/%d)\n",
> -			phba->brd_no, vport->vpi,
> -			irsp->ulpStatus, irsp->un.ulpWord[4]);
> -
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0124 FDISC failed. (%d/%d)\n",
> +				 irsp->ulpStatus, irsp->un.ulpWord[4]);
>  		if (vport->fc_vport->vport_state == FC_VPORT_INITIALIZING)
>  			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
>  
> @@ -4370,10 +4284,8 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
>  				     ELS_CMD_FDISC);
>  	if (!elsiocb) {
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0255 Issue FDISC: no IOCB\n",
> -			phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0255 Issue FDISC: no IOCB\n");
>  		return 1;
>  	}
>  
> @@ -4419,11 +4331,8 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
>  	if (rc == IOCB_ERROR) {
>  		lpfc_els_free_iocb(phba, elsiocb);
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0256 Issue FDISC: Cannot send IOCB\n",
> -			phba->brd_no, vport->vpi);
> -
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0256 Issue FDISC: Cannot send IOCB\n");
>  		return 1;
>  	}
>  	lpfc_vport_set_state(vport, FC_VPORT_INITIALIZING);
> diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> --- a/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:27:04.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:29:52.000000000 -0400
> @@ -349,6 +349,7 @@ struct lpfc_vport {
>  	uint32_t cfg_use_adisc;
>  	uint32_t cfg_fdmi_on;
>  	uint32_t cfg_discovery_threads;
> +	uint32_t cfg_log_verbose;
>  	uint32_t cfg_max_luns;
>  
>  	uint32_t dev_loss_tmo_changed;
> @@ -446,8 +447,6 @@ struct lpfc_hba {
>  	uint64_t cfg_soft_wwpn;
>  	uint32_t cfg_hba_queue_depth;
>  
> -	/* Config paramters that should be in the vport */
> -	uint32_t cfg_log_verbose;
>  
>  	lpfc_vpd_t vpd;		/* vital product data */
>  
> diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:27:04.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:29:52.000000000 -0400
> @@ -201,25 +201,23 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
>  		warn_on = 0;
>  
>  	if (warn_on) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0203 Devloss timeout on "
> -				"WWPN %x:%x:%x:%x:%x:%x:%x:%x "
> -				"NPort x%x Data: x%x x%x x%x\n",
> -				phba->brd_no, vport->vpi,
> -				*name, *(name+1), *(name+2), *(name+3),
> -				*(name+4), *(name+5), *(name+6), *(name+7),
> -				ndlp->nlp_DID, ndlp->nlp_flag,
> -				ndlp->nlp_state, ndlp->nlp_rpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0203 Devloss timeout on "
> +				 "WWPN %x:%x:%x:%x:%x:%x:%x:%x "
> +				 "NPort x%x Data: x%x x%x x%x\n",
> +				 *name, *(name+1), *(name+2), *(name+3),
> +				 *(name+4), *(name+5), *(name+6), *(name+7),
> +				 ndlp->nlp_DID, ndlp->nlp_flag,
> +				 ndlp->nlp_state, ndlp->nlp_rpi);
>  	} else {
> -		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -				"%d (%d):0204 Devloss timeout on "
> -				"WWPN %x:%x:%x:%x:%x:%x:%x:%x "
> -				"NPort x%x Data: x%x x%x x%x\n",
> -				phba->brd_no, vport->vpi,
> -				*name, *(name+1), *(name+2), *(name+3),
> -				*(name+4), *(name+5), *(name+6), *(name+7),
> -				ndlp->nlp_DID, ndlp->nlp_flag,
> -				ndlp->nlp_state, ndlp->nlp_rpi);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +				 "0204 Devloss timeout on "
> +				 "WWPN %x:%x:%x:%x:%x:%x:%x:%x "
> +				 "NPort x%x Data: x%x x%x x%x\n",
> +				 *name, *(name+1), *(name+2), *(name+3),
> +				 *(name+4), *(name+5), *(name+6), *(name+7),
> +				 ndlp->nlp_DID, ndlp->nlp_flag,
> +				 ndlp->nlp_state, ndlp->nlp_rpi);
>  	}
>  
>  	if (!(vport->load_flag & FC_UNLOADING) &&
> @@ -750,12 +748,10 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *
>  	/* Check for error */
>  	if ((mb->mbxStatus) && (mb->mbxStatus != 0x1601)) {
>  		/* CLEAR_LA mbox error <mbxStatus> state <hba_state> */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -				"%d (%d):0320 CLEAR_LA mbxStatus error x%x hba "
> -				"state x%x\n",
> -				phba->brd_no, vport->vpi, mb->mbxStatus,
> -				vport->port_state);
> -
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
> +				 "0320 CLEAR_LA mbxStatus error x%x hba "
> +				 "state x%x\n",
> +				 mb->mbxStatus, vport->port_state);
>  		phba->link_state = LPFC_HBA_ERROR;
>  		goto out;
>  	}
> @@ -787,10 +783,8 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *
>  
>  out:
>  	/* Device Discovery completes */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0225 Device Discovery completes\n",
> -			phba->brd_no, vport->vpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0225 Device Discovery completes\n");
>  	mempool_free(pmb, phba->mbox_mem_pool);
>  
>  	spin_lock_irq(shost->host_lock);
> @@ -847,19 +841,17 @@ lpfc_mbx_cmpl_local_config_link(struct l
>  	return;
>  
>  out:
> -	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -			"%d (%d):0306 CONFIG_LINK mbxStatus error x%x "
> -			"HBA state x%x\n",
> -			phba->brd_no, vport->vpi, pmb->mb.mbxStatus,
> -			vport->port_state);
> -
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
> +			 "0306 CONFIG_LINK mbxStatus error x%x "
> +			 "HBA state x%x\n",
> +			 pmb->mb.mbxStatus, vport->port_state);
>  	mempool_free(pmb, phba->mbox_mem_pool);
>  
>  	lpfc_linkdown(phba);
>  
> -	lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -			"%d (%d):0200 CONFIG_LINK bad hba state x%x\n",
> -			phba->brd_no, vport->vpi, vport->port_state);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +			 "0200 CONFIG_LINK bad hba state x%x\n",
> +			 vport->port_state);
>  
>  	lpfc_issue_clear_la(phba, vport);
>  	return;
> @@ -876,12 +868,10 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hb
>  	/* Check for error */
>  	if (mb->mbxStatus) {
>  		/* READ_SPARAM mbox error <mbxStatus> state <hba_state> */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -				"%d (%d):0319 READ_SPARAM mbxStatus error x%x "
> -				"hba state x%x>\n",
> -				phba->brd_no, vport->vpi, mb->mbxStatus,
> -				vport->port_state);
> -
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
> +				 "0319 READ_SPARAM mbxStatus error x%x "
> +				 "hba state x%x>\n",
> +				 mb->mbxStatus, vport->port_state);
>  		lpfc_linkdown(phba);
>  		goto out;
>  	}
> @@ -964,7 +954,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
>  		if (i == 0) {
>  			phba->alpa_map[0] = 0;
>  		} else {
> -			if (phba->cfg_log_verbose & LOG_LINK_EVENT) {
> +			if (vport->cfg_log_verbose & LOG_LINK_EVENT) {
>  				int numalpa, j, k;
>  				union {
>  					uint8_t pamap[16];
> @@ -990,10 +980,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba
>  					lpfc_printf_log(phba,
>  							KERN_WARNING,
>  							LOG_LINK_EVENT,
> -							"%d:1304 Link Up Event "
> +							"1304 Link Up Event "
>  							"ALPA map Data: x%x "
>  							"x%x x%x x%x\n",
> -							phba->brd_no,
>  							un.pa.wd1, un.pa.wd2,
>  							un.pa.wd3, un.pa.wd4);
>  				}
> @@ -1041,11 +1030,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba
>  	}
>  out:
>  	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -		"%d (%d):0263 Discovery Mailbox error: state: 0x%x : %p %p\n",
> -		phba->brd_no, vport->vpi,
> -		vport->port_state, sparam_mbox, cfglink_mbox);
> -
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
> +			 "0263 Discovery Mailbox error: state: 0x%x : %p %p\n",
> +			 vport->port_state, sparam_mbox, cfglink_mbox);
>  	lpfc_issue_clear_la(phba, vport);
>  	return;
>  }
> @@ -1086,8 +1073,8 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
>  	/* Check for error */
>  	if (mb->mbxStatus) {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
> -				"%d:1307 READ_LA mbox error x%x state x%x\n",
> -				phba->brd_no, mb->mbxStatus, vport->port_state);
> +				"1307 READ_LA mbox error x%x state x%x\n",
> +				mb->mbxStatus, vport->port_state);
>  		lpfc_mbx_issue_link_down(phba);
>  		phba->link_state = LPFC_HBA_ERROR;
>  		goto lpfc_mbx_cmpl_read_la_free_mbuf;
> @@ -1118,26 +1105,26 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
>  		phba->fc_stat.LinkUp++;
>  		if (phba->link_flag & LS_LOOPBACK_MODE) {
>  			lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
> -				"%d:1306 Link Up Event in loop back mode "
> -				"x%x received Data: x%x x%x x%x x%x\n",
> -				phba->brd_no, la->eventTag, phba->fc_eventTag,
> -				la->granted_AL_PA, la->UlnkSpeed,
> -				phba->alpa_map[0]);
> +					"1306 Link Up Event in loop back mode "
> +					"x%x received Data: x%x x%x x%x x%x\n",
> +					la->eventTag, phba->fc_eventTag,
> +					la->granted_AL_PA, la->UlnkSpeed,
> +					phba->alpa_map[0]);
>  		} else {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
> -				"%d:1303 Link Up Event x%x received "
> -				"Data: x%x x%x x%x x%x\n",
> -				phba->brd_no, la->eventTag, phba->fc_eventTag,
> -				la->granted_AL_PA, la->UlnkSpeed,
> -				phba->alpa_map[0]);
> +					"1303 Link Up Event x%x received "
> +					"Data: x%x x%x x%x x%x\n",
> +					la->eventTag, phba->fc_eventTag,
> +					la->granted_AL_PA, la->UlnkSpeed,
> +					phba->alpa_map[0]);
>  		}
>  		lpfc_mbx_process_link_up(phba, la);
>  	} else {
>  		phba->fc_stat.LinkDown++;
>  		lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
> -				"%d:1305 Link Down Event x%x received "
> +				"1305 Link Down Event x%x received "
>  				"Data: x%x x%x x%x\n",
> -				phba->brd_no, la->eventTag, phba->fc_eventTag,
> +				la->eventTag, phba->fc_eventTag,
>  				phba->pport->port_state, vport->fc_flag);
>  		lpfc_mbx_issue_link_down(phba);
>  	}
> @@ -1185,10 +1172,9 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba 
>  	case 0x0011:
>  	case 0x0020:
>  	case 0x9700:
> -		lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
> -				"%d (%d):0911 cmpl_unreg_vpi, "
> -				"mb status = 0x%x\n",
> -				phba->brd_no, vport->vpi, mb->mbxStatus);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
> +				 "0911 cmpl_unreg_vpi, mb status = 0x%x\n",
> +				 mb->mbxStatus);
>  		break;
>  	}
>  	vport->unreg_vpi_cmpl = VPORT_OK;
> @@ -1217,9 +1203,8 @@ lpfc_mbx_unreg_vpi(struct lpfc_vport *vp
>  	mbox->mbox_cmpl = lpfc_mbx_cmpl_unreg_vpi;
>  	rc = lpfc_sli_issue_mbox(phba, mbox, (MBX_NOWAIT | MBX_STOP_IOCB));
>  	if (rc == MBX_NOT_FINISHED) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_VPORT,
> -				"%d (%d):1800 Could not issue unreg_vpi\n",
> -				phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
> +				 "1800 Could not issue unreg_vpi\n");
>  		mempool_free(mbox, phba->mbox_mem_pool);
>  		vport->unreg_vpi_cmpl = VPORT_ERROR;
>  	}
> @@ -1236,9 +1221,9 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *p
>  	case 0x0011:
>  	case 0x9601:
>  	case 0x9602:
> -		lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
> -				"%d (%d):0912 cmpl_reg_vpi, mb status = 0x%x\n",
> -				phba->brd_no, vport->vpi, mb->mbxStatus);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
> +				 "0912 cmpl_reg_vpi, mb status = 0x%x\n",
> +				 mb->mbxStatus);
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
>  		spin_lock_irq(shost->host_lock);
>  		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
> @@ -1300,10 +1285,9 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
>  		}
>  
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -			"%d (%d):0258 Register Fabric login error: 0x%x\n",
> -			phba->brd_no, vport->vpi, mb->mbxStatus);
> -
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
> +				 "0258 Register Fabric login error: 0x%x\n",
> +				 mb->mbxStatus);
>  		return;
>  	}
>  
> @@ -1327,11 +1311,10 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
>  						LPFC_SLI3_NPIV_ENABLED) {
>  					lpfc_vport_set_state(vports[i],
>  						FC_VPORT_NO_FABRIC_SUPP);
> -					lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -							"%d (%d):0259 No NPIV "
> -							"Fabric support\n",
> -							phba->brd_no,
> -							vports[i]->vpi);
> +					lpfc_printf_vlog(vport, KERN_ERR,
> +							 LOG_ELS,
> +							"0259 No NPIV "
> +							"Fabric support\n");
>  				}
>  			}
>  		lpfc_destroy_vport_work_array(vports);
> @@ -1378,9 +1361,9 @@ out:
>  			return;
>  		}
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0260 Register NameServer error: 0x%x\n",
> -			phba->brd_no, vport->vpi, mb->mbxStatus);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0260 Register NameServer error: 0x%x\n",
> +				 mb->mbxStatus);
>  		return;
>  	}
>  
> @@ -1605,12 +1588,11 @@ lpfc_nlp_set_state(struct lpfc_vport *vp
>  	int  old_state = ndlp->nlp_state;
>  	char name1[16], name2[16];
>  
> -	lpfc_printf_log(vport->phba, KERN_INFO, LOG_NODE,
> -			"%d (%d):0904 NPort state transition x%06x, %s -> %s\n",
> -			vport->phba->brd_no, vport->vpi,
> -			ndlp->nlp_DID,
> -			lpfc_nlp_state_name(name1, sizeof(name1), old_state),
> -			lpfc_nlp_state_name(name2, sizeof(name2), state));
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
> +			 "0904 NPort state transition x%06x, %s -> %s\n",
> +			 ndlp->nlp_DID,
> +			 lpfc_nlp_state_name(name1, sizeof(name1), old_state),
> +			 lpfc_nlp_state_name(name2, sizeof(name2), state));
>  
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
>  		"node statechg    did:x%x old:%d ste:%d",
> @@ -1702,12 +1684,12 @@ lpfc_set_disctmo(struct lpfc_vport *vpor
>  	spin_unlock_irq(shost->host_lock);
>  
>  	/* Start Discovery Timer state <hba_state> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0247 Start Discovery Timer state x%x "
> -			"Data: x%x x%lx x%x x%x\n",
> -			phba->brd_no, vport->vpi, vport->port_state, tmo,
> -			(unsigned long)&vport->fc_disctmo, vport->fc_plogi_cnt,
> -			vport->fc_adisc_cnt);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0247 Start Discovery Timer state x%x "
> +			 "Data: x%x x%lx x%x x%x\n",
> +			 vport->port_state, tmo,
> +			 (unsigned long)&vport->fc_disctmo, vport->fc_plogi_cnt,
> +			 vport->fc_adisc_cnt);
>  
>  	return;
>  }
> @@ -1719,7 +1701,6 @@ int
>  lpfc_can_disctmo(struct lpfc_vport *vport)
>  {
>  	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
> -	struct lpfc_hba  *phba = vport->phba;
>  	unsigned long iflags;
>  
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
> @@ -1738,13 +1719,11 @@ lpfc_can_disctmo(struct lpfc_vport *vpor
>  	}
>  
>  	/* Cancel Discovery Timer state <hba_state> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0248 Cancel Discovery Timer state x%x "
> -			"Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, vport->port_state,
> -			vport->fc_flag, vport->fc_plogi_cnt,
> -			vport->fc_adisc_cnt);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0248 Cancel Discovery Timer state x%x "
> +			 "Data: x%x x%x x%x\n",
> +			 vport->port_state, vport->fc_flag,
> +			 vport->fc_plogi_cnt, vport->fc_adisc_cnt);
>  	return 0;
>  }
>  
> @@ -1927,10 +1906,9 @@ lpfc_unreg_default_rpis(struct lpfc_vpor
>  		rc = lpfc_sli_issue_mbox(phba, mbox,
>  					 (MBX_NOWAIT | MBX_STOP_IOCB));
>  		if (rc == MBX_NOT_FINISHED) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_VPORT,
> -					"%d (%d):1815 Could not issue "
> -					"unreg_did (default rpis)\n",
> -					phba->brd_no, vport->vpi);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
> +					 "1815 Could not issue "
> +					 "unreg_did (default rpis)\n");
>  			mempool_free(mbox, phba->mbox_mem_pool);
>  		}
>  	}
> @@ -1949,12 +1927,11 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
>  	struct lpfc_dmabuf *mp;
>  
>  	/* Cleanup node for NPort <nlp_DID> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
> -			"%d (%d):0900 Cleanup node for NPort x%x "
> -			"Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, ndlp->nlp_DID, ndlp->nlp_flag,
> -			ndlp->nlp_state, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
> +			 "0900 Cleanup node for NPort x%x "
> +			 "Data: x%x x%x x%x\n",
> +			 ndlp->nlp_DID, ndlp->nlp_flag,
> +			 ndlp->nlp_state, ndlp->nlp_rpi);
>  	lpfc_dequeue_node(vport, ndlp);
>  
>  	/* cleanup any ndlp on mbox q waiting for reglogin cmpl */
> @@ -2086,7 +2063,6 @@ lpfc_matchdid(struct lpfc_vport *vport, 
>  static struct lpfc_nodelist *
>  __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
>  {
> -	struct lpfc_hba  *phba = vport->phba;
>  	struct lpfc_nodelist *ndlp;
>  	uint32_t data1;
>  
> @@ -2096,20 +2072,18 @@ __lpfc_findnode_did(struct lpfc_vport *v
>  				 ((uint32_t) ndlp->nlp_xri << 16) |
>  				 ((uint32_t) ndlp->nlp_type << 8) |
>  				 ((uint32_t) ndlp->nlp_rpi & 0xff));
> -			lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
> -					"%d (%d):0929 FIND node DID "
> -					" Data: x%p x%x x%x x%x\n",
> -					phba->brd_no, vport->vpi,
> -					ndlp, ndlp->nlp_DID,
> -					ndlp->nlp_flag, data1);
> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
> +					 "0929 FIND node DID "
> +					 "Data: x%p x%x x%x x%x\n",
> +					 ndlp, ndlp->nlp_DID,
> +					 ndlp->nlp_flag, data1);
>  			return ndlp;
>  		}
>  	}
>  
>  	/* FIND node did <did> NOT FOUND */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
> -			"%d (%d):0932 FIND node did x%x NOT FOUND.\n",
> -			phba->brd_no, vport->vpi, did);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
> +			 "0932 FIND node did x%x NOT FOUND.\n", did);
>  	return NULL;
>  }
>  
> @@ -2301,12 +2275,11 @@ lpfc_disc_start(struct lpfc_vport *vport
>  	vport->num_disc_nodes = 0;
>  
>  	/* Start Discovery state <hba_state> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0202 Start Discovery hba state x%x "
> -			"Data: x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi, vport->port_state,
> -			vport->fc_flag, vport->fc_plogi_cnt,
> -			vport->fc_adisc_cnt);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0202 Start Discovery hba state x%x "
> +			 "Data: x%x x%x x%x\n",
> +			 vport->port_state, vport->fc_flag, vport->fc_plogi_cnt,
> +			 vport->fc_adisc_cnt);
>  
>  	/* First do ADISCs - if any */
>  	num_sent = lpfc_els_disc_adisc(vport);
> @@ -2524,10 +2497,8 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  	 * FAN
>  	 */
>  				/* FAN timeout */
> -		lpfc_printf_log(phba, KERN_WARNING, LOG_DISCOVERY,
> -				"%d (%d):0221 FAN timeout\n",
> -				phba->brd_no, vport->vpi);
> -
> +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_DISCOVERY,
> +				 "0221 FAN timeout\n");
>  		/* Start discovery by sending FLOGI, clean up old rpis */
>  		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
>  					 nlp_listp) {
> @@ -2554,10 +2525,9 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  	case LPFC_FLOGI:
>  	/* port_state is identically LPFC_FLOGI while waiting for FLOGI cmpl */
>  		/* Initial FLOGI timeout */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0222 Initial %s timeout\n",
> -				phba->brd_no, vport->vpi,
> -				vport->vpi ? "FLOGI" : "FDISC");
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0222 Initial %s timeout\n",
> +				 vport->vpi ? "FLOGI" : "FDISC");
>  
>  		/* Assume no Fabric and go on with discovery.
>  		 * Check for outstanding ELS FLOGI to abort.
> @@ -2573,11 +2543,9 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  	case LPFC_FABRIC_CFG_LINK:
>  	/* hba_state is identically LPFC_FABRIC_CFG_LINK while waiting for
>  	   NameServer login */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0223 Timeout while waiting for "
> -				"NameServer login\n",
> -				phba->brd_no, vport->vpi);
> -
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0223 Timeout while waiting for "
> +				 "NameServer login\n");
>  		/* Next look for NameServer ndlp */
>  		ndlp = lpfc_findnode_did(vport, NameServer_DID);
>  		if (ndlp)
> @@ -2588,11 +2556,10 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  
>  	case LPFC_NS_QRY:
>  	/* Check for wait for NameServer Rsp timeout */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0224 NameServer Query timeout "
> -				"Data: x%x x%x\n",
> -				phba->brd_no, vport->vpi,
> -				vport->fc_ns_retry, LPFC_MAX_NS_RETRY);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0224 NameServer Query timeout "
> +				 "Data: x%x x%x\n",
> +				 vport->fc_ns_retry, LPFC_MAX_NS_RETRY);
>  
>  		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
>  			/* Try it one more time */
> @@ -2619,10 +2586,9 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  		/* Setup and issue mailbox INITIALIZE LINK command */
>  		initlinkmbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
>  		if (!initlinkmbox) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -					"%d (%d):0206 Device Discovery "
> -					"completion error\n",
> -					phba->brd_no, vport->vpi);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +					 "0206 Device Discovery "
> +					 "completion error\n");
>  			phba->link_state = LPFC_HBA_ERROR;
>  			break;
>  		}
> @@ -2643,9 +2609,8 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  
>  	case LPFC_DISC_AUTH:
>  	/* Node Authentication timeout */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0227 Node Authentication timeout\n",
> -				phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0227 Node Authentication timeout\n");
>  		lpfc_disc_flush_list(vport);
>  
>  		/*
> @@ -2662,11 +2627,10 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  
>  	case LPFC_VPORT_READY:
>  		if (vport->fc_flag & FC_RSCN_MODE) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -					"%d (%d):0231 RSCN timeout Data: x%x "
> -					"x%x\n",
> -					phba->brd_no, vport->vpi,
> -					vport->fc_ns_retry, LPFC_MAX_NS_RETRY);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +					 "0231 RSCN timeout Data: x%x "
> +					 "x%x\n",
> +					 vport->fc_ns_retry, LPFC_MAX_NS_RETRY);
>  
>  			/* Cleanup any outstanding ELS commands */
>  			lpfc_els_flush_cmd(vport);
> @@ -2677,20 +2641,17 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  		break;
>  
>  	default:
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0229 Unexpected discovery timeout, "
> -				"vport State x%x\n",
> -				phba->brd_no, vport->vpi, vport->port_state);
> -
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0229 Unexpected discovery timeout, "
> +				 "vport State x%x\n", vport->port_state);
>  		break;
>  	}
>  
>  	switch (phba->link_state) {
>  	case LPFC_CLEAR_LA:
>  				/* CLEAR LA timeout */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0228 CLEAR LA timeout\n",
> -				phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0228 CLEAR LA timeout\n");
>  		clrlaerr = 1;
>  		break;
>  
> @@ -2701,10 +2662,9 @@ lpfc_disc_timeout_handler(struct lpfc_vp
>  	case LPFC_LINK_DOWN:
>  	case LPFC_LINK_UP:
>  	case LPFC_HBA_ERROR:
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0230 Unexpected timeout, hba link "
> -				"state x%x\n",
> -				phba->brd_no, vport->vpi, phba->link_state);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				 "0230 Unexpected timeout, hba link "
> +				 "state x%x\n", phba->link_state);
>  		clrlaerr = 1;
>  		break;
>  
> diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> --- a/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 09:27:04.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 09:29:52.000000000 -0400
> @@ -107,10 +107,9 @@ lpfc_config_port_prep(struct lpfc_hba *p
>  
>  		if (rc != MBX_SUCCESS) {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
> -					"%d:0324 Config Port initialization "
> +					"0324 Config Port initialization "
>  					"error, mbxCmd x%x READ_NVPARM, "
>  					"mbxStatus x%x\n",
> -					phba->brd_no,
>  					mb->mbxCommand, mb->mbxStatus);
>  			mempool_free(pmb, phba->mbox_mem_pool);
>  			return -ERESTART;
> @@ -128,9 +127,8 @@ lpfc_config_port_prep(struct lpfc_hba *p
>  	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
>  	if (rc != MBX_SUCCESS) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0439 Adapter failed to init, mbxCmd x%x "
> +				"0439 Adapter failed to init, mbxCmd x%x "
>  				"READ_REV, mbxStatus x%x\n",
> -				phba->brd_no,
>  				mb->mbxCommand, mb->mbxStatus);
>  		mempool_free( pmb, phba->mbox_mem_pool);
>  		return -ERESTART;
> @@ -144,9 +142,8 @@ lpfc_config_port_prep(struct lpfc_hba *p
>  	if (mb->un.varRdRev.rr == 0) {
>  		vp->rev.rBit = 0;
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0440 Adapter failed to init, READ_REV has "
> -				"missing revision information.\n",
> -				phba->brd_no);
> +				"0440 Adapter failed to init, READ_REV has "
> +				"missing revision information.\n");
>  		mempool_free(pmb, phba->mbox_mem_pool);
>  		return -ERESTART;
>  	}
> @@ -197,9 +194,8 @@ lpfc_config_port_prep(struct lpfc_hba *p
>  
>  		if (rc != MBX_SUCCESS) {
>  			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -					"%d:0441 VPD not present on adapter, "
> +					"0441 VPD not present on adapter, "
>  					"mbxCmd x%x DUMP VPD, mbxStatus x%x\n",
> -					phba->brd_no,
>  					mb->mbxCommand, mb->mbxStatus);
>  			mb->un.varDmp.word_cnt = 0;
>  		}
> @@ -253,9 +249,8 @@ lpfc_config_port_post(struct lpfc_hba *p
>  	pmb->vport = vport;
>  	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0448 Adapter failed init, mbxCmd x%x "
> +				"0448 Adapter failed init, mbxCmd x%x "
>  				"READ_SPARM mbxStatus x%x\n",
> -				phba->brd_no,
>  				mb->mbxCommand, mb->mbxStatus);
>  		phba->link_state = LPFC_HBA_ERROR;
>  		mp = (struct lpfc_dmabuf *) pmb->context1;
> @@ -312,9 +307,8 @@ lpfc_config_port_post(struct lpfc_hba *p
>  	pmb->vport = vport;
>  	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0453 Adapter failed to init, mbxCmd x%x "
> +				"0453 Adapter failed to init, mbxCmd x%x "
>  				"READ_CONFIG, mbxStatus x%x\n",
> -				phba->brd_no,
>  				mb->mbxCommand, mb->mbxStatus);
>  		phba->link_state = LPFC_HBA_ERROR;
>  		mempool_free( pmb, phba->mbox_mem_pool);
> @@ -344,9 +338,8 @@ lpfc_config_port_post(struct lpfc_hba *p
>  		&& !(phba->lmt & LMT_10Gb))) {
>  		/* Reset link speed to auto */
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_LINK_EVENT,
> -			"%d:1302 Invalid speed for this board: "
> +			"1302 Invalid speed for this board: "
>  			"Reset link speed to auto: x%x\n",
> -			phba->brd_no,
>  			phba->cfg_link_speed);
>  			phba->cfg_link_speed = LINK_SPEED_AUTO;
>  	}
> @@ -402,9 +395,8 @@ lpfc_config_port_post(struct lpfc_hba *p
>  	lpfc_set_loopback_flag(phba);
>  	if (rc != MBX_SUCCESS) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0454 Adapter failed to init, mbxCmd x%x "
> +				"0454 Adapter failed to init, mbxCmd x%x "
>  				"INIT_LINK, mbxStatus x%x\n",
> -				phba->brd_no,
>  				mb->mbxCommand, mb->mbxStatus);
>  
>  		/* Clear all interrupt enable conditions */
> @@ -588,8 +580,8 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
>  		 * need to take the HBA offline.
>  		 */
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0459 Adapter heartbeat failure, taking "
> -			"this port offline.\n", phba->brd_no);
> +				"0459 Adapter heartbeat failure, taking "
> +				"this port offline.\n");
>  
>  		spin_lock_irq(&phba->hbalock);
>  		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
> @@ -631,9 +623,9 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
>  	    phba->work_hs & HS_FFER5) {
>  		/* Re-establishing Link */
>  		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
> -				"%d:1301 Re-establishing Link "
> +				"1301 Re-establishing Link "
>  				"Data: x%x x%x x%x\n",
> -				phba->brd_no, phba->work_hs,
> +				phba->work_hs,
>  				phba->work_status[0], phba->work_status[1]);
>  		vports = lpfc_create_vport_work_array(phba);
>  		if (vports != NULL)
> @@ -679,9 +671,9 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
>  		 *  twice. This is the adapter hardware error path.
>  		 */
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0457 Adapter Hardware Error "
> +				"0457 Adapter Hardware Error "
>  				"Data: x%x x%x x%x\n",
> -				phba->brd_no, phba->work_hs,
> +				phba->work_hs,
>  				phba->work_status[0], phba->work_status[1]);
>  
>  		event_data = FC_REG_DUMP_EVENT;
> @@ -777,8 +769,7 @@ lpfc_handle_latt_err_exit:
>  	/* The other case is an error from issue_mbox */
>  	if (rc == -ENOMEM)
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
> -			        "%d:0300 READ_LA: no buffers\n",
> -				phba->brd_no);
> +			        "0300 READ_LA: no buffers\n");
>  
>  	return;
>  }
> @@ -803,8 +794,7 @@ lpfc_parse_vpd(struct lpfc_hba *phba, ui
>  
>  	/* Vital Product */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -			"%d:0455 Vital Product Data: x%x x%x x%x x%x\n",
> -			phba->brd_no,
> +			"0455 Vital Product Data: x%x x%x x%x x%x\n",
>  			(uint32_t) vpd[0], (uint32_t) vpd[1], (uint32_t) vpd[2],
>  			(uint32_t) vpd[3]);
>  	while (!finished && (index < (len - 4))) {
> @@ -1323,10 +1313,9 @@ lpfc_establish_link_tmo(unsigned long pt
>  
>  	/* Re-establishing Link, timer expired */
>  	lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
> -			"%d:1300 Re-establishing Link, timer expired "
> +			"1300 Re-establishing Link, timer expired "
>  			"Data: x%x x%x\n",
> -			phba->brd_no,  phba->pport->fc_flag,
> -			phba->pport->port_state);
> +			phba->pport->fc_flag, phba->pport->port_state);
>  	vports = lpfc_create_vport_work_array(phba);
>  	if (vports != NULL)
>  		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
> @@ -1382,8 +1371,7 @@ lpfc_online(struct lpfc_hba *phba)
>  		return 0;
>  
>  	lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
> -		       "%d:0458 Bring Adapter online\n",
> -		       phba->brd_no);
> +			"0458 Bring Adapter online\n");
>  
>  	lpfc_block_mgmt_io(phba);
>  
> @@ -1468,8 +1456,7 @@ lpfc_offline(struct lpfc_hba *phba)
>  	/* stop all timers associated with this hba */
>  	lpfc_stop_phba_timers(phba);
>  	lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
> -		       "%d:0460 Bring Adapter offline\n",
> -		       phba->brd_no);
> +			"0460 Bring Adapter offline\n");
>  	/* Bring down the SLI Layer and cleanup.  The HBA is offline
>  	   now.  */
>  	lpfc_sli_hba_down(phba);
> @@ -1648,17 +1635,15 @@ int lpfc_scan_finished(struct Scsi_Host 
>  	}
>  	if (time >= 30 * HZ) {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -				"%d:0461 Scanning longer than 30 "
> -				"seconds.  Continuing initialization\n",
> -				phba->brd_no);
> +				"0461 Scanning longer than 30 "
> +				"seconds.  Continuing initialization\n");
>  		stat = 1;
>  		goto finished;
>  	}
>  	if (time >= 15 * HZ && phba->link_state <= LPFC_LINK_DOWN) {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -				"%d:0465 Link down longer than 15 "
> -				"seconds.  Continuing initialization\n",
> -				phba->brd_no);
> +				"0465 Link down longer than 15 "
> +				"seconds.  Continuing initialization\n");
>  		stat = 1;
>  		goto finished;
>  	}
> @@ -1911,17 +1896,16 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
>  	if (phba->cfg_use_msi) {
>  		error = pci_enable_msi(phba->pcidev);
>  		if (error)
> -			lpfc_printf_log(phba, KERN_INFO, LOG_INIT, "%d:0452 "
> -					"Enable MSI failed, continuing with "
> -					"IRQ\n", phba->brd_no);
> +			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> +					"0452 Enable MSI failed, continuing "
> +					"with IRQ\n");
>  	}
>  
>  	error =	request_irq(phba->pcidev->irq, lpfc_intr_handler, IRQF_SHARED,
>  			    LPFC_DRIVER_NAME, phba);
>  	if (error) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0451 Enable interrupt handler failed\n",
> -			phba->brd_no);
> +			"0451 Enable interrupt handler failed\n");
>  		goto out_disable_msi;
>  	}
>  
> diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
> --- a/drivers/scsi/lpfc/lpfc_logmsg.h	2007-07-20 13:38:28.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2007-08-02 09:29:52.000000000 -0400
> @@ -33,6 +33,12 @@
>  #define LOG_VPORT                     0x4000	/* NPIV events */
>  #define LOG_ALL_MSG                   0xffff	/* LOG all messages */
>  
> +#define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
> +	{ if (((mask) &(vport)->cfg_log_verbose) || (level[1] <= '3')) \
> +		dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
> +			   fmt, (vport)->phba->brd_no, vport->vpi, ##arg); }
> +
>  #define lpfc_printf_log(phba, level, mask, fmt, arg...) \
> -	{ if (((mask) &(phba)->cfg_log_verbose) || (level[1] <= '3')) \
> -		dev_printk(level, &((phba)->pcidev)->dev, fmt, ##arg); }
> +	{ if (((mask) &(phba)->pport->cfg_log_verbose) || (level[1] <= '3')) \
> +		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
> +			   fmt, phba->brd_no, ##arg); }
> diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
> --- a/drivers/scsi/lpfc/lpfc_mbox.c	2007-07-20 13:38:28.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_mbox.c	2007-08-02 09:29:52.000000000 -0400
> @@ -275,11 +275,8 @@ lpfc_read_sparam(struct lpfc_hba *phba, 
>  		kfree(mp);
>  		mb->mbxCommand = MBX_READ_SPARM64;
>  		/* READ_SPARAM: no buffers */
> -		lpfc_printf_log(phba,
> -			        KERN_WARNING,
> -			        LOG_MBOX,
> -			        "%d:0301 READ_SPARAM: no buffers\n",
> -			        phba->brd_no);
> +		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
> +			        "0301 READ_SPARAM: no buffers\n");
>  		return (1);
>  	}
>  	INIT_LIST_HEAD(&mp->list);
> @@ -378,9 +375,8 @@ lpfc_reg_login(struct lpfc_hba *phba, ui
>  		mb->mbxCommand = MBX_REG_LOGIN64;
>  		/* REG_LOGIN: no buffers */
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
> -				"%d (%d):0302 REG_LOGIN: no buffers, DID x%x, "
> -				"flag x%x\n",
> -				phba->brd_no, vpi, did, flag);
> +				"0302 REG_LOGIN: no buffers, VPI:%d DID:x%x, "
> +				"flag x%x\n", vpi, did, flag);
>  		return (1);
>  	}
>  	INIT_LIST_HEAD(&mp->list);
> diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-08-02 09:27:04.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-08-02 09:29:52.000000000 -0400
> @@ -133,15 +133,15 @@ lpfc_check_sparm(struct lpfc_vport *vpor
>  	memcpy(&ndlp->nlp_portname, &sp->portName, sizeof (struct lpfc_name));
>  	return 1;
>  bad_service_param:
> -	lpfc_printf_log(vport->phba, KERN_ERR, LOG_DISCOVERY,
> -			"%d (%d):0207 Device %x "
> -			"(%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x) sent "
> -			"invalid service parameters.  Ignoring device.\n",
> -			vport->phba->brd_no, ndlp->vport->vpi, ndlp->nlp_DID,
> -			sp->nodeName.u.wwn[0], sp->nodeName.u.wwn[1],
> -			sp->nodeName.u.wwn[2], sp->nodeName.u.wwn[3],
> -			sp->nodeName.u.wwn[4], sp->nodeName.u.wwn[5],
> -			sp->nodeName.u.wwn[6], sp->nodeName.u.wwn[7]);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +			 "0207 Device %x "
> +			 "(%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x) sent "
> +			 "invalid service parameters.  Ignoring device.\n",
> +			 ndlp->nlp_DID,
> +			 sp->nodeName.u.wwn[0], sp->nodeName.u.wwn[1],
> +			 sp->nodeName.u.wwn[2], sp->nodeName.u.wwn[3],
> +			 sp->nodeName.u.wwn[4], sp->nodeName.u.wwn[5],
> +			 sp->nodeName.u.wwn[6], sp->nodeName.u.wwn[7]);
>  	return 0;
>  }
>  
> @@ -194,11 +194,11 @@ lpfc_els_abort(struct lpfc_hba *phba, st
>  	IOCB_t *cmd;
>  
>  	/* Abort outstanding I/O on NPort <nlp_DID> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0205 Abort outstanding I/O on NPort x%x "
> -			"Data: x%x x%x x%x\n",
> -			phba->brd_no, ndlp->vport->vpi, ndlp->nlp_DID,
> -			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
> +	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0205 Abort outstanding I/O on NPort x%x "
> +			 "Data: x%x x%x x%x\n",
> +			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			 ndlp->nlp_rpi);
>  
>  	lpfc_fabric_abort_nport(ndlp);
>  
> @@ -298,11 +298,10 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
>  	icmd = &cmdiocb->iocb;
>  
>  	/* PLOGI chkparm OK */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0114 PLOGI chkparm OK Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi,
> -			ndlp->nlp_DID, ndlp->nlp_state, ndlp->nlp_flag,
> -			ndlp->nlp_rpi);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0114 PLOGI chkparm OK Data: x%x x%x x%x x%x\n",
> +			 ndlp->nlp_DID, ndlp->nlp_state, ndlp->nlp_flag,
> +			 ndlp->nlp_rpi);
>  
>  	if (vport->cfg_fcp_class == 2 && sp->cls2.classValid)
>  		ndlp->nlp_fcp_info |= CLASS2;
> @@ -582,12 +581,11 @@ static uint32_t
>  lpfc_disc_illegal(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>  		  void *arg, uint32_t evt)
>  {
> -	lpfc_printf_log(vport->phba, KERN_ERR, LOG_DISCOVERY,
> -			"%d (%d):0253 Illegal State Transition: node x%x "
> -			"event x%x, state x%x Data: x%x x%x\n",
> -			vport->phba->brd_no, vport->vpi,
> -			ndlp->nlp_DID, evt, ndlp->nlp_state, ndlp->nlp_rpi,
> -			ndlp->nlp_flag);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +			 "0253 Illegal State Transition: node x%x "
> +			 "event x%x, state x%x Data: x%x x%x\n",
> +			 ndlp->nlp_DID, evt, ndlp->nlp_state, ndlp->nlp_rpi,
> +			 ndlp->nlp_flag);
>  	return ndlp->nlp_state;
>  }
>  
> @@ -777,15 +775,11 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
>  	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
>  	if (!lpfc_check_sparm(vport, ndlp, sp, CLASS3))
>  		goto out;
> -
>  	/* PLOGI chkparm OK */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (%d):0121 PLOGI chkparm OK "
> -			"Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi,
> -			ndlp->nlp_DID, ndlp->nlp_state,
> -			ndlp->nlp_flag, ndlp->nlp_rpi);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "0121 PLOGI chkparm OK Data: x%x x%x x%x x%x\n",
> +			 ndlp->nlp_DID, ndlp->nlp_state,
> +			 ndlp->nlp_flag, ndlp->nlp_rpi);
>  	if (vport->cfg_fcp_class == 2 && (sp->cls2.classValid))
>  		ndlp->nlp_fcp_info |= CLASS2;
>  	else
> @@ -805,10 +799,9 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
>  
>  	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
>  	if (!mbox) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0133 PLOGI: no memory for reg_login "
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +			"0133 PLOGI: no memory for reg_login "
>  			"Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi,
>  			ndlp->nlp_DID, ndlp->nlp_state,
>  			ndlp->nlp_flag, ndlp->nlp_rpi);
>  		goto out;
> @@ -843,30 +836,27 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
>  		kfree(mp);
>  		mempool_free(mbox, phba->mbox_mem_pool);
>  
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0134 PLOGI: cannot issue reg_login "
> -			"Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi,
> -			ndlp->nlp_DID, ndlp->nlp_state,
> -			ndlp->nlp_flag, ndlp->nlp_rpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0134 PLOGI: cannot issue reg_login "
> +				 "Data: x%x x%x x%x x%x\n",
> +				 ndlp->nlp_DID, ndlp->nlp_state,
> +				 ndlp->nlp_flag, ndlp->nlp_rpi);
>  	} else {
>  		mempool_free(mbox, phba->mbox_mem_pool);
>  
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0135 PLOGI: cannot format reg_login "
> -			"Data: x%x x%x x%x x%x\n",
> -			phba->brd_no, vport->vpi,
> -			ndlp->nlp_DID, ndlp->nlp_state,
> -			ndlp->nlp_flag, ndlp->nlp_rpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0135 PLOGI: cannot format reg_login "
> +				 "Data: x%x x%x x%x x%x\n",
> +				 ndlp->nlp_DID, ndlp->nlp_state,
> +				 ndlp->nlp_flag, ndlp->nlp_rpi);
>  	}
>  
> 
>  out:
>  	if (ndlp->nlp_DID == NameServer_DID) {
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> -		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -			"%d (%d):0261 Cannot Register NameServer login\n",
> -			phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0261 Cannot Register NameServer login\n");
>  	}
>  
>  	/* Free this node since the driver cannot login or has the wrong
> @@ -1188,19 +1178,15 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
>  				  uint32_t evt)
>  {
>  	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
> -	struct lpfc_hba  *phba = vport->phba;
>  	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
>  	MAILBOX_t *mb = &pmb->mb;
>  	uint32_t did  = mb->un.varWords[1];
>  
>  	if (mb->mbxStatus) {
>  		/* RegLogin failed */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
> -				"%d (%d):0246 RegLogin failed Data: x%x x%x "
> -				"x%x\n",
> -				phba->brd_no, vport->vpi,
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
> +				"0246 RegLogin failed Data: x%x x%x x%x\n",
>  				did, mb->mbxStatus, vport->port_state);
> -
>  		/*
>  		 * If RegLogin failed due to lack of HBA resources do not
>  		 * retry discovery.
> @@ -2046,7 +2032,6 @@ int
>  lpfc_disc_state_machine(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>  			void *arg, uint32_t evt)
>  {
> -	struct lpfc_hba  *phba = vport->phba;
>  	uint32_t cur_state, rc;
>  	uint32_t(*func) (struct lpfc_vport *, struct lpfc_nodelist *, void *,
>  			 uint32_t);
> @@ -2055,11 +2040,10 @@ lpfc_disc_state_machine(struct lpfc_vpor
>  	cur_state = ndlp->nlp_state;
>  
>  	/* DSM in event <evt> on NPort <nlp_DID> in state <cur_state> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0211 DSM in event x%x on NPort x%x in "
> -			"state %d Data: x%x\n",
> -			phba->brd_no, vport->vpi,
> -			evt, ndlp->nlp_DID, cur_state, ndlp->nlp_flag);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0211 DSM in event x%x on NPort x%x in "
> +			 "state %d Data: x%x\n",
> +			 evt, ndlp->nlp_DID, cur_state, ndlp->nlp_flag);
>  
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
>  		 "DSM in:          evt:%d ste:%d did:x%x",
> @@ -2069,11 +2053,9 @@ lpfc_disc_state_machine(struct lpfc_vpor
>  	rc = (func) (vport, ndlp, arg, evt);
>  
>  	/* DSM out state <rc> on NPort <nlp_DID> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
> -			"%d (%d):0212 DSM out state %d on NPort x%x "
> -			"Data: x%x\n",
> -			phba->brd_no, vport->vpi,
> -			rc, ndlp->nlp_DID, ndlp->nlp_flag);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +			 "0212 DSM out state %d on NPort x%x Data: x%x\n",
> +			 rc, ndlp->nlp_DID, ndlp->nlp_flag);
>  
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
>  		 "DSM out:         ste:%d did:x%x flg:x%x",
> diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> --- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-02 09:27:04.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-02 09:29:52.000000000 -0400
> @@ -406,9 +406,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
>  	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
>  	struct fcp_cmnd *fcpcmd = lpfc_cmd->fcp_cmnd;
>  	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
> -	struct lpfc_hba *phba = vport->phba;
>  	uint32_t fcpi_parm = rsp_iocb->iocb.un.fcpi.fcpi_parm;
> -	uint32_t vpi = vport->vpi;
>  	uint32_t resp_info = fcprsp->rspStatus2;
>  	uint32_t scsi_status = fcprsp->rspStatus3;
>  	uint32_t *lp;
> @@ -440,15 +438,15 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
>  	if (!scsi_status && (resp_info & RESID_UNDER))
>  		logit = LOG_FCP;
>  
> -	lpfc_printf_log(phba, KERN_WARNING, logit,
> -			"%d (%d):0730 FCP command x%x failed: x%x SNS x%x x%x "
> -			"Data: x%x x%x x%x x%x x%x\n",
> -			phba->brd_no, vpi, cmnd->cmnd[0], scsi_status,
> -			be32_to_cpu(*lp), be32_to_cpu(*(lp + 3)), resp_info,
> -			be32_to_cpu(fcprsp->rspResId),
> -			be32_to_cpu(fcprsp->rspSnsLen),
> -			be32_to_cpu(fcprsp->rspRspLen),
> -			fcprsp->rspInfo3);
> +	lpfc_printf_vlog(vport, KERN_WARNING, logit,
> +			 "0730 FCP command x%x failed: x%x SNS x%x x%x "
> +			 "Data: x%x x%x x%x x%x x%x\n",
> +			 cmnd->cmnd[0], scsi_status,
> +			 be32_to_cpu(*lp), be32_to_cpu(*(lp + 3)), resp_info,
> +			 be32_to_cpu(fcprsp->rspResId),
> +			 be32_to_cpu(fcprsp->rspSnsLen),
> +			 be32_to_cpu(fcprsp->rspRspLen),
> +			 fcprsp->rspInfo3);
>  
>  	if (resp_info & RSP_LEN_VALID) {
>  		rsplen = be32_to_cpu(fcprsp->rspRspLen);
> @@ -463,12 +461,12 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
>  	if (resp_info & RESID_UNDER) {
>  		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
>  
> -		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
> -				"%d (%d):0716 FCP Read Underrun, expected %d, "
> -				"residual %d Data: x%x x%x x%x\n",
> -				phba->brd_no, vpi, be32_to_cpu(fcpcmd->fcpDl),
> -				scsi_get_resid(cmnd), fcpi_parm, cmnd->cmnd[0],
> -				cmnd->underflow);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
> +				 "0716 FCP Read Underrun, expected %d, "
> +				 "residual %d Data: x%x x%x x%x\n",
> +				 be32_to_cpu(fcpcmd->fcpDl),
> +				 scsi_get_resid(cmnd), fcpi_parm, cmnd->cmnd[0],
> +				 cmnd->underflow);
>  
>  		/*
>  		 * If there is an under run check if under run reported by
> @@ -478,14 +476,13 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
>  		if ((cmnd->sc_data_direction == DMA_FROM_DEVICE) &&
>  			fcpi_parm &&
>  			(scsi_get_resid(cmnd) != fcpi_parm)) {
> -			lpfc_printf_log(phba, KERN_WARNING,
> -					LOG_FCP | LOG_FCP_ERROR,
> -					"%d (%d):0735 FCP Read Check Error "
> -					"and Underrun Data: x%x x%x x%x x%x\n",
> -					phba->brd_no, vpi,
> -					be32_to_cpu(fcpcmd->fcpDl),
> -					scsi_get_resid(cmnd), fcpi_parm,
> -					cmnd->cmnd[0]);
> +			lpfc_printf_vlog(vport, KERN_WARNING,
> +					 LOG_FCP | LOG_FCP_ERROR,
> +					 "0735 FCP Read Check Error "
> +					 "and Underrun Data: x%x x%x x%x x%x\n",
> +					 be32_to_cpu(fcpcmd->fcpDl),
> +					 scsi_get_resid(cmnd), fcpi_parm,
> +					 cmnd->cmnd[0]);
>  			scsi_set_resid(cmnd, scsi_bufflen(cmnd));
>  			host_status = DID_ERROR;
>  		}
> @@ -499,21 +496,19 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
>  		    (scsi_status == SAM_STAT_GOOD) &&
>  		    (scsi_bufflen(cmnd) - scsi_get_resid(cmnd)
>  		     < cmnd->underflow)) {
> -			lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
> -					"%d (%d):0717 FCP command x%x residual "
> -					"underrun converted to error "
> -					"Data: x%x x%x x%x\n",
> -					phba->brd_no, vpi, cmnd->cmnd[0],
> -					scsi_bufflen(cmnd),
> -					scsi_get_resid(cmnd), cmnd->underflow);
> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
> +					 "0717 FCP command x%x residual "
> +					 "underrun converted to error "
> +					 "Data: x%x x%x x%x\n",
> +					 cmnd->cmnd[0], cmnd->request_bufflen,
> +					 scsi_get_resid(cmnd), cmnd->underflow);
>  			host_status = DID_ERROR;
>  		}
>  	} else if (resp_info & RESID_OVER) {
> -		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
> -				"%d (%d):0720 FCP command x%x residual "
> -				"overrun error. Data: x%x x%x \n",
> -				phba->brd_no, vpi, cmnd->cmnd[0],
> -				scsi_bufflen(cmnd), scsi_get_resid(cmnd));
> +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
> +				 "0720 FCP command x%x residual overrun error. "
> +				 "Data: x%x x%x \n", cmnd->cmnd[0],
> +				 scsi_bufflen(cmnd), scsi_get_resid(cmnd));
>  		host_status = DID_ERROR;
>  
>  	/*
> @@ -522,13 +517,12 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
>  	 */
>  	} else if ((scsi_status == SAM_STAT_GOOD) && fcpi_parm &&
>  			(cmnd->sc_data_direction == DMA_FROM_DEVICE)) {
> -		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
> -				"%d (%d):0734 FCP Read Check Error Data: "
> -				"x%x x%x x%x x%x\n",
> -				phba->brd_no, vpi,
> -				be32_to_cpu(fcpcmd->fcpDl),
> -				be32_to_cpu(fcprsp->rspResId),
> -				fcpi_parm, cmnd->cmnd[0]);
> +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
> +				 "0734 FCP Read Check Error Data: "
> +				 "x%x x%x x%x x%x\n",
> +				 be32_to_cpu(fcpcmd->fcpDl),
> +				 be32_to_cpu(fcprsp->rspResId),
> +				 fcpi_parm, cmnd->cmnd[0]);
>  		host_status = DID_ERROR;
>  		scsi_set_resid(cmnd, scsi_bufflen(cmnd));
>  	}
> @@ -547,9 +541,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
>  	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
>  	struct lpfc_nodelist *pnode = rdata->pnode;
>  	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
> -	uint32_t vpi = (lpfc_cmd->cur_iocbq.vport
> -			? lpfc_cmd->cur_iocbq.vport->vpi
> -			: 0);
>  	int result;
>  	struct scsi_device *sdev, *tmp_sdev;
>  	int depth = 0;
> @@ -564,15 +555,15 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
>  		else if (lpfc_cmd->status >= IOSTAT_CNT)
>  			lpfc_cmd->status = IOSTAT_DEFAULT;
>  
> -		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
> -				"%d (%d):0729 FCP cmd x%x failed <%d/%d> "
> -				"status: x%x result: x%x Data: x%x x%x\n",
> -				phba->brd_no, vpi, cmd->cmnd[0],
> -				cmd->device ? cmd->device->id : 0xffff,
> -				cmd->device ? cmd->device->lun : 0xffff,
> -				lpfc_cmd->status, lpfc_cmd->result,
> -				pIocbOut->iocb.ulpContext,
> -				lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
> +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
> +				 "0729 FCP cmd x%x failed <%d/%d> "
> +				 "status: x%x result: x%x Data: x%x x%x\n",
> +				 cmd->cmnd[0],
> +				 cmd->device ? cmd->device->id : 0xffff,
> +				 cmd->device ? cmd->device->lun : 0xffff,
> +				 lpfc_cmd->status, lpfc_cmd->result,
> +				 pIocbOut->iocb.ulpContext,
> +				 lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
>  
>  		switch (lpfc_cmd->status) {
>  		case IOSTAT_FCP_RSP_ERROR:
> @@ -605,13 +596,12 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
>  	if (cmd->result || lpfc_cmd->fcp_rsp->rspSnsLen) {
>  		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
>  
> -		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
> -				"%d (%d):0710 Iodone <%d/%d> cmd %p, error "
> -				"x%x SNS x%x x%x Data: x%x x%x\n",
> -				phba->brd_no, vpi, cmd->device->id,
> -				cmd->device->lun, cmd, cmd->result,
> -				*lp, *(lp + 3), cmd->retries,
> -				scsi_get_resid(cmd));
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
> +				 "0710 Iodone <%d/%d> cmd %p, error "
> +				 "x%x SNS x%x x%x Data: x%x x%x\n",
> +				 cmd->device->id, cmd->device->lun, cmd,
> +				 cmd->result, *lp, *(lp + 3), cmd->retries,
> +				 scsi_get_resid(cmd));
>  	}
>  
>  	result = cmd->result;
> @@ -675,10 +665,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
>  			depth = sdev->host->cmd_per_lun;
>  
>  		if (depth) {
> -			lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
> -					"%d (%d):0711 detected queue full - "
> -					"lun queue depth  adjusted to %d.\n",
> -					phba->brd_no, vpi, depth);
> +			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
> +					 "0711 detected queue full - lun queue "
> +					 "depth adjusted to %d.\n", depth);
>  		}
>  	}
>  
> @@ -848,12 +837,9 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
>  		return FAILED;
>  
>  	/* Issue Target Reset to TGT <num> */
> -	lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
> -			"%d (%d):0702 Issue Target Reset to TGT %d "
> -			"Data: x%x x%x\n",
> -			phba->brd_no, vport->vpi, tgt_id,
> -			rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
> +			 "0702 Issue Target Reset to TGT %d Data: x%x x%x\n",
> +			 tgt_id, rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
>  	ret = lpfc_sli_issue_iocb_wait(phba,
>  				       &phba->sli.ring[phba->sli.fcp_ring],
>  				       iocbq, iocbqrsp, lpfc_cmd->timeout);
> @@ -960,10 +946,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
>  	if (lpfc_cmd == NULL) {
>  		lpfc_adjust_queue_depth(phba);
>  
> -		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
> -				"%d (%d):0707 driver's buffer pool is empty, "
> -				"IO busied\n",
> -				phba->brd_no, vport->vpi);
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
> +				 "0707 driver's buffer pool is empty, "
> +				 "IO busied\n");
>  		goto out_host_busy;
>  	}
>  
> @@ -1104,22 +1089,19 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
>  
>  	if (lpfc_cmd->pCmd == cmnd) {
>  		ret = FAILED;
> -		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -				"%d (%d):0748 abort handler timed out waiting "
> -				"for abort to complete: ret %#x, ID %d, "
> -				"LUN %d, snum %#lx\n",
> -				phba->brd_no, vport->vpi, ret,
> -				cmnd->device->id, cmnd->device->lun,
> -				cmnd->serial_number);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +				 "0748 abort handler timed out waiting "
> +				 "for abort to complete: ret %#x, ID %d, "
> +				 "LUN %d, snum %#lx\n",
> +				 ret, cmnd->device->id, cmnd->device->lun,
> +				 cmnd->serial_number);
>  	}
>  
>   out:
> -	lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
> -			"%d (%d):0749 SCSI Layer I/O Abort Request "
> -			"Status x%x ID %d LUN %d snum %#lx\n",
> -			phba->brd_no, vport->vpi, ret, cmnd->device->id,
> -			cmnd->device->lun, cmnd->serial_number);
> -
> +	lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
> +			 "0749 SCSI Layer I/O Abort Request Status x%x ID %d "
> +			 "LUN %d snum %#lx\n", ret, cmnd->device->id,
> +			 cmnd->device->lun, cmnd->serial_number);
>  	return ret;
>  }
>  
> @@ -1154,11 +1136,10 @@ lpfc_device_reset_handler(struct scsi_cm
>  			rdata = cmnd->device->hostdata;
>  			if (!rdata ||
>  				(loopcnt > ((vport->cfg_devloss_tmo * 2) + 1))){
> -				lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -						"%d (%d):0721 LUN Reset rport "
> -						"failure: cnt x%x rdata x%p\n",
> -						phba->brd_no, vport->vpi,
> -						loopcnt, rdata);
> +				lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +						 "0721 LUN Reset rport "
> +						 "failure: cnt x%x rdata x%p\n",
> +						 loopcnt, rdata);
>  				goto out;
>  			}
>  			pnode = rdata->pnode;
> @@ -1188,12 +1169,10 @@ lpfc_device_reset_handler(struct scsi_cm
>  	if (iocbqrsp == NULL)
>  		goto out_free_scsi_buf;
>  
> -	lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
> -			"%d (%d):0703 Issue target reset to TGT %d LUN %d "
> -			"rpi x%x nlp_flag x%x\n",
> -			phba->brd_no, vport->vpi, cmnd->device->id,
> -			cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
> -
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
> +			 "0703 Issue target reset to TGT %d LUN %d "
> +			 "rpi x%x nlp_flag x%x\n", cmnd->device->id,
> +			 cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
>  	iocb_status = lpfc_sli_issue_iocb_wait(phba,
>  				       &phba->sli.ring[phba->sli.fcp_ring],
>  				       iocbq, iocbqrsp, lpfc_cmd->timeout);
> @@ -1239,10 +1218,9 @@ lpfc_device_reset_handler(struct scsi_cm
>  	}
>  
>  	if (cnt) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -				"%d (%d):0719 device reset I/O flush failure: "
> -				"cnt x%x\n",
> -				phba->brd_no, vport->vpi, cnt);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +				 "0719 device reset I/O flush failure: "
> +				 "cnt x%x\n", cnt);
>  		ret = FAILED;
>  	}
>  
> @@ -1250,12 +1228,11 @@ out_free_scsi_buf:
>  	if (iocb_status != IOCB_TIMEDOUT) {
>  		lpfc_release_scsi_buf(phba, lpfc_cmd);
>  	}
> -	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -			"%d (%d):0713 SCSI layer issued device reset (%d, %d) "
> -			"return x%x status x%x result x%x\n",
> -			phba->brd_no, vport->vpi, cmnd->device->id,
> -			cmnd->device->lun, ret, cmd_status, cmd_result);
> -
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +			 "0713 SCSI layer issued device reset (%d, %d) "
> +			 "return x%x status x%x result x%x\n",
> +			 cmnd->device->id, cmnd->device->lun, ret,
> +			 cmd_status, cmd_result);
>  out:
>  	return ret;
>  }
> @@ -1306,10 +1283,9 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
>  					  cmnd->device->lun,
>  					  ndlp->rport->dd_data);
>  		if (ret != SUCCESS) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -					"%d (%d):0700 Bus Reset on target %d "
> -					"failed\n",
> -					phba->brd_no, vport->vpi, i);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +					 "0700 Bus Reset on target %d failed\n",
> +					 i);
>  			err_count++;
>  			break;
>  		}
> @@ -1347,16 +1323,14 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
>  	}
>  
>  	if (cnt) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -				"%d (%d):0715 Bus Reset I/O flush failure: "
> -				"cnt x%x left x%x\n",
> -				phba->brd_no, vport->vpi, cnt, i);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +				 "0715 Bus Reset I/O flush failure: "
> +				 "cnt x%x left x%x\n", cnt, i);
>  		ret = FAILED;
>  	}
>  
> -	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -			"%d (%d):0714 SCSI layer issued Bus Reset Data: x%x\n",
> -			phba->brd_no, vport->vpi, ret);
> +	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +			 "0714 SCSI layer issued Bus Reset Data: x%x\n", ret);
>  out:
>  	return ret;
>  }
> @@ -1389,32 +1363,28 @@ lpfc_slave_alloc(struct scsi_device *sde
>  
>  	/* Allow some exchanges to be available always to complete discovery */
>  	if (total >= phba->cfg_hba_queue_depth - LPFC_DISC_IOCB_BUFF_COUNT ) {
> -		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
> -				"%d (%d):0704 At limitation of %d "
> -				"preallocated command buffers\n",
> -				phba->brd_no, vport->vpi, total);
> +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
> +				 "0704 At limitation of %d preallocated "
> +				 "command buffers\n", total);
>  		return 0;
> -
>  	/* Allow some exchanges to be available always to complete discovery */
>  	} else if (total + num_to_alloc >
>  		phba->cfg_hba_queue_depth - LPFC_DISC_IOCB_BUFF_COUNT ) {
> -		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
> -				"%d (%d):0705 Allocation request of %d "
> -				"command buffers will exceed max of %d.  "
> -				"Reducing allocation request to %d.\n",
> -				phba->brd_no, vport->vpi, num_to_alloc,
> -				phba->cfg_hba_queue_depth,
> -				(phba->cfg_hba_queue_depth - total));
> +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
> +				 "0705 Allocation request of %d "
> +				 "command buffers will exceed max of %d.  "
> +				 "Reducing allocation request to %d.\n",
> +				 num_to_alloc, phba->cfg_hba_queue_depth,
> +				 (phba->cfg_hba_queue_depth - total));
>  		num_to_alloc = phba->cfg_hba_queue_depth - total;
>  	}
>  
>  	for (i = 0; i < num_to_alloc; i++) {
>  		scsi_buf = lpfc_new_scsi_buf(vport);
>  		if (!scsi_buf) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -					"%d (%d):0706 Failed to allocate "
> -					"command buffer\n",
> -					phba->brd_no, vport->vpi);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +					 "0706 Failed to allocate "
> +					 "command buffer\n");
>  			break;
>  		}
>  
> diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> --- a/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 09:26:42.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 09:29:52.000000000 -0400
> @@ -49,9 +49,8 @@
>  			lpfc_printf_log(phba, \
>  				KERN_INFO, \
>  				LOG_MBOX | LOG_SLI, \
> -				"%d (%d):0311 Mailbox command x%x cannot " \
> +				"(%d):0311 Mailbox command x%x cannot " \
>  				"issue Data: x%x x%x x%x\n", \
> -				phba->brd_no, \
>  				pmbox->vport ? pmbox->vport->vpi : 0, \
>  				pmbox->mb.mbxCommand,		\
>  				phba->pport->port_state,	\
> @@ -231,13 +230,11 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
>  		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
>  		if (rc != MBX_SUCCESS) {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -					"%d:0446 Adapter failed to init (%d), "
> +					"0446 Adapter failed to init (%d), "
>  					"mbxCmd x%x CFG_RING, mbxStatus x%x, "
>  					"ring %d\n",
> -					phba->brd_no, rc,
> -					pmbox->mbxCommand,
> -					pmbox->mbxStatus,
> -					i);
> +					rc, pmbox->mbxCommand,
> +					pmbox->mbxStatus, i);
>  			phba->link_state = LPFC_HBA_ERROR;
>  			ret = -ENXIO;
>  			break;
> @@ -296,9 +293,9 @@ lpfc_sli_next_iocb_slot (struct lpfc_hba
>  
>  		if (unlikely(pring->local_getidx >= max_cmd_idx)) {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -					"%d:0315 Ring %d issue: portCmdGet %d "
> +					"0315 Ring %d issue: portCmdGet %d "
>  					"is bigger then cmd ring %d\n",
> -					phba->brd_no, pring->ringno,
> +					pring->ringno,
>  					pring->local_getidx, max_cmd_idx);
>  
>  			phba->link_state = LPFC_HBA_ERROR;
> @@ -380,8 +377,8 @@ lpfc_sli_next_iotag(struct lpfc_hba *phb
>  		spin_unlock_irq(&phba->hbalock);
>  
>  	lpfc_printf_log(phba, KERN_ERR,LOG_SLI,
> -			"%d:0318 Failed to allocate IOTAG.last IOTAG is %d\n",
> -			phba->brd_no, psli->last_iotag);
> +			"0318 Failed to allocate IOTAG.last IOTAG is %d\n",
> +			psli->last_iotag);
>  
>  	return 0;
>  }
> @@ -535,10 +532,9 @@ lpfc_sli_next_hbq_slot(struct lpfc_hba *
>  		if (unlikely(hbqp->local_hbqGetIdx >= hbqp->entry_count)) {
>  			lpfc_printf_log(phba, KERN_ERR,
>  					LOG_SLI | LOG_VPORT,
> -					"%d:1802 HBQ %d: local_hbqGetIdx "
> +					"1802 HBQ %d: local_hbqGetIdx "
>  					"%u is > than hbqp->entry_count %u\n",
> -					phba->brd_no, hbqno,
> -					hbqp->local_hbqGetIdx,
> +					hbqno, hbqp->local_hbqGetIdx,
>  					hbqp->entry_count);
>  
>  			phba->link_state = LPFC_HBA_ERROR;
> @@ -666,9 +662,8 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *ph
>  		}
>  	}
>  	lpfc_printf_log(phba, KERN_ERR, LOG_SLI | LOG_VPORT,
> -			"%d:1803 Bad hbq tag. Data: x%x x%x\n",
> -			phba->brd_no, tag,
> -			lpfc_hbq_defs[tag >> 16]->buffer_count);
> +			"1803 Bad hbq tag. Data: x%x x%x\n",
> +			tag, lpfc_hbq_defs[tag >> 16]->buffer_count);
>  	return NULL;
>  }
>  
> @@ -845,12 +840,10 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
>  		 */
>  		if (lpfc_sli_chk_mbx_command(pmbox->mbxCommand) ==
>  		    MBX_SHUTDOWN) {
> -
>  			/* Unknow mailbox command compl */
>  			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
> -					"%d (%d):0323 Unknown Mailbox command "
> +					"(%d):0323 Unknown Mailbox command "
>  					"%x Cmpl\n",
> -					phba->brd_no,
>  					pmb->vport ? pmb->vport->vpi : 0,
>  					pmbox->mbxCommand);
>  			phba->link_state = LPFC_HBA_ERROR;
> @@ -865,10 +858,9 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
>  				/* Mbox cmd cmpl error - RETRYing */
>  				lpfc_printf_log(phba, KERN_INFO,
>  						LOG_MBOX | LOG_SLI,
> -						"%d (%d):0305 Mbox cmd cmpl "
> +						"(%d):0305 Mbox cmd cmpl "
>  						"error - RETRYing Data: x%x "
>  						"x%x x%x x%x\n",
> -						phba->brd_no,
>  						pmb->vport ? pmb->vport->vpi :0,
>  						pmbox->mbxCommand,
>  						pmbox->mbxStatus,
> @@ -887,9 +879,8 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
>  
>  		/* Mailbox cmd <cmd> Cmpl <cmpl> */
>  		lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
> -				"%d (%d):0307 Mailbox cmd x%x Cmpl x%p "
> +				"(%d):0307 Mailbox cmd x%x Cmpl x%p "
>  				"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x\n",
> -				phba->brd_no,
>  				pmb->vport ? pmb->vport->vpi : 0,
>  				pmbox->mbxCommand,
>  				pmb->mbox_cmpl,
> @@ -1004,12 +995,9 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
>  		/* Ring <ringno> handler: unexpected
>  		   Rctl <Rctl> Type <Type> received */
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
> -				"%d:0313 Ring %d handler: unexpected Rctl x%x "
> +				"0313 Ring %d handler: unexpected Rctl x%x "
>  				"Type x%x received\n",
> -				phba->brd_no,
> -				pring->ringno,
> -				Rctl,
> -				Type);
> +				pring->ringno, Rctl, Type);
>  	}
>  	return 1;
>  }
> @@ -1032,10 +1020,9 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *p
>  	}
>  
>  	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -			"%d:0317 iotag x%x is out off "
> +			"0317 iotag x%x is out off "
>  			"range: max iotag x%x wd0 x%x\n",
> -			phba->brd_no, iotag,
> -			phba->sli.last_iotag,
> +			iotag, phba->sli.last_iotag,
>  			*(((uint32_t *) &prspiocb->iocb) + 7));
>  	return NULL;
>  }
> @@ -1083,18 +1070,16 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
>  			 * Ring <ringno> handler: unexpected completion IoTag
>  			 * <IoTag>
>  			 */
> -			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
> -					"%d (%d):0322 Ring %d handler: "
> -					"unexpected completion IoTag x%x "
> -					"Data: x%x x%x x%x x%x\n",
> -					phba->brd_no,
> -					cmdiocbp->vport->vpi,
> -					pring->ringno,
> -					saveq->iocb.ulpIoTag,
> -					saveq->iocb.ulpStatus,
> -					saveq->iocb.un.ulpWord[4],
> -					saveq->iocb.ulpCommand,
> -					saveq->iocb.ulpContext);
> +			lpfc_printf_vlog(cmdiocbp->vport, KERN_WARNING, LOG_SLI,
> +					 "0322 Ring %d handler: "
> +					 "unexpected completion IoTag x%x "
> +					 "Data: x%x x%x x%x x%x\n",
> +					 pring->ringno,
> +					 saveq->iocb.ulpIoTag,
> +					 saveq->iocb.ulpStatus,
> +					 saveq->iocb.un.ulpWord[4],
> +					 saveq->iocb.ulpCommand,
> +					 saveq->iocb.ulpContext);
>  		}
>  	}
>  
> @@ -1112,10 +1097,9 @@ lpfc_sli_rsp_pointers_error(struct lpfc_
>  	 * rsp ring <portRspMax>
>  	 */
>  	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -			"%d:0312 Ring %d handler: portRspPut %d "
> +			"0312 Ring %d handler: portRspPut %d "
>  			"is bigger then rsp ring %d\n",
> -			phba->brd_no, pring->ringno,
> -			le32_to_cpu(pgp->rspPutInx),
> +			pring->ringno, le32_to_cpu(pgp->rspPutInx),
>  			pring->numRiocb);
>  
>  	phba->link_state = LPFC_HBA_ERROR;
> @@ -1185,9 +1169,9 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
>  		if (unlikely(irsp->ulpStatus)) {
>  			/* Rsp ring <ringno> error: IOCB */
>  			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
> -					"%d:0326 Rsp Ring %d error: IOCB Data: "
> +					"0326 Rsp Ring %d error: IOCB Data: "
>  					"x%x x%x x%x x%x x%x x%x x%x x%x\n",
> -					phba->brd_no, pring->ringno,
> +					pring->ringno,
>  					irsp->un.ulpWord[0],
>  					irsp->un.ulpWord[1],
>  					irsp->un.ulpWord[2],
> @@ -1207,9 +1191,9 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
>  			 */
>  			if (unlikely(irsp->ulpCommand == CMD_XRI_ABORTED_CX)) {
>  				lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -						"%d:0314 IOCB cmd 0x%x"
> -						" processed. Skipping"
> -						" completion", phba->brd_no,
> +						"0314 IOCB cmd 0x%x "
> +						"processed. Skipping "
> +						"completion",
>  						irsp->ulpCommand);
>  				break;
>  			}
> @@ -1234,10 +1218,9 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
>  			} else {
>  				/* Unknown IOCB command */
>  				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -						"%d:0321 Unknown IOCB command "
> +						"0321 Unknown IOCB command "
>  						"Data: x%x, x%x x%x x%x x%x\n",
> -						phba->brd_no, type,
> -						irsp->ulpCommand,
> +						type, irsp->ulpCommand,
>  						irsp->ulpStatus,
>  						irsp->ulpIoTag,
>  						irsp->ulpContext);
> @@ -1361,9 +1344,9 @@ lpfc_sli_handle_fast_ring_event(struct l
>  
>  			/* Rsp ring <ringno> error: IOCB */
>  			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
> -					"%d:0336 Rsp Ring %d error: IOCB Data: "
> +					"0336 Rsp Ring %d error: IOCB Data: "
>  					"x%x x%x x%x x%x x%x x%x x%x x%x\n",
> -					phba->brd_no, pring->ringno,
> +					pring->ringno,
>  					irsp->un.ulpWord[0],
>  					irsp->un.ulpWord[1],
>  					irsp->un.ulpWord[2],
> @@ -1383,10 +1366,9 @@ lpfc_sli_handle_fast_ring_event(struct l
>  			 */
>  			if (unlikely(irsp->ulpCommand == CMD_XRI_ABORTED_CX)) {
>  				lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -						"%d:0333 IOCB cmd 0x%x"
> +						"0333 IOCB cmd 0x%x"
>  						" processed. Skipping"
>  						" completion\n",
> -						phba->brd_no,
>  						irsp->ulpCommand);
>  				break;
>  			}
> @@ -1423,10 +1405,9 @@ lpfc_sli_handle_fast_ring_event(struct l
>  			} else {
>  				/* Unknown IOCB command */
>  				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -						"%d:0334 Unknown IOCB command "
> +						"0334 Unknown IOCB command "
>  						"Data: x%x, x%x x%x x%x x%x\n",
> -						phba->brd_no, type,
> -						irsp->ulpCommand,
> +						type, irsp->ulpCommand,
>  						irsp->ulpStatus,
>  						irsp->ulpIoTag,
>  						irsp->ulpContext);
> @@ -1504,10 +1485,9 @@ lpfc_sli_handle_slow_ring_event(struct l
>  		 * rsp ring <portRspMax>
>  		 */
>  		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -				"%d:0303 Ring %d handler: portRspPut %d "
> +				"0303 Ring %d handler: portRspPut %d "
>  				"is bigger then rsp ring %d\n",
> -				phba->brd_no, pring->ringno, portRspPut,
> -				portRspMax);
> +				pring->ringno, portRspPut, portRspMax);
>  
>  		phba->link_state = LPFC_HBA_ERROR;
>  		spin_unlock_irqrestore(&phba->hbalock, iflag);
> @@ -1596,13 +1576,12 @@ lpfc_sli_handle_slow_ring_event(struct l
>  			if (irsp->ulpStatus) {
>  				/* Rsp ring <ringno> error: IOCB */
>  				lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
> -						"%d:0328 Rsp Ring %d error: "
> +						"0328 Rsp Ring %d error: "
>  						"IOCB Data: "
>  						"x%x x%x x%x x%x "
>  						"x%x x%x x%x x%x "
>  						"x%x x%x x%x x%x "
>  						"x%x x%x x%x x%x\n",
> -						phba->brd_no,
>  						pring->ringno,
>  						irsp->un.ulpWord[0],
>  						irsp->un.ulpWord[1],
> @@ -1677,10 +1656,9 @@ lpfc_sli_handle_slow_ring_event(struct l
>  				} else {
>  					/* Unknown IOCB command */
>  					lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -							"%d:0335 Unknown IOCB "
> +							"0335 Unknown IOCB "
>  							"command Data: x%x "
>  							"x%x x%x x%x\n",
> -							phba->brd_no,
>  							irsp->ulpCommand,
>  							irsp->ulpStatus,
>  							irsp->ulpIoTag,
> @@ -1908,8 +1886,8 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
>  
>  	/* Kill HBA */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -			"%d:0329 Kill HBA Data: x%x x%x\n",
> -			phba->brd_no, phba->pport->port_state, psli->sli_flag);
> +			"0329 Kill HBA Data: x%x x%x\n",
> +			phba->pport->port_state, psli->sli_flag);
>  
>  	if ((pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
>  						  GFP_KERNEL)) == 0)
> @@ -1982,7 +1960,7 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
>  
>  	/* Reset HBA */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -			"%d:0325 Reset HBA Data: x%x x%x\n", phba->brd_no,
> +			"0325 Reset HBA Data: x%x x%x\n",
>  			phba->pport->port_state, psli->sli_flag);
>  
>  	/* perform board reset */
> @@ -2037,7 +2015,7 @@ lpfc_sli_brdrestart(struct lpfc_hba *phb
>  
>  	/* Restart HBA */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -			"%d:0337 Restart HBA Data: x%x x%x\n", phba->brd_no,
> +			"0337 Restart HBA Data: x%x x%x\n",
>  			phba->pport->port_state, psli->sli_flag);
>  
>  	word0 = 0;
> @@ -2102,9 +2080,8 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
>  			/* Adapter failed to init, timeout, status reg
>  			   <status> */
>  			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -					"%d:0436 Adapter failed to init, "
> -					"timeout, status reg x%x\n",
> -					phba->brd_no, status);
> +					"0436 Adapter failed to init, "
> +					"timeout, status reg x%x\n", status);
>  			phba->link_state = LPFC_HBA_ERROR;
>  			return -ETIMEDOUT;
>  		}
> @@ -2115,10 +2092,8 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
>  			/* Adapter failed to init, chipset, status reg
>  			   <status> */
>  			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -					"%d:0437 Adapter failed to init, "
> -					"chipset, status reg x%x\n",
> -					phba->brd_no,
> -					status);
> +					"0437 Adapter failed to init, "
> +					"chipset, status reg x%x\n", status);
>  			phba->link_state = LPFC_HBA_ERROR;
>  			return -EIO;
>  		}
> @@ -2145,10 +2120,8 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
>  		/* ERROR: During chipset initialization */
>  		/* Adapter failed to init, chipset, status reg <status> */
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0438 Adapter failed to init, chipset, "
> -				"status reg x%x\n",
> -				phba->brd_no,
> -				status);
> +				"0438 Adapter failed to init, chipset, "
> +				"status reg x%x\n", status);
>  		phba->link_state = LPFC_HBA_ERROR;
>  		return -EIO;
>  	}
> @@ -2226,9 +2199,9 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
>  
>  			lpfc_printf_log(phba, KERN_ERR,
>  					LOG_SLI | LOG_VPORT,
> -					"%d:1805 Adapter failed to init. "
> +					"1805 Adapter failed to init. "
>  					"Data: x%x x%x x%x\n",
> -					phba->brd_no, pmbox->mbxCommand,
> +					pmbox->mbxCommand,
>  					pmbox->mbxStatus, hbqno);
>  
>  			phba->link_state = LPFC_HBA_ERROR;
> @@ -2295,10 +2268,9 @@ lpfc_do_config_port(struct lpfc_hba *phb
>  		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
>  		if (rc != MBX_SUCCESS) {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0442 Adapter failed to init, mbxCmd x%x "
> +				"0442 Adapter failed to init, mbxCmd x%x "
>  				"CONFIG_PORT, mbxStatus x%x Data: x%x\n",
> -				phba->brd_no, pmb->mb.mbxCommand,
> -				pmb->mb.mbxStatus, 0);
> +				pmb->mb.mbxCommand, pmb->mb.mbxStatus, 0);
>  			spin_lock_irq(&phba->hbalock);
>  			phba->sli.sli_flag &= ~LPFC_SLI2_ACTIVE;
>  			spin_unlock_irq(&phba->hbalock);
> @@ -2339,9 +2311,9 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
>  	case 2:
>  		if (phba->cfg_npiv_enable) {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
> -				"%d:1824 NPIV enabled: Override lpfc_sli_mode "
> +				"1824 NPIV enabled: Override lpfc_sli_mode "
>  				"parameter (%d) to auto (0).\n",
> -				phba->brd_no, lpfc_sli_mode);
> +				lpfc_sli_mode);
>  			break;
>  		}
>  		mode = 2;
> @@ -2351,9 +2323,8 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
>  		break;
>  	default:
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
> -				"%d:1819 Unrecognized lpfc_sli_mode "
> -				"parameter: %d.\n",
> -				phba->brd_no, lpfc_sli_mode);
> +				"1819 Unrecognized lpfc_sli_mode "
> +				"parameter: %d.\n", lpfc_sli_mode);
>  
>  		break;
>  	}
> @@ -2361,9 +2332,8 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
>  	rc = lpfc_do_config_port(phba, mode);
>  	if (rc && lpfc_sli_mode == 3)
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
> -				"%d:1820 Unable to select SLI-3.  "
> -				"Not supported by adapter.\n",
> -				phba->brd_no);
> +				"1820 Unable to select SLI-3.  "
> +				"Not supported by adapter.\n");
>  	if (rc && mode != 2)
>  		rc = lpfc_do_config_port(phba, 2);
>  	if (rc)
> @@ -2382,8 +2352,8 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
>  	}
>  
>  	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -			"%d:0444 Firmware in SLI %x mode. Max_vpi %d\n",
> -			phba->brd_no, phba->sli_rev, phba->max_vpi);
> +			"0444 Firmware in SLI %x mode. Max_vpi %d\n",
> +			phba->sli_rev, phba->max_vpi);
>  	rc = lpfc_sli_ring_map(phba);
>  
>  	if (rc)
> @@ -2408,8 +2378,7 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
>  lpfc_sli_hba_setup_error:
>  	phba->link_state = LPFC_HBA_ERROR;
>  	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -			"%d:0445 Firmware initialization failed\n",
> -			phba->brd_no);
> +			"0445 Firmware initialization failed\n");
>  	return rc;
>  }
>  
> @@ -2461,9 +2430,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
>  
>  	/* Mbox cmd <mbxCommand> timeout */
>  	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
> -			"%d:0310 Mailbox command x%x timeout Data: x%x x%x "
> -			"x%p\n",
> -			phba->brd_no,
> +			"0310 Mailbox command x%x timeout Data: x%x x%x x%p\n",
>  			mb->mbxCommand,
>  			phba->pport->port_state,
>  			phba->sli.sli_flag,
> @@ -2486,8 +2453,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
>  	lpfc_sli_abort_iocb_ring(phba, pring);
>  
>  	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
> -			"%d:0316 Resetting board due to mailbox timeout\n",
> -			phba->brd_no);
> +			"0316 Resetting board due to mailbox timeout\n");
>  	/*
>  	 * lpfc_offline calls lpfc_sli_hba_down which will clean up
>  	 * on oustanding mailbox commands.
> @@ -2518,8 +2484,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
>  		if(!pmbox->vport) {
>  			lpfc_printf_log(phba, KERN_ERR,
>  					LOG_MBOX | LOG_VPORT,
> -					"%d:1806 Mbox x%x failed. No vport\n",
> -					phba->brd_no,
> +					"1806 Mbox x%x failed. No vport\n",
>  					pmbox->mb.mbxCommand);
>  			dump_stack();
>  			return MBXERR_ERROR;
> @@ -2596,9 +2561,8 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
>  
>  		/* Mbox cmd issue - BUSY */
>  		lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
> -				"%d (%d):0308 Mbox cmd issue - BUSY Data: "
> +				"(%d):0308 Mbox cmd issue - BUSY Data: "
>  				"x%x x%x x%x x%x\n",
> -				phba->brd_no,
>  				pmbox->vport ? pmbox->vport->vpi : 0xffffff,
>  				mb->mbxCommand, phba->pport->port_state,
>  				psli->sli_flag, flag);
> @@ -2660,9 +2624,9 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
>  
>  	/* Mailbox cmd <cmd> issue */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
> -			"%d (%d):0309 Mailbox cmd x%x issue Data: x%x x%x "
> +			"(%d):0309 Mailbox cmd x%x issue Data: x%x x%x "
>  			"x%x\n",
> -			phba->brd_no, pmbox->vport ? pmbox->vport->vpi : 0,
> +			pmbox->vport ? pmbox->vport->vpi : 0,
>  			mb->mbxCommand, phba->pport->port_state,
>  			psli->sli_flag, flag);
>  
> @@ -2864,8 +2828,7 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *p
>  	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN)) {
>  		lpfc_printf_log(phba, KERN_ERR,
>  				LOG_SLI | LOG_VPORT,
> -				"%d:1807 IOCB x%x failed. No vport\n",
> -				phba->brd_no,
> +				"1807 IOCB x%x failed. No vport\n",
>  				piocb->iocb.ulpCommand);
>  		dump_stack();
>  		return IOCB_ERROR;
> @@ -3096,11 +3059,10 @@ lpfc_sli_setup(struct lpfc_hba *phba)
>  	}
>  	if (totiocbsize > MAX_SLIM_IOCB_SIZE) {
>  		/* Too many cmd / rsp ring entries in SLI2 SLIM */
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"%d:0462 Too many cmd / rsp ring entries in "
> -				"SLI2 SLIM Data: x%x x%lx\n",
> -				phba->brd_no, totiocbsize,
> -				(unsigned long) MAX_SLIM_IOCB_SIZE);
> +		printk(KERN_ERR "%d:0462 Too many cmd / rsp ring entries in "
> +		       "SLI2 SLIM Data: x%x x%lx\n",
> +		       phba->brd_no, totiocbsize,
> +		       (unsigned long) MAX_SLIM_IOCB_SIZE);
>  	}
>  	if (phba->cfg_multi_ring_support == 2)
>  		lpfc_extra_ring_setup(phba);
> @@ -3321,9 +3283,9 @@ lpfc_sli_ringpostbuf_get(struct lpfc_hba
>  
>  	spin_unlock_irq(&phba->hbalock);
>  	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"%d:0410 Cannot find virtual addr for mapped buf on "
> +			"0410 Cannot find virtual addr for mapped buf on "
>  			"ring %d Data x%llx x%p x%p x%x\n",
> -			phba->brd_no, pring->ringno, (unsigned long long)phys,
> +			pring->ringno, (unsigned long long)phys,
>  			slp->next, slp->prev, pring->postbufq_cnt);
>  	return NULL;
>  }
> @@ -3348,12 +3310,11 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
>  			abort_iocb = phba->sli.iocbq_lookup[abort_iotag];
>  
>  		lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_SLI,
> -				"%d:0327 Cannot abort els iocb %p "
> +				"0327 Cannot abort els iocb %p "
>  				"with tag %x context %x, abort status %x, "
>  				"abort code %x\n",
> -				phba->brd_no, abort_iocb, abort_iotag,
> -				abort_context, irsp->ulpStatus,
> -				irsp->un.ulpWord[4]);
> +				abort_iocb, abort_iotag, abort_context,
> +				irsp->ulpStatus, irsp->un.ulpWord[4]);
>  
>  		/*
>  		 * make sure we have the right iocbq before taking it
> @@ -3387,9 +3348,9 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *ph
>  
>  	/* ELS cmd tag <ulpIoTag> completes */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -			"%d (X):0133 Ignoring ELS cmd tag x%x completion Data: "
> +			"0133 Ignoring ELS cmd tag x%x completion Data: "
>  			"x%x x%x x%x\n",
> -			phba->brd_no, irsp->ulpIoTag, irsp->ulpStatus,
> +			irsp->ulpIoTag, irsp->ulpStatus,
>  			irsp->un.ulpWord[4], irsp->ulpTimeout);
>  	if (cmdiocb->iocb.ulpCommand == CMD_GEN_REQUEST64_CR)
>  		lpfc_ct_free_iocb(phba, cmdiocb);
> @@ -3455,12 +3416,11 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
>  
>  	abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
>  
> -	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -			"%d (%d):0339 Abort xri x%x, original iotag x%x, "
> -			"abort cmd iotag x%x\n",
> -			phba->brd_no, vport->vpi,
> -			iabt->un.acxri.abortContextTag,
> -			iabt->un.acxri.abortIoTag, abtsiocbp->iotag);
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
> +			 "0339 Abort xri x%x, original iotag x%x, "
> +			 "abort cmd iotag x%x\n",
> +			 iabt->un.acxri.abortContextTag,
> +			 iabt->un.acxri.abortIoTag, abtsiocbp->iotag);
>  	retval = __lpfc_sli_issue_iocb(phba, pring, abtsiocbp, 0);
>  
>  abort_iotag_exit:
> @@ -3663,25 +3623,23 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
>  
>  		if (piocb->iocb_flag & LPFC_IO_WAKE) {
>  			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -					"%d:0331 IOCB wake signaled\n",
> -					phba->brd_no);
> +					"0331 IOCB wake signaled\n");
>  		} else if (timeleft == 0) {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -					"%d:0338 IOCB wait timeout error - no "
> -					"wake response Data x%x\n",
> -					phba->brd_no, timeout);
> +					"0338 IOCB wait timeout error - no "
> +					"wake response Data x%x\n", timeout);
>  			retval = IOCB_TIMEDOUT;
>  		} else {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -					"%d:0330 IOCB wake NOT set, "
> -					"Data x%x x%lx\n", phba->brd_no,
> +					"0330 IOCB wake NOT set, "
> +					"Data x%x x%lx\n",
>  					timeout, (timeleft / jiffies));
>  			retval = IOCB_TIMEDOUT;
>  		}
>  	} else {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
> -				"%d:0332 IOCB wait issue failed, Data x%x\n",
> -				phba->brd_no, retval);
> +				":0332 IOCB wait issue failed, Data x%x\n",
> +				retval);
>  		retval = IOCB_ERROR;
>  	}
>  
> @@ -3932,12 +3890,10 @@ lpfc_intr_handler(int irq, void *dev_id)
>  				 */
>  				lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX |
>  						LOG_SLI,
> -						"%d (%d):0304 Stray Mailbox "
> +						"(%d):0304 Stray Mailbox "
>  						"Interrupt mbxCommand x%x "
>  						"mbxStatus x%x\n",
> -						phba->brd_no,
> -						(vport
> -						 ? vport->vpi : 0),
> +						(vport ? vport->vpi : 0),
>  						pmbox->mbxCommand,
>  						pmbox->mbxStatus);
>  			}
> diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
> --- a/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 09:27:04.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 09:29:52.000000000 -0400
> @@ -125,11 +125,10 @@ lpfc_vport_sparm(struct lpfc_hba *phba, 
>  	pmb->vport = vport;
>  	rc = lpfc_sli_issue_mbox_wait(phba, pmb, phba->fc_ratov * 2);
>  	if (rc != MBX_SUCCESS) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
> -				"%d (%d):1818 VPort failed init, mbxCmd x%x "
> -				"READ_SPARM mbxStatus x%x, rc = x%x\n",
> -				phba->brd_no, vport->vpi,
> -				mb->mbxCommand, mb->mbxStatus, rc);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT | LOG_VPORT,
> +				 "1818 VPort failed init, mbxCmd x%x "
> +				 "READ_SPARM mbxStatus x%x, rc = x%x\n",
> +				 mb->mbxCommand, mb->mbxStatus, rc);
>  		lpfc_mbuf_free(phba, mp->virt, mp->phys);
>  		kfree(mp);
>  		if (rc != MBX_TIMEOUT)
> @@ -162,9 +161,9 @@ lpfc_valid_wwn_format(struct lpfc_hba *p
>  		return 1;
>  
>  	lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -			"%d:1822 Invalid %s: %02x:%02x:%02x:%02x:"
> +			"1822 Invalid %s: %02x:%02x:%02x:%02x:"
>  			"%02x:%02x:%02x:%02x\n",
> -			phba->brd_no, name_type,
> +			name_type,
>  			wwn->u.wwn[0], wwn->u.wwn[1],
>  			wwn->u.wwn[2], wwn->u.wwn[3],
>  			wwn->u.wwn[4], wwn->u.wwn[5],
> @@ -209,9 +208,9 @@ lpfc_vport_create(struct fc_vport *fc_vp
>  	if ((phba->sli_rev < 3) ||
>  		!(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -				"%d:1808 Create VPORT failed: "
> +				"1808 Create VPORT failed: "
>  				"NPIV is not enabled: SLImode:%d\n",
> -				phba->brd_no, phba->sli_rev);
> +				phba->sli_rev);
>  		rc = VPORT_INVAL;
>  		goto error_out;
>  	}
> @@ -219,9 +218,9 @@ lpfc_vport_create(struct fc_vport *fc_vp
>  	vpi = lpfc_alloc_vpi(phba);
>  	if (vpi == 0) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -				"%d:1809 Create VPORT failed: "
> +				"1809 Create VPORT failed: "
>  				"Max VPORTs (%d) exceeded\n",
> -				phba->brd_no, phba->max_vpi);
> +				phba->max_vpi);
>  		rc = VPORT_NORESOURCES;
>  		goto error_out;
>  	}
> @@ -230,8 +229,8 @@ lpfc_vport_create(struct fc_vport *fc_vp
>  	/* Assign an unused board number */
>  	if ((instance = lpfc_get_instance()) < 0) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -				"%d:1810 Create VPORT failed: Cannot get "
> -				"instance number\n", phba->brd_no);
> +				"1810 Create VPORT failed: Cannot get "
> +				"instance number\n");
>  		lpfc_free_vpi(phba, vpi);
>  		rc = VPORT_NORESOURCES;
>  		goto error_out;
> @@ -240,8 +239,7 @@ lpfc_vport_create(struct fc_vport *fc_vp
>  	vport = lpfc_create_port(phba, instance, &fc_vport->dev);
>  	if (!vport) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -				"%d:1811 Create VPORT failed: vpi x%x\n",
> -				phba->brd_no, vpi);
> +				"1811 Create VPORT failed: vpi x%x\n", vpi);
>  		lpfc_free_vpi(phba, vpi);
>  		rc = VPORT_NORESOURCES;
>  		goto error_out;
> @@ -251,10 +249,9 @@ lpfc_vport_create(struct fc_vport *fc_vp
>  	lpfc_debugfs_initialize(vport);
>  
>  	if (lpfc_vport_sparm(phba, vport)) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -				"%d:1813 Create VPORT failed: vpi:%d "
> -				"Cannot get sparam\n",
> -				phba->brd_no, vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
> +				 "1813 Create VPORT failed. "
> +				 "Cannot get sparam\n");
>  		lpfc_free_vpi(phba, vpi);
>  		destroy_port(vport);
>  		rc = VPORT_NORESOURCES;
> @@ -274,10 +271,9 @@ lpfc_vport_create(struct fc_vport *fc_vp
>  
>  	if (!lpfc_valid_wwn_format(phba, &vport->fc_sparam.nodeName, "WWNN") ||
>  	    !lpfc_valid_wwn_format(phba, &vport->fc_sparam.portName, "WWPN")) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -				"%d:1821 Create VPORT failed: vpi:%d "
> -				"Invalid WWN format\n",
> -				phba->brd_no, vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
> +				 "1821 Create VPORT failed. "
> +				 "Invalid WWN format\n");
>  		lpfc_free_vpi(phba, vpi);
>  		destroy_port(vport);
>  		rc = VPORT_INVAL;
> @@ -285,10 +281,9 @@ lpfc_vport_create(struct fc_vport *fc_vp
>  	}
>  
>  	if (!lpfc_unique_wwpn(phba, vport)) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -				"%d:1823 Create VPORT failed: vpi:%d "
> -				"Duplicate WWN on HBA\n",
> -				phba->brd_no, vpi);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
> +				 "1823 Create VPORT failed. "
> +				 "Duplicate WWN on HBA\n");
>  		lpfc_free_vpi(phba, vpi);
>  		destroy_port(vport);
>  		rc = VPORT_INVAL;
> @@ -320,10 +315,8 @@ lpfc_vport_create(struct fc_vport *fc_vp
>  			lpfc_initial_fdisc(vport);
>  		} else {
>  			lpfc_vport_set_state(vport, FC_VPORT_NO_FABRIC_SUPP);
> -			lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -					"%d (%d):0262 No NPIV Fabric "
> -					"support\n",
> -					phba->brd_no, vport->vpi);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +					 "0262 No NPIV Fabric support\n");
>  		}
>  	} else {
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> @@ -409,10 +402,8 @@ enable_vport(struct fc_vport *fc_vport)
>  			lpfc_initial_fdisc(vport);
>  		} else {
>  			lpfc_vport_set_state(vport, FC_VPORT_NO_FABRIC_SUPP);
> -			lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
> -					"%d (%d):0264 No NPIV Fabric "
> -					"support\n",
> -					phba->brd_no, vport->vpi);
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +					 "0264 No NPIV Fabric support\n");
>  		}
>  	} else {
>  		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
> @@ -462,9 +453,9 @@ lpfc_vport_delete(struct fc_vport *fc_vp
>  		return VPORT_INVAL;
>  
>  	if (vport->port_type == LPFC_PHYSICAL_PORT) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
> -				"%d:1812 vport_delete failed: Cannot delete "
> -				"physical host\n", phba->brd_no);
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
> +				 "1812 vport_delete failed: Cannot delete "
> +				 "physical host\n");
>  		goto out;
>  	}
>  
> @@ -544,8 +535,12 @@ lpfc_create_vport_work_array(struct lpfc
>  		return NULL;
>  	spin_lock_irq(&phba->hbalock);
>  	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
> -		if (!scsi_host_get(lpfc_shost_from_vport(port_iterator)))
> +		if (!scsi_host_get(lpfc_shost_from_vport(port_iterator))) {
> +			lpfc_printf_vlog(port_iterator, KERN_ERR, LOG_VPORT,
> +					 "1801 Create vport work array FAILED: "
> +					 "cannot do scsi_host_get\n");
>  			continue;
> +		}
>  		vports[index++] = port_iterator;
>  	}
>  	spin_unlock_irq(&phba->hbalock);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Big NACK

The code was converted to Accessors. look Here:

> -			lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
> -					"%d (%d):0717 FCP command x%x residual "
> -					"underrun converted to error "
> -					"Data: x%x x%x x%x\n",
> -					phba->brd_no, vpi, cmnd->cmnd[0],
> -					scsi_bufflen(cmnd),
> -					scsi_get_resid(cmnd), cmnd->underflow);
> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
> +					 "0717 FCP command x%x residual "
> +					 "underrun converted to error "
> +					 "Data: x%x x%x x%x\n",
> +					 cmnd->cmnd[0], cmnd->request_bufflen,
> +					 scsi_get_resid(cmnd), cmnd->underflow);

you removed an scsi_bufflen(cmnd) and put cmnd->request_bufflen in its place.
the scsi_get_resid(cmnd) you left as is.

Boaz Harrosh
