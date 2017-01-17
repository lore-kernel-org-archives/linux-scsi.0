From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 08/12] qla2xxx: Add framework for Async fabric
 discovery.
Date: Tue, 17 Jan 2017 22:17:52 +0000
Message-ID: <1484691459.2729.17.camel@sandisk.com>
References: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
         <1484598924-29066-9-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0085.outbound.protection.outlook.com ([104.47.33.85]:29856
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751118AbdAQWSF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 17:18:05 -0500
In-Reply-To: <1484598924-29066-9-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <582E4D60C6D8204596872CAE2A0B387F@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>, "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Mon, 2017-01-16 at 12:35 -0800, Himanshu Madhani wrote:
>  /*
>   * Adds an extra ref to allow to drop hw lock after adding sess to the l=
ist.
>   * Caller must put it.
> @@ -839,93 +1103,65 @@ static struct fc_port *qlt_create_sess(
>  	bool local)
>  {
>  	struct qla_hw_data *ha =3D vha->hw;
> -	struct fc_port *sess;
> +	struct fc_port *sess =3D fcport;
>  	unsigned long flags;
> =20
> -	/* Check to avoid double sessions */
> -	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> -	list_for_each_entry(sess, &vha->vp_fcports, list) {
> -		if (!memcmp(sess->port_name, fcport->port_name, WWN_SIZE)) {
> -			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
> -			    "Double sess %p found (s_id %x:%x:%x, "
> -			    "loop_id %d), updating to d_id %x:%x:%x, "
> -			    "loop_id %d", sess, sess->d_id.b.domain,
> -			    sess->d_id.b.al_pa, sess->d_id.b.area,
> -			    sess->loop_id, fcport->d_id.b.domain,
> -			    fcport->d_id.b.al_pa, fcport->d_id.b.area,
> -			    fcport->loop_id);
> -
> -			/* Cannot undelete at this point */
> -			if (sess->deleted =3D=3D QLA_SESS_DELETION_IN_PROGRESS) {
> -				spin_unlock_irqrestore(&ha->tgt.sess_lock,
> -				    flags);
> -				return NULL;
> -			}
> -
> -			if (sess->deleted)
> -				qlt_undelete_sess(sess);
> -
> -			if (!sess->se_sess) {
> -				if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
> -				    &sess->port_name[0], sess) < 0) {
> -					spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> -					return NULL;
> -				}
> -			}
> -
> -			kref_get(&sess->sess_kref);
> -			ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
> -						(fcport->flags & FCF_CONF_COMP_SUPPORTED));
> -
> -			if (sess->local && !local)
> -				sess->local =3D 0;
> -
> -			qlt_do_generation_tick(vha, &sess->generation);
> -
> -			spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> +	if (vha->vha_tgt.qla_tgt && vha->vha_tgt.qla_tgt->tgt_stop)
> +		return NULL;
> =20
> -			return sess;
> +	if (fcport->se_sess) {
> +		if (!kref_get_unless_zero(&sess->sess_kref)) {
> +			ql_dbg(ql_dbg_disc, vha, 0xffff,
> +			    "%s: kref_get_unless_zero failed for %8phC\n",
> +			    __func__, sess->port_name);
> +			return NULL;
>  		}
> -	}
> -	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> -
> -	sess =3D kzalloc(sizeof(*sess), GFP_KERNEL);
> -	if (!sess) {
> -		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04a,
> -		    "qla_target(%u): session allocation failed, all commands "
> -		    "from port %8phC will be refused", vha->vp_idx,
> -		    fcport->port_name);
> -
> -		return NULL;
> +		return fcport;
>  	}
>  	sess->tgt =3D vha->vha_tgt.qla_tgt;
> -	sess->vha =3D vha;
> -	sess->d_id =3D fcport->d_id;
> -	sess->loop_id =3D fcport->loop_id;
>  	sess->local =3D local;
> -	kref_init(&sess->sess_kref);
> -	INIT_LIST_HEAD(&sess->del_list_entry);
> =20
> -	/* Under normal circumstances we want to logout from firmware when
> +	/*
> +	 * Under normal circumstances we want to logout from firmware when
>  	 * session eventually ends and release corresponding nport handle.
>  	 * In the exception cases (e.g. when new PLOGI is waiting) correspondin=
g
> -	 * code will adjust these flags as necessary. */
> +	 * code will adjust these flags as necessary.
> +	 */
>  	sess->logout_on_delete =3D 1;
>  	sess->keep_nport_handle =3D 0;
> +	sess->logout_completed =3D 0;
> =20
> -	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
> -	    "Adding sess %p to tgt %p via ->check_initiator_node_acl()\n",
> -	    sess, vha->vha_tgt.qla_tgt);
> +	if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
> +	    &fcport->port_name[0], sess) < 0) {
> +		ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
> +		    "(%d) %8phC check_initiator_node_acl failed\n",
> +		    vha->vp_idx, fcport->port_name);
> +		return NULL;
> +	} else {
> +		kref_init(&fcport->sess_kref);
> +		/*
> +		 * Take an extra reference to ->sess_kref here to handle
> +		 * fc_port access across ->tgt.sess_lock reaquire.
> +		 */
> +		if (!kref_get_unless_zero(&sess->sess_kref)) {
> +			ql_dbg(ql_dbg_disc, vha, 0xffff,
> +			    "%s: kref_get_unless_zero failed for %8phC\n",
> +			    __func__, sess->port_name);
> +			return NULL;
> +		}
> =20
> -	sess->conf_compl_supported =3D (fcport->flags & FCF_CONF_COMP_SUPPORTED=
);
> -	BUILD_BUG_ON(sizeof(sess->port_name) !=3D sizeof(fcport->port_name));
> -	memcpy(sess->port_name, fcport->port_name, sizeof(sess->port_name));
> +		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> +		if (!IS_SW_RESV_ADDR(sess->d_id))
> +			vha->vha_tgt.qla_tgt->sess_count++;

These changes also introduce a new static checker warning:

drivers/scsi/qla2xxx/qla_target.c:1306: qlt_create_sess() error: we previou=
sly assumed 'vha->vha_tgt.qla_tgt' could be null (see line 1260)

Please check whether the newly introduced "if (vha->vha_tgt.qla_tgt)"
test is necessary.

Thanks,

Bart.=
