From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] [SCSI] pm8001 missing break statements
Date: Tue, 27 Sep 2011 12:27:18 +0800
Message-ID: <F03A176CFD18448A82D3AA46B9265D64@usish.com.cn>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE2D8@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE3E2@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:48574 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1I0E1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2011 00:27:19 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE3E2@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@us.xyratex.com>, linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <jbottomley@parallels.com>

Hi Mark,

Thanks for fix.
Acked-by: Jack Wang <jack_wang@usish.com>

: [PATCH] [SCSI] pm8001 missing break statements
> 
> Code Inspection: found two missing break directives. First one will
> result in not retrying an a task that report
> IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY, the second will result in cosmetic
> debug printk conflicting statement stutter. Because checkpatch.pl came
> up with a warning regarding unnecessary space before a newline on one of
> the fragments associated with the diff context, I took the liberty of
> fixing all the cases of this issue in the pair of files touched by this
> defect. These cosmetic changes hide the break changes :-(
> 
> To help focus, break changes are in pm8001_hwi.c fragment line 1649 for
> the IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY case statement and pm8001_sas.c
> line 1000 deals with the conflicting debug print stutter.
> 
> The real patch is enclosed as an attachment since Outlook is my current
> MTA. This code change has not shown any side effect in roughly a year of
> random acts of testing.
> 
> Signed-off-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Jack Wang <jack_wang@usish.com>
> 
>  pm8001_hwi.c |   73
> +++++++++++++++++++++++++++++------------------------------
>  pm8001_sas.c |    7 +++--
>  2 files changed, 41 insertions(+), 39 deletions(-)
> 
> diff -ru scsi-misc-2.6/drivers/scsi/pm8001/pm8001_hwi.c
> scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_hwi.c
> --- scsi-misc-2.6/drivers/scsi/pm8001/pm8001_hwi.c	2011-09-15
> 12:52:02.000000000 -0400
> +++ scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_hwi.c	2011-09-26
> 10:41:45.000000000 -0400
> @@ -567,11 +567,11 @@
>  	value = pm8001_cr32(pm8001_ha, 0, 0x44);
>  	offset = value & 0x03FFFFFF;
>  	PM8001_INIT_DBG(pm8001_ha,
> -		pm8001_printk("Scratchpad 0 Offset: %x \n", offset));
> +		pm8001_printk("Scratchpad 0 Offset: %x\n", offset));
>  	pcilogic = (value & 0xFC000000) >> 26;
>  	pcibar = get_pci_bar_index(pcilogic);
>  	PM8001_INIT_DBG(pm8001_ha,
> -		pm8001_printk("Scratchpad 0 PCI BAR: %d \n", pcibar));
> +		pm8001_printk("Scratchpad 0 PCI BAR: %d\n", pcibar));
>  	pm8001_ha->main_cfg_tbl_addr = base_addr =
>  		pm8001_ha->io_mem[pcibar].memvirtaddr + offset;
>  	pm8001_ha->general_stat_tbl_addr =
> @@ -1245,7 +1245,7 @@
> 
>  	if (mpi_msg_free_get(circularQ, 64, &pMessage) < 0) {
>  		PM8001_IO_DBG(pm8001_ha,
> -			pm8001_printk("No free mpi buffer \n"));
> +			pm8001_printk("No free mpi buffer\n"));
>  		return -1;
>  	}
>  	BUG_ON(!payload);
> @@ -1262,7 +1262,7 @@
>  	pm8001_cw32(pm8001_ha, circularQ->pi_pci_bar,
>  		circularQ->pi_offset, circularQ->producer_idx);
>  	PM8001_IO_DBG(pm8001_ha,
> -		pm8001_printk("after PI= %d CI= %d \n",
> circularQ->producer_idx,
> +		pm8001_printk("after PI= %d CI= %d\n",
> circularQ->producer_idx,
>  		circularQ->consumer_index));
>  	return 0;
>  }
> @@ -1474,7 +1474,7 @@
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS"
> -			",param = %d \n", param));
> +			",param = %d\n", param));
>  		if (param == 0) {
>  			ts->resp = SAS_TASK_COMPLETE;
>  			ts->stat = SAM_STAT_GOOD;
> @@ -1490,14 +1490,14 @@
>  		break;
>  	case IO_ABORTED:
>  		PM8001_IO_DBG(pm8001_ha,
> -			pm8001_printk("IO_ABORTED IOMB Tag \n"));
> +			pm8001_printk("IO_ABORTED IOMB Tag\n"));
>  		ts->resp = SAS_TASK_COMPLETE;
>  		ts->stat = SAS_ABORTED_TASK;
>  		break;
>  	case IO_UNDERFLOW:
>  		/* SSP Completion with error */
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW"
> -			",param = %d \n", param));
> +			",param = %d\n", param));
>  		ts->resp = SAS_TASK_COMPLETE;
>  		ts->stat = SAS_DATA_UNDERRUN;
>  		ts->residual = param;
> @@ -1649,6 +1649,7 @@
>  		ts->resp = SAS_TASK_COMPLETE;
>  		ts->stat = SAS_OPEN_REJECT;
>  		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
> +		break;
>  	default:
>  		PM8001_IO_DBG(pm8001_ha,
>  			pm8001_printk("Unknown status 0x%x\n", status));
> @@ -1937,14 +1938,14 @@
>  				ts->buf_valid_size = sizeof(*resp);
>  			} else
>  				PM8001_IO_DBG(pm8001_ha,
> -					pm8001_printk("response to large
> \n"));
> +					pm8001_printk("response to
> large\n"));
>  		}
>  		if (pm8001_dev)
>  			pm8001_dev->running_req--;
>  		break;
>  	case IO_ABORTED:
>  		PM8001_IO_DBG(pm8001_ha,
> -			pm8001_printk("IO_ABORTED IOMB Tag \n"));
> +			pm8001_printk("IO_ABORTED IOMB Tag\n"));
>  		ts->resp = SAS_TASK_COMPLETE;
>  		ts->stat = SAS_ABORTED_TASK;
>  		if (pm8001_dev)
> @@ -2728,11 +2729,11 @@
>  	u32 phy_op = le32_to_cpu(pPayload->phyop_phyid) & OP_BITS;
>  	if (status != 0) {
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("%x phy execute %x phy op failed!
> \n",
> +			pm8001_printk("%x phy execute %x phy op
> failed!\n",
>  			phy_id, phy_op));
>  	} else
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("%x phy execute %x phy op success!
> \n",
> +			pm8001_printk("%x phy execute %x phy op
> success!\n",
>  			phy_id, phy_op));
>  	return 0;
>  }
> @@ -3018,7 +3019,7 @@
>  		break;
>  	case PORT_INVALID:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk(" PortInvalid portID %d \n",
> port_id));
> +			pm8001_printk(" PortInvalid portID %d\n",
> port_id));
>  		PM8001_MSG_DBG(pm8001_ha,
>  			pm8001_printk(" Last phy Down and port
> invalid\n"));
>  		port->port_attached = 0;
> @@ -3027,7 +3028,7 @@
>  		break;
>  	case PORT_IN_RESET:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk(" Port In Reset portID %d \n",
> port_id));
> +			pm8001_printk(" Port In Reset portID %d\n",
> port_id));
>  		break;
>  	case PORT_NOT_ESTABLISHED:
>  		PM8001_MSG_DBG(pm8001_ha,
> @@ -3220,7 +3221,7 @@
>  		pm8001_printk(" status = 0x%x\n", status));
>  	for (i = 0; i < GENERAL_EVENT_PAYLOAD; i++)
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("inb_IOMB_payload[0x%x] 0x%x, \n",
> i,
> +			pm8001_printk("inb_IOMB_payload[0x%x] 0x%x,\n",
> i,
>  			pPayload->inb_IOMB_payload[i]));
>  	return 0;
>  }
> @@ -3312,12 +3313,12 @@
>  		break;
>  	case HW_EVENT_SAS_PHY_UP:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("HW_EVENT_PHY_START_STATUS \n"));
> +			pm8001_printk("HW_EVENT_PHY_START_STATUS\n"));
>  		hw_event_sas_phy_up(pm8001_ha, piomb);
>  		break;
>  	case HW_EVENT_SATA_PHY_UP:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("HW_EVENT_SATA_PHY_UP \n"));
> +			pm8001_printk("HW_EVENT_SATA_PHY_UP\n"));
>  		hw_event_sata_phy_up(pm8001_ha, piomb);
>  		break;
>  	case HW_EVENT_PHY_STOP_STATUS:
> @@ -3329,12 +3330,12 @@
>  		break;
>  	case HW_EVENT_SATA_SPINUP_HOLD:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD \n"));
> +			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD\n"));
>  		sas_ha->notify_phy_event(&phy->sas_phy,
> PHYE_SPINUP_HOLD);
>  		break;
>  	case HW_EVENT_PHY_DOWN:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("HW_EVENT_PHY_DOWN \n"));
> +			pm8001_printk("HW_EVENT_PHY_DOWN\n"));
>  		sas_ha->notify_phy_event(&phy->sas_phy,
> PHYE_LOSS_OF_SIGNAL);
>  		phy->phy_attached = 0;
>  		phy->phy_state = 0;
> @@ -3446,7 +3447,7 @@
>  		break;
>  	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
>  		PM8001_MSG_DBG(pm8001_ha,
> -
> pm8001_printk("HW_EVENT_LINK_ERR_PHY_RESET_FAILED \n"));
> +
> pm8001_printk("HW_EVENT_LINK_ERR_PHY_RESET_FAILED\n"));
>  		pm8001_hw_event_ack_req(pm8001_ha, 0,
>  			HW_EVENT_LINK_ERR_PHY_RESET_FAILED,
>  			port_id, phy_id, 0, 0);
> @@ -3456,25 +3457,25 @@
>  		break;
>  	case HW_EVENT_PORT_RESET_TIMER_TMO:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO
> \n"));
> +
> pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO\n"));
>  		sas_phy_disconnected(sas_phy);
>  		phy->phy_attached = 0;
>  		sas_ha->notify_port_event(sas_phy,
> PORTE_LINK_RESET_ERR);
>  		break;
>  	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("HW_EVENT_PORT_RECOVERY_TIMER_TMO
> \n"));
> +
> pm8001_printk("HW_EVENT_PORT_RECOVERY_TIMER_TMO\n"));
>  		sas_phy_disconnected(sas_phy);
>  		phy->phy_attached = 0;
>  		sas_ha->notify_port_event(sas_phy,
> PORTE_LINK_RESET_ERR);
>  		break;
>  	case HW_EVENT_PORT_RECOVER:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("HW_EVENT_PORT_RECOVER \n"));
> +			pm8001_printk("HW_EVENT_PORT_RECOVER\n"));
>  		break;
>  	case HW_EVENT_PORT_RESET_COMPLETE:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("HW_EVENT_PORT_RESET_COMPLETE
> \n"));
> +
> pm8001_printk("HW_EVENT_PORT_RESET_COMPLETE\n"));
>  		break;
>  	case EVENT_BROADCAST_ASYNCH_EVENT:
>  		PM8001_MSG_DBG(pm8001_ha,
> @@ -3502,21 +3503,21 @@
> 
>  	switch (opc) {
>  	case OPC_OUB_ECHO:
> -		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("OPC_OUB_ECHO
> \n"));
> +		PM8001_MSG_DBG(pm8001_ha,
> pm8001_printk("OPC_OUB_ECHO\n"));
>  		break;
>  	case OPC_OUB_HW_EVENT:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("OPC_OUB_HW_EVENT \n"));
> +			pm8001_printk("OPC_OUB_HW_EVENT\n"));
>  		mpi_hw_event(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_SSP_COMP:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("OPC_OUB_SSP_COMP \n"));
> +			pm8001_printk("OPC_OUB_SSP_COMP\n"));
>  		mpi_ssp_completion(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_SMP_COMP:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("OPC_OUB_SMP_COMP \n"));
> +			pm8001_printk("OPC_OUB_SMP_COMP\n"));
>  		mpi_smp_completion(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_LOCAL_PHY_CNTRL:
> @@ -3526,26 +3527,26 @@
>  		break;
>  	case OPC_OUB_DEV_REGIST:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("OPC_OUB_DEV_REGIST \n"));
> +			pm8001_printk("OPC_OUB_DEV_REGIST\n"));
>  		mpi_reg_resp(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_DEREG_DEV:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("unresgister the deviece \n"));
> +			pm8001_printk("unresgister the deviece\n"));
>  		mpi_dereg_resp(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_GET_DEV_HANDLE:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("OPC_OUB_GET_DEV_HANDLE \n"));
> +			pm8001_printk("OPC_OUB_GET_DEV_HANDLE\n"));
>  		break;
>  	case OPC_OUB_SATA_COMP:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("OPC_OUB_SATA_COMP \n"));
> +			pm8001_printk("OPC_OUB_SATA_COMP\n"));
>  		mpi_sata_completion(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_SATA_EVENT:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("OPC_OUB_SATA_EVENT \n"));
> +			pm8001_printk("OPC_OUB_SATA_EVENT\n"));
>  		mpi_sata_event(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_SSP_EVENT:
> @@ -3858,19 +3859,19 @@
>  	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>  	if (task->data_dir == PCI_DMA_NONE) {
>  		ATAP = 0x04;  /* no data*/
> -		PM8001_IO_DBG(pm8001_ha, pm8001_printk("no data \n"));
> +		PM8001_IO_DBG(pm8001_ha, pm8001_printk("no data\n"));
>  	} else if (likely(!task->ata_task.device_control_reg_update)) {
>  		if (task->ata_task.dma_xfer) {
>  			ATAP = 0x06; /* DMA */
> -			PM8001_IO_DBG(pm8001_ha, pm8001_printk("DMA
> \n"));
> +			PM8001_IO_DBG(pm8001_ha,
> pm8001_printk("DMA\n"));
>  		} else {
>  			ATAP = 0x05; /* PIO*/
> -			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO
> \n"));
> +			PM8001_IO_DBG(pm8001_ha,
> pm8001_printk("PIO\n"));
>  		}
>  		if (task->ata_task.use_ncq &&
>  			dev->sata_dev.command_set != ATAPI_COMMAND_SET)
> {
>  			ATAP = 0x07; /* FPDMA */
> -			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA
> \n"));
> +			PM8001_IO_DBG(pm8001_ha,
> pm8001_printk("FPDMA\n"));
>  		}
>  	}
>  	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task,
> &hdr_tag))
> diff -ru scsi-misc-2.6/drivers/scsi/pm8001/pm8001_sas.c
> scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_sas.c
> --- scsi-misc-2.6/drivers/scsi/pm8001/pm8001_sas.c	2011-09-15
> 12:52:02.000000000 -0400
> +++ scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_sas.c	2011-09-26
> 10:40:37.000000000 -0400
> @@ -651,7 +651,7 @@
>  				flag = 1; /* directly sata*/
>  		}
>  	} /*register this device to HBA*/
> -	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device \n"));
> +	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
>  	PM8001_CHIP_DISP->reg_dev_req(pm8001_ha, pm8001_device, flag);
>  	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>  	wait_for_completion(&completion);
> @@ -1000,13 +1000,14 @@
>  		/* The task is still in Lun, release it then */
>  		case TMF_RESP_FUNC_SUCC:
>  			PM8001_EH_DBG(pm8001_ha,
> -				pm8001_printk("The task is still in Lun
> \n"));
> +				pm8001_printk("The task is still in
> Lun\n"));
> +			break;
>  		/* The task is not in Lun or failed, reset the phy */
>  		case TMF_RESP_FUNC_FAILED:
>  		case TMF_RESP_FUNC_COMPLETE:
>  			PM8001_EH_DBG(pm8001_ha,
>  			pm8001_printk("The task is not in Lun or
> failed,"
> -			" reset the phy \n"));
> +			" reset the phy\n"));
>  			break;
>  		}
>  	}
> 
> ______________________________________________________________________
> This email may contain privileged or confidential information, which
should
> only be used for the purpose for which it was sent by Xyratex. No further
rights
> or licenses are granted to use such information. If you are not the
intended
> recipient of this message, please notify the sender by return and delete
it.
> You may not use, copy, disclose or rely on the information contained in
it.
> 
> Internet email is susceptible to data corruption, interception and
> unauthorised amendment for which Xyratex does not accept liability. While
we
> have taken reasonable precautions to ensure that this email is free of
viruses,
> Xyratex does not accept liability for the presence of any computer viruses
in
> this email, nor for any losses caused as a result of viruses.
> 
> Xyratex Technology Limited (03134912), Registered in England & Wales,
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
> The Xyratex group of companies also includes, Xyratex Ltd, registered in
> Bermuda, Xyratex International Inc, registered in California, Xyratex
> (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co
Ltd
> registered in The People's Republic of China and Xyratex Japan Limited
> registered in Japan.
> ______________________________________________________________________
> 
> 


