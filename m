Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99437C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BA3320728
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:26:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eiMauwgk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgJ2U0m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:26:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2U0m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 16:26:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKOdUi088305;
        Thu, 29 Oct 2020 20:26:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=cewnAIybTuW8aNIDiwdqYB8cymLXFQRm4ftEkXmt6Ig=;
 b=eiMauwgksryynnBig5ovRMwOaIqQ8quTMSUAkgdbNq0s7LI4YC6HpJbKa6gRqrSD91Cm
 7Zm4lecbZxH9KgM142eX8LztCEuxFA+WLNAM1ZID2RztsasZEV3OvVNxKcEhQVmYYtU6
 ATYJWSvG3fNqoXAF2doV4HGjxFlNIh/IurErm39eb4h8AgBiMD3i4T0bKown7hxp8iUO
 1JSxN6FmJiTr0G/PyLtUVgxiLsTsMtABhyiNJbJJIbUzgoyZy94VOmwxfOEWwCsGek1/
 tVjH1Iv49Vkp+P22o5WmzePUCYIb4cQfmQI59QBKc/4Yry8SOh7mcktXylsk7vaWTDIb Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm4cg5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:26:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKLR7j183219;
        Thu, 29 Oct 2020 20:26:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx6yw5cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:26:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TKQcGN006967;
        Thu, 29 Oct 2020 20:26:38 GMT
Received: from dhcp-10-154-184-179.vpn.oracle.com (/10.154.184.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:26:38 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 5/8] tcm qla: move sess cmd list/lock to driver
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1603954171-11621-6-git-send-email-michael.christie@oracle.com>
Date:   Thu, 29 Oct 2020 15:26:36 -0500
Cc:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <F39A56C6-BD84-45BD-A8B4-5C7729D0CE08@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-6-git-send-email-michael.christie@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=11
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=11 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Same comment as patch 3. Please just use =E2=80=9Cqla2xxx=E2=80=9D in =
subject here.

