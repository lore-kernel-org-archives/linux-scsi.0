Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39874C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E1A21A4A
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AYyqgmUd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389714AbfKEPUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:20:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28658 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389386AbfKEPUJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572967207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XRtbX7RW4ULvzEQAg0+iQLSPTgX30Momf/a5mozdRng=;
        b=AYyqgmUdtOwOsHoAwsyQul8c2/wiMEObr+EjjZc4556pzyIPKQcF1zk5kW+8g25u6XV23W
        jT7eglS0SPohlExLDF7HGq1HEIrh6KzLZoV9YLTfQ2J37oLBybKzXC8TLt2P5YTDz+/I7R
        nxDCQOUJs7IE20NnPm6BzyEZ+Uqu2fQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-5xpoJZGzOeKrl2Rx8LLjzg-1; Tue, 05 Nov 2019 10:20:06 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F09A71005500;
        Tue,  5 Nov 2019 15:20:04 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71A5E608B8;
        Tue,  5 Nov 2019 15:20:04 +0000 (UTC)
Message-ID: <c3731b3424c15946a61cedfdef905aecb5ce44c1.camel@redhat.com>
Subject: Re: [PATCH 5/8] qla2xxx: Fix double scsi_done for abort path
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 05 Nov 2019 10:20:03 -0500
In-Reply-To: <20191105150657.8092-6-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
         <20191105150657.8092-6-hmadhani@marvell.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 5xpoJZGzOeKrl2Rx8LLjzg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-11-05 at 07:06 -0800, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
>=20
> Current code assume abort will remove the original command from the
> active list where scsi_done will not be call. Instead, the eh_abort
> thread will do the scsi_done. That is not the case.  Instead, we
> have a double scsi_done calls triggering use after free.
>=20
> Abort will tell FW to release the command from FW possesion. The
> original command will return to ULP with error in its normal fashion via
> scsi_done.  eh_abort path would wait for the original command
> completion before returning.  eh_abort path will not perform the
> scsi_done call.
>=20
> Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for=
 aborting SCSI commands")
