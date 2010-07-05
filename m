From: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 09/12] be2iscsi: Add support for iscsi boot
Date: Mon, 5 Jul 2010 16:40:38 -0400
Message-ID: <201007051640.39058.konrad@kernel.org>
References: <20100630000218.GA20348@serverengines.com> <4C30EC20.9060406@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:34419 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab0GEUtF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2010 16:49:05 -0400
In-Reply-To: <4C30EC20.9060406@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On Sunday 04 July 2010 16:16:32 Mike Christie wrote:
> ccing Konrad to give him some heads up that there is going to be another
> user of the boot lib.

Excellent. Jayamohan  when you get to post a new version of the patches please 
CC so that I can review them.

>
> On 06/29/2010 07:02 PM, Jayamohan Kallickal wrote:
> > +static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char
> > *buf) +{
> > +	struct beiscsi_hba *phba = data;
> > +	char *str = buf;
> > +	int rc;
> > +
> > +	printk(KERN_ERR " In beiscsi_show_boot_tgt_info type=%d\n", type);
> > +	switch (type) {
> > +	case ISCSI_BOOT_TGT_NAME:
> > +		rc = sprintf(buf, "%.*s\n",
> > +				(int)strlen(phba->boot_sess.target_name),
>
> Did you get a compile warning if you did not cast this to a int?
>
> > +				(char *)&phba->boot_sess.target_name);
> > +		break;
> > +	case ISCSI_BOOT_TGT_IP_ADDR:
> > +		if (phba->boot_sess.conn_list[0].dest_ipaddr.ip_type == 0x1)
> > +			rc = sprintf(buf, "%pI4\n",
> > +				(char *)&phba->boot_sess.conn_list[0].
> > +				dest_ipaddr.ip_address);
> > +		else
> > +			rc = sprintf(str, "%pI6\n",
> > +				(char *)&phba->boot_sess.conn_list[0].
> > +				dest_ipaddr.ip_address);
> > +		break;
> > +	case ISCSI_BOOT_TGT_PORT:
> > +		rc = sprintf(str, "%d\n", phba->boot_sess.conn_list[0].
> > +				  dest_port);
> > +		break;
> > +
> > +	case ISCSI_BOOT_TGT_CHAP_NAME:
> > +		rc = sprintf(str,  "%.*s\n",
> > +				      phba->boot_sess.conn_list[0].
> > +				      negotiated_login_options.auth_data.chap.
> > +				      target_chap_name_length,
> > +				      (char *)&phba->boot_sess.conn_list[0].
> > +				      negotiated_login_options.auth_data.chap.
> > +				      target_chap_name);
> > +		break;
> > +	case ISCSI_BOOT_TGT_CHAP_SECRET:
> > +		rc = sprintf(str,  "%.*s\n",
> > +				      phba->boot_sess.conn_list[0].
> > +				      negotiated_login_options.auth_data.chap.
> > +				      target_secret_length,
> > +				      (char *)&phba->boot_sess.conn_list[0].
> > +				      negotiated_login_options.auth_data.chap.
> > +				      target_secret);
> > +
> > +		break;
> > +	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
> > +		rc = sprintf(str,  "%.*s\n",
> > +				      phba->boot_sess.conn_list[0].
> > +				      negotiated_login_options.auth_data.chap.
> > +				      intr_chap_name_length,
> > +				      (char *)&phba->boot_sess.conn_list[0].
> > +				      negotiated_login_options.auth_data.chap.
> > +				      intr_chap_name);
> > +
> > +		break;
> > +	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
> > +			rc = sprintf(str,  "%.*s\n",
> > +				      phba->boot_sess.conn_list[0].
> > +				      negotiated_login_options.auth_data.chap.
> > +				      intr_secret_length,
> > +				      (char *)&phba->boot_sess.conn_list[0].
> > +				      negotiated_login_options.auth_data.chap.
> > +				      intr_secret);
> > +		break;
> > +	case ISCSI_BOOT_TGT_FLAGS:
> > +			rc = sprintf(str, "2\n");
> > +		break;
> > +	case ISCSI_BOOT_TGT_NIC_ASSOC:
> > +			rc = sprintf(str, "0\n");
> > +		break;
> > +	default:
> > +		rc = -ENOSYS;
> > +		break;
> > +	}
> > +	return rc;
> > +}
> > +
> > +static ssize_t beiscsi_show_boot_ini_info(void *data, int type, char
> > *buf) +{
> > +	struct beiscsi_hba *phba = data;
> > +	char *str = buf;
> > +	int rc;
> > +
> > +	printk(KERN_ERR " In beiscsi_show_boot_ini_info type=%d\n", type);

Remove that.

> > +	switch (type) {
> > +	case ISCSI_BOOT_INI_INITIATOR_NAME:
> > +		rc = sprintf(str, "%s\n", phba->boot_sess.initiator_iscsiname);
> > +		break;
> > +	default:
> > +		rc = -ENOSYS;
> > +		break;
> > +	}
> > +	return rc;
> > +}
> > +
> > +static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char
> > *buf) +{
> > +	struct beiscsi_hba *phba = data;
> > +	char *str = buf;
> > +	int rc;
> > +
> > +	printk(KERN_ERR " In beiscsi_show_boot_eth_info type = %d\n", type);

Ditto.
> > +	switch (type) {
> > +	case ISCSI_BOOT_ETH_FLAGS:
> > +			rc = sprintf(str, "2\n");
> > +		break;
> > +	case ISCSI_BOOT_ETH_INDEX:
> > +			rc = sprintf(str, "0\n");
> > +		break;
> > +	case ISCSI_BOOT_ETH_MAC:
> > +	{
> > +		tag = be_cmd_get_mac_addr(phba);
> > +		if (!tag) {
> > +			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed\n");

You are missing a period at the end.

> > +			return -1;

use the rc. Set it to the appropiate -E<value> and break out here.

> > +		} else
> > +			wait_event_interruptible(phba->ctrl.mcc_wait[tag],
> > +						 phba->ctrl.mcc_numtag[tag]);
> > +
> > +		wrb_num = (phba->ctrl.mcc_numtag[tag]&  0x00FF0000)>>  16;
> > +		extd_status = (phba->ctrl.mcc_numtag[tag]&  0x0000FF00)>>  8;
> > +		status = phba->ctrl.mcc_numtag[tag]&  0x000000FF;
> > +		if (status || extd_status) {
> > +			SE_DEBUG(DBG_LVL_1, "Failed to get be_cmd_get_mac_addr"
> > +					    " status = %d extd_status = %d\n",

Missing period.

> > +					    status, extd_status);
> > +			free_mcc_tag(&phba->ctrl, tag);
> > +			return -1;
ditto.

> > +		} else {
> > +			wrb = queue_get_wrb(mccq, wrb_num);
> > +			free_mcc_tag(&phba->ctrl, tag);
> > +			resp = embedded_payload(wrb);
> > +			memcpy(phba->mac_address, resp->mac_address, ETH_ALEN);
> > +			rc = sysfs_format_mac(buf, phba->mac_address,
> > +					       ETH_ALEN);
> > +		}
>
> Can't you get this info in the host setup functions and then use the
> cached version? Or if it changes can you update the cached info?
>
> This also looks like the same code in beiscsi_get_host_param so it
> should at least be a function.
>
> > +	}
> > +
> > +	break;
> > +	default:
> > +		rc = -ENOSYS;
> > +		break;
> > +	}
> > +	return rc;
> > +}
> > +
> > +
> > +static mode_t beiscsi_tgt_get_attr_visibility(void *data, int type)
> > +{
> > +	int rc;
> > +
> > +	switch (type) {
> > +	case ISCSI_BOOT_TGT_NAME:
> > +	case ISCSI_BOOT_TGT_IP_ADDR:
> > +	case ISCSI_BOOT_TGT_PORT:
> > +	case ISCSI_BOOT_TGT_CHAP_NAME:
> > +	case ISCSI_BOOT_TGT_CHAP_SECRET:
> > +	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
> > +	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
> > +	case ISCSI_BOOT_TGT_NIC_ASSOC:
> > +	case ISCSI_BOOT_TGT_FLAGS:
> > +		rc = S_IRUGO;
> > +		break;
> > +	default:
> > +		rc = 0;
> > +		break;
> > +	}
> > +	return rc;
> > +}
> > +
> > +static mode_t beiscsi_ini_get_attr_visibility(void *data, int type)
> > +{
> > +	int rc;
> > +
> > +	switch (type) {
> > +	case ISCSI_BOOT_INI_INITIATOR_NAME:
> > +		rc = S_IRUGO;
> > +		break;
> > +	default:
> > +		rc = 0;
> > +		break;
> > +	}
> > +	return rc;
> > +}
> > +
> > +
> > +static mode_t beiscsi_eth_get_attr_visibility(void *data, int type)
> > +{
> > +	int rc;
> > +
> > +	switch (type) {
> > +	case ISCSI_BOOT_ETH_FLAGS:
> > +	case ISCSI_BOOT_ETH_MAC:
> > +	case ISCSI_BOOT_ETH_INDEX:
> > +		rc = S_IRUGO;
> > +		break;
> > +	default:
> > +		rc = 0;
> > +		break;
> > +	}
> > +	return rc;
> > +}
> > +
> > +static int beiscsi_setup_boot_info(struct beiscsi_hba *phba)
> > +{
> > +	struct iscsi_boot_kobj *boot_kobj;
> > +	char *set_name;
> > +
> > +	set_name = kasprintf(GFP_KERNEL, "iscsi_boot%u", phba->shost->host_no);
> > +	if (!set_name)
> > +		return -ENOMEM;
> > +
> > +	phba->boot_kset = iscsi_boot_create_kset(set_name);
> > +	if (!phba->boot_kset) {
> > +		kfree(set_name);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* get boot info using mgmt cmd */
> > +	boot_kobj = iscsi_boot_create_target(phba->boot_kset, 0, phba,
> > +					     beiscsi_show_boot_tgt_info,
> > +					     beiscsi_tgt_get_attr_visibility);
> > +	if (!boot_kobj)
> > +		goto free_kset;
> > +
> > +	boot_kobj = iscsi_boot_create_initiator(phba->boot_kset, 0, phba,
> > +					     beiscsi_show_boot_ini_info,
> > +					     beiscsi_ini_get_attr_visibility);
> > +	if (!boot_kobj)
> > +		goto free_kset;
> > +
> > +	boot_kobj = iscsi_boot_create_ethernet(phba->boot_kset, 0, phba,
> > +					     beiscsi_show_boot_eth_info,
> > +					     beiscsi_eth_get_attr_visibility);
> > +	if (!boot_kobj)
> > +		goto free_kset;
> > +	return 0;
> > +
> > +free_kset:
> > +	kfree(set_name);
> > +	iscsi_boot_destroy_kset(phba->boot_kset);
> > +	return -ENOMEM;
> > +}
> > +
> >   /*------------------- PCI Driver operations and data -----------------
> > */ static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
> >   	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
> > @@ -270,6 +523,15 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct
> > pci_dev *pcidev)
> >
> >   	if (iscsi_host_add(shost,&phba->pcidev->dev))
> >   		goto free_devices;
> > +
> > +	if (beiscsi_setup_boot_info(phba))
> > +		/*
> > +		 * log error but continue, because we may not be using
> > +		 * iscsi boot.
> > +		 */
> > +		shost_printk(KERN_ERR, phba->shost, "Could not set up "
> > +		"iSCSI boot info.");
> > +
> >   	return phba;
> >
> >   free_devices:
> > @@ -3263,6 +3525,89 @@ static void hwi_disable_intr(struct beiscsi_hba
> > *phba) "In hwi_disable_intr, Already Disabled\n");
> >   }
> >
> > +static char beiscsi_get_boot_info(struct beiscsi_hba *phba)

