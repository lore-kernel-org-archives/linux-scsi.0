Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792589562;
	b=fV/gSfJJfpnHmEvJuQjiu4s4bNw5cTR70qX68aqXGrh6iy4A78VVXmmWUsJMbaodc4Ta
	 KXCoM9cXTbfJJj0LYZl8Lsps7bhcXJ61Ozf+5ZNcIhYwRUi6dk3J3RDiXKkeTPpL0TSjn
	 lKYOWPVqx5fCut31/yi55IBDXfm4AScxmG93VkUir6Owe/w0U5BJg6qGhj/LV5mNhAg0i
	 6aH+yUBjUf+oa5viCPP6qTCXusM0nVf7H1K8GtFubSDctcQli5IInp5EbEzFni6XkePiH
	 BvswmBpFt2Qp9EbHNPsH5Oo+D+NdIo027VNOUtpgyDJn69FKdZBuSTkS3eaX33fOGNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792589562;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Qoovsy9Me/4pabviPeXeIYjoKiIHdXdyPdKrsUP1jv4=;
	b=gK1arYoO1+FjRoEsrdZHOKDdvOfMBFJbsxk18j1EJS4MGI+nJ7HQwrqJakLvhwkf8v0p
	 BTv8jYNNa24hDw32997R+heQTAMTNnhKYzpNc/5iargQwUH/8TjPn/zlJgRdF53uaXI8V
	 pp09cPi8y7Ch4GzfqXITj0HJpYngZRAMEAfZcoz6H+SkIQKOn4uWmbou74jThp+f6Z+Vr
	 9IhiObWEm5uJn2stZef8dRvPH01xZoqh+e/EQqLOxfUC6+aV8nYjGrYh98aZkFLXHLlIL
	 d7/03uu/Na1WaxmEWSzodVC4WmdB/9fyDycvrElo/IQDCjl94/NBU/GB9tupAKPwoiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FFWZrWFU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF023606A31F;
	Wed, 21 Oct 2026 13:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FFWZrWFU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2313D1F000CB;
	Wed, 21 Oct 2026 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792589561;
	bh=Qoovsy9Me/4pabviPeXeIYjoKiIHdXdyPdKrsUP1jv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FFWZrWFUwBFjhqmTZPsxJMdZ2N65hSFYJQiMC94vTmMEIAs0uFhgIQi9zXxX4Jee3
	 McXivhI4V4MLYHKfWeSHASBsKb4bf6mtItTEWoMj6Ifm/OZz7R3ptUI7IftY/74kM8
	 +VGAAc7qq/ROCmofwnr9SbHEdf+J5GiwSmt7HvnOGh8AxLKv88EVktfAI7AY0tyjWC
	 BcXXmxjOcLJvK73ao6T45SFeE9PuX8wQeO8sSW09SSlyE9l12WPzVeu7cOnP4vpkJY
	 LQJa0ISHYEhTeeTIy3h1KuvPLmQ6i3/ajSVVwHMq/jDMD9x6ID4QJhobbKuLTKYxfc
	 KrY+cgwB2gtKA==
Message-ID: <sashiko-outbox-180312@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: elx: efct: fix target session lifetime against
 node teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
References: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 13:32:40 +0000
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
- [High] scsi: elx: efct: premature PRLI completion in efct_scsi_new_initia=
tor()
- [High] scsi: elx: efct: synchronous completion race in efct_scsi_del_init=
iator()
- [High] scsi: elx: efct: lock-drop race before efc_scsi_sess_reg_complete()
--

commit a9f642ffcfa8c9202c9520625d658419af962d69
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: elx: efct: fix target session lifetime against node teardown

This commit adds reference counting on struct efc_node across
efct_lio_setup_session() and introduces a tgt_sess_state state machine
under efc->lock to synchronize LIO target session setup with node
teardown.

> diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efc=
t_lio.c
> index 67d686dd6fb33..634200c1a61b5 100644
> --- a/drivers/scsi/elx/efct/efct_lio.c
> +++ b/drivers/scsi/elx/efct/efct_lio.c

[ ... ]