> Cc: stable@vger.kernel.org # 5.2
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  |   5 +-
>  drivers/scsi/qla2xxx/qla_isr.c  |   5 ++
>  drivers/scsi/qla2xxx/qla_nvme.c |   4 +-
>  drivers/scsi/qla2xxx/qla_os.c   | 117 +++++++++++++++++++++-------------=
------
>  4 files changed, 72 insertions(+), 59 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index ef9bb3c7ad6f..2a9e6a9a8c9d 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -591,13 +591,16 @@ typedef struct srb {
>  =09 */
>  =09uint8_t cmd_type;
>  =09uint8_t pad[3];
> -=09atomic_t ref_count;
>  =09struct kref cmd_kref;=09/* need to migrate ref_count over to this */
>  =09void *priv;
>  =09wait_queue_head_t nvme_ls_waitq;
>  =09struct fc_port *fcport;
>  =09struct scsi_qla_host *vha;
>  =09unsigned int start_timer:1;
> +=09unsigned int abort:1;
> +=09unsigned int aborted:1;
> +=09unsigned int completed:1;
> +
>  =09uint32_t handle;
>  =09uint16_t flags;
>  =09uint16_t type;
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index acef3d73983c..1b8f297449cf 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2487,6 +2487,11 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct =
rsp_que *rsp, void *pkt)
>  =09=09return;
>  =09}
> =20
> +=09if (sp->abort)
> +=09=09sp->aborted =3D 1;
> +=09else
> +=09=09sp->completed =3D 1;
> +
>  =09if (sp->cmd_type !=3D TYPE_SRB) {
>  =09=09req->outstanding_cmds[handle] =3D NULL;
>  =09=09ql_dbg(ql_dbg_io, vha, 0x3015,
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 6cc19e060afc..941aa53363f5 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -224,8 +224,8 @@ static void qla_nvme_abort_work(struct work_struct *w=
ork)
> =20
>  =09if (ha->flags.host_shutting_down) {
>  =09=09ql_log(ql_log_info, sp->fcport->vha, 0xffff,
> -=09=09    "%s Calling done on sp: %p, type: 0x%x, sp->ref_count: 0x%x\n"=
,
> -=09=09    __func__, sp, sp->type, atomic_read(&sp->ref_count));
> +=09=09    "%s Calling done on sp: %p, type: 0x%x\n",
> +=09=09    __func__, sp, sp->type);
>  =09=09sp->done(sp, 0);
>  =09=09goto out;
>  =09}
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 2e7a4a2d6c5a..b59d579834ea 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -698,11 +698,6 @@ void qla2x00_sp_compl(srb_t *sp, int res)
>  =09struct scsi_cmnd *cmd =3D GET_CMD_SP(sp);
>  =09struct completion *comp =3D sp->comp;
> =20
> -=09if (WARN_ON_ONCE(atomic_read(&sp->ref_count) =3D=3D 0))
> -=09=09return;
> -
> -=09atomic_dec(&sp->ref_count);
> -
>  =09sp->free(sp);
>  =09cmd->result =3D res;
>  =09CMD_SP(cmd) =3D NULL;
> @@ -794,11 +789,6 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>  =09struct scsi_cmnd *cmd =3D GET_CMD_SP(sp);
>  =09struct completion *comp =3D sp->comp;
> =20
> -=09if (WARN_ON_ONCE(atomic_read(&sp->ref_count) =3D=3D 0))
> -=09=09return;
> -
> -=09atomic_dec(&sp->ref_count);
> -
>  =09sp->free(sp);
>  =09cmd->result =3D res;
>  =09CMD_SP(cmd) =3D NULL;
> @@ -903,7 +893,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct s=
csi_cmnd *cmd)
> =20
>  =09sp->u.scmd.cmd =3D cmd;
>  =09sp->type =3D SRB_SCSI_CMD;
> -=09atomic_set(&sp->ref_count, 1);
> +
>  =09CMD_SP(cmd) =3D (void *)sp;
>  =09sp->free =3D qla2x00_sp_free_dma;
>  =09sp->done =3D qla2x00_sp_compl;
> @@ -985,11 +975,9 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct=
 scsi_cmnd *cmd,
