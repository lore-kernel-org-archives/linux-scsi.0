Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA8F35AC0E
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792335665; cv=none; b=YoCrysOprcgr2bful6lPRpJVMwdUdEDGOFJYim2qgcI8BAczbf1oJSr+WTQlYzN1TqgGt2VdwoATrE19XNFFQs6biguVlxXekBMqliXXcdJRI3v6Bj7EHmc0zFH0C9kpNHdDhB+1JtPyF1oulkl7pNeML9zaNTiL3LUB9y1s/G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792335665; c=relaxed/simple;
	bh=BNN3W2wSf9KKCx4doIe1ntAcjIC3/t/61mAt47X/Lik=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BZDgcVld50UHY8srrd7ntWmPFcgsEf0lOsahd9XbyDQXrSyUAlVUoErSmWE32zMZxetG+rHMGniFwzFLvoulMZ4BgMjE850t+HS42LcXLQ/2TfEgMAWIIorB9zBiuZCTGvsUVEI0+tTJzyaXIOzDgtyfS97jkI0hOxFWqum1wb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtsuOAxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtsuOAxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A181F000C4;
	Sun, 18 Oct 2026 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792335663;
	bh=OqYkb/j9nBk7pZAt1BzyU/TBDmoc8Whzr2kPUzMS8FA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CtsuOAxV7NdJ575ORQR6kbtigaCMtsn+JFM2GvPVkz8A1dlQugLMzaTOkGfgttuPi
	 Xo27L1ym/DEF5Pp8RYS1t7YQN6j3WpELuTi6UULL9r5rblGHCoXj5PTe5eBEkZoq8A
	 FhbmPIbDWU5coj0FaMzrwqHOU/+VY24+E0Dwo10T8891j2RltgspKZywPvkt23M5RL
	 VgTjJAVMpKZ/HESvbt+QynZvP9ti6aL5NvJJXZgjdwFrfuUMUgoQNety3JTnuJaDlT
	 Vs7f0XXcGWUYItQJM5Hdm76Rcan3FTf/oLJV15metJc0tg9U7/Mv1uSqWHAs+QrZ35
	 R4SwxFC0K9ohw==
Message-ID: <sashiko-outbox-176224@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc7+
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <6a4bfcdc8e60669d95abb70bdaa07b87154c9a95.camel@HansenPartnership.com>
References: <6a4bfcdc8e60669d95abb70bdaa07b87154c9a95.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 18 Oct 2026 15:01:02 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] scsi: libiscsi: premature mgmt response frees pending task on =
conn->mgmtqueue
- [High] scsi: libsas: smp_execute_task_sg() skips runtime resume for sysfs=
 callers
- [High] scsi: libsas: sas_smp_handler() fails with -EACCES when runtime PM=
 is disabled
- [High] scsi: target: iscsi: UAF race on discovery_tpg param_list during l=
ogin
--

commit f682ddc340c78ec7c00ca8f8ce335b1612f00410
Author: James Bottomley <James.Bottomley@HansenPartnership.com>

SCSI fixes for 7.3-rc7+

