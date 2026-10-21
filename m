Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792594619;
	b=qAQSvBXMEivM9tyWpuf7W/wR+zcJifHwDGoijqG5rKB/2sfGZn+TQBg6BgjItMvKjaU4
	 naTKAXw28bbc/PnC6C685wOiCgu4/oO+5bxxnYZp0Eo9vrAcUuCmqLjL4JaeH66tFPhLb
	 gnjPTpzC5KzcZbUsdHBObstFZ3Qjf7GXBGgVS2ApaiatDt29cxjSljVpn5uX3WV67j+DY
	 urh0ZappLmQbypECFX6Krbny67+g5PiZJJAGVn7YeTiDpWr87rFQEvZbGnn/Hj+l4tAZD
	 OAtAckfFLO3kDur3wYbDoFSAfAtLIkACaAFVcQRJHuxBI7Y4LPoaammjM+/eUnnCNrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594619;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qkAmm2unRNfFzcFsod7/H8imHSS/kn6QazJtyFZpyO8=;
	b=DutPq8jpANKsg3+Q5GuV8v5CaLrMEBG6bjk8W4TwW9UkH0sx5b3OfNjD/iY84vc+OJ7O
	 CyRs0ifbH2qzqdKiEz+FaXAUwa7s6qFaxFgdDL+JurlG/FQSw8Z7ay9ynpu6aH3DxLlFi
	 0/+gry8PvhTb/oS5vCUBpdNkdAtDKcrZz2GoWK/g5NKTMtCbm457QBJsUA735aUuuZKb6
	 n1VGvk0DJ/KVHJhmnWIVyJmjE46PtjZQ0KwGg5f8ih4OUyRtXTj8JhWbHYYGPOBSCiazt
	 kP1HWe4sEC5O/0SGnr5bp9MSU1BVsh0SvNIjcjlJVNmberHhoXld+cOi0D8sWeQzmEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qg7lyySI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A3E606A31B;
	Wed, 21 Oct 2026 14:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qg7lyySI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5591F000C2;
	Wed, 21 Oct 2026 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792594619;
	bh=qkAmm2unRNfFzcFsod7/H8imHSS/kn6QazJtyFZpyO8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qg7lyySI3M4mMxw8lLo3ENWqfTwfDXxLfnEl7I6VdQcqfF/nSW6zXPeWzhvgYCSFS
	 OEsRkvo4w06HMaIUN+LI+/zlNCnRj96LCUQND9KRDCTv5Eyr86UDFCOKt4MSMUg+pX
	 cZZqxXJVn6DhXBYZFVwraz23rNoViY/e97VOADD09kgYnr9pf/yQ6tahUBFN9BRx3p
	 ut3ogqbPlobbr5BYouI1PGXg6qGoOYMRMB2K303qjbIztjVuRuoeDZvRcfBjnTW39h
	 Ya80si0oaKYbbtsALjLMjF09I8YjPAuod8+BFpxg5/NgTaXBr9sbhuKusbcdXZaph7
	 RXJLVILH24wfg==
Message-ID: <sashiko-outbox-180402@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: elx: efct: fix target session lifetime against
 node teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261021142818.2782104-1-yhlee@isslab.korea.ac.kr>
References: <20261021142818.2782104-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 14:56:58 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: elx: efct: race in efct_lio_setup_session() dropping lock be=
fore completion
- [High] scsi: elx: efct: second efc_node_free() call in efct_lio_setup_ses=
sion()
- [Medium] scsi: elx: efct: efct_scsi_new_initiator() hangs node when sessi=
on is registered
--

commit 0dc470d1061493230f83a79f4682d76a8f9318fc
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: elx: efct: fix target session lifetime against node teardown

This commit adds reference counting on struct efc_node across target session
setup work items and introduces an explicit target session state machine
protected by efc->lock to synchronize session creation with node teardown.

> diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efc=
t_lio.c
> index 67d686dd6fb33..9ddab907556da 100644
> --- a/drivers/scsi/elx/efct/efct_lio.c
> +++ b/drivers/scsi/elx/efct/efct_lio.c
> @@ -1062,17 +1062,33 @@ _efct_tgt_node_free(struct kref *arg)
>  	kfree(tgt_node);
>  }
> =20
> +/* True only while a setup is in flight. The caller holds efc->lock. */
> +static bool efct_tgt_sess_may_register(struct efc_node *node)
> +{
> +	return node->tgt_sess_state =3D=3D EFCT_TGT_SESS_SETUP &&
> +	       node->nport && !node->req_free;
> +}

[ ... ]

