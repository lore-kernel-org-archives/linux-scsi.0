From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: RE: [PATCH 10/15] be2iscsi: Add FW config validation
Date: Mon, 21 Dec 2015 09:29:20 +0530
Message-ID: <a6b9e93fa2d3883b19f29e878a41511d@mail.gmail.com>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-11-git-send-email-jitendra.bhivare@avagotech.com> <5673CBF8.1040401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:35397 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbLUD7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2015 22:59:25 -0500
Received: by mail-yk0-f171.google.com with SMTP id v6so118925316ykc.2
        for <linux-scsi@vger.kernel.org>; Sun, 20 Dec 2015 19:59:25 -0800 (PST)
In-Reply-To: <5673CBF8.1040401@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

Yes, the faults are not being used, it just adds to the confusion, we j=
ust
intend to get the link state change - UP or DOWN.

-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]
Sent: Friday, December 18, 2015 2:34 PM
To: Jitendra Bhivare; linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu
Subject: Re: [PATCH 10/15] be2iscsi: Add FW config validation

On 12/15/2015 04:55 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> System crash in I+T card personality
>
> Fix to add validation for ULP in initiator mode, physical port number=
,
> and supported queue, icd, cid counts.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c |    2 +-
>   drivers/scsi/be2iscsi/be_main.h |    2 +
>   drivers/scsi/be2iscsi/be_mgmt.c |  188
+++++++++++++++++++++++++--------------
>   3 files changed, 123 insertions(+), 69 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c
> b/drivers/scsi/be2iscsi/be_main.c index 8967e05..a665e6a 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5670,6 +5670,7 @@ static int beiscsi_dev_probe(struct pci_dev
*pcidev,
>   		goto free_port;
>   	}
>   	mgmt_get_port_name(&phba->ctrl, phba);
> +	beiscsi_get_params(phba);
>
>   	if (enable_msix)
>   		find_num_cpus(phba);
> @@ -5687,7 +5688,6 @@ static int beiscsi_dev_probe(struct pci_dev
*pcidev,
>   	}
>
>   	phba->shost->max_id =3D phba->params.cxns_per_ctrl;
> -	beiscsi_get_params(phba);
>   	phba->shost->can_queue =3D phba->params.ios_per_ctrl;
>   	ret =3D beiscsi_init_port(phba);
>   	if (ret < 0) {
> diff --git a/drivers/scsi/be2iscsi/be_main.h
> b/drivers/scsi/be2iscsi/be_main.h index c09082a..f89861b 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -397,7 +397,9 @@ struct beiscsi_hba {
>   		 * group together since they are used most frequently
>   		 * for cid to cri conversion
>   		 */
> +#define BEISCSI_PHYS_PORT_MAX	4
>   		unsigned int phys_port;
> +		/* valid values of phys_port id are 0, 1, 2, 3 */
>   		unsigned int eqid_count;
>   		unsigned int cqid_count;
>   		unsigned int iscsi_cid_start[BEISCSI_ULP_COUNT];
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c
> b/drivers/scsi/be2iscsi/be_mgmt.c index ad7aa75..15f7ad7 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -373,90 +373,142 @@ int mgmt_get_fw_config(struct be_ctrl_info *ct=
rl,
>   				struct beiscsi_hba *phba)
>   {
>   	struct be_mcc_wrb *wrb =3D wrb_from_mbox(&ctrl->mbox_mem);
> -	struct be_fw_cfg *req =3D embedded_payload(wrb);
> -	int status =3D 0;
> +	struct be_fw_cfg *pfw_cfg =3D embedded_payload(wrb);
> +	uint32_t cid_count, icd_count;
> +	int status =3D -EINVAL;
> +	uint8_t ulp_num =3D 0;
>
>   	mutex_lock(&ctrl->mbox_lock);
>   	memset(wrb, 0, sizeof(*wrb));
> +	be_wrb_hdr_prepare(wrb, sizeof(*pfw_cfg), true, 0);
>
> -	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
> -
> -	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
> +	be_cmd_hdr_prepare(&pfw_cfg->hdr, CMD_SUBSYSTEM_COMMON,
>   			   OPCODE_COMMON_QUERY_FIRMWARE_CONFIG,
>   			   EMBED_MBX_MAX_PAYLOAD_SIZE);
> -	status =3D be_mbox_notify(ctrl);
> -	if (!status) {
> -		uint8_t ulp_num =3D 0;
> -		struct be_fw_cfg *pfw_cfg;
> -		pfw_cfg =3D req;
>
> -		if (!is_chip_be2_be3r(phba)) {
> -			phba->fw_config.eqid_count =3D pfw_cfg->eqid_count;
> -			phba->fw_config.cqid_count =3D pfw_cfg->cqid_count;
> +	if (be_mbox_notify(ctrl)) {
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> +			    "BG_%d : Failed in mgmt_get_fw_config\n");
> +		goto fail_init;
> +	}
>
> -			beiscsi_log(phba, KERN_INFO,
> -				    BEISCSI_LOG_INIT,
> -				    "BG_%d : EQ_Count : %d CQ_Count :
%d\n",
> -				    phba->fw_config.eqid_count,
> +	/* FW response formats depend on port id */
> +	phba->fw_config.phys_port =3D pfw_cfg->phys_port;
> +	if (phba->fw_config.phys_port >=3D BEISCSI_PHYS_PORT_MAX) {
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> +			    "BG_%d : invalid physical port id %d\n",
> +			    phba->fw_config.phys_port);
> +		goto fail_init;
> +	}
> +
> +	/* populate and check FW config against min and max values */
> +	if (!is_chip_be2_be3r(phba)) {
> +		phba->fw_config.eqid_count =3D pfw_cfg->eqid_count;
> +		phba->fw_config.cqid_count =3D pfw_cfg->cqid_count;
> +		if (phba->fw_config.eqid_count =3D=3D 0 ||
> +		    phba->fw_config.eqid_count > 2048) {
> +			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> +				    "BG_%d : invalid EQ count %d\n",
> +				    phba->fw_config.eqid_count);
> +			goto fail_init;
> +		}
> +		if (phba->fw_config.cqid_count =3D=3D 0 ||
> +		    phba->fw_config.cqid_count > 4096) {
> +			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> +				    "BG_%d : invalid CQ count %d\n",
>   				    phba->fw_config.cqid_count);
> +			goto fail_init;
>   		}
> +		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> +			    "BG_%d : EQ_Count : %d CQ_Count : %d\n",
> +			    phba->fw_config.eqid_count,
> +			    phba->fw_config.cqid_count);
> +	}
>
> -		for (ulp_num =3D 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
> -			if (pfw_cfg->ulp[ulp_num].ulp_mode &
> -			    BEISCSI_ULP_ISCSI_INI_MODE)
> -				set_bit(ulp_num,
> -				&phba->fw_config.ulp_supported);
> -
> -		phba->fw_config.phys_port =3D pfw_cfg->phys_port;
> -		for (ulp_num =3D 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
{
> -			if (test_bit(ulp_num,
&phba->fw_config.ulp_supported)) {
> -
> -				phba->fw_config.iscsi_cid_start[ulp_num] =3D
> -					pfw_cfg->ulp[ulp_num].sq_base;
> -				phba->fw_config.iscsi_cid_count[ulp_num] =3D
> -					pfw_cfg->ulp[ulp_num].sq_count;
> -
> -				phba->fw_config.iscsi_icd_start[ulp_num] =3D
> -					pfw_cfg->ulp[ulp_num].icd_base;
> -				phba->fw_config.iscsi_icd_count[ulp_num] =3D
> -					pfw_cfg->ulp[ulp_num].icd_count;
> -
> -				phba->fw_config.iscsi_chain_start[ulp_num]
=3D
> -
pfw_cfg->chain_icd[ulp_num].chain_base;
> -				phba->fw_config.iscsi_chain_count[ulp_num]
=3D
> -
pfw_cfg->chain_icd[ulp_num].chain_count;
> -
> -				beiscsi_log(phba, KERN_INFO,
BEISCSI_LOG_INIT,
> -					    "BG_%d : Function loaded on
ULP : %d\n"
> -					    "\tiscsi_cid_count : %d\n"
> -					    "\tiscsi_cid_start : %d\n"
> -					    "\t iscsi_icd_count : %d\n"
> -					    "\t iscsi_icd_start : %d\n",
> -					    ulp_num,
> -					    phba->fw_config.
> -					    iscsi_cid_count[ulp_num],
> -					    phba->fw_config.
> -					    iscsi_cid_start[ulp_num],
> -					    phba->fw_config.
> -					    iscsi_icd_count[ulp_num],
> -					    phba->fw_config.
> -					    iscsi_icd_start[ulp_num]);
> -			}
> +	/**
> +	 * Check on which all ULP iSCSI Protocol is loaded.
> +	 * Set the Bit for those ULP. This set flag is used
> +	 * at all places in the code to check on which ULP
> +	 * iSCSi Protocol is loaded
> +	 **/
> +	for (ulp_num =3D 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
> +		if (pfw_cfg->ulp[ulp_num].ulp_mode &
> +		    BEISCSI_ULP_ISCSI_INI_MODE) {
> +			set_bit(ulp_num, &phba->fw_config.ulp_supported);
> +
> +			/* Get the CID, ICD and Chain count for each ULP
*/
> +			phba->fw_config.iscsi_cid_start[ulp_num] =3D
> +				pfw_cfg->ulp[ulp_num].sq_base;
> +			phba->fw_config.iscsi_cid_count[ulp_num] =3D
> +				pfw_cfg->ulp[ulp_num].sq_count;
> +
> +			phba->fw_config.iscsi_icd_start[ulp_num] =3D
> +				pfw_cfg->ulp[ulp_num].icd_base;
> +			phba->fw_config.iscsi_icd_count[ulp_num] =3D
> +				pfw_cfg->ulp[ulp_num].icd_count;
> +
> +			phba->fw_config.iscsi_chain_start[ulp_num] =3D
> +				pfw_cfg->chain_icd[ulp_num].chain_base;
> +			phba->fw_config.iscsi_chain_count[ulp_num] =3D
> +				pfw_cfg->chain_icd[ulp_num].chain_count;
> +
> +			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> +				    "BG_%d : Function loaded on ULP :
%d\n"
> +				    "\tiscsi_cid_count : %d\n"
> +				    "\tiscsi_cid_start : %d\n"
> +				    "\t iscsi_icd_count : %d\n"
> +				    "\t iscsi_icd_start : %d\n",
> +				    ulp_num,
> +				    phba->fw_config.
> +				    iscsi_cid_count[ulp_num],
> +				    phba->fw_config.
> +				    iscsi_cid_start[ulp_num],
> +				    phba->fw_config.
> +				    iscsi_icd_count[ulp_num],
> +				    phba->fw_config.
> +				    iscsi_icd_start[ulp_num]);
>   		}
> +	}
>
> -		phba->fw_config.dual_ulp_aware =3D (pfw_cfg->function_mode &
> -						  BEISCSI_FUNC_DUA_MODE);
> +	if (phba->fw_config.ulp_supported =3D=3D 0) {
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> +			    "BG_%d : iSCSI initiator mode not set: ULP0 %x
ULP1 %x\n",
> +			    pfw_cfg->ulp[BEISCSI_ULP0].ulp_mode,
> +			    pfw_cfg->ulp[BEISCSI_ULP1].ulp_mode);
> +		goto fail_init;
> +	}
>
> -		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> -			    "BG_%d : DUA Mode : 0x%x\n",
> -			    phba->fw_config.dual_ulp_aware);
> +	/**
> +	 * ICD is shared among ULPs. Use icd_count of any one loaded ULP
> +	 **/
> +	for (ulp_num =3D 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
> +		if (test_bit(ulp_num, &phba->fw_config.ulp_supported))
> +			break;
> +	icd_count =3D phba->fw_config.iscsi_icd_count[ulp_num];
> +	if (icd_count =3D=3D 0 || icd_count > 65536) {
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> +			    "BG_%d: invalid ICD count %d\n", icd_count);
> +		goto fail_init;
> +	}
>
> -	} else {
> +	cid_count =3D BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP0) +
> +		    BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP1);
> +	if (cid_count =3D=3D 0 || cid_count > 4096) {
>   		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
> -			    "BG_%d : Failed in mgmt_get_fw_config\n");
> -		status =3D -EINVAL;
> +			    "BG_%d: invalid CID count %d\n", cid_count);
> +		goto fail_init;
>   	}
>
> +	phba->fw_config.dual_ulp_aware =3D (pfw_cfg->function_mode &
> +					  BEISCSI_FUNC_DUA_MODE);
> +
> +	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
> +		    "BG_%d : DUA Mode : 0x%x\n",
> +		    phba->fw_config.dual_ulp_aware);
> +
> +	/* all set, continue using this FW config */
> +	status =3D 0;
> +fail_init:
>   	mutex_unlock(&ctrl->mbox_lock);
>   	return status;
>   }
>
Shouldn't that be 'DUAL mode' ?
But then, even the original had 'DUA'. So no need to redo the patch for
that.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton H=
RB 21284
(AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