> =20
>  =09sp->u.scmd.cmd =3D cmd;
>  =09sp->type =3D SRB_SCSI_CMD;
> -=09atomic_set(&sp->ref_count, 1);
>  =09CMD_SP(cmd) =3D (void *)sp;
>  =09sp->free =3D qla2xxx_qpair_sp_free_dma;
>  =09sp->done =3D qla2xxx_qpair_sp_compl;
> -=09sp->qpair =3D qpair;
> =20
>  =09rval =3D ha->isp_ops->start_scsi_mq(sp);
>  =09if (rval !=3D QLA_SUCCESS) {
> @@ -1187,16 +1175,6 @@ qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
>  =09return return_status;
>  }
> =20
> -static int
> -sp_get(struct srb *sp)
> -{
> -=09if (!refcount_inc_not_zero((refcount_t *)&sp->ref_count))
> -=09=09/* kref get fail */
> -=09=09return ENXIO;
> -=09else
> -=09=09return 0;
> -}
> -
>  #define ISP_REG_DISCONNECT 0xffffffffU
>  /***********************************************************************=
***
>  * qla2x00_isp_reg_stat
> @@ -1252,6 +1230,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>  =09uint64_t lun;
>  =09int rval;
>  =09struct qla_hw_data *ha =3D vha->hw;
> +=09uint32_t ratov_j;
> +=09struct qla_qpair *qpair;
> +=09unsigned long flags;
> =20
>  =09if (qla2x00_isp_reg_stat(ha)) {
>  =09=09ql_log(ql_log_info, vha, 0x8042,
> @@ -1264,13 +1245,26 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>  =09=09return ret;
> =20
>  =09sp =3D scsi_cmd_priv(cmd);
> +=09qpair =3D sp->qpair;
> =20
> -=09if (sp->fcport && sp->fcport->deleted)
> +=09if ((sp->fcport && sp->fcport->deleted) || !qpair)
>  =09=09return SUCCESS;
> =20
> -=09/* Return if the command has already finished. */
> -=09if (sp_get(sp))
> +=09spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> +=09if (sp->completed) {
> +=09=09spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
>  =09=09return SUCCESS;
> +=09}
> +
> +=09if (sp->abort || sp->aborted) {
> +=09=09spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> +=09=09return FAILED;
> +=09}
> +
> +=09sp->abort =3D 1;
> +=09sp->comp =3D &comp;
> +=09spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> +
> =20
>  =09id =3D cmd->device->id;
>  =09lun =3D cmd->device->lun;
> @@ -1279,47 +1273,37 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>  =09    "Aborting from RISC nexus=3D%ld:%d:%llu sp=3D%p cmd=3D%p handle=
=3D%x\n",
>  =09    vha->host_no, id, lun, sp, cmd, sp->handle);
> =20
> +=09/*
> +=09 * Abort will release the original Command/sp from FW. Let the
> +=09 * original command call scsi_done. In return, he will wakeup
> +=09 * this sleeping thread.
> +=09 */
>  =09rval =3D ha->isp_ops->abort_command(sp);
> +
>  =09ql_dbg(ql_dbg_taskm, vha, 0x8003,
>  =09       "Abort command mbx cmd=3D%p, rval=3D%x.\n", cmd, rval);
> =20
> +=09/* Wait for the command completion. */
> +=09ratov_j =3D ha->r_a_tov/10 * 4 * 1000;
> +=09ratov_j =3D msecs_to_jiffies(ratov_j);
>  =09switch (rval) {
>  =09case QLA_SUCCESS:
> -=09=09/*
> -=09=09 * The command has been aborted. That means that the firmware
> -=09=09 * won't report a completion.
> -=09=09 */
> -=09=09sp->done(sp, DID_ABORT << 16);
> -=09=09ret =3D SUCCESS;
> -=09=09break;
> -=09case QLA_FUNCTION_PARAMETER_ERROR: {
> -=09=09/* Wait for the command completion. */
> -=09=09uint32_t ratov =3D ha->r_a_tov/10;
> -=09=09uint32_t ratov_j =3D msecs_to_jiffies(4 * ratov * 1000);
> -
> -=09=09WARN_ON_ONCE(sp->comp);
> -=09=09sp->comp =3D &comp;
>  =09=09if (!wait_for_completion_timeout(&comp, ratov_j)) {
>  =09=09=09ql_dbg(ql_dbg_taskm, vha, 0xffff,
>  =09=09=09    "%s: Abort wait timer (4 * R_A_TOV[%d]) expired\n",
> -=09=09=09    __func__, ha->r_a_tov);
> +=09=09=09    __func__, ha->r_a_tov/10);
>  =09=09=09ret =3D FAILED;
>  =09=09} else {
>  =09=09=09ret =3D SUCCESS;
>  =09=09}
>  =09=09break;
> -=09}
>  =09default:
> -=09=09/*
> -=09=09 * Either abort failed or abort and completion raced. Let
> -=09=09 * the SCSI core retry the abort in the former case.
> -=09=09 */
>  =09=09ret =3D FAILED;
>  =09=09break;
>  =09}
> =20
>  =09sp->comp =3D NULL;
> -=09atomic_dec(&sp->ref_count);
> +
>  =09ql_log(ql_log_info, vha, 0x801c,
>  =09    "Abort command issued nexus=3D%ld:%d:%llu -- %x.\n",
>  =09    vha->host_no, id, lun, ret);
> @@ -1711,32 +1695,53 @@ static void qla2x00_abort_srb(struct qla_qpair *q=
p, srb_t *sp, const int res,
>  =09scsi_qla_host_t *vha =3D qp->vha;
>  =09struct qla_hw_data *ha =3D vha->hw;
>  =09int rval;
> +=09bool ret_cmd;
> +=09uint32_t ratov_j;
> =20
> -=09if (sp_get(sp))
> +=09if (qla2x00_chip_is_down(vha)) {
> +=09=09sp->done(sp, res);
>  =09=09return;
> +=09}
> =20
>  =09if (sp->type =3D=3D SRB_NVME_CMD || sp->type =3D=3D SRB_NVME_LS ||
>  =09    (sp->type =3D=3D SRB_SCSI_CMD && !ha->flags.eeh_busy &&
>  =09     !test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) &&
>  =09     !qla2x00_isp_reg_stat(ha))) {
> +=09=09if (sp->comp) {
> +=09=09=09sp->done(sp, res);
> +=09=09=09return;
> +=09=09}
> +
>  =09=09sp->comp =3D &comp;
> +=09=09sp->abort =3D  1;
>  =09=09spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
> -=09=09rval =3D ha->isp_ops->abort_command(sp);
> =20
> +=09=09rval =3D ha->isp_ops->abort_command(sp);
> +=09=09/* Wait for command completion. */
> +=09=09ret_cmd =3D false;
> +=09=09ratov_j =3D ha->r_a_tov/10 * 4 * 1000;
> +=09=09ratov_j =3D msecs_to_jiffies(ratov_j);
>  =09=09switch (rval) {
>  =09=09case QLA_SUCCESS:
> -=09=09=09sp->done(sp, res);
> +=09=09=09if (wait_for_completion_timeout(&comp, ratov_j)) {
> +=09=09=09=09ql_dbg(ql_dbg_taskm, vha, 0xffff,
> +=09=09=09=09    "%s: Abort wait timer (4 * R_A_TOV[%d]) expired\n",
> +=09=09=09=09    __func__, ha->r_a_tov/10);
> +=09=09=09=09ret_cmd =3D true;
> +=09=09=09}
> +=09=09=09/* else FW return SP to driver */
>  =09=09=09break;
> -=09=09case QLA_FUNCTION_PARAMETER_ERROR:
> -=09=09=09wait_for_completion(&comp);
> +=09=09default:
> +=09=09=09ret_cmd =3D true;
>  =09=09=09break;
>  =09=09}
> =20
>  =09=09spin_lock_irqsave(qp->qp_lock_ptr, *flags);
> -=09=09sp->comp =3D NULL;
> +=09=09if (ret_cmd && (!sp->completed || !sp->aborted))
> +=09=09=09sp->done(sp, res);
> +=09} else {
> +=09=09sp->done(sp, res);
>  =09}
> -
> -=09atomic_dec(&sp->ref_count);
>  }
> =20
>  static void
> @@ -1758,7 +1763,6 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int =
res)
>  =09for (cnt =3D 1; cnt < req->num_outstanding_cmds; cnt++) {
>  =09=09sp =3D req->outstanding_cmds[cnt];
>  =09=09if (sp) {
> -=09=09=09req->outstanding_cmds[cnt] =3D NULL;
>  =09=09=09switch (sp->cmd_type) {
>  =09=09=09case TYPE_SRB:
>  =09=09=09=09qla2x00_abort_srb(qp, sp, res, &flags);
> @@ -1780,6 +1784,7 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int =
res)
>  =09=09=09default:
>  =09=09=09=09break;
>  =09=09=09}
> +=09=09=09req->outstanding_cmds[cnt] =3D NULL;
>  =09=09}
>  =09}
>  =09spin_unlock_irqrestore(qp->qp_lock_ptr, flags);

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