> @@ -1157,15 +1174,28 @@ static void efct_lio_setup_session(struct work_st=
ruct *work)
>  		container_of(work, struct efct_lio_wq_data, work);
>  	struct efct *efct =3D wq_data->efct;
>  	struct efc_node *node =3D wq_data->ptr;
> +	struct efc *efc =3D node->efc;
>  	char wwpn[WWN_NAME_LEN];
>  	struct efct_lio_tpg *tpg;
>  	struct efct_node *tgt_node;
>  	struct se_portal_group *se_tpg;
>  	struct se_session *se_sess;
> +	unsigned long flags;
> +	bool deleted =3D false;
>  	int watermark;
>  	int ini_count;
>  	u64 id;
> =20
> +	spin_lock_irqsave(&efc->lock, flags);
> +	if (!efct_tgt_sess_may_register(node)) {
> +		deleted =3D node->tgt_sess_state =3D=3D EFCT_TGT_SESS_DELETE_PENDING;
> +		node->tgt_sess_state =3D EFCT_TGT_SESS_NONE;
> +		spin_unlock_irqrestore(&efc->lock, flags);
> +		efc_log_debug(efct, "node %p torn down before session setup\n",
> +			      node);
> +		goto done;
> +	}
> +
>  	/* Check to see if it's belongs to vport,
>  	 * if not get physical port
>  	 */
> @@ -1176,8 +1206,10 @@ static void efct_lio_setup_session(struct work_str=
uct *work)
>  		tpg =3D efct->tgt_efct.tpg;
>  		se_tpg =3D &tpg->tpg;
>  	} else {
> +		node->tgt_sess_state =3D EFCT_TGT_SESS_NONE;
> +		spin_unlock_irqrestore(&efc->lock, flags);
>  		efc_log_err(efct, "failed to init session\n");
> -		return;
> +		goto done;
>  	}
> =20
>  	/*
> @@ -1186,14 +1218,38 @@ static void efct_lio_setup_session(struct work_st=
ruct *work)
>  	 * ConfigFS NodeACLs.
>  	 */
>  	efct_format_wwn(wwpn, sizeof(wwpn), "",	efc_node_get_wwpn(node));
> +	spin_unlock_irqrestore(&efc->lock, flags);
> =20
>  	se_sess =3D target_setup_session(se_tpg, 0, 0, TARGET_PROT_NORMAL, wwpn,
>  				       node, efct_session_cb);
>  	if (IS_ERR(se_sess)) {
>  		efc_log_err(efct, "failed to setup session\n");
> -		kfree(wq_data);
> -		efc_scsi_sess_reg_complete(node, -EIO);
> -		return;
> +		spin_lock_irqsave(&efc->lock, flags);
> +		deleted =3D node->tgt_sess_state =3D=3D EFCT_TGT_SESS_DELETE_PENDING;
> +		node->tgt_sess_state =3D EFCT_TGT_SESS_NONE;
> +		spin_unlock_irqrestore(&efc->lock, flags);
> +		goto done;
> +	}
> +
> +	spin_lock_irqsave(&efc->lock, flags);
> +	if (!efct_tgt_sess_may_register(node)) {
> +		deleted =3D node->tgt_sess_state =3D=3D EFCT_TGT_SESS_DELETE_PENDING;
> +		tgt_node =3D node->tgt_node;
> +		node->tgt_node =3D NULL;
> +		node->tgt_sess_state =3D EFCT_TGT_SESS_NONE;
> +		spin_unlock_irqrestore(&efc->lock, flags);
> +		/*
> +		 * kfree() and not kref_put(), because the release would post a
> +		 * second completion. Nothing else can reach tgt_node, it never
> +		 * entered efct->lookup and node->tgt_node is clear.
> +		 */
> +		efc_log_debug(efct, "node %p torn down during session setup\n",
> +			      node);
> +		target_stop_session(se_sess);
> +		target_wait_for_sess_cmds(se_sess);
> +		target_remove_session(se_sess);
> +		kfree(tgt_node);
> +		goto done;
> +	}
> =20
>  	tgt_node =3D node->tgt_node;
> @@ -1202,8 +1258,10 @@ static void efct_lio_setup_session(struct work_str=
uct *work)
>  	efc_log_debug(efct, "new initiator sess=3D%p node=3D%p id: %llx\n",
>  		      se_sess, node, id);
> =20
> -	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL)))
> +	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_ATOMIC)))
>  		efc_log_err(efct, "Node lookup store failed\n");
> +	node->tgt_sess_state =3D EFCT_TGT_SESS_REGISTERED;
> +	spin_unlock_irqrestore(&efc->lock, flags);
> =20
>  	efc_scsi_sess_reg_complete(node, 0);

[Severity: High]
In efct_lio_setup_session(), node->tgt_sess_state is updated and efc->lock =
is
released before the completion event is posted to the node state machine.
Could this race with concurrent node teardown or a repeated PRLI?