This pull request contains SCSI fixes for libiscsi, libsas, st, xen-scsifro=
nt,
target, and bsg.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 5cbc51899de00..5bfdb30b9088d 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1142,13 +1142,15 @@ static int iscsi_handle_reject(struct iscsi_conn =
*conn, struct iscsi_hdr *hdr,
>  			spin_unlock(&conn->session->frwd_lock);
>  			spin_lock(&conn->session->back_lock);
>  		} else {
> -			struct iscsi_task *task;
> +			struct iscsi_task *task =3D NULL;
>  			/*
>  			 * Our nop as ping got dropped. We know the target
>  			 * and transport are ok so just clean up
>  			 */
> -			task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
> -			if (!task) {
> +			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
> +				task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
> +			if (!task || task->state =3D=3D ISCSI_TASK_FREE ||
> +			    task->sc) {
>  				iscsi_conn_printk(KERN_ERR, conn,
>  						 "Invalid pdu reject. Could "
>  						 "not lookup rejected task.\n");

[ ... ]

> @@ -1284,7 +1286,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
>  	case ISCSI_OP_SCSI_TMFUNC_RSP:
>  	case ISCSI_OP_NOOP_IN:
>  		task =3D iscsi_itt_to_task(conn, hdr->itt);
> -		if (!task)
> +		if (!task || task->state =3D=3D ISCSI_TASK_FREE || task->sc)
>  			return ISCSI_ERR_BAD_ITT;
>  		break;
>  	default:

[Severity: Critical]
Can an unsolicited or premature management response PDU or Reject PDU free a
task while it is still queued on conn->mgmtqueue in ISCSI_TASK_PENDING stat=
e?

In drivers/scsi/libiscsi.c, iscsi_alloc_mgmt_task() initializes a management
task under session->frwd_lock with refcount =3D 1, task->sc =3D NULL, and
task->state =3D ISCSI_TASK_PENDING:

drivers/scsi/libiscsi.c:iscsi_alloc_mgmt_task() {
	...
	refcount_set(&task->refcount, 1);
	task->conn =3D conn;
	task->sc =3D NULL;
	INIT_LIST_HEAD(&task->running);
	task->state =3D ISCSI_TASK_PENDING;
}

When ihost->workq is used, iscsi_send_mgmt_task() adds task->running to
conn->mgmtqueue while task->state is still ISCSI_TASK_PENDING and refcount =
is
still 1:

drivers/scsi/libiscsi.c:iscsi_send_mgmt_task() {
	...
	} else {
		list_add_tail(&task->running, &conn->mgmtqueue);
		iscsi_conn_queue_xmit(conn);
	}
}

The task only transitions to ISCSI_TASK_RUNNING later when iscsi_data_xmit()
dequeues task->running from conn->mgmtqueue and calls iscsi_prep_mgmt_task(=
).
In addition, iscsi_alloc_task() for SCSI commands runs under
session->frwd_lock (not session->back_lock) and sets task->state =3D
ISCSI_TASK_PENDING before assigning task->sc =3D sc.

Because both iscsi_handle_reject() and __iscsi_complete_pdu() only check for
task->state =3D=3D ISCSI_TASK_FREE || task->sc under session->back_lock, a =
target
response (ISCSI_OP_NOOP_IN, ISCSI_OP_LOGOUT_RSP, ISCSI_OP_LOGIN_RSP,
ISCSI_OP_TEXT_RSP, ISCSI_OP_SCSI_TMFUNC_RSP, or ISCSI_OP_REJECT with
ISCSI_REASON_IMM_CMD_REJECT for ISCSI_OP_NOOP_OUT) naming the ITT of a task=
 in
ISCSI_TASK_PENDING passes this check.

That calls iscsi_complete_task() -> __iscsi_put_task() -> iscsi_free_task(),
which drops task->refcount from 1 to 0 and returns the task to
session->cmdpool.queue via kfifo_in() without unlinking task->running from
conn->mgmtqueue:

drivers/scsi/libiscsi.c:iscsi_free_task() {
	...
	session->tt->cleanup_task(task);
	task->state =3D ISCSI_TASK_FREE;
	task->sc =3D NULL;
	if (conn->login_task =3D=3D task)
		return;

	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
}

When iscsi_data_xmit() subsequently processes conn->mgmtqueue or the task is
reallocated from cmdpool.queue, wouldn't this cause a use-after-free and
conn->mgmtqueue list corruption? Should both checks require task->state !=3D
ISCSI_TASK_RUNNING instead of task->state =3D=3D ISCSI_TASK_FREE?

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index 811c9eb4fef11..26c2099c28b97 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -62,7 +62,11 @@ static int smp_execute_task_sg(struct domain_device *d=
ev,
>  		to_sas_internal(dev->port->ha->shost->transportt);
>  	struct sas_ha_struct *ha =3D dev->port->ha;
> =20
> -	pm_runtime_get_sync(ha->dev);
> +	/*
> +	 * Non-blocking: a sync resume here would deadlock against
> +	 * sas_drain_work() during HA resume.
> +	 */
> +	pm_runtime_get_noresume(ha->dev);
>  	mutex_lock(&dev->ex_dev.cmd_mutex);
>  	for (retry =3D 0; retry < 3; retry++) {
>  		if (test_bit(SAS_DEV_GONE, &dev->state)) {
> @@ -135,7 +139,7 @@ static int smp_execute_task_sg(struct domain_device *=
dev,
>  		}
>  	}
>  	mutex_unlock(&dev->ex_dev.cmd_mutex);
> -	pm_runtime_put_sync(ha->dev);
> +	pm_runtime_put(ha->dev);
> =20
>  	BUG_ON(retry =3D=3D 3 && task !=3D NULL);
>  	sas_free_task(task);

[Severity: High]
Does replacing pm_runtime_get_sync(ha->dev) with
pm_runtime_get_noresume(ha->dev) in smp_execute_task_sg() leave sysfs and
exported PHY management callers executing SMP tasks while the SAS host is
runtime-suspended?

Only sas_smp_handler() was updated to resume ha->dev before calling
smp_execute_task_sg(), but three other non-discovery paths invoke
smp_execute_task() -> smp_execute_task_sg() on expander PHYs
(!scsi_is_sas_phy_local(phy)) without waking ha->dev:

1. Reading expander PHY link error sysfs attributes
   (show_sas_phy_invalid_dword_count,
   show_sas_phy_running_disparity_error_count,
   show_sas_phy_loss_of_dword_sync_count, and
   show_sas_phy_phy_reset_problem_count in drivers/scsi/scsi_transport_sas.=
c)
   calls sas_get_linkerrors() -> sas_smp_get_phy_events() ->
   smp_execute_task() -> smp_execute_task_sg():

drivers/scsi/libsas/sas_init.c:sas_get_linkerrors() {
	if (scsi_is_sas_phy_local(phy)) {
		...
	}

	return sas_smp_get_phy_events(phy);
}

2. Writing expander PHY linkrate sysfs attributes
   (store_sas_phy_minimum_linkrate and store_sas_phy_maximum_linkrate in
   drivers/scsi/scsi_transport_sas.c) calls sas_set_phy_speed() ->
   sas_smp_phy_control() -> smp_execute_task() -> smp_execute_task_sg():

drivers/scsi/libsas/sas_init.c:sas_set_phy_speed() {
	...
	} else {
		struct sas_rphy *rphy =3D dev_to_rphy(phy->dev.parent);
		struct domain_device *ddev =3D sas_find_dev_by_rphy(rphy);
		ret =3D sas_smp_phy_control(ddev, phy->number,
					  PHY_FUNC_LINK_RESET, rates);
	}
}

3. Calling the exported sas_phy_reset() on an expander PHY calls
   sas_smp_phy_control() -> smp_execute_task() -> smp_execute_task_sg()
   without resuming ha->dev (unlike the sysfs workqueue wrappers
   queue_phy_reset() and queue_phy_enable() in drivers/scsi/libsas/sas_init=
.c,
   which call pm_runtime_get_sync(ha->dev)).

When the controller is runtime-suspended (for example on hisi_sas_v3_hw whe=
re
sas_suspend_devices() clears dev->lldd_dev and powers down the hardware),
won't these expander PHY operations fail with -ECOMM or access a suspended
HBA?

> @@ -2222,6 +2226,11 @@ void sas_smp_handler(struct bsg_job *job, struct S=
csi_Host *shost,
>  		goto out;
>  	}
> =20
> +	/* The host may have autosuspended, resume it here. */
> +	ret =3D pm_runtime_resume_and_get(dev->port->ha->dev);
> +	if (ret)
> +		goto out;
> +
>  	ret =3D smp_execute_task_sg(dev, job->request_payload.sg_list,
>  			job->reply_payload.sg_list);
>  	if (ret >=3D 0) {

[Severity: High]
Won't pm_runtime_resume_and_get(dev->port->ha->dev) fail with -EACCES on
platform-bus libsas controllers that do not enable runtime PM, such as
hisi_sas_v1_hw and hisi_sas_v2_hw?

Previously, smp_execute_task_sg() called pm_runtime_get_sync(ha->dev) and d=
id
not check its return value. In drivers/base/power/runtime.c:rpm_resume(), w=
hen
dev->power.disable_depth > 0 and !(rpmflags & RPM_TRANSPARENT), it returns 1
only if runtime_status and last_status are both RPM_ACTIVE, and returns
-EACCES otherwise:

drivers/base/power/runtime.c:rpm_resume() {
	if (dev->power.runtime_error) {
		retval =3D -EINVAL;
	} else if (dev->power.disable_depth > 0) {
		if (dev->power.runtime_status =3D=3D RPM_ACTIVE &&
		    dev->power.last_status =3D=3D RPM_ACTIVE)
			retval =3D 1;
		else if (rpmflags & RPM_TRANSPARENT)
			goto out;
		else
			retval =3D -EACCES;
	}
}

Unlike PCI devices (where pci_pm_init() calls pm_runtime_set_active()),
platform devices are initialized by pm_runtime_init() with disable_depth =
=3D 1,
runtime_status =3D RPM_SUSPENDED, and last_status =3D RPM_INVALID. In
drivers/scsi/hisi_sas/hisi_sas_main.c:hisi_sas_probe(), platform controllers
set sha->dev =3D hisi_hba->dev (&pdev->dev) without calling
pm_runtime_set_active() or pm_runtime_enable(), so every expander BSG reque=
st
in sas_smp_handler() will abort at if (ret) goto out with -EACCES when
CONFIG_PM=3Dy.

> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/targe=
t/iscsi/iscsi_target_configfs.c
> index 704ec94383c3c..e1aa0af52c658 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -1306,17 +1306,24 @@ static ssize_t iscsi_disc_enforce_discovery_auth_=
store(struct config_item *item,
>  		return -EINVAL;
>  	}
> =20
> +	if (iscsit_get_tpg(discovery_tpg) < 0)
> +		return -EINVAL;
> +
>  	param =3D iscsi_find_param_from_key(AUTHMETHOD,
>  				discovery_tpg->param_list);
> -	if (!param)
> -		return -EINVAL;
> +	if (!param) {
> +		err =3D -EINVAL;
> +		goto out;
> +	}
> =20
>  	if (op) {
>  		/*
>  		 * Reset the AuthMethod key to CHAP.
>  		 */
> -		if (iscsi_update_param_value(param, CHAP) < 0)
> -			return -EINVAL;
> +		if (iscsi_update_param_value(param, CHAP) < 0) {
> +			err =3D -EINVAL;
> +			goto out;
> +		}
> =20
>  		discovery_tpg->tpg_attrib.authentication =3D 1;
>  		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth =3D 1;

[Severity: High]
Does acquiring discovery_tpg->tpg_access_lock via iscsit_get_tpg() prevent =
the
use-after-free race against concurrent discovery logins?

In drivers/target/iscsi/iscsi_target_parameters.c, iscsi_update_param_value=
()
frees param->value and reallocates it in place:

drivers/target/iscsi/iscsi_target_parameters.c:iscsi_update_param_value() {
	kfree(param->value);

	param->value =3D kstrdup(value, GFP_KERNEL);
	...
}

However, the discovery login path does not acquire
discovery_tpg->tpg_access_lock. When an initiator logs into a discovery
session, iscsi_target_locate_portal() in
drivers/target/iscsi/iscsi_target_nego.c sets conn->tpg =3D
iscsit_global->discovery_tpg and calls iscsit_access_np(np, conn->tpg), whi=
ch
only takes discovery_tpg->np_login_sem:

drivers/target/iscsi/iscsi_target_nego.c:iscsi_target_locate_portal() {
	...
		conn->tpg =3D iscsit_global->discovery_tpg;
		if (iscsit_access_np(np, conn->tpg) < 0) {
	...
}

Then iscsi_login_zero_tsih_s2() in drivers/target/iscsi/iscsi_target_login.c
calls iscsi_copy_param_list(), which reads param->value while holding only
discovery_tpg->np_login_sem:

drivers/target/iscsi/iscsi_target_login.c:iscsi_login_zero_tsih_s2() {
	...
	if (iscsi_copy_param_list(&conn->param_list,
				conn->tpg->param_list, 1) < 0) {
	...
}

drivers/target/iscsi/iscsi_target_parameters.c:iscsi_copy_param_list() {
	...
		new_param->name =3D kstrdup(param->name, GFP_KERNEL);
		new_param->value =3D kstrdup(param->value, GFP_KERNEL);
	...
}

Since iscsi_disc_enforce_discovery_auth_store() holds only tpg_access_lock =
and
discovery login holds only np_login_sem, can kfree(param->value) in
iscsi_update_param_value() still race with kstrdup(param->value, GFP_KERNEL)
in iscsi_copy_param_list()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/6a4bfcdc8e60669d95a=
bb70bdaa07b87154c9a95.camel@HansenPartnership.com?part=3D1
