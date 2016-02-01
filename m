From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/12] be2iscsi: Rename MCC and BMBX processing functions
Date: Mon, 1 Feb 2016 12:26:00 +0100
Message-ID: <20160201112600.GD27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-5-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbcBAL0D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 06:26:03 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-5-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:43PM +0530, Jitendra Bhivare wrote:
> beiscsi_mccq_compl -> beiscsi_mccq_compl_wait - indicate blocking cal=
l.
> be_mcc_wait_compl -> be_mcc_compl_poll - indicate polling for complet=
ion.
> be_mbox_db_ready_wait -> be_mbox_db_ready_poll - indicate polling for=
 RDY.
> be_mcc_compl_process -> beiscsi_process_mbox_compl - indicate BMBX co=
mpl.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c  | 35 +++++++++++++++++-------------=
-----
>  drivers/scsi/be2iscsi/be_cmds.h  |  6 +++---
>  drivers/scsi/be2iscsi/be_iscsi.c |  8 ++++----
>  drivers/scsi/be2iscsi/be_main.c  |  8 ++++----
>  drivers/scsi/be2iscsi/be_mgmt.c  | 12 ++++++------
>  5 files changed, 34 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index fa010ac..8dd8521 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -140,7 +140,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *ph=
ba)
>  }
> =20
>  /*
> - * beiscsi_mccq_compl()- Wait for completion of MBX
> + * beiscsi_mccq_compl_wait()- Process completion in MCC CQ
>   * @phba: Driver private structure
>   * @tag: Tag for the MBX Command
>   * @wrb: the WRB used for the MBX Command
> @@ -152,9 +152,9 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *ph=
ba)
>   * Success: 0
>   * Failure: Non-Zero
>   **/
> -int beiscsi_mccq_compl(struct beiscsi_hba *phba,
> -		uint32_t tag, struct be_mcc_wrb **wrb,
> -		struct be_dma_mem *mbx_cmd_mem)
> +int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
> +			    uint32_t tag, struct be_mcc_wrb **wrb,
> +			    struct be_dma_mem *mbx_cmd_mem)
>  {
>  	int rc =3D 0;
>  	uint32_t mcc_tag_status;
> @@ -283,7 +283,7 @@ static inline void be_mcc_compl_use(struct be_mcc=
_compl *compl)
>  }
> =20
>  /*
> - * be_mcc_compl_process()- Check the MBX comapletion status
> + * beiscsi_process_mbox_compl()- Check the MBX completion status
>   * @ctrl: Function specific MBX data structure
>   * @compl: Completion status of MBX Command
>   *
> @@ -293,8 +293,8 @@ static inline void be_mcc_compl_use(struct be_mcc=
_compl *compl)
>   * Success: Zero
>   * Failure: Non-Zero
>   **/
> -static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
> -				struct be_mcc_compl *compl)
> +static int beiscsi_process_mbox_compl(struct be_ctrl_info *ctrl,
> +				      struct be_mcc_compl *compl)
>  {
>  	u16 compl_status, extd_status;
>  	struct be_mcc_wrb *wrb =3D wrb_from_mbox(&ctrl->mbox_mem);
> @@ -520,7 +520,7 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info=
 *ctrl,
>  }
> =20
>  /*
> - * be_mcc_wait_compl()- Wait for MBX completion
> + * be_mcc_compl_poll()- Wait for MBX completion
>   * @phba: driver private structure
>   *
>   * Wait till no more pending mcc requests are present
> @@ -556,8 +556,7 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, u=
nsigned int tag)
>  }
> =20
>  /*
> -/*
> - * be_mbox_db_ready_wait()- Check ready status
> + * be_mbox_db_ready_poll()- Check ready status
>   * @ctrl: Function specific MBX data structure
>   *
>   * Check for the ready status of FW to send BMBX
> @@ -567,7 +566,7 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, u=
nsigned int tag)
>   * Success: 0
>   * Failure: Non-Zero
>   **/
> -static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
> +static int be_mbox_db_ready_poll(struct be_ctrl_info *ctrl)
>  {
>  	/* wait 30s for generic non-flash MBOX operation */
>  #define BEISCSI_MBX_RDY_BIT_TIMEOUT	30000
> @@ -629,7 +628,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
>  	struct be_mcc_compl *compl =3D &mbox->compl;
>  	struct beiscsi_hba *phba =3D pci_get_drvdata(ctrl->pdev);
> =20
> -	status =3D be_mbox_db_ready_wait(ctrl);
> +	status =3D be_mbox_db_ready_poll(ctrl);
>  	if (status)
>  		return status;
> =20
> @@ -638,7 +637,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
>  	val |=3D (upper_32_bits(mbox_mem->dma) >> 2) << 2;
>  	iowrite32(val, db);
> =20
> -	status =3D be_mbox_db_ready_wait(ctrl);
> +	status =3D be_mbox_db_ready_poll(ctrl);
>  	if (status)
>  		return status;
> =20
> @@ -648,7 +647,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
>  	val |=3D (u32) (mbox_mem->dma >> 4) << 2;
>  	iowrite32(val, db);
> =20
> -	status =3D be_mbox_db_ready_wait(ctrl);
> +	status =3D be_mbox_db_ready_poll(ctrl);
>  	if (status)
>  		return status;
> =20
> @@ -656,7 +655,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
>  	udelay(1);
> =20
>  	if (be_mcc_compl_is_new(compl)) {
> -		status =3D be_mcc_compl_process(ctrl, &mbox->compl);
> +		status =3D beiscsi_process_mbox_compl(ctrl, compl);
>  		be_mcc_compl_use(compl);
>  		if (status) {
>  			beiscsi_log(phba, KERN_ERR,
> @@ -689,7 +688,7 @@ static int be_mbox_notify_wait(struct beiscsi_hba=
 *phba)
>  	struct be_mcc_compl *compl =3D &mbox->compl;
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
> =20
> -	status =3D be_mbox_db_ready_wait(ctrl);
> +	status =3D be_mbox_db_ready_poll(ctrl);
>  	if (status)
>  		return status;
> =20
> @@ -699,7 +698,7 @@ static int be_mbox_notify_wait(struct beiscsi_hba=
 *phba)
>  	iowrite32(val, db);
> =20
>  	/* wait for ready to be set */
> -	status =3D be_mbox_db_ready_wait(ctrl);
> +	status =3D be_mbox_db_ready_poll(ctrl);
>  	if (status !=3D 0)
>  		return status;
> =20
> @@ -708,7 +707,7 @@ static int be_mbox_notify_wait(struct beiscsi_hba=
 *phba)
>  	val |=3D (u32)(mbox_mem->dma >> 4) << 2;
>  	iowrite32(val, db);
> =20
> -	status =3D be_mbox_db_ready_wait(ctrl);
> +	status =3D be_mbox_db_ready_poll(ctrl);
>  	if (status !=3D 0)
>  		return status;
> =20
> diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/=
be_cmds.h
> index f50b32ac..b14ac01 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.h
> +++ b/drivers/scsi/be2iscsi/be_cmds.h
> @@ -732,9 +732,9 @@ void free_mcc_tag(struct be_ctrl_info *ctrl, unsi=
gned int tag);
> =20
>  int be_cmd_modify_eq_delay(struct beiscsi_hba *phba, struct be_set_e=
qd *,
>  			    int num);
> -int beiscsi_mccq_compl(struct beiscsi_hba *phba,
> -			uint32_t tag, struct be_mcc_wrb **wrb,
> -			struct be_dma_mem *mbx_cmd_mem);
> +int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
> +			    uint32_t tag, struct be_mcc_wrb **wrb,
> +			    struct be_dma_mem *mbx_cmd_mem);
>  /*ISCSI Functuions */
>  int be_cmd_fw_initialize(struct be_ctrl_info *ctrl);
>  int be_cmd_fw_uninit(struct be_ctrl_info *ctrl);
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi=
/be_iscsi.c
> index 633257b..09f89a3 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -735,7 +735,7 @@ static int beiscsi_get_initname(char *buf, struct=
 beiscsi_hba *phba)
>  		return -EBUSY;
>  	}
> =20
> -	rc =3D beiscsi_mccq_compl(phba, tag, &wrb, NULL);
> +	rc =3D beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
>  	if (rc) {
>  		beiscsi_log(phba, KERN_ERR,
>  			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> @@ -1143,7 +1143,7 @@ static int beiscsi_open_conn(struct iscsi_endpo=
int *ep,
>  		return -EAGAIN;
>  	}
> =20
> -	ret =3D beiscsi_mccq_compl(phba, tag, NULL, &nonemb_cmd);
> +	ret =3D beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
>  	if (ret) {
>  		beiscsi_log(phba, KERN_ERR,
>  			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> @@ -1302,7 +1302,7 @@ static int beiscsi_close_conn(struct  beiscsi_e=
ndpoint *beiscsi_ep, int flag)
>  		ret =3D -EAGAIN;
>  	}
> =20
> -	ret =3D beiscsi_mccq_compl(phba, tag, NULL, NULL);
> +	ret =3D beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
> =20
>  	/* Flush the CQ entries */
>  	beiscsi_flush_cq(phba);
> @@ -1377,7 +1377,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoin=
t *ep)
>  			    beiscsi_ep->ep_cid);
>  	}
> =20
> -	beiscsi_mccq_compl(phba, tag, NULL, NULL);
> +	beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
>  	beiscsi_close_conn(beiscsi_ep, tcp_upload_flag);
>  free_ep:
>  	msleep(BEISCSI_LOGOUT_SYNC_DELAY);
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 8b9d01a..dfc2ee9 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -286,7 +286,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>  		return FAILED;
>  	}
> =20
> -	rc =3D beiscsi_mccq_compl(phba, tag, NULL, &nonemb_cmd);
> +	rc =3D beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
>  	if (rc !=3D -EBUSY)
>  		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
>  				    nonemb_cmd.va, nonemb_cmd.dma);
> @@ -367,7 +367,7 @@ static int beiscsi_eh_device_reset(struct scsi_cm=
nd *sc)
>  		return FAILED;
>  	}
> =20
> -	rc =3D beiscsi_mccq_compl(phba, tag, NULL, &nonemb_cmd);
> +	rc =3D beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
>  	if (rc !=3D -EBUSY)
>  		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
>  				    nonemb_cmd.va, nonemb_cmd.dma);
> @@ -4394,7 +4394,7 @@ static int beiscsi_get_boot_info(struct beiscsi=
_hba *phba)
>  		goto boot_freemem;
>  	}
> =20
> -	ret =3D beiscsi_mccq_compl(phba, tag, NULL, &nonemb_cmd);
> +	ret =3D beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
>  	if (ret) {
>  		beiscsi_log(phba, KERN_ERR,
>  			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> @@ -5424,7 +5424,7 @@ static void be_eqd_update(struct beiscsi_hba *p=
hba)
>  	if (num) {
>  		tag =3D be_cmd_modify_eq_delay(phba, set_eqd, num);
>  		if (tag)
> -			beiscsi_mccq_compl(phba, tag, NULL, NULL);
> +			beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
>  	}
>  }
> =20
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/=
be_mgmt.c
> index a88e636..85044b8 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -942,7 +942,7 @@ unsigned int mgmt_get_all_if_id(struct beiscsi_hb=
a *phba)
>  	be_mcc_notify(phba, tag);
>  	mutex_unlock(&ctrl->mbox_lock);
> =20
> -	status =3D beiscsi_mccq_compl(phba, tag, &wrb, NULL);
> +	status =3D beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
>  	if (status) {
>  		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
>  			    "BG_%d : Failed in mgmt_get_all_if_id\n");
> @@ -993,7 +993,7 @@ static int mgmt_exec_nonemb_cmd(struct beiscsi_hb=
a *phba,
>  	be_mcc_notify(phba, tag);
>  	mutex_unlock(&ctrl->mbox_lock);
> =20
> -	rc =3D beiscsi_mccq_compl(phba, tag, NULL, nonemb_cmd);
> +	rc =3D beiscsi_mccq_compl_wait(phba, tag, NULL, nonemb_cmd);
> =20
>  	if (resp_buf)
>  		memcpy(resp_buf, nonemb_cmd->va, resp_buf_len);
> @@ -1427,7 +1427,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba=
 *phba,
>  			return -EAGAIN;
>  		}
> =20
> -		rc =3D beiscsi_mccq_compl(phba, tag, &wrb, NULL);
> +		rc =3D beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
>  		if (rc) {
>  			beiscsi_log(phba, KERN_ERR,
>  				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> @@ -1461,7 +1461,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba=
 *phba,
>  			return -EAGAIN;
>  		}
> =20
> -		rc =3D beiscsi_mccq_compl(phba, tag, NULL, NULL);
> +		rc =3D beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
>  		if (rc) {
>  			beiscsi_log(phba, KERN_ERR,
>  				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> @@ -1503,7 +1503,7 @@ int mgmt_set_vlan(struct beiscsi_hba *phba,
>  		return -EBUSY;
>  	}
> =20
> -	rc =3D beiscsi_mccq_compl(phba, tag, NULL, NULL);
> +	rc =3D beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
>  	if (rc) {
>  		beiscsi_log(phba, KERN_ERR,
>  			    (BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX),
> @@ -1869,7 +1869,7 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *=
phba,
>  	be_mcc_notify(phba, tag);
>  	mutex_unlock(&ctrl->mbox_lock);
> =20
> -	rc =3D beiscsi_mccq_compl(phba, tag, &wrb, NULL);
> +	rc =3D beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
>  	if (rc) {
>  		beiscsi_log(phba, KERN_ERR,
>  			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> --=20
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