On the failure paths (when no TPG is found, or when target_setup_session()
returns an error while node->tgt_sess_state =3D=3D EFCT_TGT_SESS_SETUP),
efct_lio_setup_session() sets node->tgt_sess_state =3D EFCT_TGT_SESS_NONE a=
nd
drops efc->lock before jumping to done:, where efc_scsi_sess_reg_complete()
re-acquires efc->lock to post EFC_EVT_NODE_SESS_REG_FAIL.

During that unlocked window, the node is still in __efc_d_port_logged_in,
which allows two races:

1. If __efc_d_initiate_shutdown() -> efct_scsi_del_initiator() runs under
efc->lock in this window, efct_scsi_del_initiator() observes
node->tgt_sess_state =3D=3D EFCT_TGT_SESS_NONE instead of EFCT_TGT_SESS_SET=
UP and
returns EFC_SCSI_CALL_COMPLETE instead of EFC_SCSI_CALL_ASYNC.
__efc_d_initiate_shutdown() then immediately posts
EFC_EVT_NODE_DEL_INI_COMPLETE and advances the node to __efc_node_shutdown(=
).
If the shutdown is EFC_NODE_SHUTDOWN_IMPLICIT_LOGO, the node re-initiates
login and then receives the stale EFC_EVT_NODE_SESS_REG_FAIL from done:.

2. If a repeated PRLI arrives in __efc_d_port_logged_in during this unlocked
window, efct_scsi_new_initiator() sees node->tgt_sess_state =3D=3D
EFCT_TGT_SESS_NONE, sets EFCT_TGT_SESS_SETUP, and queues a second
efct_lio_setup_session() work item. The first work item then runs done: and
posts EFC_EVT_NODE_SESS_REG_FAIL, sending LS_RJT for the second PRLI's ox_id
and clearing node->send_ls_acc while the second work item is still in fligh=
t.

Similarly, on the success path above, node->tgt_sess_state is set to
EFCT_TGT_SESS_REGISTERED and efc->lock is dropped before
efc_scsi_sess_reg_complete(node, 0) and before atomic_add_return() on
efct->tgt_efct.initiator_count. A concurrent efct_scsi_del_initiator() can
run in that window before EFC_EVT_NODE_SESS_REG_OK is posted and decrement
initiator_count before it has been incremented.

> =20
> @@ -1216,6 +1274,17 @@ static void efct_lio_setup_session(struct work_str=
uct *work)
>  	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
> =20
>  	kfree(wq_data);
> +	kref_put(&node->ref, node->release);
> +	return;
> +
> +done:
> +	/* every exit owes the node exactly one completion */
> +	if (deleted)
> +		efc_scsi_del_initiator_complete(efc, node);
> +	else
> +		efc_scsi_sess_reg_complete(node, -EIO);
> +	kfree(wq_data);
> +	kref_put(&node->ref, node->release);
>  }

[Severity: High]
Can jumping to done: and calling efc_scsi_sess_reg_complete() or
efc_scsi_del_initiator_complete() trigger a second call to efc_node_free(no=
de)
and dereference a NULL node->nport if the node has already reached
__efc_node_shutdown()?

In efct_tgt_sess_may_register(node), the check tests node->nport &&
!node->req_free. Those fields only become NULL and true once the node has
already completed __efc_node_shutdown() and efc_node_free() (for instance, =
if
a subsequent PRLI cleared node->init via efc_process_prli_payload() before
__efc_d_initiate_shutdown() ran so efct_scsi_del_initiator() was skipped, or
via the unlocked window between setting EFCT_TGT_SESS_NONE and reaching don=
e:
when efct_scsi_del_initiator() returns EFC_SCSI_CALL_COMPLETE).

Once efc_node_free(node) has run, node->nport is NULL and node->req_free
remains true while efct_lio_setup_session() still holds its kref on node.
When done: then calls efc_scsi_sess_reg_complete() or
efc_scsi_del_initiator_complete(), efc_node_post_event() runs on the node:

drivers/scsi/elx/libefc/efc_node.c:efc_node_post_event() {
	...
	node->evtdepth--;

	/*
	 * Free the node object if so requested,
	 * and we're at an event call depth of zero
	 */
	if (node->evtdepth =3D=3D 0 && node->req_free)
		free_node =3D true;

	if (free_node)
		efc_node_free(node);
}

In efc_node_free(), if node->refound is set, node->nport is passed to
efc_node_find() before the !node->nport check:

drivers/scsi/elx/libefc/efc_node.c:efc_node_free() {
	...
	if (node->refound) {
		/*
		 * Save the name server node. We will send fake RSCN event at
		 * the end to handle ignored RSCN event during node deletion
		 */
		ns =3D efc_node_find(node->nport, FC_FID_DIR_SERV);
	}

	if (!node->nport) {
		efc_log_err(efc, "Node already Freed\n");
		return;
	}
	...
}