> @@ -1186,14 +1216,43 @@ static void efct_lio_setup_session(struct work_st=
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
> +		spin_lock_irqsave(&efc->lock, flags);
> +		if (!efct_tgt_sess_may_register(node)) {
> +			node->tgt_sess_state =3D EFCT_TGT_SESS_NONE;
> +			spin_unlock_irqrestore(&efc->lock, flags);
> +			goto done;
> +		}
> +		node->tgt_sess_state =3D EFCT_TGT_SESS_NONE;
> +		spin_unlock_irqrestore(&efc->lock, flags);
>  		efc_scsi_sess_reg_complete(node, -EIO);
> -		return;
> +		goto done;
> +	}
> +
> +	spin_lock_irqsave(&efc->lock, flags);
> +	if (!efct_tgt_sess_may_register(node)) {
> +		tgt_node =3D node->tgt_node;
> +		node->tgt_node =3D NULL;
> +		node->tgt_sess_state =3D EFCT_TGT_SESS_NONE;
> +		spin_unlock_irqrestore(&efc->lock, flags);
> +		/*
> +		 * No kref_put(), because efct_scsi_del_initiator() already
> +		 * reported completion. tgt_node never reached efct->lookup
> +		 * and node->tgt_node is cleared above, so nothing else can
> +		 * reach it and its count is the one kref_init() gave it.
> +		 */
> +		efc_log_debug(efct, "node %p torn down during session setup\n",
> +			      node);
> +		target_stop_session(se_sess);
> +		target_wait_for_sess_cmds(se_sess);
> +		target_remove_session(se_sess);
> +		kfree(tgt_node);
> +		goto done;
>  	}
> =20
>  	tgt_node =3D node->tgt_node;
> @@ -1202,8 +1261,10 @@ static void efct_lio_setup_session(struct work_str=
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
Does dropping efc->lock in efct_lio_setup_session() before calling
efc_scsi_sess_reg_complete() leave a race window with concurrent node
teardown?

On the target_setup_session() error path, efct_lio_setup_session()
checks efct_tgt_sess_may_register(node), sets node->tgt_sess_state to
EFCT_TGT_SESS_NONE, and releases efc->lock before calling
efc_scsi_sess_reg_complete(node, -EIO), which then re-acquires
efc->lock to post EFC_EVT_NODE_SESS_REG_FAIL:

drivers/scsi/elx/libefc/efc_node.c:efc_scsi_sess_reg_complete() {
	...
	spin_lock_irqsave(&efc->lock, flags);
	/* Notify the node to resume */
	efc_node_post_event(node, evt, NULL);
	spin_unlock_irqrestore(&efc->lock, flags);
}

If __efc_d_initiate_shutdown() -> efct_scsi_del_initiator() runs on
another CPU during that unlocked window, efct_scsi_del_initiator() sees
node->tgt_sess_state =3D=3D EFCT_TGT_SESS_NONE and returns
EFC_SCSI_CALL_COMPLETE immediately. The node can then finish
__efc_node_shutdown() and run efc_node_free(node) (which sets
node->nport =3D NULL while leaving node->req_free =3D true), or be reused
in place on an implicit or explicit logout, before
efc_scsi_sess_reg_complete() re-acquires efc->lock.

When efc_scsi_sess_reg_complete() then calls efc_node_post_event() on
an already-freed node, efc_node_post_event() sees:

drivers/scsi/elx/libefc/efc_node.c:efc_node_post_event() {
	...
	if (node->evtdepth =3D=3D 0 && node->req_free)
		free_node =3D true;

	if (free_node)
		efc_node_free(node);
}

Calling efc_node_free() a second time when node->refound is set will
dereference the NULL node->nport inside efc_node_find(node->nport,
FC_FID_DIR_SERV). A similar lock drop occurs on the success path
between setting node->tgt_sess_state =3D EFCT_TGT_SESS_REGISTERED and
calling efc_scsi_sess_reg_complete(node, 0). Should the registration
completion event be posted before releasing efc->lock?

[ ... ]

> @@ -1223,6 +1286,10 @@ int efct_scsi_new_initiator(struct efc *efc, struc=
t efc_node *node)
>  	struct efct *efct =3D node->efc->base;
>  	struct efct_lio_wq_data *wq_data;
> =20
> +	/* a repeated PRLI must not build a second session for one node */
> +	if (node->tgt_sess_state !=3D EFCT_TGT_SESS_NONE)
> +		return EFC_SCSI_CALL_COMPLETE;

[Severity: High]
What happens if a remote initiator sends a second PRLI while the first
efct_lio_setup_session() work item is still in flight (with
node->tgt_sess_state =3D=3D EFCT_TGT_SESS_SETUP)?

In drivers/scsi/elx/libefc/efc_device.c, efc_d_send_prli_rsp() treats
EFC_SCSI_CALL_COMPLETE as synchronous session registration completion
and immediately posts EFC_EVT_NODE_SESS_REG_OK:

drivers/scsi/elx/libefc/efc_device.c:efc_d_send_prli_rsp() {
	...
	if (rc =3D=3D EFC_SCSI_CALL_COMPLETE)
		efc_node_post_event(node, EFC_EVT_NODE_SESS_REG_OK, NULL);
}

In __efc_d_port_logged_in(), handling EFC_EVT_NODE_SESS_REG_OK sends
the PRLI LS_ACC and moves the node to __efc_d_device_ready:

drivers/scsi/elx/libefc/efc_device.c:__efc_d_port_logged_in() {
	...
	case EFC_EVT_NODE_SESS_REG_OK:
		if (node->send_ls_acc =3D=3D EFC_NODE_SEND_LS_ACC_PRLI)
			efc_send_prli_acc(node, node->ls_acc_oxid);

		node->send_ls_acc =3D EFC_NODE_SEND_LS_ACC_NONE;
		efc_node_transition(node, __efc_d_device_ready, NULL);
		break;
}

Because efct_lio_setup_session() has not finished target_setup_session()
yet, the PRLI LS_ACC is sent and the node enters __efc_d_device_ready
before ConfigFS NodeACLs are checked in
core_tpg_check_initiator_node_acl() and before tgt_node is stored in
efct->lookup. Any FCP commands arriving before xa_store(&efct->lookup,
...) will be dropped by efct_dispatch_frame(), and if
target_setup_session() later fails (for example with -EACCES or
-ENOMEM), the PRLI LS_ACC has already been sent instead of LS_RJT and
__efc_d_device_ready ignores the subsequent EFC_EVT_NODE_SESS_REG_FAIL
event, leaving the node ready with no LIO session.

Should efct_scsi_new_initiator() return EFC_SCSI_CALL_ASYNC when
node->tgt_sess_state =3D=3D EFCT_TGT_SESS_SETUP so the node waits for the
in-flight setup work to finish?

[ ... ]

> @@ -1287,17 +1358,22 @@ int efct_scsi_del_initiator(struct efc *efc, stru=
ct efc_node *node, int reason)
>  	if (reason =3D=3D EFCT_SCSI_INITIATOR_MISSING)
>  		return EFC_SCSI_CALL_COMPLETE;
> =20
> -	if (!tgt_node) {
> -		efc_log_err(efct, "tgt_node is NULL\n");
> -		return -EIO;
> +	if (node->tgt_sess_state =3D=3D EFCT_TGT_SESS_SETUP) {
> +		/* hand the session being built back to the setup work */
> +		node->tgt_sess_state =3D EFCT_TGT_SESS_DELETE_PENDING;
> +		return EFC_SCSI_CALL_COMPLETE;
>  	}

[Severity: High]
Could returning EFC_SCSI_CALL_COMPLETE here while
efct_lio_setup_session() is still running on lio_wq cause races with
node re-login or teardown?

When __efc_d_initiate_shutdown() calls efct_scsi_del_initiator() and
receives EFC_SCSI_CALL_COMPLETE, it immediately posts
EFC_EVT_NODE_DEL_INI_COMPLETE and advances the node to
__efc_node_shutdown() while efct_lio_setup_session() is still executing:

1. On an implicit logout (EFC_NODE_SHUTDOWN_IMPLICIT_LOGO, such as a
new PLOGI) or an explicit logout with pending frames,
efc_node_handle_implicit_logo() or efc_node_handle_explicit_logo() in
drivers/scsi/elx/libefc/efc_node.c sets node->req_free =3D false and
re-attaches the same struct efc_node in place:

drivers/scsi/elx/libefc/efc_node.c:efc_node_handle_implicit_logo() {
	...
	/* Re-attach node with the same HW node resources */
	node->req_free =3D false;
	rc =3D efc_node_attach(node);
	efc_node_transition(node, __efc_d_wait_node_attach, NULL);
	...
}

If the new PRLI arrives before the previous efct_lio_setup_session()
work item has unwound EFCT_TGT_SESS_DELETE_PENDING,
efct_scsi_new_initiator() sees node->tgt_sess_state !=3D
EFCT_TGT_SESS_NONE and returns EFC_SCSI_CALL_COMPLETE without queueing
a new session setup. The node transitions to __efc_d_device_ready, and
the old work item then unwinds and resets node->tgt_node =3D NULL and
node->tgt_sess_state =3D EFCT_TGT_SESS_NONE, leaving the ready node
without a LIO session.

2. On normal node teardown, __efc_node_shutdown() sets
node->req_free =3D true and efc_node_post_event() calls
efc_node_free(node) immediately while efct_lio_setup_session() may
still be inside target_setup_session(). After efct_session_cb() drops
efc->lock, transport_register_session() briefly publishes se_sess
(with se_sess->fabric_sess_ptr =3D node) onto se_nacl->acl_sess_list
before efct_lio_setup_session() removes it. If a concurrent LIO
session teardown (such as target_shutdown_sessions() ->
efct_lio_close_session()) runs during that window, it calls
efc_node_post_shutdown(node, NULL) -> efc_node_post_event() on the
already-freed node, which sees node->evtdepth =3D=3D 0 && node->req_free
and calls efc_node_free(node) a second time, dereferencing NULL
node->nport in efc_node_find(node->nport, FC_FID_DIR_SERV) when
node->refound is set:

drivers/scsi/elx/libefc/efc_node.c:efc_node_free() {
	...
	if (node->refound) {
		ns =3D efc_node_find(node->nport, FC_FID_DIR_SERV);
	}

	if (!node->nport) {
		efc_log_err(efc, "Node already Freed\n");
		return;
	}
	...
}

Would it be safer for efct_scsi_del_initiator() to return
EFC_SCSI_CALL_ASYNC when setting EFCT_TGT_SESS_DELETE_PENDING and have
efct_lio_setup_session() call efc_scsi_del_initiator_complete() once
the abort and unwind have completed?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021130802.2691=
833-1-yhlee@isslab.korea.ac.kr?part=3D1