Why is this function returning a char when you return int values?

> > +{
> > +	struct be_cmd_resp_get_boot_target *boot_resp;
> > +	struct be_cmd_resp_geta_session *session_resp;
> > +	struct be_mcc_wrb *wrb;
> > +	struct be_dma_mem nonemb_cmd;
> > +	unsigned int tag, wrb_num;
> > +	unsigned short status, extd_status;
> > +	struct be_queue_info *mccq =&phba->ctrl.mcc_obj.q;
> > +
> > +	tag = beiscsi_get_boot_target(phba);
> > +	if (!tag) {
> > +		SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed\n");

Missing period at the end.
> > +		return -1;
Should the error value be something else? Say -ENODEV or -EINVAL?
or -ENOSYS?

> > +	} else
> > +		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
> > +					 phba->ctrl.mcc_numtag[tag]);
> > +
> > +	wrb_num = (phba->ctrl.mcc_numtag[tag]&  0x00FF0000)>>  16;
> > +	extd_status = (phba->ctrl.mcc_numtag[tag]&  0x0000FF00)>>  8;
> > +	status = phba->ctrl.mcc_numtag[tag]&  0x000000FF;
> > +	if (status || extd_status) {
> > +		SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed"
> > +				    " status = %d extd_status = %d\n",
> > +				    status, extd_status);
> > +		free_mcc_tag(&phba->ctrl, tag);
> > +		return -1;
> > +	}
> > +	wrb = queue_get_wrb(mccq, wrb_num);
> > +	free_mcc_tag(&phba->ctrl, tag);
> > +	boot_resp = embedded_payload(wrb);
> > +
> > +	if (boot_resp->boot_session_handle>= 0) {
> > +
>
> extra newline.
>
> You also probably can change this up to be
>
> if (boot_resp->boot_session_handle < 0) {
> 	printk(KERN_ERR "No Boot Session for this pci_func,"
> 		"session Hndl = %d\n", boot_resp->boot_session_handle);
> 	return 0;
> }
>
>
> nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
> 				sizeof(*session_resp),
> 				&nonemb_cmd.dma);
>
> .......
>
>
> tag = beiscsi_geta_session_info(phba,
> 		boot_resp->boot_session_handle,&nonemb_cmd);
> if (!tag)
> 	goto free_nonemb;
>
> ....
>
> if (something else fails)
> 	goto free_nonemb;
>
> .....
>
> free_nonemb:
> 	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size
> 	return 0;
>
> > +		nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
> > +					sizeof(*session_resp),
> > +					&nonemb_cmd.dma);
> > +		if (nonemb_cmd.va == NULL) {
> > +			SE_DEBUG(DBG_LVL_1,
> > +				 "Failed to allocate memory for"
> > +				 "beiscsi_geta_session_info\n");
> > +			return -1;
> > +		}
> > +
> > +		memset(nonemb_cmd.va, 0, sizeof(*session_resp));
> > +		tag = beiscsi_geta_session_info(phba,
> > +			boot_resp->boot_session_handle,&nonemb_cmd);
> > +		if (!tag) {
> > +			SE_DEBUG(DBG_LVL_1, "beiscsi_geta_session_info"
> > +				" Failed\n");
> > +			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
> > +			    nonemb_cmd.va, nonemb_cmd.dma);
> > +			return -1;
> > +		} else
> > +			wait_event_interruptible(phba->ctrl.mcc_wait[tag],
> > +						 phba->ctrl.mcc_numtag[tag]);
> > +
> > +		wrb_num = (phba->ctrl.mcc_numtag[tag]&  0x00FF0000)>>  16;
> > +		extd_status = (phba->ctrl.mcc_numtag[tag]&  0x0000FF00)>>  8;
> > +		status = phba->ctrl.mcc_numtag[tag]&  0x000000FF;
> > +		if (status || extd_status) {
> > +			SE_DEBUG(DBG_LVL_1, "beiscsi_geta_session_info Failed"
> > +					    " status = %d extd_status = %d\n",
> > +					    status, extd_status);
> > +			free_mcc_tag(&phba->ctrl, tag);
> > +			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
> > +			    nonemb_cmd.va, nonemb_cmd.dma);
> > +			return -1;
> > +		}
> > +		wrb = queue_get_wrb(mccq, wrb_num);
> > +		free_mcc_tag(&phba->ctrl, tag);
> > +		session_resp = nonemb_cmd.va ;
> > +		memcpy(&phba->boot_sess,&session_resp->session_info,
> > +		       sizeof(struct mgmt_session_info));
> > +		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
> > +			    nonemb_cmd.va, nonemb_cmd.dma);
> > +	} else {
> > +		printk(KERN_ERR "No Boot Session for this pci_func,"
> > +			"session Hndl = %d\n", boot_resp->boot_session_handle);
> > +	}
> > +		return 0;
> > +}
> > +
> >   static int beiscsi_init_port(struct beiscsi_hba *phba)
> >   {
> >   	int ret;
> > @@ -3825,6 +4170,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
> >   	iscsi_host_remove(phba->shost);
> >   	pci_dev_put(phba->pcidev);
> >   	iscsi_host_free(phba->shost);
> > +	iscsi_boot_destroy_kset(phba->boot_kset);
> >   }
> >
> >   static void beiscsi_msix_enable(struct beiscsi_hba *phba)
> > @@ -3985,6 +4331,13 @@ static int __devinit beiscsi_dev_probe(struct
> > pci_dev *pcidev, "Failed to hwi_enable_intr\n");
> >   		goto free_intr;
> >   	}
> > +	ret = beiscsi_get_boot_info(phba);
>
> Fix return value. Should be returning -Exyx code like the code does/should.
>
> > +	if (ret<  0) {
> > +		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
> > +			     "Failed to hwi_enable_intr\n");
> > +		goto free_intr;
> > +	}
> > +
> >   	SE_DEBUG(DBG_LVL_8, "\n\n\n SUCCESS - DRIVER LOADED\n\n\n");
> >   	return 0;
> >
> > diff --git a/drivers/scsi/be2iscsi/be_main.h
> > b/drivers/scsi/be2iscsi/be_main.h index 08996d0..978a57d 100644
> > --- a/drivers/scsi/be2iscsi/be_main.h
> > +++ b/drivers/scsi/be2iscsi/be_main.h
> > @@ -311,6 +311,7 @@ struct beiscsi_hba {
> >   	struct list_head hba_queue;
> >   	unsigned short *cid_array;
> >   	struct iscsi_endpoint **ep_array;
> > +	struct iscsi_boot_kset *boot_kset;
> >   	struct Scsi_Host *shost;
> >   	struct {
> >   		/**
> > @@ -341,6 +342,7 @@ struct beiscsi_hba {
> >   	struct work_struct work_cqs;	/* The work being queued */
> >   	struct be_ctrl_info ctrl;
> >   	unsigned int generation;
> > +	struct mgmt_session_info boot_sess;
> >   	struct invalidate_command_table inv_tbl[128];
> >
> >   };
> > diff --git a/drivers/scsi/be2iscsi/be_mgmt.c
> > b/drivers/scsi/be2iscsi/be_mgmt.c index c33aa3c..ee85898 100644
> > --- a/drivers/scsi/be2iscsi/be_mgmt.c
> > +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> > @@ -20,6 +20,77 @@
> >
> >   #include "be_mgmt.h"
> >   #include "be_iscsi.h"
> > +#include<scsi/scsi_transport_iscsi.h>
> > +
> > +unsigned int beiscsi_get_boot_target(struct beiscsi_hba *phba)
> > +{
> > +	struct be_ctrl_info *ctrl =&phba->ctrl;
> > +	struct be_mcc_wrb *wrb;
> > +	struct be_cmd_req_get_mac_addr *req;
> > +	unsigned int tag = 0;
> > +
> > +	SE_DEBUG(DBG_LVL_8, "In bescsi_get_boot_target\n");
> > +	spin_lock(&ctrl->mbox_lock);
> > +	tag = alloc_mcc_tag(phba);
> > +	if (!tag) {
> > +		spin_unlock(&ctrl->mbox_lock);
> > +		return tag;
> > +	}
> > +
> > +	wrb = wrb_from_mccq(phba);
> > +	req = embedded_payload(wrb);
> > +	wrb->tag0 |= tag;
> > +	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
> > +	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
> > +			   OPCODE_ISCSI_INI_BOOT_GET_BOOT_TARGET,
> > +			   sizeof(*req));
> > +
> > +	be_mcc_notify(phba);
> > +	spin_unlock(&ctrl->mbox_lock);
> > +	return tag;
> > +}
> > +
> > +unsigned int beiscsi_geta_session_info(struct beiscsi_hba *phba,
>
> Probably just wanted to name this beiscsi_get_session_info
>
> > +				  u32 boot_session_handle,
> > +				  struct be_dma_mem *nonemb_cmd)
> > +{
> > +	struct be_ctrl_info *ctrl =&phba->ctrl;
> > +	struct be_mcc_wrb *wrb;
> > +	unsigned int tag = 0;
> > +	struct  be_cmd_req_geta_session *req;
> > +	struct be_cmd_resp_geta_session *resp;
> > +	struct be_sge *sge;
> > +
> > +	SE_DEBUG(DBG_LVL_8, "In beiscsi_geta_session_info\n");
> > +	spin_lock(&ctrl->mbox_lock);
> > +	tag = alloc_mcc_tag(phba);
> > +	if (!tag) {
> > +		spin_unlock(&ctrl->mbox_lock);
> > +		return tag;
> > +	}
> > +
> > +	nonemb_cmd->size = sizeof(*resp);
> > +	req = nonemb_cmd->va;
> > +	memset(req, 0, sizeof(*req));
> > +	wrb = wrb_from_mccq(phba);
> > +	sge = nonembedded_sgl(wrb);
> > +	wrb->tag0 |= tag;
> > +
> > +
> > +	wrb->tag0 |= tag;
> > +	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
> > +	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
> > +			   OPCODE_ISCSI_INI_SESSION_GET_A_SESSION,
> > +			   sizeof(*resp));
> > +	req->session_handle = boot_session_handle;
> > +	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
> > +	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma&  0xFFFFFFFF);
> > +	sge->len = cpu_to_le32(nonemb_cmd->size);
> > +
> > +	be_mcc_notify(phba);
> > +	spin_unlock(&ctrl->mbox_lock);
> > +	return tag;
> > +}
> >
> >   unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
> >   				struct beiscsi_hba *phba)