Should done: avoid posting completion events when node->req_free is already
set (or !node->nport)?

> =20
>  int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
>  {
>  	struct efct *efct =3D node->efc->base;
>  	struct efct_lio_wq_data *wq_data;
> =20
> +	/* a repeated PRLI waits for the in-flight setup, it does not add one */
> +	if (node->tgt_sess_state !=3D EFCT_TGT_SESS_NONE)
> +		return EFC_SCSI_CALL_ASYNC;

[ ... ]

> @@ -1287,17 +1364,22 @@ int efct_scsi_del_initiator(struct efc *efc, stru=
ct efc_node *node, int reason)
>  	if (reason =3D=3D EFCT_SCSI_INITIATOR_MISSING)
>  		return EFC_SCSI_CALL_COMPLETE;
> =20
> -	if (!tgt_node) {
> -		efc_log_err(efct, "tgt_node is NULL\n");
> -		return -EIO;
> +	if (node->tgt_sess_state =3D=3D EFCT_TGT_SESS_SETUP) {
> +		/* the setup work unwinds it and completes the delete */
> +		node->tgt_sess_state =3D EFCT_TGT_SESS_DELETE_PENDING;
> +		return EFC_SCSI_CALL_ASYNC;
>  	}
> =20
> +	if (node->tgt_sess_state !=3D EFCT_TGT_SESS_REGISTERED || !tgt_node)
> +		return EFC_SCSI_CALL_COMPLETE;
> +
>  	wq_data =3D kzalloc_obj(*wq_data, GFP_ATOMIC);
>  	if (!wq_data)
>  		return -ENOMEM;
> =20
>  	id =3D (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
>  	xa_erase(&efct->lookup, id);
> +	node->tgt_sess_state =3D EFCT_TGT_SESS_NONE;

[Severity: Medium]
What happens in efct_scsi_new_initiator() if node->tgt_sess_state is still
EFCT_TGT_SESS_REGISTERED when a new PRLI arrives?

Because efct_scsi_new_initiator() checks:

	if (node->tgt_sess_state !=3D EFCT_TGT_SESS_NONE)
		return EFC_SCSI_CALL_ASYNC;

returning EFC_SCSI_CALL_ASYNC when node->tgt_sess_state is
EFCT_TGT_SESS_REGISTERED (rather than EFCT_TGT_SESS_SETUP) leaves the node
waiting in __efc_d_port_logged_in for EFC_EVT_NODE_SESS_REG_OK or
EFC_EVT_NODE_SESS_REG_FAIL when no efct_lio_setup_session() work item is in
flight to post it.

It looks like a node can reach efct_scsi_new_initiator() with
node->tgt_sess_state =3D=3D EFCT_TGT_SESS_REGISTERED in two ways:

1. An initiator logs in and reaches EFCT_TGT_SESS_REGISTERED, then sends a
PRLI with FCP_SPPF_INIT_FCN clear in __efc_d_device_ready or
__efc_d_port_logged_in, which causes efc_process_prli_payload() to set
node->init =3D false. If the peer then sends PLOGI (triggering
EFC_EVT_SHUTDOWN_IMPLICIT_LOGO) or LOGO with pending frames,
__efc_d_initiate_shutdown() skips scsi_del_node because node->init is false,
and the node re-attaches and returns to __efc_d_port_logged_in with
node->tgt_sess_state still set to EFCT_TGT_SESS_REGISTERED.

2. During an implicit logout (or explicit logout with pending frames),
efct_scsi_del_initiator() fails its GFP_ATOMIC allocation of wq_data and
returns -ENOMEM before clearing node->tgt_sess_state. In
__efc_d_initiate_shutdown():

drivers/scsi/elx/libefc/efc_device.c:__efc_d_initiate_shutdown() {
	...
			if (node->nport->enable_tgt)
				rc =3D efc->tt.scsi_del_node(efc, node,
					EFC_SCSI_INITIATOR_DELETED);

			if (rc =3D=3D EFC_SCSI_CALL_COMPLETE || rc < 0)
				efc_node_post_event(node,
					EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);
	...
}

Because rc < 0 still posts EFC_EVT_NODE_DEL_INI_COMPLETE, the node completes
re-attachment and enters __efc_d_port_logged_in with node->tgt_sess_state
still set to EFCT_TGT_SESS_REGISTERED, where the next PRLI will hang the no=
de
in efct_scsi_new_initiator().

> =20
>  	wq_data->ptr =3D node;
>  	wq_data->efct =3D efct;

[ ... ]

>
> --=20
> 2.51.2
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021142818.2782=
104-1-yhlee@isslab.korea.ac.kr?part=3D1
