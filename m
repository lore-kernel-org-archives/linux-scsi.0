Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36ADAC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA56120756
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kaRCvetk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgJ2U2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:28:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50320 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2U2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 16:28:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKPIjm182236;
        Thu, 29 Oct 2020 20:28:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=pI35sNMPqfXq+lKXa7Zp5zu3yHKzJG2f2ABNS7PVTbQ=;
 b=kaRCvetkiG105499y3WVyaW67TVzOjMERXbndb2dZdZ7XvZs5Nk3gbEuIPSVv4AbwYMW
 EORq0nR5pJEhIkx+ZHjXFZRAs0yIJfcCMsNqcAsh+w/1qWcQKoxT6pFKorxzSGlOK71X
 E/cr/53tPtBJlvlmTR/dyjAlRmms6a6FHAT3l2ns73Poul4aV0hnSblm8d0c0Z3mTZr+
 efHNjt/Dz14QxV+nmjaKdHCejq4sQqQGAQ1EmvQ8cvBJznp1JEkwcErcwz7Zg4g2Y5xh
 u6ahQPfzSPV2k1NRAKiunTz/jp3App7IApW2wbuGkryLCL3/tLqqRn3HCfDT3dJyN0RS qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sb71yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:28:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKKDFX110509;
        Thu, 29 Oct 2020 20:28:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx60x66s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:28:20 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TKSIOD009828;
        Thu, 29 Oct 2020 20:28:18 GMT