> On Oct 29, 2020, at 1:49 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> Except for debug output in the shutdown path, tcm qla2xxx is the only
> driver using the se_session sess_cmd_list. This moves the list to that
> driver so in the next patches we can remove the sess_cmd_lock from the
> main IO path for the rest of the drivers.
>=20
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h     |  2 ++
> drivers/scsi/qla2xxx/qla_init.c    |  3 ++
> drivers/scsi/qla2xxx/qla_target.c  |  1 +
> drivers/scsi/qla2xxx/qla_target.h  |  1 +
> drivers/scsi/qla2xxx/tcm_qla2xxx.c | 57 =
+++++++++++++++++++++++---------------
> 5 files changed, 42 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index 4f0486f..ed9b10f 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2493,6 +2493,8 @@ enum rscn_addr_format {
> 	int generation;
>=20
> 	struct se_session *se_sess;
> +	struct list_head sess_cmd_list;
> +	spinlock_t sess_cmd_lock;
> 	struct kref sess_kref;
> 	struct qla_tgt *tgt;
> 	unsigned long expires;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 898c70b..5626e9b 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4974,6 +4974,9 @@ void qla2x00_set_fcport_state(fc_port_t *fcport, =
int state)
> 	INIT_LIST_HEAD(&fcport->gnl_entry);
> 	INIT_LIST_HEAD(&fcport->list);
>=20
> +	INIT_LIST_HEAD(&fcport->sess_cmd_list);
> +	spin_lock_init(&fcport->sess_cmd_lock);
> +
> 	return fcport;
> }
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c =
b/drivers/scsi/qla2xxx/qla_target.c
> index f88548b..6603cad 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4292,6 +4292,7 @@ static struct qla_tgt_cmd =
*qlt_get_tag(scsi_qla_host_t *vha,
>=20
> 	cmd->cmd_type =3D TYPE_TGT_CMD;
> 	memcpy(&cmd->atio, atio, sizeof(*atio));
> +	INIT_LIST_HEAD(&cmd->sess_cmd_list);
> 	cmd->state =3D QLA_TGT_STATE_NEW;
> 	cmd->tgt =3D vha->vha_tgt.qla_tgt;
> 	qlt_incr_num_pend_cmds(vha);
> diff --git a/drivers/scsi/qla2xxx/qla_target.h =
b/drivers/scsi/qla2xxx/qla_target.h
> index 1cff7c6..10e5e6c8 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -856,6 +856,7 @@ struct qla_tgt_cmd {
> 	uint8_t cmd_type;
> 	uint8_t pad[7];
> 	struct se_cmd se_cmd;
> +	struct list_head sess_cmd_list;
> 	struct fc_port *sess;
> 	struct qla_qpair *qpair;
> 	uint32_t reset_count;
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c =
b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index f5a91bf..e122da9 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -255,6 +255,7 @@ static void tcm_qla2xxx_free_mcmd(struct =
qla_tgt_mgmt_cmd *mcmd)
> static void tcm_qla2xxx_complete_free(struct work_struct *work)
> {
> 	struct qla_tgt_cmd *cmd =3D container_of(work, struct =
qla_tgt_cmd, work);
> +	unsigned long flags;
>=20
> 	cmd->cmd_in_wq =3D 0;
>=20
> @@ -265,6 +266,10 @@ static void tcm_qla2xxx_complete_free(struct =
work_struct *work)
> 	cmd->trc_flags |=3D TRC_CMD_FREE;
> 	cmd->cmd_sent_to_fw =3D 0;
>=20
> +	spin_lock_irqsave(&cmd->sess->sess_cmd_lock, flags);
> +	list_del_init(&cmd->sess_cmd_list);
> +	spin_unlock_irqrestore(&cmd->sess->sess_cmd_lock, flags);
> +
> 	transport_generic_free_cmd(&cmd->se_cmd, 0);
> }
>=20
> @@ -451,13 +456,14 @@ static int =
tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
> 	struct se_portal_group *se_tpg;
> 	struct tcm_qla2xxx_tpg *tpg;
> #endif
> -	int flags =3D TARGET_SCF_ACK_KREF;
> +	int target_flags =3D TARGET_SCF_ACK_KREF;
> +	unsigned long flags;
>=20
> 	if (bidi)
> -		flags |=3D TARGET_SCF_BIDI_OP;
> +		target_flags |=3D TARGET_SCF_BIDI_OP;
>=20
> 	if (se_cmd->cpuid !=3D WORK_CPU_UNBOUND)
> -		flags |=3D TARGET_SCF_USE_CPUID;
> +		target_flags |=3D TARGET_SCF_USE_CPUID;
>=20
> 	sess =3D cmd->sess;
> 	if (!sess) {
> @@ -479,11 +485,15 @@ static int =
tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
> 		return 0;
> 	}
> #endif
> -
> 	cmd->qpair->tgt_counters.qla_core_sbt_cmd++;
> +
> +	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
> +	list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
> +	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
> +
> 	return target_submit_cmd(se_cmd, se_sess, cdb, =
&cmd->sense_buffer[0],
> -				cmd->unpacked_lun, data_length, =
fcp_task_attr,
> -				data_dir, flags);
> +				 cmd->unpacked_lun, data_length, =
fcp_task_attr,
> +				 data_dir, target_flags);
> }
>=20
> static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
> @@ -617,25 +627,20 @@ static int tcm_qla2xxx_handle_tmr(struct =
qla_tgt_mgmt_cmd *mcmd, u64 lun,
> static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port =
*sess,
>     uint64_t tag)
> {
> -	struct qla_tgt_cmd *cmd =3D NULL;
> -	struct se_cmd *secmd;
> +	struct qla_tgt_cmd *cmd;
> 	unsigned long flags;
>=20
> 	if (!sess->se_sess)
> 		return NULL;
>=20
> -	spin_lock_irqsave(&sess->se_sess->sess_cmd_lock, flags);
> -	list_for_each_entry(secmd, &sess->se_sess->sess_cmd_list, =
se_cmd_list) {
> -		/* skip task management functions, including =
tmr->task_cmd */
> -		if (secmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> -			continue;
> -
> -		if (secmd->tag =3D=3D tag) {
> -			cmd =3D container_of(secmd, struct qla_tgt_cmd, =
se_cmd);
> -			break;
> -		}
> +	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
> +	list_for_each_entry(cmd, &sess->sess_cmd_list, sess_cmd_list) {
> +		if (cmd->se_cmd.tag =3D=3D tag)
> +			goto done;
> 	}
> -	spin_unlock_irqrestore(&sess->se_sess->sess_cmd_lock, flags);
> +	cmd =3D NULL;
> +done:
> +	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
>=20
> 	return cmd;
> }
> @@ -765,11 +770,19 @@ static void tcm_qla2xxx_queue_tm_rsp(struct =
se_cmd *se_cmd)
>=20
> static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
> {
> -	struct qla_tgt_cmd *cmd =3D container_of(se_cmd,
> -				struct qla_tgt_cmd, se_cmd);
> +	struct qla_tgt_cmd *cmd;
> +	unsigned long flags;
>=20
> -	if (qlt_abort_cmd(cmd))
> +	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> 		return;
> +
> +	cmd  =3D container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
> +
> +	spin_lock_irqsave(&cmd->sess->sess_cmd_lock, flags);
> +	list_del_init(&cmd->sess_cmd_list);
> +	spin_unlock_irqrestore(&cmd->sess->sess_cmd_lock, flags);
> +
> +	qlt_abort_cmd(cmd);
> }
>=20
> static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *,
> --=20
> 1.8.3.1
>=20

Other than small nit for the subject,=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