Received: from dhcp-10-154-184-179.vpn.oracle.com (/10.154.184.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:28:18 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 6/8] target: Drop sess_cmd_lock from IO path
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1603954171-11621-7-git-send-email-michael.christie@oracle.com>
Date:   Thu, 29 Oct 2020 15:28:17 -0500
Cc:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <74583FB7-EF34-4F01-8191-D87450E58E5A@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-7-git-send-email-michael.christie@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=11 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=11
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 29, 2020, at 1:49 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> To remove the sess_cmd_lock this patch does:
>=20
> - Removes the sess_cmd_list use from lio core, because it's been
> moved to qla2xxx.
>=20
> - Removes sess_tearing_down check in the IO path. Instead of using
> that bit and the sess_cmd_lock, we rely on the cmd_count percpu
> ref. To do this we switch to
> percpu_ref_kill_and_confirm/percpu_ref_tryget_live.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> drivers/infiniband/ulp/isert/ib_isert.c |  2 +-
> drivers/infiniband/ulp/srpt/ib_srpt.c   |  2 +-
> drivers/scsi/qla2xxx/tcm_qla2xxx.c      |  9 +---
> drivers/target/target_core_tpg.c        |  2 +-
> drivers/target/target_core_transport.c  | 77 =
++++++++++++++-------------------
> drivers/target/tcm_fc/tfc_sess.c        |  2 +-
> include/target/target_core_base.h       |  6 +--
> include/target/target_core_fabric.h     |  2 +-
> 8 files changed, 43 insertions(+), 59 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c =
b/drivers/infiniband/ulp/isert/ib_isert.c
> index 436e17f..3d21bf3 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -2471,7 +2471,7 @@ static void isert_release_work(struct =
work_struct *work)
> 	isert_info("iscsi_conn %p\n", conn);
>=20
> 	if (conn->sess) {
> -		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
> +		target_stop_session(conn->sess->se_sess);
> 		target_wait_for_sess_cmds(conn->sess->se_sess);
> 	}
> }
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c =
b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 0065eb1..8377113 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2084,7 +2084,7 @@ static void srpt_release_channel_work(struct =
work_struct *w)
> 	se_sess =3D ch->sess;
> 	BUG_ON(!se_sess);
>=20
> -	target_sess_cmd_list_set_waiting(se_sess);
> +	target_stop_session(se_sess);
> 	target_wait_for_sess_cmds(se_sess);
>=20
> 	target_remove_session(se_sess);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c =
b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index e122da9..784b43f 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -368,15 +368,10 @@ static void tcm_qla2xxx_put_sess(struct fc_port =
*sess)
> static void tcm_qla2xxx_close_session(struct se_session *se_sess)
> {
> 	struct fc_port *sess =3D se_sess->fabric_sess_ptr;
> -	struct scsi_qla_host *vha;
> -	unsigned long flags;
>=20
> 	BUG_ON(!sess);
> -	vha =3D sess->vha;
>=20
> -	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> -	target_sess_cmd_list_set_waiting(se_sess);
> -	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> +	target_stop_session(se_sess);
>=20
> 	sess->explicit_logout =3D 1;
> 	tcm_qla2xxx_put_sess(sess);
> @@ -831,7 +826,7 @@ static void =
tcm_qla2xxx_clear_nacl_from_fcport_map(struct fc_port *sess)
>=20
> static void tcm_qla2xxx_shutdown_sess(struct fc_port *sess)
> {
> -	target_sess_cmd_list_set_waiting(sess->se_sess);
> +	target_stop_session(sess->se_sess);
> }
>=20
> static int tcm_qla2xxx_init_nodeacl(struct se_node_acl *se_nacl,
> diff --git a/drivers/target/target_core_tpg.c =
b/drivers/target/target_core_tpg.c
> index 62aa5fa..736847c 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -328,7 +328,7 @@ static void target_shutdown_sessions(struct =
se_node_acl *acl)
> restart:
> 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
> 	list_for_each_entry(sess, &acl->acl_sess_list, sess_acl_list) {
> -		if (sess->sess_tearing_down)
> +		if (atomic_read(&sess->stopped))
> 			continue;
>=20
> 		list_del_init(&sess->sess_acl_list);
> diff --git a/drivers/target/target_core_transport.c =
b/drivers/target/target_core_transport.c
> index 465b6583..b228c66 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -215,7 +215,7 @@ static void target_release_sess_cmd_refcnt(struct =
percpu_ref *ref)
> {
> 	struct se_session *sess =3D container_of(ref, typeof(*sess), =
cmd_count);
>=20
> -	wake_up(&sess->cmd_list_wq);
> +	wake_up(&sess->cmd_count_wq);
> }
>=20
> /**
> @@ -228,9 +228,10 @@ int transport_init_session(struct se_session =
*se_sess)
> {
> 	INIT_LIST_HEAD(&se_sess->sess_list);
> 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
> -	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
> 	spin_lock_init(&se_sess->sess_cmd_lock);
> -	init_waitqueue_head(&se_sess->cmd_list_wq);
> +	init_waitqueue_head(&se_sess->cmd_count_wq);
> +	init_completion(&se_sess->stop_done);
> +	atomic_set(&se_sess->stopped, 0);
> 	return percpu_ref_init(&se_sess->cmd_count,
> 			       target_release_sess_cmd_refcnt, 0, =
GFP_KERNEL);
> }
> @@ -239,11 +240,11 @@ int transport_init_session(struct se_session =
*se_sess)
> void transport_uninit_session(struct se_session *se_sess)
> {
> 	/*
> -	 * Drivers like iscsi and loop do not call
> -	 * target_sess_cmd_list_set_waiting during session shutdown so =
we
> -	 * have to drop the ref taken at init time here.
> +	 * Drivers like iscsi and loop do not call target_stop_session
> +	 * during session shutdown so we have to drop the ref taken at =
init
> +	 * time here.
> 	 */
> -	if (!se_sess->sess_tearing_down)
> +	if (!atomic_read(&se_sess->stopped))
> 		percpu_ref_put(&se_sess->cmd_count);
>=20
> 	percpu_ref_exit(&se_sess->cmd_count);
> @@ -1632,9 +1633,8 @@ int target_submit_cmd_map_sgls(struct se_cmd =
*se_cmd, struct se_session *se_sess
> 	if (flags & TARGET_SCF_UNKNOWN_SIZE)
> 		se_cmd->unknown_data_length =3D 1;
> 	/*
> -	 * Obtain struct se_cmd->cmd_kref reference and add new cmd to
> -	 * se_sess->sess_cmd_list.  A second kref_get here is necessary
> -	 * for fabrics using TARGET_SCF_ACK_KREF that expect a second
> +	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get =
here is
> +	 * necessary for fabrics using TARGET_SCF_ACK_KREF that expect a =
second
> 	 * kref_put() to happen during fabric packet acknowledgement.
> 	 */
> 	ret =3D target_get_sess_cmd(se_cmd, flags & =
TARGET_SCF_ACK_KREF);
> @@ -2763,14 +2763,13 @@ int transport_generic_free_cmd(struct se_cmd =
*cmd, int wait_for_tasks)
> EXPORT_SYMBOL(transport_generic_free_cmd);
>=20
> /**
> - * target_get_sess_cmd - Add command to active ->sess_cmd_list
> + * target_get_sess_cmd - Verify the session is accepting cmds and =
take ref
>  * @se_cmd:	command descriptor to add
>  * @ack_kref:	Signal that fabric will perform an ack =
target_put_sess_cmd()
>  */
> int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
> {
> 	struct se_session *se_sess =3D se_cmd->se_sess;
> -	unsigned long flags;
> 	int ret =3D 0;
>=20
> 	/*
> @@ -2785,15 +2784,8 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, =
bool ack_kref)
> 		se_cmd->se_cmd_flags |=3D SCF_ACK_KREF;
> 	}
>=20
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -	if (se_sess->sess_tearing_down) {
> +	if (!percpu_ref_tryget_live(&se_sess->cmd_count))
> 		ret =3D -ESHUTDOWN;
> -		goto out;
> -	}
> -	list_add_tail(&se_cmd->se_cmd_list, &se_sess->sess_cmd_list);
> -	percpu_ref_get(&se_sess->cmd_count);
> -out:
> -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>=20
> 	if (ret && ack_kref)
> 		target_put_sess_cmd(se_cmd);
> @@ -2818,13 +2810,6 @@ static void target_release_cmd_kref(struct kref =
*kref)
> 	struct se_session *se_sess =3D se_cmd->se_sess;
> 	struct completion *free_compl =3D se_cmd->free_compl;
> 	struct completion *abrt_compl =3D se_cmd->abrt_compl;
> -	unsigned long flags;
> -
> -	if (se_sess) {
> -		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -		list_del_init(&se_cmd->se_cmd_list);
> -		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> -	}
>=20
> 	target_free_cmd_mem(se_cmd);
> 	se_cmd->se_tfo->release_cmd(se_cmd);
> @@ -2952,21 +2937,25 @@ void target_show_cmd(const char *pfx, struct =
se_cmd *cmd)
> }
> EXPORT_SYMBOL(target_show_cmd);
>=20
> +static void target_stop_session_confirm(struct percpu_ref *ref)
> +{
> +	struct se_session *se_sess =3D container_of(ref, struct =
se_session,
> +						  cmd_count);
> +	complete_all(&se_sess->stop_done);
> +}
> +
> /**
> - * target_sess_cmd_list_set_waiting - Set sess_tearing_down so no new =
commands are queued.
> - * @se_sess:	session to flag
> + * target_stop_session - Stop new IO from being queued on the =
session.
> + * @se_sess:    session to stop
>  */
> -void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
> +void target_stop_session(struct se_session *se_sess)
> {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -	se_sess->sess_tearing_down =3D 1;
> -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> -
> -	percpu_ref_kill(&se_sess->cmd_count);
> +	pr_debug("Stopping session queue.\n");
> +	if (atomic_cmpxchg(&se_sess->stopped, 0, 1) =3D=3D 0)
> +		percpu_ref_kill_and_confirm(&se_sess->cmd_count,
> +					    =
target_stop_session_confirm);
> }
> -EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
> +EXPORT_SYMBOL(target_stop_session);
>=20
> /**
>  * target_wait_for_sess_cmds - Wait for outstanding commands
> @@ -2974,19 +2963,19 @@ void target_sess_cmd_list_set_waiting(struct =
se_session *se_sess)
>  */
> void target_wait_for_sess_cmds(struct se_session *se_sess)
> {
> -	struct se_cmd *cmd;
> 	int ret;
>=20
> -	WARN_ON_ONCE(!se_sess->sess_tearing_down);
> +	WARN_ON_ONCE(!atomic_read(&se_sess->stopped));
>=20
> 	do {
> -		ret =3D wait_event_timeout(se_sess->cmd_list_wq,
> +		pr_debug("Waiting for running cmds to complete.\n");
> +		ret =3D wait_event_timeout(se_sess->cmd_count_wq,
> 				percpu_ref_is_zero(&se_sess->cmd_count),
> 				180 * HZ);
> -		list_for_each_entry(cmd, &se_sess->sess_cmd_list, =
se_cmd_list)
> -			target_show_cmd("session shutdown: still waiting =
for ",
> -					cmd);
> 	} while (ret <=3D 0);
> +
> +	wait_for_completion(&se_sess->stop_done);
> +	pr_debug("Waiting for cmds done.\n");
> }
> EXPORT_SYMBOL(target_wait_for_sess_cmds);
>=20
> diff --git a/drivers/target/tcm_fc/tfc_sess.c =
b/drivers/target/tcm_fc/tfc_sess.c
> index 4fd6a1d..23ce506 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -275,7 +275,7 @@ static struct ft_sess *ft_sess_delete(struct =
ft_tport *tport, u32 port_id)
>=20
> static void ft_close_sess(struct ft_sess *sess)
> {
> -	target_sess_cmd_list_set_waiting(sess->se_sess);
> +	target_stop_session(sess->se_sess);
> 	target_wait_for_sess_cmds(sess->se_sess);
> 	ft_sess_put(sess);
> }
> diff --git a/include/target/target_core_base.h =
b/include/target/target_core_base.h
> index b3c9946..2824463 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -608,7 +608,7 @@ static inline struct se_node_acl =
*fabric_stat_to_nacl(struct config_item *item)
> }
>=20
> struct se_session {
> -	unsigned		sess_tearing_down:1;
> +	atomic_t		stopped;
> 	u64			sess_bin_isid;
> 	enum target_prot_op	sup_prot_ops;
> 	enum target_prot_type	sess_prot_type;
> @@ -618,9 +618,9 @@ struct se_session {
> 	struct percpu_ref	cmd_count;
> 	struct list_head	sess_list;
> 	struct list_head	sess_acl_list;
> -	struct list_head	sess_cmd_list;
> 	spinlock_t		sess_cmd_lock;
> -	wait_queue_head_t	cmd_list_wq;
> +	wait_queue_head_t	cmd_count_wq;
> +	struct completion	stop_done;
> 	void			*sess_cmd_map;
> 	struct sbitmap_queue	sess_tag_pool;
> };
> diff --git a/include/target/target_core_fabric.h =
b/include/target/target_core_fabric.h
> index 6adf4d7..d60a3eb 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -178,7 +178,7 @@ int	=
transport_send_check_condition_and_sense(struct se_cmd *,
> int	target_send_busy(struct se_cmd *cmd);
> int	target_get_sess_cmd(struct se_cmd *, bool);
> int	target_put_sess_cmd(struct se_cmd *);
> -void	target_sess_cmd_list_set_waiting(struct se_session *);
> +void	target_stop_session(struct se_session *se_sess);
> void	target_wait_for_sess_cmds(struct se_session *);
> void	target_show_cmd(const char *pfx, struct se_cmd *cmd);
>=20
> --=20
> 1.8.3.1
>=20

For target and tcm_qla2xxx piece,=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

